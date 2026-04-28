
	-- TODAS ESTAS TABELAS FORAM CORRIDAS NO DIA 14/10

-- 1) NFIN DO REPORTE
CREATE TABLE BU_CAPTOOLS_WORK.NFIN_REP AS
SELECT *
FROM bu_esg_work.modesg_out_empr_info_nfin
    WHERE REF_DATE='2025-06-30'
;

-- 2) NFIN GERADA NO DIA 14/10 PARA TER A MARCA DE KGL 
CREATE TABLE BU_CAPTOOLS_WORK.NFIN_1410 AS
SELECT *
FROM bu_esg_work.modesg_out_empr_info_nfin_202506
    WHERE REF_DATE='2025-06-30'

;

-- 3) NFIN GERADA NO DIA 14/10 PARA TER A MARCA DE KGL // auxiliar 
CREATE TABLE BU_CAPTOOLS_WORK.NFIN_aux AS
SELECT *
FROM bu_esg_work.tmp_modesg_aux_cli_emss_scib_final
;

-- 4) Tabela de emissões estrutural 
CREATE TABLE BU_CAPTOOLS_WORK.emi_financ AS
SELECT *
FROM bu_esg_work.modesg_out_emss_fncd
    WHERE REF_DATE='2025-06-30'
;

-- 5) QUERY AUXILIAR NO REPORTE 

SELECT substr(F1.cod_nace_esg,1,1) AS NACE
    ,F2.origem_scp1_emss,F2.origem_scp2_emss,F2.origem_scp3_emss
    ,CASE
        WHEN F1.ZCLIENTE='8029317631' THEN 'PRISA'
        WHEN F1.ZCLIENTE='8000520483' THEN '0S30G'
        WHEN F1.ZCLIENTE='8001732068' THEN 'CGYNG'
        WHEN F1.ZCLIENTE='8008740708' THEN '5VFRG'
        WHEN F1.ZCLIENTE='8046459070' THEN '1500G'
        ELSE F3.CCLI_KGL
    END AS GLCS_CODE
    ,CASE WHEN F1.ZCLIENTE IN ('8029317631' ,'8000520483' ,'8001732068' ,'8008740708' ,'8046459070') THEN 1 ELSE 0 END AS FLAG_CLIENTE
    ,CASE 
        WHEN (F2.origem_scp1_emss LIKE '%SCIB%' OR F2.origem_scp2_emss LIKE '%SCIB%' OR F2.origem_scp3_emss LIKE '%SCIB%') THEN 1
        ELSE 0
    END AS FLAG_SCIB
    ,sum(AMOUNT) AS MONTANTE
    ,SUM(NVL(F2.scp1_emss_fncd,0))+SUM(NVL(F2.scp2_emss_fncd,0))+SUM(NVL(F2.scp3_emss_fncd,0)) AS TOTAL
    ,sum(f2.divida_total) as divida_tatico
    ,sum(f3.divida_total) as divida_estr
    
FROM 
    (
    SELECT DISTINCT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,cod_nace_esg,zcliente
    FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
    WHERE ID_CORRIDA=3 
    )F1
LEFT JOIN 
    (
    SELECT *
    FROM bu_esg_work.emi_finan_v4
    WHERE FLAG_PERIMETRO LIKE '%ST SGPS Cons%'
        -- AND (origem_scp1_emss LIKE '%SCIB%' OR origem_scp2_emss LIKE '%SCIB%' OR origem_scp3_emss LIKE '%SCIB%')
    )F2 ON F1.CHAVE=F2.CHAVE
LEFT JOIN 
    (
    SELECT *--zcliente,scp1_emss,scp2_emss,scp3_emss,origem_scp1_emss,origem_scp2_emss,origem_scp3_emss,divida_total,capital_proprio
    FROM bu_esg_work.tmp_modesg_aux_cli_emss_scib_final
    where (origem_scp1_emss LIKE '%SCIB%' OR origem_scp2_emss LIKE '%SCIB%' OR origem_scp3_emss LIKE '%SCIB%')
    )F3 ON f1.zcliente=F3.zcliente
GROUP BY 1,2,3,4,5,6,7

;
-- 7) AS IS - SCIB 


SELECT 
    substr(F1.cod_nace_esg,1,1) AS NACE,
    concat(
        lpad(regexp_extract(trim(cod_nace_esg), '^[A-Z]([0-9]+)\\.', 1), 2, '0'),
        '.',
        regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 1),
        regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 2)
    ) AS cod_formatado,
    CASE
        WHEN F1.ZCLIENTE='8029317631' THEN 'PRISA'
        WHEN F1.ZCLIENTE='8000520483' THEN '0S30G'
        WHEN F1.ZCLIENTE='8001732068' THEN 'CGYNG'
        WHEN F1.ZCLIENTE='8008740708' THEN '5VFRG'
        WHEN F1.ZCLIENTE='8046459070' THEN '1500G'
        ELSE F3.CCLI_KGL
    END AS GLCS_CODE,
    SUM(CAST(f2.AMOUNT AS DECIMAL (38,6)))*-1 AS AMOUNT,
    SUM(CAST(f2.SCP1_EMSS_FNCD AS DECIMAL (38,16))) AS GESI,
    SUM(CAST(f2.SCP2_EMSS_FNCD AS DECIMAL (38,16))) AS GESII,
    SUM(CAST(f2.SCP3_EMSS_FNCD AS DECIMAL (38,16))) AS GESIII
    
FROM 
    (
    SELECT DISTINCT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,cod_nace_esg,zcliente
    FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
    WHERE ID_CORRIDA=3 
    )F1
INNER JOIN 
    (
    SELECT *
    FROM bu_esg_work.EMI_FINAN_V3
    WHERE FLAG_PERIMETRO LIKE '%ST SGPS Cons%'
        AND (origem_scp1_emss LIKE '%SCIB%' OR origem_scp2_emss LIKE '%SCIB%' OR origem_scp3_emss LIKE '%SCIB%')
    )F2 ON F1.CHAVE=F2.CHAVE
