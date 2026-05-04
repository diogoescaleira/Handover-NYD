# -*- coding: utf-8 -*-
#import psycopg2
from pyspark import SparkContext, SparkConf
from pyspark.sql import HiveContext
#from __init__ import sqlContext
import sys
import logging
import datetime
import os.path
import ConfigParser
import os
import subprocess
import re
import time
from pyspark.sql.functions import max as mx, last_day as ld
from datetime import date
from dateutil.relativedelta import relativedelta
now = datetime.datetime.now()
conf = SparkConf().setAppName("SRB Bail-in Data Set")
sc = SparkContext(conf=conf)
sqlContext = HiveContext(sc)
import getpass
utilizador = getpass.getuser()


#Loading Properties
propertiesFileParser = ConfigParser.SafeConfigParser(os.environ)

PROPERTIES_FILE = 'tradutores.properties'

def loadPropertiesFile(properties):
	try:
		propertiesFileParser.readfp(open(os.path.abspath('') +'/'+ properties))
	except IOError:
		print("\n Properties File "+os.path.abspath('') +'/'+ properties + " does not exist")
		sys.exit(1)
	return

loadPropertiesFile(PROPERTIES_FILE)


logging.basicConfig(format="%(asctime)s:%(levelname)s:%(filename)s:%(message)s")
LOGGER = logging.getLogger("SRB_Bail_in_Data_Set")

print('\n inicio logging \n')
LOGGER.handlers = []
LOGGER.setLevel(propertiesFileParser.get("LOGGER", "LEVEL"))
LoggerFormatter = logging.Formatter(propertiesFileParser.get("LOGGER", "FORMATTER", 1))
fileName = 'srb_bail_in_data_set.log'
LoggerFile_handler = logging.FileHandler(filename=os.path.join(fileName))
LoggerFile_handler.setFormatter(LoggerFormatter)
LOGGER.addHandler(LoggerFile_handler)
print('\n fim logging \n')


refdate = sys.argv[1]
LOGGER.info("\n refdate = {} \n".format(refdate ))

database='bu_captools_work'

def createDataframe(list, schema):
    try:
        df = sqlContext.createDataFrame(list, schema)
        LOGGER.info("Creating dataframe = {} ".format(df))
    except Exception as e:
        print('\nError creating dataframe: {}'.format(e))
        raise
    return df

# ----------------------------------------------------------------------------------------------------#
# DROP tabelas temporarias de possiveis execucoes anteriores                                          #
# ----------------------------------------------------------------------------------------------------#
# DROP tabela temporaria universo_temp
try:
	query="""   DROP TABLE IF EXISTS {}.universo_temp""".format(database)
	sqlContext.sql(query)
	LOGGER.info("\n DROP TABLE universo_temp with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while DROP TABLE universo_temp \n Query Used:\n {} \n exception: {} \n".format(query, str(e)))   

# DROP tabela temporaria date_next_int_pay_temp
try:
	query="""   DROP TABLE IF EXISTS {}.date_next_int_pay_temp""".format(database)
	sqlContext.sql(query)
	LOGGER.info("\n DROP TABLE date_next_int_pay_temp with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while DROP TABLE date_next_int_pay_temp \n Query Used:\n {} \n exception: {} \n".format(query, str(e))) 

# ----------------------------------------------------------------------------------------------------#
# CREATE tabelas temporarias                                                                          #
# ----------------------------------------------------------------------------------------------------#
# CREATE tabela temporaria universo_temp
try:
	query="""   CREATE TABLE {}.universo_temp (contract_id string)""".format(database)
	sqlContext.sql(query)
	LOGGER.info("\n CREATE TABLE universo_temp with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while CREATE on universo_temp \n Query Used:\n {} \n exception: {} \n".format(query, str(e)))

# CREATE tabela temporaria date_next_int_pay_temp
try:
	query="""   CREATE TABLE {}.date_next_int_pay_temp (contract_id string, payment_interest_date string)""".format(database)
	sqlContext.sql(query)
	LOGGER.info("\n CREATE TABLE date_next_int_pay_temp with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while CREATE on date_next_int_pay_temp \n Query Used:\n {} \n exception: {} \n".format(query, str(e)))

