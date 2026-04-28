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

INSERT OVERWRITE BU_ESG_WORK.AG10_TEMP_CTO_AGR PARTITION (REF_DATE)

SELECT 
    CASE 
        WHEN TRIM(UPPER(X.INSTRUMENTO_FINANCEIRO)) = 'CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS' THEN 'LOANS'  
        WHEN TRIM(UPPER(X.INSTRUMENTO_FINANCEIRO))= 'INSTRUMENTOS DE DIVIDA' THEN 'BONDS'
    END AS CONTA,	
    X.CONTRAPARTE, 
    X.TIPO_COLATERAL,
    X.GREEN_FINANCIAL_INSTRUMENT,
    X.PURPOSE_ESG,
	X.ACUTE_CHANGES,
	X.CHRONIC_CHANGES,
	X.FLAG_PHYSICAL_RISK,
    ROUND(SUM(X.AMOUNT),0) AS AMOUNT,

	--PARTICAO
	'${REF_DATE}' AS REF_DATE	
FROM 
(
    SELECT *
    FROM BU_ESG_WORK.AG10_TEMP_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}' 
)X 

GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 10
;