LEFT JOIN 
    (
    SELECT *--zcliente,scp1_emss,scp2_emss,scp3_emss,origem_scp1_emss,origem_scp2_emss,origem_scp3_emss,divida_total,capital_proprio
    FROM bu_esg_work.tmp_modesg_aux_cli_emss_scib_final
    where (origem_scp1_emss LIKE '%SCIB%' OR origem_scp2_emss LIKE '%SCIB%' OR origem_scp3_emss LIKE '%SCIB%')
    )F3 ON f1.zcliente=F3.zcliente
GROUP BY 1,2,3

;

-- 7) TO BE - SCIB

SELECT 
    substr(F1.cod_nace_esg,1,1) AS NACE,
    concat(
        lpad(regexp_extract(trim(cod_nace_esg), '^[A-Z]([0-9]+)\\.', 1), 2, '0'),
        '.',
        regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 1),
        regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 2)
    ) AS cod_formatado,
    CASE
        WHEN F1.ZCLIENTE='8029317631' THEN 'PRISA'
        WHEN F1.ZCLIENTE='8000520483' THEN '0S30G'
        WHEN F1.ZCLIENTE='8001732068' THEN 'CGYNG'
        WHEN F1.ZCLIENTE='8008740708' THEN '5VFRG'
        WHEN F1.ZCLIENTE='8046459070' THEN '1500G'
        ELSE F3.CCLI_KGL
    END AS GLCS_CODE,
    SUM(CAST(f2.amount_v2 AS DECIMAL (38,6)))*-1 AS AMOUNT,
    SUM(CAST(f2.SCP1_EMSS_FNCD AS DECIMAL (38,16))) AS GESI,
    SUM(CAST(f2.SCP2_EMSS_FNCD AS DECIMAL (38,16))) AS GESII,
    SUM(CAST(f2.SCP3_EMSS_FNCD AS DECIMAL (38,16))) AS GESIII
    
FROM 
    (
    SELECT DISTINCT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,cod_nace_esg,zcliente
    FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
    WHERE ID_CORRIDA=3 
    )F1
INNER JOIN 
    (
    SELECT *
        ,concat(cempresa,cbalcao,cnumecta,zdeposit) as chave
        ,CASE WHEN  concat(cempresa,cbalcao,cnumecta,zdeposit)='31000320631593096000000000000000' THEN -1*AMOUNT ELSE AMOUNT END as amount_v2
    FROM bu_esg_work.modesg_out_emss_fncd
    WHERE nome_perimetro LIKE '%ST SGPS Cons%'
        AND (origem_scp1_emss LIKE '%SCIB%' OR origem_scp2_emss LIKE '%SCIB%' OR origem_scp3_emss LIKE '%SCIB%')
        and ref_date='2025-06-30'
    )F2 ON F1.CHAVE=F2.CHAVE
LEFT JOIN 
    (
    SELECT *--zcliente,scp1_emss,scp2_emss,scp3_emss,origem_scp1_emss,origem_scp2_emss,origem_scp3_emss,divida_total,capital_proprio
    FROM bu_esg_work.tmp_modesg_aux_cli_emss_scib_final
    where (origem_scp1_emss LIKE '%SCIB%' OR origem_scp2_emss LIKE '%SCIB%' OR origem_scp3_emss LIKE '%SCIB%')
    )F3 ON f1.zcliente=F3.zcliente
GROUP BY 1,2,3

-- 8) AS IS // DQS4

SELECT NACE,EUROPEAN_UNION,cod_formatado,SUM(AMOUNT_V1) AS GROSS,SUM(AMOUNT_V2) AS GROSS2, SUM(client_debt) AS DEBT,SUM(client_own_funds) AS EQUITY
    ,SUM(fatr_indv_pme) AS FATR,SUM(GESI) AS SCOPE1,SUM(GESII) AS SCOPE2,SUM(GESIII) AS SCOPE3
FROM 
    (
    SELECT 
        substr(F1.cod_nace_esg,1,1) AS NACE,F1.zcliente,EUROPEAN_UNION,
        concat(
            lpad(regexp_extract(trim(cod_nace_esg), '^[A-Z]([0-9]+)\\.', 1), 2, '0'),
            '.',
            regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 1),
            regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 2)
        ) AS cod_formatado,
        SUM(F2.AMOUNT_V1) AS AMOUNT_V1,
        SUM(F3.AMOUNT_V2) AS AMOUNT_V2,
        SUM(F2.GESI) AS GESI,
        SUM(F2.GESII) AS GESII,
        SUM(F2.GESIII) AS GESIII
        
    FROM 
        (
        SELECT DISTINCT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,cod_nace_esg,zcliente,EUROPEAN_UNION
        FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
        WHERE ID_CORRIDA=3 
        )F1
    INNER JOIN 
        (
        SELECT CHAVE,
                SUM(CAST(SCP1_EMSS_FNCD AS DECIMAL (38,16))) AS GESI,
                SUM(CAST(SCP2_EMSS_FNCD AS DECIMAL (38,16))) AS GESII,
                SUM(CAST(SCP3_EMSS_FNCD AS DECIMAL (38,16))) AS GESIII,
                SUM(CAST(AMOUNT AS DECIMAL (38,16)))*-1 AS AMOUNT_V1

        FROM bu_esg_work.EMI_FINAN_V3--bu_esg_work.modesg_out_emss_fncd
        WHERE flag_perimetro LIKE '%ST SGPS Cons%'
            AND (origem_scp1_emss LIKE '%BCL%' OR origem_scp1_emss LIKE '%PF%')
            AND origem_scp1_emss NOT LIKE '%SCIB%'
            AND (origem_scp1_emss LIKE '%DQS4%' OR origem_scp2_emss LIKE '%DQS4%' OR origem_scp2_emss LIKE '%DQS4%')
        GROUP BY 1
            -- and ref_date='2025-06-30'
        )F2 ON F1.CHAVE=F2.CHAVE
    LEFT JOIN 
        (
        SELECT CHAVE,SUM(CAST(AMOUNT AS DECIMAL (38,16)))*-1 AS AMOUNT_V2
        FROM bu_esg_work.EMI_FINAN_V4--bu_esg_work.modesg_out_emss_fncd
        WHERE flag_perimetro LIKE '%ST SGPS Cons%'
            AND (origem_scp1_emss LIKE '%BCL%' OR origem_scp1_emss LIKE '%PF%')
            AND origem_scp1_emss NOT LIKE '%SCIB%'
            AND (origem_scp1_emss LIKE '%DQS4%' OR origem_scp2_emss LIKE '%DQS4%' OR origem_scp2_emss LIKE '%DQS4%')
        GROUP BY 1
        )F3 ON F2.CHAVE=F3.CHAVE
    GROUP BY 1,2,3,4
    )L1