# ----------------------------------------------------------------------------------------------------#
# INSERT INTO tabelas temporarias                                                                          #
# ----------------------------------------------------------------------------------------------------#
# INSERT INTO tabela temporaria universo_temp
try:
	query=""" 
    INSERT INTO {}.universo_temp
	SELECT DISTINCT contract_id
	FROM
	  (SELECT fr001.contract_id
	   FROM
		 (SELECT CONCAT(cempresa,cbalcao,cnumecta,zdeposit) AS contract_id,
				 ccontab_final_ifrs
		  FROM cd_captools.fr001_univ_saldo
		  WHERE ref_date = '{}') AS fr001
	   INNER JOIN
		 (SELECT *
		  FROM cd_captools.fr802_pl_contas
		  WHERE ref_date = '{}'
			AND cod_plano = 'BST_IND'
			AND (tipo_conta='P'
				 OR (tipo_conta='C'
					 AND instrumento_financeiro='instrumentos de capital'))) AS fr802 ON fr001.ccontab_final_ifrs = fr802.conta
	   INNER JOIN
        (SELECT CONCAT(cempresa,cbalcao,cnumecta,zdeposit) AS contract_id
		  FROM cd_captools.fr004_cto 
            WHERE ref_date= '{}'
			--Segundo Pedro Mendes só devem ser considerados registos com cempresa='31' e que não tenham valor_bruto_on_p = 0 and capital_juro_on_p = 0
            AND cempresa='31'
			AND !(valor_bruto_on_p = 0
				  AND capital_juro_on_p = 0)) fr004 ON fr004.contract_id = fr001.contract_id
	   UNION ALL 
       --Estes 2 contratos nao estavam a entrar e têm de entrar segundo Pedro Mendes daí forçar a sua presença
       SELECT CONCAT(cempresa,cbalcao,cnumecta,zdeposit) AS contract_id
	   FROM cd_captools.fr001_univ_saldo
	   WHERE ref_date = '{}'
		 AND CONCAT(cempresa,cbalcao,cnumecta,zdeposit) IN ('31641600000000000PTBSQAOM0031000','31641600005800007PTCPP0AM0007000')) tx
    """.format(database,refdate,refdate,refdate,refdate)
	sqlContext.sql(query)
	LOGGER.info("\n INSERT INTO TABLE universo_temp with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while INSERT INTO universo_temp \n Query Used:\n {} \n exception: {} \n".format(query, str(e)))


# INSERT INTO tabela temporaria date_next_int_pay_temp
try:
	query=""" 
    INSERT INTO TABLE {}.date_next_int_pay_temp
	SELECT ty.contract_id,
		   ty.payment_interest_date
	FROM
	  (SELECT tx.contract_id,
			  tx.payment_interest_date,
			  (row_number() over (partition BY tx.contract_id
								  ORDER BY tx.contract_id,tx.payment_interest_date)) AS rownumb
	   FROM
		 (SELECT contract_id,
				 al029.chave_alm,
				 IF(al029.tipo_balanco='P', al029.dt_prox_liq_juros_pas, 'N/A') AS payment_interest_date
		  FROM
			(SELECT *
			 FROM {}.universo_temp) universo_temp 
	LEFT JOIN
			(SELECT chave_finrep,
					chave_alm
			 FROM
			   (SELECT concat(cempresa_fr, cbalcao_fr, cnumecta_fr, zdeposit_fr) AS chave_finrep,
					   concat(cempresa, cbalcao, cnumecta, zdeposit) AS chave_master
				FROM cd_captools.kt_chaves_finrep
				WHERE ref_date='{}' ) kt_chaves_finrep
			 LEFT JOIN
			   (SELECT concat(cempresa, cbalcao, cnumecta, zdeposit) AS chave_alm,
					   concat(cempresa_master, cbalcao_master, cnumecta_master, zdeposit_master) AS chave_master
				FROM cd_alm.kt_chaves_alm_m
				WHERE ref_date='{}') kt_chaves_alm_m ON kt_chaves_finrep.chave_master = kt_chaves_alm_m.chave_master) trad ON universo_temp.contract_id = trad.chave_finrep
		  LEFT JOIN
			(SELECT *, concat(cempresa, cbalcao, cnumecta, zdeposit) AS chave_alm
			 FROM cd_alm.al029_cnt_core_m
			 WHERE ref_date='{}') al029 ON trad.chave_alm = al029.chave_alm) tx) ty
	WHERE rownumb = 1							
    """.format(database,database,refdate,refdate,refdate)
	sqlContext.sql(query)
	LOGGER.info("\n INSERT INTO TABLE date_next_int_pay_temp with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while INSERT INTO date_next_int_pay_temp \n Query Used:\n {} \n exception: {} \n".format(query, str(e)))



