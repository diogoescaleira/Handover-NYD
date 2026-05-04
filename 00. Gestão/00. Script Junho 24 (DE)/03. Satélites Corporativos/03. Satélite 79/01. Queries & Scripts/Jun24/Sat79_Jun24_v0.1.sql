------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Operações Gerais ----------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select sum(amount) from(
select amount
 from bu_esg_work.rf_sat79_Jun24_aux11)a
; 

 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- maturity_esg, european_union, performing_esg, env_sust_ccm, excluded_paris, cnael, nace_Esg--------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Piloto Jun23 ==> 35 217 017 901,861991€ (Universo Full s/ MC10)
--              ==> 2 083 518 registos 
--              ==> 35 217 015 723,870027915889 €

-- Exerci Dez23 ==> 34 546 622 606,9271 € (Universo Full s/ MC10)
--              ==> 2 024 200  registos 
--              ==> 34 546 620 644,594329568995 € sum(amount)

-- Exerci Dez23 v2 ==> 2024202 | 34 598 882 682.944329568995   (diferença de 1962.33 para o full)

-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux1;
create table bu_esg_work.rf_sat79_Jun24_aux1 as

select 																		 
        a.*,
        b.zcliente,
        b.`28_dt_maturity`,
 
		case
			 when a.idcomb_satelite like '%MC06%' then 'MESG4' -- regra corporação de acordo com satelite_strucutre
			 when a.idcomb_satelite like '%MC08%' then 'MESG4' -- regra corporação adicionada no piloto de jun23 para investments in subsidiaries pro tyva02 não devemos ter posso usar `17_accumulated_impairment`?
			 when fr802.flag_mesg5 = 1 then 'MESG5'	 -- Counterparty having the choice of the repayment date
			 when b.`28_dt_maturity` < "${ref_date}" then 'MESG1' -- contratos com maturidade inferior ao rácio => 1º bucket, validado com corporação e regras das guidelines							
			 when b.`28_dt_maturity` in ('','0001-01-01','9999-12-31',null) and a.idcomb_satelite like '%MC02%' and a.idcomb_satelite like '%COLL2%' then 'MESG4'
			 when b.`28_dt_maturity` in ('','0001-01-01','9999-12-31',null) and a.idcomb_satelite like '%MC02%' and a.idcomb_satelite like '%COLL3%' then 'MESG1'
			 when b.`28_dt_maturity` in ('','0001-01-01','9999-12-31',null) and a.idcomb_satelite like '%MC02%' and a.idcomb_satelite not like '%COLL2%' and a.idcomb_satelite not like '%COLL3%' then 'MESG1'
			 when b.`28_dt_maturity` in ('','0001-01-01','9999-12-31',null) and a.idcomb_satelite like '%MC04%' then 'MESG1'
			 when b.`28_dt_maturity` in ('','0001-01-01','9999-12-31',null) then 'MESG6'
			 when round(datediff(to_date(b.`28_dt_maturity`), to_date('${ref_date}'))/365.25,4) <= 05 then 'MESG1'
			 when round(datediff(to_date(b.`28_dt_maturity`), to_date('${ref_date}'))/365.25,4) <= 10 then 'MESG2'
			 when round(datediff(to_date(b.`28_dt_maturity`), to_date('${ref_date}'))/365.25,4) <= 20 then 'MESG3'
			 when round(datediff(to_date(b.`28_dt_maturity`), to_date('${ref_date}'))/365.25,4) > 20 then 'MESG4'
			 else 'MESG6'
			 end as maturity_esg,	 

        case
            when a.idcomb_satelite like '%MC06%'                                                        then 0		--Exclusão de equity
			when a.idcomb_satelite like '%MC08%'                                                        then 0
            when fr802.flag_mesg5 = 1                                                                   then 0		--Exclusão de counterparty having the choice of repayment date
            when b.`28_dt_maturity` in ('','0001-01-01','9999-12-31',null)                              then 0
            when b.`28_dt_maturity` < "${ref_date}"                                                     then 0
            when round(datediff(to_date(b.`28_dt_maturity`), to_date("${ref_date}"))/365.25,4) <= 05    then 1
            when round(datediff(to_date(b.`28_dt_maturity`), to_date("${ref_date}"))/365.25,4) <= 10    then 1
            when round(datediff(to_date(b.`28_dt_maturity`), to_date("${ref_date}"))/365.25,4) <= 20    then 1
            when round(datediff(to_date(b.`28_dt_maturity`), to_date("${ref_date}"))/365.25,4) >  20    then 1
            else 0			
        end as flag_maturity,

		case 
            when b.`28_dt_maturity` in ('','0001-01-01','9999-12-31',null) then null
            when fr802.flag_mesg5 = 1 then null
            when b.`28_dt_maturity` < "${ref_date}" then null
            else round(datediff(to_date(b.`28_dt_maturity`), to_date("${ref_date}"))/365.25, 4)
        end as years_to_maturity,

		case													
			when b.`93_european_union`='Y' then 'EU1'
			when b.`93_european_union`='N' then 'EU2'
		else '' end as european_union,
				
		case
			when idcomb_satelite like '%MC02;ACPF3%' AND idcomb_satelite like '%PFV1%' then 'PERF1' 			
			when idcomb_satelite like '%MC02;ACPF3%' AND idcomb_satelite like '%PFV2%' then 'PERF2' 
			when idcomb_satelite like '%MC02;ACPF4%' AND idcomb_satelite like '%PFV1%' then 'PERF1' 
			when idcomb_satelite like '%MC02;ACPF4%' AND idcomb_satelite like '%PFV2%' then 'PERF2' 
			
			when idcomb_satelite like '%MC04;ACPF3%' AND idcomb_satelite like '%PFV1%' then 'PERF1' 
			when idcomb_satelite like '%MC04;ACPF3%' AND idcomb_satelite like '%PFV2%' then 'PERF2' 
			when idcomb_satelite like '%MC04;ACPF4%' AND idcomb_satelite like '%PFV1%' then 'PERF1' 
			when idcomb_satelite like '%MC04;ACPF4%' AND idcomb_satelite like '%PFV2%' then 'PERF2' 
			
			when idcomb_satelite like '%MC02;ACPF5%' AND idcomb_satelite like '%STAG1%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC02;ACPF5%' AND idcomb_satelite like '%STAG1%' AND idcomb_satelite like '%DEFA2%' then 'PERF1'			
			when idcomb_satelite like '%MC02;ACPF5%' AND idcomb_satelite like '%STAG2%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC02;ACPF5%' AND idcomb_satelite like '%STAG2%' AND idcomb_satelite like '%DEFA2%' then 'PERF1'
			when idcomb_satelite like '%MC02;ACPF5%' AND idcomb_satelite like '%STAG3%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC02;ACPF5%' AND idcomb_satelite like '%STAG3%' AND idcomb_satelite like '%DEFA2%' then 'PERF2'
			
			when idcomb_satelite like '%MC02;ACPF6%' AND idcomb_satelite like '%STAG1%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC02;ACPF6%' AND idcomb_satelite like '%STAG1%' AND idcomb_satelite like '%DEFA2%' then 'PERF1'
			when idcomb_satelite like '%MC02;ACPF6%' AND idcomb_satelite like '%STAG2%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC02;ACPF6%' AND idcomb_satelite like '%STAG2%' AND idcomb_satelite like '%DEFA2%' then 'PERF1'
			when idcomb_satelite like '%MC02;ACPF6%' AND idcomb_satelite like '%STAG3%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC02;ACPF6%' AND idcomb_satelite like '%STAG3%' AND idcomb_satelite like '%DEFA2%' then 'PERF2'
			
			when idcomb_satelite like '%MC04;ACPF5%' AND idcomb_satelite like '%STAG1%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC04;ACPF5%' AND idcomb_satelite like '%STAG1%' AND idcomb_satelite like '%DEFA2%' then 'PERF1'
			when idcomb_satelite like '%MC04;ACPF5%' AND idcomb_satelite like '%STAG2%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC04;ACPF5%' AND idcomb_satelite like '%STAG2%' AND idcomb_satelite like '%DEFA2%' then 'PERF1'
			when idcomb_satelite like '%MC04;ACPF5%' AND idcomb_satelite like '%STAG3%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC04;ACPF5%' AND idcomb_satelite like '%STAG3%' AND idcomb_satelite like '%DEFA2%' then 'PERF2'
			
			when idcomb_satelite like '%MC04;ACPF6%' AND idcomb_satelite like '%STAG1%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC04;ACPF6%' AND idcomb_satelite like '%STAG1%' AND idcomb_satelite like '%DEFA2%' then 'PERF1'
			when idcomb_satelite like '%MC04;ACPF6%' AND idcomb_satelite like '%STAG2%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC04;ACPF6%' AND idcomb_satelite like '%STAG2%' AND idcomb_satelite like '%DEFA2%' then 'PERF1'
			when idcomb_satelite like '%MC04;ACPF6%' AND idcomb_satelite like '%STAG3%' AND idcomb_satelite like '%DEFA1%' then 'PERF2'
			when idcomb_satelite like '%MC04;ACPF6%' AND idcomb_satelite like '%STAG3%' AND idcomb_satelite like '%DEFA2%' then 'PERF2'			
			else ''
		end as performing_esg,
				
        b.`22_counterparty_nuts`,
        b.`23_counterparty_zipcode`,
        b.`14_nace`,
        b.`15_nace_esg` as nace_esg_orig,
        b.`12_non_performing`,
        b.`17_accumulated_impairment`,
        b.`30_stage_ifrs9`,
        b.`51_client_own_funds`,
        b.`75_isin`,
        b.cpais_residencia,		
		b.`5_collateral_zip_code`,
        b.`4_collateral_nuts`,
        b.`16_percent_collateral`,
		b.`33_counterparty_type`,	
		
        case
            when (a.idcomb_satelite like '%SC0303%' or trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras') 
				 and paris.zcliente is not null  then 'EXC1' --Excluído
            when (a.idcomb_satelite like '%SC0303%' or trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras')  then 'EXC2' --Não excluído
			else ''
        end as excluded_paris,
		
		case 
            when substr(b.`14_nace`,1,1) = 'A' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL1'
            when substr(b.`14_nace`,1,1) = 'B' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL2'
            when substr(b.`14_nace`,1,1) = 'C' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL3'
            when substr(b.`14_nace`,1,1) = 'D' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL4'
            when substr(b.`14_nace`,1,1) = 'E' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL5'
            when substr(b.`14_nace`,1,1) = 'F' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL6'
            when substr(b.`14_nace`,1,1) = 'G' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL7'
            when substr(b.`14_nace`,1,1) = 'H' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL8'
            when substr(b.`14_nace`,1,1) = 'I' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL9'
            when substr(b.`14_nace`,1,1) = 'J' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL10'
            when substr(b.`14_nace`,1,1) = 'L' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL11'
            when substr(b.`14_nace`,1,1) = 'M' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL12'  
            when substr(b.`14_nace`,1,1) = 'N' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL13'
            when substr(b.`14_nace`,1,1) = 'O' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL14'
            when substr(b.`14_nace`,1,1) = 'P' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL15'
            when substr(b.`14_nace`,1,1) = 'Q' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL16'
            when substr(b.`14_nace`,1,1) = 'R' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL17'
            when substr(b.`14_nace`,1,1) = 'S' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
            when trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
			when trim(b.`33_counterparty_type`) = '' and idcomb_satelite like '%SC0303%' then 'CNAEL18'		--Adicionada nova linha de código. Validado com Luísa
            else ''
        end as CNAEL,
				
        case
            when trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' and nace_esg.nace_level4 is not null then nace_esg.ID
            when trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'NACE19010303' --Nace default disponibilizado pela corporação
            when trim(b.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' and nace_esg.nace_level4 is not null then nace_esg.ID	
            when trim(b.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' then 'NACE19010303' --Nace default disponibilizado pela corporação
            else ''									
        end as nace_esg,	
		-- Adicionado no piloto jun23
		case 
        	when ((a.idcomb_satelite like '%SC02%') OR (b.`33_counterparty_type` = 'instituicoes de credito')) and idcomb_satelite like '%MC08%' then 'INVS2'
        	when ((a.idcomb_satelite like '%SC0301%') OR (b.`33_counterparty_type` = 'setor publico')) and idcomb_satelite like '%MC08%' then 'INVS3'
        	when ((a.idcomb_satelite like '%SC0302%')  OR (b.`33_counterparty_type` = 'outras instituicoes financeiras')) and idcomb_satelite like '%MC08%' then 'INVS4'
        	when ((a.idcomb_satelite like '%SC0303%')  OR (b.`33_counterparty_type` = 'outras empresas nao financeiras')) and idcomb_satelite like '%MC08%' then 'INVS5'
        else '' end as Investment_Sector,

        peso,        
        case 
            when b.ckbalbem is null then 0
            else 1
        end as flag_hipotec,
        b.ckbalbem,
        b.ckctabem,
        b.ckrefbem,
        saldo_ct*peso as amount

from (select *
        from bu_esg_work.rf_pilar3_universo_full where DT_RFRNC = '${ref_date}' and id_corrida in (
        select max(id_corrida)
        from bu_esg_work.rf_pilar3_universo_full where DT_RFRNC = '${ref_date}')
        
        and csatelite = 79 and idcomb_satelite not like '%MC10%') as a
				
left join bu_esg_work.reparticao_garantias_final_Jun24_v2 as b
on  a.cempresa_ct = b.cempresa_ct
and a.cbalcao_ct  = b.cbalcao_ct
and a.cnumecta_ct = b.cnumecta_ct
and a.zdeposit_ct = b.zdeposit_ct

left join bu_esg_work.rf_pilar3_pesos_Jun24_v2 as peso						-- Tabela representa o peso de cada colateral face ao total do empréstimo
on  b.cempresa_ct = peso.cempresa_ct
and b.cbalcao_ct  = peso.cbalcao_ct
and b.cnumecta_ct = peso.cnumecta_ct
and b.zdeposit_ct = peso.zdeposit_ct
and coalesce(b.ckbalbem,'0')    = coalesce(peso.ckbalbem, '0')
and coalesce(b.ckctabem,'0')    = coalesce(peso.ckctabem, '0')
and coalesce(b.ckrefbem,'0')    = coalesce(peso.ckrefbem, '0')

left join(select distinct zcliente from 
			(

			--LEI --1
				(select distinct ccliente as zcliente --,* 
				from
					(
					select 'Y' as CIB, * from bu_esg_work.rf_comp_excluded_paris_agree_scib_pilot_Jun23
					union all
					select 'N' as CIB,* from bu_esg_work.rf_comp_excluded_paris_agree_pilot_jun23
					) corp
				inner join 
					(Select distinct ccliente, clei as clei_dwt01, 	gcliente 
					from cd_clientes.dwt001_cliente where data_date_part="${ref_date_util}"
					and trim(clei) <> '') dwt01 --1
				on corp.lei = dwt01.clei_dwt01 
				-- CT003 TEM O UNIVERSO DA DWT01
				---- left join 
				---- (Select distinct zcliente, trim(clei) as clei_ct03 from cd_captools.ct003_univ_cli where ref_date="${ref_date}" 
				---- and trim(clei) <> ''
				---- )ct03 -- 1
				---- on corp.lei = ct03.clei_ct03
				)

			union all

			--ISIN --2
				(select distinct coalesce(zcliente_emitente,zcliente1,zcliente2) as zcliente--,*
				from
					(
					select 'Y' as CIB, * from bu_esg_work.rf_comp_excluded_paris_agree_scib_pilot_Jun23
					union all
					select 'N' as CIB,* from bu_esg_work.rf_comp_excluded_paris_agree_pilot_jun23
					) corp
				
				left join 
					(Select distinct zcliente_emitente, isin as isin_ct610 
					from cd_captools.ct610_titulos where ref_date="${ref_date}"
					and trim(isin) <> '')ct610 --0
				on corp.isin = ct610.isin_ct610
				
				left join 
					(Select distinct lpad(cast(zcliente as string),10,'0') as zcliente1, ctitisin 
					from cd_mercados.ttt35_titlgru where data_date_part="${ref_date_util}"
					and trim(ctitisin)<>'' and zcliente <> 0) tt35_1 --2
				on corp.isin = tt35_1.ctitisin
				
				left join 
					(Select distinct lpad(cast(zcliente as string),10,'0') as zcliente2, cisinref 
					from cd_mercados.ttt35_titlgru where data_date_part="${ref_date_util}"
					and trim(ctitisin)<>'' and zcliente <> 0) tt35_2 --0
				on corp.isin = tt35_2.cisinref
				having zcliente is not null
				)
				
			union all

			--KGL --171
				(select distinct ccliente as zcliente--,* 
				from
					(
					select 'Y' as CIB, * from bu_esg_work.rf_comp_excluded_paris_agree_scib_pilot_Jun23
					union all
					select 'N' as CIB,* from bu_esg_work.rf_comp_excluded_paris_agree_pilot_jun23
					) corp
				inner join 
					(SELECT ccliente,gcli_kgl,centlegal,gnomelegal,cgrupo 
					from cd_riscos.rstf159_rating_interno where data_date_part = "${ref_date_util}"
					and trim(ccliente) not in ('','#')) cib --94
				on corp.kgl_code = cib.centlegal or corp.kgl_code = cib.cgrupo
				)
				
			union all

				(select distinct zcliente  as zcliente--,* 
				from
					(
					select 'Y' as CIB, * from bu_esg_work.rf_comp_excluded_paris_agree_scib_pilot_Jun23
					union all
					select 'N' as CIB,* from bu_esg_work.rf_comp_excluded_paris_agree_pilot_jun23
					) corp
				
				inner join 
					(Select distinct ct70.zcliente, ct70.zgrupo, ct71.kgl5 from 
						(Select * from cd_captools.ct070_univ_gr_cli where ref_date="${ref_date}" and tipo_relacao = 'CONTROLO') ct70
					inner join 
						(Select * from cd_captools.ct071_rwa_gr_ec where ref_date="${ref_date}" and trim(kgl5)<>'') ct71
						on ct70.zgrupo=ct71.zgrupo
					) ct71 --127
				on corp.kgl_code =  ct71.kgl5 
				)

			union all

				(select distinct zcliente  as zcliente--,* 
				from
					(
					select 'Y' as CIB, * from bu_esg_work.rf_comp_excluded_paris_agree_scib_pilot_Jun23
					union all
					select 'N' as CIB,* from bu_esg_work.rf_comp_excluded_paris_agree_pilot_jun23
					) corp
				inner join
					(select zcliente,cptyparent_code, cptylastparent_code from 
						(Select distinct zcliente, trim(ccli_kgl) as ccli_kgl from cd_captools.ct003_univ_cli where ref_date="${ref_date}" 
						and trim(ccli_kgl) <> '')ct03
					inner join 
						(Select * from bu_esg_work.p3_Client_Data_JQUEST ) input
						on trim(input.cpty_code) = trim(ct03.ccli_kgl)
					) kgl_ct03 --42
				on corp.kgl_code =  kgl_ct03.cptyparent_code or  corp.kgl_code =  kgl_ct03.cptylastparent_code
				)
			) union_kgl) paris
	on b.zcliente = paris.zcliente  

-- Identificação de operações que entram no bucket MESG5 (Counterparty having the choice of the repayment date)
left join ( select distinct a.cempresa_ct, 
							a.cbalcao_ct, 
							a.cnumecta_ct, 
							a.zdeposit_ct, 
							1 as flag_mesg5
			 from ( select * from bu_esg_work.rf_pilar3_universo_full where DT_RFRNC = '${ref_date}' and id_corrida in 
			 (select max(id_corrida) from bu_esg_work.rf_pilar3_universo_full where DT_RFRNC = '${ref_date}')) as a 
			
				inner join (select * FROM cd_captools.fr802_pl_contas 
								where cod_plano = 'BST_IND'
								and ref_date = "${ref_date}"
								and (upper(produto) like 'CART%CR%DITO%' 
								or upper(produto) like '%REPOS%' 
								or upper(produto) like '%VISTA, DESCOBERTOS E CO%')) as b
					on a.ifrs_ct = b.conta) as fr802
	on  a.cempresa_ct = fr802.cempresa_ct
	and a.cbalcao_ct  = fr802.cbalcao_ct
	and a.cnumecta_ct = fr802.cnumecta_ct
	and a.zdeposit_ct = fr802.zdeposit_ct

-- Mapeamento para preenchimento do NACE ESG (para empresas não financeiras), que de momento é igual ao NACE
left join bu_esg_work.nace_esg_pillar3 as nace_esg		--Criar tabela de excel a importar com base na nova marcação do excel sat 79 caso mudem os NACE que a corporação envia
on concat(split_part(b.`15_nace_esg`,".",1),split_part(b.`15_nace_esg`,".",2),split_part(b.`15_nace_esg`,".",3)) = trim(split_part(nace_esg.nace_level4, "-",1))		
;

----------------------------------------------------------------------------------------------------------------------------------------------------
-- acute/chronic changes, geography-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

-- Piloto Jun23 ==> 35 217 015 723,870027915889 € saldo (s/ MC10)
--              ==> 2 083 518 registos 

-- Exerci Dez23 ==> 34 546 620 644,594329568995 € sum(amount)
--              ==> 2 024 200 registos 

-- Exerci Dez23 v2 ==> 2024202 | 34 598 882 682.944329568995  

-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux2;
create table bu_esg_work.rf_sat79_Jun24_aux2 as
select  a.*,
        case
            when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'ACUT1' 
            when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'ACUT1'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'ACUT1'
            else 'ACUT2'	
        end as acute_changes,
		
        case
            when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'CHRO1'
            when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'CHRO1'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'CHRO1'
            else 'CHRO2'	
        end as chronic_changes,
		
        case		
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (724) then 'GEO1'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (826) then 'GEO2'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (620) then 'GEO3'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (840) then 'GEO4'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (616) then 'GEO5'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (276) then 'GEO6'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (250) then 'GEO7'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (578) then 'GEO8'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (484) then 'GEO9'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (152) then 'GEO10'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (076) then 'GEO11'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (032) then 'GEO12'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (604) then 'GEO13'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (170) then 'GEO14'
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (858) then 'GEO15'
			-- Geografias que existiam à data: ver alterações em exercicios futuros
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (600,068,218,862,238,531) then 'GEO16' --Rest of Latam 
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (044,060,092,124,136,192,214,222,312,320,533,591,630,666,780) then 'GEO17' --Rest of North America
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and cast(a.cpais_residencia as int) in (020,040,056,100,191,196,203,208,246,292,300,336,348,352,372,380,428,438,440,442,470,492,498,528,642,643,674,688,703,705,752,756,792,804,807,831,832,833) then 'GEO18' --Rest of Europe
            when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') then 'GEO19' --Rest of World
            else 'GEO3'
        end as geo
     
from bu_esg_work.rf_sat79_Jun24_aux1 as a

-- risco físico real para colaterais
left join (select * from bu_esg_work.pilar3_physical_risk_Jun24 where nace_code like '%Secured%') as prhipotec1 
on a.`4_collateral_nuts` = prhipotec1.nuts_code

-- risco físico real para idcombs com colaterais imobiliarios, mas sem colaterais associados
left join (select * from bu_esg_work.pilar3_physical_risk_Jun24 where nace_code like '%Secured%') as prhipotec3 
on a.`22_counterparty_nuts` = prhipotec3.nuts_code

-- risco físico proxy para colaterais
left join (select * from bu_esg_work.pilar3_proxy_physical_risk_Jun24 where nace like '%Secured%') as prhipotec2 
on prhipotec2.country = 'PT'					--PC: alterado para não ser necessário trazer colunas adicionais

-- risco físico real para demais operações
left join (
			Select 	a.*, 
					b.id
from bu_esg_work.pilar3_physical_risk_Jun24 a 
	left join
	 bu_esg_work.nace_esg_pillar3 as b 
		on concat(split_part(a.nace_code,".",1),
		    case when a.nace_code like 'A.%'or a.nace_code like 'B.%' then SUBSTRING(A.nace_code,4,1)
					else SUBSTRING(A.nace_code,3,2) end) 
	= trim(split_part(b.nace_level4, "-",1))) as prgeral1
		on a.`22_counterparty_nuts` = prgeral1.nuts_code
			and left(a.nace_esg,8) = prgeral1.id

-- risco físico proxy para demais operações																			
left join ( select a.*, 
				   b.tayd91c0_celemtab as iso_code, 
				   c.id
			from 
				(Select *, 
						concat(split_part(nace,".",1), case when nace like 'A.%' or nace like 'B.%' then SUBSTRING(nace,4,1) else SUBSTRING(nace,3,2) end) as nace_level4
							from bu_esg_work.pilar3_proxy_physical_risk_Jun24) a
			left join 
			(select * 
				from cd_estruturais.tat91_tabelas
					where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}") and tayd91c0_ctabela = '015')b
							on a.country=b.tayd91c0_nelemc09			
			left join
					bu_esg_work.nace_esg_pillar3 as c
						on a.nace_level4 = trim(split_part(c.nace_level4, "-",1))
			) as prgeral2
				on cast(coalesce(a.cpais_residencia,'620') as string) = prgeral2.iso_code -- os nulls 
				and left(a.nace_esg,8) = prgeral2.id;



---------------------------------------------------------------------------------------------------------------------------------------------------
-- average weighted maturity ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
-- Piloto Jun23 ==> 35 217 015 723,870027915889 € saldo (s/ MC10)
--              ==> 2 083 518 registos 

-- Exerci Dez23 ==> 34 546 620 644,594329568995 € sum(amount) 
--              ==> 2 024 200 registos 
-- Exerci Dez23 v2 ==> 2024202 | 34 598 882 682.944329568995  
-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux3;
create table bu_esg_work.rf_sat79_Jun24_aux3 as 
select  a.*,
		b.saldo_satelite as saldo_satelite_agrup
        --case 
        --    when a.flag_maturity = 0 then null
        --    else (a.amount/b.saldo_satelite)
        --end as aveg_weight
from bu_esg_work.rf_sat79_Jun24_aux2 as a
left join ( select geo,
                    cnael,
                    nace_esg,
                    sociedade_contraparte,
                    cod_ajust,
					-- Regras alteradas piloto jun23
                   case 
						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg <> '' THEN 
						concat(idcomb_satelite,";",performing_esg,";",excluded_paris)
						
						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg = '' and Investment_Sector = ''  THEN 
						concat(idcomb_satelite,";",excluded_paris,";",maturity_esg)

						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg = '' and Investment_Sector <> ''  THEN 
						concat(idcomb_satelite,";",Investment_Sector,";",excluded_paris)
												
						when idcomb_satelite like '%TYVA02%' and excluded_paris = '' and performing_esg = '' and Investment_Sector <> ''  THEN 
						concat(idcomb_satelite,";",Investment_Sector)
						
						when idcomb_satelite like '%TYVA02%' and excluded_paris = '' and performing_esg <> '' and Investment_Sector = ''  THEN 
						concat(idcomb_satelite,";",performing_esg)

						WHEN idcomb_satelite like '%MC06%' AND idcomb_satelite NOT like '%SC0303%' THEN
						concat(idcomb_satelite,";",maturity_esg)
						
						WHEN idcomb_satelite like '%TYVA01%' and excluded_paris <>'' and performing_esg <> '' and idcomb_satelite not like '%MC08%' THEN
						concat(idcomb_satelite,";",performing_esg,";",excluded_paris,";",maturity_esg)
						
						WHEN idcomb_satelite like '%TYVA01%' and excluded_paris = '' and performing_esg = '' and idcomb_satelite like '%MC08%' THEN
						concat(idcomb_satelite,";",Investment_Sector,";",maturity_esg)		
						
						WHEN idcomb_satelite like '%MC06%' AND idcomb_satelite like '%SC0303%' THEN
						concat(idcomb_satelite,";",excluded_paris,";",maturity_esg)				

						when flag_maturity=1 and excluded_paris <>'' and Investment_Sector <>'' then
						concat(idcomb_satelite,";",performing_esg,";",Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						when flag_maturity=1 and excluded_paris ='' then
						concat(idcomb_satelite,";",performing_esg,";",maturity_esg)
						
						WHEN flag_maturity=0 AND maturity_esg = 'MESG5' and Investment_Sector <>'' then 
						concat(idcomb_satelite,";",performing_esg,";",Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						when flag_maturity=0 and excluded_paris <>'' and Investment_Sector <>'' then
						concat(idcomb_satelite,";",performing_esg,";",Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						else concat(idcomb_satelite,";",performing_esg,";",maturity_esg)
					end as id_comb,
	
                    flag_maturity,
					acute_changes,
					chronic_changes,
					european_union,
					Investment_Sector,
                    sum(amount) as saldo_satelite
            from bu_esg_work.rf_sat79_Jun24_aux2
            group by 1,2,3,4,5,6,7,8,9,10,11
			having id_comb like '%TYVA01%'
			) as b
on                    
                   case 
						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg <> '' THEN 
						concat(idcomb_satelite,";",performing_esg,";",excluded_paris)
						
						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg = '' and b.Investment_Sector = ''  THEN 
						concat(idcomb_satelite,";",excluded_paris,";",maturity_esg)

						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg = '' and b.Investment_Sector <> ''  THEN 
						concat(idcomb_satelite,";",b.Investment_Sector,";",excluded_paris)
												
						when idcomb_satelite like '%TYVA02%' and excluded_paris = '' and performing_esg = '' and b.Investment_Sector <> ''  THEN 
						concat(idcomb_satelite,";",b.Investment_Sector)
						
						when idcomb_satelite like '%TYVA02%' and excluded_paris = '' and performing_esg <> '' and b.Investment_Sector = ''  THEN 
						concat(idcomb_satelite,";",performing_esg)

						WHEN idcomb_satelite like '%MC06%' AND idcomb_satelite NOT like '%SC0303%' THEN
						concat(idcomb_satelite,";",maturity_esg)
						
						WHEN idcomb_satelite like '%TYVA01%' and excluded_paris <>'' and performing_esg <> '' and idcomb_satelite not like '%MC08%' THEN
						concat(idcomb_satelite,";",performing_esg,";",excluded_paris,";",maturity_esg)
						
						WHEN idcomb_satelite like '%TYVA01%' and excluded_paris = '' and performing_esg = '' and idcomb_satelite like '%MC08%' THEN
						concat(idcomb_satelite,";",b.Investment_Sector,";",maturity_esg)		
						
						WHEN idcomb_satelite like '%MC06%' AND idcomb_satelite like '%SC0303%' THEN
						concat(idcomb_satelite,";",excluded_paris,";",maturity_esg)				

						when b.flag_maturity=1 and excluded_paris <>'' and b.Investment_Sector <>'' then
						concat(idcomb_satelite,";",performing_esg,";",b.Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						when b.flag_maturity=1 and excluded_paris ='' then
						concat(idcomb_satelite,";",performing_esg,";",maturity_esg)
						
						WHEN b.flag_maturity=0 AND maturity_esg = 'MESG5' and b.Investment_Sector <>'' then 
						concat(idcomb_satelite,";",performing_esg,";",b.Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						when b.flag_maturity=0 and excluded_paris <>'' and b.Investment_Sector <>'' then
						concat(idcomb_satelite,";",performing_esg,";",b.Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						else concat(idcomb_satelite,";",performing_esg,";",maturity_esg)
					end = b.id_comb

and a.flag_maturity = b.flag_maturity
and a.geo = b.geo
and a.cnael = b.cnael
and a.nace_esg= b.nace_esg
and a.sociedade_contraparte = b.sociedade_contraparte
and a.cod_ajust = b.cod_ajust
and a.acute_changes=b.acute_changes
and a.chronic_changes=b.chronic_changes
and a.european_union=b.european_union
and a.Investment_Sector = b.Investment_Sector
;


-- Piloto Jun23 ==> 35 217 015 723,870027915889 € saldo (s/ MC10)
--              ==> 2 083 518 registos 

-- Exerci Dez23 ==> 34 546 620 644,594329568995 € sum(amount)
--              ==> 2 024 200 registos 
-- Exerci Dez23 v2 ==> 2024202 | 34 598 882 682.944329568995  
-- Alteração de marcação do setor para um idcomb com marcação errada de SC0303 --> Por indicação da contabilidade

-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux4;
create table bu_esg_work.rf_sat79_Jun24_aux4 as
select *,
		case
			when idcomb_satelite like '%SC0303%' and cnael='' then replace(idcomb_satelite,'SC0303','SC0302')
			else idcomb_satelite
		end as idcomb_satelite_aux
from bu_esg_work.rf_sat79_Jun24_aux3;
 
 
-------------------------------------------------------------------------------------------------------------------------------
-- Agrupar aveg e amount por atributos ----------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- Piloto Jun23 ==> 35 217 015 723,870027915889 € saldo (s/ MC10)
--              ==> 12 637 registos 

-- Exerci Dez23 ==> 34 546 620 644,594329568995 € sum(amount) 
--              ==> 12 701 registos 
-- Exerci Dez23 v2 ==> 12 700 | 34 598 882 682.944329568995  
-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux5;
create table bu_esg_work.rf_sat79_Jun24_aux5 as 
select  '00411' as reporting_soc,
		sociedade_contraparte as counterparty_soc,
		'BI00411' as adjustment_code,
		
 case 
						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg <> '' THEN 
						concat(idcomb_satelite,";",performing_esg,";",excluded_paris)
						
						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg = '' and Investment_Sector = ''  THEN 
						concat(idcomb_satelite,";",excluded_paris,";",maturity_esg)

						when idcomb_satelite like '%TYVA02%' and excluded_paris <>'' and performing_esg = '' and Investment_Sector <> ''  THEN 
						concat(idcomb_satelite,";",Investment_Sector,";",excluded_paris)
												
						when idcomb_satelite like '%TYVA02%' and excluded_paris = '' and performing_esg = '' and Investment_Sector <> ''  THEN 
						concat(idcomb_satelite,";",Investment_Sector)
						
						when idcomb_satelite like '%TYVA02%' and excluded_paris = '' and performing_esg <> '' and Investment_Sector = ''  THEN 
						concat(idcomb_satelite,";",performing_esg)

						WHEN idcomb_satelite like '%MC06%' AND idcomb_satelite NOT like '%SC0303%' THEN
						concat(idcomb_satelite,";",maturity_esg)
						
						WHEN idcomb_satelite like '%TYVA01%' and excluded_paris <>'' and performing_esg <> '' THEN
						concat(idcomb_satelite,";",performing_esg,";",excluded_paris,";",maturity_esg)
						
						WHEN idcomb_satelite like '%TYVA01%' and excluded_paris = '' and performing_esg = '' and idcomb_satelite like '%MC08%' THEN
						concat(idcomb_satelite,";",Investment_Sector,";",maturity_esg)
						
						WHEN idcomb_satelite like '%MC06%' AND idcomb_satelite like '%SC0303%' THEN
						concat(idcomb_satelite,";",excluded_paris,";",maturity_esg)				

						when flag_maturity=1 and excluded_paris <>'' and Investment_Sector <>'' then
						concat(idcomb_satelite,";",performing_esg,";",Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						when flag_maturity=1 and excluded_paris ='' then
						concat(idcomb_satelite,";",performing_esg,";",maturity_esg)
						
						WHEN flag_maturity=0 AND maturity_esg = 'MESG5' and Investment_Sector <>'' then 
						concat(idcomb_satelite,";",performing_esg,";",Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						when flag_maturity=0 and excluded_paris <>'' and Investment_Sector <>'' then
						concat(idcomb_satelite,";",performing_esg,";",Investment_Sector,";",excluded_paris,";",maturity_esg)
						
						else concat(idcomb_satelite,";",performing_esg,";",maturity_esg)
					end   as id_comb,
--						
		sum(amount) as amount,
		european_union as EU,
		chronic_changes as CHRO,
		acute_changes as ACUT,
		geo,
		cnael,
		nace_esg as nace,
        --case 
        --    when a.flag_maturity = 0 then null
        --    else (amount/saldo_satelite_agrup)
        --end as aveg_weight,
		ceiling(sum(years_to_maturity * 
				case 
					when flag_maturity = 0 or idcomb_satelite not like '%TYVA01%' then null
					else (amount/saldo_satelite_agrup)
				end)) as aveg -- alteração para calcular o AVEG com o gross em vez do liquido (guia da corporação)
from bu_esg_work.rf_sat79_Jun24_aux4 as a
group by 1,2,3,4,6,7,8,9,10,11
;
 
---------------------------------------------------------------------------------------------------------------------------------------------------
-- Tabelas finais - operações gerais ----------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
   
-- Piloto Jun23 ==> 35 217 015 769 € saldo (s/ MC10)
--              ==> 12 625 registos 

-- Exerci Dez23 ==> 34 546 620 675 € sum(amount)
--              ==> 12 694 registos 

-- Exerci Dez23 v2 ==> 12 694 | 34 598 882 710 (dif de arredondamento 27.05567169189453)   
-- Foi criada uma v3 para refletir a alteração da sociedade contrapart '01278'

-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux6;
create table bu_esg_work.rf_sat79_Jun24_aux6 as
select
    reporting_soc,
    case
		when counterparty_soc='01278' then '00000'
		else counterparty_soc
	end as counterparty_soc,
    adjustment_code,
    id_comb,
    -sum(round(amount,0)) as amount,
    EU,
    CHRO,
    ACUT,
    geo,
    cnael,
    nace,                                                    
    case when cast(aveg as string) is null and id_comb like '%MESG1%' then '0' 
		when cast(aveg as string) < '0' and id_comb like '%MESG1%' then '0'
		when cast(aveg as string) is null and id_comb not like '%MESG1%' then ''
		when id_comb not like '%MESG%' THEN '' 
		else cast(aveg as string) end as aveg
        from bu_esg_work.rf_sat79_Jun24_aux5
where amount <> 0
group by 1,2,3,4,6,7,8,9,10,11,12
;

-- Piloto Jun23 ==> 35 217 015 769 € saldo (s/ MC10)
--              ==> 12 524 registos 

-- Exerci Dez23 ==> 34 546 620 675 € sum(amount) 
--              ==> 12 552 registos 
-- Exerci Dez23 v2 ==> 12 552 

-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux7;
create table bu_esg_work.rf_sat79_Jun24_aux7 as
select *
        from bu_esg_work.rf_sat79_Jun24_aux6
where amount <> 0;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Adjudicados --------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Piloto Jun23 ==> 54 718 144.79510000 € saldo 
--              ==> 620 registos 
--              ==> cargabal_vc 

-- Exerci Dez23 ==> 1 116 registos 
--              ==> 24 160 058,510596642000 € sum (amount) | total
--              ==> cargabal_vc = 58 340 999.745100000000 sum(amount) 
--              ==> cargabal_prov = - 34 180 941.234503358000 sum(amount)
--              ==> Todos os adjusdicados têm conta de provisão e valor bruto 
-- Exerci Dez23 v2 ==> 1 010 | 18 849 825.594590642000
--                 ==> cargabal_vc = 46504922.765100000000
--                 ==> cargabal_prov 27655097.170509358000

-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux8;
create table bu_esg_work.rf_sat79_Jun24_aux8 as
select 
        a.idcomb_satelite, 
        a.sociedade_contraparte,
        a.cod_ajust,
        a.cargabal_ct,
        a.saldo_ct,
        b.cod_imovel,
        b.tipo_adjudicado,
        b.cargabal_vc,
        c.cargabal_prov,
        -- coalesce(b.fiabilidad,c.fiabilidad) as fiabilidad,
        -- coalesce(b.clase_energetica,c.clase_energetica) as clase_energetica,
        -- coalesce(b.emisiones,c.emisiones) as emisiones,
        -- coalesce(b.consumos,c.consumos) as consumos,
        'EXC2' as excluded_paris,
        'MESG4' as maturity_esg,
        case
            when coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'ACUT1'
            else 'ACUT2'
        end as acute_changes,
        case
            when coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'CHRO1'
            else 'CHRO2'
        end as chronic_changes,
        case 
            when cargabal_ct = '' then -saldo_ct
            when b.cargabal_vc in ('1605000','1605010') then b.valor_cargabal_vc
            else -c.valor_cargabal_prov
        end as amount
      
from (  select csatelite, idcomb_satelite, sociedade_contraparte, cod_ajust, cargabal_ct, sum(saldo_ct) as saldo_ct 
		from bu_esg_work.rf_pilar3_universo_full where csatelite = 79 and idcomb_satelite like '%MC10%' and DT_RFRNC = '${ref_date}'
		and id_corrida in ( select max(id_corrida) from bu_esg_work.rf_pilar3_universo_full where csatelite = 79 and DT_RFRNC = '${ref_date}')
        group by 1,2,3,4,5) as a
        
left join (select * from bu_esg_work.adjudicados_Jun24_final
            where tipo_adjudicado <> 'Totta URBE' and cargabal_vc in ('1605000','1605010')) as b
on a.cargabal_ct = b.cargabal_vc
        
left join (select * from bu_esg_work.adjudicados_Jun24_final
            where tipo_adjudicado <> 'Totta URBE' and cargabal_prov in ('2642300')) as c
on a.cargabal_ct = c.cargabal_prov

-- risco físico real
left join (select * from bu_esg_work.pilar3_physical_risk_Jun24 where nace_code like '%Secured%') as prhipotec1
on coalesce(b.`4_collateral_nuts`,c.`4_collateral_nuts`) = prhipotec1.nuts_code

-- risco físico proxy
left join (select a.*, b.tayd91c0_celemtab as iso_code from
			(Select * from bu_esg_work.pilar3_proxy_physical_risk_Jun24 where nace like '%Secured%') a
			left join
			(
			select * from cd_estruturais.tat91_tabelas
			where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}") and tayd91c0_ctabela = '015')b
			on a.country=b.tayd91c0_nelemc09)as prhipotec2
on prhipotec2.iso_code = '620'
;


-- tabela final
-- Piloto Jun23 ==> 54 718 163 € saldo 
--              ==> 4 registos 

-- Exerci Dez23 ==> 24 160 081 € sum(amount)
--              ==> 4 registos 
-- Exerci Dez23 v2 ==> 18 849 846 € sum(amount)
--              ==> 4 registos 

-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux9;
create table bu_esg_work.rf_sat79_Jun24_aux9 as
select
    '00411' as reporting_soc,
    case
		when sociedade_contraparte='01278' then '00000'
		else sociedade_contraparte
	end as counterparty_soc,
    'BI00411' as adjustment_code,
	CASE 
		when idcomb_satelite like '%TYVA02%' then idcomb_satelite	
		else concat(idcomb_satelite,";",maturity_esg) 
	END as id_comb,
    sum(round(amount,0)) as amount,
    'EU1' as EU,
    chronic_changes as CHRO,
    acute_changes as ACUT,
    'GEO3' as geo,
    '' as cnae,
    '' as nace,
    '' as aveg
from bu_esg_work.rf_sat79_Jun24_aux8
group by 1,2,3,4,6,7,8,9,10,11,12
;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- União de operações gerais e adjudicados ----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- tabela final - consolidação
-- Piloto Jun23 ==> 35 270 685 904 € saldo 
--              ==> 12 528 registos 

-- Exerci Dez23 ==> 34 570 780 756 € sum(amount) 
--              ==> 12 556 registos 
-- Exerci Dez23 v2 ==> 34 617 732 556 € sum(amount) 
--              ==> 12 556 registos 


-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux10;
create table bu_esg_work.rf_sat79_Jun24_aux10 as
select * from bu_esg_work.rf_sat79_Jun24_aux7
union all
select * from bu_esg_work.rf_sat79_Jun24_aux9
;

-- Desconsideração de operações SC02 --> Por indicação da corporação (Cargabal Masterizado sem visibilidade de SC02+COLL3)
-- Piloto Jun23 ==> 35 270 685 900 € saldo 
--              ==> 12 517 registos 

-- Exerci Dez23 ==> 34 569 756 195 € sum(amount) 
--              ==> 12 545 registos 

-- Exerci Dez23 ==> 34 616 707 995 € sum(amount) 
--              ==> 12 545 registos 


-- drop table if exists bu_esg_work.rf_sat79_Jun24_aux11;
create table bu_esg_work.rf_sat79_Jun24_aux11 as
Select * from bu_esg_work.rf_sat79_Jun24_aux10
where id_comb not like '%SC02%'
;

insert overwrite table  bu_esg_work.RT_PILAR3_SATELITE79_Jun24 partition (DT_RFRNC, PROC_ID)
select 
reporting_soc,
counterparty_soc,
adjustment_code,
id_comb,
cast(amount as decimal(36,0)) as amount,
eu,
chro,
acut,
geo,
cnael,
nace,
aveg,
strleft(cast(current_timestamp() as STRING), 10) as PROC_DATE,
-- Particao
'${ref_date}' as DT_RFRNC,
rt.NEW_PROC_ID
from  bu_esg_work.rf_sat79_Jun24_aux11
left join
(Select nvl(max(PROC_ID),0)+1 as NEW_PROC_ID from bu_esg_work.RT_PILAR3_SATELITE79) RT
on 1=1
;
