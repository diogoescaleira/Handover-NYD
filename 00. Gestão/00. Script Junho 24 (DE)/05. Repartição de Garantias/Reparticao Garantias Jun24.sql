
---------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | Código para processamento da repartição de garantias                                  --
---------------------------------------------------------------------------------------------------------------------
-- Neyond 2023                                                                                                     --
---------------------------------------------------------------------------------------------------------------------

-- Base que permite calcular o gross carrying amount por chave ct
	--> HF: 10/JAN - 1.811.865   Linhas
	--> HF: 22/JAN - 1.811.869   Linhas
	--> JB: 02/JUL - 1.811.869   Linhas (Dados dez/23)
	--> JB: 15/JUL - 2.067.284   Linhas  
	--> JB: 16/JUL - 2.067.600   Linhas 


DROP TABLE bu_esg_work.metricas_pilar3_ctr_cli_jun24_aux;
CREATE TABLE bu_esg_work.metricas_pilar3_ctr_cli_jun24_aux AS
SELECT  UNIV_CTR.*, 
        UNIV_CT.SUM_MSALDO_FINAL_CT AS gross_carrying_amount_aux
FROM (select * from bu_esg_work.rf_metricas_pilar3_ctr_cli_jun24 ) UNIV_CTR -- JB (02/07/24):  WHERE DT_RFRNC = '${DATE}' and id_corrida=2 --> Adição do filtro de data e corrida necessário?
LEFT JOIN
(
    SELECT CEMPRESA,
              CBALCAO,
              CNUMECTA,
              ZDEPOSIT,
              SUM(SUM_MSALDO_FINAL_CT) AS SUM_MSALDO_FINAL_CT
    FROM
    (
        SELECT CEMPRESA,
              CBALCAO,
              CNUMECTA,
              ZDEPOSIT ,
              CCONTAB_FINAL_CARGABAL,
              SUM(MSALDO_FINAL) AS SUM_MSALDO_FINAL_CT
        FROM CD_CAPTOOLS.CT001_UNIV_SALDO
        WHERE REF_DATE = '${ref_date}'
              AND flag_ativo=1
        GROUP BY 1,2,3,4,5
    ) A
    INNER JOIN
    ( 
        SELECT DISTINCT *
        FROM CD_CAPTOOLS.FR802_PL_CONTAS
        WHERE REF_DATE = '${ref_date}'
            AND DETALHE_CONTA = 'I'
            AND TIPO_CONTA = 'A'
            AND COD_PLANO = 'CARGABAL'
            AND CONTA <> ''
            AND UPPER(BRUTO_IMPARIDADE) <> 'IMPARIDADE'
            AND UPPER(INSTRUMENTO_FINANCEIRO) IN ('CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS',
                                                  'INSTRUMENTOS DE DIVIDA')
            AND UPPER(CARTEIRA_CONTABILISTICA) IN ('ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVES DE RESULTADOS',
                                                   'ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVÉS DE RESULTADOS',
                                                   'ATIVOS FINANCEIROS AO CUSTO AMORTIZADO',
                                                   'ATIVOS FINANCEIROS AO CUSTO AMORTIZADO',
                                                   'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE OUTRO RENDIMENTO INTEGRAL',
                                                   'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVÉS DE OUTRO RENDIMENTO INTEGRAL',
                                                   'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE RESULTADOS')
    ) B 
    ON A.CCONTAB_FINAL_CARGABAL = B.CONTA
    GROUP BY CEMPRESA,
              CBALCAO,
              CNUMECTA,
              ZDEPOSIT
) UNIV_CT
ON CONCAT(UNIV_CTR.CEMPRESA_CT,UNIV_CTR.CBALCAO_CT,UNIV_CTR.CNUMECTA_CT,UNIV_CTR.ZDEPOSIT_CT)=CONCAT(UNIV_CT.CEMPRESA,UNIV_CT.CBALCAO,UNIV_CT.CNUMECTA,UNIV_CT.ZDEPOSIT)

