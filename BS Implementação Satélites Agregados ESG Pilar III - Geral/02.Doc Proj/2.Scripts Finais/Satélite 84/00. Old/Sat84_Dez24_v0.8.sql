---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                                    Pressupostos a assegurar antes da corrida do processo                                                              --
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Validar que os ficheiro de input se encontram atualizados:
 -- "20221222 Pillar 3 ESG - eligibility ratios.v5"
 -- "20231006_Pillar 3 ESG - GAR External Data_v4"
 -- "20221222 Pillar 3 ESG - eligibility ratios.v5"

-- UNIVERSO FULL SAT 84 (SEM ADJUDICADOS): -47 179 239 387.184385

-------------------------------------------------------------------------------------------------------------------------
------------------------------------TABELAS AUXILIARES PARA CONSTRUÇÂO DO SAT 84 ----------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- Jun24 (v2)   ==>  2 782 897 registos  
--              ==>  67 021 047 311.97 (Diferença de 2.294 € face ao univero full)

-- Dez24        ==> 2 845 751 registos  
--              ==> 67 708 032 144.48 (Diferença de 2.494 € face ao univero full)

-- drop table bu_esg_work.pilar3_sat84_Dez24_tabaux1;
create table bu_esg_work.pilar3_sat84_Dez24_tabaux1 as
select  
		a.csatelite,
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
		b.flag_SPV,
        -(a.saldo_ct)*pesos.peso as amount, 
        b.zcliente,
        b.ckbalbem,
        b.ckctabem,
        b.ckrefbem, 
        b.clase_energetica,
        b.`14_nace`,
        b.`15_nace_esg`,        
        b.`84_dt_origination`,
        b.`93_european_union`,
		b.`5_collateral_zip_code`,
		b.`23_counterparty_ZIPcode`,
		case 
            when b.ckbalbem is null then 0
            else 1
        end as flag_hipotec,	
		
        -- Remapeamento dos códigos NUTS uma vez que o input da corporação não incorpora as alterações feita pela União Europeia em 2024:
		CASE WHEN trim(b.`4_collateral_nuts`) = 'PT195' THEN 'PT16H'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1D2' THEN 'PT16I'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1D1' THEN 'PT16B'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT191' THEN 'PT16D'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT192' THEN 'PT16E'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT193' THEN 'PT16F'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT194' THEN 'PT16G'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1C1' THEN 'PT181'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1C2' THEN 'PT184'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1D3' THEN 'PT185'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1C3' THEN 'PT186'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1C4' THEN 'PT187'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT196' THEN 'PT116J'
			 WHEN trim(b.`4_collateral_nuts`) IN ('PT1B0', 'PT1A0') THEN 'PT170'
			 ELSE b.`4_collateral_nuts`
		END AS `4_collateral_nuts`,
		
		-- Remapeamento dos códigos NUTS uma vez que o input da corporação não incorpora as alterações feita pela União Europeia em 2024:
		CASE WHEN trim(b.`22_counterparty_nuts`) = 'PT195' THEN 'PT16H'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT1D2' THEN 'PT16I'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT1D1' THEN 'PT16B'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT191' THEN 'PT16D'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT192' THEN 'PT16E'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT193' THEN 'PT16F'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT194' THEN 'PT16G'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT1C1' THEN 'PT181'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT1C2' THEN 'PT184'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT1D3' THEN 'PT185'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT1C3' THEN 'PT186'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT1C4' THEN 'PT187'
			 WHEN trim(b.`22_counterparty_nuts`) = 'PT196' THEN 'PT116J'
			 WHEN trim(b.`22_counterparty_nuts`) IN ('PT1B0', 'PT1A0') THEN 'PT170'
			 ELSE b.`22_counterparty_nuts`
		END AS `22_counterparty_nuts`,
		
        b.cpais_residencia,
        b.fiabilidad
from 
(select
            csatelite,
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
    from bu_esg_work.rf_pilar3_universo_full                       -- ALTERADA TABELA PARA NOVA TABELA DE IDCOMBS DA DATA DE REPORTE
        where DT_RFRNC = '${ref_date}' 
		and ID_CORRIDA = '1'
		and csatelite in (84,222) 
		and idcomb_satelite not like '%MC10%'       	
            group by
                csatelite,
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
					GAR.`5_collateral_zip_code` ,
					GAR.`23_counterparty_ZIPcode`,					
					GAR.flag_SPV,
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
				    FROM bu_esg_work.p3_reparticao_garantias
					where DT_RFRNC = '${ref_date}' 
					and ID_CORRIDA in (select max(id_corrida) from  bu_esg_work.p3_reparticao_garantias  where DT_RFRNC = '${ref_date}' ) 
				) GAR
				LEFT JOIN
				(
				    SELECT *
				    FROM bu_esg_work.gloval_clase_energetica_Dez24
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
    from bu_esg_work.rf_pilar3_pesos_Dez24
) as pesos
    on  a.cempresa_ct = pesos.cempresa_ct
    and a.cbalcao_ct  = pesos.cbalcao_ct
    and a.cnumecta_ct = pesos.cnumecta_ct
    and a.zdeposit_ct = pesos.zdeposit_ct
    and coalesce(b.ckbalbem,'0') = coalesce(pesos.ckbalbem, '0')
    and coalesce(b.ckctabem,'0') = coalesce(pesos.ckctabem, '0')
    and coalesce(b.ckrefbem,'0') = coalesce(pesos.ckrefbem, '0')
;

-- Dez24        ==> 2 845 751 registos 
-- Dez24_v2     ==> 2 845 751 registos 

-- Tabela auxiliar de mapeamento de SFICS
-- drop table bu_esg_work.pilar3_sat84_Dez24_tabaux1_SFICS_v2
create table bu_esg_work.pilar3_sat84_Dez24_tabaux1_SFICS_v2 as
select   a.*
		,c.sfcs_green_activity_comgloval
		,c.tipo_produto
		,c.sfcs_tag_comgloval
		,c.des_detalle_lease
		,c.des_combustivel
		,c.dinioper
		,c.co2
		,c.cmetanseg
		,c.flag_green_dashboard
		,c.ckprodmi
		,c.activity_template
        ,CASE
                WHEN SFICS.cempresa_ct IS NOT NULL THEN SFICS.SFICS
                WHEN activity_template = 'AGFGR001' THEN 'A.1.1'
                WHEN activity_template = 'AGFGR002' THEN 'A.2.3'
                WHEN activity_template = 'AGFGR006' THEN 'A.3.1'
                WHEN activity_template = 'AGFGR007' THEN 'A.3.2'
                WHEN activity_template = 'AGFGR008' THEN 'A.3.7'
		        WHEN activity_template = 'AGFSO001' THEN 'A.5.2'
         END AS SFICS
from bu_esg_work.pilar3_sat84_Dez24_tabaux1 a
left join 
-- JB (23/07/2024): ROW_NUMBER adicionado para mitigar duplicações por cmetanseg (Email enviado a CdG a 23/07). Avaliar se necessário no próximo exercício.     
-- AR (21/01/2025): Acontece a Dez24 e foi corrigido usando a metodologia indicada por CdG a Jun24
(SELECT * FROM    
  (SELECT ROW_NUMBER () OVER (PARTITION BY cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct,ckbalbem,ckctabem,ckrefbem 
								ORDER BY case when cmetanseg like 'EB%' then 1 else 0 end  DESC) AS ORDEM,
			c1.* 
	from  
	(select  
				cempresa_ct,
				cbalcao_ct,
				cnumecta_ct,
				zdeposit_ct,
				case when ckbalbem = '' then null else ckbalbem end as ckbalbem,
				case when ckctabem = '' then null else ckctabem end as ckctabem,
				case when ckrefbem = '' then null else ckrefbem end as ckrefbem,                       
				sfcs_green_activity_comgloval,
				tipo_produto,
				sfcs_tag_comgloval,
				des_detalle_lease,
				des_combustivel,
				dinioper,
				cast(co2 as int) as co2,
				case when cmetanseg like 'EB%' then cmetanseg else '' end as cmetanseg,
				flag_green_dashboard,
				ckprodmi,
				activity_template
			from bu_esg_work.rf_pilar3_cdg_tabaux1_Dez24_v2                
			where sfcs_tag_comgloval not in ('No Elegible', 'Sin información') and sfcs_tag_comgloval is not null
	) c1) c2  where ordem = 1) as c			
on a.cempresa_ct = c.cempresa_ct
and a.cbalcao_ct = c.cbalcao_ct
and a.cnumecta_ct = c.cnumecta_ct
and a.zdeposit_ct = c.zdeposit_ct
and coalesce(a.ckbalbem,'') = coalesce(c.ckbalbem, '')
and coalesce(a.ckctabem,'') = coalesce(c.ckctabem, '')
and coalesce(a.ckrefbem,'') = coalesce(c.ckrefbem, '')
left join 
	(
		select distinct cempresa_ct,
						cbalcao_ct,
						cnumecta_ct,
						zdeposit_ct,
						case when sfcis in ('A.3.7.2.1','A.3.7.5.2','A.3.7.2.2') then 'A.3.7'
						     when sfcis in ('A.3.1.2.1','A.3.1.2.2') then 'A.3.1'
						else sfcis
						end as sfics
		from bu_esg_work.mapeamento_sfics_dez24
	) SFICS
ON concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct)=concat(SFICS.cempresa_ct,SFICS.cbalcao_ct,SFICS.cnumecta_ct,SFICS.zdeposit_ct)




-- Jun24        ==>  2 782 897   registos  
--              ==>  67 021 047 311.97 (Diferença de 2.294 € face ao univero full)

