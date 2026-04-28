
/*===================================================================================================================================================
													  
												SIMULAÇÃO MARCAÇÃO VERDE - 1º MARCAÇÃO
															NEYOND 2024 - V.F.
																
 ===================================================================================================================================================*/
  
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 1A. CRIAÇÃO DA TABELA AUXILIAR COM TODAS AS MÉTRICAS NECESSÁRIAS PARA A MARCAÇÃO VERDE - PARTE 1 
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- DEZ24: Inserted 10.131.966  row(s)
      
DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_DEZ24;
CREATE TABLE BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_DEZ24 AS

SELECT *
FROM 

	-- 1º Cruzamento: Obter o Universo Base + campos da base (4.1.3.2.)
	--> DEZ24 6.287.849 registos 
    (
    SELECT zcliente,cempresa,cbalcao,cnumecta,zdeposit,flag_project_finance,cproduto,csubprod,dabertur,concat(cproduto,csubprod) AS PRDT_SPRDT
        ,concat(cempresa,cbalcao,cnumecta,zdeposit) as chave_cto
        ,concat(cempresa,cbalcao,cnumecta) as chave_cto_2
    FROM cd_captools.ct085_univ_cto_d
    WHERE ref_date='${ref_date}'
    )BASE 
LEFT JOIN 
	-- 2º Cruzamento: Cruzamento com a CT084 para obter a contraparte (4.1.3.1.)
	--> DEZ24 6.287.849 registos 
    (
    SELECT DISTINCT zcliente as zcliente_1,contraparte
    FROM cd_captools.ct084_univ_cli_d
    WHERE ref_date='${ref_date}'
    )F1 ON BASE.zcliente=F1.zcliente_1
LEFT JOIN 
	-- 3º Cruzamento: Cruzamento com a NFIN (4.1.3.3.)
	--> DEZ24 6.287.849 registos 
    (
    SELECT zcliente as zcliente_3,flg_csrd
    FROM bu_esg_work.modesg_out_empr_info_nfin
    WHERE ref_date='${ref_date}'
    )F2 ON BASE.zcliente=F2.zcliente_3
LEFT JOIN 
	-- 4º Cruzamento: Cruzamento com a EPT01 (4.1.3.5.)
	--> DEZ24 6.287.849 registos 
	(
	SELECT concat(cempresa,ckbalcao,cknumcta) as chave_cto_5, cfamilia
	FROM cd_emprestimos.ept01_contas
	where data_date_part='${ref_date}'
    )F3 ON BASE.chave_cto_2=F3.chave_cto_5

LEFT JOIN
	-- 5º Cruzamento: Cruzamento com O Modelo Verde - Riscos por Cliente (4.1.3.10.)
	--> DEZ24 6.287.849 registos 
    (
    SELECT zcliente as zcliente_10,flg_rsc_fsc_agd as flg_rsc_fsc_agd_cli,flg_rsc_fsc_crnc as flg_rsc_fsc_crnc_cli
    FROM bu_esg_work.modesg_out_empr_info_nfin
    WHERE ref_date='${ref_date}'
    )F4 ON BASE.zcliente=F4.zcliente_10
LEFT JOIN 
	-- 6º Cruzamento: Traçabilidade Responsabilidade Processo - Bem Imóvel + Obter finalidade (4.1.3.6.)
	--> DEZ24 6.288.670 registos 
    (
    SELECT concat(bank_id,branch_code,contract_id,reference_code) AS CHAVE_RESP_6, 
        concat(process_bank_id,process_branch_code,process_account_id,process_reference_code) AS CHAVE_PROC_6
    FROM bu_esg_work.responsibility_process_rel
    WHERE data_date_part='${ref_date}'
    )F5 ON BASE.CHAVE_CTO=F5.CHAVE_RESP_6
LEFT JOIN 
	-- 7º Cruzamento: Traçabilidade Processo - Bem Imóvel
	--> DEZ24 6.292.981 registos 
    (
    SELECT concat(process_bank_id,process_branch_code,process_account_id,process_reference_code) AS CHAVE_PROC_7
        ,concat(property_bank_id,property_branch_code,property_contract_id,property_reference_code) AS CHAVE_BEM_7
        ,collateral_property_ind,financed_property_ind
    FROM bu_esg_work.process_property_rel 
    WHERE data_date_part='${ref_date}'
        AND (financed_property_ind=1 OR collateral_property_ind=1)
    )F6 ON F5.CHAVE_PROC_6=F6.CHAVE_PROC_7
LEFT JOIN 
	-- 8º Cruzamento: Cruzamento com a tabela de certificados (4.1.3.8.) 
	--> DEZ24 6.292.981 registos 
    (
    SELECT concat(property_bank_id,property_branch_code,property_contract_id,property_reference_code) AS CHAVE_BEM_8,EPC,quality_score,primary_energy_req_value
    FROM bu_esg_work.property_energy_certificate
    WHERE data_date_part='${ref_date}'
    )F7 ON F6.CHAVE_BEM_7=F7.CHAVE_BEM_8
LEFT JOIN 
	-- 9º Cruzamento: Cruzamento com a tabela de imóveis (4.1.3.9.) 
	--> DEZ24 6.292.981 registos 
    (
    SELECT concat(property_bank_id,property_branch_code,property_contract_id,property_reference_code) AS CHAVE_BEM_9,construction_year, property_purpose_code, net_floor_area
    FROM bu_esg_work.property
    WHERE data_date_part='${ref_date}'
    )F8 ON F6.CHAVE_BEM_7=F8.CHAVE_BEM_9
LEFT JOIN 
	-- 10º Cruzamento: Cruzamento com a tabela de imóveis (4.1.3.9.) para obter riscos
	--> DEZ24 6.292.981 registos 
    (
    SELECT DISTINCT concat(CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM) AS CHAVE_BEM_RS,flg_rsc_fsc_agd,flg_rsc_fsc_crnc
    FROM bu_esg_work.modesg_out_bens_imoveis
    WHERE ref_date='${ref_date}'
    )F9 ON F6.CHAVE_BEM_7=F9.CHAVE_BEM_RS and f6.collateral_property_ind=1
LEFT JOIN 
	-- 11º Cruzamento: Traçabilidade Responsabilidade Processo - Bem Móvel
	--> DEZ24 6.348.711 registos 
    (
    SELECT concat(cempresp,ckbalres,ckctares,ckrefresp) AS CHAVE_RESP_10,
        CONCAT(cempresa,ckbalcao,cknumcta,comp_id_gar) AS CHAVE_PROC_10
    FROM cd_garantias.gt001_trz_rsp_gt
    WHERE ref_date='${ref_date}'
    )F10 ON BASE.CHAVE_CTO=F10.CHAVE_RESP_10
LEFT JOIN 
	-- 12º Cruzamento: Traçabilidade Processo - Bem Móvel
	--> DEZ24 6.348.711 registos 
    (
    SELECT CONCAT(cempresa,ckbalcao,cknumcta,comp_id_gar) AS CHAVE_PROC_11
        ,concat(cempbem,ckbalbem,ckctabem,ckrefbem) AS CHAVE_BEM_11
    FROM cd_garantias.gt012_trz_gt_mob
    WHERE ref_date='${ref_date}'
    )F11 ON F10.CHAVE_PROC_10=F11.CHAVE_PROC_11
LEFT JOIN 
	-- 13º Cruzamento: Cruzamento com a GT013 (4.1.3.4.)
	--> DEZ24 6.348.711 registos
    (
    SELECT concat(cempbem,ckbalbem,ckctabem,ckrefbem) AS CHAVE_BEM_12
        ,co2,CAST(co2 AS DECIMAL(18,6)) AS CO2_MOD,tipo_eqp,cgarant_bem,combustivel
    FROM cd_garantias.gt013_bens_mob
    WHERE ref_date='${ref_date}'
    )F12 ON F11.CHAVE_BEM_11=F12.CHAVE_BEM_12
LEFT JOIN 
	-- 14º Cruzamento: Tradutor Master Mis 
	--> DEZ24 8.247.055 registos 
    (
    SELECT concat(cempcta,ckbalcao,cknumcta,zdeposit_mis) AS CHAVE_MIS_13
        ,concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER_13
    FROM cd_captools.kt_chaves_mis
    WHERE ref_date='${ref_date}'
    )F13 ON BASE.CHAVE_CTO=F13.CHAVE_MASTER_13
LEFT JOIN 
	-- 15º Cruzamento: Cruzamento com a 207 (4.1.3.7.) 
	--> DEZ24 10.127.965 registos 
    (
    SELECT DISTINCT concat(cempcta,ckbalcao,cknumcta,zdeposit) AS CHAVE_207,ckmetamis,ckprodmi,cmetanseg
    FROM cd_captools.ct207_rent_over
    WHERE ref_date='${ref_date}'
    )F14 ON F13.CHAVE_MIS_13=F14.CHAVE_207
LEFT JOIN 
	-- 16º Cruzamento: Obter finalidade (4.1.3.6.)
	--> DEZ24 10.128.843 registos 
    (
    SELECT distinct concat(bank_id,branch_code,contract_id,reference_code) AS CHAVE_RESP_16, purpose_code
    FROM bu_esg_work.responsibility_process_rel
    WHERE data_date_part='${ref_date}'
    )F15 ON BASE.CHAVE_CTO=F15.CHAVE_RESP_16
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 1B. CRIAÇÃO DA TABELA FINAL COM TODAS AS MÉTRICAS NECESSÁRIAS PARA A MARCAÇÃO VERDE - PARTE 2
--------------------------------------------------------------------------------------------------------------------------------------------------

  	-- DEZ24: Inserted 10.131.966  row(s)
   
DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_DEZ24;
CREATE TABLE BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_DEZ24 AS

SELECT F1.*
    ,CASE
        WHEN F2.CHAVE_CTO IS NULL THEN 0 
        ELSE F2.NUM_BENS
    END AS NUM_BENS_IMO
    ,CASE
        WHEN F3.CHAVE_CTO IS NULL THEN 0 
        ELSE F3.NUM_BENS
    END AS NUM_BENS_MOV
    ,CASE
        WHEN F4.CHAVE_CTO IS NULL THEN 0 
        ELSE F4.NUM_CHAVES
    END AS NUM_CHAVES_207
    ,CASE
        WHEN F5.CHAVE_CTO IS NULL THEN 0 
        ELSE F5.NUM_CHAVES
    END AS NUM_CHAVES_TRA
FROM 
    (
    SELECT *
		,CASE 
			WHEN CHAVE_BEM_RS IS NOT NULL and flg_rsc_fsc_agd is not null THEN flg_rsc_fsc_agd
			ELSE flg_rsc_fsc_agd_cli
		END AS flg_rsc_fsc_agd_TRAT
		,CASE 
			WHEN CHAVE_BEM_RS IS NOT NULL and flg_rsc_fsc_CRNC is not NULL THEN flg_rsc_fsc_CRNC
			ELSE flg_rsc_fsc_CRNC_cli
		END AS flg_rsc_fsc_CRNC_TRAT
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_DEZ24
    )F1
LEFT JOIN 
    (
    SELECT CHAVE_CTO,count(DISTINCT CHAVE_BEM_7) AS NUM_BENS
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_DEZ24
    WHERE CHAVE_BEM_7 IS NOT NULL 
    GROUP BY 1 
    )F2 ON F1.CHAVE_CTO=F2.CHAVE_CTO
LEFT JOIN 
    (
    SELECT CHAVE_CTO,count(DISTINCT CHAVE_BEM_11) AS NUM_BENS
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_DEZ24
    WHERE CHAVE_BEM_11 IS NOT NULL 
    GROUP BY 1 
    )F3 ON F1.CHAVE_CTO=F3.CHAVE_CTO
LEFT JOIN 
    (
    SELECT CHAVE_CTO,count(DISTINCT CHAVE_207) AS NUM_CHAVES
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_DEZ24
    WHERE CHAVE_207 IS NOT NULL 
    GROUP BY 1 
    )F4 ON F1.CHAVE_CTO=F4.CHAVE_CTO
LEFT JOIN 
    (
    SELECT CHAVE_CTO,count(DISTINCT CHAVE_MIS_13) AS NUM_CHAVES
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_DEZ24
    WHERE CHAVE_MIS_13 IS NOT NULL 
    GROUP BY 1 
    )F5 ON F1.CHAVE_CTO=F5.CHAVE_CTO
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 2A. CRIAÇÃO DA TABELA AUXILIAR COM AS MARCAÇÕES DO 1º ROUND CATEGORIA SFICS - NIVEL PRODUTO + NIVEL CLIENTE 
--------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.MV_PROD_CLI_DEZ24;
CREATE TABLE BU_CAPTOOLS_WORK.MV_PROD_CLI_DEZ24 AS

