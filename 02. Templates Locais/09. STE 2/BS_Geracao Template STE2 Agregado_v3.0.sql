/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 23/05/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 2 STE 																					 ****
****  (Banking book - Climate change transition risk: Loans collateralised by immovable property - Energy efficiency of the collateral ) ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  2. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO TEMPLATE 2 STE                         					   */
/*=========================================================================================================================================*/


INSERT OVERWRITE TABLE BU_ESG_WORK.AG02_STE_CTO_AGR PARTITION (REF_DATE)

SELECT
	TIPO_COLATERAL,
	EPC_LABEL,
	EP_SCORE,
	EUROPEAN_UNION,
	ROUND(SUM(AMOUNT),0) AS AMOUNT,
	QUALITY_SCORE,
	MATURITY_ESG,
	CASE       
		WHEN FLAG_MATURITY = 0  THEN NULL
		WHEN ROUND(SUM(AMOUNT))*ROUND(AVG(YEARS_TO_MATURITY),0) < 0 THEN 0 -- ZERAR CASOS NEGATIVOS (MATURIDADE NEGATIVA NÃO PODERÁ SER CONSIDERADA)
		ELSE ROUND(SUM(AMOUNT))*ROUND(AVG(YEARS_TO_MATURITY),0) 
	END AS AVEG_AUX,
	NEW_BUSINESS_FLOW,
	PREVIOUS_YEAR_EP_SCORE,
	PREVIOUS_YEAR_EPC_LABEL,
	FLAG_MATURITY,
	CASE
		WHEN ROUND(SUM(AMOUNT)) * ROUND(AVG(TX_JURO),2) < 0 THEN 0 -- ZERAR CASOS NEGATIVOS (CONFIRMADO PELA CORPORAÇÃO NO EMAIL DE DIA 28/01/2025)
		ELSE ROUND(SUM(AMOUNT)) * ROUND(AVG(TX_JURO),2) 
	END AS INTEREST_AUX,
	CASE
		WHEN ROUND(SUM(AMOUNT)) * ROUND(AVG(VALOR_LTV_DECIMAL),2) < 0 THEN 0 -- ZERAR CASOS NEGATIVOS
		ELSE ROUND(SUM(AMOUNT)) * ROUND(AVG(VALOR_LTV_DECIMAL),2)
	END AS LTV_AUX,
	COLLATERAL_LTV,
	SOURCE_CODE,
	
	-- PARTICAO
	'${REF_DATE}' AS REF_DATE
    
FROM (SELECT * FROM BU_ESG_WORK.AG02_STE_CTO_GRA WHERE REF_DATE = '${REF_DATE}') X

GROUP BY 1,2,3,4,6,7,9,10,11,12,15,16,17
;

