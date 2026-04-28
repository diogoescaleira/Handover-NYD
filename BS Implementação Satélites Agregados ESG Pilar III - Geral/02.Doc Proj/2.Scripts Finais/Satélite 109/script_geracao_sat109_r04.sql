
--- Satélites Agregados Pilar III ESG ---
--- PROCESSO DE PREPARAÇÃO DE INFORMAÇÃO E GERAÇÃO DO SATÉLITE 109_IESG_Interest and Commisions ---


-- De notar que as tabelas referenciadas no processo de preparação e geração do satélite 109 infra encontram-se descritas em detalhe no documento Word "BS Esp Satélites Agregados ESG Pilar III - Satélite 109"

-------------------------------------------------------------------------------------------------------------------------------
--- Definição do Universo de comissões não financeiras provenientes da tabela ct211 do mis - R04 Comissões Não Financeiras ----  
-------------------------------------------------------------------------------------------------------------------------------

--- Tabela de definição do universo de contratos a reportar no Satélite 109 (descrita no ponto 1.3.1 - Tabela de formação do universo: bu_esg_work.ste_sat109_univ_r04_dez25)

drop table bu_esg_work.ste_sat109_univ_r04_[date_ref];
create table bu_esg_work.ste_sat109_univ_r04_dez25 as
select 
         a.*,
        c.cnatureza_juri, 
        c.nace_code, 
        c.cpais_residencia, 
        e.country_code,
        case 
            when (c.cnatureza_juri  like '131%' or c.cnatureza_juri like '231%')
            and contraparte in ('outras empresas nao financeiras', '') then 'outras empresas nao financeiras'
            else 'outros setores'
        end as contraparte,
        b.ref_date as ref_date_cli
