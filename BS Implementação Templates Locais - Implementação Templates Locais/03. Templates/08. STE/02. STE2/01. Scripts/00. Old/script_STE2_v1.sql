---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                          Processo de geração do STE 2 | Desenvolvimento Neyond 2025                                                                   --
--                  Banking book - Climate change transition risk: Loans collateralised by immovable property - Energy efficiency of the collateral                      --
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1º Passo: Identificação do universo a popular
-- REGISTOS: 365.743 | MONTANTE: -26 856 052 668.5381982389000000
drop table if exists bu_esg_work.local_pilar3_STE2_aux1_dez24_teste;
create table bu_esg_work.local_pilar3_STE2_aux1_dez24_teste AS

        select 
            a.*,
            b.`13_gross_carrying_amount`,
            -- b.`32_type_collateral`,
            b.ckbalbem,	
            b.ckctabem,
            b.ckrefbem,	
            -- b.`19_type_of_asset`,
            -- b.flag_colateral,
            -- b.zcliente,
            -- b.mavalbem, 
            b.epc,	
            b.quality_score,
            b.consumos,
            -- b.emisiones,
            case
                when d.valor_ltv is null then 101.000000
                when d.valor_ltv > 150 then 150.000000
                else d.valor_ltv
            end as valor_ltv,
            case
                when d.valor_ltv is null then 1.0100000000
                when d.valor_ltv > 150 then 1.5000000000
                else d.valor_ltv/100
            end as valor_ltv_decimal,
            case
                when tx_juro_lt = 99999999999.000000 then 0.000000 
                else tx_juro_lt
            end as tx_juro,
            case
                when d.valor_ltv is null then 'LTV5'
                when d.valor_ltv <= 40 then 'LTV1'
                when d.valor_ltv <= 60 then 'LTV2'
                when d.valor_ltv <= 80 then 'LTV3'
                when d.valor_ltv <= 100 then 'LTV4'
                else 'LTV5' 
            end as collateral_ltv,
            -- case
            --     when d.valor_ltv is null then 0 -- analisar marcação do valor ltv
            --     else 1
            -- end as flag_LTV, confirmar se temos nulls
            -- case
                -- when tx_juro_lt is null then 0
                -- when tx_juro_lt = 99999999999.000000 then 0 -- analisar marcação da tx juro
                -- else 1
            -- end as flag_txjuro,
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
            -- case
            --     when a.data_abertura>= '${ref_date_ini}' then ''  -- ver que valores o quality score toma na property, falar com helder para ver quais certifcados sao considerados reais
            --     when b.quality_score not in ('', '1-REAL','SANTANDER') or b.quality_score is null then '' -- ver quando é null que valor assume 
            --     when trim(b.epc_label_py) like 'A%' then 'PEPC1'
            --     when trim(b.epc_label_py) like 'B%' then 'PEPC2'
            --     when trim(b.epc_label_py) like 'C%' then 'PEPC3'
            --     when trim(b.epc_label_py) like 'D%' then 'PEPC4'
            --     when trim(b.epc_label_py) like 'E%' then 'PEPC5'
            --     when trim(b.epc_label_py) like 'F%' then 'PEPC6'
            --     when trim(b.epc_label_py) like 'G%' then 'PEPC7'
            --     else 'PEPC8'
            -- end as previous_year_epc_label, 
            -- case
            --     when a.data_abertura>= '${ref_date_ini}' then ''
            --     when b.consumos is null then ''  -- confirmar se existem nulls
            --     when b.ep_score_py <= 100 then 'PEPS1'
            --     when b.ep_score_py > 100 and b.ep_score_py <= 200 then 'PEPS2'
            --     when b.ep_score_py > 200 and b.ep_score_py <= 300 then 'PEPS3'
            --     when b.ep_score_py > 300 and b.ep_score_py <= 400 then 'PEPS4'
            --     when b.ep_score_py > 400 and b.ep_score_py <= 500 then 'PEPS5'
            --     when b.ep_score_py > 500 then 'PEPS6'
            --     else 'PEPS7'
            -- end as previous_year_ep_score,
            case
                when a.data_abertura>= '${ref_date_ini}' then ''
                when b.quality_score not in ('', '1-REAL','SANTANDER') or b.quality_score is null then '' -- quando é estimado o previous year vem a vazio
                when b.epc_label_py = 'A' then 'PEPC1'
                when b.epc_label_py = 'B' then 'PEPC2'
                when b.epc_label_py = 'C' then 'PEPC3'
                when b.epc_label_py = 'D' then 'PEPC4'
                when b.epc_label_py = 'E' then 'PEPC5'
                when b.epc_label_py = 'F' then 'PEPC6'
                when b.epc_label_py = 'G' then 'PEPC7'
                else 'PEPC8'
            end as previous_year_epc_label, 
            case
                when a.data_abertura>= '${ref_date_ini}' then ''
                when b.consumos is null then '' 
                when b.ep_score_py = 'menor_100' then 'PEPS1'
                when b.ep_score_py = 'menor_200' then 'PEPS2'
                when b.ep_score_py = 'menor_300' then 'PEPS3'
                when b.ep_score_py = 'menor_400' then 'PEPS4'
                when b.ep_score_py = 'menor_500' then 'PEPS5'
                when b.ep_score_py = 'maior_500' then 'PEPS6'
                else 'PEPS7'
            end as previous_year_ep_score,
            -- 'EU-area' as European_Union, -- vai mudar
            case                                                    
                when b.country_code IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                    then 'EU-area'
                when b.country_code NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428', '')
                    then 'Non EU-area'
                when b.cpais_residencia IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                    then 'EU-area'
                when b.cpais_residencia NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
                    then 'Non EU-area'
            else '' end as european_union,
            case
                when a.ccontab_final_idcomb_total like '%MC06%' then 'MESG4' -- regra corporação de acordo com satelite_strucutre
                when a.ccontab_final_idcomb_total like '%MC08%' then 'MESG4' -- regra corporação adicionada no piloto de jun23 para investments in subsidiaries pro tyva02 não devemos ter posso usar `17_accumulated_impairment`?
                when a.flag_mesg5 = 1 then 'MESG5'	 -- Counterparty having the choice of the repayment date
                when a.data_vencimento < "${ref_date}" and (a.data_vencimento not in ('','0001-01-01','9999-12-31') or a.data_vencimento is not null) then 'MESG1' -- contratos com maturidade inferior ao rácio => 1º bucket, validado com corporação e regras das guidelines							
                when (a.data_vencimento in ('','0001-01-01','9999-12-31') or a.data_vencimento is null)and a.ccontab_final_idcomb_total like '%MC02%' and a.ccontab_final_idcomb_total like '%COLL2%' then 'MESG4' -- unknown maturity residencial (adicionado por indicação da corporação 28/11/2024 "BS | ESG Pilar III - Satelite 220")
                when (a.data_vencimento in ('','0001-01-01','9999-12-31') or a.data_vencimento is null)and a.ccontab_final_idcomb_total like '%MC02%' and a.ccontab_final_idcomb_total like '%COLL3%' then 'MESG1' -- unknown maturity comercial (adicionado por indicação da corporação 28/11/2024 "BS | ESG Pilar III - Satelite 220")
                when (a.data_vencimento in ('','0001-01-01','9999-12-31') or a.data_vencimento is null)and a.ccontab_final_idcomb_total like '%MC02%' and a.ccontab_final_idcomb_total not like '%COLL2%' and a.ccontab_final_idcomb_total not like '%COLL3%' then 'MESG1' --unknown maturity rest of loans (adicionado por indicação da corporação 28/11/2024 "BS | ESG Pilar III - Satelite 220")
                when (a.data_vencimento in ('','0001-01-01','9999-12-31') or a.data_vencimento is null)and a.ccontab_final_idcomb_total like '%MC04%' then 'MESG1' -- unknown maturity bebt securities (adicionado por indicação da corporação 28/11/2024 "BS | ESG Pilar III - Satelite 220")
                when (a.data_vencimento in ('','0001-01-01','9999-12-31') or a.data_vencimento is null)then 'MESG6' -- Other contracts with no stated maturity
                when round(datediff(to_date(a.data_vencimento), to_date('${ref_date}'))/365.25,4) <= 05 then 'MESG1' 
                when round(datediff(to_date(a.data_vencimento), to_date('${ref_date}'))/365.25,4) <= 10 then 'MESG2'
                when round(datediff(to_date(a.data_vencimento), to_date('${ref_date}'))/365.25,4) <= 20 then 'MESG3'
                when round(datediff(to_date(a.data_vencimento), to_date('${ref_date}'))/365.25,4) > 20 then 'MESG4'
                else 'MESG6'
            end as maturity_esg,
            case
                when a.ccontab_final_idcomb_total like '%MC06%'                                            then 0		--Exclusão de equity
                when a.ccontab_final_idcomb_total like '%MC08%'                                            then 0
                when a.flag_mesg5 = 1                                                                      then 0		--Exclusão de counterparty having the choice of repayment date
                when a.data_vencimento in ('','0001-01-01','9999-12-31') or a.data_vencimento is null      then 0
                when a.data_vencimento < "${ref_date}"                                                     then 0
                when round(datediff(to_date(a.data_vencimento), to_date("${ref_date}"))/365.25,4) <= 05    then 1
                when round(datediff(to_date(a.data_vencimento), to_date("${ref_date}"))/365.25,4) <= 10    then 1
                when round(datediff(to_date(a.data_vencimento), to_date("${ref_date}"))/365.25,4) <= 20    then 1
                when round(datediff(to_date(a.data_vencimento), to_date("${ref_date}"))/365.25,4) >  20    then 1
                else 0			
            end as flag_maturity,
            case 
                when a.data_vencimento in ('','0001-01-01','9999-12-31') or a.data_vencimento is null then null
                when a.flag_mesg5 = 1 then null
                when a.data_vencimento < "${ref_date}" then null
                else round(datediff(to_date(a.data_vencimento), to_date("${ref_date}"))/365.25, 4)
            end as years_to_maturity,
            case
                when (data_inicio not in ('','0001-01-01','9999-12-31') or data_inicio is not null) and data_inicio >= '${ref_date_ini}' then 'NBF1' -- data inicio : data de reestruturação/renegociação
                when a.data_abertura >= '${ref_date_ini}' then 'NBF2' -- '2024-01-01'
                else 'NBF3'
            end as new_business_flow 

        from 
        (
            select distinct 
                -- sociedade_contraparte,
                data_abertura,
                data_vencimento,
                -- cod_ajust, 
                cempresa,
                cbalcao,
                cnumecta,
                zdeposit,
                tipo_colateral, -- vai alterar para a repartição
                ccontab_final_idcomb_total,
                bruto_imparidade,
                case 
                    when upper(produto) LIKE 'CART%CR%DITO%' OR 
                    upper(produto) LIKE '%REPOS%'  OR 
                    upper(produto) LIKE '%VISTA, DESCOBERTOS E CO%'
                then 1 end as flag_mesg5
            from bu_esg_work.p3_full_ctr_cli_local_dez24_v2 
            where dt_rfrnc = '${ref_date}' 
                -- and id_corrida IN (SELECT max(id_corrida) FROM bu_esg_work.p3_full_ctr_cli_local_dez24_v2 WHERE dt_rfrnc = '${ref_date}') 
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
                CERT_ENERG_PREVIOUS_YEAR.ep_score as ep_score_py,
                CERT_ENERG_PREVIOUS_YEAR.epc_label as epc_label_py,
                RENEGOCIADOS.data_inicio,
                property.country_code    
            FROM
            (
                SELECT * 
                FROM bu_esg_work.p3_reparticao_garantias_local_dez24
                WHERE dt_rfrnc = '${ref_date}' 
                    -- and id_corrida IN (SELECT max(id_corrida) FROM bu_esg_work.p3_reparticao_garantias_local_dez24 WHERE dt_rfrnc = '${ref_date}') 
            ) GAR
            LEFT JOIN
            -- (
            --     SELECT *
            --     FROM bu_esg_work.gloval_clase_energetica_dez24
            -- ) CERT_ENERG
            -- ON CONCAT(GAR.ckbalbem,GAR.ckctabem,GAR.ckrefbem) = chave_banco_atual
            (
                SELECT *
                FROM bu_esg_work.property_energy_certificate
                where data_date_part = '${ref_date}'
            ) CERT_ENERG
            ON CONCAT(GAR.ckbalbem,GAR.ckctabem,GAR.ckrefbem) = concat(property_branch_code, property_contract_id, property_reference_code) -- depois adicionar o cempbem
            LEFT JOIN
            (
                SELECT *
                FROM bu_esg_work.local_pilar3_temp2_dez23
            ) CERT_ENERG_PREVIOUS_YEAR
            ON CONCAT(coalesce(GAR.ckbalbem,'0'),coalesce(GAR.ckctabem,'0'),coalesce(GAR.ckrefbem,'0')) = CONCAT(coalesce(CERT_ENERG_PREVIOUS_YEAR.ckbalbem,'0'),coalesce(CERT_ENERG_PREVIOUS_YEAR.ckctabem,'0'),coalesce(CERT_ENERG_PREVIOUS_YEAR.ckrefbem,'0'))
            and CONCAT(GAR.cempresa,GAR.cbalcao,GAR.cnumecta,GAR.zdeposit) = CONCAT(CERT_ENERG_PREVIOUS_YEAR.cempresa,CERT_ENERG_PREVIOUS_YEAR.cbalcao,CERT_ENERG_PREVIOUS_YEAR.cnumecta,CERT_ENERG_PREVIOUS_YEAR.zdeposit)
            -- (
            --     SELECT *
            --     FROM bu_esg_work.property_energy_certificate
            --     where data_date_part = '${ref_date_ant}'
            -- ) CERT_ENERG_PREVIOUS_YEAR
            -- ON CONCAT(coalesce(GAR.ckbalbem,'0'),coalesce(GAR.ckctabem,'0'),coalesce(GAR.ckrefbem,'0')) = CONCAT(coalesce(CERT_ENERG_PREVIOUS_YEAR.property_branch_code,'0'),coalesce(CERT_ENERG_PREVIOUS_YEAR.property_contract_id,'0'),coalesce(CERT_ENERG_PREVIOUS_YEAR.property_reference_code,'0'))
            LEFT JOIN
            (
                SELECT substr(conta,1,4) as cbalcao, substr(conta,5,11) as cnumecta, zdeposit, data_inicio from bu_esg_work.rnm85_restr_dez24 -- a ser mudado para curated_internal_mainframe_reconducoes.rnm85_restr
                WHERE refinanciamento = 'S' and dificuldades_financeiras = 'N' and data_date_part = '${ref_date}'
            ) as RENEGOCIADOS
            ON concat(GAR.cbalcao,GAR.cnumecta,GAR.zdeposit) = concat(RENEGOCIADOS.cbalcao,RENEGOCIADOS.cnumecta,RENEGOCIADOS.zdeposit)
            LEFT JOIN
            (
                select distinct
                concat(property_branch_code, property_contract_id, property_reference_code) as chave_bem_gar,
                country_code from business_assets.property
                where data_date_part = '${ref_date}'
            ) property 
            on concat(GAR.ckbalbem, GAR.ckctabem, GAR.ckrefbem ) = property.chave_bem_gar 
            GROUP BY 
                GAR.cempresa,
                GAR.cbalcao,
                GAR.cnumecta,
                GAR.zdeposit,
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
                CERT_ENERG_PREVIOUS_YEAR.ep_score,
                CERT_ENERG_PREVIOUS_YEAR.epc_label,
                RENEGOCIADOS.data_inicio,
                property.country_code      
        ) as b
        on  a.cempresa = b.cempresa
        and a.cbalcao  = b.cbalcao
        and a.cnumecta = b.cnumecta
        and a.zdeposit = b.zdeposit

        left join 
        ( 
            select distinct b.cempresa,  b.cbalcao, b.cnumecta, b.zdeposit, a.ANNLSD_AGRD_RT as tx_juro_lt from
                (
                select distinct instrmnt_id, ANNLSD_AGRD_RT
                from cd_loan_tapes_bce.LT002_INSTRUMENT where ref_date = '${ref_date}' and ambito = 'PM' and nome_perimetro = 'Individual Local' and segmento = 'ESTR'
                ) a 
            left join
                (select distinct * from cd_captools.kt_chaves_finrep where ref_date = '${ref_date}') b
            on a.instrmnt_id = concat(b.cempresa_fr,b.cbalcao_fr,b.cnumecta_fr,b.zdeposit_fr)
        ) as c
        on  a.cempresa = c.cempresa
        and a.cbalcao  = c.cbalcao
        and a.cnumecta = c.cnumecta
        and a.zdeposit = c.zdeposit

        left join
        (
            select b.cempresa,  b.cbalcao, b.cnumecta, b.zdeposit, a.valor_ltv from
                (
                select distinct cempresa, cbalcao, cnumecta, zdeposit, valor_ltv
                from cd_captools.fr011_caps_ltv where ref_date = '${ref_date}'
                ) a 
            left join
                (select distinct * from cd_captools.kt_chaves_finrep where ref_date = '${ref_date}') b
            on a.cempresa = b.cempresa_fr and a.cbalcao= b.cbalcao_fr and a.cnumecta = b.cnumecta_fr and a.zdeposit = b.zdeposit_fr
        ) as d
        on  a.cempresa = d.cempresa
        and a.cbalcao  = d.cbalcao
        and a.cnumecta = d.cnumecta
        and a.zdeposit = d.zdeposit
        where `13_gross_carrying_amount` is not null
