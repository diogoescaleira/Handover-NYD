/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 24/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 4																		                 ****
****  ( Exposure to top 20 carbon intensive firms )                                      												 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  2. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO TEMPLATE 4                 							       */
/*=========================================================================================================================================*/


INSERT OVERWRITE BU_ESG_WORK.AG04_TEMP_CTO_AGR PARTITION (REF_DATE)
SELECT X.*,
		CASE 
			WHEN BRUTO_IMPARIDADE = 'valor bruto' AND MATURITY > 0 THEN MATURITY*AMOUNT				
			ELSE NULL
		END AS AVEG_AUX,

		-- PARTICAO
		'${REF_DATE}' AS REF_DATE
FROM
(
	SELECT
		CONTRAPARTE,
		BRUTO_IMPARIDADE,
		ROUND(YEARS_TO_MATURITY,0) AS MATURITY,
		ROUND(SUM(SUSTAINABLE_CCM),0) AS SUSTAINABLE_CCM,
		ROUND(SUM(MSALDO_FINAL),0) AS AMOUNT,
		FLAG_CSRD	
	FROM 
	(	
		SELECT * FROM BU_ESG_WORK.AG04_TEMP_CTO_GRA
		WHERE REF_DATE = '${REF_DATE}' 
	) AUX GROUP BY 1,2,3,6
) X

;