from (

--- Tabela Base do Universo de contratos, filtrada por comissões não financeiras - t211_rent_kpmco
        select cempcta,ckbalcao,cknumcta,zdeposit as zdeposit_mis, concat(cempcta,ckbalcao,cknumcta,zdeposit) as chave_mis, zcliente,cmetacom, sum(c457+c460) as saldo_comis
        from cd_captools.ct211_rent_kpmco
        where ref_date = "${ref_date}"
        and cempcta = '31' 
        and origem = 'MIS'
        and TRIM(cmetacom) in ('AA1000','AA1100','AA1150','AA1190','AA1300','AA1410','AA1420','AA1431','AA1432','AA1433','AA1480','AA1490','AA2000','AA2100',
					     'AA2200','AA2290','AA2300','AA3000','AA3001','AA310','AA3101','CC1010','CC1019','CC1020','CC1021','CC1022','CC1111',
						 'CC1200','CC1201','CC1210','CC1212','CC1220','CC1310','CC1311','CC1312','CC1320','CC1330','CC1351','CC1361','CC1362','CC1410',
						 'CC1420','CC1430','CC1440','CC1510','CC1520','CC1525','CC1540','CC1546','CC1547','CC155A','CC155B','CC1560','CC1565','CC1568',
						 'CC1570','CC1580','CC1600','CC1700','CC1800','CC1810','CC1950','CC2000','CC2200','CC2300','CC3000','CC3001','CC3002','CC3003',
						 'CC3051','CC3052','CC3053','CC3071','CC3073','CC3100','CCC000','CCC001','EE200C','EE200D','EE200E','EE2190',
						 'EE3000','EE3090','EE5120','EE5130','EE6110','EE7221','EE7222','EE7231','EE7232','EE7242','EE7243',
						 'EE7252','EE7256','EE7261','EE7262','EE7265','EE7266','EE7267','EE7268','EE726D','EE726G','EE726H','EE726I','EE7272','EE72AA',
						 'EE72AB','EE72AC','EE72AD','EE72B3','EE72B4','EE72ZA','EE72ZB','EE72ZC','EE72ZD','EE72ZE','EE8000','GH1200','GH2210','GH2500',
						 'GH2650','GH3100','GH3200','GH3300','GH3610','GH3620','GH3900','GH4002','GH5000','GH5100','GH5996','GH5997','JJ1000','JJ1100',
             'JJ2000','JJ2100','JJ3000','JJ5000','JJ500B','JJ6000','JJ7000','JJ8000','MM1000','MM1050',
             'MM1100','MM1200','MM1310','MM1320','MM1350','MM1403','MM1404','MM1405','MM1411','MM1412','MM1415','MM1416','MM1431','MM1432',
						 'MM2000','MM2111','MM2112','MM2120','MM2130','MM3010','MM3021','MM3022','MM3023','MM3032','MM3033','MM3034','MM3037','MM3038',
						 'MM3100','MM4000','MM5201','MM5209','MM6000','MM7000','MM7110','MM7120','MM7131','MM7132','MM7200','MM7300','MM7301','MM7500',
						 'MM7710','MM7720','MM7800','MM7850','MM7950','MM7961','MM7962','MM7963','MM7964','PP1000','PP2000','PP3000','PP4000','QQ0110',
						 'QQ0120','QQ1000','SS0100','SS0111','SS0112','SS0121','SS0122','SS1000','SS1002','SS1003','SS1005','SS2100','SS2101','SS2102',
						 'SS2210','SS2220','SS2231','SS2232','SS2241','SS2242','SS2243','SS2250','SS2300','SS2301','SS2400','SS2510','SS2520','SS2530',
						 'SS2540','SS2550','SS2555','SS2560','SS2570','SS2580','SS2590','SS2591','SS2600','SS2700','SS280A','SS280B','SS280C','SS280D',
						 'SS2810','SS2910','SS2911','SS2930','SS2950','SS2951','SS2999','SX1100','SX1200','TT1100','TT2000','TT2100','TT3100','TT4000',
						 'TT4100','TT4210','TT5000','TT5100','TT5110','TT5200','UMC000','UMCGI0','UMCGP0','UMCGR0','EE7257','EE7259','AA1434','AA1435',
						 'AA3100','GH2000','EE4000','EE1500','MM1510','MM1520','MM1525','MM1526','MM1530','MM1531','MM1532','MM1533','MM1534',
             'MM1536','MM1537','MM1538',
             'GH2310','GH3410','GH3420','JJ3150','TT3200','AA1200','AA1310','CC2100','EE9030','EE9040','EE9050','GH599B','JJ1200','MM5100',
             'TT4220','MM5202','MM7400','MM7600','MM7900','MM7970','SS2261','SS2262','SS2710','SS2711','SS2952','TT1000','TT2200') -- comissões não financeiras de acordo com o ficheiro da ana clara
          group by 1,2,3,4,5,6,7
     ) as a

--- Adição do cliente com maior ref_date associada dentro do ano de reporte
inner join (select zcliente, max(ref_date) as ref_date
            from cd_captools.ct003_univ_cli 
            where ref_date < '${ref_date_fim}' 
            group by 1) as b 
on a.zcliente = b.zcliente

--- Associação dos campos relevantes para futura marcação dos contratos: 'zcliente','cnatureza_juri', 'nace_code', 'cpais_residencia' e 'contraparte'
inner join ( select distinct zcliente,cnatureza_juri, nace_code, cpais_residencia, contraparte,ref_date
                from cd_captools.ct003_univ_cli
                where  ref_date <  '${ref_date_fim}'
                ) c
on b.zcliente = c.zcliente
and b.ref_date = c.ref_date

--- Cruzamento com o tradutor de chaves Master-MIS de forma a ser possível aceder à informação no Modelo de Bens Imóveis 
Left join (select distinct concat(cempcta,	ckbalcao,	cknumcta,	zdeposit_mis) as chave_mis, 
concat(	cempresa,	cbalcao,	cnumecta,	zdeposit) as chave_master from cd_captools.kt_chaves_mis
where ref_date = '${ref_date}') kt_mis