;

-- Tabela Final
drop table bu_esg_work.local_pilar3_STE2_final_dez24_teste;
create table bu_esg_work.local_pilar3_STE2_final_dez24_teste as
select
        tipo_colateral,
        epc_label,
        ep_score,
        european_union,
        round(-sum(`13_gross_carrying_amount`),0) AS amount,
        quality_score,
        new_business_flow,
        previous_year_ep_score,
        previous_year_epc_label,
        flag_maturity,
        maturity_esg,
        collateral_ltv,
        case
            when flag_maturity = 0  then null
            when round(-sum(`13_gross_carrying_amount`))*round(avg(years_to_maturity),0) < 0 then 0 -- zerar casos negativos
            else round(-sum(`13_gross_carrying_amount`))*round(avg(years_to_maturity),0) 
        end as aveg_aux,
        case
            when round(-sum(`13_gross_carrying_amount`)) * round(avg(tx_juro),2) < 0 then 0 -- zerar casos negativos
            else round(-sum(`13_gross_carrying_amount`)) * round(avg(tx_juro),2) 
        end as interest_aux,
        case
            when round(-sum(`13_gross_carrying_amount`)) * round(avg(valor_ltv_decimal),2) < 0 then 0 -- zerar casos negativos
            else round(-sum(`13_gross_carrying_amount`)) * round(avg(valor_ltv_decimal),2)
        end as ltv_aux    
    from bu_esg_work.local_pilar3_STE2_aux1_dez24_teste
    GROUP BY 1,2,3,4,6,7,8,9,10,11,12
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