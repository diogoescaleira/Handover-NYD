
/********************************************************************************************************************************************
****   Projeto: Calculadora de Emissões                                                                         						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 22/12/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Cálculo de Emissões de Real Estate				     										     ****
********************************************************************************************************************************************/

-- #1: Distribuicao por finalidade em numero e valor. Tanto RE como CR
SELECT 
    purpose_code,
    property_purpose_code,
    cgarant_bem,
    SUM(AMOUNT) AS AMOUNT,
    COUNT(DISTINCT CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM) AS COUNT_BENS,
    SUM(scp1_emss_op2b) AS EMSS_SCP1,
    SUM(scp2_emss_op2b) AS EMSS_SCP2
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V2
WHERE purpose_code in ('CRE_OUTRO','Habitacao')
    and FLAG_CTO_BEM='CTO_IMO'
GROUP BY 1,2,3
;


-- #2: no CRE nos colaterais com finaldade RE ter uma distribuiçao de valor para despistar finalidades residenciais. 
-- Usando valor avaliacao ver população ( nr e valor) compor intervalo de valor < 500k, entre esse e < 1M, e maior q isso. 
SELECT 
    purpose_code,
    property_purpose_code,
    cgarant_bem,
    CASE 
        WHEN sum_mavalia IS NOT NULL AND sum_mavalia < 500000 THEN 'M. AVALIACAO < 500K'
        WHEN sum_mavalia IS NOT NULL AND sum_mavalia >= 500000 AND sum_mavalia < 1000000 THEN 'M. AVALIACAO >=500K E < 1M'
        WHEN sum_mavalia IS NOT NULL AND sum_mavalia >= 1000000 THEN 'M. AVALIACAO >= 1M'
    ELSE '' END AS ANALISE_MONT_AVAL, 
    SUM(AMOUNT) AS AMOUNT,
    COUNT(DISTINCT CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM) AS COUNT_BENS,
    SUM(scp1_emss_op2b) AS EMSS_SCP1,
    SUM(scp2_emss_op2b) AS EMSS_SCP2
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V2
WHERE purpose_code in ('CRE_OUTRO')
    AND FLAG_CTO_BEM='CTO_IMO'
    AND property_purpose_code = '01'
GROUP BY 1,2,3,4
;

-- #3: . Nos m2 tanto em CRE como em RE fazer a distribuiçao (valor e numero) de areas <50, entre isso e < 100, entre isso e 
-- menor q 200, entre isso e menor q 500, entre isso e menor q 1000, e dpois > q 1000 m2 
SELECT 
    purpose_code,
    -- property_purpose_code,
    -- cgarant_bem,
    CASE 
        WHEN net_floor_area < 50 THEN 'AREA < 50 m2'
        WHEN net_floor_area >=50 and net_floor_area < 100 THEN 'AREA >= 50 m2 e <100m2'
        WHEN net_floor_area >=100 and net_floor_area < 200 THEN 'AREA >= 100 m2 e <200m2'
        WHEN net_floor_area >=200 and net_floor_area < 500 THEN 'AREA >= 200 m2 e <500m2'
        WHEN net_floor_area >=500 and net_floor_area < 1000 THEN 'AREA >= 500 m2 e <1000m2'
        WHEN net_floor_area >=1000 THEN 'AREA >= 1000m2'
    ELSE '' END AS ANALISE_AREA_M2, 
    SUM(AMOUNT) AS AMOUNT,
    COUNT(DISTINCT CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM) AS COUNT_BENS,
    SUM(scp1_emss_op2b) AS EMSS_SCP1,
    SUM(scp2_emss_op2b) AS EMSS_SCP2
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V2
WHERE purpose_code in ('CRE_OUTRO','Habitacao')
    AND FLAG_CTO_BEM='CTO_IMO'
    AND (net_floor_area IS NOT NULL OR net_floor_area=0)
    AND origem_scp1_emss <> 'Nao Aplicavel'