on kt_mis.chave_mis= a.chave_mis

left join

--- Modelo de Bens Imóveis - Associação do campo 'country_code' para futura marcação da métrica GEO - Physical risk_Geographical Area
(select distinct chave_resp, property.country_code from 
(select distinct concat(bank_id, branch_code, contract_id, reference_code) as chave_resp,
        concat(process_bank_id, process_branch_code, process_account_id, process_reference_code) as chave_proc
        from business_assets.responsibility_process_rel
where data_date_part = '${ref_date}') resp_proc

Inner join

(select distinct concat(process_bank_id, process_branch_code, process_account_id, process_reference_code) as chave_proc,
        concat(property_bank_id, property_branch_code, property_contract_id, property_reference_code) as chave_bem
        from business_assets.process_property_rel
where data_date_part = '${ref_date}') proc_property

on resp_proc.chave_proc = proc_property.chave_proc

Inner join

(select distinct 
        concat(property_bank_id, property_branch_code, property_contract_id, property_reference_code) as chave_bem, 
        country_code from business_assets.property
where data_date_part = '${ref_date}')property

on proc_property.chave_bem = property.chave_bem

)e

on kt_mis.chave_master = e.chave_resp
;


-------------------------------------------------------------------------------------------------------------------------------
-------------------------------- Construção do Satélite 109 e Respetivos Tratamentos ------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

--- Tabela de criação de todas as dimensões a considerar no satélite granularidade ao nível do contrato MIS (i.e, ‘cempcta’, ’ckbalcao’, ‘cknumcta’, ‘zdeposit’) e metacomissão (i.e, ‘cmetacom’)
--- (descrita no ponto 1.3.2.	Tabela auxiliar de agregação de informação do Satélite 109: bu_esg_work.ste_sat109_metricas_r04_dez25)

drop table bu_esg_work.ste_sat109_metricas_r04_[date_ref];  
create table bu_esg_work.ste_sat109_metricas_r04_dez25 as
select DISTINCT a.*,

--- Marcação do campo continuing_operations
		'CONT1' as continuing_operations,

--- Marcação do campo base
		'R04' as base,

--- Marcação do campo main_category, de acordo com o mapeamento aprovado por Controlo de Gestão (Ana Clara)
		case when cmetacom in ('AA3000','AA3001','AA2290') then 'MC54' 
	         when cmetacom in ('MM2000','MM4000','MM7300','MM7301','MM7500','JJ7000','EE3000') then 'MC54'
             when cmetacom in ('UMCGP0', 'UMCGR0') then 'MC54'
             when cmetacom in('PP1000','MM1000','MM1050','MM1537') then 'MC45'
             when cmetacom in ('PP2000', 'PP3000') then 'MC53'
	         when (cmetacom like 'MM1%' ) then  'MC53'
	         when (cmetacom like 'QQ%' or cmetacom like 'SS%' or cmetacom like 'SX%') then  'MC45'
	         when (cmetacom like 'MM%' ) then  'MC52'
	         when cmetacom like 'AA%' then 'MC52'
             when cmetacom like 'CC%' then 'MC52'
             when cmetacom like 'GH%' then 'MC54'
	         when cmetacom like 'JJ%' then 'MC52'
	         when cmetacom like 'EE%' then 'MC52'
	         when cmetacom like 'TT%' then 'MC52'
        end as main_category,

--- Marcação do campo Comission Sector atrvés da contraparte associada à metacomissão
		case 
			when A.contraparte = 'outras empresas nao financeiras' then 'COSE1'
			else 'COSE2'
		end as comission_sector,