LEFT JOIN 
    (
    SELECT DISTINCT zcliente,client_own_funds,client_debt,fatr_indv_pme 
    FROM bu_esg_work.EMI_FINAN_V3
    )L2 ON L1.ZCLIENTE=L2.ZCLIENTE
GROUP BY 1,2,3
;
;

-- 9) TO BE / DQS4

SELECT NACE,EUROPEAN_UNION,cod_formatado,SUM(AMOUNT) AS GROSS, SUM(client_debt) AS DEBT,SUM(client_own_funds) AS EQUITY
    ,SUM(fatr_indv_pme) AS FATR,SUM(GESI) AS SCOPE1,SUM(GESII) AS SCOPE2,SUM(GESIII) AS SCOPE3
FROM 
    (
    SELECT 
        substr(F1.cod_nace_esg,1,1) AS NACE,F1.zcliente,EUROPEAN_UNION,
        concat(
            lpad(regexp_extract(trim(cod_nace_esg), '^[A-Z]([0-9]+)\\.', 1), 2, '0'),
            '.',
            regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 1),
            regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 2)
        ) AS cod_formatado,
        SUM(CAST(f2.amount_V2 AS DECIMAL (38,6)))*-1 AS AMOUNT,
        SUM(CAST(f2.SCP1_EMSS_FNCD AS DECIMAL (38,16))) AS GESI,
        SUM(CAST(f2.SCP2_EMSS_FNCD AS DECIMAL (38,16))) AS GESII,
        SUM(CAST(f2.SCP3_EMSS_FNCD AS DECIMAL (38,16))) AS GESIII
        
    FROM 
        (
        SELECT DISTINCT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,cod_nace_esg,zcliente,EUROPEAN_UNION
        FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
        WHERE ID_CORRIDA=3 
        )F1
    INNER JOIN 
        (
        SELECT *
            ,concat(cempresa,cbalcao,cnumecta,zdeposit) as chave
            ,CASE WHEN  concat(cempresa,cbalcao,cnumecta,zdeposit)='31000320631593096000000000000000' THEN -1*AMOUNT ELSE AMOUNT END as amount_v2
        FROM bu_esg_work.modesg_out_emss_fncd
        WHERE nome_perimetro LIKE '%ST SGPS Cons%'
            AND (origem_scp1_emss LIKE '%BCL%' OR origem_scp1_emss LIKE '%PF%')
            AND origem_scp1_emss NOT LIKE '%SCIB%'
            AND (origem_scp1_emss LIKE '%DQS4%' OR origem_scp2_emss LIKE '%DQS4%' OR origem_scp2_emss LIKE '%DQS4%')
            and ref_date='2025-06-30'
        )F2 ON F1.CHAVE=F2.CHAVE
    GROUP BY 1,2,3,4
    )L1
LEFT JOIN 
    (
    SELECT DISTINCT zcliente,client_own_funds,client_debt,fatr_indv_pme 
    FROM bu_esg_work.EMI_FINAN_V3
    )L2 ON L1.ZCLIENTE=L2.ZCLIENTE
GROUP BY 1,2,3


;
-- 10) AS IS DQS5 

SELECT 
    substr(F1.cod_nace_esg,1,1) AS NACE,EUROPEAN_UNION,
    concat(
        lpad(regexp_extract(trim(cod_nace_esg), '^[A-Z]([0-9]+)\\.', 1), 2, '0'),
        '.',
        regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 1),
        regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 2)
    ) AS cod_formatado,
    SUM(F2.AMOUNT_V1) AS AMOUNT_V1,
    SUM(F3.AMOUNT_V2) AS AMOUNT_V2,
    SUM(F2.GESI) AS GESI,
    SUM(F2.GESII) AS GESII,
    SUM(F2.GESIII) AS GESIII
    
FROM 
    (
    SELECT DISTINCT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,cod_nace_esg,zcliente,EUROPEAN_UNION
    FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
    WHERE ID_CORRIDA=3 
    )F1
INNER JOIN 
    (
    SELECT CHAVE,
            SUM(CAST(SCP1_EMSS_FNCD AS DECIMAL (38,16))) AS GESI,
            SUM(CAST(SCP2_EMSS_FNCD AS DECIMAL (38,16))) AS GESII,
            SUM(CAST(SCP3_EMSS_FNCD AS DECIMAL (38,16))) AS GESIII,
            SUM(CAST(AMOUNT AS DECIMAL (38,16)))*-1 AS AMOUNT_V1
    FROM bu_esg_work.EMI_FINAN_V3--bu_esg_work.modesg_out_emss_fncd
    WHERE flag_perimetro LIKE '%ST SGPS Cons%'
        AND (origem_scp1_emss LIKE '%BCL%' OR origem_scp1_emss LIKE '%PF%')
        AND origem_scp1_emss NOT LIKE '%SCIB%'
        AND (origem_scp1_emss LIKE '%DQS5%' OR origem_scp2_emss LIKE '%DQS5%' OR origem_scp2_emss LIKE '%DQS5%')
    GROUP BY 1
        -- and ref_date='2025-06-30'
    )F2 ON F1.CHAVE=F2.CHAVE