;
-------------------------------------------------------------------------------------------
------------------------------- Universo --------------------------------------------------
-------------------------------------------------------------------------------------------
--Base auxiliar para repartição das garantias/imóveis, cruzamento de métricas de cliente com as métricas de contrato
--401.914 registos
	--> HF: 10/JAN - 390.347  Linhas
	--> HF: 22/JAN - 390.347  Linhas	
	--> JB: 15/JUL - 363.794  Linhas
	--> JB: 16/JUL - 363.794  Linhas	
	
--drop table if exists bu_esg_work.reparticao_garantias_aux_jun24;
create table bu_esg_work.reparticao_garantias_aux_jun24 as

Select distinct
a.cempresa_fr012,
a.cbalcao_fr012,
a.cnumecta_fr012,
a.zdeposit_fr012,
a.cempresa_ct,
a.cbalcao_ct,
a.cnumecta_ct,
a.zdeposit_ct,
b.zcliente,
b.`12_non_performing`,
b.gross_carrying_amount_aux, 
b.`13_gross_carrying_amount`,
b.`14_nace`,
b.`15_nace_esg`,
b.nace_hold,
b.flag_SPV,
b.`17_accumulated_impairment`,
b.`22_counterparty_nuts`,
b.`23_counterparty_zipcode`,
b.cp3,
b.cpais_residencia,
b.`28_dt_maturity`,
b.`29_flag_specialised_lending`,
b.`30_stage_ifrs9`,
b.`33_counterparty_type`,
b.`83_dt_reference`,
b.`47_client_turnover`,
b.`48_group_turnover`,
b.`51_client_own_funds`,
b.client_debt,
b.client_revenue,
b.`53_client_nr_employees`,
b.`54_group_nr_employees`,
b.`70_flag_audited_financial_sttmnts`,
b.`71_dt_financial_statements`,
b.`73_client_total_assets`,
b.`74_group_total_assets`,
b.`75_isin`,
b.`93_european_union`,
b.`84_dt_origination`,
-- a.ckbalcao,     HF: 10/01
-- a.cknumcta,     HF: 10/01
-- a.comp_id_gar,  HF: 10/01
a.`32_type_collateral`,
a.`16_percent_collateral`, 
cast(a.mavaliaa as decimal(21,6)) as mavaliaa,
a.ckbalbem, 
a.ckctabem,
a.ckrefbem, 
a.`5_collateral_zip_code`, 
a.`4_collateral_nuts`,
a.mavalbem, 
a.tipo_imovel,

'' as casuistica
--flag_colateral

from (select * from bu_esg_work.p3_Colaterais_jun24) a 
inner join
bu_esg_work.metricas_pilar3_ctr_cli_jun24_aux b
on concat(a.cempresa_fr012, a.cbalcao_fr012, a.cnumecta_fr012, a.zdeposit_fr012)=concat(b.cempresa_fr012, b.cbalcao_fr012, b.cnumecta_fr012, b.zdeposit_fr012)
and concat(a.cempresa_ct, a.cbalcao_ct, a.cnumecta_ct, a.zdeposit_ct)=concat(b.cempresa_ct, b.cbalcao_ct, b.cnumecta_ct, b.zdeposit_ct)

;
-------------------------------------------------------------------------------------------
-------------------------- Campo gross_carrying_amount rateado ----------------------------
-------------------------------------------------------------------------------------------
-- 405.403  registos (mais registos porque são adicionadas as linhas não coberto)
	--> HF: 10/JAN - 393.196 Linhas
	--> HF: 22/JAN - 393.196 Linhas	
	--> JB: 15/JUL - 366.012 Linhas 
	--> JB: 16/JUL - 366.012 Linhas 
	
