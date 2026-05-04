
---------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | Código para geração do satélite 83 (MITI) - DEZ23
---------------------------------------------------------------------------------------------------------------------
--  Desenvolvedor: Neyond
---------------------------------------------------------------------------------------------------------------------

-- Universo FULL: 53 465 975 232

-- 1. Criação de universo base 
-- Piloto Jun23 ==> 1 820 273 registos 
--              ==> 53 465 972 742 (perdemos 2 490€ devido à tabela de pesos)

-- Dez23        ==> -53 399 238 470,66 € (Universo Full s/ MC10)
--              ==>  1 787 297 registos 
--              ==> -53 399 236 253.039293890000 (perdemos 2 217€ devido à tabela de pesos)

-- NOTA: CONFIRMAR QUE NAO DESMULTIPLICA POR CAUSA DOS CAMPOS DE CO2 E DESCRITIVO DO VEÍCULO

drop table bu_esg_work.pilar3_sat83_dez23_tabaux1;
create table bu_esg_work.pilar3_sat83_dez23_tabaux1 as
select  
        a.sociedade_contraparte, 
        a.idcomb_satelite,
        a.cempresa_ct, 
        a.cbalcao_ct,
        a.cnumecta_ct,
        a.zdeposit_ct,
        a.cod_ajust,
        a.saldo_ct, -- Exposição
        a.setor,
        b.`33_counterparty_type`,
        b.`29_flag_specialised_lending`,
        -(a.saldo_ct)*pesos.peso as amount, 
        b.zcliente,
        b.ckbalbem,
        b.ckctabem,
        b.ckrefbem, 
        b.clase_energetica,
        b.`14_nace`,
        b.`84_dt_origination`,
        b.`93_european_union`,
        b.fiabilidad, 
        c.sfcs_tag_comgloval,
        c.sfcs_green_activity_comgloval,
        c.tipo_produto,
 		b.`4_collateral_nuts`,
		b.`22_counterparty_nuts`,
		ept01.cfamilia,
		c.ckprodmi,
		ct004.cproduto,
		ct004.csubprod,
		ct004.dabertur,
		cpais_residencia,
		des_combustivel,
		co2,
		des_detalle_lease,
		anoconst,
		nifrru,
		case
            when trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' and nace_esg.nace_level4 is not null then nace_esg.ID
            when trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'NACE19010303' -- NOTA: nace default disponibilizado pela corporação
            when trim(b.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' and nace_esg.nace_level4 is not null then nace_esg.ID	
            when trim(b.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' then 'NACE19010303' -- NOTA: nace default disponibilizado pela corporação
            else ''									
        end as nace_esg        
from 
(select
            sociedade_contraparte, 
            idcomb_satelite,
            cempresa_ct, 
            cbalcao_ct,
            cnumecta_ct,
            zdeposit_ct,
            'BI00411' as cod_ajust,
            sum(saldo_ct) as saldo_ct, -- Exposição
            case 
                when idcomb_satelite like '%SC0302%' then 'FC'       
                when idcomb_satelite like '%SC0303%' then 'NFC'
                else ''
            end as setor
    from bu_esg_work.rf_pilar3_universo_full                   -- ALTERADA TABELA PARA NOVA TABELA DE IDCOMBS DEZ23
        where DT_RFRNC = '${ref_date}' and csatelite = 83       
            group by
                sociedade_contraparte, 
                idcomb_satelite,
                cempresa_ct, 
                cbalcao_ct,
                cnumecta_ct,
                zdeposit_ct,
                'BI00411',
                case when idcomb_satelite like '%SC0302%' then 'FC'          
                     when idcomb_satelite like '%SC0303%' then 'NFC'
                                else '' end
     ) as a
left join   
            (
				SELECT DISTINCT 
				    GAR.cempresa_ct,
				    GAR.cbalcao_ct,
				    GAR.cnumecta_ct,
				    GAR.zdeposit_ct,
				    GAR.zcliente,
				    GAR.`13_gross_carrying_amount`,
				    GAR.`32_type_collateral`,
				    GAR.`16_percent_collateral`,
				    GAR.ckbalbem,	
				    GAR.ckctabem,
				    GAR.ckrefbem,	
				    GAR.`19_type_of_asset`,
				    GAR.flag_colateral,
				    GAR.`14_nace`,
				    GAR.`15_nace_esg`,
				    GAR.`84_dt_origination`,
				    GAR.`33_counterparty_type`,
				    GAR.`29_flag_specialised_lending`,
				    GAR.`93_european_union`,
             		GAR.`4_collateral_nuts`,
            		GAR.`22_counterparty_nuts`,	
            		GAR.cpais_residencia,
				    CERT_ENERG.clase_energetica,	
				    CERT_ENERG.fiabilidad,
				    CERT_ENERG.consumos
				FROM
				(
				    SELECT * 
				    FROM bu_esg_work.reparticao_garantias_final_dez23
				) GAR
				LEFT JOIN
				(
				    SELECT *
				    FROM bu_esg_work.gloval_clase_energetica_dez23
				) CERT_ENERG
				ON CONCAT(GAR.ckbalbem,GAR.ckctabem,GAR.ckrefbem) = chave_banco_atual
             ) as b
 on  a.cempresa_ct = b.cempresa_ct 
 and a.cbalcao_ct  = b.cbalcao_ct 
 and a.cnumecta_ct = b.cnumecta_ct 
 and a.zdeposit_ct = b.zdeposit_ct
left join 
(
    select distinct
        cempresa_ct,
        cbalcao_ct,
        cnumecta_ct,
        zdeposit_ct,
        ckbalbem,
        ckctabem,
        ckrefbem,
        peso
    from bu_esg_work.rf_pilar3_pesos_dez23
) as pesos
    on  a.cempresa_ct = pesos.cempresa_ct
    and a.cbalcao_ct  = pesos.cbalcao_ct
    and a.cnumecta_ct = pesos.cnumecta_ct
    and a.zdeposit_ct = pesos.zdeposit_ct
    and coalesce(b.ckbalbem,'0') = coalesce(pesos.ckbalbem, '0')
    and coalesce(b.ckctabem,'0') = coalesce(pesos.ckctabem, '0')
    and coalesce(b.ckrefbem,'0') = coalesce(pesos.ckrefbem, '0')
left join (select distinct 
                    cempresa_ct, 
                    cbalcao_ct,
                    cnumecta_ct,
                    zdeposit_ct,
                    case when ckbalbem = '' then null else ckbalbem end as ckbalbem,
                    case when ckctabem = '' then null else ckctabem end as ckctabem,
                    case when ckrefbem = '' then null else ckrefbem end as ckrefbem,                      
                    sfcs_green_activity_comgloval,
                    sfcs_tag_comgloval,
                    tipo_produto,
                    ckprodmi,
					des_combustivel,
					co2,
					des_detalle_lease
            from bu_esg_work.rf_pilar3_cdg_tabaux1_dez23
            where sfcs_tag_comgloval not in ('Sin información','No Elegible')
           ) as c
on  a.cempresa_ct = c.cempresa_ct
and a.cbalcao_ct  = c.cbalcao_ct
and a.cnumecta_ct = c.cnumecta_ct
and a.zdeposit_ct = c.zdeposit_ct
and coalesce(b.ckbalbem,'') = coalesce(c.ckbalbem, '')
and coalesce(b.ckctabem,'') = coalesce(c.ckctabem, '')
and coalesce(b.ckrefbem,'') = coalesce(c.ckrefbem, '')

left join bu_esg_work.nace_esg_pillar3 as nace_esg	
on concat(split_part(b.`15_nace_esg`,".",1),split_part(b.`15_nace_esg`,".",2),split_part(b.`15_nace_esg`,".",3)) = trim(split_part(nace_esg.nace_level4, "-",1))

left join (select * from cd_emprestimos.ept01_contas where data_date_part='${ref_date_util}') ept01 -- '2023-12-29'
on concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct)=concat(ept01.cempresa,ept01.ckbalcao,ept01.cknumcta)

left join (select * from cd_captools.ct004_univ_cto where ref_date='${ref_date}') ct004
on concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct)=concat(ct004.cempresa,ct004.cbalcao,ct004.cnumecta,ct004.zdeposit)