LEFT JOIN 
    (
    SELECT CHAVE,SUM(CAST(AMOUNT AS DECIMAL (38,16)))*-1 AS AMOUNT_V2
    FROM bu_esg_work.EMI_FINAN_V4--bu_esg_work.modesg_out_emss_fncd
    WHERE flag_perimetro LIKE '%ST SGPS Cons%'
        AND (origem_scp1_emss LIKE '%BCL%' OR origem_scp1_emss LIKE '%PF%')
        AND origem_scp1_emss NOT LIKE '%SCIB%'
        AND (origem_scp1_emss LIKE '%DQS5%' OR origem_scp2_emss LIKE '%DQS5%' OR origem_scp2_emss LIKE '%DQS5%')
    GROUP BY 1
    )F3 ON F2.CHAVE=F3.CHAVE
GROUP BY 1,2,3
;

-- 11) TO BE DQS5

    SELECT 
        substr(F1.cod_nace_esg,1,1) AS NACE,EUROPEAN_UNION,
        concat(
            lpad(regexp_extract(trim(cod_nace_esg), '^[A-Z]([0-9]+)\\.', 1), 2, '0'),
            '.',
            regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 1),
            regexp_extract(trim(cod_nace_esg), '^[A-Z][0-9]+\\.([0-9]+)\\.([0-9]+)$', 2)
        ) AS cod_formatado,
        SUM(CAST(f2.amount_V2 AS DECIMAL (38,6)))*-1 AS AMOUNT,
        SUM(CAST(f2.SCP1_EMSS_FNCD AS DECIMAL (38,16))) AS GESI,
        SUM(CAST(f2.SCP2_EMSS_FNCD AS DECIMAL (38,16))) AS GESII,
        SUM(CAST(f2.SCP3_EMSS_FNCD AS DECIMAL (38,16))) AS GESIII
        
    FROM 
        (
        SELECT DISTINCT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,cod_nace_esg,zcliente,EUROPEAN_UNION
        FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
        WHERE ID_CORRIDA=3 
        )F1
    INNER JOIN 
        (
        SELECT *
            ,concat(cempresa,cbalcao,cnumecta,zdeposit) as chave
            ,CASE WHEN  concat(cempresa,cbalcao,cnumecta,zdeposit)='31000320631593096000000000000000' THEN -1*AMOUNT ELSE AMOUNT END as amount_v2
        FROM bu_esg_work.modesg_out_emss_fncd
        WHERE nome_perimetro LIKE '%ST SGPS Cons%'
            AND (origem_scp1_emss LIKE '%BCL%' OR origem_scp1_emss LIKE '%PF%')
            AND origem_scp1_emss NOT LIKE '%SCIB%'
            AND (origem_scp1_emss LIKE '%DQS5%' OR origem_scp2_emss LIKE '%DQS5%' OR origem_scp2_emss LIKE '%DQS5%')
            and ref_date='2025-06-30'
        )F2 ON F1.CHAVE=F2.CHAVE
    GROUP BY 1,2,3









-- 98) Template 1 gerado com a tabela de emissões estrutural 

create table bu_captools_work.temp1_round_estr as 

SELECT 
    UNIVERSO.ZCLIENTE,
	UNIVERSO.CEMPRESA,
	UNIVERSO.CBALCAO,
	UNIVERSO.CNUMECTA,
	UNIVERSO.ZDEPOSIT,
    UNIVERSO.VB_IMP, 
    UNIVERSO.STAGES AS STAGE, 
    UNIVERSO.CONTRAPARTE,
	NFIN.FLG_CSRD AS FLAG_CSRD,
	SUM(ASCI) AS ASCI,
	SUM(GESI) AS GESI,
	SUM(ASC2) AS ASC2,
	SUM(GESII) AS GESII,
	SUM(ASCIII) AS ASCIII,
	SUM(GESIII) AS GESIII,
	CASE
		WHEN  TRIM(UNIVERSO.CONTRAPARTE) = 'outras empresas nao financeiras' AND NFIN.FLG_EMPRS_EXCL_PARIS = 1 THEN 'excluido' 
		WHEN  TRIM(UNIVERSO.CONTRAPARTE) = 'outras empresas nao financeiras' AND NFIN.FLG_EMPRS_EXCL_PARIS = 0 THEN 'nao excluido' 
		ELSE ''
	END AS EXCLUDED_PARIS,
	CASE
        WHEN INSTRUMENTO_FINANCEIRO = 'instrumentos de capital' THEN -3 -- 'INSTRUMENTOS DE CAPITAL' : > 20 ANOS
	    WHEN UNIVERSO.DATA_VENCIMENTO  IN ('','0001-01-01','9999-12-31',NULL) AND TIPO_COLATERAL = 'Garantia Residencial' THEN -2 -- FALTA DE DATA QUALITY DE DADOS MAS GARANTIA RESIDENCIAL
    	WHEN UNIVERSO.DATA_VENCIMENTO  IN ('','0001-01-01','9999-12-31',NULL) THEN -1 -- FALTA DE DATA QUALITY DE DADOS MAS NÃO GARANTIA RESIDENCIAL
	    WHEN UPPER(UNIVERSO.PRODUTO) LIKE 'CART%CR%DITO%' OR UPPER(UNIVERSO.PRODUTO) LIKE '%REPOS%'  OR UPPER(UNIVERSO.PRODUTO) LIKE '%VISTA, DESCOBERTOS E CO%' THEN -1 -- 'COUNTERPARTY HAVING THE CHOICE OF THE REPAYMENT DATE'
        WHEN UNIVERSO.DATA_VENCIMENTO  < '${REF_DATE}' THEN -4 --'OLD CONTRACTS' 
        ELSE ROUND(DATEDIFF(TO_DATE(UNIVERSO.DATA_VENCIMENTO), TO_DATE('${REF_DATE}'))/365.25, 4)
    END AS YEARS_TO_MATURITY,
	CASE
		WHEN UNIVERSO.ZCLIENTE = '0000000000' THEN 'S'
		WHEN NFIN.COD_NACE_ESG = '' AND UNIVERSO.CONTRAPARTE = 'outras empresas nao financeiras' THEN 'S' 
		WHEN NFIN.COD_NACE_ESG = 'Nao Aplicavel' THEN '' 
		WHEN NFIN.COD_NACE_ESG IS NULL THEN ''
		ELSE NFIN.COD_NACE_ESG
	END AS COD_NACE_ESG,
	SUM(
        CASE
            WHEN TRIM(UPPER(SFICS.NOME_GENERAL_SPECIFIC_PURPOSE)) = 'SPECIFIC PURPOSE' AND SFICS.NOME_SPECIFIC_ELIGIBLE = 'CCM' THEN NVL(ASCI,0) ELSE 0 END +
    	CASE 
    		WHEN TRIM(UPPER(SFICS.NOME_GENERAL_SPECIFIC_PURPOSE)) = 'GENERAL PURPOSE' THEN NVL(ASCI * NFIN.CCM_TRNVR_OWN_PRFRMNCE_ALGND/100,0) ELSE 0 END + 
        CASE 
    		WHEN TRIM(UPPER(SFICS.NOME_GENERAL_SPECIFIC_PURPOSE)) = 'GENERAL PURPOSE' THEN NVL(ASCI * NFIN.CCM_TRNVR_TRNSTN_ALIGND/100,0) ELSE 0 END + 
        CASE 
    		WHEN TRIM(UPPER(SFICS.NOME_GENERAL_SPECIFIC_PURPOSE)) = 'GENERAL PURPOSE' THEN NVL(ASCI * NFIN.CCM_TRNVR_ENBLNG_ALGND/100,0) ELSE 0 END 
		)  AS SUSTAINABLE_CCM,
	SOURCE_EMISSION_1,
	SOURCE_EMISSION_2,
	SOURCE_EMISSION_3,
	EUROPEAN_UNION,

    -- PARTICAO
	RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	'${REF_DATE}' AS REF_DATE