# ----------------------------------------------------------------------------------------------------#
# INSERT OVERWRITE tabela final (bail_in_srb)                                                         #
# ----------------------------------------------------------------------------------------------------#
try:
	query=""" 
	INSERT OVERWRITE TABLE {}.bail_in_srb_py PARTITION (ref_date='{}')
	SELECT DISTINCT legal_entity,
					lei_code,
					id_liability,
					nature_instrument,
					governing_law,
					contract_currency,
					issuance_date,
					legal_maturity_date,
					earliest_redemption_date,
					payment_interest_date,
					outstanding_amount,
					insolvency_ranking,
					flag_same_resol_group,
					type_own_funds,
					amount_own_funds,
					amount_subord_liabil_not_own_funds,
					second_own_funds_component,
					amount_own_funds_component,
					agio_own_funds,
					carrying_amount_ifrs,
					carrying_amount_national_gaap,
					original_amount_issued_eur,
					original_amount_issued_currency,
					outstanding_principal_amount,
					accrued_interest,
					amount_writedown,
					portion_liabil_external_issuances,
					if(cast(query2.insolvency_ranking AS int) <= 8,'yes','no') AS flag_requirements_srmr,
					total_amount_fees_charges,
					country_contracting_party,
					tax_residence_contracting_party,
					name_contracting_party,
					id_contracting_party,
					counterparty_type,
					counterparty_resol_group,
					id_guarantee,
					group_counterparty_id,
					amount_guarantee,
					maximum_amount_guarantee,
					type_guarantee,
					guarantee_trigger,
					flag_guarantee_requirements_srmr,
					percentage_collateralisation,
					issuance_date_collateral,
					maturity_date_collateral,
					id_securities_collateral,
					flag_collateral_assets_resol_entity,
					location_security,
					type_collateralisation,
					value_collateral,
					type_protection_value,
					date_value_security,
					protection_valuation_approach,
					ckutulmo,
					htimest
	FROM
	  (SELECT legal_entity,
			  lei_code,
			  id_liability,
			  CASE
				  WHEN query1.nature_instrument = 'CARTOES MISTOS' THEN 'Other'
				  WHEN query1.nature_instrument = 'CONFIRMING' THEN 'Other'
				  WHEN query1.nature_instrument = 'CONTA CHEQUE FORNECEDORES' THEN 'Other'
				  WHEN query1.nature_instrument = 'CONTABILIZACAO CARTEIRA PROPRIA-TITULOS' THEN 'Other'
				  WHEN query1.nature_instrument = 'CONTAS CORRENTES - M.N.' THEN 'Other'
				  WHEN query1.nature_instrument = 'CONTAS CORRENTES - M/E' THEN 'Other'
				  WHEN query1.nature_instrument = 'CONTAS INTERNAS - M.N.' THEN 'Other'
				  WHEN query1.nature_instrument = 'CONTAS INTERNAS - MOEDA ESTRANGEIRA (NOSTROS)' THEN 'Other'
				  WHEN query1.nature_instrument = 'D.O. ESPECIAL' THEN 'Cash account/saving account'
				  WHEN query1.nature_instrument = 'DEP.ORDEM ME (OFFSHORE MADEIRA)' THEN 'Cash account/saving account'
				  WHEN query1.nature_instrument = 'DEP.ORDEM MN(OFFSHORE MADEIRA)' THEN 'Cash account/saving account'
				  WHEN query1.nature_instrument = 'DEPOSITO A ORDEM - M.N. (OFFSHORE CAYMAN)' THEN 'Cash account/saving account'
				  WHEN query1.nature_instrument = 'DEPOSITO A ORDEM - M.N.' THEN 'Cash account/saving account'
				  WHEN query1.nature_instrument = 'DEPOSITO A ORDEM - MOEDA ESTRANGEIRA OFFSHORE' THEN 'Cash account/saving account'
				  WHEN query1.nature_instrument = 'DEPOSITO A ORDEM - MOEDA ESTRANGEIRA' THEN 'Cash account/saving account'
				  WHEN query1.nature_instrument = 'DEPOSITO A PRAZO EM MOEDA NACIONAL' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'DEPOSITOS A PRAZO - M.E.' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'DEPOSITOS A PRAZO - M.N. (OFFSHORE)' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'DEPOSITOS A PRAZO - POUPANCA REFORMA' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'DEPOSITOS A PRAZO - PRODUTOS ESTRUTURADOS' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'DEPOSITOS A PRAZO EM MOEDA ESTRANGEIRA' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'DEPOSITOS A PRAZO EM MOEDA NACIONAL' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'DEPOSITOS DE POUPANCA' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'DEVEDORES / CREDORES DIVERSOS' THEN 'Other'
				  WHEN query1.nature_instrument = 'EMPRESTIMOS' THEN 'Other'
				  WHEN query1.nature_instrument = 'ESTRANGEIRO-AVALES E GARANTIAS' THEN 'Other'
				  WHEN query1.nature_instrument = 'FACTORING' THEN 'Other'
				  WHEN query1.nature_instrument = 'Obrigacao Hipotecaria' THEN 'Registered Bond'
				  WHEN query1.nature_instrument = 'Obrigacao Senior' THEN 'Registered Bond'
				  WHEN query1.nature_instrument = 'Obrigacao Subordinada' THEN 'Registered Bond'
				  WHEN query1.nature_instrument = 'PRODUTO GESTAO BALCAO' THEN 'Other'
				  WHEN query1.nature_instrument = 'PRODUTOS ESTRANGEIRO - CREDITOS DOCUMENTARIOS IMPORTACAO' THEN 'Other'
				  WHEN query1.nature_instrument = 'RESERVADO PARA NOVA APLICACAO DE TESOURARIA' THEN 'Borrower Note Loan'
				  WHEN query1.nature_instrument = 'SANTANDER - PRODUTOS TESOURARIA' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'SUPER SATISFACAO RECARREGAVEL' THEN 'Term deposit'
				  WHEN query1.nature_instrument = 'Titularizacao Sintetica' THEN 'Registered Bond'
				  WHEN query1.nature_instrument = 'Titularizacao' THEN 'Registered Bond'
				  WHEN query1.nature_instrument = 'Acao Ordinaria' THEN 'Title of ownership'
				  WHEN query1.nature_instrument = 'Acao Preferencial' THEN 'Title of ownership'
				  WHEN query1.nature_instrument = 'Emprestimo Subordinado' THEN 'Registered Bond'
				  WHEN query1.nature_instrument = 'Instrumento Fundos Proprios Adicionais Nivel 1 (AT1)' THEN 'Registered Bond'
				  WHEN query1.nature_instrument = 'Prestacao Suplementar' THEN 'Title of ownership'
				  WHEN query1.nature_instrument = 'Suprimento' THEN 'Title of ownership'
				  WHEN query1.nature_instrument IS NULL THEN 'MISS'
				  ELSE query1.nature_instrument
			  END AS nature_instrument,
			  governing_law,
			  contract_currency,
			  issuance_date,
			  legal_maturity_date,
			  earliest_redemption_date,
			  payment_interest_date,
			  outstanding_amount,
			  CASE
				  WHEN query1.contrato_ct610_aux IS NOT NULL THEN query1.rank_insolv_aux1
				  WHEN query1.nature_instrument = 'CARTOES MISTOS' THEN '14'
				  WHEN query1.nature_instrument = 'CONFIRMING' THEN '9'
				  WHEN query1.nature_instrument = 'CONTA CHEQUE FORNECEDORES' THEN '14'
				  WHEN query1.nature_instrument = 'CONTABILIZACAO CARTEIRA PROPRIA-TITULOS' THEN '9'
				  WHEN query1.nature_instrument = 'CONTAS CORRENTES - M.N.' THEN '9'
				  WHEN query1.nature_instrument = 'CONTAS CORRENTES - M/E' THEN '9'
				  WHEN query1.nature_instrument = 'CONTAS INTERNAS - M.N.' THEN '9'
				  WHEN query1.nature_instrument = 'CONTAS INTERNAS - MOEDA ESTRANGEIRA (NOSTROS)' THEN '9'
				  WHEN query1.nature_instrument = 'DEVEDORES / CREDORES DIVERSOS' THEN '14'
				  WHEN query1.nature_instrument = 'EMPRESTIMOS' THEN '9'
				  WHEN query1.nature_instrument = 'ESTRANGEIRO-AVALES E GARANTIAS' THEN '9'
				  WHEN query1.nature_instrument = 'FACTORING' THEN '9'
				  WHEN query1.nature_instrument IS NULL THEN '14'
				  WHEN query1.nature_instrument = 'PRODUTO GESTAO BALCAO' THEN '14'
				  WHEN query1.nature_instrument = 'PRODUTOS ESTRANGEIRO - CREDITOS DOCUMENTARIOS IMPORTACAO' THEN '9'
				  WHEN query1.nature_instrument = 'RESERVADO PARA NOVA APLICACAO DE TESOURARIA' THEN '20'
				  WHEN query1.contrato_fg001_aux2 IS NOT NULL
					   AND query1.mtot_nao_coberto_por_depositante_aux3 > 0
					   AND (query1.pme_aux4 IN (1,2,3)
							OR query1.counterparty_type = 'Households (1)') THEN '14;13'
				  WHEN query1.contrato_fg001_aux2 IS NOT NULL
					   AND query1.mtot_nao_coberto_por_depositante_aux3 > 0
					   AND !(query1.pme_aux4 IN (1,2,3)
							 OR query1.counterparty_type = 'Households (1)') THEN '14;12'
				  WHEN query1.contrato_fg001_aux2 IS NOT NULL THEN '14'
				  ELSE 'MISS'
			  END AS insolvency_ranking,
			  flag_same_resol_group,
			  type_own_funds,
			  amount_own_funds,
			  amount_subord_liabil_not_own_funds,
			  second_own_funds_component,
			  amount_own_funds_component,
			  agio_own_funds,
			  carrying_amount_ifrs,
			  carrying_amount_national_gaap,
			  original_amount_issued_eur,
			  original_amount_issued_currency, 
     -- 2 contratos que Pedro Mendes pediu para se incluir no universo de contratos bail-in
	 CASE
		 WHEN query1.id_liability IN ('31641600000000000PTBSQAOM0031000','31641600005800007PTCPP0AM0007000') THEN query1.outstanding_amount
		 ELSE query1.outstanding_amount - query1.accrued_interest
	 END AS outstanding_principal_amount,
	 accrued_interest,
	 amount_writedown,
	 portion_liabil_external_issuances,
	 total_amount_fees_charges,
	 country_contracting_party,
	 tax_residence_contracting_party,
	 name_contracting_party,
	 id_contracting_party,
	 counterparty_type,
	 counterparty_resol_group,
	 id_guarantee,
	 group_counterparty_id,
	 amount_guarantee,
	 maximum_amount_guarantee,
	 type_guarantee,
	 guarantee_trigger,
	 flag_guarantee_requirements_srmr,
	 percentage_collateralisation,
	 issuance_date_collateral,
	 maturity_date_collateral,
	 id_securities_collateral,
	 flag_collateral_assets_resol_entity,
	 location_security,
	 type_collateralisation,
	 value_collateral,
	 type_protection_value,
	 date_value_security,
	 protection_valuation_approach,
	 ckutulmo,
	 htimest
	   FROM
		 (SELECT 'BANCO SANTANDER TOTTA, S.A' AS legal_entity,
				 '549300URJH9VSI58CS32' AS lei_code,
				 temp.contract_id AS id_liability,
				 if(fr004.cproduto = '0V0','FACTORING',coalesce(ct610.tipo_titulo,tat91_023.tayd91c0_gelemtab)) AS nature_instrument,
				 coalesce(tat91_015.tayd91c0_nelemc09, 'PT') AS governing_law,
				 coalesce(tat91_206.TAYD91C0_NELEMC01, 'EUR') AS contract_currency,
				 CASE
					 WHEN trim(coalesce(concat(substr(ct610.dt_emissao,7,4),substr(ct610.dt_emissao,3,4),substr(ct610.dt_emissao,1,2)),fr004.data_abertura)) = '' THEN 'MISS'
					 ELSE coalesce(concat(substr(ct610.dt_emissao,7,4),substr(ct610.dt_emissao,3,4),substr(ct610.dt_emissao,1,2)),fr004.data_abertura)
				 END AS issuance_date,
				 CASE
					 WHEN trim(coalesce(concat(substr(ct610.dt_vencim,7,4),substr(ct610.dt_vencim,3,4),substr(ct610.dt_vencim,1,2)),fr004.data_vencimento)) = '' THEN 'MISS'
					 ELSE coalesce(concat(substr(ct610.dt_vencim,7,4),substr(ct610.dt_vencim,3,4),substr(ct610.dt_vencim,1,2)),fr004.data_vencimento)
				 END AS legal_maturity_date,
				 coalesce(concat(substr(ct610.dt_prim_amrt_ant_inv,7,4),substr(ct610.dt_prim_amrt_ant_inv,3,4),substr(ct610.dt_prim_amrt_ant_inv,1,2)),'N/A') AS earliest_redemption_date,
				 CASE
					 WHEN trim(date_next_int_pay_temp.payment_interest_date) = '' THEN 'MISS'
					 ELSE coalesce(date_next_int_pay_temp.payment_interest_date,'MISS')
				 END AS payment_interest_date, -- 2 contratos que Pedro Mendes pediu para se incluir no universo de contratos bail-in
	 CASE
		 WHEN TEMP.contract_id IN ('31641600000000000PTBSQAOM0031000','31641600005800007PTCPP0AM0007000') THEN fr001_2regs.msaldo_final
		 ELSE coalesce(fr004.valor_bruto_on_p,0)
	 END AS outstanding_amount,
	 ct610.contrato_ct610 AS contrato_ct610_aux,
	 ct610.rank_insolv AS rank_insolv_aux1,
	 fg001.contrato_fg001 AS contrato_fg001_aux2,
	 fg001.mtot_nao_coberto_por_depositante AS mtot_nao_coberto_por_depositante_aux3,
	 busme.cod_empr_pme AS pme_aux4, IF (coalesce(ct610.zcliente_investidor,fr004.zcliente) IN ('0000238954',
																								'6511000505',
																								'7400416271',
																								'7400416353',
																								'7400416520',
																								'7400416611',
																								'7400416763',
																								'7400507283',
																								'7400701625',
																								'7401474691',
																								'7401536276',
																								'8037849269',
																								'8043363752',
																								'8044173594',
																								'8046250676',
																								'8046296743',
																								'8046334916',
																								'9001925092'),'yes',
																											  'no') AS flag_same_resol_group,
										coalesce(ct610.eleg_fund_prop,'N/A') AS type_own_funds,
										coalesce(ct610.mon_fund_prop,0) AS amount_own_funds,
										0 AS amount_subord_liabil_not_own_funds,
										'N/A' AS second_own_funds_component,
										0 AS amount_own_funds_component,
										0 AS agio_own_funds, -- 2 contratos que Pedro Mendes pediu para se incluir no universo de contratos bail-in
	 CASE
		 WHEN TEMP.contract_id IN ('31641600000000000PTBSQAOM0031000','31641600005800007PTCPP0AM0007000') THEN fr001_2regs.msaldo_final
		 ELSE coalesce(fr004.valor_bruto_on_p,99999999999.99)
	 END AS carrying_amount_ifrs,
	 CASE
		 WHEN TEMP.contract_id IN ('31641600000000000PTBSQAOM0031000','31641600005800007PTCPP0AM0007000') THEN fr001_2regs.msaldo_final
		 ELSE coalesce(fr004.valor_bruto_on_p,99999999999.99)
	 END AS carrying_amount_national_gaap,
	 coalesce(ct610.nom_tot_inic,0) AS original_amount_issued_eur,
	 0 AS original_amount_issued_currency,
	 coalesce(accrued_interest,0) AS accrued_interest, -- 2 contratos que Pedro Mendes pediu para se incluir no universo de contratos bail-in
	 CASE
		 WHEN TEMP.contract_id IN ('31641600000000000PTBSQAOM0031000','31641600005800007PTCPP0AM0007000') THEN fr001_2regs.msaldo_final
		 ELSE if(ct610.rank_insolv IN ('1','2','3','8'),fr004.valor_bruto_on_p,0)
	 END AS amount_writedown,
	 0 AS portion_liabil_external_issuances,
	 coalesce(total_amount_fees_charges,0) AS total_amount_fees_charges,
	 coalesce(tat91_015_pais.tayd91c0_nelemc09,'MISS') AS country_contracting_party,
	 coalesce(tat91_015_pais.tayd91c0_nelemc09,'MISS') AS tax_residence_contracting_party,
	 coalesce(IF(ct003.itip_cli= 'F','Natural Customer',ct003.gcliente),'MISS') AS name_contracting_party,
	 coalesce(IF((IF(ct003.itip_cli= 'F','Natural Customer',ct003.clei)) = '#',coalesce(ct610.zcliente_investidor,ct003.zcliente),IF(ct003.itip_cli= 'F','Natural Customer',ct003.clei)),'MISS') AS id_contracting_party,
	 CASE
		 WHEN ct003.contraparte = 'particulares' THEN 'Households (1)'
		 WHEN ct003.contraparte = 'outras empresas nao financeiras' THEN IF(busme.cod_empr_pme IN (1,2,3),'Non-financial corporations (SMEs) (2)','Non-financial corporations (non-SMEs) (3)')
		 WHEN ct003.contraparte = 'instituicoes de credito' THEN 'Credit institutions (4)'
		 WHEN ct003.contraparte = 'outras instituicoes financeiras ' THEN 'Other financial corporations (5)'
		 WHEN ct003.contraparte = 'bancos centrais' THEN 'General governments & Central banks (6)'
		 WHEN ct003.contraparte = 'setor publico' THEN 'General governments & Central banks (6)'
	 END AS counterparty_type,
	 coalesce(IF(clientes_intragrupo.zcliente = coalesce(ct610.zcliente_investidor,fr004.zcliente),IF(clientes_intragrupo.zcliente IN ('0000238954', '6511000505', '7400416271', '7400416353', '7400416520', '7400416611', '7400416763', '7400507283', '7400701625', '7401474691', '7401536276', '8037849269', '8043363752', '8044173594', '8046250676', '8046296743', '8046334916', '9001925092'), 'Intragroup but not intra-resolution group (2)','Intragroup and intra-resolution group (1)'), 'No'),'MISS') AS counterparty_resol_group,
	 'N/A' AS id_guarantee,
	 'N/A' AS group_counterparty_id,
	 0 AS amount_guarantee,
	 0 AS maximum_amount_guarantee,
	 'N/A' AS type_guarantee,
	 'N/A' AS guarantee_trigger,
	 'N/A' AS flag_guarantee_requirements_srmr,
	 coalesce((((al602.haircut_tit / 100) + 1) * 100),0) AS percentage_collateralisation,
	 coalesce(al602.dt_inicio,'N/A') AS issuance_date_collateral,
	 coalesce(al602.dt_fim,'N/A') AS maturity_date_collateral,
	 coalesce(concat(al602.cempresa_tit,al602.cbalcao_tit,al602.cnumecta_tit,zdeposit_tit),'N/A') AS id_securities_collateral,
	 coalesce(If(concat(al602.cempresa_tit,al602.cbalcao_tit,al602.cnumecta_tit,zdeposit_tit) != 'NULL', 'Yes', 'No'),'MISS') AS flag_collateral_assets_resol_entity,
	 coalesce(If(concat(al602.cempresa_tit,al602.cbalcao_tit,al602.cnumecta_tit,zdeposit_tit) != 'NULL', 'PT', 'N/A'),'MISS') AS location_security,
	 coalesce(If(concat(al602.cempresa_tit,al602.cbalcao_tit,al602.cnumecta_tit,zdeposit_tit) != 'NULL', 'securities', 'N/A'),'MISS') AS type_collateralisation,
	 cast(If(concat(al602.cempresa_tit,al602.cbalcao_tit,al602.cnumecta_tit,zdeposit_tit) != 'NULL', al602.mon_nom_atu_tit, 0) AS STRING) AS value_collateral,
	 coalesce(If(concat(al602.cempresa_tit,al602.cbalcao_tit,al602.cnumecta_tit,zdeposit_tit) != 'NULL', 'Market value (3)', 'N/A'),'MISS') AS type_protection_value,
	 coalesce(If(concat(al602.cempresa_tit,al602.cbalcao_tit,al602.cnumecta_tit,zdeposit_tit) != 'NULL', substr(cast(date_sub(al602.ref_date,30) AS STRING),1,10), 'N/A'),'MISS') AS date_value_security,
	 coalesce(If(concat(al602.cempresa_tit,al602.cbalcao_tit,al602.cnumecta_tit,zdeposit_tit) != 'NULL', 'Mark-to-market valuation (1)', 'N/A'),'MISS') AS protection_valuation_approach,
	 '{}' AS ckutulmo,
	 cast(current_timestamp() AS STRING) AS htimest
		  FROM {}.universo_temp TEMP
		  LEFT JOIN
			(SELECT *
			 FROM cd_captools.fr004_cto
			 WHERE ref_date='{}') fr004 ON temp.contract_id = concat(fr004.cempresa,fr004.cbalcao,fr004.cnumecta,fr004.zdeposit)
		  LEFT JOIN
			(SELECT *,
					concat(cempresa,cbalcao,cnumecta,zdeposit) AS contrato_ct610
			 FROM cd_captools.ct610_titulos
			 WHERE ref_date='{}'
			   AND cempresa = '31') ct610 ON concat(ct610.cempresa,ct610.cbalcao,ct610.cnumecta,ct610.zdeposit) = concat(fr004.cempresa,fr004.cbalcao,fr004.cnumecta,fr004.zdeposit)
		  LEFT JOIN
			(SELECT *
			 FROM cd_captools.ct003_univ_cli
			 WHERE ref_date='{}') ct003 ON ct003.zcliente = coalesce(substring(ct610.zcliente_investidor,1,10),fr004.zcliente) 
	
		  LEFT JOIN 
          -- Faz-se max(data_date_part) para se obter os dados mais recentes da tabela
			(SELECT t1.*
			 FROM
			   (SELECT *
				FROM cd_estruturais.tat91_tabelas
				WHERE tayd91c0_ctabela='015') t1
			 INNER JOIN
			   (SELECT max(data_date_part) AS data_date_part
				FROM cd_estruturais.tat91_tabelas
				WHERE tayd91c0_ctabela='015') t2 ON t1.data_date_part = t2.data_date_part) tat91_015 ON ct610.lei_aplicavel = tat91_015.tayd91c0_celemtab
		  LEFT JOIN 
          -- Faz-se max(data_date_part) para se obter os dados mais recentes da tabela
			(SELECT t1.*
			 FROM
			   (SELECT *
				FROM cd_estruturais.tat91_tabelas
				WHERE tayd91c0_ctabela='015') t1
			 INNER JOIN
			   (SELECT max(data_date_part) AS data_date_part
				FROM cd_estruturais.tat91_tabelas
				WHERE tayd91c0_ctabela='015') t2 ON t1.data_date_part = t2.data_date_part)tat91_015_pais ON tat91_015_pais.tayd91c0_celemtab = ct003.cpais_residencia
		  LEFT JOIN 
          -- Faz-se max(data_date_part) para se obter os dados mais recentes da tabela
			(SELECT t1.*
			 FROM
			   (SELECT *
				FROM cd_estruturais.tat91_tabelas
				WHERE tayd91c0_ctabela='023') t1
			 INNER JOIN
			   (SELECT max(data_date_part) AS data_date_part
				FROM cd_estruturais.tat91_tabelas
				WHERE tayd91c0_ctabela='023') t2 ON t1.data_date_part = t2.data_date_part) tat91_023 ON fr004.cproduto = tat91_023.tayd91c0_celemtab
		  LEFT JOIN 
          -- Faz-se max(data_date_part) para se obter os dados mais recentes da tabela
			(SELECT t1.*
			 FROM
			   (SELECT *
				FROM cd_estruturais.tat91_tabelas
				WHERE tayd91c0_ctabela='206') t1
			 INNER JOIN
			   (SELECT max(data_date_part) AS data_date_part
				FROM cd_estruturais.tat91_tabelas
				WHERE tayd91c0_ctabela='206') t2 ON t1.data_date_part = t2.data_date_part) tat91_206 ON tat91_206.tayd91c0_celemtab = coalesce(ct610.cmoeda,fr004.cmoeda1)
		  LEFT JOIN
			(SELECT *
			 FROM cd_alm.al602_repos_alm
			 WHERE ref_date='{}') al602 ON concat(fr004.cempresa,fr004.cbalcao,fr004.cnumecta,fr004.zdeposit)= concat(al602.cempresa,al602.cbalcao,al602.cnumecta,al602.zdeposit)
		  LEFT JOIN
			(SELECT *
			 FROM cd_captools.clientes_intragrupo
			 WHERE data_date_part='{}') clientes_intragrupo ON clientes_intragrupo.zcliente = coalesce(ct610.zcliente_investidor,fr004.zcliente)
		  LEFT JOIN
			(SELECT *
			 FROM business_sme2003361.out_sme_2003_361
			 WHERE ref_date='{}') busme ON busme.zcliente = coalesce(ct610.zcliente_investidor,fr004.zcliente)
		  LEFT JOIN
			(SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS contrato_fg001,
					sum(mtot_nao_coberto_por_depositante) AS mtot_nao_coberto_por_depositante
			 FROM cd_alm.fg001_fgd
			 WHERE ref_date='{}'
			   AND calinea = '#'
			   AND flag_ativo = '1'
			 GROUP BY cempresa,
					  cbalcao,
					  cnumecta,
					  zdeposit) fg001 ON contrato_fg001 = concat(fr004.cempresa,fr004.cbalcao,fr004.cnumecta,fr004.zdeposit)
		  LEFT JOIN
			(SELECT *
			 FROM {}.date_next_int_pay_temp) date_next_int_pay_temp ON date_next_int_pay_temp.contract_id = temp.contract_id
		  LEFT JOIN
			(SELECT CONCAT(cempresa,cbalcao,cnumecta,zdeposit) AS contract_id,
					NVL(SUM(MSALDO_FINAL), 0) AS accrued_interest
			 FROM
			   (SELECT *
				FROM cd_captools.fr001_univ_saldo
				WHERE ref_date ='{}' ) AS fr001
			 INNER JOIN
			   (SELECT *
				FROM cd_captools.fr802_pl_contas
				WHERE ref_date = '{}'
				  AND cod_plano = 'BST_IND'
				  AND COMPOSICAO_VALOR = 'juros/encargos a pagar'
				  AND (tipo_conta='P'
					   OR (tipo_conta='C'
						   AND instrumento_financeiro='instrumentos de capital')) ) AS fr802 ON fr001.ccontab_final_ifrs = fr802.conta
			 GROUP BY cempresa,
					  cbalcao,
					  cnumecta,
					  zdeposit) t_accrued_interest ON t_accrued_interest.contract_id = temp.contract_id
		  LEFT JOIN
			(SELECT CONCAT(cempresa,cbalcao,cnumecta,zdeposit) AS contract_id,
					NVL(SUM(MSALDO_FINAL), 0) AS total_amount_fees_charges
			 FROM
			   (SELECT *
				FROM cd_captools.fr001_univ_saldo
				WHERE ref_date ='{}' ) AS fr001
			 INNER JOIN
			   (SELECT *
				FROM cd_captools.fr802_pl_contas
				WHERE ref_date = '{}'
				  AND cod_plano = 'BST_IND'
				  AND (tipo_conta='P'
					   OR (tipo_conta='C'
						   AND instrumento_financeiro='instrumentos de capital'))
				  AND COMPOSICAO_VALOR = 'despesas/comissoes com encargo diferido associadas ao custo amortizado' ) AS fr802 ON fr001.ccontab_final_ifrs = fr802.conta
			 GROUP BY cempresa,
					  cbalcao,
					  cnumecta,
					  zdeposit) t_total_amount_fees_charges ON t_total_amount_fees_charges.contract_id = temp.contract_id
		  LEFT JOIN
			(SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS contrato,
					sum(msaldo_final) AS msaldo_final
			 FROM cd_captools.fr001_univ_saldo
			 WHERE ref_date ='{}'
			 GROUP BY cempresa,
					  cbalcao,
					  cnumecta,
					  zdeposit) AS fr001_2regs ON fr001_2regs.contrato = TEMP.contract_id) AS query1) AS query2		
    """.format(database,refdate,utilizador,database,refdate,refdate,refdate,refdate,refdate,refdate,refdate,database,refdate,refdate,refdate,refdate,refdate)
	sqlContext.sql(query)
	LOGGER.info("\n INSERT OVERWRITE TABLE bail_in_srb_py with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while INSERT OVERWRITE TABLE bail_in_srb_py   \n Query Used:\n {} \n exception: {} \n".format(query, str(e)))


