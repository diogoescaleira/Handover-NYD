/*******************************************************************************************************************************************
****   Projeto: Certificação Bail-In                                                                          						    ****
****   Autor: Neyond                                                                                                                    ****
****   Data: 17/11/2025                                                                                                                 ****
****   SQL Script Descrição: Simulação da Tabela LT004       																		    ****
********************************************************************************************************************************************

/*=========================================================================================================================================*/
/*  1. TABELA GRANULAR: SIMULAÇÃO DA TABELA LT004                                                                            			   */
/*=========================================================================================================================================*/

INSERT OVERWRITE TABLE BU_CAPTOOLS_WORK.SIMUL_LT004 PARTITION (ID_CORRIDA,REF_DATE)

SELECT 

    CASE
        WHEN DT_MTRTY_PRTCTN = '0000-00-00' THEN ''
        WHEN DT_MTRTY_PRTCTN = '1111-11-11' THEN '0001-01-01'
        ELSE DT_MTRTY_PRTCTN
        END AS DT_MTRTY_PRTCN

    ,PRTCTN_ID
    
    ,CASE
        WHEN PRTCTN_PRVDR_ID = 'N/A' THEN 'Not applicable'
        ELSE PRTCTN_PRVDR_ID
        END AS PRTCTN_PRVDR_ID
        
    ,CASE
        WHEN TRIM(TIPOLOGIA) = 'PES' THEN 'N'
        WHEN TRIM(TIPOLOGIA) <> 'PES' THEN 'Y'
        END AS FLG_SCRD
        
    ,RT.NEW_ID_CORRIDA AS ID_CORRIDA
    
     ,'${REF_DATE}' AS REF_DATE    

FROM 

--TABELA DE UNIVERSO
    (
    SELECT DISTINCT PRTCTN_ID, REPLACE(REPLACE(PRTCTN_ID, 'P', ''), '_', '') AS PRCTCN_ID_CLEAN 
    FROM 
        (
        SELECT 
            INSTRMNT_ID
        FROM BU_CAPTOOLS_WORK.SIMUL_LT002_INSTRUMENT
        WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.SIMUL_LT002_INSTRUMENT WHERE REF_DATE ='${REF_DATE}')
        )LT002
    LEFT JOIN

        (
        SELECT 
            CEMPRESA,
            CBALCAO,
            CNUMECTA,
            ZDEPOSIT,
            CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE_IC,
            CONCAT(CEMPRESA_FR,CBALCAO_FR,CNUMECTA_FR,ZDEPOSIT_FR) AS CHAVE_FR
        FROM CD_CAPTOOLS.KT_CHAVES_FINREP
        WHERE REF_DATE = '${REF_DATE}'
        )KT_FR ON INSTRMNT_ID = CHAVE_FR

    INNER JOIN
        (
        SELECT 
            CKBALCAO,
            CKNUMCTA,
            COMP_ID_GAR,
            CKBALRES,
            CKCTARES,
            CKREFRESP,
            TIPOLOGIA AS TIPOLOGIA_GT018,
            CONCAT(CKBALCAO,CKNUMCTA,COMP_ID_GAR) AS CHAVE_PROC,
            CONCAT(CKBALRES,CKCTARES,CKREFRESP) AS CHAVE_RESP,
            CONCAT(SUBSTRING(TIPOLOGIA,1,1),'_',CKBALBEM,'_',CKCTABEM,'_',CKREFBEM) AS PRTCTN_ID
        FROM CD_GARANTIAS.GT018_RATEIO_AVAL
        WHERE REF_DATE = '${REF_DATE}'
            AND TIPOLOGIA = 'PES'
        )GT018 ON CBALCAO = CKBALRES AND CNUMECTA = CKCTARES AND ZDEPOSIT = CKREFRESP
    )UNIV --6

--OBTER DT_MTRTY_PRTCTN E PRTCTN_PRVDR_ID (17/11: CAMPO JÁ EXISTENTE NO LT, DESENVOLVIMENTO DE IT NÃO CONCLUÍDO)
LEFT JOIN
    (
    SELECT DISTINCT PRTCTN_ID AS PRTCTN_ID_AUX, DT_MTRTY_PRTCTN, PRTCTN_PRVDR_ID
    FROM BU_LOANTAPE_WORK.LT004_PROTECTION
    WHERE REF_DATE = '${REF_DATE}'
        AND SEGMENTO = 'ESTR'
        AND AMBITO = 'SRB_MBDT'
        AND NOME_PERIMETRO = 'Individual Local'
        AND ENTIDADE = '00100'
    )LT004 ON PRTCTN_ID = PRTCTN_ID_AUX --UNIV 6

--OBTENÇÃO DO CAMPO "TIPOLOGIA" DA GT018_RATEIO_AVAL
LEFT JOIN
    (
    SELECT DISTINCT
        CONCAT(CKBALBEM,CKCTABEM, CKREFBEM) AS CHAVE_GARANTIA_GT018,
        TIPOLOGIA
    FROM CD_GARANTIAS.GT018_RATEIO_AVAL
    WHERE REF_DATE = '${REF_DATE}'
    )GT018 ON PRCTCN_ID_CLEAN = CHAVE_GARANTIA_GT018

-- PARTIÇÃO DA TABELA 
LEFT JOIN 
    (
    SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
    FROM BU_CAPTOOLS_WORK.SIMUL_LT004
    WHERE REF_DATE = '${REF_DATE}'
    )RT ON 1=1 
;
    
/*=========================================================================================================================================*/
/*  AUX. Criação da tabela                                                                             			                           */
/*=========================================================================================================================================*/

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.SIMUL_LT004;

INVALIDATE METADATA BU_CAPTOOLS_WORK.SIMUL_LT004;

CREATE TABLE BU_CAPTOOLS_WORK.SIMUL_LT004  
(

	DT_MTRTY_PRTCTN STRING,
    PRTCTN_ID STRING,
    PRTCTN_PRVDR_ID STRING,
    FLG_SCRD STRING
)
PARTITIONED BY (ID_CORRIDA BIGINT, REF_DATE STRING);




    