FROM
(    SELECT 
    	ZCLIENTE,
    	CEMPRESA,
    	CBALCAO,
    	CNUMECTA,
    	ZDEPOSIT,
        VB_IMP, 
        CONTRAPARTE,
        STAGES,
        DATA_VENCIMENTO,
        PRODUTO,
        INSTRUMENTO_FINANCEIRO,
        TIPO_COLATERAL,
		SOURCE_EMISSION_1,
		SOURCE_EMISSION_2,
		SOURCE_EMISSION_3,
		EUROPEAN_UNION,
    	SUM(AMOUNT) AS ASCI,
    	SUM(GESI) AS GESI,
    	SUM(AMOUNT) AS ASC2,
    	SUM(GESII) AS GESII,
    	SUM(AMOUNT) AS ASCIII,
    	SUM(GESIII) AS GESIII    	
    FROM
    (
        SELECT
        	UNIVERSO.ZCLIENTE,
        	UNIVERSO.CEMPRESA,
        	UNIVERSO.CBALCAO,
        	UNIVERSO.CNUMECTA,
        	UNIVERSO.ZDEPOSIT,
            UNIVERSO.BRUTO_IMPARIDADE AS VB_IMP, 
            CONTRAPARTE,
            STAGES,
            DATA_VENCIMENTO,
            PRODUTO,
            INSTRUMENTO_FINANCEIRO,
            TIPO_COLATERAL,
			CASE 
        		WHEN EMISS.ORIGEM_SCP1_EMSS IN ('MISS','Nao Aplicavel') THEN 'SOUR3'
        		WHEN EMISS.ORIGEM_SCP1_EMSS LIKE '%DQS1%' OR EMISS.ORIGEM_SCP1_EMSS LIKE '%DQS2%' THEN 'SOUR1'
    			ELSE 'SOUR2'
    		END AS SOURCE_EMISSION_1,
			CASE 
				WHEN EMISS.ORIGEM_SCP2_EMSS IN ('MISS','Nao Aplicavel') THEN 'SOUR3'
				WHEN EMISS.ORIGEM_SCP2_EMSS LIKE '%DQS1%' OR EMISS.ORIGEM_SCP2_EMSS LIKE '%DQS2%' THEN 'SOUR1'
				ELSE 'SOUR2'
			END AS SOURCE_EMISSION_2,
			CASE 
				WHEN EMISS.ORIGEM_SCP3_EMSS IN ('MISS','Nao Aplicavel') THEN 'SOUR3'
				WHEN EMISS.ORIGEM_SCP3_EMSS LIKE '%DQS1%' OR EMISS.ORIGEM_SCP3_EMSS LIKE '%DQS2%' THEN 'SOUR1'
				ELSE 'SOUR2'
			END AS SOURCE_EMISSION_3,
			CASE
				WHEN UNIVERSO.ZCLIENTE = '0000000000' THEN 'EU1'
				WHEN CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
					THEN 'EU1'
				WHEN CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
					THEN 'EU2'
				ELSE '' 
			END AS EUROPEAN_UNION,
            SUM(CAST(EMISS.AMOUNT AS DECIMAL (38,6)))*-1 AS AMOUNT,
            SUM(CAST(EMISS.SCP1_EMSS_FNCD AS DECIMAL (38,16))) AS GESI,
            SUM(CAST(EMISS.SCP2_EMSS_FNCD AS DECIMAL (38,16))) AS GESII,
            SUM(CAST(EMISS.SCP3_EMSS_FNCD AS DECIMAL (38,16))) AS GESIII
        FROM
        -- TABELA DE UNIVERSO
        (
        	SELECT 
        	DISTINCT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,ZCLIENTE,BRUTO_IMPARIDADE,STAGES,CONTRAPARTE,DATA_VENCIMENTO,PRODUTO,INSTRUMENTO_FINANCEIRO,TIPO_COLATERAL,CPAIS_RESIDENCIA
        	FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO
        	WHERE TEMPLATE1 = 1 AND
        		  REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO WHERE REF_DATE = '${REF_DATE}') AND BRUTO_IMPARIDADE = 'valor bruto'
        ) UNIVERSO
        
        LEFT JOIN 
        (   
            SELECT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,ZCLIENTE,ORIGEM_SCP1_EMSS, ORIGEM_SCP2_EMSS, ORIGEM_SCP3_EMSS,
				SUM(CASE WHEN  concat(cempresa,cbalcao,cnumecta,zdeposit)='31000320631593096000000000000000' THEN -1*AMOUNT ELSE AMOUNT END) AS AMOUNT
				,SUM(SCP1_EMSS_FNCD) AS SCP1_EMSS_FNCD,SUM(SCP2_EMSS_FNCD) AS SCP2_EMSS_FNCD,SUM(SCP3_EMSS_FNCD) AS SCP3_EMSS_FNCD
            FROM bu_esg_work.modesg_out_emss_fncd
            WHERE nome_perimetro LIKE '%ST SGPS Cons%'
            and REF_DATE = '${REF_DATE}'
            GROUP BY 1,2,3,4,5,6,7,8
        ) EMISS
        ON  UNIVERSO.CEMPRESA = EMISS.CEMPRESA AND
            UNIVERSO.CBALCAO  = EMISS.CBALCAO AND
            UNIVERSO.CNUMECTA = EMISS.CNUMECTA AND
            UNIVERSO.ZDEPOSIT = EMISS.ZDEPOSIT 

        GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
    ) BRUTO
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
    UNION ALL
    SELECT
    	UNIVERSO.ZCLIENTE, 
    	UNIVERSO.CEMPRESA,
    	UNIVERSO.CBALCAO,
    	UNIVERSO.CNUMECTA,
    	UNIVERSO.ZDEPOSIT,
        BRUTO_IMPARIDADE AS VB_IMP, 
        CONTRAPARTE,
        STAGES,
        DATA_VENCIMENTO,
        PRODUTO,
        INSTRUMENTO_FINANCEIRO,
        TIPO_COLATERAL,
        NULL AS SOURCE_EMISSION_1,
		NULL AS SOURCE_EMISSION_2,
		NULL AS SOURCE_EMISSION_3,
		CASE
			WHEN UNIVERSO.ZCLIENTE = '0000000000' THEN 'EU1' 
			WHEN CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
				THEN 'EU1'
			WHEN CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
				THEN 'EU2'
			ELSE '' 
		END AS EUROPEAN_UNION,
    	SUM(MSALDO_FINAL)*-1 AS ASCI,
    	NULL AS GESI,
    	SUM(MSALDO_FINAL)*-1 AS ASC2,
    	NULL AS GESII,
    	SUM(MSALDO_FINAL)*-1 AS ASCIII,
    	NULL AS GESIII
    FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO UNIVERSO
    WHERE TEMPLATE1 = 1 AND
    	  REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO WHERE REF_DATE = '${REF_DATE}') AND BRUTO_IMPARIDADE = 'imparidade'
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,16
) UNIVERSO
LEFT JOIN (SELECT * FROM BU_ESG_WORK.MODESG_OUT_EMPR_INFO_NFIN WHERE REF_DATE='${REF_DATE}') NFIN
ON UNIVERSO.ZCLIENTE = NFIN.ZCLIENTE 