--drop table bu_esg_work.reparticao_garantias_aux_fr_jun24;
create table bu_esg_work.reparticao_garantias_aux_fr_jun24 as
SELECT * FROM (
(
SELECT x.cempresa_ct,
       x.cbalcao_ct,
       x.cnumecta_ct,
       x.zdeposit_ct,
       xx.ckbalbem,
       xx.ckctabem,
       xx.ckrefbem,
       xx.mavaliaa,
       montante_coberto*(mavaliaa/sum_mavaliaa) AS mont_repart,
       1 AS flag_colateral
from
(
    select  MAVALIA.cempresa_ct,MAVALIA.cbalcao_ct,MAVALIA.cnumecta_ct,MAVALIA.zdeposit_ct,
            sum(cast(mavaliaa as decimal(38,8))) as sum_mavaliaa,
            sum(cast(gross_carrying_amount_aux as decimal(38,8))) as sum_gross,
            case 
                -- Não coberto
                when sum(cast(gross_carrying_amount_aux as decimal(38,8))) > sum(cast(mavaliaa as decimal(38,8))) then sum(cast(mavaliaa as decimal(38,8)))  
                
                -- Coberto
                when sum(cast(gross_carrying_amount_aux as decimal(38,8))) <= sum(cast(mavaliaa as decimal(38,8))) and sum(cast(gross_carrying_amount_aux as decimal(38,8)))>0 then sum(cast(gross_carrying_amount_aux as decimal(38,8)))

            else 0 end as montante_coberto,   
    
            -- Parte não coberta
            case 
    
                when sum(cast(gross_carrying_amount_aux as decimal(38,8))) > sum(cast(mavaliaa as decimal(38,8))) then sum(cast(gross_carrying_amount_aux as decimal(38,8)))-sum(cast(mavaliaa as decimal(38,8)))
                
                when sum(cast(gross_carrying_amount_aux as decimal(38,8))) <= sum(cast(mavaliaa as decimal(38,8)))  and sum(cast(gross_carrying_amount_aux as decimal(38,8)))<0 then sum(cast(gross_carrying_amount_aux as decimal(38,8)))
                
            else 0 end as montante_n_cobert
    from 
    (
        select  
            cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct,
            -- ckbalcao,cknumcta,comp_id_gar,
            -- ckbalbem,ckctabem,ckrefbem,
            sum(mavaliaa) as mavaliaa
        from bu_esg_work.reparticao_garantias_aux_jun24
        group by cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct
    ) MAVALIA
    left join
    (
        select distinct 
                cempresa_ct,
                cbalcao_ct,
                cnumecta_ct,
                zdeposit_ct,
                -gross_carrying_amount_aux as gross_carrying_amount_aux
        from bu_esg_work.reparticao_garantias_aux_jun24
    ) GRSS
    on concat(MAVALIA.cempresa_ct,MAVALIA.cbalcao_ct,MAVALIA.cnumecta_ct,MAVALIA.zdeposit_ct)=concat(GRSS.cempresa_ct,GRSS.cbalcao_ct,GRSS.cnumecta_ct,GRSS.zdeposit_ct)
    
    GROUP BY
    MAVALIA.cempresa_ct,
    MAVALIA.cbalcao_ct,
    MAVALIA.cnumecta_ct,
    MAVALIA.zdeposit_ct
) x
left join
(
    select  
            cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct,
            ckbalbem,ckctabem,ckrefbem,
            sum(mavaliaa) as mavaliaa
    from bu_esg_work.reparticao_garantias_aux_jun24
    group by cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct,
             ckbalbem,ckctabem,ckrefbem
) xx
on concat(x.cempresa_ct,x.cbalcao_ct,x.cnumecta_ct,x.zdeposit_ct)=concat(xx.cempresa_ct,xx.cbalcao_ct,xx.cnumecta_ct,xx.zdeposit_ct)
)
union all 

(
SELECT nc.cempresa_ct,
       nc.cbalcao_ct,
       nc.cnumecta_ct,
       nc.zdeposit_ct,
       null as ckbalbem,
       null as ckctabem,
       null as ckrefbem,
       0 as mavaliaa,
       montante_n_cobert AS mont_repart,
       0 AS flag_colateral
       from
       (
    select  MAVALIA.cempresa_ct,MAVALIA.cbalcao_ct,MAVALIA.cnumecta_ct,MAVALIA.zdeposit_ct,
            sum(cast(mavaliaa as decimal(38,8))) as sum_mavaliaa,
            sum(cast(gross_carrying_amount_aux as decimal(38,8))) as sum_gross,
			
			            case 
                -- Não coberto
                when sum(cast(gross_carrying_amount_aux as decimal(38,8))) > sum(cast(mavaliaa as decimal(38,8))) then sum(cast(mavaliaa as decimal(38,8)))  
                
                -- Coberto
                when sum(cast(gross_carrying_amount_aux as decimal(38,8))) <= sum(cast(mavaliaa as decimal(38,8)))  and sum(cast(gross_carrying_amount_aux as decimal(38,8)))>0 then sum(cast(gross_carrying_amount_aux as decimal(38,8)))

            else 0 end as montante_coberto,   
    
            -- Parte não coberta
            case 
    
                when sum(cast(gross_carrying_amount_aux as decimal(38,8))) > sum(cast(mavaliaa as decimal(38,8))) then sum(cast(gross_carrying_amount_aux as decimal(38,8)))-sum(cast(mavaliaa as decimal(38,8)))
                
                when sum(cast(gross_carrying_amount_aux as decimal(38,8))) <= sum(cast(mavaliaa as decimal(38,8)))  and sum(cast(gross_carrying_amount_aux as decimal(38,8)))<0 then sum(cast(gross_carrying_amount_aux as decimal(38,8)))
                
            else 0 end as montante_n_cobert

    from 
    (
        select  
            cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct,
            -- ckbalcao,cknumcta,comp_id_gar,
            -- ckbalbem,ckctabem,ckrefbem,
            sum(mavaliaa) as mavaliaa
        from bu_esg_work.reparticao_garantias_aux_jun24
        group by cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct
    ) MAVALIA
    left join
    (
        select distinct 
                cempresa_ct,
                cbalcao_ct,
                cnumecta_ct,
                zdeposit_ct,
                -gross_carrying_amount_aux as gross_carrying_amount_aux
        from bu_esg_work.reparticao_garantias_aux_jun24
    ) GRSS
    on concat(MAVALIA.cempresa_ct,MAVALIA.cbalcao_ct,MAVALIA.cnumecta_ct,MAVALIA.zdeposit_ct)=concat(GRSS.cempresa_ct,GRSS.cbalcao_ct,GRSS.cnumecta_ct,GRSS.zdeposit_ct)
    
    GROUP BY
    MAVALIA.cempresa_ct,
    MAVALIA.cbalcao_ct,
    MAVALIA.cnumecta_ct,
    MAVALIA.zdeposit_ct
) NC
having abs(mont_repart) > 0
)
)x
;