SELECT *
    ,CASE WHEN TRIM(CKMETAMIS) IN ('AD0128','AD0145','AD0108','AR0108','AD0125','AL01','AR0105','AD0105') AND TRIM(TIPO_EQP) IN ('410', '415') THEN 1 ELSE 0 END AS REGRA_1
    ,CASE WHEN TRIM(CKPRODMI) IN ('096ENE', '096CER', '096ERC', '096YEG', '096YER', '096YEV','096YRE','096MKE') THEN 1 ELSE 0 END AS REGRA_2
    ,CASE WHEN TRIM(CKMETAMIS) IN ('AD0103','AD0144','AR0103','AD0123','AD0124','AD0104','AD0143','AR0104') AND TRIM(COMBUSTIVEL)='ELECTRICO' THEN 1 ELSE 0 END AS REGRA_3
    ,CASE WHEN TRIM(CKMETAMIS) IN ('AD0103','AD0144','AR0103','AD0123','AD0124','AD0104','AD0143','AR0104') AND  CO2_MOD>0 AND CO2_MOD<=50 AND TRIM(CO2)<>'' AND CO2 IS NOT NULL THEN 1 ELSE 0 END AS REGRA_4
	,CASE WHEN TRIM(CKMETAMIS) IN ('AI0241','AH0201','AI0221','AI0201') AND TRIM(EPC) IN ('A','A+','B') THEN 1 ELSE 0 END AS REGRA_5
    ,CASE WHEN TRIM(CKMETAMIS) IN (
         'AI0341','AI0329','AH0301','AI0306','AI0350','AI0344','AI0303','AH0310','AH0304','AI0326','AI0309','AI0330','AI0321',
         'AH0309','AI0349','AI0346','AI0301','AH0306','AI0343','AH0303','AI0310','AI0304','AI0328','AI0307','AI0302','AH0305','AH0311','AI0345','AI0351',
         'AI0322','AI0360','AH0320','AI0327','AI0308','AI0325','AI0331','AI0348','AI0320','AH0308','AH0307','AI0347','AH0302','AI0305','AI0311','AI0342'
         ) AND TRIM(EPC) IN ('A','A+','B') AND TRIM(purpose_code) in ('004', '104') THEN 1 ELSE 0 END AS REGRA_6
    ,CASE WHEN TRIM(CKMETAMIS) IN (
         'AI0341','AI0329','AH0301','AI0306','AI0350','AI0344','AI0303','AH0310','AH0304','AI0326','AI0309','AI0330','AI0321',
         'AH0309','AI0349','AI0346','AI0301','AH0306','AI0343','AH0303','AI0310','AI0304','AI0328','AI0307','AI0302','AH0305','AH0311','AI0345','AI0351',
         'AI0322','AI0360','AH0320','AI0327','AI0308','AI0325','AI0331','AI0348','AI0320','AH0308','AH0307','AI0347','AH0302','AI0305','AI0311','AI0342'
         ) AND TRIM(EPC) IN ('A','A+','B') AND TRIM(purpose_code) in ('001','005','007','008','009','012') THEN 1 ELSE 0 END AS REGRA_7
    ,CASE WHEN TRIM(CKMETAMIS) IN ('AI0202','AI0222','AH0202','AI0242','AI0313','AI0333','AH0313','AI0353') THEN 1 ELSE 0 END AS REGRA_8
    ,CASE WHEN TRIM(CKMETAMIS) IN ('AC01','AD0106','AR0106','AR0109','AD0126','AD0109','AD0146','AD0110','AR0110') AND TRIM(EPC) IN ('A','A+','B') THEN 1 ELSE 0 END AS REGRA_9
    ,CASE WHEN TRIM(CKPRODMI) IN  ('096FOR', '096K32', '096KEI', '096CFE','096CFP', '096CFU','096CPE','096CPP','096CTC','096KPP','096KPT','096YFF','096YFP') THEN 1 ELSE 0 END AS REGRA_10
    ,CASE WHEN TRIM(CKMETAMIS) IN ('AI0418') AND TRIM (cmetanseg) not in ('EC0','EC2','EC3','EC4','EC9','ECA','ECB','ECC','ECD','ECE','ECF','ECH','ECI','ECJ','ECK','ECL','ECM') THEN 1 ELSE 0 END AS REGRA_11
    ,CASE
        WHEN TRIM(CKMETAMIS) IN ('AD0128','AD0145','AD0108','AR0108','AD0125','AL01','AR0105','AD0105') AND TRIM(TIPO_EQP) IN ('410', '415') THEN 'A.1.1.'
        WHEN TRIM(CKPRODMI) IN ('096ENE', '096CER', '096ERC', '096YEG', '096YER', '096YEV','096YRE','096MKE') THEN 'A.1.1.'
        WHEN TRIM(CKMETAMIS) IN ('AD0103','AD0144','AR0103','AD0123','AD0124','AD0104','AD0143','AR0104') AND TRIM(COMBUSTIVEL)='ELECTRICO' THEN 'A.2.3.'
        WHEN TRIM(CKMETAMIS) IN ('AD0103','AD0144','AR0103','AD0123','AD0124','AD0104','AD0143','AR0104') AND  CO2_MOD>0 AND CO2_MOD<=50 AND TRIM(CO2)<>'' AND CO2 IS NOT NULL THEN 'A.2.3.'
        WHEN TRIM(CKMETAMIS) IN ('AI0241','AH0201','AI0221','AI0201') AND TRIM(EPC) IN ('A','A+','B') THEN 'A.3.1.'
        WHEN TRIM(CKMETAMIS) IN (
                                'AI0341','AI0329','AH0301','AI0306','AI0350','AI0344','AI0303','AH0310','AH0304','AI0326','AI0309','AI0330','AI0321',
                                'AH0309','AI0349','AI0346','AI0301','AH0306','AI0343','AH0303','AI0310','AI0304','AI0328','AI0307','AI0302','AH0305','AH0311','AI0345','AI0351',
                                'AI0322','AI0360','AH0320','AI0327','AI0308','AI0325','AI0331','AI0348','AI0320','AH0308','AH0307','AI0347','AH0302','AI0305','AI0311','AI0342'
                                ) AND TRIM(EPC) IN ('A','A+','B') AND TRIM(purpose_code) in ('004', '104') THEN 'A.3.1.'
        WHEN TRIM(CKMETAMIS) IN (
                                'AI0341','AI0329','AH0301','AI0306','AI0350','AI0344','AI0303','AH0310','AH0304','AI0326','AI0309','AI0330','AI0321',
                                'AH0309','AI0349','AI0346','AI0301','AH0306','AI0343','AH0303','AI0310','AI0304','AI0328','AI0307','AI0302','AH0305','AH0311','AI0345','AI0351',
                                'AI0322','AI0360','AH0320','AI0327','AI0308','AI0325','AI0331','AI0348','AI0320','AH0308','AH0307','AI0347','AH0302','AI0305','AI0311','AI0342'
                                ) AND TRIM(EPC) IN ('A','A+','B') AND TRIM(purpose_code) IN ('001','005','007','008','009','012') THEN 'A.3.7.'
        WHEN TRIM(CKMETAMIS) IN ('AI0202','AI0222','AH0202','AI0242','AI0313','AI0333','AH0313','AI0353') THEN 'A.3.2.'
        WHEN TRIM(CKMETAMIS) IN ('AC01','AD0106','AR0106','AR0109','AD0126','AD0109','AD0146','AD0110','AR0110') AND TRIM(EPC) IN ('A','A+','B') THEN 'A.3.7.'
        WHEN TRIM(CKPRODMI) IN  ('096FOR', '096K32', '096KEI', '096CFE','096CFP', '096CFU','096CPE','096CPP','096CTC','096KPP','096KPT','096YFF','096YFP') THEN 'Student loans'
        WHEN TRIM(CKMETAMIS) IN ('AI0418') AND TRIM (cmetanseg) not in ('EC0','EC2','EC3','EC4','EC9','ECA','ECB','ECC','ECD','ECE','ECF','ECH','ECI','ECJ','ECK','ECL','ECM') THEN 'A.5.2.'
        ELSE 'SEM CATEG'
    END AS FLAG_CAT_PRO
    ,CASE
        WHEN TRIM(CKMETAMIS) IN ('AD0128','AD0145','AD0108','AR0108','AD0125','AL01','AR0105','AD0105') AND TRIM(TIPO_EQP) IN ('410', '415') THEN 1
        WHEN TRIM(CKPRODMI) IN ('096ENE', '096CER', '096ERC', '096YEG', '096YER', '096YEV','096YRE','096MKE') THEN 2
        WHEN TRIM(CKMETAMIS) IN ('AD0103','AD0144','AR0103','AD0123','AD0124','AD0104','AD0143','AR0104') AND TRIM(COMBUSTIVEL)='ELECTRICO' THEN 3
        WHEN TRIM(CKMETAMIS) IN ('AD0103','AD0144','AR0103','AD0123','AD0124','AD0104','AD0143','AR0104') AND  CO2_MOD>0 AND CO2_MOD<=50 AND TRIM(CO2)<>'' AND CO2 IS NOT NULL THEN 4
        WHEN TRIM(CKMETAMIS) IN ('AI0241','AH0201','AI0221','AI0201') AND TRIM(EPC) IN ('A','A+','B') THEN 5
        WHEN TRIM(CKMETAMIS) IN (
                                'AI0341','AI0329','AH0301','AI0306','AI0350','AI0344','AI0303','AH0310','AH0304','AI0326','AI0309','AI0330','AI0321',
                                'AH0309','AI0349','AI0346','AI0301','AH0306','AI0343','AH0303','AI0310','AI0304','AI0328','AI0307','AI0302','AH0305','AH0311','AI0345','AI0351',
                                'AI0322','AI0360','AH0320','AI0327','AI0308','AI0325','AI0331','AI0348','AI0320','AH0308','AH0307','AI0347','AH0302','AI0305','AI0311','AI0342'
                                ) AND TRIM(EPC) IN ('A','A+','B') AND TRIM(purpose_code) in ('004', '104') THEN 6
        WHEN TRIM(CKMETAMIS) IN (
                                'AI0341','AI0329','AH0301','AI0306','AI0350','AI0344','AI0303','AH0310','AH0304','AI0326','AI0309','AI0330','AI0321',
                                'AH0309','AI0349','AI0346','AI0301','AH0306','AI0343','AH0303','AI0310','AI0304','AI0328','AI0307','AI0302','AH0305','AH0311','AI0345','AI0351',
                                'AI0322','AI0360','AH0320','AI0327','AI0308','AI0325','AI0331','AI0348','AI0320','AH0308','AH0307','AI0347','AH0302','AI0305','AI0311','AI0342'
                                ) AND TRIM(EPC) IN ('A','A+','B') AND TRIM(purpose_code) IN ('001','005','007','008','009','012') THEN 7
        WHEN TRIM(CKMETAMIS) IN ('AI0202','AI0222','AH0202','AI0242','AI0313','AI0333','AH0313','AI0353') THEN 8
        WHEN TRIM(CKMETAMIS) IN ('AC01','AD0106','AR0106','AR0109','AD0126','AD0109','AD0146','AD0110','AR0110') AND TRIM(EPC) IN ('A','A+','B') THEN 9
        WHEN TRIM(CKPRODMI) IN  ('096FOR', '096K32', '096KEI', '096CFE','096CFP', '096CFU','096CPE','096CPP','096CTC','096KPP','096KPT','096YFF','096YFP') THEN 10
        WHEN TRIM(CKMETAMIS) IN ('AI0418') AND TRIM (cmetanseg) not in ('EC0','EC2','EC3','EC4','EC9','ECA','ECB','ECC','ECD','ECE','ECF','ECH','ECI','ECJ','ECK','ECL','ECM') THEN 11
        ELSE 12
    END AS FLAG_CAT_ORDEM 
   ,CASE
        WHEN ZCLIENTE='2661006572' AND SUBSTR(TRIM(DABERTUR),1,4)>='2024' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='5100413732' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7400325981' AND SUBSTR(TRIM(DABERTUR),1,4)>='2024' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7400387010' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7400427931' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7400670912' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7400826571' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7401178577' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7401486525' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7401729935' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7402249336' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='8020601611' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='8045509488' AND SUBSTR(TRIM(DABERTUR),1,4)>='2023' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='8046593364' AND SUBSTR(TRIM(DABERTUR),1,4)>='2024' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7401009221' AND SUBSTR(TRIM(DABERTUR),1,4)>='2024' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7400988336' AND SUBSTR(TRIM(DABERTUR),1,4)>='2024' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7400378968' AND SUBSTR(TRIM(DABERTUR),1,4)>='2024' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        WHEN ZCLIENTE='7400171147' AND SUBSTR(TRIM(DABERTUR),1,4)>='2024' AND (TRIM(CKPRODMI) not like '0V0%' OR CKPRODMI IS NULL) THEN 1
        ELSE 0
    END AS FLAG_CAT_CLI
FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_DEZ24
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 2B. NIVEL PRODUTO - QUERY DE SUPORTE PARA ANÁLISE DOS RESULTADOS
		-->
--------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT MAX_REGRA_1 ,MAX_REGRA_2 ,MAX_REGRA_3 ,MAX_REGRA_4 ,MAX_REGRA_5 ,MAX_REGRA_6 ,MAX_REGRA_7 ,MAX_REGRA_8 ,MAX_REGRA_9 ,MAX_REGRA_10 ,MAX_REGRA_11 ,FLAG_CAT_PRO
FROM 
    (
    SELECT CHAVE_CTO
        ,MAX(REGRA_1) AS MAX_REGRA_1 
        ,MAX(REGRA_2) AS MAX_REGRA_2 
        ,MAX(REGRA_3) AS MAX_REGRA_3 
        ,MAX(REGRA_4) AS MAX_REGRA_4 
        ,MAX(REGRA_5) AS MAX_REGRA_5 
        ,MAX(REGRA_6) AS MAX_REGRA_6 
        ,MAX(REGRA_7) AS MAX_REGRA_7 
        ,MAX(REGRA_8) AS MAX_REGRA_8 
        ,MAX(REGRA_9) AS MAX_REGRA_9 
        ,MAX(REGRA_10) AS MAX_REGRA_10 
        ,MAX(REGRA_11) AS MAX_REGRA_11 
        ,MIN(FLAG_CAT_ORDEM) AS MIN_FLAG_CAT_ORDEM 
    FROM BU_CAPTOOLS_WORK.MV_PROD_CLI_DEZ24 
    GROUP BY 1 
    )F1 
LEFT JOIN 
    (
    SELECT DISTINCT CHAVE_CTO,FLAG_CAT_PRO
    FROM
        (
        SELECT *
            ,RANK() OVER (PARTITION BY CHAVE_CTO ORDER BY FLAG_CAT_ORDEM ASC) AS RANK_TRAT_1
        FROM BU_CAPTOOLS_WORK.MV_PROD_CLI_DEZ24
        WHERE FLAG_CAT_PRO<>'SEM CATEG'
        )AUX WHERE RANK_TRAT_1=1
    )F2 ON F1.CHAVE_CTO=F2.CHAVE_CTO
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. TABELA COM 1º MARCAÇÃO (CATEGORIA + % VERDE)
--------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_1;
CREATE TABLE BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_1 AS

SELECT BASE.*
    ,CASE
        WHEN OPER.CHAVE_OPE IS NOT NULL THEN categ_op
        WHEN CLI.chave_cto IS NOT NULL THEN 'Pure Green counterparty - Default'
        WHEN PROD.CHAVE_CTO IS NOT NULL THEN FLAG_CAT_PRO
        ELSE 'Nao Aplicavel'
    END AS nome_ctgr_sfics
    ,CASE
        WHEN OPER.CHAVE_OPE IS NOT NULL THEN PERC_OP
        WHEN CLI.chave_cto IS NOT NULL THEN 1
        WHEN PROD.CHAVE_CTO IS NOT NULL THEN 1
        ELSE 0
    END AS montante_pndrc
    ,CASE
        WHEN OPER.CHAVE_OPE IS NOT NULL THEN 1
        WHEN CLI.chave_cto IS NOT NULL THEN 2
        WHEN PROD.CHAVE_CTO IS NOT NULL THEN 3
        ELSE 4
    END AS FLAG_AUX
    
FROM 
	-- 1º Cruzamento: Obter o Universo Base 
	--> DEZ24 6.287.849 registos 
    (
    SELECT zcliente,cempresa,cbalcao,cnumecta,zdeposit
        ,concat(cempresa,cbalcao,cnumecta,zdeposit) as chave_cto
    FROM cd_captools.ct085_univ_cto_d
    WHERE ref_date='${ref_date}'
    )BASE 
