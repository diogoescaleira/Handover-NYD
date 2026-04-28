---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                          Processo de geração do Template 2 | Desenvolvimento Neyond 2025                                                                   --
--                  Banking book - Climate change transition risk: Loans collateralised by immovable property - Energy efficiency of the collateral                      --
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1º Passo: Identificação do universo a popular
-- REGISTOS: 365.743 | MONTANTE: -26 856 052 668.5381982389000000
drop table if exists bu_esg_work.ag02_temp_cto_gra;
create table bu_esg_work.ag02_temp_cto_gra as
select 
	a.*,
	b.`13_gross_carrying_amount`,
	b.ckbalbem,	
	b.ckctabem,
	b.ckrefbem,	
	b.epc,	
	b.quality_score,
	b.consumos,
	case
		when trim(b.epc) like 'A%' then 'A'
		when trim(b.epc) like 'B%' then 'B'
		when trim(b.epc) like 'C%' then 'C'
		when trim(b.epc) like 'D%' then 'D'
		when trim(b.epc) like 'E%' then 'E'
		when trim(b.epc) like 'F%' then 'F'
		when trim(b.epc) like 'G%' then 'G'
		else 'Sem dados'
	end as EPC_Label, 
	case 
		when b.consumos <= 100 then 'menor_100'
		when b.consumos > 100 and b.consumos <= 200 then 'menor_200'
		when b.consumos > 200 and b.consumos <= 300 then 'menor_300'
		when b.consumos > 300 and b.consumos <= 400 then 'menor_400'
		when b.consumos > 400 and b.consumos <= 500 then 'menor_500'
		when b.consumos > 500 then 'maior_500'
		else 'Sem dados'
	end as EP_Score,
	case                                                    
		when b.country_code IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
			then 'EU-area'
		when b.country_code NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428', '')
			then 'Non EU-area'
		when b.cpais_residencia IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
			then 'EU-area'
		when b.cpais_residencia NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
			then 'Non EU-area'
	else '' end as european_union
from 
(
	select distinct 
		cempresa,
		cbalcao,
		cnumecta,
		zdeposit,
		tipo_colateral,
		ccontab_final_idcomb_total,
		bruto_imparidade
	from bu_esg_work.p3_full_ctr_cli_local_dez24_v2 
	where dt_rfrnc = '${ref_date}' 
		and template2=1
) as a

left join  
(
	SELECT  
		GAR.cempresa,
		GAR.cbalcao,
		GAR.cnumecta,
		GAR.zdeposit,
		SUM(GAR.`13_gross_carrying_amount`) AS `13_gross_carrying_amount`,
		GAR.ckbalbem,	
		GAR.ckctabem,
		GAR.ckrefbem,
		GAR.cpais_residencia,	
		CERT_ENERG.epc,	
		CERT_ENERG.quality_score,
		CERT_ENERG.ep_score as consumos,
		property.country_code 
	FROM
	(
		SELECT * 
		FROM bu_esg_work.p3_reparticao_garantias_local_dez24
		WHERE dt_rfrnc = '${ref_date}' 
	) GAR
	LEFT JOIN
	(
		select distinct
			property_branch_code, 
			property_contract_id, 
			property_reference_code,
			country_code 
		from business_assets.property
		where data_date_part = '${ref_date}'
	) property 
	on concat(GAR.ckbalbem, GAR.ckctabem, GAR.ckrefbem) = concat(property.property_branch_code, property.property_contract_id, property.property_reference_code) 			
	LEFT JOIN
	(
		SELECT *
		FROM bu_esg_work.property_energy_certificate
		where data_date_part = '${ref_date}'
	) CERT_ENERG
	ON CONCAT(GAR.ckbalbem,GAR.ckctabem,GAR.ckrefbem) = concat(property_branch_code, property_contract_id, property_reference_code) -- depois adicionar o cempbem
	GROUP BY 
		GAR.cempresa,
		GAR.cbalcao,
		GAR.cnumecta,
		GAR.zdeposit,
		GAR.ckbalbem,	
		GAR.ckctabem,
		GAR.ckrefbem,
		GAR.cpais_residencia,	
		CERT_ENERG.epc,	
		CERT_ENERG.quality_score,
		CERT_ENERG.ep_score,
		property.country_code 
) as b
on  a.cempresa = b.cempresa
and a.cbalcao  = b.cbalcao
and a.cnumecta = b.cnumecta
and a.zdeposit = b.zdeposit
where `13_gross_carrying_amount` is not null
;