LEFT JOIN (SELECT * FROM BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA WHERE REF_DATE='${REF_DATE}') SFICS
ON  UNIVERSO.CEMPRESA = SFICS.CEMPRESA AND
    UNIVERSO.CBALCAO  = SFICS.CBALCAO AND
    UNIVERSO.CNUMECTA = SFICS.CNUMECTA AND
    UNIVERSO.ZDEPOSIT = SFICS.ZDEPOSIT

LEFT JOIN
(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}'
) RT
ON  1=1

GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 16, 17, 18, 20, 21, 22, 23, 24, 25
;

-- 99) Clientes que são SCIB na NFIN, mas deixaram de ter origem scib na corrida que IT fez a 13/10

SELECT *
    ,CASE
	    WHEN F1.CLEI IN ('','#') AND F5.CLEI_GRUPO_MAX_CLEI IS NOT NULL THEN F5.CLEI_GRUPO_MAX_CLEI
	    ELSE F1.CLEI
    END AS CLEI_TRAT
    ,CASE
        WHEN ZCLIENTE_PF IS NOT NULL THEN 'Y'
        ELSE 'N'
    END AS FLAG_PF
FROM 
	-- 1º Cruzamento: Obter o Universo Base (Sem duplicados por zcliente) 
	-- A1.a) 
	--> JAN25 8.071.947 Registos 
    (
    SELECT TRIM(ZCLIENTE) AS ZCLIENTE
        ,TRIM(CCLI_GRUPO) AS CCLI_GRUPO
    	,TRIM(CCLI_KGL) AS CCLI_KGL
    	,TRIM(CLEI) AS CLEI
    	,cpais_residencia
    	,CASE
    	    WHEN TRIM(cpais_residencia) IN ('344','352','376','392','410','446','554','578','630','674','020','036','124','702','756','158','840') THEN 'Advanced economies'
    	    WHEN TRIM(cpais_residencia) IN ('040','056','100','191','196','203','208','233','246','250','276','300','348','372','380','428','440','442','470'
    	        ,'528','616','620','642','703','705','724','752','826') THEN 'EU member states'
    	 END AS VALOR_MV
    FROM CD_CAPTOOLS.CT084_UNIV_CLI_D
    WHERE REF_DATE = '${ref_date}'
    	AND ORIGEM = 'AUT'
    	and zcliente IN -- ='8008740708'
    ('8008740708'
    ,'8046459070'
    ,'8000520483'
    ,'8001732068'
    ,'8029317631')
    )F1
