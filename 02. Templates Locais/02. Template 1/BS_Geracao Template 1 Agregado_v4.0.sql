/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 28/05/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 1																					     ****
****  ( Banking book - Climate change transition risk: Quality of exposures by sector ) 												 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO TEMPLATE 1                  							       */
/*=========================================================================================================================================*/

INSERT OVERWRITE BU_ESG_WORK.AG01_TEMP_CTO_AGR PARTITION (REF_DATE)

SELECT  X.STAGE,
        X.CONTRAPARTE,
        X.VB_IMP,
        X.EXCLUDED_PARIS,
        X.MATURITY,
        X.COD_NACE_ESG,
        X.ASCI,
        X.GESI,
        X.ASC2,
        X.GESII,
        X.ASCIII,
        X.GESIII,
        X.FLAG_CSRD,
        X.SUSTAINABLE_CCM,
		CASE 
			WHEN VB_IMP = 'valor bruto' AND MATURITY > 0 THEN MATURITY*ASCI				
			ELSE NULL
		END AS AVEG_AUX,
		SOURCE_EMISSION_1,
        SOURCE_EMISSION_2,
        SOURCE_EMISSION_3,

		-- PARTICAO
		'${REF_DATE}' AS REF_DATE
FROM
(
	SELECT
		STAGE,
        CONTRAPARTE,
        VB_IMP,
        EXCLUDED_PARIS,
        ROUND(YEARS_TO_MATURITY,0) AS MATURITY,
        COD_NACE_ESG,
        ROUND(SUM(ASCI),2) AS ASCI,
        ROUND(SUM(GESI),2) AS GESI,
        ROUND(SUM(ASC2),2) AS ASC2,
        ROUND(SUM(GESII),2) AS GESII,
        ROUND(SUM(ASCIII),2) AS ASCIII,
        ROUND(SUM(GESIII),2) AS GESIII,
        FLAG_CSRD,
        ROUND(SUM(SUSTAINABLE_CCM),2) AS SUSTAINABLE_CCM,
        SOURCE_EMISSION_1,
        SOURCE_EMISSION_2,
        SOURCE_EMISSION_3
        
	FROM 
	(	
		SELECT * FROM BU_ESG_WORK.AG01_TEMP_CTO_GRA
		WHERE REF_DATE = '${REF_DATE}' 
	) AUX  GROUP BY 1,2,3,4,5,6,13,15,16,17
) X ;