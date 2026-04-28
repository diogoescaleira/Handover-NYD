/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 30/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 10																		                 ****
****  ( Other climate change mitigating actions that are not covered in the EU Taxonomy )               								 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  2. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO TEMPLATE 10                 							       */
/*=========================================================================================================================================*/


-- INSERT OVERWRITE BU_ESG_WORK.AG10_TEMP_CTO_AGR PARTITION (ID_CORRIDA,REF_DATE)
SELECT 
    CASE 
        WHEN TRIM(UPPER(X.INSTRUMENTO_FINANCEIRO)) = 'CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS' THEN 'LOANS'  
        WHEN TRIM(UPPER(X.INSTRUMENTO_FINANCEIRO))= 'INSTRUMENTOS DE DIVIDA' THEN 'BONDS'
    END AS CONTA,	
    X.CONTRAPARTE, 
    X.TIPO_COLATERAL,
    X.GREEN_FINANCIAL_INSTRUMENT,
    X.PURPOSE_ESG,
    ROUND(SUM(X.AMOUNT),0) AS AMOUNT,

	--PARTICAO
	RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	'${REF_DATE}' AS REF_DATE	
FROM 
(
    SELECT *
    FROM BU_ESG_WORK.AG10_TEMP_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}' 
				AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.AG10_TEMP_CTO_GRA WHERE REF_DATE = '${REF_DATE}')
)X 

LEFT JOIN
    
(
SELECT 
	NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
FROM BU_ESG_WORK.AG10_TEMP_CTO_AGR
WHERE REF_DATE = '${REF_DATE}'
) RT

ON 1=1

GROUP BY 1, 2, 3, 4, 5, 7, 8
;