LEFT JOIN 
	-- 2º Cruzamento: Marcação ao Nivel da Operação
	--> DEZ24 6.287.849 registos 
    (
    SELECT *
    FROM BU_CAPTOOLS_WORK.MV_OPERACAO_DEZ24
    WHERE categ_op<>'SEM MARCA'
    )OPER ON BASE.chave_cto=OPER.CHAVE_OPE
LEFT JOIN 
	-- 3º Cruzamento: Marcação ao Nivel do Cliente
	--> DEZ24 6.287.849 registos 
    (
    SELECT chave_cto,MAX(FLAG_CAT_CLI) AS FLAG_MARCA
    FROM BU_CAPTOOLS_WORK.MV_PROD_CLI_DEZ24
    GROUP BY 1 HAVING FLAG_MARCA=1
    )CLI ON BASE.chave_cto=CLI.chave_cto
LEFT JOIN 
	-- 4º Cruzamento: Marcação ao Nivel do Produto 
	--> DEZ24 6.287.849 registos 
    (
    SELECT DISTINCT CHAVE_CTO,FLAG_CAT_PRO
    FROM
        (
        SELECT *
            ,RANK() OVER (PARTITION BY CHAVE_CTO ORDER BY FLAG_CAT_ORDEM ASC) AS RANK_TRAT_1
        FROM BU_CAPTOOLS_WORK.MV_PROD_CLI_DEZ24
        WHERE FLAG_CAT_PRO<>'SEM CATEG'
        )AUX WHERE RANK_TRAT_1=1
    )PROD ON BASE.chave_cto=PROD.CHAVE_CTO   
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. TABELA AUXILIAR COM 2º MARCAÇÃO - ESG RISK 
--------------------------------------------------------------------------------------------------------------------------------------------------

--DROP TABLE IF EXISTS BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_2;
CREATE TABLE BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_2 AS

