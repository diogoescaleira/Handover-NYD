
drop table if exists bu_esg_work.ag080_enpc_cto_gra;
create table bu_esg_work.ag080_enpc_cto_gra AS

            select 
                a.*,
                b.`13_gross_carrying_amount`,
                b.ckbalbem,	
                b.ckctabem,
                b.ckrefbem,
                b.epc,	
                b.quality_score,
                b.consumos,
                -- b.emisiones,
                
            case
                -- when trim(b.fiabilidad) in ('7-SIN DATO', null) then 'EPSD3'
                -- when trim(b.fiabilidad) = '7-SIN DATO' or b.fiabilidad is null then 'EPSD3'
                when b.consumos is null then 'EPSD3'
                else 'EPSD2' -- quando houver uma nova tabela com as fiabilidades de consumo temos de desdobrar isto em condições como consumo real e estimado
            end as EP_Score_Data, -- consumos atualmente vêm todos da Gloval por isso são todos estimados --Passamos a ter hipótese de ter consumos reais (EPSD1)
                
                case 
                    when b.consumos <= 100 then 'EPSC1'
                    when b.consumos > 100 and b.consumos <= 200 then 'EPSC2'
                    when b.consumos > 200 and b.consumos <= 300 then 'EPSC3'
                    when b.consumos > 300 and b.consumos <= 400 then 'EPSC4'
                    when b.consumos > 400 and b.consumos <= 500 then 'EPSC5'
                    when b.consumos > 500 then 'EPSC6'
                    else 'EPSC7'
                end as EP_Score,
    
                
                Case when quality_score  IN ('1-REAL', 'SANTANDER') Then 'EPCD1'
                     when quality_score IN ('2-MUY ALTA', '3-ALTA', '4-MEDIA', '5-MEDIA BAJA', '6-BAJA') Then 'EPCD2'
                     else 'EPCD3'
                end as EP_Label_Data,
    
                case
                    when trim(b.epc) like 'A%' then 'EPCL1'
                    when trim(b.epc) like 'B%' then 'EPCL2'
                    when trim(b.epc) like 'C%' then 'EPCL3'
                    when trim(b.epc) like 'D%' then 'EPCL4'
                    when trim(b.epc) like 'E%' then 'EPCL5'
                    when trim(b.epc) like 'F%' then 'EPCL6'
                    when trim(b.epc) like 'G%' then 'EPCL7'
                    else 'EPCL8'
                end as EPC_Label, 
    
    
                case                                                    
                    when b.country_code IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                        then 'EU1'
                    when b.country_code NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428', '')
                        then 'EU2'
                    when b.cpais_residencia IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                        then 'EU1'
                    when b.cpais_residencia NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
                        then 'EU2'
                else '' end as european_union
    
            from 
    
    (select *, concat(cempresa_ct, cbalcao_ct, cnumecta_ct, zdeposit_ct) as chave_ct 
            from bu_esg_work.rf_pilar3_universo_full 
    		where DT_RFRNC = '${ref_date}' 
    			and id_corrida in (
    				select max(id_corrida)
    				from bu_esg_work.rf_pilar3_universo_full where DT_RFRNC = '${ref_date}')
            	and csatelite in (80, 220) 
                ) AS a
    
            left join  
            (
                SELECT  
                    GAR.cempresa_ct,
                    GAR.cbalcao_ct,
                    GAR.cnumecta_ct,
                    GAR.zdeposit_ct,
                    SUM(GAR.`13_gross_carrying_amount`) AS `13_gross_carrying_amount`,
                    -- GAR.`32_type_collateral`,
                    GAR.ckbalbem,	
                    GAR.ckctabem,
                    GAR.ckrefbem,
                    GAR.cpais_residencia,	
                    -- GAR.`19_type_of_asset`,
                    -- GAR.flag_colateral,
                    -- GAR.zcliente,
                    -- GAR.mavalbem, 
                    CERT_ENERG.epc,	
                    CERT_ENERG.quality_score,
                    CERT_ENERG.ep_score as consumos,
                    -- CERT_ENERG.emisiones,
                
                    property.country_code    
                FROM
                (
                    
	SELECT *
	FROM bu_esg_work.p3_reparticao_garantias
	WHERE dt_rfrnc='${ref_date}'
		AND id_corrida IN (SELECT max(id_corrida) FROM bu_esg_work.p3_reparticao_garantias WHERE DT_RFRNC = '${ref_date}') 
	 
                ) GAR
               
                LEFT JOIN
                  (
                      SELECT *
                    FROM bu_esg_work.property_energy_certificate
                    where data_date_part = '${ref_date}'
                ) CERT_ENERG
                ON CONCAT(GAR.ckbalbem,GAR.ckctabem,GAR.ckrefbem) = concat(property_branch_code, property_contract_id, property_reference_code) -- depois adicionar o cempbem
               
                LEFT JOIN
                (
                    select distinct
                    concat(property_branch_code, property_contract_id, property_reference_code) as chave_bem_gar,
                    country_code from business_assets.property
                    where data_date_part = '${ref_date}'
                ) property 
                on concat(GAR.ckbalbem, GAR.ckctabem, GAR.ckrefbem ) = property.chave_bem_gar 
                GROUP BY 
                    GAR.cempresa_ct,
                    GAR.cbalcao_ct,
                    GAR.cnumecta_ct,
                    GAR.zdeposit_ct,
                    -- GAR.`32_type_collateral`,
                    GAR.ckbalbem,	
                    GAR.ckctabem,
                    GAR.ckrefbem,
                    GAR.cpais_residencia,	
                    -- GAR.`19_type_of_asset`,
                    -- GAR.flag_colateral,
                    -- GAR.zcliente,
                    -- GAR.mavalbem, 
                    CERT_ENERG.epc,	
                    CERT_ENERG.quality_score,
                    CERT_ENERG.ep_score,
                    -- CERT_ENERG.emisiones,
                    property.country_code      
            ) as b

on  a.cempresa_ct = b.cempresa_ct
and a.cbalcao_ct  = b.cbalcao_ct
and a.cnumecta_ct = b.cnumecta_ct
and a.zdeposit_ct = b.zdeposit_ct

;   

-- Tabela Final
-- drop table bu_esg_work.ag080_enpc_cto_agr;
-- create table bu_esg_work.ag080_enpc_cto_agr as
Select
        
        case 
            when sociedade_contraparte = '' then '00000'
            else sociedade_contraparte
        end as counterparty_soc,
        'BI00411' as adjustment_code,
        concat(idcomb_satelite,';',ep_score_data,';',ep_score,';',ep_label_data,';',epc_label) as comb_code,
        round(-sum(`13_gross_carrying_amount`),0) as amount,
        european_union as eu 
    from bu_esg_work.ag080_enpc_cto_gra
    GROUP BY 1,2,3,5
    ;