---------------------------------------------------------------------------------------------
-- Inclusão do universo de contratos sem garantia com o universo de contratos com garantia --
---------------------------------------------------------------------------------------------

	--> Dez23 - 1.821.635 linhas

	--> HF: 22/JAN - 1.821.639 Linhas 
	--> JB: 16/JUL - 2.075.910 Linhas 

insert overwrite table  bu_esg_work.p3_reparticao_garantias partition (id_corrida, dt_rfrnc)
-- create table  bu_esg_work.reparticao_garantias_final_jun24 as
select 
    *,
    from_unixtime(unix_timestamp()) as htimest,
-- Particao
    CAST(NEW_ID_CORRIDA AS STRING) as ID_CORRIDA,
	"${ref_date}" as ref_date 
from
(
select distinct 
a.cempresa_ct,
a.cbalcao_ct,
a.cnumecta_ct,
a.zdeposit_ct,
a.zcliente,
a.`12_non_performing`,
a.gross_carrying_amount_aux as `13_gross_carrying_amount`,
a.`14_nace`,
a.`15_nace_esg`,
a.nace_hold,
a.flag_SPV,
a.`17_accumulated_impairment`,
a.`22_counterparty_nuts`,
a.`23_counterparty_zipcode`,
a.cp3,
a.cpais_residencia,
a.`28_dt_maturity`,
a.`29_flag_specialised_lending`,
a.`30_stage_ifrs9`,
a.`33_counterparty_type`,
a.`83_dt_reference`,
a.`47_client_turnover`,
a.`48_group_turnover`,
a.`51_client_own_funds`,
a.client_debt,
a.client_revenue,
a.`53_client_nr_employees`,
a.`54_group_nr_employees`,
a.`70_flag_audited_financial_sttmnts`,
a.`71_dt_financial_statements`,
a.`73_client_total_assets`,
a.`74_group_total_assets`,
a.`75_isin`,
a.`93_european_union`,
a.`84_dt_origination`,
NULL as 32_type_collateral,
NULL as 16_percent_collateral, 
NULL as mavaliaa,
NULL as ckbalbem,
NULL as ckctabem,
NULL as ckrefbem,
NULL as 5_collateral_zip_code, 
NULL as 4_collateral_nuts,
NULL as mavalbem,
NULL as 19_type_of_asset, 
NULL as flag_colateral,
1 as n_union
from bu_esg_work.metricas_pilar3_ctr_cli_jun24_aux a
where  concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct) not in
(select distinct concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) from bu_esg_work.p3_Colaterais_jun24)