GROUP BY 1,2
;
-- #4: Valor de tco2 por m2.   <10, entre isso e < 20, entre isso e <30, entre isso e <40, 
-- entre isso e <50, eentre isso e < 60 dpois > q 60 
SELECT 
    purpose_code,
    -- property_purpose_code,
    -- cgarant_bem,
    CASE 
        WHEN RATIO_INTENS_OP1 is null then 'SEM RACIO'
        WHEN RATIO_INTENS_OP1 < 10 THEN 'INTENS < 10'
        WHEN RATIO_INTENS_OP1 >= 10 AND RATIO_INTENS_OP1 < 20 THEN 'INTENS >= 10 e < 20'
        WHEN RATIO_INTENS_OP1 >= 20 AND RATIO_INTENS_OP1 < 30 THEN 'INTENS >= 20 e < 30'
        WHEN RATIO_INTENS_OP1 >= 30 AND RATIO_INTENS_OP1 < 40 THEN 'INTENS >= 30 e < 40'
        WHEN RATIO_INTENS_OP1 >= 40 AND RATIO_INTENS_OP1 < 50 THEN 'INTENS >= 40 e < 50'
        WHEN RATIO_INTENS_OP1 >= 50 AND RATIO_INTENS_OP1 < 60 THEN 'INTENS >= 50 e < 60'
         WHEN RATIO_INTENS_OP1 >= 60 THEN 'INTENS >= 60'
    ELSE '' END AS RACIO_CENARIO_1,
    CASE 
        WHEN RATIO_INTENS_OP2 is null then 'SEM RACIO'
        WHEN RATIO_INTENS_OP2 < 10 THEN 'INTENS < 10'
        WHEN RATIO_INTENS_OP2 >= 10 AND RATIO_INTENS_OP2 < 20 THEN 'INTENS >= 10 e < 20'
        WHEN RATIO_INTENS_OP2 >= 20 AND RATIO_INTENS_OP2 < 30 THEN 'INTENS >= 20 e < 30'
        WHEN RATIO_INTENS_OP2 >= 30 AND RATIO_INTENS_OP2 < 40 THEN 'INTENS >= 30 e < 40'
        WHEN RATIO_INTENS_OP2 >= 40 AND RATIO_INTENS_OP2 < 50 THEN 'INTENS >= 40 e < 50'
        WHEN RATIO_INTENS_OP2 >= 50 AND RATIO_INTENS_OP2 < 60 THEN 'INTENS >= 50 e < 60'
         WHEN RATIO_INTENS_OP2 >= 60 THEN 'INTENS >= 60'
    ELSE '' END AS RACIO_CENARIO_2,    
    SUM(AMOUNT) AS AMOUNT,
    COUNT(DISTINCT CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM) AS COUNT_BENS,
    SUM(scp1_emss_op2b) AS EMSS_SCP1,
    SUM(scp2_emss_op2b) AS EMSS_SCP2
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V3
WHERE purpose_code in ('CRE_OUTRO','Habitacao')
    AND FLAG_CTO_BEM='CTO_IMO'
GROUP BY 1,2,3
;
-- #5: Analise de correlacso entre 3 e 4
;

-- #6: % de imoveis sem area vs com area em ambos
SELECT 
    purpose_code,
    CASE 
        WHEN net_floor_area IS NULL OR net_floor_area = 0 THEN 'IMOVEL SEM ÁREA'
    ELSE 'IMOVEL COM ÁREA' END AS ANALISE_AREA, 
    -- cgarant_bem,
    SUM(AMOUNT) AS AMOUNT,
    COUNT(DISTINCT CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM) AS COUNT_BENS,
    SUM(scp1_emss_op2b) AS EMSS_SCP1,
    SUM(scp2_emss_op2b) AS EMSS_SCP2
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V2
WHERE purpose_code in ('CRE_OUTRO','Habitacao')
    and FLAG_CTO_BEM='CTO_IMO'
    AND origem_scp1_emss <> 'Nao Aplicavel'
GROUP BY 1,2
;

-- #7: Representatividade de valor de financiamento sem colateral em ambos
;

-- #8: Distribuicao dos p. Aquisicao <  q valor avaliacao ( com distincao entre a distancia destes valores %) 
-- por antiguidade financiamento
SELECT 
    UNIV.purpose_code,
    CASE 
        WHEN preco_aquisicao_ori IS NULL THEN 'SEM PRECO AQ.'
        WHEN sum_mavalia IS NULL THEN 'SEM M. AVALIACAO'
        WHEN preco_aquisicao_ori < sum_mavalia THEN 'PRECO AQUIS < M. AVALIACAO'
        WHEN preco_aquisicao_ori = sum_mavalia THEN 'PRECO AQUIS = M. AVALIACAO'
        WHEN preco_aquisicao_ori > sum_mavalia THEN 'PRECO AQUIS > M. AVALIACAO'
    ELSE '' END AS ANALISE_PA_MAVAL, 
    YEAR(DABERTUR) AS ANO_ABERT,
    CASE WHEN YEAR(DABERTUR) < 2000 THEN 'Year < 2000'
         WHEN YEAR(DABERTUR) >= 2000 THEN 'Year >= 2000'
    END AS VALIDA,
    SUM(AMOUNT) AS AMOUNT,
    COUNT(DISTINCT CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM) AS COUNT_BENS,
    SUM(scp1_emss_op2b) AS EMSS_SCP1,
    SUM(scp2_emss_op2b) AS EMSS_SCP2
FROM 
(
    SELECT *
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V2
    WHERE purpose_code in ('CRE_OUTRO','Habitacao')
        and FLAG_CTO_BEM='CTO_IMO'
) UNIV
LEFT JOIN
(
    SELECT *
    FROM cd_captools.ct004_univ_cto
    WHERE ref_date='2024-12-31'
) CT4
ON  UNIV.CEMPRESA = CT4.CEMPRESA AND
    UNIV.CBALCAO = CT4.CBALCAO AND
    UNIV.CNUMECTA = CT4.CNUMECTA AND
    UNIV.ZDEPOSIT = CT4.ZDEPOSIT
GROUP BY 1,2,3,4
;
 