SELECT *
	,CASE
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND CO2_MOD =0 AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND CO2_MOD =0 AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ','ELECTRICO') AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(CONTRAPARTE) IN ('particulares','outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE <0.45 AND NET_FLOOR_AREA  <5000 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Linked%' THEN 'Other purpose'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Pure Green%' THEN 'Other purpose'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) IN ('A.7.12.','A.7.18.','A.7.7.') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Building acquisition'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(DABERTUR) < '2022-01-01' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(CONTRAPARTE) IN ('instituicoes financeiras', 'setor publico') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor Vehicle Loans'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Building renovation loans'
        WHEN TRIM(CONTRAPARTE) NOT IN('outras empresas nao financeiras') AND CONTRAPARTE IS NOT NULL AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Building renovation loans'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Building renovation loans'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Building renovation loans'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.7.%' THEN 'Other purpose'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.1.13.' THEN 'Other purpose'
        WHEN FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Other purpose'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.6.%' THEN 'Other purpose'
        WHEN FLAG_PROJECT_FINANCE = 1 THEN 'Other purpose'
        WHEN TRIM(CFAMILIA) NOT IN ('02','03','04') AND CFAMILIA IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Other purpose'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(CFAMILIA) IN ('02','03','04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) NOT IN( '01') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Other purpose'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Other purpose'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.3.1.' THEN 'Other purpose'
        WHEN TRIM(NVL(EPC,'')) not in ('A+','A', 'B') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Other purpose'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'Nao Aplicavel'
        WHEN TRIM(CKPRODMI) IN ('000045','000051','000053') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'Nao Aplicavel'
        WHEN TRIM(CKPRODMI) = '000042' AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(NVL(TIPO_EQP,'')) IN ('254','257','146','256','121','252','242','148','255','141','241','251','144','253','243','143','180','181','713','712','244','203','147','145','142','122','120') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.7.12.','A.7.18.','A.7.7.','','Nao Aplicavel','Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND FLAG_PROJECT_FINANCE = 1 AND TRIM(NOME_CTGR_SFICS) NOT IN ('Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'Nao Aplicavel'
        ELSE 'Nao Aplicavel'
    END AS nome_purpose_esg_nalinh_tax
    ,CASE
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Building renovation loans'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor vehicle loans'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor vehicle loans'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND CO2_MOD =0 AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor vehicle loans'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor vehicle loans'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor vehicle loans'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND CO2_MOD =0 AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Motor vehicle loans'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'Building acquisition'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ','ELECTRICO') AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN ('particulares','outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE <0.45 AND NET_FLOOR_AREA  <5000 THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Building acquisition'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Linked%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Pure Green%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) IN ('A.7.12.','A.7.18.','A.7.7.') THEN 'Other purpose'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Other purpose'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(DABERTUR) < '2022-01-01' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN ('instituicoes financeiras', 'setor publico') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) NOT IN('outras empresas nao financeiras') AND CONTRAPARTE IS NOT NULL AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.7.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.1.13.' THEN 'Nao Aplicavel'
        WHEN FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.6.%' THEN 'Nao Aplicavel'
        WHEN FLAG_PROJECT_FINANCE = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(CFAMILIA) NOT IN ('02','03','04') AND CFAMILIA IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(CFAMILIA) IN ('02','03','04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) NOT IN( '01') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.3.1.' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) not in ('A+','A', 'B') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') THEN 'Building renovation loans'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'Building renovation loans'
        WHEN TRIM(CKPRODMI) IN ('000045','000051','000053') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'Motor vehicle loans'
        WHEN TRIM(CKPRODMI) = '000042' AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(NVL(TIPO_EQP,'')) IN ('254','257','146','256','121','252','242','148','255','141','241','251','144','253','243','143','180','181','713','712','244','203','147','145','142','122','120') THEN 'Motor vehicle loans'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Building acquisition'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'Building acquisition'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.7.12.','A.7.18.','A.7.7.','','Nao Aplicavel','Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'Other purpose'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND FLAG_PROJECT_FINANCE = 1 AND TRIM(NOME_CTGR_SFICS) NOT IN ('Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'Other purpose'
        ELSE 'Nao Aplicavel'
    END AS nome_purpose_esg_alinh_tax
	,CASE
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Specific purpose'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Specific purpose'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Specific purpose'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND CO2_MOD =0 AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Specific purpose'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Specific purpose'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Specific purpose'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND CO2_MOD =0 AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'Specific purpose'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ','ELECTRICO') AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN ('particulares','outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Specific purpose'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE <0.45 AND NET_FLOOR_AREA  <5000 THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Specific purpose'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Linked%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Pure Green%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) IN ('A.7.12.','A.7.18.','A.7.7.') THEN 'Specific purpose'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(DABERTUR) < '2022-01-01' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN ('instituicoes financeiras', 'setor publico') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) NOT IN('outras empresas nao financeiras') AND CONTRAPARTE IS NOT NULL AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.7.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.1.13.' THEN 'Nao Aplicavel'
        WHEN FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.6.%' THEN 'Nao Aplicavel'
        WHEN FLAG_PROJECT_FINANCE = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(CFAMILIA) NOT IN ('02','03','04') AND CFAMILIA IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(CFAMILIA) IN ('02','03','04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) NOT IN( '01') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.3.1.' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) not in ('A+','A', 'B') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') THEN 'Specific purpose'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'Specific purpose'
        WHEN TRIM(CKPRODMI) IN ('000045','000051','000053') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'Specific purpose'
        WHEN TRIM(CKPRODMI) = '000042' AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(NVL(TIPO_EQP,'')) IN ('254','257','146','256','121','252','242','148','255','141','241','251','144','253','243','143','180','181','713','712','244','203','147','145','142','122','120') THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Specific purpose'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'Specific purpose'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.7.12.','A.7.18.','A.7.7.','','Nao Aplicavel','Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'Specific purpose'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND FLAG_PROJECT_FINANCE = 1 AND TRIM(NOME_CTGR_SFICS) NOT IN ('Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'Specific purpose'
        ELSE 'General Purpose'  
    END AS nome_general_specific_purpose
	,CASE
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'CCM'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'CCM'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'CCM'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND CO2_MOD =0 AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'CCM'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'CCM'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'CCM'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND CO2_MOD =0 AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'No'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'No'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ','ELECTRICO') AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN ('particulares','outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'CCM'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE <0.45 AND NET_FLOOR_AREA  <5000 THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'CCM'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Linked%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Pure Green%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) IN ('A.7.12.','A.7.18.','A.7.7.') THEN 'No'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(DABERTUR) < '2022-01-01' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN ('instituicoes financeiras', 'setor publico') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) NOT IN('outras empresas nao financeiras') AND CONTRAPARTE IS NOT NULL AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.7.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.1.13.' THEN 'Nao Aplicavel'
        WHEN FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.6.%' THEN 'Nao Aplicavel'
        WHEN FLAG_PROJECT_FINANCE = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(CFAMILIA) NOT IN ('02','03','04') AND CFAMILIA IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(CFAMILIA) IN ('02','03','04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) NOT IN( '01') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.3.1.' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) not in ('A+','A', 'B') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') THEN 'CCM'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'CCM'
        WHEN TRIM(CKPRODMI) IN ('000045','000051','000053') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'CCM'
        WHEN TRIM(CKPRODMI) = '000042' AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(NVL(TIPO_EQP,'')) IN ('254','257','146','256','121','252','242','148','255','141','241','251','144','253','243','143','180','181','713','712','244','203','147','145','142','122','120') THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'CCM'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'CCM'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.7.12.','A.7.18.','A.7.7.','','Nao Aplicavel','Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'CCM'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND FLAG_PROJECT_FINANCE = 1 AND TRIM(NOME_CTGR_SFICS) NOT IN ('Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'CCM'
        ELSE 'Nao Aplicavel' 
    END AS nome_specific_eligible
	,CASE
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Enabling'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Transitional'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Transitional'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND CO2_MOD =0 AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Transitional'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Transitional'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Transitional'
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND CO2_MOD =0 AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Transitional'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ','ELECTRICO') AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN ('particulares','outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Pure'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Pure'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Pure'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Pure'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE <0.45 AND NET_FLOOR_AREA  <5000 THEN 'Pure'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Pure'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Pure'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Pure'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 'Pure'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Linked%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Pure Green%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) IN ('A.7.12.','A.7.18.','A.7.7.') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Pure'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(DABERTUR) < '2022-01-01' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN ('instituicoes financeiras', 'setor publico') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) NOT IN('outras empresas nao financeiras') AND CONTRAPARTE IS NOT NULL AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.7.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.1.13.' THEN 'Nao Aplicavel'
        WHEN FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.6.%' THEN 'Nao Aplicavel'
        WHEN FLAG_PROJECT_FINANCE = 1 THEN 'Nao Aplicavel'
        WHEN TRIM(CFAMILIA) NOT IN ('02','03','04') AND CFAMILIA IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(CFAMILIA) IN ('02','03','04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) NOT IN( '01') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 'Nao Aplicavel'
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.3.1.' THEN 'Nao Aplicavel'
        WHEN TRIM(NVL(EPC,'')) not in ('A+','A', 'B') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 'Nao Aplicavel'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') THEN 'No'
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'No'
        WHEN TRIM(CKPRODMI) IN ('000045','000051','000053') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 'No'
        WHEN TRIM(CKPRODMI) = '000042' AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(NVL(TIPO_EQP,'')) IN ('254','257','146','256','121','252','242','148','255','141','241','251','144','253','243','143','180','181','713','712','244','203','147','145','142','122','120') THEN 'No'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 'No'
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 'No'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.7.12.','A.7.18.','A.7.7.','','Nao Aplicavel','Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'No'
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND FLAG_PROJECT_FINANCE = 1 AND TRIM(NOME_CTGR_SFICS) NOT IN ('Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 'No'
        ELSE 'Nao Aplicavel'
    END AS nome_specific_sustainable
    ,CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END AS FLAG_1
    ,CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_2
    ,CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_3
    ,CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND CO2_MOD =0 AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_4
    ,CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_5
    ,CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_6
    ,CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND CO2_MOD =0 AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_7
    ,CASE WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END AS FLAG_8
    ,CASE WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 1 ELSE 0 END AS FLAG_9
    ,CASE WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ','ELECTRICO') AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_10
    ,CASE WHEN TRIM(CONTRAPARTE) IN ('particulares','outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_11
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_12
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_13
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_14
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_15
    ,CASE WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE <0.45 AND NET_FLOOR_AREA  <5000 THEN 1 ELSE 0 END AS FLAG_16
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_17
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_18
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_19
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_20
    ,CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Linked%' THEN 1 ELSE 0 END AS FLAG_21
    ,CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Pure Green%' THEN 1 ELSE 0 END AS FLAG_22
    ,CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) IN ('A.7.12.','A.7.18.','A.7.7.') THEN 1 ELSE 0 END AS FLAG_23
    ,CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 1 ELSE 0 END AS FLAG_24
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END AS FLAG_25
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END AS FLAG_26
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 1 ELSE 0 END AS FLAG_27
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 1 ELSE 0 END AS FLAG_28
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END AS FLAG_29
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END AS FLAG_30
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 1 ELSE 0 END AS FLAG_31
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 1 ELSE 0 END AS FLAG_32
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_33
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_34
    ,CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_35
    ,CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END AS FLAG_36
    ,CASE WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 1 ELSE 0 END AS FLAG_37
    ,CASE WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 1 ELSE 0 END AS FLAG_38
    ,CASE WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(DABERTUR) < '2022-01-01' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_39
    ,CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_40
    ,CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_41
    ,CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_42
    ,CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_43
    ,CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_44
    ,CASE WHEN TRIM(CONTRAPARTE) IN ('instituicoes financeiras', 'setor publico') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_45
    ,CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END AS FLAG_46
    ,CASE WHEN TRIM(CONTRAPARTE) NOT IN('outras empresas nao financeiras') AND CONTRAPARTE IS NOT NULL AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END AS FLAG_47
    ,CASE WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END AS FLAG_48
    ,CASE WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END AS FLAG_49
    ,CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.7.%' THEN 1 ELSE 0 END AS FLAG_50
    ,CASE WHEN TRIM(NOME_CTGR_SFICS) = 'A.1.13.' THEN 1 ELSE 0 END AS FLAG_51
    ,CASE WHEN FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 1 ELSE 0 END AS FLAG_52
    ,CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.6.%' THEN 1 ELSE 0 END AS FLAG_53
    ,CASE WHEN FLAG_PROJECT_FINANCE = 1 THEN 1 ELSE 0 END AS FLAG_54
    ,CASE WHEN TRIM(CFAMILIA) NOT IN ('02','03','04') AND CFAMILIA IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 1 ELSE 0 END AS FLAG_55
    ,CASE WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(CFAMILIA) IN ('02','03','04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) NOT IN( '01') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 1 ELSE 0 END AS FLAG_56
    ,CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END AS FLAG_57
    ,CASE WHEN TRIM(NOME_CTGR_SFICS) = 'A.3.1.' THEN 1 ELSE 0 END AS FLAG_58
    ,CASE WHEN TRIM(NVL(EPC,'')) not in ('A+','A', 'B') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 1 ELSE 0 END AS FLAG_59
    ,CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') THEN 1 ELSE 0 END AS FLAG_60
    ,CASE WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 1 ELSE 0 END AS FLAG_61
    ,CASE WHEN TRIM(CKPRODMI) IN ('000045','000051','000053') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 1 ELSE 0 END AS FLAG_62
    ,CASE WHEN TRIM(CKPRODMI) = '000042' AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(NVL(TIPO_EQP,'')) IN ('254','257','146','256','121','252','242','148','255','141','241','251','144','253','243','143','180','181','713','712','244','203','147','145','142','122','120') THEN 1 ELSE 0 END AS FLAG_63
    ,CASE WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END AS FLAG_64
    ,CASE WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 1 ELSE 0 END AS FLAG_65
    ,CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.7.12.','A.7.18.','A.7.7.','','Nao Aplicavel','Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 1 ELSE 0 END AS FLAG_66
    ,CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND FLAG_PROJECT_FINANCE = 1 AND TRIM(NOME_CTGR_SFICS) NOT IN ('Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 1 ELSE 0 END AS FLAG_67


   
    ,(CASE WHEN   TRIM(CONTRAPARTE) IN('outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND CO2_MOD =0 AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND CO2_MOD =0 AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ','ELECTRICO') AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) IN ('particulares','outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE <0.45 AND NET_FLOOR_AREA  <5000 THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Linked%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Pure Green%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) IN ('A.7.12.','A.7.18.','A.7.7.') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(DABERTUR) < '2022-01-01' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) IN ('instituicoes financeiras', 'setor publico') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) NOT IN('outras empresas nao financeiras') AND CONTRAPARTE IS NOT NULL AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.7.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NOME_CTGR_SFICS) = 'A.1.13.' THEN 1 ELSE 0 END
        + CASE WHEN FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.6.%' THEN 1 ELSE 0 END
        + CASE WHEN FLAG_PROJECT_FINANCE = 1 THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CFAMILIA) NOT IN ('02','03','04') AND CFAMILIA IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(CFAMILIA) IN ('02','03','04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) NOT IN( '01') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NOME_CTGR_SFICS) = 'A.3.1.' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) not in ('A+','A', 'B') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKPRODMI) IN ('000045','000051','000053') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CKPRODMI) = '000042' AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(NVL(TIPO_EQP,'')) IN ('254','257','146','256','121','252','242','148','255','141','241','251','144','253','243','143','180','181','713','712','244','203','147','145','142','122','120') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 1 ELSE 0 END
        + CASE WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.7.12.','A.7.18.','A.7.7.','','Nao Aplicavel','Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 1 ELSE 0 END
        + CASE WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND FLAG_PROJECT_FINANCE = 1 AND TRIM(NOME_CTGR_SFICS) NOT IN ('Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 1 ELSE 0 END
    ) AS FLAG_MARC
    ,CASE
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 1
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 2
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 3
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND CO2_MOD =0 AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 4
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 5
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 6
        WHEN TRIM(CKPRODMI) IN ('000042','000045','000051','000053') AND TRIM(CONTRAPARTE) = 'particulares' AND CO2_MOD =0 AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) IN ('146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 7
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 8
        WHEN TRIM(NVL(EPC,'')) = '' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 9
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ','ELECTRICO') AND TRIM(DABERTUR) >= '2022-01-01' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 10
        WHEN TRIM(CONTRAPARTE) IN ('particulares','outras empresas nao financeiras') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 11
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 12
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 13
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 14
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 15
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE <0.45 AND NET_FLOOR_AREA  <5000 THEN 16
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 17
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 18
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) = '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 19
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND FLG_CSRD = 0 AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) < '2020' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') THEN 20
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Linked%' THEN 21
        WHEN TRIM(NOME_CTGR_SFICS) LIKE '%Pure Green%' THEN 22
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) IN ('A.7.12.','A.7.18.','A.7.7.') THEN 23
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND FLG_CSRD = 0 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 24
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 25
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 26
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 27
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 1 THEN 28
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 29
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 30
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 31
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_AGD_TRAT = 1 THEN 32
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 33
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 34
        WHEN TRIM(NVL(EPC,'')) LIKE 'A%' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 35
        WHEN TRIM(NVL(EPC,'')) = 'B' AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(QUALITY_SCORE) NOT IN ('1-REAL','SANTANDER') THEN 36
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 37
        WHEN TRIM(NVL(EPC,'')) in ('A','B') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND FLG_RSC_FSC_CRNC_TRAT = 0 AND FLG_RSC_FSC_AGD_TRAT = 0 AND TRIM(NVL(CONSTRUCTION_YEAR,'9999')) >= '2020' AND TRIM(NVL(CONSTRUCTION_YEAR,'9999'))< '9999' AND TRIM(QUALITY_SCORE) IN ('1-REAL','SANTANDER') AND PRIMARY_ENERGY_REQ_VALUE >=0.45 THEN 38
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(DABERTUR) < '2022-01-01' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 39
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 40
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 0 AND TRIM(COMBUSTIVEL) = 'ELECTRICO' AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 41
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND FLG_CSRD = 1 AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD <50 AND CO2_MOD IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 42
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(COMBUSTIVEL) IN ('HIBRIDO', 'HIBRIDO/GASOLINA', 'HIBRIDO/GASOLEO','GASOLINA','GASOLEO','GAZ') AND CO2_MOD >=50 AND CO2_MOD IS NOT NULL AND TRIM(NVL(TIPO_EQP,'')) IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 43
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NVL(TIPO_EQP,'')) NOT IN ('141','241','251','252','253','254','255','256','257','146','180') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 44
        WHEN TRIM(CONTRAPARTE) IN ('instituicoes financeiras', 'setor publico') AND TRIM(PRDT_SPRDT) IN ('000042','000045','000051','000053') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 45
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 46
        WHEN TRIM(CONTRAPARTE) NOT IN('outras empresas nao financeiras') AND CONTRAPARTE IS NOT NULL AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 47
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 48
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) IN ('A.3.2.','A.3.3.','A.3.4.','A.3.5.','A.3.6.') THEN 49
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.7.%' THEN 50
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.1.13.' THEN 51
        WHEN FLG_CSRD = 1 AND TRIM(NOME_CTGR_SFICS) LIKE 'A.1.%' THEN 52
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.6.%' THEN 53
        WHEN FLAG_PROJECT_FINANCE = 1 THEN 54
        WHEN TRIM(CFAMILIA) NOT IN ('02','03','04') AND CFAMILIA IS NOT NULL AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 55
        WHEN TRIM(CONTRAPARTE) = 'particulares' AND TRIM(CFAMILIA) IN ('02','03','04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) NOT IN( '01') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 56
        WHEN TRIM(NOME_CTGR_SFICS) LIKE 'A.2.%' THEN 57
        WHEN TRIM(NOME_CTGR_SFICS) = 'A.3.1.' THEN 58
        WHEN TRIM(NVL(EPC,'')) not in ('A+','A', 'B') AND TRIM(NOME_CTGR_SFICS) LIKE 'A.3.%' THEN 59
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(PRDT_SPRDT) IN ('096HGP','0960H8','096065') THEN 60
        WHEN TRIM(CKMETAMIS) IN('AI0202', 'AI0222', 'AI0242', 'AI0313', 'AI0333', 'AI0353') AND TRIM(CKPRODMI) IN('096MC3', '096MC7', '096FG5', '096FL5', '096FI5', '096FN5', '096YC3') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 61
        WHEN TRIM(CKPRODMI) IN ('000045','000051','000053') AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') THEN 62
        WHEN TRIM(CKPRODMI) = '000042' AND TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','particulares') AND TRIM(NVL(TIPO_EQP,'')) IN ('254','257','146','256','121','252','242','148','255','141','241','251','144','253','243','143','180','181','713','712','244','203','147','145','142','122','120') THEN 63
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) = 'particulares' AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') AND TRIM(NVL(PROPERTY_PURPOSE_CODE,'')) = '01' THEN 64
        WHEN TRIM(NVL(EPC,'')) NOT IN ('') AND TRIM(CONTRAPARTE) IN ('outras empresas nao financeiras','setor publico') AND TRIM(PRDT_SPRDT) NOT IN ('096HGP','0960H8','096065') AND TRIM(CFAMILIA) IN ('02', '03', '04') THEN 65
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND TRIM(NOME_CTGR_SFICS) NOT IN ('A.7.12.','A.7.18.','A.7.7.','','Nao Aplicavel','Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 66
        WHEN TRIM(CONTRAPARTE) IN('outras empresas nao financeiras','setor publico','particulares') AND FLAG_PROJECT_FINANCE = 1 AND TRIM(NOME_CTGR_SFICS) NOT IN ('Sustainability Linked Finance - Default','Pure Green counterparty - Default') THEN 67
    END AS FLAG_ORDEM
FROM (
    SELECT F1.*,F2.NOME_CTGR_SFICS
    FROM 
        (
        SELECT *
        FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_DEZ24
        )F1
    LEFT JOIN 
        (
        SELECT *
        FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_1
        )F2 ON F1.CHAVE_CTO=F2.CHAVE_CTO
    )BASE
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. CRIAÇÃO DA TABELA FINAL
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 6287849 row(s)

DROP TABLE IF EXISTS BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_SIMUL; 
CREATE TABLE BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_SIMUL AS

SELECT F1.*
    ,'Nao Aplicavel' AS SSTNBL_INDCTR
    ,F2.NOME_GENERAL_SPECIFIC_PURPOSE
    ,F2.NOME_PURPOSE_ESG_ALINH_TAX
    ,F2.NOME_PURPOSE_ESG_NALINH_TAX
    ,F2.NOME_SPECIFIC_ELIGIBLE
    ,F2.NOME_SPECIFIC_SUSTAINABLE
	,F2.FLAG_ORDEM
FROM 
    (
    SELECT *
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_1
    )F1
LEFT JOIN 
    (
    SELECT DISTINCT CHAVE_CTO,NOME_PURPOSE_ESG_NALINH_TAX,NOME_PURPOSE_ESG_ALINH_TAX,NOME_GENERAL_SPECIFIC_PURPOSE,NOME_SPECIFIC_ELIGIBLE,NOME_SPECIFIC_SUSTAINABLE,FLAG_ORDEM
    FROM
        (
        SELECT *
            ,RANK() OVER (PARTITION BY CHAVE_CTO ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT_1
        FROM BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_2
        )AUX WHERE RANK_TRAT_1=1
    )F2 ON F1.CHAVE_CTO=F2.CHAVE_CTO
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Análise DA TABELA FINAL
--------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    F1.NOME_CTGR_SFICS
    ,F1.MONTANTE_PNDRC
    ,F1.NOME_GENERAL_SPECIFIC_PURPOSE
    ,F1.NOME_PURPOSE_ESG_ALINH_TAX
    ,F1.NOME_PURPOSE_ESG_NALINH_TAX
    ,F1.NOME_SPECIFIC_ELIGIBLE
    ,F1.NOME_SPECIFIC_SUSTAINABLE
    ,F1.FLAG_ORDEM
    ,F2.NOME_CTGR_SFICS
    ,F2.MONTANTE_PNDRC
    ,F2.NOME_GENERAL_SPECIFIC_PURPOSE
    ,F2.NOME_PURPOSE_ESG_ALINH_TAX
    ,F2.NOME_PURPOSE_ESG_NALINH_TAX
    ,F2.NOME_SPECIFIC_ELIGIBLE
    ,F2.NOME_SPECIFIC_SUSTAINABLE
    ,count(*) AS N
FROM 
    (
    SELECT *
    FROM BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_SIMUL
    )F1
FULL JOIN 
    (
    SELECT *,concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE
    FROM bu_esg_work.modesg_out_sfics_taxon_europeia_202412
    WHERE ref_date='2024-12-31'
    )F2 ON F1.CHAVE_CTO=F2.CHAVE
WHERE F1.NOME_PURPOSE_ESG_ALINH_TAX<>F2.NOME_PURPOSE_ESG_ALINH_TAX
    OR F1.NOME_PURPOSE_ESG_NALINH_TAX<>F2.NOME_PURPOSE_ESG_NALINH_TAX
    OR F1.NOME_SPECIFIC_ELIGIBLE<>F2.NOME_SPECIFIC_ELIGIBLE
    OR F1.NOME_SPECIFIC_SUSTAINABLE<>F2.NOME_SPECIFIC_SUSTAINABLE
    OR F1.NOME_GENERAL_SPECIFIC_PURPOSE<>F2.NOME_GENERAL_SPECIFIC_PURPOSE
    OR F1.NOME_CTGR_SFICS<>F2.NOME_CTGR_SFICS
    OR F1.MONTANTE_PNDRC<>F2.MONTANTE_PNDRC
    
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
;
SELECT *
FROM 
    (
    SELECT *
    FROM BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_SIMUL
    )F1
FULL JOIN 
    (
    SELECT *,concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE
    FROM bu_esg_work.modesg_out_sfics_taxon_europeia_202412
    WHERE ref_date='2024-12-31'
    )F2 ON F1.CHAVE_CTO=F2.CHAVE
WHERE 
concat (  
    f1.NOME_CTGR_SFICS
    ,F1.NOME_GENERAL_SPECIFIC_PURPOSE
    ,F1.NOME_PURPOSE_ESG_ALINH_TAX
    ,F1.NOME_PURPOSE_ESG_NALINH_TAX
    ,F1.NOME_SPECIFIC_ELIGIBLE
    ,F1.NOME_SPECIFIC_SUSTAINABLE
    ,F2.NOME_GENERAL_SPECIFIC_PURPOSE
    ,F2.NOME_PURPOSE_ESG_ALINH_TAX
    ,F2.NOME_PURPOSE_ESG_NALINH_TAX
    ,F2.NOME_SPECIFIC_ELIGIBLE
    ,F2.NOME_SPECIFIC_SUSTAINABLE
    )='A.3.1.Nao AplicavelNao AplicavelOther purposeNao AplicavelNao AplicavelSpecific purposeBuilding acquisitionNao AplicavelCCMPure'


;
select DISTINCT 
FLAG_1
,FLAG_2
,FLAG_3
,FLAG_4
,FLAG_5
,FLAG_6
,FLAG_7
,FLAG_8
,FLAG_9
,FLAG_10
,FLAG_11
,FLAG_12
,FLAG_13
,FLAG_14
,FLAG_15
,FLAG_16
,FLAG_17
,FLAG_18
,FLAG_19
,FLAG_20
,FLAG_21
,FLAG_22
,FLAG_23
,FLAG_24
,FLAG_25
,FLAG_26
,FLAG_27
,FLAG_28
,FLAG_29
,FLAG_30
,FLAG_31
,FLAG_32
,FLAG_33
,FLAG_34
,FLAG_35
,FLAG_36
,FLAG_37
,FLAG_38
,FLAG_39
,FLAG_40
,FLAG_41
,FLAG_42
,FLAG_43
,FLAG_44
,FLAG_45
,FLAG_46
,FLAG_47
,FLAG_48
,FLAG_49
,FLAG_50
,FLAG_51
,FLAG_52
,FLAG_53
,FLAG_54
,FLAG_55
,FLAG_56
,FLAG_57
,FLAG_58
,FLAG_59

from BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_2
where FLAG_MARC-FLAG_60-FLAG_61-FLAG_62-FLAG_63-FLAG_64-FLAG_65-FLAG_66-FLAG_67>1
;

SELECT DISTINCT
FLAG_13
,FLAG_15
,FLAG_25
,FLAG_26
,FLAG_29
,FLAG_30
,FLAG_33
,FLAG_34
,FLAG_37
,FLAG_58
,FLAG_MARC-FLAG_60-FLAG_61-FLAG_62-FLAG_63-FLAG_64-FLAG_65-FLAG_66-FLAG_67 AS N
from BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_2
where FLAG_MARC-FLAG_60-FLAG_61-FLAG_62-FLAG_63-FLAG_64-FLAG_65-FLAG_66-FLAG_67>1
;

SELECT DISTINCT
FLAG_60
,FLAG_61
,FLAG_62
,FLAG_63
,FLAG_64
,FLAG_65
,FLAG_66
,FLAG_67
,FLAG_60
+FLAG_61
+FLAG_62
+FLAG_63
+FLAG_64
+FLAG_65
+FLAG_66
+FLAG_67 AS N
from BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_ROUND_2

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 98. CRIAÇÃO DA TABELA AUXILIAR COM A MARCAÇÃO AO NÍVEL DA OPERAÇÃO
--------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.MV_OPERACAO_DEZ24;
CREATE TABLE BU_CAPTOOLS_WORK.MV_OPERACAO_DEZ24 AS

SELECT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE_OPE,CONCAT(CEMPRESA,CBALCAO,CNUMECTA) AS CHAVE_OPE_2
	,CASE
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20446109096' AND ZDEPOSIT='000000000000000' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20602396096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20675830096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046586' AND ZDEPOSIT='000530000778212' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20470315096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20510516096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20690870096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20650866096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20703947096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20440417096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20421433096' AND ZDEPOSIT='000000000000000' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524657096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20498993096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20440268096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20520606096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046532' AND ZDEPOSIT='000530000759112' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046602' AND ZDEPOSIT='000530000477905' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614519097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250308' AND ZDEPOSIT='000450000777941' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20705397096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20409727096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20684840096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20503461096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20595061096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20648746096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20678271096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046337' AND ZDEPOSIT='000530000777099' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20505524096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046651' AND ZDEPOSIT='000530000667540' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20504006096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20452826096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046430' AND ZDEPOSIT='000530000509837' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20433180096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20683446096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655139096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046682' AND ZDEPOSIT='000530000778109' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20719729096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729132096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692850096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046516' AND ZDEPOSIT='000530000778022' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729959096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20580881096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450044096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046548' AND ZDEPOSIT='000530000778238' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046517' AND ZDEPOSIT='000530000761564' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250196' AND ZDEPOSIT='000450000777717' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0649774000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20481528096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0649777000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20695275096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250070' AND ZDEPOSIT='000450000507008' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20543400096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20441662096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20612312096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250305' AND ZDEPOSIT='000450000708369' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20465497096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20561840096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524277096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20669122096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046564' AND ZDEPOSIT='000530000610062' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20415039096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250155' AND ZDEPOSIT='000450000751878' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20535117096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711601096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20547047096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20588157096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20572474096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18606234097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20717889096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046636' AND ZDEPOSIT='000530000777692' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20673181096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20625363096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0644306000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046478' AND ZDEPOSIT='000530000772334' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20646377096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20508072096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='000008005551652' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250397' AND ZDEPOSIT='000450000479263' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20653910096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20515069096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20547187096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250120' AND ZDEPOSIT='000450000777369' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20406558096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20416052096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710355096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20730510096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250009' AND ZDEPOSIT='000450000697368' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20504634096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249945' AND ZDEPOSIT='000450000776779' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249925' AND ZDEPOSIT='000450000730426' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20487145096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20668488096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20451745096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20743869096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046428' AND ZDEPOSIT='000530000777397' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250399' AND ZDEPOSIT='000450000703859' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250344' AND ZDEPOSIT='000450000682143' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046655' AND ZDEPOSIT='000530000778900' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20477088096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046639' AND ZDEPOSIT='000530000778783' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380009759' AND ZDEPOSIT='390103800097599' THEN 'Pure Green counterparty - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20464094096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20486253096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20726666096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20630009096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20454558096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739636096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20411558096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20712690096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20515317096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692330096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250445' AND ZDEPOSIT='000450000739755' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593777096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20531140096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20614201096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20744479096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000271' AND ZDEPOSIT='0004900C59640I1' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691407096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20574637096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20548805096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046510' AND ZDEPOSIT='000530000777090' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046588' AND ZDEPOSIT='000530000778621' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20534433096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20562327096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718705096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20612932096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18605822097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249622' AND ZDEPOSIT='000450000577476' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20518345096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250307' AND ZDEPOSIT='000450000690334' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250026' AND ZDEPOSIT='000450000619047' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250383' AND ZDEPOSIT='000450000464914' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20502307096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691696096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000303' AND ZDEPOSIT='001520240387054' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046374' AND ZDEPOSIT='000530000734019' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450143096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18606242097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711254096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20636188096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20575287096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0652829000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20456934096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250393' AND ZDEPOSIT='000450000479263' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711841096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20542238096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20422043096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20462999096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20681499096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20613427096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20506811096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0656331000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20447339096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20618947096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20709233096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0645887000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250501' AND ZDEPOSIT='000450000479263' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607380097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250428' AND ZDEPOSIT='000450000656980' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20645775096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249952' AND ZDEPOSIT='000450000763019' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20459482096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593447096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250266' AND ZDEPOSIT='000450000777035' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654595096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20620448096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250395' AND ZDEPOSIT='000450000479263' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250552' AND ZDEPOSIT='000450000774376' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20621073096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046394' AND ZDEPOSIT='000530000591609' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710785096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20603063096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0651268000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046537' AND ZDEPOSIT='000530000742000' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250309' AND ZDEPOSIT='000450000739300' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20587894096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20737820096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691613096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20562350096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250174' AND ZDEPOSIT='000450000777312' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046650' AND ZDEPOSIT='000530000778844' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20533674096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20491311096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250144' AND ZDEPOSIT='000450000464215' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046646' AND ZDEPOSIT='000530000772405' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18613511097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20416797096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20447032096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249014' AND ZDEPOSIT='000450000771906' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20507108096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046627' AND ZDEPOSIT='000530000508723' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20717244096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030643' AND ZDEPOSIT='363603800306431' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046059' AND ZDEPOSIT='000530000774133' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20540133096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20586052096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20582218096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000326' AND ZDEPOSIT='001520240435480' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20469861096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20656038096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20598248096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20491600096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20482153096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20474200096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20686191096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046444' AND ZDEPOSIT='000530000671403' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0654545000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249918' AND ZDEPOSIT='000450000520796' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20723796096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20696794096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000303' AND ZDEPOSIT='001520240387053' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046120' AND ZDEPOSIT='000530000763835' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20722160096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20548409096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046614' AND ZDEPOSIT='000530000778700' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20546817096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20520242096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20612379096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046557' AND ZDEPOSIT='000530000772819' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20744149096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607950097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249097' AND ZDEPOSIT='000450000640795' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20508064096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250353' AND ZDEPOSIT='000450000500392' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20509930096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20467352096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118090' AND ZDEPOSIT='000510000778442' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046460' AND ZDEPOSIT='000530000734782' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20532940096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20445713096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611143097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20464243096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739834096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729488096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20536438096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20693098096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20687447096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20532999096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249702' AND ZDEPOSIT='000450000775719' THEN 'A.2.5.'
		-- WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20451117096' AND ZDEPOSIT='000000000000000' THEN 'B.1.' -- 07/05 - Reunião com SB e RC acerca das categorias B.1. e A.11.5. / Excluimos esta operação 
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20679535096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20417910096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000369' AND ZDEPOSIT='001520240499273' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20621693096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20562061096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046391' AND ZDEPOSIT='000530000752998' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046496' AND ZDEPOSIT='000530000674444' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20685730096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20703715096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20722111096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20715446096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20480116096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20715198096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250228' AND ZDEPOSIT='000450000777815' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046393' AND ZDEPOSIT='000530000745916' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718903096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20666300096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20465034096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20700380096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20730627096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611119097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450036096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728258096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20467501096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20430681096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20635552096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0657604000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20638655096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20673330096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20409750096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20560107096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20459334096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20438528096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250185' AND ZDEPOSIT='000450000646541' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046523' AND ZDEPOSIT='000530000746423' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250249' AND ZDEPOSIT='000450000777784' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250442' AND ZDEPOSIT='000450000755687' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655980096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20512744096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20596150096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20700430096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20600390096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046658' AND ZDEPOSIT='000530000687784' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250458' AND ZDEPOSIT='000450000765471' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046592' AND ZDEPOSIT='000530000778534' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20724109096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20727730096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046468' AND ZDEPOSIT='000530000672437' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20623947096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607406097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000369' AND ZDEPOSIT='001520240499274' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250396' AND ZDEPOSIT='000450000479263' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20542451096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20534862096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718069096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20690607096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20650536096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046554' AND ZDEPOSIT='000530000767409' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046375' AND ZDEPOSIT='000530000777331' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118088' AND ZDEPOSIT='000510000676660' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250243' AND ZDEPOSIT='000450000776076' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20678099096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20525225096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20435078096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20514591096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20530183096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739735096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046593' AND ZDEPOSIT='000530000507721' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046489' AND ZDEPOSIT='000530000678935' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20644315096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20480371096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000326' AND ZDEPOSIT='001520240435479' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20598743096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20645486096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20627161096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20567144096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20562673096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721709096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573746096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046471' AND ZDEPOSIT='000530000777797' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046386' AND ZDEPOSIT='000530000777415' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20520259096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20622287096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20498506096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0651269000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654009096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692538096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046635' AND ZDEPOSIT='000530000738417' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250452' AND ZDEPOSIT='000450000507008' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654058096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250557' AND ZDEPOSIT='000450000778577' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046629' AND ZDEPOSIT='000530000778611' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118099' AND ZDEPOSIT='000510000779117' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20523592096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20671268096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20613476096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20408976096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250134' AND ZDEPOSIT='000450000777515' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250102' AND ZDEPOSIT='000450000527837' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20441050096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250161' AND ZDEPOSIT='000450000741255' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250311' AND ZDEPOSIT='000450000658389' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20459433096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250215' AND ZDEPOSIT='000450000693478' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250246' AND ZDEPOSIT='000450000623414' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20667712096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610368097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046418' AND ZDEPOSIT='000530000777315' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20726989096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20508585096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250291' AND ZDEPOSIT='000450000777918' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418348096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20700166096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20626700096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607992097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614139097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20606504096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250507' AND ZDEPOSIT='000450000777597' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00005800040' AND ZDEPOSIT='PTPWDBOM0009000' THEN 'A.2.3.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046545' AND ZDEPOSIT='000530000778337' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046568' AND ZDEPOSIT='000530000778069' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20693916096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000271' AND ZDEPOSIT='001520240310181' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250191' AND ZDEPOSIT='000450000770015' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655956096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20521539096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0648089000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20602933096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046502' AND ZDEPOSIT='000530000734792' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250240' AND ZDEPOSIT='000450000463688' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20549175096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20521117096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000326' AND ZDEPOSIT='0004900C59640I1' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20624143096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20459367096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20515382096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20410055096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20523568096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20437116096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20620109096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250018' AND ZDEPOSIT='000450000111159' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20636519096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607398097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607976097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20745823096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046455' AND ZDEPOSIT='000530000777766' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20645544096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250068' AND ZDEPOSIT='000450000482167' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603488097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20606777096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0646093000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046481' AND ZDEPOSIT='000530000672482' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046312' AND ZDEPOSIT='000530000774981' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20586698096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20683388096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20480611096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593694096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046550' AND ZDEPOSIT='000530000775747' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250233' AND ZDEPOSIT='000450000685443' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250154' AND ZDEPOSIT='000450000655732' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20457197096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000271' AND ZDEPOSIT='001520240310182' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20408539096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718614096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20618384096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000303' AND ZDEPOSIT='0004900C59640I1' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20481221096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655675096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524822096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046398' AND ZDEPOSIT='000530000524393' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046392' AND ZDEPOSIT='000530000744192' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655840096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250394' AND ZDEPOSIT='000450000479263' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250169' AND ZDEPOSIT='000450000537073' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046527' AND ZDEPOSIT='000530000746907' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250356' AND ZDEPOSIT='000450000777388' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20429451096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20740949096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450861096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20567037096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710488096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718713096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046598' AND ZDEPOSIT='000530000562271' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046584' AND ZDEPOSIT='000530000729965' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20701941096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711585096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20681788096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250148' AND ZDEPOSIT='000450000661609' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18608008097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20549084096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20610969096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593207096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728720096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118089' AND ZDEPOSIT='000510000663003' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20622584096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250444' AND ZDEPOSIT='000450000777846' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573498096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250194' AND ZDEPOSIT='000450000320437' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046467' AND ZDEPOSIT='000530000473183' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654454096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20523691096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20725767096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20493960096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20437967096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046507' AND ZDEPOSIT='000530000777942' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654611096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20548219096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250047' AND ZDEPOSIT='000450000479262' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20620802096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250234' AND ZDEPOSIT='000450000511064' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691043096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20741236096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250294' AND ZDEPOSIT='000450000735077' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20540315096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046572' AND ZDEPOSIT='000530000738417' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20668371096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046448' AND ZDEPOSIT='000530000777622' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654306096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20571542096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654892096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20516315096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380009711' AND ZDEPOSIT='390103800097119' THEN 'Pure Green counterparty - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418173096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250031' AND ZDEPOSIT='000450000774332' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250343' AND ZDEPOSIT='000450000738505' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20671730096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250447' AND ZDEPOSIT='000450000775362' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20652391096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20724695096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046323' AND ZDEPOSIT='000530000610953' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046350' AND ZDEPOSIT='000530000694857' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20699194096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20424130096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20457247096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20559885096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20650148096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20585807096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710207096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046521' AND ZDEPOSIT='000530000691867' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250001' AND ZDEPOSIT='000450000746382' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046335' AND ZDEPOSIT='000530000777001' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20422902096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250126' AND ZDEPOSIT='000450000661755' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20571583096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20621420096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20501333096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000232081' AND ZDEPOSIT='000450000777668' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20624036096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20591862096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654926096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20557228096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20471461096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593033096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20587878096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250204' AND ZDEPOSIT='000450000657028' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046499' AND ZDEPOSIT='000530000777981' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20487491096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0654529000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20553599096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046631' AND ZDEPOSIT='000530000778473' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249679' AND ZDEPOSIT='000450000666600' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20673272096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20566641096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711171096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20736806096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20647771096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20740444096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20472725096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418058096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046575' AND ZDEPOSIT='000530000778347' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20606363096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20592530096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046351' AND ZDEPOSIT='000530000694857' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20599675096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249959' AND ZDEPOSIT='000450000701482' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250388' AND ZDEPOSIT='000450000777979' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250596' AND ZDEPOSIT='000450000101714' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20727177096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046429' AND ZDEPOSIT='000530000777471' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250143' AND ZDEPOSIT='000450000769750' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20482328096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20746110096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20632211096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20461470096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046477' AND ZDEPOSIT='000530000678664' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046419' AND ZDEPOSIT='000530000777517' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654082096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046443' AND ZDEPOSIT='000530000661077' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573928096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418827096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046566' AND ZDEPOSIT='000530000778437' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18606226097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20722335096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721469096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0652833000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20564000096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250375' AND ZDEPOSIT='000450000593526' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614501097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20630140096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20430269096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046576' AND ZDEPOSIT='000530000778633' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20436720096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20724364096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20629001096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692884096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20705603096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20447115096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20477104096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20504410096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250216' AND ZDEPOSIT='000450000693152' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20477070096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20575246096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249035' AND ZDEPOSIT='000450000757852' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250398' AND ZDEPOSIT='000450000479263' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20540588096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610376097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20519087096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20513528096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20410469096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20709480096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20507355096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046590' AND ZDEPOSIT='000530000778327' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20717962096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20455837096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20417563096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250236' AND ZDEPOSIT='000450000777267' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710751096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20619036096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20604624096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20745146096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524145096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20703012096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20440375096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20417258096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20456157096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249743' AND ZDEPOSIT='000450000470349' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20679055096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250166' AND ZDEPOSIT='000450000679140' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18599454097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20540786096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20522214096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250270' AND ZDEPOSIT='000450000756441' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20570684096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20663414096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046473' AND ZDEPOSIT='000530000777658' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654413096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739487096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20557921096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046384' AND ZDEPOSIT='000530000776939' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20449525096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20476791096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20515135096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046466' AND ZDEPOSIT='000530000740306' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20611017096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046637' AND ZDEPOSIT='000530000753461' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20506589096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20746458096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046441' AND ZDEPOSIT='000530000478830' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20611082096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='000007400192000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046607' AND ZDEPOSIT='000530000777884' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611192097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20490750096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250457' AND ZDEPOSIT='000450000778175' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20471289096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418884096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20410832096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611929097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20466750096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20625173096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20653092096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711403096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0657588000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20599741096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524111096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691274096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20659784096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046605' AND ZDEPOSIT='000530000751301' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611135097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728142096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20659792096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20652078096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20432703096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20629233096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20520226096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20590187096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20551361096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20537519096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046616' AND ZDEPOSIT='000530000776714' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046621' AND ZDEPOSIT='000530000778470' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728829096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249937' AND ZDEPOSIT='000450000776704' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20535414096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046512' AND ZDEPOSIT='000530000771105' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20553110096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20525480096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711635096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046503' AND ZDEPOSIT='000530000775589' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20574223096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721592096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250093' AND ZDEPOSIT='000450000769333' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20745351096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20415054096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250498' AND ZDEPOSIT='000450000615853' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20662648096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18613388097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20559505096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046531' AND ZDEPOSIT='000530000778105' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000369' AND ZDEPOSIT='0004900C59640I1' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20695523096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20451158096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20423413096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20705330096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20516463096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20428958096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046491' AND ZDEPOSIT='000530000777763' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20480074096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20498746096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250322' AND ZDEPOSIT='000450000582346' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20734223096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046494' AND ZDEPOSIT='000530000771644' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20441381096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20514849096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20394531096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20557913096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20430087096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046431' AND ZDEPOSIT='000530000479569' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20416466096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250158' AND ZDEPOSIT='000450000777542' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046423' AND ZDEPOSIT='000530000761678' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250118' AND ZDEPOSIT='000450000465865' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20594148096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611812097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18606952097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611127097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046565' AND ZDEPOSIT='000530000776977' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20574512096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573845096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250100' AND ZDEPOSIT='000450000605797' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728944096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20545306096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046504' AND ZDEPOSIT='000530000764463' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729439096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20613872096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250287' AND ZDEPOSIT='000450000693659' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20561527096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250425' AND ZDEPOSIT='000450000778229' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20464904096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20531215096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593421096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046501' AND ZDEPOSIT='000530000601814' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20646864096' AND ZDEPOSIT='000000000000000' THEN 'A.3.2.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250338' AND ZDEPOSIT='000450000665310' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20519525096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20651989096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20612726096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250041' AND ZDEPOSIT='000450000677689' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20590153096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603504097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20704796096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20709803096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20489281096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739594096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20717830096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20725650096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250103' AND ZDEPOSIT='000450000645721' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18608263097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250525' AND ZDEPOSIT='000450000772607' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20437694096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20627922096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20561659096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20648753096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718598096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250313' AND ZDEPOSIT='000450000661942' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20471875096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20714571096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20568654096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20548896096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20724851096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20517529096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250432' AND ZDEPOSIT='000450000740236' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00005800040' AND ZDEPOSIT='PTEDA4OM0001000' THEN 'A.1.6.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20647045096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20429832096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20451166096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20596911096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721212096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20478136096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046582' AND ZDEPOSIT='000530000778576' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20417092096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20486717096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20616164096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20464235096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20727821096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721071096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20632419096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20518055096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20563002096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250569' AND ZDEPOSIT='000450000621375' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250059' AND ZDEPOSIT='000450000402549' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18608354097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250044' AND ZDEPOSIT='000450000776999' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20609227096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20675509096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20465760096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20638861096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046497' AND ZDEPOSIT='000530000104782' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20620828096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249975' AND ZDEPOSIT='000450000773031' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20448824096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20487087096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20469895096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20607916096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20663208096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20429766096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20569405096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250306' AND ZDEPOSIT='000450000777994' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20101258096' AND ZDEPOSIT='000000000000000' THEN 'A.2.3.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118094' AND ZDEPOSIT='000510000778293' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20627641096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20638275096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20400098096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614105097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20510847096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20643721096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046378' AND ZDEPOSIT='000530000698628' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249698' AND ZDEPOSIT='000450000531229' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614097097' AND ZDEPOSIT='000000000000000' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20740410096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20551379096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20461355096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20447081096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20592449096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046449' AND ZDEPOSIT='000530000777627' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573589096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20431754096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046596' AND ZDEPOSIT='000530000775529' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20741046096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20602917096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20631312096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20665351096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20608781096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20440102096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250492' AND ZDEPOSIT='000450000666078' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20499504096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0656333000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20504527096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20462726096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046511' AND ZDEPOSIT='000530000771105' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450929096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20599824096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20392360096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250643' AND ZDEPOSIT='000450000674536' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20570312096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20566328096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046420' AND ZDEPOSIT='000530000776873' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450481096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046352' AND ZDEPOSIT='000530000775774' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250301' AND ZDEPOSIT='000450000776616' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20625090096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20664016096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20673165096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20416573096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20734777096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046425' AND ZDEPOSIT='000530000609702' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20609409096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046606' AND ZDEPOSIT='000530000778327' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20546668096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20696844096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250631' AND ZDEPOSIT='000450000738842' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20474358096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249934' AND ZDEPOSIT='000450000320597' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20599360096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20423009096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20591102096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655824096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250265' AND ZDEPOSIT='000450000751110' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046457' AND ZDEPOSIT='000530000768050' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249946' AND ZDEPOSIT='000450000777033' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250588' AND ZDEPOSIT='000450000612203' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20511381096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654157096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20736715096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20495536096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20621156096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692207096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20496435096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046381' AND ZDEPOSIT='000530000660314' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250241' AND ZDEPOSIT='000450000740703' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20631478096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046442' AND ZDEPOSIT='000530000777715' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729728096' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20371372096' AND ZDEPOSIT='000000000000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20541933096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20744230096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250456' AND ZDEPOSIT='000450000778166' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046349' AND ZDEPOSIT='000530000694857' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250427' AND ZDEPOSIT='000450000778145' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20586987096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20647227096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046601' AND ZDEPOSIT='000530000778027' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20458807096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250096' AND ZDEPOSIT='000450000730739' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249848' AND ZDEPOSIT='000450000476492' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0648083000000' THEN 'Sustainability Linked Finance - Default'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046370' AND ZDEPOSIT='000530000777185' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20702659096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20495825096' AND ZDEPOSIT='000000000000000' THEN 'Student loans'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046462' AND ZDEPOSIT='000530000700116' THEN 'A.2.5.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046628' AND ZDEPOSIT='000530000778514' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20653407096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20552252096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20433081096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20519731096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729751096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20429162096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20598479096' AND ZDEPOSIT='000000000000000' THEN 'A.3.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046498' AND ZDEPOSIT='000530000469296' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584001097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19540052096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19484855096' THEN 'A.2.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580686097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='14206154096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20398086096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17789792096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970188096' THEN 'A.1.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603074097' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000338' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19186658096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18719830096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000918' THEN 'KPI Linked - Green'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18922996096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17691576096' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249673' THEN 'A.7.12.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18579522097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18578946097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17776336096' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000069' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19279693096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030582' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15866485096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17615609096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18587996097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584530097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17985283096' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18587970097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='14246804096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609295097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='13618128096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='16573411096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18230911096' THEN 'A.8.10.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00177714007' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18719749096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18848894096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17221713096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18574762097' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581940097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17738088096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610152097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20201868096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='16256835096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030444' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584134097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17985440096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18605145097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17988048096' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20176433096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970006096' THEN 'A.1.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580082097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000913' THEN 'KPI Linked - Green'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970329096' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18782002096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18117340096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584829097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17195834096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00155769007' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970261096' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00146552007' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000938' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19899151096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030546' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18589430097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177027096' THEN 'A.2.3.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000189' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17456178096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17789768096' THEN 'A.3.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18578102097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19467223096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='10854551096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18631522096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030598' THEN 'A.2.3.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000374' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='2392' AND CNUMECTA='00062468020' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18529429096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18582393097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18583672097' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000392' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15745168096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380029937' THEN 'A.6.19.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17092288096' THEN 'A.7.18.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030299' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18598241097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17099127096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18617538097' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000200' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18602936097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20356902096' THEN 'A.8.23.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15697617096' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000104' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603025097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='16573239096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17988162096' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19200590096' THEN 'A.3.2.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20210000167' THEN 'A.2.3.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000248863' THEN 'A.2.3.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000046' THEN 'A.6.19.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18617026096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17949420096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17615633096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18061290096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18577054097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15971459096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580520097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18599181097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18527555096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580181097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17984898096' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18421551096' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000519' THEN 'KPI Linked - Green'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18583888097' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000433' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15680068096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18589422097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18592467097' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18752930096' THEN 'A.3.2.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177076096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609287097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00005800040' THEN 'KPI Linked - Green'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17191858096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17892174096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18006550096' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19567360096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20082102096' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000005' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17943282096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581866097' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000076' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18015098096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00177706007' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17894030096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18588028097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20176607096' THEN 'A.2.3.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20210000166' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18605897097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18582302097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970121096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18574218097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581494097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609261097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18507177096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18716661096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18575959097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15868994096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970212096' THEN 'A.1.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18471762096' THEN 'A.2.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18577849097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581916097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584910097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18617835097' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970279096' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17734145096' THEN 'A.2.3.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20200000282' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18586329097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18582856097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18585610097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970345096' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609303097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580702097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18578672097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970428096' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18061704096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18719509096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970238096' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580736097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17864504096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030145' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970469096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18574804097' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18579902097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581890097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17988014096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584472097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19725695096' THEN 'A.1.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000211' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18708411096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970139096' THEN 'A.1.5.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581924097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177472096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030438' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19260578096' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18850452096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17587055096' THEN 'A.7.18.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18602886097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18320845096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607208097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17984740096' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609246097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030480' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20193511096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18578680097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00117215007' THEN 'KPI Linked - Green'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177555096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609253097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970402096' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18585560097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609238097' THEN 'A.7.7.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249672' THEN 'A.7.12.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18573699097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19748267096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17988238096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18455971096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20140124096' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00155736007' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607273097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581874097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607984097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970311096' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18598373097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18710680096' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000518' THEN 'KPI Linked - Green'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610350097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='13098164096' THEN 'A.3.1.'
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20220000078' THEN 'A.6.19.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603645097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614568097' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000824' THEN 'KPI Linked - Green'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177605096' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18582849097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000914' THEN 'KPI Linked - Green'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610558097' THEN 'A.7.7.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584662097' THEN 'A.7.7.'
		WHEN CEMPRESA='80' AND CBALCAO='6416' AND ZDEPOSIT='335785840000000' THEN 'A.1.1.'
		WHEN CEMPRESA='80' AND CBALCAO='6416' AND ZDEPOSIT='504121590000000' THEN 'Pure Green counterparty - Default'
		WHEN CEMPRESA='80' AND CBALCAO='6416' AND ZDEPOSIT='521431150000000' THEN 'Pure Green counterparty - Default'
		WHEN CEMPRESA='80' AND CBALCAO='6416' AND ZDEPOSIT='336426400000000' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='54960380020' AND ZDEPOSIT='000000000000000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND CBALCAO='0000' AND CNUMECTA='21661935001' AND ZDEPOSIT='000000000000000' THEN 'A.3.2.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880441640' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423280' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880378030' THEN 'A.2.14.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820426880' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880453120' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423300' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880440190' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880447100' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880412130' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423310' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304890421450' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880441620' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423340' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880419800' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423140' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880441610' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880438000' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423320' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423150' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880437990' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423160' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423050' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820426870' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880429700' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820433740' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880424410' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880432120' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423200' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880441630' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880427010' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423270' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880428400' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820433730' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423290' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820433890' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880428430' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880436270' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820434610' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423260' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880402110' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880407580' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880398940' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820433900' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820451180' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304890435500' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880427230' THEN 'A.2.3.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423210' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880435030' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820364880' THEN 'A.1.9.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880419270' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423190' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423180' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423060' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423030' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423040' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423000' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820434630' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423120' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423020' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880407590' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423010' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880419810' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880444710' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880402100' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820399500' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880457370' THEN 'Pure Green counterparty - Default'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880444350' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880427990' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423170' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880398950' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423220' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880366120' THEN 'A.2.14.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880418860' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880438140' THEN 'A.3.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423330' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880444100' THEN 'A.2.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880436280' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880430130' THEN 'A.1.1.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880419020' THEN 'A.2.2.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880447060' THEN 'A.1.3.'
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880447600' THEN 'A.3.1.'
		ELSE 'SEM MARCA'
	END AS CATEG_OP
	,CASE
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20446109096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20602396096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20675830096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046586' AND ZDEPOSIT='000530000778212' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20470315096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20510516096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20690870096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20650866096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20703947096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20440417096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20421433096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524657096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20498993096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20440268096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20520606096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046532' AND ZDEPOSIT='000530000759112' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046602' AND ZDEPOSIT='000530000477905' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614519097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250308' AND ZDEPOSIT='000450000777941' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20705397096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20409727096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20684840096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20503461096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20595061096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20648746096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20678271096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046337' AND ZDEPOSIT='000530000777099' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20505524096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046651' AND ZDEPOSIT='000530000667540' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20504006096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20452826096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046430' AND ZDEPOSIT='000530000509837' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20433180096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20683446096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655139096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046682' AND ZDEPOSIT='000530000778109' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20719729096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729132096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692850096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046516' AND ZDEPOSIT='000530000778022' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729959096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20580881096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450044096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046548' AND ZDEPOSIT='000530000778238' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046517' AND ZDEPOSIT='000530000761564' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250196' AND ZDEPOSIT='000450000777717' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0649774000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20481528096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0649777000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20695275096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250070' AND ZDEPOSIT='000450000507008' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20543400096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20441662096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20612312096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250305' AND ZDEPOSIT='000450000708369' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20465497096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20561840096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524277096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20669122096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046564' AND ZDEPOSIT='000530000610062' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20415039096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250155' AND ZDEPOSIT='000450000751878' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20535117096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711601096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20547047096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20588157096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20572474096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18606234097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20717889096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046636' AND ZDEPOSIT='000530000777692' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20673181096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20625363096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0644306000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046478' AND ZDEPOSIT='000530000772334' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20646377096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20508072096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='000008005551652' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250397' AND ZDEPOSIT='000450000479263' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20653910096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20515069096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20547187096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250120' AND ZDEPOSIT='000450000777369' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20406558096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20416052096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710355096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20730510096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250009' AND ZDEPOSIT='000450000697368' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20504634096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249945' AND ZDEPOSIT='000450000776779' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249925' AND ZDEPOSIT='000450000730426' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20487145096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20668488096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20451745096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20743869096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046428' AND ZDEPOSIT='000530000777397' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250399' AND ZDEPOSIT='000450000703859' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250344' AND ZDEPOSIT='000450000682143' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046655' AND ZDEPOSIT='000530000778900' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20477088096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046639' AND ZDEPOSIT='000530000778783' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380009759' AND ZDEPOSIT='390103800097599' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20464094096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20486253096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20726666096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20630009096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20454558096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739636096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20411558096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20712690096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20515317096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692330096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250445' AND ZDEPOSIT='000450000739755' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593777096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20531140096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20614201096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20744479096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000271' AND ZDEPOSIT='0004900C59640I1' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691407096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20574637096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20548805096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046510' AND ZDEPOSIT='000530000777090' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046588' AND ZDEPOSIT='000530000778621' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20534433096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20562327096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718705096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20612932096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18605822097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249622' AND ZDEPOSIT='000450000577476' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20518345096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250307' AND ZDEPOSIT='000450000690334' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250026' AND ZDEPOSIT='000450000619047' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250383' AND ZDEPOSIT='000450000464914' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20502307096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691696096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000303' AND ZDEPOSIT='001520240387054' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046374' AND ZDEPOSIT='000530000734019' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450143096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18606242097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711254096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20636188096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20575287096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0652829000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20456934096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250393' AND ZDEPOSIT='000450000479263' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711841096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20542238096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20422043096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20462999096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20681499096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20613427096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20506811096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0656331000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20447339096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20618947096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20709233096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0645887000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250501' AND ZDEPOSIT='000450000479263' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607380097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250428' AND ZDEPOSIT='000450000656980' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20645775096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249952' AND ZDEPOSIT='000450000763019' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20459482096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593447096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250266' AND ZDEPOSIT='000450000777035' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654595096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20620448096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250395' AND ZDEPOSIT='000450000479263' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250552' AND ZDEPOSIT='000450000774376' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20621073096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046394' AND ZDEPOSIT='000530000591609' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710785096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20603063096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0651268000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046537' AND ZDEPOSIT='000530000742000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250309' AND ZDEPOSIT='000450000739300' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20587894096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20737820096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691613096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20562350096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250174' AND ZDEPOSIT='000450000777312' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046650' AND ZDEPOSIT='000530000778844' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20533674096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20491311096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250144' AND ZDEPOSIT='000450000464215' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046646' AND ZDEPOSIT='000530000772405' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18613511097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20416797096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20447032096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249014' AND ZDEPOSIT='000450000771906' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20507108096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046627' AND ZDEPOSIT='000530000508723' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20717244096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030643' AND ZDEPOSIT='363603800306431' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046059' AND ZDEPOSIT='000530000774133' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20540133096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20586052096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20582218096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000326' AND ZDEPOSIT='001520240435480' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20469861096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20656038096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20598248096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20491600096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20482153096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20474200096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20686191096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046444' AND ZDEPOSIT='000530000671403' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0654545000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249918' AND ZDEPOSIT='000450000520796' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20723796096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20696794096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000303' AND ZDEPOSIT='001520240387053' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046120' AND ZDEPOSIT='000530000763835' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20722160096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20548409096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046614' AND ZDEPOSIT='000530000778700' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20546817096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20520242096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20612379096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046557' AND ZDEPOSIT='000530000772819' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20744149096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607950097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249097' AND ZDEPOSIT='000450000640795' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20508064096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250353' AND ZDEPOSIT='000450000500392' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20509930096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20467352096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118090' AND ZDEPOSIT='000510000778442' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046460' AND ZDEPOSIT='000530000734782' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20532940096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20445713096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611143097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20464243096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739834096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729488096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20536438096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20693098096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20687447096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20532999096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249702' AND ZDEPOSIT='000450000775719' THEN 1
		-- WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20451117096' AND ZDEPOSIT='000000000000000' THEN 1 -- 07/05 - Reunião com SB e RC acerca das categorias B.1. e A.11.5. / Excluimos esta operação 
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20679535096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20417910096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000369' AND ZDEPOSIT='001520240499273' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20621693096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20562061096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046391' AND ZDEPOSIT='000530000752998' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046496' AND ZDEPOSIT='000530000674444' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20685730096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20703715096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20722111096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20715446096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20480116096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20715198096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250228' AND ZDEPOSIT='000450000777815' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046393' AND ZDEPOSIT='000530000745916' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718903096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20666300096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20465034096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20700380096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20730627096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611119097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450036096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728258096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20467501096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20430681096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20635552096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0657604000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20638655096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20673330096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20409750096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20560107096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20459334096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20438528096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250185' AND ZDEPOSIT='000450000646541' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046523' AND ZDEPOSIT='000530000746423' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250249' AND ZDEPOSIT='000450000777784' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250442' AND ZDEPOSIT='000450000755687' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655980096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20512744096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20596150096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20700430096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20600390096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046658' AND ZDEPOSIT='000530000687784' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250458' AND ZDEPOSIT='000450000765471' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046592' AND ZDEPOSIT='000530000778534' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20724109096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20727730096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046468' AND ZDEPOSIT='000530000672437' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20623947096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607406097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000369' AND ZDEPOSIT='001520240499274' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250396' AND ZDEPOSIT='000450000479263' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20542451096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20534862096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718069096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20690607096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20650536096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046554' AND ZDEPOSIT='000530000767409' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046375' AND ZDEPOSIT='000530000777331' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118088' AND ZDEPOSIT='000510000676660' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250243' AND ZDEPOSIT='000450000776076' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20678099096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20525225096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20435078096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20514591096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20530183096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739735096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046593' AND ZDEPOSIT='000530000507721' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046489' AND ZDEPOSIT='000530000678935' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20644315096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20480371096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000326' AND ZDEPOSIT='001520240435479' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20598743096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20645486096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20627161096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20567144096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20562673096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721709096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573746096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046471' AND ZDEPOSIT='000530000777797' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046386' AND ZDEPOSIT='000530000777415' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20520259096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20622287096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20498506096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0651269000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654009096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692538096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046635' AND ZDEPOSIT='000530000738417' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250452' AND ZDEPOSIT='000450000507008' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654058096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250557' AND ZDEPOSIT='000450000778577' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046629' AND ZDEPOSIT='000530000778611' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118099' AND ZDEPOSIT='000510000779117' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20523592096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20671268096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20613476096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20408976096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250134' AND ZDEPOSIT='000450000777515' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250102' AND ZDEPOSIT='000450000527837' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20441050096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250161' AND ZDEPOSIT='000450000741255' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250311' AND ZDEPOSIT='000450000658389' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20459433096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250215' AND ZDEPOSIT='000450000693478' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250246' AND ZDEPOSIT='000450000623414' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20667712096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610368097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046418' AND ZDEPOSIT='000530000777315' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20726989096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20508585096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250291' AND ZDEPOSIT='000450000777918' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418348096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20700166096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20626700096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607992097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614139097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20606504096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250507' AND ZDEPOSIT='000450000777597' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00005800040' AND ZDEPOSIT='PTPWDBOM0009000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046545' AND ZDEPOSIT='000530000778337' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046568' AND ZDEPOSIT='000530000778069' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20693916096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000271' AND ZDEPOSIT='001520240310181' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250191' AND ZDEPOSIT='000450000770015' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655956096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20521539096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0648089000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20602933096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046502' AND ZDEPOSIT='000530000734792' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250240' AND ZDEPOSIT='000450000463688' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20549175096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20521117096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000326' AND ZDEPOSIT='0004900C59640I1' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20624143096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20459367096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20515382096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20410055096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20523568096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20437116096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20620109096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250018' AND ZDEPOSIT='000450000111159' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20636519096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607398097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607976097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20745823096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046455' AND ZDEPOSIT='000530000777766' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20645544096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250068' AND ZDEPOSIT='000450000482167' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603488097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20606777096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0646093000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046481' AND ZDEPOSIT='000530000672482' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046312' AND ZDEPOSIT='000530000774981' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20586698096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20683388096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20480611096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593694096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046550' AND ZDEPOSIT='000530000775747' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250233' AND ZDEPOSIT='000450000685443' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250154' AND ZDEPOSIT='000450000655732' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20457197096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000271' AND ZDEPOSIT='001520240310182' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20408539096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718614096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20618384096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000303' AND ZDEPOSIT='0004900C59640I1' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20481221096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655675096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524822096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046398' AND ZDEPOSIT='000530000524393' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046392' AND ZDEPOSIT='000530000744192' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655840096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250394' AND ZDEPOSIT='000450000479263' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250169' AND ZDEPOSIT='000450000537073' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046527' AND ZDEPOSIT='000530000746907' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250356' AND ZDEPOSIT='000450000777388' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20429451096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20740949096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450861096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20567037096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710488096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718713096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046598' AND ZDEPOSIT='000530000562271' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046584' AND ZDEPOSIT='000530000729965' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20701941096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711585096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20681788096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250148' AND ZDEPOSIT='000450000661609' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18608008097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20549084096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20610969096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593207096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728720096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118089' AND ZDEPOSIT='000510000663003' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20622584096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250444' AND ZDEPOSIT='000450000777846' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573498096' AND ZDEPOSIT='000000000000000' THEN 0.12
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250194' AND ZDEPOSIT='000450000320437' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046467' AND ZDEPOSIT='000530000473183' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654454096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20523691096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20725767096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20493960096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20437967096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046507' AND ZDEPOSIT='000530000777942' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654611096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20548219096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250047' AND ZDEPOSIT='000450000479262' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20620802096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250234' AND ZDEPOSIT='000450000511064' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691043096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20741236096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250294' AND ZDEPOSIT='000450000735077' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20540315096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046572' AND ZDEPOSIT='000530000738417' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20668371096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046448' AND ZDEPOSIT='000530000777622' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654306096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20571542096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654892096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20516315096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380009711' AND ZDEPOSIT='390103800097119' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418173096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250031' AND ZDEPOSIT='000450000774332' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250343' AND ZDEPOSIT='000450000738505' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20671730096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250447' AND ZDEPOSIT='000450000775362' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20652391096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20724695096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046323' AND ZDEPOSIT='000530000610953' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046350' AND ZDEPOSIT='000530000694857' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20699194096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20424130096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20457247096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20559885096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20650148096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20585807096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710207096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046521' AND ZDEPOSIT='000530000691867' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250001' AND ZDEPOSIT='000450000746382' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046335' AND ZDEPOSIT='000530000777001' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20422902096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250126' AND ZDEPOSIT='000450000661755' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20571583096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20621420096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20501333096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000232081' AND ZDEPOSIT='000450000777668' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20624036096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20591862096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654926096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20557228096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20471461096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593033096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20587878096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250204' AND ZDEPOSIT='000450000657028' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046499' AND ZDEPOSIT='000530000777981' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20487491096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0654529000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20553599096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046631' AND ZDEPOSIT='000530000778473' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249679' AND ZDEPOSIT='000450000666600' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20673272096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20566641096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711171096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20736806096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20647771096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20740444096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20472725096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418058096' AND ZDEPOSIT='000000000000000' THEN 0.6
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046575' AND ZDEPOSIT='000530000778347' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20606363096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20592530096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046351' AND ZDEPOSIT='000530000694857' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20599675096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249959' AND ZDEPOSIT='000450000701482' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250388' AND ZDEPOSIT='000450000777979' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250596' AND ZDEPOSIT='000450000101714' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20727177096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046429' AND ZDEPOSIT='000530000777471' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250143' AND ZDEPOSIT='000450000769750' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20482328096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20746110096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20632211096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20461470096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046477' AND ZDEPOSIT='000530000678664' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046419' AND ZDEPOSIT='000530000777517' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654082096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046443' AND ZDEPOSIT='000530000661077' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573928096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418827096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046566' AND ZDEPOSIT='000530000778437' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18606226097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20722335096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721469096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0652833000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20564000096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250375' AND ZDEPOSIT='000450000593526' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614501097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20630140096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20430269096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046576' AND ZDEPOSIT='000530000778633' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20436720096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20724364096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20629001096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692884096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20705603096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20447115096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20477104096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20504410096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250216' AND ZDEPOSIT='000450000693152' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20477070096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20575246096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249035' AND ZDEPOSIT='000450000757852' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250398' AND ZDEPOSIT='000450000479263' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20540588096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610376097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20519087096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20513528096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20410469096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20709480096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20507355096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046590' AND ZDEPOSIT='000530000778327' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20717962096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20455837096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20417563096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250236' AND ZDEPOSIT='000450000777267' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20710751096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20619036096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20604624096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20745146096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524145096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20703012096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20440375096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20417258096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20456157096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249743' AND ZDEPOSIT='000450000470349' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20679055096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250166' AND ZDEPOSIT='000450000679140' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18599454097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20540786096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20522214096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250270' AND ZDEPOSIT='000450000756441' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20570684096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20663414096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046473' AND ZDEPOSIT='000530000777658' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654413096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739487096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20557921096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046384' AND ZDEPOSIT='000530000776939' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20449525096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20476791096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20515135096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046466' AND ZDEPOSIT='000530000740306' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20611017096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046637' AND ZDEPOSIT='000530000753461' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20506589096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20746458096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046441' AND ZDEPOSIT='000530000478830' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20611082096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='000007400192000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046607' AND ZDEPOSIT='000530000777884' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611192097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20490750096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250457' AND ZDEPOSIT='000450000778175' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20471289096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20418884096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20410832096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611929097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20466750096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20625173096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20653092096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711403096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0657588000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20599741096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20524111096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20691274096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20659784096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046605' AND ZDEPOSIT='000530000751301' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611135097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728142096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20659792096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20652078096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20432703096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20629233096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20520226096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20590187096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20551361096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20537519096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046616' AND ZDEPOSIT='000530000776714' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046621' AND ZDEPOSIT='000530000778470' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728829096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249937' AND ZDEPOSIT='000450000776704' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20535414096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046512' AND ZDEPOSIT='000530000771105' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20553110096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20525480096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20711635096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046503' AND ZDEPOSIT='000530000775589' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20574223096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721592096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250093' AND ZDEPOSIT='000450000769333' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20745351096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20415054096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250498' AND ZDEPOSIT='000450000615853' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20662648096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18613388097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20559505096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046531' AND ZDEPOSIT='000530000778105' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000369' AND ZDEPOSIT='0004900C59640I1' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20695523096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20451158096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20423413096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20705330096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20516463096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20428958096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046491' AND ZDEPOSIT='000530000777763' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20480074096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20498746096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250322' AND ZDEPOSIT='000450000582346' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20734223096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046494' AND ZDEPOSIT='000530000771644' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20441381096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20514849096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20394531096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20557913096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20430087096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046431' AND ZDEPOSIT='000530000479569' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20416466096' AND ZDEPOSIT='000000000000000' THEN 0.6
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250158' AND ZDEPOSIT='000450000777542' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046423' AND ZDEPOSIT='000530000761678' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250118' AND ZDEPOSIT='000450000465865' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20594148096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611812097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18606952097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18611127097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046565' AND ZDEPOSIT='000530000776977' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20574512096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573845096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250100' AND ZDEPOSIT='000450000605797' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20728944096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20545306096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046504' AND ZDEPOSIT='000530000764463' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729439096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20613872096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250287' AND ZDEPOSIT='000450000693659' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20561527096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250425' AND ZDEPOSIT='000450000778229' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20464904096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20531215096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20593421096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046501' AND ZDEPOSIT='000530000601814' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20646864096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250338' AND ZDEPOSIT='000450000665310' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20519525096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20651989096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20612726096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250041' AND ZDEPOSIT='000450000677689' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20590153096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603504097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20704796096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20709803096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20489281096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20739594096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20717830096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20725650096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250103' AND ZDEPOSIT='000450000645721' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18608263097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250525' AND ZDEPOSIT='000450000772607' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20437694096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20627922096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20561659096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20648753096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20718598096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250313' AND ZDEPOSIT='000450000661942' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20471875096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20714571096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20568654096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20548896096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20724851096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20517529096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250432' AND ZDEPOSIT='000450000740236' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00005800040' AND ZDEPOSIT='PTEDA4OM0001000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20647045096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20429832096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20451166096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20596911096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721212096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20478136096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046582' AND ZDEPOSIT='000530000778576' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20417092096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20486717096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20616164096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20464235096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20727821096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20721071096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20632419096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20518055096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20563002096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250569' AND ZDEPOSIT='000450000621375' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250059' AND ZDEPOSIT='000450000402549' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18608354097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250044' AND ZDEPOSIT='000450000776999' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20609227096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20675509096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20465760096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20638861096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046497' AND ZDEPOSIT='000530000104782' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20620828096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249975' AND ZDEPOSIT='000450000773031' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20448824096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20487087096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20469895096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20607916096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20663208096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20429766096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20569405096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250306' AND ZDEPOSIT='000450000777994' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20101258096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00005118094' AND ZDEPOSIT='000510000778293' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20627641096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20638275096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20400098096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614105097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20510847096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20643721096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046378' AND ZDEPOSIT='000530000698628' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249698' AND ZDEPOSIT='000450000531229' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614097097' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20740410096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20551379096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20461355096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20447081096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20592449096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046449' AND ZDEPOSIT='000530000777627' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20573589096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20431754096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046596' AND ZDEPOSIT='000530000775529' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20741046096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20602917096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20631312096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20665351096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20608781096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20440102096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250492' AND ZDEPOSIT='000450000666078' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20499504096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0656333000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20504527096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20462726096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046511' AND ZDEPOSIT='000530000771105' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450929096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20599824096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20392360096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250643' AND ZDEPOSIT='000450000674536' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20570312096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20566328096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046420' AND ZDEPOSIT='000530000776873' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20450481096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046352' AND ZDEPOSIT='000530000775774' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250301' AND ZDEPOSIT='000450000776616' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20625090096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20664016096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20673165096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20416573096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20734777096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046425' AND ZDEPOSIT='000530000609702' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20609409096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046606' AND ZDEPOSIT='000530000778327' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20546668096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20696844096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250631' AND ZDEPOSIT='000450000738842' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20474358096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249934' AND ZDEPOSIT='000450000320597' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20599360096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20423009096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20591102096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20655824096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250265' AND ZDEPOSIT='000450000751110' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046457' AND ZDEPOSIT='000530000768050' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249946' AND ZDEPOSIT='000450000777033' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250588' AND ZDEPOSIT='000450000612203' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20511381096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20654157096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20736715096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20495536096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20621156096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20692207096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20496435096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046381' AND ZDEPOSIT='000530000660314' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250241' AND ZDEPOSIT='000450000740703' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20631478096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046442' AND ZDEPOSIT='000530000777715' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729728096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20371372096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20541933096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20744230096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250456' AND ZDEPOSIT='000450000778166' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046349' AND ZDEPOSIT='000530000694857' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250427' AND ZDEPOSIT='000450000778145' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20586987096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20647227096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046601' AND ZDEPOSIT='000530000778027' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20458807096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000250096' AND ZDEPOSIT='000450000730739' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249848' AND ZDEPOSIT='000450000476492' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000001085' AND ZDEPOSIT='PC0648083000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046370' AND ZDEPOSIT='000530000777185' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20702659096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20495825096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046462' AND ZDEPOSIT='000530000700116' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046628' AND ZDEPOSIT='000530000778514' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20653407096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20552252096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20433081096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20519731096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20729751096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20429162096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20598479096' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00008046498' AND ZDEPOSIT='000530000469296' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584001097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19540052096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19484855096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580686097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='14206154096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20398086096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17789792096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970188096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603074097' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000338' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19186658096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18719830096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000918' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18922996096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17691576096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249673' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18579522097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18578946097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17776336096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000069' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19279693096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030582' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15866485096' THEN 0.7
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17615609096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18587996097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584530097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17985283096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18587970097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='14246804096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609295097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='13618128096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='16573411096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18230911096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00177714007' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18719749096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18848894096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17221713096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18574762097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581940097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17738088096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610152097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20201868096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='16256835096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030444' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584134097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17985440096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18605145097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17988048096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20176433096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970006096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580082097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000913' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970329096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18782002096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18117340096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584829097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17195834096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00155769007' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970261096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00146552007' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000938' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19899151096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030546' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18589430097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177027096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000189' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17456178096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17789768096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18578102097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19467223096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='10854551096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18631522096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030598' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000374' THEN 0.05
		WHEN CEMPRESA='31' AND CBALCAO='2392' AND CNUMECTA='00062468020' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18529429096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18582393097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18583672097' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000392' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15745168096' THEN 0.5518
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380029937' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17092288096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030299' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18598241097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17099127096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18617538097' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000200' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18602936097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20356902096' THEN 0.83
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15697617096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000104' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603025097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='16573239096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17988162096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19200590096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20210000167' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000248863' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000046' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18617026096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17949420096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17615633096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18061290096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18577054097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15971459096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580520097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18599181097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18527555096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580181097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17984898096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18421551096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000519' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18583888097' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000433' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15680068096' THEN 0.37
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18589422097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18592467097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18752930096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177076096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609287097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00005800040' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17191858096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17892174096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18006550096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19567360096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20082102096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20230000005' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17943282096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581866097' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000076' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18015098096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00177706007' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17894030096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18588028097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20176607096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20210000166' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18605897097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18582302097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970121096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18574218097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581494097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609261097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18507177096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18716661096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18575959097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15868994096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970212096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18471762096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18577849097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581916097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584910097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18617835097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970279096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17734145096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20200000282' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18586329097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18582856097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18585610097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970345096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609303097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580702097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18578672097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970428096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18061704096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18719509096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970238096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18580736097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17864504096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030145' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970469096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18574804097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18579902097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581890097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17988014096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584472097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19725695096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20240000211' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18708411096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970139096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581924097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177472096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030438' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19260578096' THEN 0.73
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18850452096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17587055096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18602886097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18320845096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607208097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17984740096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609246097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6636' AND CNUMECTA='00380030480' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20193511096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18578680097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00117215007' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177555096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609253097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970402096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18585560097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18609238097' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='00000249672' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18573699097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='19748267096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='17988238096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18455971096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20140124096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='00155736007' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607273097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18581874097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18607984097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='15970311096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18598373097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18710680096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000518' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610350097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='13098164096' THEN 1
		WHEN CEMPRESA='89' AND CBALCAO='0000' AND CNUMECTA='20220000078' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18603645097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18614568097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000824' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='20177605096' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18582849097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='6416' AND CNUMECTA='00000000914' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18610558097' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='18584662097' THEN 1
		WHEN CEMPRESA='80' AND CBALCAO='6416' AND ZDEPOSIT='335785840000000' THEN 1
		WHEN CEMPRESA='80' AND CBALCAO='6416' AND ZDEPOSIT='504121590000000' THEN 1
		WHEN CEMPRESA='80' AND CBALCAO='6416' AND ZDEPOSIT='521431150000000' THEN 1
		WHEN CEMPRESA='80' AND CBALCAO='6416' AND ZDEPOSIT='336426400000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0003' AND CNUMECTA='54960380020' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND CBALCAO='0000' AND CNUMECTA='21661935001' AND ZDEPOSIT='000000000000000' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880441640' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423280' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880378030' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820426880' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880453120' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423300' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880440190' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880447100' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880412130' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423310' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304890421450' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880441620' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423340' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880419800' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423140' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880441610' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880438000' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423320' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423150' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880437990' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423160' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423050' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820426870' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880429700' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820433740' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880424410' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880432120' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423200' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880441630' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880427010' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423270' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880428400' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820433730' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423290' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820433890' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880428430' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880436270' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820434610' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423260' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880402110' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880407580' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880398940' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820433900' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820451180' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304890435500' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880427230' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423210' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880435030' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820364880' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880419270' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423190' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423180' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423060' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423030' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423040' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423000' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820434630' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423120' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423020' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880407590' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423010' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880419810' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880444710' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880402100' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304820399500' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880457370' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880444350' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880427990' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423170' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880398950' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423220' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880366120' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880418860' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880438140' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880423330' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880444100' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880436280' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880430130' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880419020' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880447060' THEN 1
		WHEN CEMPRESA='31' AND ZDEPOSIT='962304880447600' THEN 1
	END AS PERC_OP	
FROM CD_CAPTOOLS.CT085_UNIV_CTO_D
WHERE ref_date='${ref_date}'


;
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 98. QUERY AUXILIAR PAIS E FILHOS - (APENAS 1 ITERAÇÃO)
--------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT NIVEL 
FROM
    (
    SELECT DISTINCT NIVEL_1 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0)) IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_2 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_3 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_4 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_5 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_6 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_7 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_8 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_0))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_2 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_3 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_4 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_5 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_6 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_7 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_8 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_1))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_3 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_4 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_5 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_6 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_7 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_8 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_2))IN ('${ckmetamis}')

    UNION ALL SELECT DISTINCT NIVEL_4 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_5 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_6 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_7 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_8 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_3))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_5 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_4))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_6 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_4))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_7 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_4))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_8 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_4))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_4))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_4))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_4))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_4))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_6 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_5))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_7 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_5))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_8 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_5))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_5))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_5))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_5))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_5))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_7 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_6))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_8 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_6))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_6))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_6))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_6))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_6))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_8 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_7))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_7))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_7))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_7))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_7))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_9 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND  TRIM(UPPER(NIVEL_8))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_8))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_8))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_8))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_10 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_9))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_9))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_9))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_11 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_10))IN ('${ckmetamis}')
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_10))IN ('${ckmetamis}')
    
    UNION ALL SELECT DISTINCT NIVEL_12 AS NIVEL FROM cd_captools.ct011_dim_hier WHERE ref_date = '2024-12-31' AND id_dimensao = 1 AND TRIM(UPPER(NIVEL_11))IN ('${ckmetamis}')
    )AUX
;