--- Marcação do campo Physical risk_Geographical Area, validando se existem imóveis associados: No caso de existirem imóveis associados - o mapeamento é realizado com o campo 'country_code'proveniente do Modelo de Bens Imóveis, caso contrário, é utilizado o campo 'cpais_residencia'
        case
        	-- Geografias que existiam à data: ver alterações em exercicios futuros
            when a.contraparte <> 'outras empresas nao financeiras' then '' 	--- de acordo com os MDDs forncedios pela corporação todos os registos que são marcados com COSE2 não reportam a métrica em questão
            when country_code is not null and country_code in ('620') then 'GEO3'
            when country_code is not null and country_code in ('724') then 'GEO1'
            when country_code is not null and country_code in ('826') then 'GEO2'
            when country_code is not null and country_code in ('840') then 'GEO4'
            when country_code is not null and country_code in ('616') then 'GEO5'
            when country_code is not null and country_code in ('276') then 'GEO6'
            when country_code is not null and country_code in ('250') then 'GEO7'
            when country_code is not null and country_code in ('578') then 'GEO8'
            when country_code is not null and country_code in ('484') then 'GEO9'
            when country_code is not null and country_code in ('152') then 'GEO10'
            when country_code is not null and country_code in ('076') then 'GEO11'
            when country_code is not null and country_code in ('032') then 'GEO12'
            when country_code is not null and country_code in ('604') then 'GEO13'
            when country_code is not null and country_code in ('170') then 'GEO14'
            when country_code is not null and country_code in ('858') then 'GEO15'
            when country_code is not null and country_code in ('600','068','218','862','238','531') then 'GEO16' --Rest of Latam 
            when country_code is not null and country_code in ('044','060','092','124','136','192','214','222','312','320','533','591','630','666','780') then 'GEO17' --Rest of North America
            when country_code is not null and country_code in ('020','040','056','100','191','196','203','208','246','292','300','336','348','352','372','380','428','438','440','442','470','492','498','528','642','643','674','688','703','705','752','756','792','804','807','831','832','833') then 'GEO18' --Rest of Europe    
            when cast(a.cpais_residencia as int) in (620) then 'GEO3'
            when cast(a.cpais_residencia as int) in (724) then 'GEO1'
            when cast(a.cpais_residencia as int) in (826) then 'GEO2'
            when cast(a.cpais_residencia as int) in (840) then 'GEO4'
            when cast(a.cpais_residencia as int) in (616) then 'GEO5'
            when cast(a.cpais_residencia as int) in (276) then 'GEO6'
            when cast(a.cpais_residencia as int) in (250) then 'GEO7'
            when cast(a.cpais_residencia as int) in (578) then 'GEO8'
            when cast(a.cpais_residencia as int) in (484) then 'GEO9'
            when cast(a.cpais_residencia as int) in (152) then 'GEO10'
            when cast(a.cpais_residencia as int) in (076) then 'GEO11'
            when cast(a.cpais_residencia as int) in (032) then 'GEO12'
            when cast(a.cpais_residencia as int) in (604) then 'GEO13'
            when cast(a.cpais_residencia as int) in (170) then 'GEO14'
            when cast(a.cpais_residencia as int) in (858) then 'GEO15'
            when cast(a.cpais_residencia as int) in (600,068,218,862,238,531) then 'GEO16' --Rest of Latam 
            when cast(a.cpais_residencia as int) in (044,060,092,124,136,192,214,222,312,320,533,591,630,666,780) then 'GEO17' --Rest of North America
            when cast(a.cpais_residencia as int) in (020,040,056,100,191,196,203,208,246,292,300,336,348,352,372,380,428,438,440,442,470,492,498,528,642,643,674,688,703,705,752,756,792,804,807,831,832,833) then 'GEO18' --Rest of Europe
            else 'GEO19'
        end as geo,
		
--- Marcação do campo european_union        
	   case 
			when a.contraparte <> 'outras empresas nao financeiras' then '' --- de acordo com os MDDs forncedios pela corporação todos os registos que são marcados com COSE2 não reportam a métrica em questão
            when cpais_residencia in ('276','040','056','100','203','196','191','208','703','705','724','233','246','250','300','348','372','380','428','440','442','470','528','616','620','642','752') then 'EU1'
            else 'EU2'
        end as european_union, 
	   