LEFT JOIN 
	-- 2º Cruzamento: Cruzamento com a rstf159_rating_interno
	-- A1.b) + A2. Reported emissions: 1.1 - 3 I)
	--> JAN25 8.071.947 Registos 
	(
	SELECT TRIM(CCLIENTE) AS CCLIENTE_RST159,TRIM(CENTLEGAL) AS CENTLEGAL_RST159,TRIM(CGRUPO) AS CGRUPO_RST159
	FROM CD_RISCOS.RSTF159_RATING_INTERNO
	WHERE DATA_DATE_PART = '${ref_date}'
	    AND TRIM(CCLIENTE) NOT IN ('','#')
	)F2 ON F1.ZCLIENTE=F2.CCLIENTE_RST159 
LEFT JOIN 
	-- 3º Cruzamento: Cruzamento com a ct071_rwa_gr_ec
	-- A1.c) + A2. Reported emissions: 1.1 - 3 II)
	--> JAN25 8.071.947 Registos 
    (
    SELECT DISTINCT S1.ZCLIENTE_CT088,S2.KGL5_CT071
    FROM
        (
		SELECT TRIM(ZCLIENTE) AS ZCLIENTE_CT088, TRIM(ZGRUPO) AS ZGRUPO_CT088
		FROM CD_CAPTOOLS.CT088_UNIV_GCL_D
		WHERE REF_DATE = '${ref_date}'
			AND TRIM(TIPO_RELACAO)='CONTROLO'
		)S1
	INNER JOIN 
	    (
	    SELECT DISTINCT ZGRUPO_CT071,KGL5_CT071
	    FROM
	    	(
	    	SELECT 
	    		TRIM(ZGRUPO) AS ZGRUPO_CT071,TRIM(KGL5) AS KGL5_CT071,TOT_ACTI AS TOT_ACTI_CT071
	    		,RANK() OVER (PARTITION BY ZGRUPO ORDER BY TOT_ACTI DESC) AS RANK_1
	    	FROM CD_CAPTOOLS.CT071_RWA_GR_EC
	    	WHERE REF_DATE = '${ref_date}'
	    		AND TRIM(KGL5)<>''
	    	)AUX_TRAT WHERE RANK_1=1 --9052
	    )S2 ON S1.ZGRUPO_CT088=S2.ZGRUPO_CT071
    )F3 ON F1.ZCLIENTE=F3.ZCLIENTE_CT088
-- LEFT JOIN 
-- 	-- 4º Cruzamento: Cruzamento com a JQUEST (p3_client_data_jquest)
-- 	-- A1.d) + A2. Reported emissions: 1.1 - 3 III)
-- 	--> JAN25 8.071.951 Registos
-- 	-- 2 CLIENTES A DUPLICAR POR VÁRIAS CORRESPONDÊNCIAS NA JQUEST (5100620259 - 4 COMBINAÇÕES // 7402308356 - 2 COMBINAÇÕES)
--     (
-- 	SELECT DISTINCT *
-- 	FROM
-- 		(
-- 		SELECT TRIM(ZCLIENTE) AS ZCLIENTE_JQUEST,TRIM(CCLI_KGL) AS CCLI_KGL_JQUEST
-- 		FROM CD_CAPTOOLS.CT084_UNIV_CLI_D
-- 		WHERE REF_DATE = '${ref_date}'
-- 			AND ORIGEM = 'AUT'
-- 			AND CCLI_KGL IS NOT NULL 
-- 		)S1
-- 	LEFT JOIN
-- 		(
-- 		SELECT TRIM(CPTY_CODE) AS CPTY_CODE_JQUEST,TRIM(CPTYPARENT_CODE) AS CPTYPARENT_CODE_JQUEST,TRIM(CPTYLASTPARENT_CODE) AS CPTYLASTPARENT_CODE_JQUEST
-- 		FROM BU_CAPTOOLS_WORK.P3_CLIENT_DATA_JQUEST
-- 		)S2 ON S1.CCLI_KGL_JQUEST=S2.CPTY_CODE_JQUEST
-- 	)F4 ON F1.ZCLIENTE=F4.ZCLIENTE_JQUEST
LEFT JOIN 
	-- 5º Cruzamento: Cruzamento por CLEI
	-- A2. Reported emissions: 1.1 - 1 I)
	--> JAN25 8.071.951 Registos
	(
	SELECT 
		*
	FROM    
		(
		SELECT 
			*
			,RANK() OVER (PARTITION BY CCLI_GRUPO_MAX_CLEI ORDER BY CLEI_GRUPO_MAX_CLEI DESC) AS RANK_MAX_CLEI
		FROM
			(
			SELECT DISTINCT
				TRIM(CCLI_GRUPO) AS CCLI_GRUPO_MAX_CLEI
				,TRIM(CLEI) AS CLEI_GRUPO_MAX_CLEI
			FROM CD_CAPTOOLS.CT084_UNIV_CLI_D
			WHERE REF_DATE = '${ref_date}'
				AND ORIGEM = 'AUT'
				AND TRIM(CLEI) NOT IN ('','#')
			)AUX
		)AUX_TRAT WHERE RANK_MAX_CLEI=1
	)F5 ON f1.CCLI_GRUPO=f5.CCLI_GRUPO_MAX_CLEI
