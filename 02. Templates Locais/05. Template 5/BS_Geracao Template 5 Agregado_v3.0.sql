/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 23/04/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 5 																					     ****
****  ( Banking book - Climate change physical risk: Exposures subject to physical risk  ) 												 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  2. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO TEMPLATE 5                  							       */
/*=========================================================================================================================================*/

INSERT OVERWRITE BU_ESG_WORK.AG05_TEMP_CTO_AGR PARTITION (REF_DATE)

SELECT X.*,
		CASE 
			WHEN VB_IMP = 'valor bruto' AND MATURITY > 0 THEN MATURITY*AMOUNT				
			ELSE NULL
		END AS AVEG_AUX,

		-- PARTICAO
		'${REF_DATE}' AS REF_DATE
FROM
(
	SELECT
		STAGE, 
		CONTRAPARTE,
		VB_IMP,
		TIPO_COLATERAL,
		ROUND(YEARS_TO_MATURITY,0) AS MATURITY,
		COD_NACE_ESG, 
		ACUTE_CHANGES,
		CHRONIC_CHANGES,
		FLAG_PHYSICAL_RISK,
		ROUND(SUM(AMOUNT)) AS AMOUNT		
	FROM 
	(	
		SELECT * FROM BU_ESG_WORK.AG05_TEMP_CTO_GRA
		WHERE REF_DATE = '${REF_DATE}' 
	) AUX GROUP BY 1,2,3,4,5,6,7,8,9
) X
;

