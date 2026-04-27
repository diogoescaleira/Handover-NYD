/*******************************************************************************************************************************************
****   Projeto: Certificação Bail-In                                                                          						    ****
****   Autor: Neyond                                                                                                                    ****
****   Data: 18/11/2025                                                                                                                 ****
****   SQL Script Descrição: Simulação da Tabela B0500       																		    ****
********************************************************************************************************************************************

/*=========================================================================================================================================*/
/*  1. TABELA GRANULAR: SIMULAÇÃO DA TABELA B0500                                                                            			   */
/*=========================================================================================================================================*/

INSERT OVERWRITE TABLE BU_CAPTOOLS_WORK.SIMUL_B0500 PARTITION (ID_CORRIDA,REF_DATE)


SELECT 
    
    CAST(ROW_NUMBER() OVER (ORDER BY `0020_UNIQ_ID_GUARANTEE`) AS INT) AS `0010_ROW_NUMBER` 
    
    ,*
    
FROM (

    SELECT

    `0020_UNIQ_ID_GUARANTEE`,
    
    'PT' AS `0030_GOVERNING_LAW`, -- CAMPO DE VALOR FIXO (VERIFICAR COMENTÁRIOS DA ESPECIFICAÇÃO - NECESSÁRIO DESENVOLVIMENTO ESTUTURAL)
    
    'FALSE' AS `0040_FLG_ART12G_3_SRMR`, -- CAMPO DE VALOR FIXO
    
    'Counterparty' AS `0050_TYP_GUARANTEE`, -- CAMPO DE VALOR FIXO
    
    CAST(`0060_MAX_AMNT_GUARANTEE` AS DECIMAL(21,2)) AS `0060_MAX_AMNT_GUARANTEE`,
    
    `0070_FLG_SCRD`,
    
    999999999999999 AS `0080_AMNT_CLLTRL`, -- VERIFICAR VALOR N/A

    'Default' AS `0090_GUARANTEE_TRGGR`,
    
    DT_MTRTY_PRTCTN AS `0100_DT_MTRTY_CLLTR`,
    
    'Not applicable' AS `0110_SCRTS_CLLTRL_ID`,
    
    'Not applicable' AS `0120_TYP_CLLTRLZTN`,
    
    'Not applicable' AS `0130_TYP_PRTCTN_VL`,
    
    '0001-01-01' AS `0140_DT_VLTN_SCRTY`,
    
    'Not applicable' AS `0150_PRTCTN_VLTN_APPRCH`,
    
    RT.NEW_ID_CORRIDA AS ID_CORRIDA,
    
    '${REF_DATE}' AS REF_DATE
    
FROM

--CAMPOS DA LT006 (INCLUINDO UNIVERSO)
    (
    SELECT DISTINCT 
        INSTRMNT_ID, 
        PRTCTN_ID, 
        CONCAT(INSTRMNT_ID,PRTCTN_ID) AS 0020_UNIQ_ID_GUARANTEE, 
        PRTCTN_ALLCTD_VL AS 0060_MAX_AMNT_GUARANTEE
    FROM BU_CAPTOOLS_WORK.simul_lt006_instr_prot
    WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.simul_lt006_instr_prot WHERE REF_DATE ='${REF_DATE}')
    )LT006
LEFT JOIN

--CAMPOS DA LT004
    (
    SELECT 
        PRTCTN_ID,
        FLG_SCRD AS 0070_FLG_SCRD,
        DT_MTRTY_PRTCTN,
        PRTCTN_PRVDR_ID
    FROM BU_CAPTOOLS_WORK.SIMUL_LT004
    WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.SIMUL_LT004 WHERE REF_DATE ='${REF_DATE}')
    )LT004 ON LT004.PRTCTN_ID = LT006.PRTCTN_ID

--REMOÇÃO DAS GARANTIAS ASSOCIADAS AOS CLIENTES QUE NÃO SÃO INTRAGRUPO SANTANDER
INNER JOIN
    (
    SELECT *
    FROM cd_captools.clientes_intragrupo
    WHERE data_date_part = '${REF_DATE}'
    ) intragrupo ON lt004.prtctn_prvdr_id = intragrupo.zcliente

INNER JOIN
    (
    SELECT *
    FROM cd_captools.perimetro
    WHERE espanha_ifrs IN ('x', 'B')
        AND cod_soc_cpus <> '00100'
        AND data_date_part = '${REF_DATE}'
    ) perimetro ON intragrupo.consoles = perimetro.cod_espana

--PARTIÇÃO TEMPORAL
LEFT JOIN
	(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_CAPTOOLS_WORK.simul_B0500
	WHERE REF_DATE = '${REF_DATE}'
	)RT 
	ON 1=1 

)FINAL
;

/*=========================================================================================================================================*/
/*  AUX. Criação da tabela                                                                             			                           */
/*=========================================================================================================================================*/

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.SIMUL_B0500;

CREATE TABLE BU_CAPTOOLS_WORK.SIMUL_B0500  
(
	0010_ROW_NMBR INT,
	0020_UNIQ_ID_GUARANTEE STRING,
	0030_GOVERNING_LAW STRING,
	0040_FLG_ART12G_3_SRMR STRING,
	0050_TYP_GUARANTEE STRING,
	0060_MAX_AMNT_GUARANTEE DECIMAL(21,2),
	0070_FLG_SCRD STRING,
	0080_AMNT_CLLTRL DECIMAL(21,2),
	0090_GUARANTEE_TRGGR STRING,
	0100_DT_MTRTY_CLLTRL STRING,
	0110_SCRTS_CLLTRL_ID STRING,
	0120_TYP_CLLTRLZTN STRING,
	0130_TYP_PRTCTN_VL STRING,
	0140_DT_VLTN_SCRTY STRING,
	0150_PRTCTN_VLTN_APPRCH STRING
	
)
PARTITIONED BY (ID_CORRIDA BIGINT, REF_DATE STRING);