# ----------------------------------------------------------------------------------------------------#
# DROP tabelas temporarias                                                                            #
# ----------------------------------------------------------------------------------------------------#
# DROP tabela temporaria universo_temp
try:
	query="""   DROP TABLE IF EXISTS {}.universo_temp""".format(database)
	sqlContext.sql(query)
	LOGGER.info("\n DROP TABLE universo_temp with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while DROP TABLE universo_temp \n Query Used:\n {} \n exception: {} \n".format(query, str(e)))   

# DROP tabela temporaria date_next_int_pay_temp
try:
	query="""   DROP TABLE IF EXISTS {}.date_next_int_pay_temp""".format(database)
	sqlContext.sql(query)
	LOGGER.info("\n DROP TABLE date_next_int_pay_temp with success \n Query Used:\n {} \n".format(query))
except Exception, e:
	LOGGER.error("\n error while DROP TABLE date_next_int_pay_temp \n Query Used:\n {} \n exception: {} \n".format(query, str(e))) 


# ----------------------------------------------------------------------------------------------------#
# Call do ficheiro Shell que:  									      #
# 1)Executa o invalidate metadata da tabela                                                           #
# 2)Executa a exportacao da tabela para ficheiro .csv                                                 #
# 3)Executa o zip do ficheiro .csv                                                                    #
# ----------------------------------------------------------------------------------------------------#

bash_string = 'bash Unload_bail_in_srb.sh {} '.format(refdate)
LOGGER.info(" \n bash comand = '{}'\n".format(bash_string))

retcode = os.system(bash_string)
#retcode = subprocess.call([bash_string], shell=True)
#retcode = subprocess.run(['/home/e858309/bash Unload_bail_in_srb.sh'], shell=True)

LOGGER.info(" \n retcode = '{}'\n".format(retcode))