-- Tabela Final
drop table bu_esg_work.ag02_temp_cto_agr;
create table bu_esg_work.ag02_temp_cto_agr as
select
        tipo_colateral,
        epc_label,
        ep_score,
        european_union,
        round(-sum(`13_gross_carrying_amount`),0) AS amount,
        quality_score,
from bu_esg_work.ag02_temp_cto_gra
group by 1,2,3,4,6,7,9,10,11,12,15
;





-- -- ADJUDICADOS 
-- -- REGISTOS: 486
-- drop table if exists bu_esg_work.local_pilar3_STE2_adj_dez24;
-- create table bu_esg_work.local_pilar3_STE2_adj_dez24 as
-- select
--     *,
--     case
--         when trim(clase_energetica) like 'A%' then 'A'
--         when trim(clase_energetica) like 'B%' then 'B'
--         when trim(clase_energetica) like 'C%' then 'C'
--         when trim(clase_energetica) like 'D%' then 'D'
--         when trim(clase_energetica) like 'E%' then 'E'
--         when trim(clase_energetica) like 'F%' then 'F'
--         when trim(clase_energetica) like 'G%' then 'G'
--         else 'Sem dados'
--     end as epc_label, 
--     case 
--         when consumos <= 100 then 'menor_100'
--         when consumos > 100 and consumos <= 200 then 'menor_200'
--         when consumos > 200 and consumos <= 300 then 'menor_300'
--         when consumos > 300 and consumos <= 400 then 'menor_400'
--         when consumos > 400 and consumos <= 500 then 'menor_500'
--         when consumos > 500 then 'maior_500'
--         else 'Sem dados'
--     end as ep_score,
--     'EU-area' as european_union
    
-- from 
-- (   
--     SELECT *
--     FROM
--     (
--         select * 
--         from bu_esg_work.adjudicados_dez24_final
--         where tipo_adjudicado <> 'Dações+Arrematações' and (cargabal_vc in ('1605000', '1605010') OR cargabal_prov = '2642300')
--     ) x
--     LEFT JOIN
--     (
--         SELECT *
--         FROM bu_esg_work.gloval_clase_energetica_dez24
--     ) CERT_ENERG
--     ON cod_imovel = chave_banco_atual
-- ) x; 


-- -- TABELA FINAL
-- -- REGISTOS : 30.756
-- drop table bu_esg_work.local_pilar3_STE2_final_dez24;
-- create table bu_esg_work.local_pilar3_STE2_final_dez24 as
-- SELECT 
--     'Stock' AS tipo_colateral,
--     epc_label,
--     ep_score,
--     european_union,
--     round(sum(valor_cargabal_vc)) AS amount,
--     fiabilidad,
--     tipo_adjudicado AS `32_type_collateral`,
--     null AS maturity,
--     '' as new_business_flow,
--     '' as previous_year_ep_score,
--     '' as previous_year_epc_label,
--     '' as collateral_ltv,
--     null as interest,
--     null as loan_to_value
-- FROM bu_esg_work.local_pilar3_STE2_adj_dez24
-- GROUP BY 1, 2, 3, 4, 6, 7,8,9,10,11,12,13,14

-- UNION ALL

-- select
--     tipo_colateral,
--     epc_label,
--     ep_score,
--     european_union,
--     round(-sum(`13_gross_carrying_amount`)) AS amount,
--     fiabilidad,
--     `32_type_collateral`,
--     round(years_to_maturity,0) AS maturity,
--     new_business_flow,
--     previous_year_ep_score,
--     previous_year_epc_label,
--     collateral_ltv,
--     round(tx_juro,2) as interest,
--     round(valor_ltv_decimal,2) as loan_to_value   
-- from bu_esg_work.local_pilar3_STE2_aux1_dez24
-- GROUP BY 1,2,3,4,6,7,8,9,10,11,12,13,14
-- ;