LEFT JOIN
 (SELECT ckbalbem, ckctabem, MIN(CASE
                                     WHEN TRIM(anoconst)=''
                                          OR anoconst <'1500' or anoconst in ('0N') THEN '9999'
                                     ELSE anoconst
                                 END) AS anoconst, '000000000000000' AS ckrefbeM
  FROM cd_emprestimos.gpt18_bens
  WHERE data_date_part = '${ref_date_util}' -- '2023-12-29'
  GROUP BY ckbalbem, ckctabem, '000000000000000') ano
ON CONCAT(b.ckbalbem,b.ckctabem,b.ckrefbem)=CONCAT(ano.ckbalbem,ano.ckctabem,ano.ckrefbem)
;

-- 2. Mapeamento de métricas
-- Piloto Jun23 ==> 1 820 273 registos 
--              ==> 53 465 972 742 (perdemos 2 490€ devido à tabela de pesos)

-- Dez23        ==> -53 399 236 253.04 € 
--              ==>  1 787 297 registos 
-- 
drop table bu_esg_work.pilar3_sat83_dez23_tabaux2;
create table bu_esg_work.pilar3_sat83_dez23_tabaux2 as
select  distinct
        '00411' as reporting_soc,        
        sociedade_contraparte, 
        cod_ajust,
        idcomb_satelite,
        cempresa_ct, 
        cbalcao_ct,
        cnumecta_ct,
        zdeposit_ct,
        saldo_ct, -- Exposição
        setor,
        `33_counterparty_type`,
        `29_flag_specialised_lending`,
        amount, 
        zcliente,
        ckbalbem,
        ckctabem,
        ckrefbem, 
        clase_energetica,
        `14_nace`,
        `84_dt_origination`,
        `93_european_union`,
        fiabilidad,
        sfcs_tag_comgloval,
        sfcs_green_activity_comgloval,
        tipo_produto,
 		`4_collateral_nuts`,
		`22_counterparty_nuts`,
		cfamilia,
		ckprodmi,
		cproduto,
		csubprod,
		cpais_residencia,
 		des_combustivel,
 		co2,
 		des_detalle_lease,
    case
        when sfcs_green_activity_comgloval = 'Agriculture, forestry and livestock' then 'GFI1'
        when sfcs_green_activity_comgloval = 'Manufacturing' then 'GFI1'
        when sfcs_green_activity_comgloval like 'Real estate%' then 'GFI1'
        when sfcs_green_activity_comgloval like 'Transport%' then 'GFI1'
        when sfcs_green_activity_comgloval like 'Energy%' then 'GFI1'
        when sfcs_green_activity_comgloval = 'Water and waste management' then 'GFI1'
        when sfcs_tag_comgloval = 'Sustainability Linked' and trim(sfcs_green_activity_comgloval) in ('N/A','n/a','') then 'GFI1'
        when ckprodmi in ('113EMP','075EMP') then 'GFI1'
        else 'GFI2'
    end as green_financial_instrument,

    case
    
     -- Building Renovation 
     
        when idcomb_satelite like '%SC0304%' and concat(cproduto,csubprod) in ('096HGP','0960H8','096065') and trim(nifrru)<>'' then 'PESG1'
            
     -- Motor Vehicle Loans    
        -- -	Gas and plug-in hybrid cars than pollute more than 50g CO2 per km
        when  idcomb_satelite like '%SC0304%' and (
                --(des_combustivel in ('HIBRIDO') and co2 > 50 and co2 <> '' and co2 is not null)  --- > De acordo com o email da Rute Ferreira recebido no dia 4/01 não existe informação nas tabelas de Lease que permita identificar plug-in
                --or

	    -- -	Electric and vehicles than pollute less than 50g CO2: loans granted before 01/01/2022                 
                (des_combustivel = 'ELECTRICO' and dabertur < '01/01/2022')
                or
	    -- -	Electric and vehicles than pollute less than 50g CO2: loans granted before 01/01/2022                 
                (des_combustivel = 'ELECTRICO' and des_detalle_lease not in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG'))
                or                
	    -- -	Electric and vehicles than pollute less than 50g CO2: loans granted before 01/01/2022                 
                (co2 <> '' and co2 is not null and cast(co2 as int) < 50 and dabertur < '01/01/2022')
                or
	    -- -	Electric and vehicles than pollute less than 50g CO2: different from categories M1 and N1                 
                (co2 <> '' and co2 is not null and cast(co2 as int) < 50 and des_detalle_lease not in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG'))
              )    
        then 'PESG2'
    
    	when  idcomb_satelite like '%SC0304%' and sfcs_green_activity_comgloval like 'Transport%' then 'PESG2' 
    	
     -- Building Acquisition Loans 
        when idcomb_satelite like '%SC0304%' and
            (
                (`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
        	    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
        	  or 
        	    (`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
        	    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
        	    
        	 )  
        	  and
        	
            -- Possui Risco Físico
          (
            case
                when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
                when a.ckbalbem IS NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk'
                when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
                when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
                when a.ckbalbem IS NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
                when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'
                else 'Without Physical Risk'	
            end
          ) = 'With Physical Risk' and
      
            -- Não possui ano de construção ou ano de construção é inferior a 2020
            (anoconst is null or anoconst='9999' or anoconst < '2020') and 
	
            -- Possui certificado energético real           
            fiabilidad in ('','1-REAL','SANTANDER') and 
        
            -- Possui classe energética A ou B -- ALTERAÇÃO GUIDELINES DEZ23     
            (clase_energetica like 'A%' or clase_energetica like 'B%') 
        then 'PESG3'
        
        when idcomb_satelite like '%SC0304%' and
	    (
	        (`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
		    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
		  or 
		    (`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
		    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
		    
		 )  
		  and sfcs_green_activity_comgloval like 'Real estate%' then 'PESG3'
                	
        when (idcomb_satelite like '%SC0301%' or idcomb_satelite like '%SC0302%' or idcomb_satelite like '%SC0303%') then ''        
		when idcomb_satelite like '%SC0304%' and sfcs_green_activity_comgloval = 'Agriculture, forestry and livestock' then 'PESG4'
		when idcomb_satelite like '%SC0304%' and sfcs_green_activity_comgloval = 'Manufacturing' then 'PESG4'
		when idcomb_satelite like '%SC0304%' and sfcs_green_activity_comgloval like 'Energy%' then 'PESG4'
		when idcomb_satelite like '%SC0304%' and sfcs_tag_comgloval = 'Sustainability Linked' and trim(sfcs_green_activity_comgloval) in ('N/A','n/a','') then 'PESG4'
        else '' end as purpose_esg,

        case
            when sfcs_green_activity_comgloval = 'Agriculture, forestry and livestock' then 'FUTY1'
            when sfcs_tag_comgloval = 'Sustainability Linked' and trim(sfcs_green_activity_comgloval) in ('N/A','n/a','') then 'FUTY2'
		    when sfcs_green_activity_comgloval = 'Manufacturing' then 'FUTY4'
		    when ckprodmi in ('113EMP','075EMP') then 'FUTY4' -- GREEN BONDS
            
    
     -- Building Renovation 
     
        when idcomb_satelite like '%SC0304%' and concat(cproduto,csubprod) in ('096HGP','0960H8','096065') and trim(nifrru)<>'' then 'FUTY4'    
    
    
     -- Building Acquisition Loans 
        when idcomb_satelite like '%SC0304%' and
            (
                (`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
        	    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
        	  or 
        	    (`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
        	    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
        	    
        	 )  
        	  and
        	
            -- Possui Risco Físico
          (
            case
                when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
                when a.ckbalbem IS NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk'
                when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
                when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
                when a.ckbalbem IS NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
                when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'
                else 'Without Physical Risk'	
            end
          ) = 'With Physical Risk' and
      
            -- Não possui ano de construção ou ano de construção é inferior a 2020
            (anoconst is null or anoconst='9999' or anoconst < '2020') and 
	
            -- Possui certificado energético real           
            fiabilidad in ('','1-REAL','SANTANDER') and 
        
            -- Possui classe energética A ou B -- ALTERAÇÃO GUIDELINES DEZ23     
            (clase_energetica like 'A%' or clase_energetica like 'B%') 
        then 'FUTY4'
        
        when idcomb_satelite like '%SC0304%' and
	    (
	        (`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
		    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
		  or 
		    (`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
		    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
		    
		 )  
		  and sfcs_green_activity_comgloval like 'Real estate%' then 'FUTY4'            
            
        -- Motor Vehicle Loans 
            -- COMPLETAR
            -- o	Plug-in hybrid electric vehicles (PHEV) or gas vehicles that pollute more than 50g of CO2 
            -- o	Electric and other vehicles from categories distinct to M1 and N1 polluting less than 50g CO2/Km 
            when des_detalle_lease not in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG') and cast(co2 as int) < 50 and co2 <> '' and co2 is not null then 'FUTY4'
            -- o	Car loans aligned with EU Taxonomy (i.e.: electric or hybrids cars from category M1 and N1 polluting less than 50g CO2/Km) but granted before 01/01/2022
            when des_combustivel in ('HIBRIDO','ELECTRICO','HIBRIDO/GASOLINA','HIBRIDO/GASOLEO') and
            	des_detalle_lease in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG') and 
            	cast(co2 as int) < 50 and co2 <> '' and co2 is not null and
            	dabertur < '01/01/2022'
            then 'FUTY4'
            
			when(		
				case when 
				
						(
							case when idcomb_satelite like '%SC0304%' and concat(cproduto,csubprod) in ('096HGP','0960H8','096065') and trim(nifrru)<>'' then 'PESG1'
								 when idcomb_satelite like '%SC0304%' and concat(cproduto,csubprod) in ('096HGP', '0960H8', '096065') and (clase_energetica like 'A%' or clase_energetica like 'B%') then 'PESG1'
							end
						  ) <> 'PESG1' and
				
				
				         (
							case when idcomb_satelite like '%SC0304%' and
							(
								(`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
								and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
							  or 
								(`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
								and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
								
							 )  then 'PESG3' end 
						  ) <> 'PESG3' and 
						  
						  ( 
							case when idcomb_satelite like '%SC0304%' and
								(
									(`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
									and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
								  or 
									(`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
									and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
									
								 )  
								  and sfcs_green_activity_comgloval like 'Real estate%' then 'PESG3' end
						   ) <> 'PESG3'
			    
				then 'Y' else '' end
				) = 'Y' then 'FUTY4'
				            
        	when sfcs_green_activity_comgloval like 'Transport%' then 'FUTY4'
        	when sfcs_green_activity_comgloval like 'Energy%' then 'FUTY4'
		    when sfcs_green_activity_comgloval = 'Water and waste management' then 'FUTY4'        	
            else ''
        end as funding_type,
		
        case
            when sfcs_green_activity_comgloval = 'Agriculture, forestry and livestock' then 'RMCT1'
            -- when c.sfcs_green_activity_comgloval = 'Water and waste management' then 'RMCT1' -- No pioto Jun23 a atividade passou a estar alinhada com a Taxonomia Europeia
            when sfcs_tag_comgloval = 'Sustainability Linked' and trim(sfcs_green_activity_comgloval) in ('N/A','n/a','') then 'RMCT1'
            else 'RMCT1' -- Por defeito é marcado policy and legal risk
        end as risk_mitigated_cct,
        
        case
            when sfcs_green_activity_comgloval = 'Agriculture, forestry and livestock' then 'RMCP1' -- De acordo com as guidelines a atividade "4.5 Land conservation and restoration & soil remediation" contribui para mitigar physical risk (chronic) (de acordo com informação do Bernardo Vedor, 'Agriculture, forestry and livestock' diz respeito ao 4.5 das classes SFCS)
            when sfcs_tag_comgloval = 'Sustainability Linked' and trim(sfcs_green_activity_comgloval) in ('N/A','n/a','') then 'RMCP3' -- de acordo com as guidelines as operações com Policy & Legal risk por default, devem marcar como "Non mitigated"
			-- when c.sfcs_green_activity_comgloval = 'Water and waste management' then 'RMCP3' -- No pioto Jun23 a atividade passou a estar alinhada com a Taxonomia Europeia
			else 'RMCP3'
        
        end as risk_mitigated_ccp,
		
		case 
     -- Building Renovation 
     
        when idcomb_satelite like '%SC0304%' and concat(cproduto,csubprod) in ('096HGP','0960H8','096065') and trim(nifrru)<>'' then 'Building Renovation'    
    
    
     -- Building Acquisition Loans 
        when idcomb_satelite like '%SC0304%' and
            (
                (`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
        	    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
        	  or 
        	    (`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
        	    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
        	    
        	 )  
        	  and
        	
            -- Possui Risco Físico
          (
            case
                when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
                when a.ckbalbem IS NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk'
                when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
                when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
                when a.ckbalbem IS NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
                when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'
                else 'Without Physical Risk'	
            end
          ) = 'With Physical Risk' and
      
            -- Não possui ano de construção ou ano de construção é inferior a 2020
            (anoconst is null or anoconst='9999' or anoconst < '2020') and 
	
            -- Possui certificado energético real           
            fiabilidad in ('','1-REAL','SANTANDER') and 
        
            -- Possui classe energética A ou B -- ALTERAÇÃO GUIDELINES DEZ23     
            (clase_energetica like 'A%' or clase_energetica like 'B%') 
        then 'Building Acquisition'
        
        when idcomb_satelite like '%SC0304%' and
	    (
	        (`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
		    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
		  or 
		    (`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
		    and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
		    
		 )  
		  and sfcs_green_activity_comgloval like 'Real estate%' then 'Building Acquisition'  		    
		    
		    
		    when sfcs_green_activity_comgloval = 'Agriculture, forestry and livestock' then '' -- DEVIDO A ESTAR MONTADO EM CASCATA, EXISTEM GREEN BONDS QUE NAO SAO MARCADAS COMO TAL PORQUE FICAM COMO AGRICULTURA, DESTE MODO TEMREMOS DE MAPEAR O COMMENT A NULO PARA NAO TERMOS COMMMENT PARA COISAS QUE POSSUEM funding_type <> 'FUTY4'
		    when sfcs_tag_comgloval = 'Sustainability Linked' and trim(sfcs_green_activity_comgloval) in ('N/A','n/a','') then ''
		    when sfcs_green_activity_comgloval = 'Manufacturing' then 'Manufacturing'
		    when ckprodmi in ('113EMP','075EMP') then 'Green Bonds'
        	when sfcs_green_activity_comgloval like 'Transport%' then 'Land Transport'
        	when sfcs_green_activity_comgloval like 'Energy%' then 'Energy'		    
		    when sfcs_green_activity_comgloval = 'Water and waste management' then 'Water and waste management'        	
		    when des_detalle_lease not in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG') and 
		    	cast(co2 as int) < 50 and co2 <> '' and co2 is not null 
		    then 'Electric and other vehicles from categories distinct to M1 and N1 polluting less than 50g CO2/Km'
			when des_combustivel in ('HIBRIDO','ELECTRICO','HIBRIDO/GASOLINA','HIBRIDO/GASOLEO') and
            	des_detalle_lease in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG') and 
            	cast(co2 as int) < 50 and co2 <>'' and co2 is not null and
            	dabertur < '01/01/2022'
            then 'Car loans aligned with EU Taxonomy (i.e.: electric or hybrids cars from category M1 and N1 polluting less than 50g CO2/Km) but granted before 01/01/2022'
			when(		
				case when 
				
						(
							case when idcomb_satelite like '%SC0304%' and concat(cproduto,csubprod) in ('096HGP','0960H8','096065') and trim(nifrru)<>'' then 'PESG1'
								 when idcomb_satelite like '%SC0304%' and concat(cproduto,csubprod) in ('096HGP', '0960H8', '096065') and (clase_energetica like 'A%' or clase_energetica like 'B%') then 'PESG1'
							end
						  ) <> 'PESG1' and
				
				
				         (
							case when idcomb_satelite like '%SC0304%' and
							(
								(`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
								and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
							  or 
								(`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
								and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
								
							 )  then 'PESG3' end 
						  ) <> 'PESG3' and 
						  
						  ( 
							case when idcomb_satelite like '%SC0304%' and
								(
									(`33_counterparty_type` = 'particulares' and cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
									and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065')) 
								  or 
									(`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and cfamilia in ('02','03','04')
									and concat(cproduto,csubprod) not in ('096HGP','0960H8','096065'))
									
								 )  
								  and sfcs_green_activity_comgloval like 'Real estate%' then 'PESG3' end
						   ) <> 'PESG3'
			    
				then 'Y' else '' end
				) = 'Y' then 'Real estate - Others'		

		else '' end as comment_

from (select  * from bu_esg_work.pilar3_sat83_dez23_tabaux1) as a

-- risco físico real para colaterais
left join (select * from bu_esg_work.pilar3_physical_risk_dez23 where nace_code like '%Secured%') as prhipotec1 
on a.`4_collateral_nuts` = prhipotec1.nuts_code

-- risco físico real para idcombs com colaterais imobiliarios, mas sem colaterais associados
left join (select * from bu_esg_work.pilar3_physical_risk_dez23 where nace_code like '%Secured%') as prhipotec3 
on a.`22_counterparty_nuts` = prhipotec3.nuts_code

-- risco físico proxy para colaterais
left join (select * from bu_esg_work.pilar3_proxy_physical_risk_dez23 where nace like '%Secured%') as prhipotec2 
on prhipotec2.country = 'PT'	

left join (
		Select 	a.*, 
				b.id
from bu_esg_work.pilar3_physical_risk_dez23 a 
left join  bu_esg_work.nace_esg_pillar3 as b 
on concat(split_part(a.nace_code,".",1),
	    case when a.nace_code like 'A.%'or a.nace_code like 'B.%' then SUBSTRING(A.nace_code,4,1)
				else SUBSTRING(A.nace_code,3,2) end) 
= trim(split_part(b.nace_level4, "-",1))) as prgeral1
	on a.`22_counterparty_nuts` = prgeral1.nuts_code
		and left(a.nace_esg,8) = prgeral1.id    

left join 
( select a.*, 
			   b.tayd91c0_celemtab as iso_code, 
			   c.id
		from 
			(Select *, 
					concat(split_part(nace,".",1), case when nace like 'A.%' or nace like 'B.%' then SUBSTRING(nace,4,1) else SUBSTRING(nace,3,2) end) as nace_level4
						from bu_esg_work.pilar3_proxy_physical_risk_dez23) a
		left join 
		(select * 
			from cd_estruturais.tat91_tabelas
				where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}") and tayd91c0_ctabela = '015')b
						on a.country=b.tayd91c0_nelemc09			
		left join
				bu_esg_work.nace_esg_pillar3 as c
					on a.nace_level4 = trim(split_part(c.nace_level4, "-",1))
) as prgeral2
on cast(coalesce(a.cpais_residencia,'620') as string) = prgeral2.iso_code
and left(a.nace_esg,8) = prgeral2.id


;

-- Piloto Jun23 ==> 57 Registos
--              ==> 53 465 975 230

-- Dez23        ==>  68 registos 
--              ==> -53 399 236 253 € 
 	
drop table bu_esg_work.pilar3_sat83_dez23_tabaux3;
create table bu_esg_work.pilar3_sat83_dez23_tabaux3 as
select 
    reporting_soc,
    case 
        when sociedade_contraparte = '' or sociedade_contraparte ='01278' then '00000'
        else sociedade_contraparte
    end as counterparty_soc,
    'BI00411' as adjustment_code,
    case
        when green_financial_instrument = 'GFI2' then concat(idcomb_satelite,';',green_financial_instrument)
        when idcomb_satelite like '%SC0304%' then concat(idcomb_satelite,';',purpose_esg,';',green_financial_instrument,';',funding_type,';',risk_mitigated_cct,';',risk_mitigated_ccp)
        else concat(idcomb_satelite,';',green_financial_instrument,';',funding_type,';',risk_mitigated_cct,';',risk_mitigated_ccp)
    end as id_comb,
    -round(sum(amount),0) as amount,
    case when funding_type = 'FUTY4' then comment_ else '' end as dcon

from bu_esg_work.pilar3_sat83_dez23_tabaux2
group by 1,2,3,4,6
;

-- Piloto Jun23 ==> 55 Registos
--              ==> 53 465 975 230

-- Dez23        ==>  66 registos 
--              ==> -53 399 236 253 € 
-- 
-- alteração do idcomb com atributos MC04 e COLL4 para COLL1
drop table bu_esg_work.pilar3_sat83_dez23_tabaux4;
create table bu_esg_work.pilar3_sat83_dez23_tabaux4 as
select 
	reporting_soc,
	counterparty_soc,
	adjustment_code,
	case
		when id_comb like '%MC04%COLL4%' then replace(id_comb,'COLL4','COLL1')
		when id_comb like '%SC02%COLL3%' then replace(id_comb,'COLL3','COLL1')
		else id_comb
	end as id_comb,
	sum(amount) as amount,
	dcon

from bu_esg_work.pilar3_sat83_dez23_tabaux3
group by 1,2,3,4,6;