union all
select distinct
b.cempresa_ct,
b.cbalcao_ct,
b.cnumecta_ct,
b.zdeposit_ct,
b.zcliente,
b.`12_non_performing`,
(b.mont_repart)*(-1) as `13_gross_carrying_amount`,
b.`14_nace`,
b.`15_nace_esg`,
b.nace_hold,
b.flag_SPV,
b.`17_accumulated_impairment`,
b.`22_counterparty_nuts`,
b.`23_counterparty_zipcode`,
b.cp3,
b.cpais_residencia,
b.`28_dt_maturity`,
b.`29_flag_specialised_lending`,
b.`30_stage_ifrs9`,
b.`33_counterparty_type`,
b.`83_dt_reference`,
b.`47_client_turnover`,
b.`48_group_turnover`,
b.`51_client_own_funds`,
b.client_debt,
b.client_revenue,
b.`53_client_nr_employees`,
b.`54_group_nr_employees`,
b.`70_flag_audited_financial_sttmnts`,
b.`71_dt_financial_statements`,
b.`73_client_total_assets`,
b.`74_group_total_assets`,
b.`75_isin`,
b.`93_european_union`,
b.`84_dt_origination`,
b.`32_type_collateral`,
b.`16_percent_collateral`, 
b.mavaliaa,
b.ckbalbem, 
b.ckctabem,
b.ckrefbem, 
b.`5_collateral_zip_code`, 
b.`4_collateral_nuts`,
b.mavalbem, 
b.tipo_imovel, 
b.flag_colateral,
2 as n_union
from 
(
    select x.*, xx.mont_repart, xx.flag_colateral
    from 
    (
        select *
        from bu_esg_work.reparticao_garantias_aux_jun24
    ) x
    left join
    (
        select *
        from bu_esg_work.reparticao_garantias_aux_fr_jun24
    ) xx
    on concat(x.cempresa_ct,x.cbalcao_ct,x.cnumecta_ct,x.zdeposit_ct,x.ckbalbem,x.ckctabem,x.ckrefbem) = 
       concat(xx.cempresa_ct,xx.cbalcao_ct,xx.cnumecta_ct,xx.zdeposit_ct,xx.ckbalbem,xx.ckctabem,xx.ckrefbem)
) b
union all