--- Marcação do campo CNAEL
	   case
            when a.contraparte <> 'outras empresas nao financeiras' then ''	--- de acordo com os MDDs forncedios pela corporação todos os registos que são marcados com COSE2 não reportam a métrica em questão
            when substr(nfin.nace_code,1,1) = 'A' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL1'
            when substr(nfin.nace_code,1,1) = 'D' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL4'
            when substr(nfin.nace_code,1,1) = 'C' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL3'
            when substr(nfin.nace_code,1,1) = 'E' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL5'
            when substr(nfin.nace_code,1,1) = 'F' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL6'
            when substr(nfin.nace_code,1,1) = 'G' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL7'
            when substr(nfin.nace_code,1,1) = 'B' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL2'
            when substr(nfin.nace_code,1,1) = 'H' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL8'
            when substr(nfin.nace_code,1,1) = 'I' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL9'
            when substr(nfin.nace_code,1,1) = 'J' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL10'
            when substr(nfin.nace_code,1,1) = 'L' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL11'
            when substr(nfin.nace_code,1,1) = 'M' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL12'
            when substr(nfin.nace_code,1,1) = 'N' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL13'
            when substr(nfin.nace_code,1,1) = 'O' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL14'
            when substr(nfin.nace_code,1,1) = 'P' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL15'
            when substr(nfin.nace_code,1,1) = 'Q' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL16'
            when substr(nfin.nace_code,1,1) = 'R' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL17'
            when substr(nfin.nace_code,1,1) = 'S' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL18'
            when trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL18'
		    else ''
        end as CNAEL,

--- Marcaçaõ do campo nace_code_esg - NACE Nível 4
	       case
            when a.contraparte <> 'outras empresas nao financeiras' then ''	--- de acordo com os MDDs forncedios pela corporação todos os registos que são marcados com COSE2 não reportam a métrica em questão
            when nace_esg.nace_level4 is not null then nace_esg.ID
            else 'NACE19010303' --Nace default disponibilizado pela corporação
        end as nace_code_esg

from bu_esg_work.ste_sat109_univ_r04_dez25 as a

--- Associação da informação do código Nace ESG ('cod_nace_esg') da tabela de empresas não financeiras do Modelo Verde (onde foi realizado previamente o tratamento das Holdings) à tabela de Universo 
LEFT JOIN  
	(select zcliente, cod_nace_esg as nace_code from  bu_esg_work.modesg_out_empr_info_nfin where ref_date = '${ref_date}') nfin
ON a.zcliente = nfin.zcliente


LEFT JOIN 
	(SELECT * FROM bu_esg_work.nace_esg_pillar3) as nace_esg		
on concat(split_part(nfin.nace_code,".",1),split_part(nfin.nace_code,".",2),split_part(nfin.nace_code,".",3)) = trim(split_part(nace_esg.nace_level4, "-",1))	


;

--- Tabela final do satélite, formatada de acordo com o esperado ser recebido pela corporação
--- (descrita no ponto 1.3.3.	Tabela final do Satélite 109: bu_esg_work.ste_sat109_final_r04_dez25)

 
drop table bu_esg_work.ste_sat109_metricas_r04_final_[date_ref];
create table bu_esg_work.ste_sat109_final_r04_dez25 as
select 
    '00411' as reporting_soc,
    '00000'as counterparty_soc,
    'BI00411' as adjustment_code,
    concat(continuing_operations,';',base,';',main_category,';',comission_sector) as comb_code,
    round(- sum(saldo_comis)) as amount,
    european_union,
    geo,
    CNAEL,
    nace_code_esg as nace 
from bu_esg_work.ste_sat109_aux1_r04_dez25 as a
group by 1,2,3,4,6,7,8,9

;
