/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 17/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 93  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO SATÉLITE 93                							       */
/*=========================================================================================================================================*/

INSERT OVERWRITE TABLE BU_ESG_WORK.AG093_GHGE_CTO_AGR PARTITION (REF_DATE)

SELECT
    A.INFORMING_SOC, 
    A.COUNTERPARTY_SOC, 
    A.ADJUSTMENT_CODE, 
    A.COMB_CODE, 
    A.EU, 
    A.CNAEL, 
    A.NACE_ESG AS NACE,
    ROUND(SUM(ASCI),0) AS ASCI, 
    ROUND(SUM(GESI),0) AS GESI, 
    ROUND(SUM(ASC2),0) AS ASC2, 
    ROUND(SUM(GESII),0) AS GESII, 
    ROUND(SUM(ASCIII),0) AS ASCIII, 
    ROUND(SUM(GESIII),0) AS GESIII,
	'${REF_DATE}' AS REF_DATE    
FROM 
    (
    SELECT
            '00411' AS INFORMING_SOC,
            CASE WHEN SOCIEDADE_CONTRAPARTE = '' THEN '00000' ELSE SOCIEDADE_CONTRAPARTE END AS COUNTERPARTY_SOC,
            'BI00411' AS ADJUSTMENT_CODE,
    		
            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC08%' THEN CONCAT(IDCOMB_SATELITE,';',INVESTMENT_SECTOR,';',CLIENT_EMISSION_AREA,';',CALCULATION_APPROACH,';',SOURCE_EMISSION,';',DATA_QUALITY_SCORE)
                ELSE CONCAT(IDCOMB_SATELITE,';',CLIENT_EMISSION_AREA,';',CALCULATION_APPROACH,';',SOURCE_EMISSION,';',DATA_QUALITY_SCORE)
            END AS COMB_CODE,
    		EUROPEAN_UNION AS EU,
            CNAEL,
            NACE_ESG,
            CASE WHEN ASCI IS NULL THEN 0 ELSE ASCI END AS ASCI,        
    		CASE 
                WHEN GESI IS NULL AND SOURCE_EMISSION = 'SOUR3' THEN NULL
                WHEN GESI IS NULL AND SOURCE_EMISSION <> 'SOUR3' THEN 0.00
                WHEN ASCI < 0 THEN 0.00
                ELSE GESI 
            END AS GESI,
    		CASE WHEN ASC2 IS NULL THEN 0 ELSE ASC2 END AS ASC2,
    		CASE 
                WHEN GESII IS NULL AND SOURCE_EMISSION = 'SOUR3' THEN NULL
                WHEN GESII IS NULL AND SOURCE_EMISSION <> 'SOUR3' THEN 0.00
                WHEN ASC2 < 0 OR GESII < 0 THEN 0.00
                ELSE GESII 
            END AS GESII,
    		CASE WHEN ASCIII IS NULL THEN 0 ELSE ASCIII END AS ASCIII, 
    		CASE 
                WHEN GESIII IS NULL AND SOURCE_EMISSION = 'SOUR3' THEN NULL
                WHEN GESIII IS NULL AND SOURCE_EMISSION <> 'SOUR3' THEN 0.00
                WHEN ASCIII < 0 THEN 0.00
                ELSE GESIII 
            END AS GESIII
    FROM BU_ESG_WORK.AG093_GHGE_CTO_GRA
	WHERE REF_DATE='${REF_DATE}'
    ) A

    GROUP BY 1,2,3,4,5,6,7,14
	HAVING ASCI <> 0
;