-- Dez24        ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- Dez24_v3     ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- Dez24_v4     ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- drop table if exists bu_esg_work.pilar3_sat84_Dez24_tabaux2_v6;
create table bu_esg_work.pilar3_sat84_Dez24_tabaux2_v6 as
select  distinct
		a.csatelite,
        a.sociedade_contraparte, 
        a.idcomb_satelite,
        a.cempresa_ct, 
        a.cbalcao_ct,
        a.cnumecta_ct,
        a.zdeposit_ct,
        a.cod_ajust,
        a.saldo_ct, -- Exposição
        a.setor,
		a.`15_nace_esg`,
        a.`33_counterparty_type`,
        a.`29_flag_specialised_lending`,
		a.flag_SPV,
        a.`93_european_union`,
        a.`4_collateral_nuts`,
        a.`22_counterparty_nuts`,  
		a.`5_collateral_zip_code`,
		a.`23_counterparty_ZIPcode`,		
        a.cpais_residencia,     
        a.amount,
        a.zcliente,
        a.ckbalbem,
        a.ckctabem,
        a.ckrefbem, 
        a.clase_energetica,
        a.fiabilidad,
		a.flag_hipotec,
        a.sfcs_green_activity_comgloval,
        a.sfcs_tag_comgloval,
        a.tipo_produto,
        a.cmetanseg,
        a.ckprodmi,
        a.dinioper,
        a.des_detalle_lease,
        a.des_combustivel,
        a.co2,   		
        ct003.cnatureza_juri,
        EPT01.nifrru,
        ct004.cproduto,
        ct004.csubprod,
		sfics,
		cfamilia,
        case 
        	when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'instituicoes de credito' then 'INVS2'
        	when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'setor publico' then 'INVS3'
        	when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras instituicoes financeiras' then 'INVS4'
        	when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' then 'INVS5'
        else '' end as investment_sector,	
        case
            when a.idcomb_satelite like '%SC0301%' and a.`33_counterparty_type` = 'setor publico' and 
            	ct003.cnatureza_juri in ('121100','121210','121220','211110','211120','211130','221100','221210','121231') then'Sovereigns'  --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
            when a.idcomb_satelite like '%SC0301%' and a.`33_counterparty_type` = 'setor publico' then 'Local Governments' 
            when a.idcomb_satelite like '%SC0301%' then 'Local Governments'
            when a.idcomb_satelite like '%SC0302%' and a.`14_nace` in ('K65.3.0','K66.1.1','K64.3.0','K66.1.2','K66.3.0')    ---  MAPEAMENTO EM REVISÃO POR BUZÓN MAS MANTER PARA PILOTO JUN23
                and a.`33_counterparty_type` = 'outras instituicoes financeiras' then 'Investment firms'
            when a.idcomb_satelite like '%SC0302%' and a.`14_nace` in ('K66.1.9','K64.2.0')   ---  MAPEAMENTO EM REVISÃO POR BUZÓN MAS MANTER PARA PILOTO JUN23
                and a.`33_counterparty_type` = 'outras instituicoes financeiras' then 'Management firms'          
            when a.idcomb_satelite like '%SC0302%' and a.`14_nace` in ('K65.1.1','K65.1.2','K65.2.0', 'K66.2.1','K66.2.2','K66.2.9')    ---  MAPEAMENTO EM REVISÃO POR BUZÓN MAS MANTER PARA PILOTO JUN23
                and a.`33_counterparty_type` = 'outras instituicoes financeiras' then 'Insurance undertakings'          
            when a.idcomb_satelite like '%SC0302%' and a.`33_counterparty_type` = 'outras instituicoes financeiras' then 'Rest of other financial corporation'
            when a.idcomb_satelite like '%SC0302%' and a.`33_counterparty_type` = 'instituicoes de credito'  and a.`14_nace` in ('K64.1.1','K64.1.9','K64.9.1','K64.9.2','K64.9.9') then 'Rest of other financial corporation' ---  MAPEAMENTO EM REVISÃO POR BUZÓN MAS MANTER PARA PILOTO JUN23
            when a.idcomb_satelite like '%SC0302%' then 'Rest of other financial corporation'
            when (a.idcomb_satelite like '%MC08%' and a.`33_counterparty_type` = 'outras instituicoes financeiras') then 'Rest of other financial corporation'            
        else '' end as esg_subsector_name,

       
        case 
        
            when a.idcomb_satelite like '%MC42%' OR a.idcomb_satelite like '%MC43%' then '' -- Off balance
		 
			when a.idcomb_satelite like '%MC13%' then ''
		 
		 -- Sovereings
		 
        	when a.idcomb_satelite like '%SC0301%' and a.`33_counterparty_type` = 'setor publico' and 	
        		ct003.cnatureza_juri in ('121100','121210','121220','211110','211120','211130','221100','221210','121231') then '' --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL

         -- Building renovation loans:
         
         -- Dez24: Atualização do mapeamento de 096.0H8 para 096.HH2
            when a.`33_counterparty_type` in ('particulares','outras empresas nao financeiras') and concat(ct004.cproduto,ct004.csubprod) in ('096HGP','0960H8','096065') 
            			then 'Building Renovation Loans'  
            when a.`33_counterparty_type` in ('particulares','outras empresas nao financeiras') and trim(ept01.nifrru) <> '' then 'Building Renovation Loans'   -- IDENTIFICAÇÃO DE IFRRU
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' and concat(ct004.cproduto,ct004.csubprod) in ('096HGP','0960H8','096065') 
            			then 'Building Renovation Loans'          
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' and trim(ept01.nifrru) <> '' then 'Building Renovation Loans'   -- IDENTIFICAÇÃO DE IFRRU
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' and concat(ct004.cproduto,ct004.csubprod) in ('096HGP','0960H8','096065') then 'Building Renovation Loans'   -- IDENTIFICAÇÃO DE IFRRU            		   			         
 
         -- Building Acquisition Loans (cfamilia --> consultar tat em '245')	
            when a.`33_counterparty_type` = 'particulares' and ept01.cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
            	and concat(ct004.cproduto,ct004.csubprod) not in ('096HGP','0960H8','096065') then 'Building Acquisition Loans'
            when a.`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and ept01.cfamilia in ('02','03','04')
            	and concat(ct004.cproduto,ct004.csubprod) not in ('096HGP','0960H8','096065') then 'Building Acquisition Loans'              	
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' and ept01.cfamilia in ('02','03','04')
            	and concat(ct004.cproduto,ct004.csubprod) not in ('096HGP','0960H8','096065') then 'Building Acquisition Loans'      
				
        
        -- Motor Vehicle Loans
            when a.`33_counterparty_type` in ('particulares','outras empresas nao financeiras') 
            	and concat(ct004.cproduto,ct004.csubprod) in ('000045','000051','000053') then 'Motor vehicle loans'
			when  a.`33_counterparty_type` in ('particulares','outras empresas nao financeiras') 
            	and concat(ct004.cproduto,ct004.csubprod) ='000042' and 
				(des_detalle_lease in ('COMERCIAIS DE 2601KG A 3500KG','TT DE 2601KG A 3500KG','MOTOCICLOS CILINDRADA SUPERIOR A 50CM3','TT DE 1601KG A 2600KG','EMBARCACOES','COMERCIAIS ATE 1600KG','REBOQUE/SEMI-REBOQUE C/MATRICULA','TT ATE 1600KG','VEICULOS LIGEIROS DE PASSAGEIROS','VEICULOS PESADOS DE MERCADORIAS','COMERCIAIS DE 1601KG A 2600KG','VEICULOS PESADOS DE PASSAGEIROS','CICLOMOTOR OU MOTOCICLO AT� 50CM3'))
				then 'Motor vehicle loans'
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras'
            	and concat(ct004.cproduto,ct004.csubprod) in ('000045','000051','000053') then 'Motor vehicle loans' 
			when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras'
            	and concat(ct004.cproduto,ct004.csubprod) ='000042' and 
				(des_detalle_lease in ('COMERCIAIS DE 2601KG A 3500KG','TT DE 2601KG A 3500KG','MOTOCICLOS CILINDRADA SUPERIOR A 50CM3','TT DE 1601KG A 2600KG','EMBARCACOES','COMERCIAIS ATE 1600KG','REBOQUE/SEMI-REBOQUE C/MATRICULA','TT ATE 1600KG','VEICULOS LIGEIROS DE PASSAGEIROS','VEICULOS PESADOS DE MERCADORIAS','COMERCIAIS DE 1601KG A 2600KG','VEICULOS PESADOS DE PASSAGEIROS','CICLOMOTOR OU MOTOCICLO AT� 50CM3'))				
				then 'Motor vehicle loans'

        -- Condição geral
            when (a.idcomb_satelite like '%SC0301%' or a.idcomb_satelite like '%SC0303%')  
            			and a.sfcs_green_activity_comgloval not in ('N/A', 'n/a', '','No Elegible', 'Sin información') and (a.sfcs_green_activity_comgloval is not null) then 'Other Purpose' 

            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' 
            			and a.sfcs_green_activity_comgloval not in ('N/A', 'n/a', '','No Elegible', 'Sin información') and (a.sfcs_green_activity_comgloval is not null) then 'Other Purpose'             			
        -- Specialised Lending            
            when (a.`29_flag_specialised_lending` = '1') then 'Other Purpose'
        
		-- SPV
			when (a.flag_SPV = '1') then 'Other Purpose'
			
		-- SFICS
			
			when sfics in ('C.SLL', 'Pure Green') then ''
		
			when (a.idcomb_satelite like '%SC0301%' or a.idcomb_satelite like '%SC0303%') and trim(sfics) <> '' and sfics not in ('C.SLL', 'Pure Green') then 'Other Purpose'  	
		
        else '' end as 102_purpose_esg, 
                 
    -- Mapeamento da flag de NFRD através da tabela criada acima
        case
            when (a.idcomb_satelite like '%SC0302%' or a.idcomb_satelite like '%SC0303%') -- 'outras instituicoes financeiras','outras empresas nao financeiras'
            	and FLAG_NFRD_AUX.flg_nfrd = 1
            then 'Subject to NFRD'
            
            when a.idcomb_satelite like '%MC08%' and -- join ventures
	            a.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') and
	            FLAG_NFRD_AUX.flg_nfrd = 1
            then 'Subject to NFRD'   

            when a.idcomb_satelite like '%SC02%' -- 'instituicoes de credito'
	            and FLAG_NFRD_AUX.flg_nfrd = 1
            then 'Subject to NFRD'                         
            
            when (a.idcomb_satelite like '%SC0302%' or a.idcomb_satelite like '%SC0303%')
            	and (FLAG_NFRD_AUX.flg_nfrd <> 1 OR FLAG_NFRD_AUX.flg_nfrd IS NULL)
            then 'Not Subject to NFRD'
            
            when a.idcomb_satelite like '%MC08%'
	            and a.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
	            and (FLAG_NFRD_AUX.flg_nfrd <> 1 OR FLAG_NFRD_AUX.flg_nfrd IS NULL)
            then 'Not Subject to NFRD' 
            
            when a.idcomb_satelite like '%SC02%'
	            and (FLAG_NFRD_AUX.flg_nfrd <> 1 OR FLAG_NFRD_AUX.flg_nfrd IS NULL) 
            then 'Not Subject to NFRD'             
            
            -- Todas as SC02/SC0302/SC0303 deverão ter marcação de NFRD (por isso tudo o que não cai no Sujeito será Não Sujeito)
            when (a.idcomb_satelite like '%SC0302%' or a.idcomb_satelite like '%SC0303%' or a.idcomb_satelite like '%SC02%') then 'Not Subject to NFRD'                
          
            when a.idcomb_satelite like '%MC08%' and a.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') then 'Not Subject to NFRD'                       
            
            else ''
        end as flag_nfrd,
    -- Mapeamento do Originated During Period
        case 
            when a.`84_dt_origination` >= '${ref_date_ini}' then 'ORDP1'		-- No reporte de junho 2024 foi utilizada a data 2024-01-01.
            else 'ORDP2'
        end as originated_during_period, 
        
        case
            
            when a.idcomb_satelite like '%MC42%' OR a.idcomb_satelite like '%MC43%' then '' -- Loan commitments given e Other commitments given
        
			when a.idcomb_satelite like '%MC13%' then ''
		
        	when a.idcomb_satelite like '%SC0301%' and a.`33_counterparty_type` = 'setor publico' and 
        		ct003.cnatureza_juri in ('121100','121210','121220','211110','211120','211130','221100','221210','121231') then 'General Purpose' --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
      	 
         -- Building renovation loans:
         
         -- Dez24: Atualização do mapeamento de 096.0H8 para 096.HH2
            when a.`33_counterparty_type` in ('particulares','outras empresas nao financeiras') and concat(ct004.cproduto,ct004.csubprod) in ('096HGP','0960H8','096065') -- PRODUTOS DISPONIBILIZADOS POR CDG E APROVADOS PELA SUSANA
            			then 'Specific Purpose'
            when a.`33_counterparty_type` in ('particulares','outras empresas nao financeiras') and trim(ept01.nifrru) <> '' then 'Specific Purpose'   -- IDENTIFICAÇÃO DE IFRRU
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' and concat(ct004.cproduto,ct004.csubprod) in ('096HGP','0960H8','096065') 
            			then 'Specific Purpose'
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' and trim(ept01.nifrru) <> '' then 'Specific Purpose'   -- IDENTIFICAÇÃO DE IFRRU
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' and concat(ct004.cproduto,ct004.csubprod) in ('096HGP','0960H8','096065') then 'Specific Purpose'   -- IDENTIFICAÇÃO DE IFRRU            		   			         
 
         -- Building Acquisition Loans (cfamilia --> consultar tat em '245')
            when a.`33_counterparty_type` = 'particulares' and ept01.cfamilia in ('02','03','04') and idcomb_satelite like '%COLL2%' -- FOI FORÇADO A SEREM APENAS COLL2 PORQUE CORPORAÇÃO APENAS PERMITE QUE ACQUISITION SEJA ASSOCIADO A COLL2
            	and concat(ct004.cproduto,ct004.csubprod) not in ('096HGP','0960H8','096065') then 'Specific Purpose'
            when a.`33_counterparty_type` in ('outras empresas nao financeiras','setor publico') and ept01.cfamilia in ('02','03','04')
            	and concat(ct004.cproduto,ct004.csubprod) not in ('096HGP','0960H8','096065') then 'Specific Purpose'
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' and ept01.cfamilia in ('02','03','04')
            	and concat(ct004.cproduto,ct004.csubprod) not in ('096HGP','0960H8','096065') then 'Specific Purpose'              	                         			             			        			       
        
		---> JB(12/07/2024): Atualização com base no feedback de CdG (adição código de produto 000042 e remoção do 000Y45)
            when a.`33_counterparty_type` in ('particulares','outras empresas nao financeiras') 
            	and concat(ct004.cproduto,ct004.csubprod) in ('000045','000051','000053') then 'Specific Purpose'  
				
			when a.`33_counterparty_type` in ('particulares','outras empresas nao financeiras') 
            	and concat(ct004.cproduto,ct004.csubprod) ='000042'  
				and (des_detalle_lease in ('COMERCIAIS DE 2601KG A 3500KG','TT DE 2601KG A 3500KG','MOTOCICLOS CILINDRADA SUPERIOR A 50CM3','TT DE 1601KG A 2600KG','EMBARCACOES','COMERCIAIS ATE 1600KG','REBOQUE/SEMI-REBOQUE C/MATRICULA','TT ATE 1600KG','VEICULOS LIGEIROS DE PASSAGEIROS','VEICULOS PESADOS DE MERCADORIAS','COMERCIAIS DE 1601KG A 2600KG','VEICULOS PESADOS DE PASSAGEIROS','CICLOMOTOR OU MOTOCICLO AT� 50CM3'))
				then 'Specific Purpose' 
				
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras'
            	and concat(ct004.cproduto,ct004.csubprod) in ('000045','000051','000053') then 'Specific Purpose' 
				
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' 
            	and concat(ct004.cproduto,ct004.csubprod) ='000042' 
				and (des_detalle_lease in ('COMERCIAIS DE 2601KG A 3500KG','TT DE 2601KG A 3500KG','MOTOCICLOS CILINDRADA SUPERIOR A 50CM3','TT DE 1601KG A 2600KG','EMBARCACOES','COMERCIAIS ATE 1600KG','REBOQUE/SEMI-REBOQUE C/MATRICULA','TT ATE 1600KG','VEICULOS LIGEIROS DE PASSAGEIROS','VEICULOS PESADOS DE MERCADORIAS','COMERCIAIS DE 1601KG A 2600KG','VEICULOS PESADOS DE PASSAGEIROS','CICLOMOTOR OU MOTOCICLO AT� 50CM3'))
				then 'Specific Purpose'

        -- Condição geral
            when (a.idcomb_satelite like '%SC0301%' or a.idcomb_satelite like '%SC0302%' or a.idcomb_satelite like '%SC0303%')
            			and a.sfcs_green_activity_comgloval not in ('N/A', 'n/a', '','No Elegible', 'Sin información') and (a.sfcs_green_activity_comgloval is not null) then 'Specific Purpose' 
        
            when a.idcomb_satelite like '%MC08%' and  a.`33_counterparty_type` = 'outras empresas nao financeiras' 
            			and a.sfcs_green_activity_comgloval not in ('N/A', 'n/a', '','No Elegible', 'Sin información') and (a.sfcs_green_activity_comgloval is not null) then 'Specific Purpose'             			
        
        -- Specialised Lending            
            when (a.`29_flag_specialised_lending` = '1') then 'Specific Purpose'
			
		-- SPV
			when (a.flag_SPV = '1') then 'Specific Purpose'
			
		-- SFICS
		
			when sfics in ('C.SLL', 'Pure Green') then 'General Purpose'
				
			when (a.idcomb_satelite like '%SC0301%' or a.idcomb_satelite like '%SC0303%') and trim(sfics) <> '' and sfics not in ('C.SLL', 'Pure Green') then 'Specific Purpose'
           
            else 'General Purpose' 
        
        end as 67_use_of_proceeds,   
              
            -- Mapeamento da flag de European Union: Só é aplicável para os casos que são Non-Financial Corporations e Financial que não são sujeitos a flag NFRD 
         case when 
         			(FLAG_NFRD_AUX.flg_nfrd <> 1 or FLAG_NFRD_AUX.flg_nfrd IS NULL) and 
         			(a.idcomb_satelite like '%SC0302%' OR a.idcomb_satelite like '%SC0303%') and 
         			a.`93_european_union` = 'Y' 
         	   then 'EU1' 
         	   when 
         			(FLAG_NFRD_AUX.flg_nfrd <> 1 or FLAG_NFRD_AUX.flg_nfrd IS NULL) and 
         			a.idcomb_satelite like '%MC08%' and
         			a.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') and
         			a.`93_european_union` = 'Y' 
         	   then 'EU1' 
         	   when 
         			(FLAG_NFRD_AUX.flg_nfrd <> 1 or FLAG_NFRD_AUX.flg_nfrd IS NULL) and 
         			a.idcomb_satelite like '%MC41%' and
         			a.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') and
         			a.`93_european_union` = 'Y' 
         	   then 'EU1'    
         	   when 
         			(FLAG_NFRD_AUX.flg_nfrd <> 1 or FLAG_NFRD_AUX.flg_nfrd IS NULL) and 
         			a.idcomb_satelite like '%SC02%' and
         			-- a.`33_counterparty_type` in ('instituicoes de credito') and -- JUN24: comentado devido a problemas no front (idcombs com NFRD2 têm de reportar EU)
         			a.`93_european_union` = 'Y' 
         	   then 'EU1'           	         	   
               when 
               		(FLAG_NFRD_AUX.flg_nfrd <> 1 or FLAG_NFRD_AUX.flg_nfrd IS NULL) and 
               		(a.idcomb_satelite like '%SC0302%' OR a.idcomb_satelite like '%SC0303%') and 
                    a.`93_european_union` = 'N'  
               then 'EU2' 
         	   when 
         			(FLAG_NFRD_AUX.flg_nfrd <> 1 or FLAG_NFRD_AUX.flg_nfrd IS NULL) and 
         			a.idcomb_satelite like '%MC08%' and
         			a.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') and
         			a.`93_european_union` = 'N' 
         	   then 'EU2'    		
         	   when 
         			(FLAG_NFRD_AUX.flg_nfrd <> 1 or FLAG_NFRD_AUX.flg_nfrd IS NULL) and 
         			a.idcomb_satelite like '%MC41%' and
         			a.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') and
         			a.`93_european_union` = 'N' 
         	   then 'EU2'   
         	   when 
         			(FLAG_NFRD_AUX.flg_nfrd <> 1 or FLAG_NFRD_AUX.flg_nfrd IS NULL) and 
         			a.idcomb_satelite like '%SC02%' and
         			-- a.`33_counterparty_type` in ('instituicoes de credito') and -- JUN24: comentado devido a problemas no front (idcombs com NFRD2 têm de reportar EU)
         			a.`93_european_union` = 'N' 
         	   then 'EU2'            	                	               
         	   
          else '' 
          end as european_union,
          
        case
            when idcomb_satelite like '%SC0302%' and concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct) in ('31641600005800050PTNOFIIE0000000','31641600005800050PTPLG8IM0001000','31641600005800050PTPL1AIM0000000','31641600005800050PTPLGEIM0004000') then '' -- correção devido a incorreto mapeamento de Contabilidade (email Nuno Pinheiro dia 26/01)
			when trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' and nace_esg.nace_level4 is not null then nace_esg.ID
            when trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'NACE19010303' -- NOTA: nace default disponibilizado pela corporação
            when trim(a.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' and nace_esg.nace_level4 is not null then nace_esg.ID	
            when trim(a.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' then 'NACE19010303' -- NOTA: nace default disponibilizado pela corporação
			when idcomb_satelite like '%SC0303%' and a.zcliente = '0000000000' then 'NACE19010303' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
			when idcomb_satelite like '%SC0303%' and concat(a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct)='6416SUPRIMENTOSPTTAE0AN0006000' then 'NACE19010303' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb            
			else ''									
        end as nace_esg,
		case
            when idcomb_satelite like '%SC0302%' and concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct) in ('31641600005800050PTNOFIIE0000000','31641600005800050PTPLG8IM0001000','31641600005800050PTPL1AIM0000000','31641600005800050PTPLGEIM0004000') then '' -- correção devido a incorreto mapeamento de Contabilidade (email Nuno Pinheiro dia 26/01)
			when substr(a.`15_nace_esg`,1,1) = 'A' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL1'
            when substr(a.`15_nace_esg`,1,1) = 'B' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL2'
            when substr(a.`15_nace_esg`,1,1) = 'C' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL3'
            when substr(a.`15_nace_esg`,1,1) = 'D' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL4'
            when substr(a.`15_nace_esg`,1,1) = 'E' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL5'
            when substr(a.`15_nace_esg`,1,1) = 'F' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL6'
            when substr(a.`15_nace_esg`,1,1) = 'G' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL7'
            when substr(a.`15_nace_esg`,1,1) = 'H' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL8'
            when substr(a.`15_nace_esg`,1,1) = 'I' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL9'
            when substr(a.`15_nace_esg`,1,1) = 'J' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL10'
            when substr(a.`15_nace_esg`,1,1) = 'L' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL11'
            when substr(a.`15_nace_esg`,1,1) = 'M' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL12'  
            when substr(a.`15_nace_esg`,1,1) = 'N' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL13'
            when substr(a.`15_nace_esg`,1,1) = 'O' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL14'
            when substr(a.`15_nace_esg`,1,1) = 'P' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL15'
            when substr(a.`15_nace_esg`,1,1) = 'Q' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL16'
            when substr(a.`15_nace_esg`,1,1) = 'R' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL17'
            when substr(a.`15_nace_esg`,1,1) = 'S' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
            when trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
			when trim(a.`33_counterparty_type`) = '' and idcomb_satelite like '%SC0303%' then 'CNAEL18'		--Adicionada nova linha de código. Validado com Luísa
			when idcomb_satelite like '%SC0303%' and a.zcliente = '0000000000' then 'CNAEL18' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
			when idcomb_satelite like '%SC0303%' and concat(a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct)='6416SUPRIMENTOSPTTAE0AN0006000' then 'CNAEL18' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
            else ''
        end as CNAEL     
              
from (select * from bu_esg_work.pilar3_sat84_Dez24_tabaux1_SFICS_v2) a

LEFT JOIN
(
    SELECT *
    FROM cd_captools.ct003_univ_cli
    WHERE ref_date='${ref_date}'
) ct003
ON A.ZCLIENTE=ct003.ZCLIENTE

left join bu_esg_work.nace_esg_pillar3 as nace_esg	
on concat(split_part(a.`15_nace_esg`,".",1),split_part(a.`15_nace_esg`,".",2),split_part(a.`15_nace_esg`,".",3)) = trim(split_part(nace_esg.nace_level4, "-",1))

left join (select * from cd_captools.ct004_univ_cto where ref_date='${ref_date}') ct004
on concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct)=concat(ct004.cempresa,ct004.cbalcao,ct004.cnumecta,ct004.zdeposit)

left join (select * from cd_emprestimos.ept01_contas where data_date_part='${ref_date_util}' and csitcta not in ('AN', 'CA', 'LI', 'EX', 'AP', 'RE')) ept01 -- '2024-12-31'
on concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct)=concat(ept01.cempresa,ept01.ckbalcao,ept01.cknumcta)

left join (select * from bu_esg_work.modesg_out_empr_info_nfin where ref_date='${ref_date}') FLAG_NFRD_AUX
ON a.zcliente = FLAG_NFRD_AUX.zcliente

;

-- Jun24        ==>  2 782 897   registos  
--              ==>  67 021 047 311.97 (Diferença de 2.294 € face ao univero full)

-- Dez24        ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- Dez24_v3     ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- Dez24_v4     ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- drop table if exists bu_esg_work.pilar3_sat84_Dez24_tabaux3_v7;
create table bu_esg_work.pilar3_sat84_Dez24_tabaux3_v7 as
select A.*, 
 -- Specific Elegible ==> Partindo do pressuposto que é só o que está em Green 
    -- Assignação do CCM 
    -- Banca Comercial: Specific Purpose + Estar alinhado com a Taxonomia Europeia ---> VALIDAR COM A CORPORAÇÃO 
    -- CIB: Entra tudo exceto o que tem a tag_gloval = 'Sustainability Linked', tudo o resto que é CIB é alinhado com a Taxonomia Europeia ---> VALIDAR COM A CORPORAÇÃO 
  -- General Purpose
    -- Banca Comercial: Specific Purpose + Estar alinhado com a Taxonomia Europeia ---> VALIDAR COM A CORPORAÇÃO 
    -- CIB: Entra tudo exceto o que tem a tag_gloval = 'Sustainability Linked', tudo o resto que é CIB é alinhado com a Taxonomia Europeia ---> VALIDAR COM A CORPORAÇÃO 
-- Assignação do CCA: Atualmen não existem operações a contribuir para o CCA    
            -- CIB
        case
        
			when a.idcomb_satelite like '%MC42%' OR a.idcomb_satelite like '%MC43%' then '' -- Loan commitments given e Other commitments given
			
			when a.idcomb_satelite like '%MC13%' then ''
			
         -- Sovereings
        	when idcomb_satelite like '%SC0301%' and `33_counterparty_type` = 'setor publico' and 
        		 cnatureza_juri in ('121100','121210','121220','211110','211120','211130','221100','221210','121231') then 'General' --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
 
         -- Local Governments
         	when idcomb_satelite like '%SC0301%' and `33_counterparty_type` = 'setor publico' and 
         	    (sfcs_green_activity_comgloval not in ('Agriculture, forestry and livestock', 'n/a', 'N/A', '','No Elegible', 'Sin información') and (sfcs_green_activity_comgloval is not null)) then 'CCM_Banca_Comercial_Specific' 
        	
        -- CIB
        	when
                    sfcs_tag_comgloval <> 'Sustainability Linked' -- Sustainability Linked são CIB não são alinhados com a Taxonomia 
                and trim(cmetanseg) like 'EB%' 
                and (sfcs_green_activity_comgloval not in ('Agriculture, forestry and livestock', 'n/a', 'N/A', '','No Elegible', 'Sin información') and (sfcs_green_activity_comgloval is not null)) -- CIB alinhado com Taxonomia Europeia
                    then  'CCM_CIB_Specific'

		 -- Motor vehicle loans		 
           	when (idcomb_satelite like '%SC0302%' or idcomb_satelite like '%SC0303%' or idcomb_satelite like '%SC0304%') and 102_purpose_esg='Motor vehicle loans' then 'CCM_Banca_Comercial_Specific'    
           
         -- Building Renovation Loan
           	when (idcomb_satelite like '%SC0302%' or idcomb_satelite like '%SC0303%' or idcomb_satelite like '%SC0304%') and `102_purpose_esg`='Building Renovation Loans' then 'CCM_Banca_Comercial_Specific'                 	
         
         -- Building Acquisition Loan 	
          	
			when (idcomb_satelite like '%SC0302%' or idcomb_satelite like '%SC0303%' or idcomb_satelite like '%SC0304%') and `67_use_of_proceeds` = 'Specific Purpose' and 102_purpose_esg = 'Building Acquisition Loans' and clase_energetica is not null and trim(clase_energetica) <> ''
          		then 'CCM_Banca_Comercial_Specific'   
				
          	when (idcomb_satelite like '%SC0302%' or idcomb_satelite like '%SC0303%' or idcomb_satelite like '%SC0304%') and `67_use_of_proceeds` = 'Specific Purpose' and 102_purpose_esg = 'Building Acquisition Loans' and (clase_energetica is null or trim(clase_energetica) = '')
          		then 'No Mitigation_Adaptation'				
          		
          -- Other Purpose
         	when 
                    (idcomb_satelite like '%SC0302%' or idcomb_satelite like '%SC0303%')
                and sfcs_green_activity_comgloval in ('Agriculture, forestry and livestock','Biodiversity and conservation projects')
                    then  'No Mitigation_Adaptation'
					
         	when 
                    (idcomb_satelite like '%SC0302%' or idcomb_satelite like '%SC0303%')
                and sfcs_green_activity_comgloval not in ('Agriculture, forestry and livestock', 'n/a', 'N/A', '','No Elegible', 'Sin información') and (sfcs_green_activity_comgloval is not null) -- CIB alinhado com Taxonomia Europeia
                    then  'CCM_Banca_Comercial_Specific' 					

                       		            		           	 
            when (`29_flag_specialised_lending` = '1') then 'CCM_Banca_Comercial_Specific'
            
			when (flag_SPV = '1') then 'CCM_Banca_Comercial_Specific'

		-- SFICS
			when (a.idcomb_satelite like '%SC0301%' or a.idcomb_satelite like '%SC0303%')  and  
                sfics in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1')
			then 'No Mitigation_Adaptation'			

		-- SFICS
		
			when sfics in ('C.SLL', 'Pure Green') then 'General'
		
			when (a.idcomb_satelite like '%SC0301%' or a.idcomb_satelite like '%SC0303%')  and trim(sfics) <> '' and sfics not in ('C.SLL', 'Pure Green')  and 
				 sfics not in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1')
			then 'CCM_Banca_Comercial_Specific'	
			
            when 
                    `67_use_of_proceeds` = 'General Purpose'
                        then 'General'             
           
            else '' end as flag_aux_mit_adap
from bu_esg_work.pilar3_sat84_Dez24_tabaux2_v6 a;


-- Jun24        ==>  2 782 897   registos  
--              ==>  67 021 047 311.97 (Diferença de 2.294 € face ao univero full)

-- Dez24        ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- Dez24_v3     ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- Dez24_v4     ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- drop table if exists bu_esg_work.pilar3_sat84_Dez24_tabaux4_v8;
create table bu_esg_work.pilar3_sat84_Dez24_tabaux4_v8 as
select a.*, 
        case
            when a.idcomb_satelite like '%MC42%' OR a.idcomb_satelite like '%MC43%' then '' -- Loan commitments given e Other commitments given
			when a.idcomb_satelite like '%MC13%' then ''
			when a.`67_use_of_proceeds` = 'Specific Purpose' then 'GSPUR2'
            else 'GSPUR1' 
        end as general_specific_purpose,    

        case 
				when a.idcomb_satelite like '%MC42%' OR a.idcomb_satelite like '%MC43%' then '' -- Loan commitments given e Other commitments given
				when a.flag_aux_mit_adap = 'CCM_CIB_Specific' then 'SELI1'
    -- Casos CIB que levam com CCM e CCA ==> Assignar CCM (Atualmente não temos estas operações a levar com SELI2) Guidelines cap. 4.1.3.1 (vii) refere que atualmente não existe CCA e que por defeito deve ser marcado CCM
				when a.flag_aux_mit_adap = 'CCM_Banca_Comercial_Specific' then 'SELI1'
				when a.flag_aux_mit_adap = 'No Mitigation_Adaptation' then 'SELI3'
                else '' 
		end as specific_eligible,


            case 
			
				when a.idcomb_satelite like '%MC42%' OR a.idcomb_satelite like '%MC43%' then '' -- Loan commitments given e Other commitments given
			
				when a.idcomb_satelite like '%MC13%' then ''
			
	---- HOUSEHOLDS ----
            	
            	-- TRANSITIONAL	
	
				when 	trim(`102_purpose_esg`) = 'Motor vehicle loans' and 
            	 		idcomb_satelite like '%SC0304%' and -- household
						upper(des_combustivel)='ELECTRICO' and
             	 		des_detalle_lease in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG') and            	 		
            	 		dinioper >= '2022-01-01' 
            	 then 'Transitional'

				when 	trim(`102_purpose_esg`) = 'Motor vehicle loans' and 
            	 		idcomb_satelite like '%SC0304%' and -- household
						(co2 < 50 and co2 is not null) and  -- jun/24: com base no feedback de dez/23, emissões superiores a 50 devem estar no SAT83
             	 		des_detalle_lease in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG') and            	 		
            	 		dinioper >= '2022-01-01' 
            	 then 'Transitional'
		 	 		 
				-- Household (Categoria L)
            	 when 	trim(`102_purpose_esg`) = 'Motor vehicle loans' and 
            	 		idcomb_satelite like '%SC0304%' and -- household
						(co2 = 0 and co2 is not null) and
            	 		des_detalle_lease like ('%MOTOCICLO%') and
            	 		dinioper >= '2022-01-01' 
            	 then 'Transitional'					 
            	 
            	 when idcomb_satelite like '%SC0304%' and trim(`102_purpose_esg`) = 'Motor vehicle loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap not in ('General','No Mitigation_Adaptation') then 'No'


            	-- PURE 
				
                 when  
                      (
                        case
                            when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk'         
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk' -- sempre assumido em primeiro lugar a informação do colateral, seja por nuts ou país;
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'						
                            else 'Without Physical Risk'	
                        end
                      ) = 'Without Physical Risk' and
                        (anoconst is null or anoconst='9999') and 
                        a.flag_aux_mit_adap = 'CCM_Banca_Comercial_Specific' and 
                        a.fiabilidad in ('','1-REAL','SANTANDER') and 
                        (a.clase_energetica like 'A%' or trim(a.clase_energetica) = 'B') and
                        trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and
                        idcomb_satelite like '%SC0304%'
                 then 'Pure'
                 		
                 when   
                 
                      (
                        case
                            when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk'         
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk' -- sempre assumido em primeiro lugar a informação do colateral, seja por nuts ou país;
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'						
                            else 'Without Physical Risk'
                        end
                      ) = 'Without Physical Risk' and
                      
                        anoconst < '2020' and 
                        a.flag_aux_mit_adap = 'CCM_Banca_Comercial_Specific' and 
                        a.fiabilidad in ('','1-REAL','SANTANDER') and 
                        (a.clase_energetica like 'A%' or trim(a.clase_energetica) = 'B') and
                        trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and
                        idcomb_satelite like '%SC0304%'
						then 'Pure'

                 when   
                      (
                        case
                            when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk'         
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk' -- sempre assumido em primeiro lugar a informação do colateral, seja por nuts ou país;
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'						
                            else 'Without Physical Risk'
                        end
                      ) = 'Without Physical Risk' and
					  
                        anoconst >= '2020' and anoconst<>'9999' and 
                        a.flag_aux_mit_adap = 'CCM_Banca_Comercial_Specific' and 
                        a.fiabilidad in ('','1-REAL','SANTANDER') and -- a confirmar com corporação
						trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and
						idcomb_satelite like '%SC0304%' and
						idcomb_satelite like '%COLL2%' and
                        a.clase_energetica = 'A+'
						then 'Pure'		
					

                when idcomb_satelite like '%SC0304%' and idcomb_satelite like '%COLLL2%' and trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap not in ('General','No Mitigation_Adaptation') then 'No'
                
                when idcomb_satelite like '%SC0304%' and idcomb_satelite like '%COLLL2%' and trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') then ''
 
				when idcomb_satelite like '%SC0304%' and idcomb_satelite like '%COLLL2%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'General Purpose' and a.flag_aux_mit_adap ='' then ''

				when idcomb_satelite like '%SC0304%' and trim(a.`102_purpose_esg`) = 'Building Renovation Loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap not in ('General','No Mitigation_Adaptation') then 'No'


---- NON FINANCIAL CORPORATIONS ----
			
				-- ENABLING
	
				-- SFICS					
				when idcomb_satelite like '%SC0303%' and flag_nfrd = 'Not Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Building Renovation Loans' 
					 and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' and sfics in ('A.3.2','A.3.3','A.3.4','A.3.5','A.3.6') then 'Enabling'
	
				when a.flag_aux_mit_adap = 'CCM_Banca_Comercial_Specific' and trim(a.sfcs_green_activity_comgloval) = ('Real estate - Building renovation loans') and trim(nifrru)<>'' and flag_nfrd = 'Not Subject to NFRD' then 'No' 


				-- TRANSITIONAL
				--- Non-Financial Corp sem NFRD (Categoria M, N)
				
            	 when 	trim(`102_purpose_esg`) = 'Motor vehicle loans' and 
            	 		idcomb_satelite like '%SC0303%' and -- NFC
						upper(des_combustivel)='ELECTRICO' and
            	 		flag_nfrd <> 'Subject to NFRD' and
						des_detalle_lease in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG')           	 		
            	 then 'Transitional'				
				
            	 when 	trim(`102_purpose_esg`) = 'Motor vehicle loans' and 
            	 		idcomb_satelite like '%SC0303%' and -- NFC
						(co2 < 50 and co2 is not null) and
            	 		flag_nfrd <> 'Subject to NFRD' and
						des_detalle_lease in ('VEICULOS LIGEIROS DE PASSAGEIROS','COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG','TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG')           	 		
            	 then 'Transitional'
				 
				 
				--- Non-Financial Corp sem NFRD (Categoria L)
            	 when 	trim(`102_purpose_esg`) = 'Motor vehicle loans' and 
            	 		idcomb_satelite like '%SC0303%' and -- NFC
            	 		flag_nfrd <> 'Subject to NFRD' and
						(co2 =0 and co2 is not null) and
            	 		(des_detalle_lease like ('%MOTOCICLO%'))  
            	 then 'Transitional'          	 
          	
				when idcomb_satelite like '%SC0303%' and flag_nfrd <> 'Subject to NFRD' and trim(`102_purpose_esg`) = 'Motor vehicle loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap not in ('General','No Mitigation_Adaptation') then 'No'
               
            	-- PURE 
				
                 when  
                      (
                        case
                            when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk'         
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk' -- sempre assumido em primeiro lugar a informação do colateral, seja por nuts ou país;
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'						
                            else 'Without Physical Risk'	
                        end
                      ) = 'Without Physical Risk' and
                        (anoconst is null or anoconst='9999') and 
                        a.flag_aux_mit_adap = 'CCM_Banca_Comercial_Specific' and 
                        a.fiabilidad in ('','1-REAL','SANTANDER') and 
                        (a.clase_energetica like 'A%' or trim(a.clase_energetica) = 'B') and
                        trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and
                        idcomb_satelite like '%SC0303%' and
						flag_nfrd <> 'Subject to NFRD'  --- JB (26/06/2024): Adição de condição não sujeito a NFRD
                 then 'Pure'
                 		
                 when   
                 
                      (
                        case
                            when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk'         
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk' -- sempre assumido em primeiro lugar a informação do colateral, seja por nuts ou país;
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'						
                            else 'Without Physical Risk'
                        end
                      ) = 'Without Physical Risk' and
                      
                        anoconst < '2020' and 
                        a.flag_aux_mit_adap = 'CCM_Banca_Comercial_Specific' and 
                        a.fiabilidad in ('','1-REAL','SANTANDER') and 
                        (a.clase_energetica like 'A%' or trim(a.clase_energetica) = 'B') and
                        trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and
                        idcomb_satelite like '%SC0303%' and
						flag_nfrd <> 'Subject to NFRD'  --- JB (26/06/2024): Adição de condição não sujeito a NFRD
						then 'Pure'               
            
                 when   
                 
                      (
                        case
                            when a.ckbalbem IS NOT NULL and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk' 
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_acute,prhipotec2.rs_acute) = 'Yes' then 'With Physical Risk'         
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_acute,prhipotec3.rs_acute) = 'Yes' then 'With Physical Risk' -- sempre assumido em primeiro lugar a informação do colateral, seja por nuts ou país;
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_acute = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_acute,prgeral2.rs_acute) = 'Yes' then 'With Physical Risk'
							--when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'		
							when a.flag_hipotec = 1 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec1.rs_chronic,prhipotec2.rs_chronic) = 'Yes' then 'With Physical Risk'
							when a.flag_hipotec = 0 and (idcomb_satelite LIKE '%COLL2%' or idcomb_satelite LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is null and coalesce(prhipotec2.rs_chronic,prhipotec3.rs_chronic) = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is not null and PR_CP.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and PR_CP.joined_Key is null and PR_CP2.cpt_code is not null and PR_CP2.rs_chronic = 'Yes' then 'With Physical Risk'
							when (idcomb_satelite NOT LIKE '%COLL2%' and idcomb_satelite NOT LIKE '%COLL3%') and coalesce(prgeral1.rs_chronic,prgeral2.rs_chronic) = 'Yes' then 'With Physical Risk'						
                            else 'Without Physical Risk'	
                        end
                      ) = 'Without Physical Risk' and
                      
                        anoconst >= '2020' and anoconst<>'9999' and 
                        a.flag_aux_mit_adap = 'CCM_Banca_Comercial_Specific' and 
                        a.fiabilidad in ('','1-REAL','SANTANDER') and 
                        a.clase_energetica = 'A+' and
                        trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and
                        idcomb_satelite like '%SC0303%' and
						idcomb_satelite like '%COLL3%' and
						flag_nfrd <> 'Subject to NFRD'  --- JB (26/06/2024): Adição de condição não sujeito a NFRD
						then 'Pure'    			
			

               when idcomb_satelite like '%SC0303%' and flag_nfrd <> 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' and trim(a.sfcs_green_activity_comgloval) like 'Energy%' then 'Pure'				

			  
			  --- SPVs e PFs
			  
			    when flag_SPV = '1' or `29_flag_specialised_lending`='1' then 'No' -- Por indicação da Corporaçao e, dado que nao temos os indicadores DNSH e MSS para comprovar, todos estes casos são considerados como 'Não alinhados'
			   
			  	
				when sfics in ('C.SLL', 'Pure Green') then ''
			
			  
                when idcomb_satelite like '%SC0303%' and flag_nfrd <> 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' then 'No'
                
 
				-- SFICS
				-- ?????	
				
				when idcomb_satelite like '%SC0303%' and flag_nfrd <> 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' and trim(a.sfcs_green_activity_comgloval) not in ('Agriculture, forestry and livestock','Biodiversity and conservation projects') and (sfcs_green_activity_comgloval is not null) then 'No'
				
				-- SFICS
				-- ?????
				
				when idcomb_satelite like '%SC0303%' and flag_nfrd <> 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') and trim(a.sfcs_green_activity_comgloval) in ('Agriculture, forestry and livestock','Biodiversity and conservation projects') then ''
				
				-- SFICS
				when idcomb_satelite like '%SC0303%' and flag_nfrd <> 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') and 
				     sfics in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1') then ''
				
				
				when idcomb_satelite like '%SC0303%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'General Purpose' and a.flag_aux_mit_adap = '' then ''
           
                when idcomb_satelite like '%SC0303%' and flag_nfrd = 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Building Renovation Loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' then 'No'
                                
				when idcomb_satelite like '%SC0303%' and flag_nfrd = 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Motor vehicle loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' then 'No'

                when idcomb_satelite like '%SC0303%' and flag_nfrd = 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' then 'No'
                              
				when idcomb_satelite like '%SC0303%' and flag_nfrd = 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' and trim(a.sfcs_green_activity_comgloval) not in ('Agriculture, forestry and livestock','Biodiversity and conservation projects') and (sfcs_green_activity_comgloval is not null) then 'No'
                
				-- SFICS
				when idcomb_satelite like '%SC0303%' and flag_nfrd = 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') and 
				     sfics not in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1') then 'No'					

                when idcomb_satelite like '%SC0303%' and flag_nfrd = 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') and trim(a.sfcs_green_activity_comgloval) in ('Agriculture, forestry and livestock','Biodiversity and conservation projects') then ''
                
                -- SFICS
				when idcomb_satelite like '%SC0303%' and flag_nfrd = 'Subject to NFRD' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') and 
				     sfics in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1') then 'No'					
				
				when idcomb_satelite like '%SC0302%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' and trim(a.sfcs_green_activity_comgloval) not in ('Agriculture, forestry and livestock','Biodiversity and conservation projects') and (sfcs_green_activity_comgloval is not null) then 'No'
                
                -- SFICS
				when idcomb_satelite like '%SC0302%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'Specific Purpose' and 
				     sfics not in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1') then 'No'
				
				when idcomb_satelite like '%SC0302%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') and trim(a.sfcs_green_activity_comgloval) in ('Agriculture, forestry and livestock','Biodiversity and conservation projects') then 'No'
                

				-- SFICS
				when idcomb_satelite like '%SC0302%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') and 
				     sfics in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1') then 'No'
				
				
                when idcomb_satelite like '%SC0302%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'General Purpose' and a.flag_aux_mit_adap = '' then ''
                
				when idcomb_satelite like '%SC0301%' and trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' then 'No'		
				
				when idcomb_satelite like '%SC0301%' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap like 'CCM%' and trim(a.sfcs_green_activity_comgloval) not in ('Agriculture, forestry and livestock','Biodiversity and conservation projects') and (sfcs_green_activity_comgloval is not null) then 'No'

				-- SFICS
				when idcomb_satelite like '%SC0301%' and trim(a.`102_purpose_esg`) = 'Other Purpose' and a.`67_use_of_proceeds` = 'Specific Purpose' and 
				     sfics not in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1') then 'No'	
					 
				-- SFICS
				when idcomb_satelite like '%SC0301%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'Specific Purpose' and a.flag_aux_mit_adap in ('No Mitigation_Adaptation') and 
				     sfics in ('A.1.32','A.2.21','A.6.2','A.7.7','A.7.8','A.7.9','A.7.10','A.7.11','A.7.12','A.7.13','A.7.14','A.7.15','A.7.16','A.7.17','A.7.18','A.7.19','A.7.20','A.8.27','A.11.1') then 'No'	
					 
				when idcomb_satelite like '%SC0301%' and trim(a.`102_purpose_esg`) = '' and a.`67_use_of_proceeds` = 'General Purpose' and a.flag_aux_mit_adap = '' then ''
				
				            -- Geral (CIB + NCIB)
                when a.flag_aux_mit_adap in ('General','No Mitigation_Adaptation') then ''
				
                
 else 'No' end as specific_sustainable_part2
FROM 
(
	select *,
	          substring(`5_collateral_zip_code`,1,4) AS zipCode_Collateral,
              `23_counterparty_ZIPcode` AS zipCode_CounterParty,
		      CASE
				  WHEN `15_nace_esg` != ''
						AND `15_nace_esg` != 'null'
						AND nace.id != '' THEN CASE
												  WHEN (`15_nace_esg` LIKE 'A%'
														 OR `15_nace_esg` LIKE 'B%') THEN concat(substring(`15_nace_esg`,1,1),'.','0',REGEXP_EXTRACT(`15_nace_esg`,'([0-9]+)',1))
												  ELSE concat(substring(`15_nace_esg`,1,1),'.',REGEXP_EXTRACT(`15_nace_esg`,'([0-9]+)',1))
											  END
				  ELSE ''
			  END AS nace_esg_aux
	  from bu_esg_work.pilar3_sat84_Dez24_tabaux3_v7
	  LEFT JOIN bu_esg_work.nace_esg_pillar3 AS nace ON concat(split_part(`15_nace_esg`, ".", 1), split_part(`15_nace_esg`, ".", 2), split_part(`15_nace_esg`, ".", 3)) = trim(split_part(nace.nace_level4, "-", 1))
) as a 
LEFT JOIN
 (SELECT ckbalbem, ckctabem, MIN(CASE
                                     WHEN TRIM(anoconst)=''
                                          OR anoconst <'1500' or anoconst in ('0N') THEN '9999'
                                     ELSE anoconst
                                 END) AS anoconst, '000000000000000' AS ckrefbeM
  FROM cd_emprestimos.gpt18_bens
  WHERE data_date_part = '${ref_date_util}' --'2023-12-29'
  GROUP BY ckbalbem, ckctabem, '000000000000000') ano
ON CONCAT(A.ckbalbem,A.ckctabem,A.ckrefbem)=CONCAT(ano.ckbalbem,ano.ckctabem,ano.ckrefbem)

-- METODOLOGIA POR ZIP CODE

LEFT JOIN
(
    SELECT *, concat(concat(NACE),'_',substring(LOCAT,5,4)) AS joined_Key 
    FROM bu_esg_work.physical_risk_cp_dez24
) PR_CP
ON CONCAT(nace_esg_aux, '_', coalesce(a.zipCode_Collateral, a.zipCode_CounterParty)) = PR_CP.joined_Key 
   AND CPAIS_RESIDENCIA = '620' 
   
-- METODOLOGIA PROXY POR ZIP CODE

LEFT JOIN
(
    SELECT *, substring(LOCAT,5,4) as cpt_code
    FROM bu_esg_work.physical_risk_cp_dez24
	WHERE nace='Secured'
) PR_CP2
ON a.zipCode_Collateral = PR_CP2.cpt_code 
   AND CPAIS_RESIDENCIA = '620'   

-- METODOLOGIA POR NUTS

-- risco físico real para colaterais
left join (select * from bu_esg_work.physical_risk_nuts_dez24 where nace like '%Secured%') as prhipotec1 
on a.`4_collateral_nuts` = prhipotec1.locat

-- risco físico real para idcombs com colaterais imobiliarios, mas sem colaterais associados
left join (select * from bu_esg_work.physical_risk_nuts_dez24 where nace like '%Secured%') as prhipotec3 
on a.`22_counterparty_nuts` = prhipotec3.locat

-- risco físico proxy para colaterais
left join (select * from bu_esg_work.physical_risk_proxy_country_dez24 where nace like '%Secured%') as prhipotec2 
on prhipotec2.country = 'PT'

-- risco físico real para demais operações
left join 
(
	Select 	a.*, 
			b.id
    from bu_esg_work.physical_risk_nuts_dez24 a 
    left join bu_esg_work.nace_esg_pillar3 as b 
    on concat(split_part(a.nace,".",1), case when a.nace like 'A.%'or a.nace like 'B.%' then SUBSTRING(a.nace,4,1) else SUBSTRING(a.nace,3,2) end) 
        = trim(split_part(b.nace_level4, "-",1))
) as prgeral1
on a.`22_counterparty_nuts` = prgeral1.locat and left(a.nace_esg,8) = prgeral1.id

-- risco físico proxy para demais operações
left join 
( 
    select  a.*, 
	        b.tayd91c0_celemtab as iso_code, 
			c.id
	from 
	(
    	Select *, 
    	        case when country = 'UK' then 'GB' else country end as country_,
    			concat(split_part(nace,".",1), case when nace like 'A.%' or nace like 'B.%' then SUBSTRING(nace,4,1) else SUBSTRING(nace,3,2) end) as nace_level4
    	from bu_esg_work.physical_risk_proxy_country_dez24
    ) a
	left join 
	(
	    select * 
		from cd_estruturais.tat91_tabelas
		where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}") and tayd91c0_ctabela = '015'
	)b
	on a.country_ = b.tayd91c0_nelemc09			
	left join bu_esg_work.nace_esg_pillar3 as c
	on a.nace_level4 = trim(split_part(c.nace_level4, "-",1))
) as prgeral2
on cast(coalesce(a.cpais_residencia,'620') as string) = prgeral2.iso_code -- os nulls 
and left(a.nace_esg,8) = prgeral2.id

;
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
------------------Criação de tabela auxiliar para ter os rácios por zcliente ----------
---------------------------------------------------------------------------------------

-- 19 639  registos Jun24
-- 20 581 registos Dez24

DROP TABLE bu_esg_work.Eligibity_racios_Dez24;
CREATE TABLE bu_esg_work.Eligibity_racios_Dez24 AS
SELECT *
FROM

	(
	SELECT  CASE
           WHEN LEI_AUX.ZCLIENTE IS NOT NULL THEN LEI_AUX.ZCLIENTE
           WHEN LEI_AUX.ZCLIENTE IS NULL THEN KGL_AUX.ZCLIENTE
           ELSE ''
       END AS ZCLIENTE,
       CASE
           WHEN LEI_AUX.ZCLIENTE IS NOT NULL THEN LEI_AUX.NFRD
           WHEN LEI_AUX.ZCLIENTE IS NULL THEN KGL_AUX.NFRD
           ELSE ''
       END AS NFRD,
       CASE
           WHEN LEI_AUX.ADAPT_TURNOVER_T_ELIG IS NOT NULL THEN LEI_AUX.ADAPT_TURNOVER_T_ELIG
           WHEN LEI_AUX.ADAPT_TURNOVER_T_ELIG IS NULL THEN KGL_AUX.ADAPT_TURNOVER_T_ELIG
           ELSE NULL
       END AS ADAPT_TURNOVER_T_ELIG,
       CASE
           WHEN LEI_AUX.ADAPT_TURNOVER_ENAB_ALIG IS NOT NULL THEN LEI_AUX.ADAPT_TURNOVER_ENAB_ALIG
           WHEN LEI_AUX.ADAPT_TURNOVER_ENAB_ALIG IS NULL THEN KGL_AUX.ADAPT_TURNOVER_ENAB_ALIG
           ELSE NULL
       END AS ADAPT_TURNOVER_ENAB_ALIG,
       CASE
           WHEN LEI_AUX.ADAPT_TURNOVER_OWN_PERF_ALIG IS NOT NULL THEN LEI_AUX.ADAPT_TURNOVER_OWN_PERF_ALIG
           WHEN LEI_AUX.ADAPT_TURNOVER_OWN_PERF_ALIG IS NULL THEN KGL_AUX.ADAPT_TURNOVER_OWN_PERF_ALIG
           ELSE NULL
       END AS ADAPT_TURNOVER_OWN_PERF_ALIG,
       CASE
           WHEN LEI_AUX.ADAPT_CAPEX_T_ELIG IS NOT NULL THEN LEI_AUX.ADAPT_CAPEX_T_ELIG
           WHEN LEI_AUX.ADAPT_CAPEX_T_ELIG IS NULL THEN KGL_AUX.ADAPT_CAPEX_T_ELIG
           ELSE NULL
       END AS ADAPT_CAPEX_T_ELIG,
       CASE
           WHEN LEI_AUX.ADAPT_CAPEX_ENAB_ALIG IS NOT NULL THEN LEI_AUX.ADAPT_CAPEX_ENAB_ALIG
           WHEN LEI_AUX.ADAPT_CAPEX_ENAB_ALIG IS NULL THEN KGL_AUX.ADAPT_CAPEX_ENAB_ALIG
           ELSE NULL
       END AS ADAPT_CAPEX_ENAB_ALIG,
       CASE
           WHEN LEI_AUX.ADAPT_CAPEX_OWN_PERF_ALIG IS NOT NULL THEN LEI_AUX.ADAPT_CAPEX_OWN_PERF_ALIG
           WHEN LEI_AUX.ADAPT_CAPEX_OWN_PERF_ALIG IS NULL THEN KGL_AUX.ADAPT_CAPEX_OWN_PERF_ALIG
           ELSE NULL
       END AS ADAPT_CAPEX_OWN_PERF_ALIG,
       CASE
           WHEN LEI_AUX.MITIG_TURNOVER_T_ELIG IS NOT NULL THEN LEI_AUX.MITIG_TURNOVER_T_ELIG
           WHEN LEI_AUX.MITIG_TURNOVER_T_ELIG IS NULL THEN KGL_AUX.MITIG_TURNOVER_T_ELIG
           ELSE NULL
       END AS MITIG_TURNOVER_T_ELIG,
       CASE
           WHEN LEI_AUX.MITIG_TURNOVER_ENAB_ALIG IS NOT NULL THEN LEI_AUX.MITIG_TURNOVER_ENAB_ALIG
           WHEN LEI_AUX.MITIG_TURNOVER_ENAB_ALIG IS NULL THEN KGL_AUX.MITIG_TURNOVER_ENAB_ALIG
           ELSE NULL
       END AS MITIG_TURNOVER_ENAB_ALIG,
       CASE
           WHEN LEI_AUX.MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG IS NOT NULL THEN LEI_AUX.MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG
           WHEN LEI_AUX.MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG IS NULL THEN KGL_AUX.MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG
           ELSE NULL
       END AS MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG,
       CASE
           WHEN LEI_AUX.MITIG_TURNOVER_OWN_PERF_ALIG IS NOT NULL THEN LEI_AUX.MITIG_TURNOVER_OWN_PERF_ALIG
           WHEN LEI_AUX.MITIG_TURNOVER_OWN_PERF_ALIG IS NULL THEN KGL_AUX.MITIG_TURNOVER_OWN_PERF_ALIG
           ELSE NULL
       END AS MITIG_TURNOVER_OWN_PERF_ALIG,
       CASE
           WHEN LEI_AUX.MITIG_CAPEX_T_ELIG IS NOT NULL THEN LEI_AUX.MITIG_CAPEX_T_ELIG
           WHEN LEI_AUX.MITIG_CAPEX_T_ELIG IS NULL THEN KGL_AUX.MITIG_CAPEX_T_ELIG
           ELSE NULL
       END AS MITIG_CAPEX_T_ELIG,
       CASE
           WHEN LEI_AUX.MITIG_CAPEX_ENAB_ALIG IS NOT NULL THEN LEI_AUX.MITIG_CAPEX_ENAB_ALIG
           WHEN LEI_AUX.MITIG_CAPEX_ENAB_ALIG IS NULL THEN KGL_AUX.MITIG_CAPEX_ENAB_ALIG
           ELSE NULL
       END AS MITIG_CAPEX_ENAB_ALIG,
       CASE
           WHEN LEI_AUX.MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG IS NOT NULL THEN LEI_AUX.MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG
           WHEN LEI_AUX.MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG IS NULL THEN KGL_AUX.MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG
           ELSE NULL
       END AS MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG,
       CASE
           WHEN LEI_AUX.MITIG_CAPEX_OWN_PERF_ALIG IS NOT NULL THEN LEI_AUX.MITIG_CAPEX_OWN_PERF_ALIG
           WHEN LEI_AUX.MITIG_CAPEX_OWN_PERF_ALIG IS NULL THEN KGL_AUX.MITIG_CAPEX_OWN_PERF_ALIG
           ELSE NULL
       END AS MITIG_CAPEX_OWN_PERF_ALIG,
       CASE
           WHEN LEI_AUX.POLLU_TURNOVER_TOTAL_ELIG IS NOT NULL THEN LEI_AUX.POLLU_TURNOVER_TOTAL_ELIG
           WHEN LEI_AUX.POLLU_TURNOVER_TOTAL_ELIG IS NULL THEN KGL_AUX.POLLU_TURNOVER_TOTAL_ELIG
           ELSE NULL
       END AS POLLU_TURNOVER_TOTAL_ELIG,
       CASE
           WHEN LEI_AUX.POLLU_TURNOVER_OWN_PER_ALIG IS NOT NULL THEN LEI_AUX.POLLU_TURNOVER_OWN_PER_ALIG
           WHEN LEI_AUX.POLLU_TURNOVER_OWN_PER_ALIG IS NOT NULL THEN KGL_AUX.POLLU_TURNOVER_OWN_PER_ALIG
           ELSE NULL
       END AS POLLU_TURNOVER_OWN_PER_ALIG,
       CASE
           WHEN LEI_AUX.POLLU_CAPEX_TOTAL_ELIG IS NOT NULL THEN LEI_AUX.POLLU_CAPEX_TOTAL_ELIG
           WHEN LEI_AUX.POLLU_CAPEX_TOTAL_ELIG IS NOT NULL THEN KGL_AUX.POLLU_CAPEX_TOTAL_ELIG
           ELSE NULL
       END AS POLLU_CAPEX_TOTAL_ELIG,
       CASE
           WHEN LEI_AUX.POLLU_CAPEX_OWN_PERFORMANCE_ALIG IS NOT NULL THEN LEI_AUX.POLLU_CAPEX_OWN_PERFORMANCE_ALIG
           WHEN LEI_AUX.POLLU_CAPEX_OWN_PERFORMANCE_ALIG IS NOT NULL THEN KGL_AUX.POLLU_CAPEX_OWN_PERFORMANCE_ALIG
           ELSE NULL
       END AS POLLU_CAPEX_OWN_PERFORMANCE_ALIG,
       CASE
           WHEN LEI_AUX.BIO_TURNOVER_TOTAL_ELIG IS NOT NULL THEN LEI_AUX.BIO_TURNOVER_TOTAL_ELIG
           WHEN LEI_AUX.BIO_TURNOVER_TOTAL_ELIG IS NOT NULL THEN KGL_AUX.BIO_TURNOVER_TOTAL_ELIG
           ELSE NULL
       END AS BIO_TURNOVER_TOTAL_ELIG,
       CASE
           WHEN LEI_AUX.BIO_TURNOVER_OWN_PERFORMANCE_ALIG IS NOT NULL THEN LEI_AUX.BIO_TURNOVER_OWN_PERFORMANCE_ALIG
           WHEN LEI_AUX.BIO_TURNOVER_OWN_PERFORMANCE_ALIG IS NOT NULL THEN KGL_AUX.BIO_TURNOVER_OWN_PERFORMANCE_ALIG
           ELSE NULL
       END AS BIO_TURNOVER_OWN_PERFORMANCE_ALIG,
       CASE
           WHEN LEI_AUX.BIO_CAPEX_TOTAL_ELIG IS NOT NULL THEN LEI_AUX.BIO_CAPEX_TOTAL_ELIG
           WHEN LEI_AUX.BIO_CAPEX_TOTAL_ELIG IS NOT NULL THEN KGL_AUX.BIO_CAPEX_TOTAL_ELIG
           ELSE NULL
       END AS BIO_CAPEX_TOTAL_ELIG,
       CASE
           WHEN LEI_AUX.BIO_CAPEX_OWN_PERFORMANCE_ALIG IS NOT NULL THEN LEI_AUX.BIO_CAPEX_OWN_PERFORMANCE_ALIG
           WHEN LEI_AUX.BIO_CAPEX_OWN_PERFORMANCE_ALIG IS NOT NULL THEN KGL_AUX.BIO_CAPEX_OWN_PERFORMANCE_ALIG
           ELSE NULL
       END AS BIO_CAPEX_OWN_PERFORMANCE_ALIG,
       CASE
           WHEN LEI_AUX.WATER_TURNOVER_TOTAL_ELIG IS NOT NULL THEN LEI_AUX.WATER_TURNOVER_TOTAL_ELIG
           WHEN LEI_AUX.WATER_TURNOVER_TOTAL_ELIG IS NOT NULL THEN KGL_AUX.WATER_TURNOVER_TOTAL_ELIG
           ELSE NULL
       END AS WATER_TURNOVER_TOTAL_ELIG,
       CASE
           WHEN LEI_AUX.WATER_TURNOVER_ENABLING_ALIG IS NOT NULL THEN LEI_AUX.WATER_TURNOVER_ENABLING_ALIG
           WHEN LEI_AUX.WATER_TURNOVER_ENABLING_ALIG IS NOT NULL THEN KGL_AUX.WATER_TURNOVER_ENABLING_ALIG
           ELSE NULL
       END AS WATER_TURNOVER_ENABLING_ALIG,
       CASE
           WHEN LEI_AUX.WATER_TURNOVER_OWN_PERFORMANCE_ALIG IS NOT NULL THEN LEI_AUX.WATER_TURNOVER_OWN_PERFORMANCE_ALIG
           WHEN LEI_AUX.WATER_TURNOVER_OWN_PERFORMANCE_ALIG IS NOT NULL THEN KGL_AUX.WATER_TURNOVER_OWN_PERFORMANCE_ALIG
           ELSE NULL
       END AS WATER_TURNOVER_OWN_PERFORMANCE_ALIG,
       CASE
           WHEN LEI_AUX.WATER_CAPEX_TOTAL_ELIG IS NOT NULL THEN LEI_AUX.WATER_CAPEX_TOTAL_ELIG
           WHEN LEI_AUX.WATER_CAPEX_TOTAL_ELIG IS NOT NULL THEN KGL_AUX.WATER_CAPEX_TOTAL_ELIG
           ELSE NULL
       END AS WATER_CAPEX_TOTAL_ELIG,
       CASE
           WHEN LEI_AUX.WATER_CAPEX_ENABLING_ALIG IS NOT NULL THEN LEI_AUX.WATER_CAPEX_ENABLING_ALIG
           WHEN LEI_AUX.WATER_CAPEX_ENABLING_ALIG IS NOT NULL THEN KGL_AUX.WATER_CAPEX_ENABLING_ALIG
           ELSE NULL
       END AS WATER_CAPEX_ENABLING_ALIG,
       CASE
           WHEN LEI_AUX.WATER_CAPEX_OWN_PERFORMANCE_ALIG IS NOT NULL THEN LEI_AUX.WATER_CAPEX_OWN_PERFORMANCE_ALIG
           WHEN LEI_AUX.WATER_CAPEX_OWN_PERFORMANCE_ALIG IS NOT NULL THEN KGL_AUX.WATER_CAPEX_OWN_PERFORMANCE_ALIG
           ELSE NULL
       END AS WATER_CAPEX_OWN_PERFORMANCE_ALIG,
       CASE
           WHEN LEI_AUX.CIRC_TURNOVER_TOTAL_ELIG IS NOT NULL THEN LEI_AUX.CIRC_TURNOVER_TOTAL_ELIG
           WHEN LEI_AUX.CIRC_TURNOVER_TOTAL_ELIG IS NOT NULL THEN KGL_AUX.CIRC_TURNOVER_TOTAL_ELIG
           ELSE NULL
       END AS CIRC_TURNOVER_TOTAL_ELIG,
       CASE
           WHEN LEI_AUX.CIRC_TURNOVER_ENABLING_ALIG IS NOT NULL THEN LEI_AUX.CIRC_TURNOVER_ENABLING_ALIG
           WHEN LEI_AUX.CIRC_TURNOVER_ENABLING_ALIG IS NOT NULL THEN KGL_AUX.CIRC_TURNOVER_ENABLING_ALIG
           ELSE NULL
       END AS CIRC_TURNOVER_ENABLING_ALIG,
       CASE
           WHEN LEI_AUX.CIRC_TURNOVER_OWN_PERFORMANCE_ALIG IS NOT NULL THEN LEI_AUX.CIRC_TURNOVER_OWN_PERFORMANCE_ALIG
           WHEN LEI_AUX.CIRC_TURNOVER_OWN_PERFORMANCE_ALIG IS NOT NULL THEN KGL_AUX.CIRC_TURNOVER_OWN_PERFORMANCE_ALIG
           ELSE NULL
       END AS CIRC_TURNOVER_OWN_PERFORMANCE_ALIG,
       CASE
           WHEN LEI_AUX.CIRC_CAPEX_TOTAL_ELIG IS NOT NULL THEN LEI_AUX.CIRC_CAPEX_TOTAL_ELIG
           WHEN LEI_AUX.CIRC_CAPEX_TOTAL_ELIG IS NOT NULL THEN KGL_AUX.CIRC_CAPEX_TOTAL_ELIG
           ELSE NULL
       END AS CIRC_CAPEX_TOTAL_ELIG,
       CASE
           WHEN LEI_AUX.CIRC_CAPEX_ENABLING_ALIG IS NOT NULL THEN LEI_AUX.CIRC_CAPEX_ENABLING_ALIG
           WHEN LEI_AUX.CIRC_CAPEX_ENABLING_ALIG IS NOT NULL THEN KGL_AUX.CIRC_CAPEX_ENABLING_ALIG
           ELSE NULL
       END AS CIRC_CAPEX_ENABLING_ALIG,
       CASE 
           WHEN LEI_AUX.CIRC_CAPEX_OWN_PERFORMANCE_ALIG IS NOT NULL THEN LEI_AUX.CIRC_CAPEX_OWN_PERFORMANCE_ALIG 
           WHEN LEI_AUX.CIRC_CAPEX_OWN_PERFORMANCE_ALIG IS NOT NULL THEN KGL_AUX.CIRC_CAPEX_OWN_PERFORMANCE_ALIG 
           ELSE NULL
        END AS CIRC_CAPEX_OWN_PERFORMANCE_ALIG
	FROM
	(
	    SELECT DISTINCT CT003.zcliente, 
	                    RACIOS_AUX.NFRD,
                        ADAPT_TURNOVER_T_ELIG,
                        ADAPT_TURNOVER_ENAB_ALIG,
                        ADAPT_TURNOVER_OWN_PERF_ALIG,
                        ADAPT_CAPEX_T_ELIG,
                        ADAPT_CAPEX_ENAB_ALIG,
                        ADAPT_CAPEX_OWN_PERF_ALIG,
                        MITIG_TURNOVER_T_ELIG,
                        MITIG_TURNOVER_ENAB_ALIG,
                        MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG,
                        MITIG_TURNOVER_OWN_PERF_ALIG,
                        MITIG_CAPEX_T_ELIG,
                        MITIG_CAPEX_ENAB_ALIG,
                        MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG,
                        MITIG_CAPEX_OWN_PERF_ALIG,
                        
--> JB(02/07/24): NOVOS CAMPOS
                        POLLU_TURNOVER_TOTAL_ELIG,
                        POLLU_TURNOVER_OWN_PER_ALIG,
                        POLLU_CAPEX_TOTAL_ELIG,
                        POLLU_CAPEX_OWN_PERFORMANCE_ALIG,
                        BIO_TURNOVER_TOTAL_ELIG,
                        BIO_TURNOVER_OWN_PERFORMANCE_ALIG,
                        BIO_CAPEX_TOTAL_ELIG,
                        BIO_CAPEX_OWN_PERFORMANCE_ALIG,
                        WATER_TURNOVER_TOTAL_ELIG,
                        WATER_TURNOVER_ENABLING_ALIG,
                        WATER_TURNOVER_OWN_PERFORMANCE_ALIG,
                        WATER_CAPEX_TOTAL_ELIG,
                        WATER_CAPEX_ENABLING_ALIG,
                        WATER_CAPEX_OWN_PERFORMANCE_ALIG,
                        CIRC_TURNOVER_TOTAL_ELIG,
                        CIRC_TURNOVER_ENABLING_ALIG,
                        CIRC_TURNOVER_OWN_PERFORMANCE_ALIG,
                        CIRC_CAPEX_TOTAL_ELIG,
                        CIRC_CAPEX_ENABLING_ALIG,
                        CIRC_CAPEX_OWN_PERFORMANCE_ALIG


	    FROM
	     ( 
	        SELECT *
	        FROM bu_esg_work.GAR_External_Data_Dez24   ---- ALTERAR APÓS TER TABELA DE RÁCIOS DE ELEGIBILIDADE
	      ) AS RACIOS_AUX   
	      
	    -- Ligação rácio elegibilidade
	    
	    -- Por lei  
	    
	    LEFT JOIN 
	     (  
	        SELECT clei,
	               zcliente
	        FROM cd_captools.ct003_univ_cli
	        WHERE ref_date = '${ref_date}' AND TRIM(CLEI) <> '' 
	      ) AS CT003
	    ON RACIOS_AUX.lei = CT003.clei
	    
	) LEI_AUX
	FULL JOIN
	-- Por KGL
	(
    	SELECT *
    	   FROM
    	     (SELECT ROW_NUMBER () OVER (PARTITION BY XX.ZCLIENTE
    	                                 ORDER BY FLG ASC) AS ORDEM,
    	             XX.*
    	      FROM
    	        (
    	        select 
    			    ZCLIENTE,
    			    NFRD,
    			    GLCS,
    			    ADAPT_TURNOVER_T_ELIG,
    			    ADAPT_TURNOVER_ENAB_ALIG,
    			    ADAPT_TURNOVER_OWN_PERF_ALIG,
    			    ADAPT_CAPEX_T_ELIG,
    			    ADAPT_CAPEX_ENAB_ALIG,
    			    ADAPT_CAPEX_OWN_PERF_ALIG,
    			    MITIG_TURNOVER_T_ELIG,
    			    MITIG_TURNOVER_ENAB_ALIG,
    			    MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG,
    			    MITIG_TURNOVER_OWN_PERF_ALIG,
    			    MITIG_CAPEX_T_ELIG,
    			    MITIG_CAPEX_ENAB_ALIG,
    			    MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG,
    			    MITIG_CAPEX_OWN_PERF_ALIG,
                    POLLU_TURNOVER_TOTAL_ELIG,
                    POLLU_TURNOVER_OWN_PER_ALIG,
                    POLLU_CAPEX_TOTAL_ELIG,
                    POLLU_CAPEX_OWN_PERFORMANCE_ALIG,
                    BIO_TURNOVER_TOTAL_ELIG,
                    BIO_TURNOVER_OWN_PERFORMANCE_ALIG,
                    BIO_CAPEX_TOTAL_ELIG,
                    BIO_CAPEX_OWN_PERFORMANCE_ALIG,
                    WATER_TURNOVER_TOTAL_ELIG,
                    WATER_TURNOVER_ENABLING_ALIG,
                    WATER_TURNOVER_OWN_PERFORMANCE_ALIG,
                    WATER_CAPEX_TOTAL_ELIG,
                    WATER_CAPEX_ENABLING_ALIG,
                    WATER_CAPEX_OWN_PERFORMANCE_ALIG,
                    CIRC_TURNOVER_TOTAL_ELIG,
                    CIRC_TURNOVER_ENABLING_ALIG,
                    CIRC_TURNOVER_OWN_PERFORMANCE_ALIG,
                    CIRC_CAPEX_TOTAL_ELIG,
                    CIRC_CAPEX_ENABLING_ALIG,
                    CIRC_CAPEX_OWN_PERFORMANCE_ALIG,
    			    FLG
    			from
    			(
                    select corp.*, ct003.zcliente
                    from
                        (Select * from cd_captools.ct003_univ_cli where ref_date='${ref_date}') ct003
                    inner join
                        (Select * from cd_captools.ct070_univ_gr_cli where ref_date='${ref_date}' and tipo_relacao = 'CONTROLO') ct70
                    on ct003.zcliente = ct70.zcliente
                    inner join
                        (Select * from cd_captools.ct069_univ_gr_ec where ref_date='${ref_date}') ct069
                    on ct069.zgrupo = ct70.zgrupo
                    inner join 
                    	(
                    	    select ccliente,gcli_kgl,centlegal,gnomelegal,cgrupo 
                    	    from cd_riscos.rstf159_rating_interno
                    	    where data_date_part = '${ref_date_util}' and trim(ccliente) not in ('','#')
                    	 ) rstf
                    on ct069.zcliente_princ = rstf.ccliente
                    inner join
                        (select 'Y' as CIB, '1' as flg, * from bu_esg_work.GAR_External_Data_Dez24) corp
                    on corp.glcs = rstf.centlegal or corp.glcs = rstf.cgrupo
                    union all
                    (
                    select corp.*, ccliente  as zcliente
                    from
                    	(select 'Y' as CIB, '1' as flg, * from bu_esg_work.GAR_External_Data_Dez24) corp
                    inner join 
                    	(
                    	    select ccliente,gcli_kgl,centlegal,gnomelegal,cgrupo 
                    	    from cd_riscos.rstf159_rating_interno 
                    	    where data_date_part = '${ref_date_util}' and trim(ccliente) not in ('','#')) cib
                    on corp.glcs = cib.centlegal or corp.glcs = cib.cgrupo
                    )
                    union all 
                    
                    (
                    select distinct corp.*, zcliente  as zcliente
                    from
                    	(select 'Y' as CIB, '2' as flg, * from bu_esg_work.GAR_External_Data_Dez24) corp
                        inner join 
                    	(Select distinct ct70.zcliente, ct70.zgrupo, ct71.kgl5 from 
                    		(Select * from cd_captools.ct070_univ_gr_cli where ref_date='${ref_date}' and tipo_relacao = 'CONTROLO') ct70
                    	inner join 
                    		(Select * from cd_captools.ct071_rwa_gr_ec where ref_date='${ref_date}' and trim(kgl5)<>'') ct71
                    		on ct70.zgrupo=ct71.zgrupo
                    	) ct71 
                    on corp.glcs =  ct71.kgl5 
                    )
                    union all
                    
                    (
                    select corp.*, ct003.zcliente
                    from
                        (Select * from cd_captools.ct003_univ_cli where ref_date='${ref_date}') ct003
                    inner join
                        (Select * from cd_captools.ct070_univ_gr_cli where ref_date='${ref_date}' and tipo_relacao = 'CONTROLO') ct70
                    on ct003.zcliente = ct70.zcliente
                    left join
                        (Select * from cd_captools.ct069_univ_gr_ec where ref_date='${ref_date}') ct069
                    on ct069.zgrupo = ct70.zgrupo
                    inner join
                    	(Select * from cd_captools.ct003_univ_cli where ref_date='${ref_date}') ct3
                    on ct069.zcliente_princ = ct3.zcliente    
                    inner join 
                    	(Select * from bu_esg_work.p3_Client_Data_JQUEST) JQUEST
                    on trim(JQUEST.cpty_code) = trim(ct3.ccli_kgl) 
                    inner join
                        (select 'Y' as CIB, '3' as flg, * from bu_esg_work.GAR_External_Data_Dez24) corp
                    on corp.glcs =  JQUEST.cptyparent_code or  corp.glcs =  JQUEST.cptylastparent_code
                    
                    union all
                    select distinct corp.*, zcliente  as zcliente
                    from
                    	(select 'Y' as CIB, '3' as flg, * from bu_esg_work.GAR_External_Data_Dez24) corp
                    inner join
                    	(select zcliente,cptyparent_code, cptylastparent_code from 
                    		(Select distinct zcliente, trim(ccli_kgl) as ccli_kgl from cd_captools.ct003_univ_cli where ref_date='${ref_date}' 
                    		and trim(ccli_kgl) <> '')ct03
                    	inner join 
                    		(Select * from bu_esg_work.p3_Client_Data_JQUEST) input
                    		on trim(input.cpty_code) = trim(ct03.ccli_kgl)
                    	) kgl_ct03 
                    on corp.glcs =  kgl_ct03.cptyparent_code or  corp.glcs =  kgl_ct03.cptylastparent_code
                    )
    			)x
    			)xx
    	 )XXX
    	WHERE ORDEM = 1 	
	) KGL_AUX
	ON LEI_AUX.ZCLIENTE = KGL_AUX.ZCLIENTE
) RACIOS_ELEG
;


-- Jun24        ==>  2 782 897   registos  
--              ==>  67 021 047 311.97 (Diferença de 2.294 € face ao univero full)

-- Dez24        ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- Dez24_v3     ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- drop table if exists bu_esg_work.pilar3_sat84_Dez24_tabaux5_v7;
create table bu_esg_work.pilar3_sat84_Dez24_tabaux5_v7 as 
SELECT   
        a.csatelite,
		a.sociedade_contraparte,
        a.idcomb_satelite,
        a.cempresa_ct,
        a.cbalcao_ct,
        a.cnumecta_ct,
        a.zdeposit_ct,
        a.cod_ajust,
        a.saldo_ct,
        a.setor,
        a.`33_counterparty_type`,
        a.`29_flag_specialised_lending`,
		a.flag_SPV,
        a.amount,
        a.zcliente,
        a.ckbalbem,
        a.ckctabem,
        a.ckrefbem,
        a.clase_energetica,
        a.fiabilidad,
        a.sfcs_green_activity_comgloval,
        a.sfcs_tag_comgloval,
        a.tipo_produto,
        a.cmetanseg,
        a.esg_subsector_name,
        a.`102_purpose_esg`,
        a.flag_nfrd,
        a.originated_during_period,
        a.`67_use_of_proceeds`,
        a.european_union,
        a.flag_aux_mit_adap,
        a.general_specific_purpose,
        a.specific_eligible,
        a.specific_sustainable_part2,
        a.investment_sector,
        a.nace_esg,
        a.CNAEL,
		
		--Turnover
		---Mitigation
        case when general_specific_purpose = 'GSPUR1' then amount * CAST(MITIG_TURNOVER_T_ELIG AS DECIMAL (38,12))/100 end as TUCCM,
        case when general_specific_purpose = 'GSPUR1' then amount * CAST(MITIG_TURNOVER_OWN_PERF_ALIG AS DECIMAL (38,12))/100 end as ETCCM,
        case when general_specific_purpose = 'GSPUR1' then amount * CAST(MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG AS DECIMAL (38,12))/100 end as TRANT,
        case when general_specific_purpose = 'GSPUR1' then amount * CAST(MITIG_TURNOVER_ENAB_ALIG AS DECIMAL (38,12))/100 end as ENTCCM,
		---Adaptation
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(ADAPT_TURNOVER_T_ELIG AS DECIMAL (38,12))/100 end as TUCCA,
        case when general_specific_purpose = 'GSPUR1' then amount * CAST(ADAPT_TURNOVER_OWN_PERF_ALIG AS DECIMAL (38,12))/100 end as ETCCA,
        case when general_specific_purpose = 'GSPUR1' then amount * CAST(ADAPT_TURNOVER_ENAB_ALIG AS DECIMAL (38,12))/100 end as ENTCCA,
		--Water & Waste management
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(WATER_TURNOVER_TOTAL_ELIG AS DECIMAL (38,12))/100 end as TUWTR,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(WATER_TURNOVER_OWN_PERFORMANCE_ALIG AS DECIMAL (38,12))/100 end as ETWTR,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(WATER_TURNOVER_ENABLING_ALIG AS DECIMAL (38,12))/100 end as ENTWTR,
		---Circular Economy
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(CIRC_TURNOVER_TOTAL_ELIG AS DECIMAL (38,12))/100 end as TUCE,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(CIRC_TURNOVER_OWN_PERFORMANCE_ALIG AS DECIMAL (38,12))/100 end as ETCE,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(CIRC_TURNOVER_ENABLING_ALIG AS DECIMAL (38,12))/100 end as ENTCE,
		---Pollution
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(POLLU_TURNOVER_TOTAL_ELIG AS DECIMAL (38,12))/100 end as TUPPC,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(POLLU_TURNOVER_OWN_PER_ALIG AS DECIMAL (38,12))/100 end as ETPPC,
		--Biodiversity
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(BIO_TURNOVER_TOTAL_ELIG AS DECIMAL (38,12))/100 end as TUBIO,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(BIO_TURNOVER_OWN_PERFORMANCE_ALIG AS DECIMAL (38,12))/100 end as ETBIO,
		
		--Capex
		---Mitigation
	    case when general_specific_purpose = 'GSPUR1' then amount * CAST(MITIG_CAPEX_T_ELIG AS DECIMAL (38,12))/100 end as CACCM,
	    case when general_specific_purpose = 'GSPUR1' then amount * CAST(MITIG_CAPEX_OWN_PERF_ALIG AS DECIMAL (38,12))/100 end as ECCCM,
	    case when general_specific_purpose = 'GSPUR1' then amount * CAST(MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG AS DECIMAL (38,12))/100 end as TRANC,
	    case when general_specific_purpose = 'GSPUR1' then amount * CAST(MITIG_CAPEX_ENAB_ALIG AS DECIMAL (38,12))/100 end as ENCCCM,
		---Adaptation 
	    case when general_specific_purpose = 'GSPUR1' then amount * CAST(ADAPT_CAPEX_T_ELIG AS DECIMAL (38,12))/100 end as CACCA,
	    case when general_specific_purpose = 'GSPUR1' then amount * CAST(ADAPT_CAPEX_OWN_PERF_ALIG AS DECIMAL (38,12))/100 end as ECCCA,
	    case when general_specific_purpose = 'GSPUR1' then amount * CAST(ADAPT_CAPEX_ENAB_ALIG AS DECIMAL (38,12))/100 end as ENCCCA,		
		---Water & Waste Management
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(WATER_CAPEX_TOTAL_ELIG AS DECIMAL (38,12))/100 end as CAWTR,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(WATER_CAPEX_OWN_PERFORMANCE_ALIG AS DECIMAL (38,12))/100 end as ECWTR,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(WATER_CAPEX_ENABLING_ALIG AS DECIMAL (38,12))/100 end as ENCWTR,
		---Circular Economy
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(CIRC_CAPEX_TOTAL_ELIG AS DECIMAL (38,12))/100 end as CACE,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(CIRC_CAPEX_OWN_PERFORMANCE_ALIG AS DECIMAL (38,12))/100 end as ECCE,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(CIRC_CAPEX_ENABLING_ALIG AS DECIMAL (38,12))/100 end as ENCCE,
		--Pollution
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(POLLU_CAPEX_TOTAL_ELIG AS DECIMAL (38,12))/100 end as CAPPC,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(POLLU_CAPEX_OWN_PERFORMANCE_ALIG AS DECIMAL (38,12))/100 end as ECPPC,
		--Biodiversity
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(BIO_CAPEX_TOTAL_ELIG AS DECIMAL (38,12))/100 end as CABIO,
		case when general_specific_purpose = 'GSPUR1' then amount * CAST(BIO_CAPEX_OWN_PERFORMANCE_ALIG AS DECIMAL (38,12))/100 end as ECBIO
				
  		  
    
FROM bu_esg_work.pilar3_sat84_Dez24_tabaux4_v8 a
LEFT JOIN bu_esg_work.Eligibity_racios_Dez24 B
ON A.ZCLIENTE=B.ZCLIENTE

;

-- Jun24        ==>  2 782 897   registos  
--              ==>  67 021 047 311.97 (Diferença de 2.294 € face ao univero full)

-- Dez24        ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- Dez24_v3     ==> 2 845 751 registos  
--              ==> 67 708 032 144.48

-- drop table if exists bu_esg_work.pilar3_sat84_Dez24_tabaux6_v7;
create table bu_esg_work.pilar3_sat84_Dez24_tabaux6_v7 as     
select a.*,
	   CASE when idcomb_satelite like '%MC04%COLL4%' then replace(idcomb_satelite,'COLL4','COLL1')
			when idcomb_satelite like '%MC04%COLL3%' then replace(idcomb_satelite,'COLL3','COLL1')
			when idcomb_satelite like '%MC02%SC02%COLL3%' then replace(idcomb_satelite,'COLL3','COLL1')    -- AC: Forçar estes combinações para que passam a ser COLL1 (Verificar a futuros exercicios se é necessário) (Mail enviado pela Corporação enviado a 22/01/2025)
			ELSE idcomb_satelite
		END AS idcomb_satelite_tratado,
        -- 3º Parte: Campo Specific sustainable do satélite
            case when a.specific_sustainable_part2 = 'Transitional' then 'SSUS1'
                 when a.specific_sustainable_part2 = 'Enabling' then 'SSUS2' 
                 when a.specific_sustainable_part2 = 'Pure' then 'SSUS3' 
                 when a.specific_sustainable_part2 = 'No' then 'SSUS4'
            else '' end as specific_sustainable,
        case
            when trim(a.esg_subsector_name) = 'Local Governments' then 'ESGS1'
                
            when trim(a.esg_subsector_name) = 'Sovereigns' then 'ESGS2'
            
            when trim(a.esg_subsector_name) = 'Investment firms' then 'ESGS3'
                
            when trim(a.esg_subsector_name) = 'Management firms' then 'ESGS4'
                
            when trim(a.esg_subsector_name) = 'Insurance undertakings' then 'ESGS5'
                
            when trim(a.esg_subsector_name) = 'Rest of other financial corporation'  then 'ESGS6' 
            
            --Para os casos em que a contraparte nao está preenchida, ir pelo que está no ID_Comb 
            when a.`33_counterparty_type` = '' and a.idcomb_satelite like '%SC0302%'  then 'ESGS6'
            
            else ''
        
        end as esg_subsector,
      
        case
            when trim(a.`102_purpose_esg`) = 'Building Renovation Loans' then 'PESG1'
                
            when trim(a.`102_purpose_esg`) = 'Motor vehicle loans' then 'PESG2'
            
            when trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' then 'PESG3'            
                
            when trim(a.`102_purpose_esg`) = ('Other Purpose') then 'PESG4'     
            
            else ''
        
        end as purpose_esg,
        
        case
                when a.idcomb_satelite not like '%SC0303%' then '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                when a.specific_sustainable_part2 = 'No' then ''   -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                when trim(a.specific_eligible) = 'SELI3' then '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                when trim(a.flag_nfrd)='' then '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                when a.`29_flag_specialised_lending` = '0' and trim(a.`102_purpose_esg`) = 'Building Acquisition Loans' then '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS                 
                when a.`29_flag_specialised_lending` = '1' and trim(a.specific_eligible) = 'SELI3' then 'SPLE2' -- FORÇADO COM BASE NO EMAIL DA CORPORAÇÃO DE DIA 09/01/2025
                when a.`29_flag_specialised_lending` = '0' and a.`67_use_of_proceeds`='Specific Purpose' then 'SPLE2' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS 
                when a.`67_use_of_proceeds`='General Purpose' then '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
        else ''
        end as specialised_lending,
        
        case 
            when a.flag_nfrd ='Subject to NFRD' then 'NFRD1'
            when a.flag_nfrd ='Not Subject to NFRD' then 'NFRD2'
            else ''
        end as nfrd_disclosures  
from bu_esg_work.pilar3_sat84_Dez24_tabaux5_v7 a
;


-- Jun24 (2)    ==>  4 243 registos -- após inclusão do case when no nace e cnael + novos racios
--              ==>  67 021 047 311.97 (Diferença de 2.294 € face ao univero full)

-- Dez24        ==> 4 480 registos  
--              ==> 67 708 032 144.48

-- Dez24_v3     ==> 4 812 registos  
--              ==> 67 708 032 144.48

-- drop table bu_esg_work.pilar3_sat84_Dez24_tabaux7_v7;
create table bu_esg_work.pilar3_sat84_Dez24_tabaux7_v7 as
select 
   csatelite,
   '00411' as INFORMING_SOC,
    case 
        when sociedade_contraparte = '' then '00000'
		 when sociedade_contraparte = '01278' then '00000'											
        else sociedade_contraparte
    end as counterparty_soc,
    'BI00411' as adjustment_code,
	

	case when idcomb_satelite_tratado like  'M01;MC42%'       -- Adição de condição para "Off balance and Memorandum/ Loans commitments given" com base no MdD
			OR idcomb_satelite_tratado like 'M01;MC4302%'     -- Adição de condição para "Off balance and Memorandum/ Other commitments given" com base no MdD 
			OR idcomb_satelite_tratado like 'M01;MC4301%'     -- Adição de condição para "Off balance and Memorandum/ Non-financial guarantees given" com base no MdD 
			OR idcomb_satelite_tratado like '%MC1301%'        -- Adição de condição para "Accrual - Other assets" com base no MdD 
			OR idcomb_satelite_tratado like '%ACPF7%'         -- Adição de condição para "Derivatives/ Hedge accounting" com base no MdD 
			OR idcomb_satelite_tratado like '%ACPF2%'         -- Adição de condição para "Derivatives + Derivatives + Equity instruments + Loans and advances/ Held for trading" com base no MdD 	
			OR idcomb_satelite_tratado like '%MC02;TYVA01%'   -- Adição de condição para "Loans and advances sem accounting portfolio" com base no MdD 
			OR idcomb_satelite_tratado like '%MC06;TYVA01%'   -- Adição de condição para "Equity instruments sem accounting portfolio" com base no MdD 
			OR idcomb_satelite_tratado like '%MC01%'          -- Adição de condição para "Cash on hand" com base no MdD 
			OR idcomb_satelite_tratado like '%MC05%'          -- Adição de condição para "Derivatives" com base no MdD 
			OR idcomb_satelite_tratado like '%MC11%'          -- Adição de condição para "Other intangible assets" com base no MdD 
			OR idcomb_satelite_tratado like '%MC12%'          -- Adição de condição para "Tax assets" com base no MdD (Adicionado a Dez24)
			OR idcomb_satelite_tratado like '%MC13%'          -- Adição de condição para "Other intangible assets" com base no MdD 
			OR (idcomb_satelite_tratado like '%MC02%'  and idcomb_satelite like '%SC01%') -- Adição de condição para "Cash and cash balances at central banks and other demand deposits" de central banks com base no MdD 	
			then concat(idcomb_satelite_tratado,';',originated_during_period ) 
		when idcomb_satelite_tratado like '%MC02%'  and idcomb_satelite like '%SC02%' and idcomb_satelite like '%ACPF1%'      -- Adição de condição para "Cash and cash balances at central banks and other demand deposits" de credit institutions com base no MdD 	
			then concat(idcomb_satelite_tratado,';',nfrd_disclosures,';', originated_during_period) 
		when idcomb_satelite_tratado like '%SC0302%'   -- Adição de condição para Outras empresas financeiras 
			then concat(idcomb_satelite_tratado,';', esg_subsector,';', nfrd_disclosures, ';', originated_during_period, ';', general_specific_purpose, ';', specialised_lending, ';', specific_eligible,';', specific_sustainable) 
		else concat(idcomb_satelite_tratado,';',Investment_Sector,';', esg_subsector,';',purpose_esg,';', nfrd_disclosures, ';', originated_during_period, ';', general_specific_purpose, ';', specialised_lending,';',specific_eligible,';', specific_sustainable) 
	end as COMB_CODE,
	    --
    sum(amount) as amount,
    case
        when european_union='N/A' then ''
        else european_union
    end as EU,
	-- forçar nace apenas para NFC (SC0303) ou investimentos em NFC (INVS5)
	CASE 
		WHEN idcomb_satelite like '%SC0304%' and cnael<>'' then '' -- FORÇAR PORQUE EXISTE UM PARTICULAR (SCO304) CLASSIFICADO COMO NFC (ENVIADA DUVIDA A LUISA AQUANDO DO PILOTO JUN23)
		when idcomb_satelite not like '%SC0303%' and Investment_Sector <> 'INVS5' then '' -- forçar nace apenas para NFC (SC0303) ou investimentos em NFC (INVS5)
		ELSE CNAEL 
	END AS CNAEL, 
	CASE 
		WHEN idcomb_satelite like '%SC0304%' and NACE_ESG <>'' then '' -- FORÇAR PORQUE EXISTE UM PARTICULAR (SCO304) CLASSIFICADO COMO NFC (ENVIADA DUVIDA A LUISA AQUANDO DO PILOTO JUN23)
		when idcomb_satelite not like '%SC0303%' and Investment_Sector <> 'INVS5' then '' -- forçar nace apenas para NFC (SC0303) ou investimentos em NFC (INVS5)
		ELSE NACE_ESG 
	END AS NACE, 
    round (sum(TUCCM),0) as TUCCM,
    round (sum(etccm),0) as etccm,
    round (sum(trant),0) as trant,
    round (sum(entccm),0) as entccm,
    round (sum(tucca),0) as tucca,
	round (sum(etcca),0) as etcca,
	round (sum(entcca),0) as entcca,

	round (sum(TUWTR),0) as TUWTR,
	round (sum(ETWTR),0) as ETWTR,
	round (sum(ENTWTR),0) as ENTWTR,
	round (sum(TUCE),0) as TUCE,
	round (sum(ETCE),0) as ETCE,
	round (sum(ENTCE),0) as ENTCE,
	round (sum(TUPPC),0) as TUPPC,
	round (sum(ETPPC),0) as ETPPC,
	round (sum(TUBIO),0) as TUBIO,
	round (sum(ETBIO),0) as ETBIO,

    round (sum(CACCM),0) as CACCM,
    round (sum(ecccm),0) as ecccm,
    round (sum(tranc),0) as tranc,
    round (sum(encccm),0) as encccm, 
    round (sum(cacca),0) as cacca, 
    round (sum(eccca),0) as eccca, 
    round (sum(enccca),0) as enccca, 	

	round (sum(CAWTR),0) as CAWTR,
	round (sum(ECWTR),0) as ECWTR,
	round (sum(ENCWTR),0) as ENCWTR,
	round (sum(CACE),0) as CACE,
	round (sum(ECCE),0) as ECCE,
	round (sum(ENCCE),0) as ENCCE,
	round (sum(CAPPC),0) as CAPPC,
	round (sum(ECPPC),0) as ECPPC,
	round (sum(CABIO),0) as CABIO,
	round (sum(ECBIO),0) as ECBIO    
	
from bu_esg_work.pilar3_sat84_Dez24_tabaux6_v7
WHERE concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) NOT IN ('00100CMAHAJID0000232600421BI0041100') -- Contrato removido por estar a gerar combinação inválida, não tem peso relevante (1 €) e foi decidido remover
group by 1,2,3,4,5,7,8,9
;

-- Jun24  (2)   ==>  4 205 registos 
--              ==>  67 021 047 335

-- Dez24        ==> 4 475 registos  
--              ==> 67 708 032 167

-- Dez24_v2     ==> 4 817 registos  
--              ==> 67 708 032 167

-- Dez24_v3     ==> 4 807 registos  
--              ==> 67 708 032 167

-- drop table bu_esg_work.pilar3_sat84_Dez24_tabaux8_v7; 
create table bu_esg_work.pilar3_sat84_Dez24_tabaux8_v7 as
select  
		csatelite,
		INFORMING_SOC,
		counterparty_soc,
		adjustment_code,
		COMB_CODE,
		round(amount,0) as amount,
		EU,
		CNAEL, 
		NACE, 
		
		-- Forçar rácios de elegibilidade apenas a idcombs válidos:
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCCM IS NULL THEN 0 ELSE TUCCM END AS TUCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCCM IS NULL THEN 0 ELSE ETCCM END AS ETCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TRANT IS NULL THEN 0 ELSE TRANT END AS TRANT,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCCM IS NULL THEN 0 ELSE ENTCCM END AS ENTCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCCA IS NULL THEN 0 ELSE TUCCA END AS TUCCA,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCCA IS NULL THEN 0 ELSE ETCCA END AS ETCCA,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCCA IS NULL THEN 0 ELSE ENTCCA END AS ENTCCA,

		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUWTR IS NULL THEN 0 ELSE TUWTR END AS TUWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETWTR IS NULL THEN 0 ELSE ETWTR END AS ETWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTWTR IS NULL THEN 0 ELSE ENTWTR END AS ENTWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCE IS NULL THEN 0 ELSE TUCE END AS TUCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCE IS NULL THEN 0 ELSE ETCE END AS ETCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCE IS NULL THEN 0 ELSE ENTCE END AS ENTCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUPPC IS NULL THEN 0 ELSE TUPPC END AS TUPPC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETPPC IS NULL THEN 0 ELSE ETPPC END AS ETPPC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUBIO IS NULL THEN 0 ELSE TUBIO END AS TUBIO,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETBIO IS NULL THEN 0 ELSE ETBIO END AS ETBIO,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACCM IS NULL THEN 0 ELSE CACCM END AS CACCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCCM IS NULL THEN 0 ELSE ECCCM END AS ECCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TRANC IS NULL THEN 0 ELSE TRANC END AS TRANC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCCM IS NULL THEN 0 ELSE ENCCCM END AS ENCCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACCA IS NULL THEN 0 ELSE CACCA END AS CACCA,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCCA IS NULL THEN 0 ELSE ECCCA END AS ECCCA,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCCA IS NULL THEN 0 ELSE ENCCCA END AS ENCCCA,

		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CAWTR IS NULL THEN 0 ELSE CAWTR END AS CAWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECWTR IS NULL THEN 0 ELSE ECWTR END AS ECWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCWTR IS NULL THEN 0 ELSE ENCWTR END AS ENCWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACE IS NULL THEN 0 ELSE CACE END AS CACE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCE IS NULL THEN 0 ELSE ECCE END AS ECCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCE IS NULL THEN 0 ELSE ENCCE END AS ENCCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CAPPC IS NULL THEN 0 ELSE CAPPC END AS CAPPC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECPPC IS NULL THEN 0 ELSE ECPPC END AS ECPPC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CABIO IS NULL THEN 0 ELSE CABIO END AS CABIO,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECBIO IS NULL THEN 0 ELSE ECBIO END AS ECBIO
from bu_esg_work.pilar3_sat84_Dez24_tabaux7_v7
	
where amount is not null and amount<>0;

---------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------   ADJUDICADOS   ---------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------


-- NOTA RITA (DEZ24) : ANALISAR SE MC10 POSSUEM VALOR EM 'CMAH' ASSOCIADO (PORQUE SE EXISTIR ESSE VALOR NAO VAI ESTAR NO FICHEIRO ENVIADO E O MONTANTE NAO VAI PASSAR DIRETAMENTE PARA O SATÉLITE)

-- Jun24       ==>  548  registos 
--              ==> 23 914 288 028

-- Dez24       ==>  455  registos 
--              ==> 40 660 145.8


-- drop table bu_esg_work.pilar3_sat84_Dez24_adj_tabaux1;
create table bu_esg_work.pilar3_sat84_Dez24_adj_tabaux1 as
select distinct
        a.csatelite,
		a.idcomb_satelite, 
        a.sociedade_contraparte,
        a.cod_ajust,
        a.cargabal_ct,
        a.saldo_ct,
        b.cod_imovel,
        b.tipo_adjudicado,
        --b.cargabal_vc,
        b.valor_cargabal_vc,
        b.fin_imovel,
		
        -- Remapeamento dos códigos NUTS uma vez que o input da corporação não incorpora as alterações feita pela União Europeia em 2024:
		CASE WHEN trim(b.`4_collateral_nuts`) = 'PT195' THEN 'PT16H'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1D2' THEN 'PT16I'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1D1' THEN 'PT16B'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT191' THEN 'PT16D'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT192' THEN 'PT16E'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT193' THEN 'PT16F'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT194' THEN 'PT16G'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1C1' THEN 'PT181'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1C2' THEN 'PT184'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1D3' THEN 'PT185'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1C3' THEN 'PT186'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT1C4' THEN 'PT187'
			 WHEN trim(b.`4_collateral_nuts`) = 'PT196' THEN 'PT116J'
			 WHEN trim(b.`4_collateral_nuts`) IN ('PT1B0', 'PT1A0') THEN 'PT170'
			 ELSE b.`4_collateral_nuts`
		END AS `4_collateral_nuts`,
		
        b.`5_collateral_zip_code`,
        b.tipo_imovel,        
        b.data_aquisicao,
        b.fiabilidad,
        b.clase_energetica,
        b.emisiones,
        b.consumos,
		'' as investment_sector,
		'' as esg_subsector, -- Na satellite structure é sempre N/A
        '' as purpose_esg, -- Na satellite structure é sempre N/A
        '' as nfrd_disclosures, -- Na satellite structure é sempre N/A
        '' as european_union, -- Apenas aplicável a id_comb SC0303 (NFC) o que não acontece para adjudicados
        '' as nace_esg,
        '' as CNAEL,
        'GSPUR2' as general_specific_purpose, -- REFERIDO NAS GUIDELINES DE OUT23_V2 QUE TODOS OS ADJUDICADOS DEVERÃO TER PROPÓSITO ESPECIFICO 
		
        '' as specialised_lending, -- Na satellite structure é sempre N/A
        
		case 
            when b.data_aquisicao >= '${ref_date_ini}' then 'ORDP1' -- Mapear com o primeiro do dia do ano em análise
            else 'ORDP2' 
        end as originated_during_period,
        
		case
            when cargabal_ct = '' then -saldo_ct
            else valor_cargabal_vc
        end as amount

from (  
		select csatelite, idcomb_satelite, sociedade_contraparte, cod_ajust, cargabal_ct, sum(saldo_ct) as saldo_ct 
        from bu_esg_work.rf_pilar3_universo_full
        where DT_RFRNC = '${ref_date}' 
		and ID_CORRIDA = '1'
		and csatelite = 84 
		and idcomb_satelite  like '%MC10%'                 
        group by 1,2,3,4,5
      ) as a

left join ( 
			    SELECT *
			    FROM
			    (
			        select * 
			        from bu_esg_work.adjudicados_Dez24_final
			        where tipo_adjudicado <> 'Totta URBE' and cargabal_vc in ('1605000','1605010')
			    ) x
			    LEFT JOIN
			    (
			        SELECT *
			        FROM bu_esg_work.gloval_clase_energetica_Dez24
			    ) CERT_ENERG
			    ON cod_imovel = chave_banco_atual
            ) as b
on a.cargabal_ct = b.cargabal_vc
;

-- Jun24       ==>  548  registos 
--             ==>  57 329 558.7 

-- Dez24       ==>  455  registos 
--              ==> 40 660 145.8

-- drop table bu_esg_work.pilar3_sat84_Dez24_adj_tabaux2;
create table bu_esg_work.pilar3_sat84_Dez24_adj_tabaux2 as
select distinct  
		csatelite,
		idcomb_satelite,
        sociedade_contraparte,
        cod_ajust,
        cargabal_ct,
        saldo_ct,
        cod_imovel,
        tipo_adjudicado,
        valor_cargabal_vc,
        fin_imovel,
        `4_collateral_nuts`,
        `5_collateral_zip_code`,
        tipo_imovel,
        data_aquisicao,
        esg_subsector,
        purpose_esg,
        nfrd_disclosures,
        european_union,
        specialised_lending,
        originated_during_period,
        amount,
		general_specific_purpose,
		'SELI3'	as specific_eligible, -- Segundo email da Corporação o universo de adjudicados deverá sempre ser mapeado como 'No'
		''	as specific_sustainable -- Segundo email da Corporação o universo de adjudicados deverá sempre ser mapeado como 'No'				
from bu_esg_work.pilar3_sat84_Dez24_adj_tabaux1
;			


-- Jun24       ==>  10  registos 
--             ==>  57 329 560

-- Jun24       ==>  10  registos 
--             ==>  40 660 145

-- drop table bu_esg_work.pilar3_sat84_Dez24_adj_tabaux3;
create table bu_esg_work.pilar3_sat84_Dez24_adj_tabaux3 as
select 
    csatelite,
	'00411' as INFORMING_SOC,
    case 
        when sociedade_contraparte = '' then '00000'
    	when sociedade_contraparte = '01278' then '00000'										   
        else sociedade_contraparte
    end as counterparty_soc,
    'BI00411' as adjustment_code,
    case when idcomb_satelite like '%ORIG3%' 
    	   or idcomb_satelite like '%ORIG2%' 
    	   or idcomb_satelite like '%ORIG1%' 
    	   or idcomb_satelite like '%MC1001%'
    	   or idcomb_satelite like '%MC1002%'
    	   or idcomb_satelite like '%MC1003%'
    	   or idcomb_satelite like '%MC1004%'
    	 then concat(idcomb_satelite,';', esg_subsector, ';', originated_during_period)
    	else concat(idcomb_satelite,';', esg_subsector,';',purpose_esg,';', nfrd_disclosures, ';', originated_during_period, ';', general_specific_purpose, ';',
        specialised_lending, ';', specific_eligible,';', specific_sustainable) end as id_comb,
    round(sum(amount)) as amount,		                                      
    '' as EU,
    '' as CNAEL,
    '' as NACE,	
    0 as TUCCM, -- em linha com as operações gerais
    0 as ETCCM,
    0 as TRANT,
    0 as ENTCCM,
    0 as TUCCA,
    0 as ETCCA,
    0 as ENTCCA,

    0 as TUWTR,
    0 as ETWTR,
    0 as ENTWTR,
    0 as TUCE,
    0 as ETCE,
    0 as ENTCE,
    0 as TUPPC,
    0 as ETPPC,
    0 as TUBIO,
    0 as ETBIO,	
    
    0 as CACCM, -- em linha com as operações gerais
    0 as ECCCM,
    0 as TRANC,
    0 as ENCCCM,
    0 as CACCA,
    0 as ECCCA,
    0 as ENCCCA,
    

    0 as CAWTR,
    0 as ECWTR,
    0 as ENCWTR,
    0 as CACE,
    0 as ECCE,
    0 as ENCCE,
    0 as CAPPC,
    0 as ECPPC,
    0 as CABIO,
    0 as ECBIO  
from bu_esg_work.pilar3_sat84_Dez24_adj_tabaux2
where amount <> 0
group by 1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
order by 4,1,2,3,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
;


-- Jun24       ==>  10  registos 
--             ==>  57 329 560

-- Jun24       ==>  10  registos 
--             ==>  40 660 145

-- drop table bu_esg_work.pilar3_sat84_Dez24_adj_tabaux4;
create table bu_esg_work.pilar3_sat84_Dez24_adj_tabaux4 as
select 
    csatelite,
	INFORMING_SOC,
    counterparty_soc,
    adjustment_code,

--- Martelar IDComb para desconsiderar COLL3 e COLL4 para MC04 e MC02 com SC02 que não existem no Cargabal----
    case
    	when id_comb like '%MC04%COLL4%' then replace(id_comb,'COLL4','COLL1')
		when id_comb like '%MC04%COLL3%' then replace(id_comb,'COLL3','COLL1')
    	when id_comb like '%MC02%SC02%COLL3%' then replace(id_comb,'COLL3','COLL1')
    	else id_comb
    end as id_comb,
    
    round(amount) as amount, 
	EU,
	CNAEL,
	NACE,
	TUCCM, -- em linha com as operações gerais
	ETCCM,
	TRANT,
	ENTCCM,
	TUCCA,
	ETCCA,
	ENTCCA,

	 TUWTR,
	 ETWTR,
	 ENTWTR,
	 TUCE,
	 ETCE,
	 ENTCE,
	 TUPPC,
	 ETPPC,
	 TUBIO,
	 ETBIO,
	
	CACCM, -- em linha com as operações gerais
	ECCCM,
	TRANC,
	ENCCCM,
	CACCA,
	ECCCA,
	ENCCCA,

	 CAWTR,
	 ECWTR,
	 ENCWTR,
	 CACE,
	 ECCE,
	 ENCCE,
	 CAPPC,
	 ECPPC,
	 CABIO,
	 ECBIO  		
FROM bu_esg_work.pilar3_sat84_Dez24_adj_tabaux3
;

-- Jun24  (2)  ==>  4 485  registos 
--             ==>  67 748 692 312.8

-- Dez24_v2    ==>  4 827  registos 
--             ==>  67 748 692 312.8

-- Dez24_v3    ==>  4 817  registos 
--             ==>  67 748 692 312.8

-- AGREGAÇÃO DE UNIVERSO DE OPERAÇÃO GERAIS + ADJUDICADOS

-- 
CREATE TABLE bu_esg_work.pilar3_sat84_Dez24_final_v7 AS
SELECT csatelite,
       informing_soc,
       counterparty_soc,
       adjustment_code,
       REGEXP_REPLACE(REGEXP_REPLACE(comb_code, ';+', ';'),';$','') as comb_code, 
       amount,
    	eu,
                           cnael,
                           nace,
                           tuccm,
                           etccm,
                           trant,
                           entccm,
                           tucca,
                           etcca,
                           entcca,
                           tuwtr,
                           etwtr,
                           entwtr,
                           tuce,
                           etce,
                           entce,
                           tuppc,
                           etppc,
                           tubio,
                           etbio,
                           caccm,
                           ecccm,
                           tranc,
                           encccm,
                           cacca,
                           eccca,
                           enccca,
                           cawtr,
                           ecwtr,
                           encwtr,
                           cace,
                           ecce,
						   encce,
		                   cappc,
						   ecppc,
						   cabio,
						   ecbio
FROM bu_esg_work.pilar3_sat84_Dez24_tabaux8_v7
UNION ALL
SELECT csatelite,
       informing_soc,
       counterparty_soc,
       adjustment_code,
       REGEXP_REPLACE(REGEXP_REPLACE(id_comb, ';+', ';'),';$','') as id_comb,
       amount,
       eu,
       cnael,
       nace,
       tuccm,
       etccm,
       trant,
       entccm,
       tucca,
       etcca,
       entcca,
       tuwtr,
       etwtr,
       entwtr,
       tuce,
       etce,
       entce,
       tuppc,
       etppc,
       tubio,
       etbio,
       caccm,
       ecccm,
       tranc,
       encccm,
       cacca,
       eccca,
       enccca,
       cawtr,
       ecwtr,
       encwtr,
       cace,
       ecce,
	   encce,
	   cappc,
	   ecppc,
	   cabio,
	   ecbio
FROM bu_esg_work.pilar3_sat84_Dez24_adj_tabaux4 ;



-- Desagregação em satélite automático e manual
-- drop table if exists bu_esg_work.pilar3_sat84_Dez24_final_aut_v7;
create table bu_esg_work.pilar3_sat84_Dez24_final_aut_v7 as
select *
from bu_esg_work.pilar3_sat84_Dez24_final_v7
where csatelite = 222 and amount <> 0.0;


-- drop table if exists bu_esg_work.pilar3_sat84_Dez24_final_manual_v7;
create table bu_esg_work.pilar3_sat84_Dez24_final_manual_v7 as
select *
from bu_esg_work.pilar3_sat84_Dez24_final_v7
where csatelite = 84 and amount <> 0.0;



insert overwrite table  bu_esg_work.RT_PILAR3_SATELITE84 partition (DT_RFRNC, PROC_ID)
select
INFORMING_SOC,
counterparty_soc,
adjustment_code,
id_comb,
amount,
EU,
CNAEL,
NACE,
cast(ETCCM  as decimal(38,0)),
cast(ETCCM  as decimal(38,0)),
cast(TRANT  as decimal(38,0)),
cast(ENTCCM as decimal(38,0)),
cast(TUCCA  as decimal(38,0)),
cast(ETCCA  as decimal(38,0)),
cast(ENTCCA as decimal(38,0)),
cast(CACCM  as decimal(38,0)),
cast(ECCCM  as decimal(38,0)),
cast(TRANC  as decimal(38,0)),
cast(ENCCCM as decimal(38,0)),
cast(CACCA  as decimal(38,0)),
cast(ECCCA  as decimal(38,0)),
cast(ENCCCA as decimal(38,0)),
strleft( cast(current_timestamp() as STRING), 10) as PROC_DATE,
-- Particao
'${ref_date}' as DT_RFRNC,
rt.NEW_PROC_ID
from bu_esg_work.pilar3_sat84_Dez24_final
left join
(Select nvl(max(PROC_ID),0)+1 as NEW_PROC_ID from bu_esg_work.RT_PILAR3_SATELITE84) RT
on 1=1
;




-- TABELAS ANALISES AUXILIARES --
---------------------------------
-- 3 216 
-- 3 711 (Jun24)				
DROP TABLE bu_esg_work.tradutor_cliente_Dez24
CREATE TABLE bu_esg_work.tradutor_cliente_Dez24 AS
SELECT *
FROM
(
	SELECT  KGL_AUX.GLCS,
	        LEI_AUX.lei,
	        CASE     
	            WHEN LEI_AUX.ZCLIENTE IS NOT NULL THEN LEI_AUX.ZCLIENTE
	            WHEN LEI_AUX.ZCLIENTE IS NULL THEN KGL_AUX.ZCLIENTE
	        ELSE '' 
	        END AS ZCLIENTE
	FROM
	(
	    SELECT DISTINCT CT003.zcliente, 
	                    RACIOS_AUX.lei,
	                    RACIOS_AUX.NFRD,
                        ADAPT_TURNOVER_T_ELIG,
                        ADAPT_TURNOVER_ENAB_ALIG,
                        ADAPT_TURNOVER_OWN_PERF_ALIG,
                        ADAPT_CAPEX_T_ELIG,
                        ADAPT_CAPEX_ENAB_ALIG,
                        ADAPT_CAPEX_OWN_PERF_ALIG,
                        MITIG_TURNOVER_T_ELIG,
                        MITIG_TURNOVER_ENAB_ALIG,
                        MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG,
                        MITIG_TURNOVER_OWN_PERF_ALIG,
                        MITIG_CAPEX_T_ELIG,
                        MITIG_CAPEX_ENAB_ALIG,
                        MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG,
                        MITIG_CAPEX_OWN_PERF_ALIG,
						POLLU_TURNOVER_TOTAL_ELIG, 
                    	POLLU_TURNOVER_OWN_PER_ALIG, 
                    	POLLU_CAPEX_TOTAL_ELIG, 
                    	POLLU_CAPEX_OWN_PERFORMANCE_ALIG, 
                    	BIO_TURNOVER_TOTAL_ELIG, 
                    	BIO_TURNOVER_OWN_PERFORMANCE_ALIG, 
                    	BIO_CAPEX_TOTAL_ELIG, 
                    	BIO_CAPEX_OWN_PERFORMANCE_ALIG, 
                    	WATER_TURNOVER_TOTAL_ELIG, 
                    	WATER_TURNOVER_ENABLING_ALIG, 
                    	WATER_TURNOVER_OWN_PERFORMANCE_ALIG, 
                    	WATER_CAPEX_TOTAL_ELIG, 
                    	WATER_CAPEX_ENABLING_ALIG, 
                    	WATER_CAPEX_OWN_PERFORMANCE_ALIG, 
                    	CIRC_TURNOVER_TOTAL_ELIG, 
                    	CIRC_TURNOVER_ENABLING_ALIG, 
                    	CIRC_TURNOVER_OWN_PERFORMANCE_ALIG, 
                    	CIRC_CAPEX_TOTAL_ELIG, 
                    	CIRC_CAPEX_ENABLING_ALIG, 
                    	CIRC_CAPEX_OWN_PERFORMANCE_ALIG							 
	    FROM
	     ( 
	        SELECT *
	        FROM bu_esg_work.GAR_External_Data_Dez24  ---- suposto alterar para jun24? ---- ALTERAR APÓS TER TABELA DE RÁCIOS DE ELEGIBILIDADE
	      ) AS RACIOS_AUX   
	      
	    -- Ligação rácio elegibilidade
	    
	    -- Por lei  
	    
	    LEFT JOIN 
	     (  
	        SELECT clei,
	               zcliente
	        FROM cd_captools.ct003_univ_cli
	        WHERE ref_date = '${ref_date}' AND TRIM(CLEI) <> '' --and zcliente='7400875388'	
	      ) AS CT003
	    ON RACIOS_AUX.lei = CT003.clei
	    
	) LEI_AUX
	FULL JOIN
	-- Por KGL
	(
    	SELECT *
    	   FROM
    	     (SELECT ROW_NUMBER () OVER (PARTITION BY XX.ZCLIENTE
    	                                 ORDER BY FLG ASC) AS ORDEM,
    	             XX.*
    	      FROM
    	        (
    	        select 
    			    ZCLIENTE,
    			    NFRD,
    			    GLCS,
    			    ADAPT_TURNOVER_T_ELIG,
    			    ADAPT_TURNOVER_ENAB_ALIG,
    			    ADAPT_TURNOVER_OWN_PERF_ALIG,
    			    ADAPT_CAPEX_T_ELIG,
    			    ADAPT_CAPEX_ENAB_ALIG,
    			    ADAPT_CAPEX_OWN_PERF_ALIG,
    			    MITIG_TURNOVER_T_ELIG,
    			    MITIG_TURNOVER_ENAB_ALIG,
    			    MITIG_TURNOVER_TRANSIT_ACTIVITY_ALIG,
    			    MITIG_TURNOVER_OWN_PERF_ALIG,
    			    MITIG_CAPEX_T_ELIG,
    			    MITIG_CAPEX_ENAB_ALIG,
    			    MITIG_CAPEX_TRANSIT_ACTIVITY_ALIG,
    			    MITIG_CAPEX_OWN_PERF_ALIG,
					POLLU_TURNOVER_TOTAL_ELIG, 
                    POLLU_TURNOVER_OWN_PER_ALIG, 
                    POLLU_CAPEX_TOTAL_ELIG, 
                    POLLU_CAPEX_OWN_PERFORMANCE_ALIG, 
                    BIO_TURNOVER_TOTAL_ELIG, 
                    BIO_TURNOVER_OWN_PERFORMANCE_ALIG, 
                    BIO_CAPEX_TOTAL_ELIG, 
                    BIO_CAPEX_OWN_PERFORMANCE_ALIG, 
                    WATER_TURNOVER_TOTAL_ELIG, 
                    WATER_TURNOVER_ENABLING_ALIG, 
                    WATER_TURNOVER_OWN_PERFORMANCE_ALIG, 
                    WATER_CAPEX_TOTAL_ELIG, 
                    WATER_CAPEX_ENABLING_ALIG, 
                    WATER_CAPEX_OWN_PERFORMANCE_ALIG, 
                    CIRC_TURNOVER_TOTAL_ELIG, 
                    CIRC_TURNOVER_ENABLING_ALIG, 
                    CIRC_TURNOVER_OWN_PERFORMANCE_ALIG, 
                    CIRC_CAPEX_TOTAL_ELIG, 
                    CIRC_CAPEX_ENABLING_ALIG, 
                    CIRC_CAPEX_OWN_PERFORMANCE_ALIG,								
    			    FLG
    			from
    			(
    				select corp.*, ccliente  as zcliente
    				from
    					(
    					select 'Y' as CIB, '1' as flg, * from bu_esg_work.GAR_External_Data_Dez24 ---- suposto alterar para jun24?
    					) corp
    				inner join 
    					(SELECT ccliente,gcli_kgl,centlegal,gnomelegal,cgrupo 
    					from cd_riscos.rstf159_rating_interno 
    					where data_date_part = '${ref_date_util}' and 
    					      trim(ccliente) not in ('','#')) cib ---- Cruzam 1.553 casos
    				on corp.glcs = cib.centlegal or corp.glcs = cib.cgrupo
    
    				union all
    				-- Cruzam 1.827 casos
    				(
    					select distinct corp.*, zcliente  as zcliente
    					from
    						(
    						select 'Y' as CIB, '2' as flg, * from bu_esg_work.GAR_External_Data_Dez24 ---- suposto alterar para jun24?
    						) corp
    					inner join 
    						(Select distinct ct70.zcliente, ct70.zgrupo, ct71.kgl5 from 
    							(Select * from cd_captools.ct070_univ_gr_cli where ref_date='${ref_date}' and tipo_relacao = 'CONTROLO') ct70
    						inner join 
    							(Select * from cd_captools.ct071_rwa_gr_ec where ref_date='${ref_date}' and trim(kgl5)<>'') ct71
    																																
    				
    							on ct70.zgrupo=ct71.zgrupo
    						) ct71 
    					on corp.glcs =  ct71.kgl5 
    				)
    
    				union all
    				-- Cruzam 642 casos
    				(
    					select distinct corp.*, zcliente  as zcliente
    					from
    						(
    						select 'Y' as CIB, '3' as flg, * from bu_esg_work.GAR_External_Data_DEZ23 ---- suposto alterar para jun24?
    						) corp
    					inner join
    						(select zcliente,cptyparent_code, cptylastparent_code from 
    							(Select distinct zcliente, trim(ccli_kgl) as ccli_kgl from cd_captools.ct003_univ_cli where ref_date='${ref_date}' 
    							and trim(ccli_kgl) <> '')ct03
    						inner join 
    							(Select * from bu_esg_work.p3_Client_Data_JQUEST) input
    							on trim(input.cpty_code) = trim(ct03.ccli_kgl)
    						) kgl_ct03 
    					on corp.glcs =  kgl_ct03.cptyparent_code or  corp.glcs =  kgl_ct03.cptylastparent_code
    				)
    			)x
    			)xx
    	 )XXX
    	WHERE ORDEM = 1 	
	) KGL_AUX
	ON LEI_AUX.ZCLIENTE = KGL_AUX.ZCLIENTE
) RACIOS_ELEG
WHERE ZCLIENTE IS NOT NULL