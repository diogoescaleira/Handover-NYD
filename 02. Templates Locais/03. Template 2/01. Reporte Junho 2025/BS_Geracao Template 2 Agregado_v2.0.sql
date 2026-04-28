/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 29/04/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 2  																					 ****
****  (Banking book - Climate change transition risk: Loans collateralised by immovable property - Energy efficiency of the collateral ) ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  2. Tabela final: obtenção das métricas agregadas a reportar no âmbito do Template 2                  							       */
/*=========================================================================================================================================*/


-- INSERT OVERWRITE TABLE BU_ESG_WORK.AG02_TEMP_CTO_AGR PARTITION (ID_CORRIDA,REF_DATE)
SELECT
        TIPO_COLATERAL,
        EPC_LABEL,
        EP_SCORE,
        EUROPEAN_UNION,
        ROUND(SUM(AMOUNT),0) AS AMOUNT,
        QUALITY_SCORE,
        SOURCE_CODE,
		
		-- PARTICAO
		RT.NEW_ID_CORRIDA AS ID_CORRIDA,
		'${REF_DATE}' AS REF_DATE
	
FROM (SELECT * FROM BU_ESG_WORK.AG02_TEMP_CTO_GRA WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.AG02_TEMP_CTO_GRA WHERE REF_DATE = '${REF_DATE}'))X
LEFT JOIN
(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_ESG_WORK.AG02_TEMP_CTO_AGR
	WHERE REF_DATE = '${REF_DATE}'
) RT
ON 1=1
GROUP BY 1,2,3,4,6,7,8,9
;



