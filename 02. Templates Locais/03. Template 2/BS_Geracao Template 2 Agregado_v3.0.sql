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


INSERT OVERWRITE TABLE BU_ESG_WORK.AG02_TEMP_CTO_AGR PARTITION (REF_DATE)

SELECT
        TIPO_COLATERAL,
        EPC_LABEL,
        EP_SCORE,
        EUROPEAN_UNION,
        ROUND(SUM(AMOUNT),0) AS AMOUNT,
        QUALITY_SCORE,
        SOURCE_CODE,
		
		-- PARTICAO
		'${REF_DATE}' AS REF_DATE
	
FROM BU_ESG_WORK.AG02_TEMP_CTO_GRA 
WHERE REF_DATE = '${REF_DATE}' 

GROUP BY 1,2,3,4,6,7,8
;