-- LEFT JOIN 
-- 	-- 6º Cruzamento: Cruzamento por ISIN
-- 	-- A2. Reported emissions: 1.1 - 2 I)
-- 	--> JAN25 8.072.189 Registos
-- 	--> CLIENTES A DUPLICAR POR VÁRIAS CORRESPONDÊNCIAS DE ISIN
--     (
--     SELECT DISTINCT TRIM(ZCLIENTE_EMITENTE) AS ZCLIENTE_CT610,TRIM(ISIN) AS ISIN_CT610
--     FROM CD_CAPTOOLS.CT610_TITULOS
--     WHERE REF_DATE IN (SELECT MAX(REF_DATE) FROM CD_CAPTOOLS.CT610_TITULOS WHERE REF_DATE <= '${ref_date}')
--     )F6 ON F1.ZCLIENTE=F6.ZCLIENTE_CT610
-- LEFT JOIN 
-- 	-- 7º Cruzamento: Cruzamento por ISIN
-- 	-- A2. Reported emissions: 1.1 - 2 II) - Opção 1
-- 	--> JAN25 XXX Registos
-- 	--> CLIENTES A DUPLICAR POR VÁRIAS CORRESPONDÊNCIAS
--     (
--     SELECT DISTINCT TRIM(CAST(ZCLIENTE AS STRING)) AS ZCLIENTE_TTT35_1,TRIM(CTITISIN) AS CTITISIN_TTT35_1
--     FROM CD_MERCADOS.TTT35_TITLGRU
--     WHERE DATA_DATE_PART IN (SELECT MAX(DATA_DATE_PART) FROM CD_MERCADOS.TTT35_TITLGRU WHERE DATA_DATE_PART <= '${ref_date}')
--     )F7 ON F1.ZCLIENTE=F7.ZCLIENTE_TTT35_1
-- LEFT JOIN 
-- 	-- 8º Cruzamento: Cruzamento por ISIN
-- 	-- A2. Reported emissions: 1.1 - 2 II) - Opção 2
-- 	--> JAN25 XXX Registos
-- 	--> CLIENTES A DUPLICAR POR VÁRIAS CORRESPONDÊNCIAS
--     (
--     SELECT DISTINCT TRIM(CAST(ZCLIENTE AS STRING)) AS ZCLIENTE_TTT35_2,TRIM(CISINREF) AS CISINREF_TTT35_2
--     FROM CD_MERCADOS.TTT35_TITLGRU
--     WHERE DATA_DATE_PART IN (SELECT MAX(DATA_DATE_PART) FROM CD_MERCADOS.TTT35_TITLGRU WHERE DATA_DATE_PART <= '${ref_date}')
--     )F8 ON F1.ZCLIENTE=F8.ZCLIENTE_TTT35_2
LEFT JOIN
	-- 9º Cruzamento: Obter saldo do cliente 
	--> JAN25 XXX Registos
    (
    SELECT TRIM(ZCLIENTE) AS ZCLIENTE_FR004,nvl(-1*sum(VALOR_BRUTO_ON_A),0) sum_saldo_FR004
    FROM cd_captools.fr004_cto
    WHERE REF_DATE = '${ref_date}'
    GROUP BY 1 
    )F9 ON F1.ZCLIENTE=F9.ZCLIENTE_FR004
LEFT JOIN 
	-- 10º Cruzamento: Obter Flag Project Finance
	--> JAN25 XXX Registos
    (
    SELECT DISTINCT TRIM(ZCLIENTE) AS ZCLIENTE_PF
    FROM cd_captools.ct004_univ_cto 
    WHERE REF_DATE = '${ref_date}' 
		AND TRIM(flag_project_finance)='1'
    )F10 ON F1.ZCLIENTE=F10.ZCLIENTE_PF
LEFT JOIN 
	-- 11º Cruzamento: Obter Flag Project Finance
	--> JAN25 XXX Registos
    (
    SELECT TRIM(ZCLIENTE) AS ZCLIENTE_PME,fatr_indv AS fatr_indv_PME 
    FROM cd_captools.ct063_univ_pme 
    WHERE REF_DATE = '${ref_date}' 
    )F11 ON F1.ZCLIENTE=F11.ZCLIENTE_PME
LEFT JOIN 
	(
	SELECT TRIM(ZCLIENTE) AS ZCLIENTE_CONTRAPARTE,ref_date AS REF_DATE_CONTRAPARTE,TRIM(CONTRAPARTE) AS CONTRAPARTE
	FROM
		(
		SELECT ZCLIENTE,ref_date,contraparte
		,RANK() OVER (PARTITION BY ZCLIENTE ORDER BY ref_date DESC) AS RANK_CONTRAPARTE
		FROM CD_CAPTOOLS.CT084_UNIV_CLI_D
		WHERE ORIGEM = 'AUT'
			AND TRIM(contraparte)<>''
			AND contraparte IS NOT NULL 
			AND ref_date <= '${ref_date}'
		)AUX WHERE RANK_CONTRAPARTE=1
	)F12 ON F1.ZCLIENTE=F12.ZCLIENTE_CONTRAPARTE
LEFT JOIN 
    (
	SELECT DISTINCT *
	FROM
		(
		SELECT TRIM(ZCLIENTE) AS ZCLIENTE_JQUEST,TRIM(CCLI_KGL) AS CCLI_KGL_JQUEST
		FROM CD_CAPTOOLS.CT084_UNIV_CLI_D
		WHERE REF_DATE = '${ref_date}'
			AND ORIGEM = 'AUT'
			AND CCLI_KGL IS NOT NULL 
		)S1
	LEFT JOIN
		(
		SELECT TRIM(CPTY_CODE) AS CPTY_CODE_JQUEST,TRIM(CPTYPARENT_CODE) AS CPTYPARENT_CODE_JQUEST,TRIM(CPTYLASTPARENT_CODE) AS CPTYLASTPARENT_CODE_JQUEST
		FROM BU_CAPTOOLS_WORK.P3_CLIENT_DATA_JQUEST
		)S2 ON S1.CCLI_KGL_JQUEST=S2.CPTY_CODE_JQUEST
	)JQ ON F1.ZCLIENTE=JQ.ZCLIENTE_JQUEST
-- where f1.zcliente='8008740708'