-- PERMITE INTRODUZIR DETALHE DO CONTRATO PARA OS CONTRATOS QUE POSSUEM EXPOSIÇÃO NÃO TOTALMENTE COBERTA PELA GARANTIA
(
    select 
        x.cempresa_ct,
        x.cbalcao_ct,
        x.cnumecta_ct,
        x.zdeposit_ct,
        x.zcliente,
        x.`12_non_performing`,
        (xx.mont_repart)*(-1) as `13_gross_carrying_amount`,
        x.`14_nace`,
        x.`15_nace_esg`,
        x.nace_hold,
        x.flag_SPV,
        x.`17_accumulated_impairment`,
        x.`22_counterparty_nuts`,
        x.`23_counterparty_zipcode`,
        x.cp3,
        x.cpais_residencia,
        x.`28_dt_maturity`,
        x.`29_flag_specialised_lending`,
        x.`30_stage_ifrs9`,
        x.`33_counterparty_type`,
        x.`83_dt_reference`,
        x.`47_client_turnover`,
        x.`48_group_turnover`,
        x.`51_client_own_funds`,
        x.client_debt,
        x.client_revenue,
        x.`53_client_nr_employees`,
        x.`54_group_nr_employees`,
        x.`70_flag_audited_financial_sttmnts`,
        x.`71_dt_financial_statements`,
        x.`73_client_total_assets`,
        x.`74_group_total_assets`,
        x.`75_isin`,
        x.`93_european_union`,
        x.`84_dt_origination`,
        NULL AS `32_type_collateral`,
        NULL AS `16_percent_collateral`, 
        NULL AS mavaliaa,
        NULL AS ckbalbem, 
        NULL AS ckctabem,
        NULL AS ckrefbem, 
        NULL AS `5_collateral_zip_code`, 
        NULL AS `4_collateral_nuts`,
        NULL AS mavalbem, 
        NULL AS tipo_imovel,
        xx.flag_colateral,
		3 as n_union
    from
    (
        select distinct 
            cempresa_ct,
            cbalcao_ct,
            cnumecta_ct,
            zdeposit_ct,
            zcliente,
            12_non_performing,
            gross_carrying_amount_aux,
            13_gross_carrying_amount,
            14_nace,
            15_nace_esg,
            nace_hold,
            flag_spv,
            17_accumulated_impairment,
            22_counterparty_nuts,
            23_counterparty_zipcode,
            cp3,
            cpais_residencia,
            28_dt_maturity,
            29_flag_specialised_lending,
            30_stage_ifrs9,
            33_counterparty_type,
            83_dt_reference,
            47_client_turnover,
            48_group_turnover,
            51_client_own_funds,
            client_debt,
            client_revenue,
            53_client_nr_employees,
            54_group_nr_employees,
            70_flag_audited_financial_sttmnts,
            71_dt_financial_statements,
            73_client_total_assets,
            74_group_total_assets,
            75_isin,
            93_european_union,
            84_dt_origination,
            -- NULL as ckbalcao,    HF: 10/01
            -- NULL as cknumcta,    HF: 10/01
            -- NULL as comp_id_gar, HF: 10/01
            NULL as 32_type_collateral,
            NULL as 16_percent_collateral,
            NULL as mavaliaa,
            NULL as ckbalbem,
            NULL as ckctabem,
            NULL as ckrefbem,
            NULL as 5_collateral_zip_code,
            NULL as 4_collateral_nuts,
            NULL as mavalbem,
            NULL as tipo_imovel,
            NULL as casuistica
        from bu_esg_work.reparticao_garantias_aux_jun24
    ) x
    left join
    (
        select *
        from bu_esg_work.reparticao_garantias_aux_fr_jun24
        where flag_colateral = 0
    ) xx
    on concat(x.cempresa_ct,x.cbalcao_ct,x.cnumecta_ct,x.zdeposit_ct) = 
       concat(xx.cempresa_ct,xx.cbalcao_ct,xx.cnumecta_ct,xx.zdeposit_ct)
	   having 13_gross_carrying_amount is not null 
)
) x

left join
(Select nvl(max(ID_CORRIDA),0)+1 as NEW_ID_CORRIDA from bu_esg_work.p3_colaterais) ID_COR
on 1=1
;




;
