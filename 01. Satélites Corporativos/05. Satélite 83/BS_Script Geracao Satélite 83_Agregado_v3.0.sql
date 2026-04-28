/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 27/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 83  																					 ****
********************************************************************************************************************************************/


/*=========================================================================================================================================*/
/*  1. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO SATÉLITE 83                							       */
/*=========================================================================================================================================*/

INSERT OVERWRITE BU_ESG_WORK.AG83_MITI_CTO_AGR PARTITION (REF_DATE)

SELECT 
	INFORMING_SOC,
	COUNTERPARTY_SOC, 
	ADJUSTMENT_CODE,
    CASE
    	WHEN COMB_CODE LIKE '%MC04%COLL4%' THEN REPLACE(COMB_CODE,'COLL4','COLL1')
    	WHEN COMB_CODE LIKE '%MC02%SC02%COLL3%' THEN REPLACE(COMB_CODE,'COLL3','COLL1')
    	ELSE COMB_CODE
    END AS COMB_CODE,
	ROUND(SUM(AMOUNT),0) AS AMOUNT,
	DCON,

	'${REF_DATE}' AS REF_DATE

FROM
(
	SELECT 
		'00411' AS INFORMING_SOC,
		CASE 
			WHEN SOCIEDADE_CONTRAPARTE = '' OR SOCIEDADE_CONTRAPARTE ='01278' THEN '00000'
			ELSE SOCIEDADE_CONTRAPARTE
		END AS COUNTERPARTY_SOC,
		'BI00411' AS ADJUSTMENT_CODE,	
		CASE
			WHEN GREEN_FINANCIAL_INSTRUMENT = 'GFI2' THEN CONCAT(IDCOMB_SATELITE,';',GREEN_FINANCIAL_INSTRUMENT)
			ELSE CONCAT(IDCOMB_SATELITE,';',PURPOSE_ESG,';',GREEN_FINANCIAL_INSTRUMENT,';',FUNDING_TYPE,';',RISK_MITIGATED_CCT,';',RISK_MITIGATED_CCP)
		END AS COMB_CODE,
		SUM(AMOUNT) AS AMOUNT,
		DCON
	FROM BU_ESG_WORK.AG83_MITI_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}' 
	GROUP BY 1,2,3,4,6
) X

GROUP BY 1,2,3,4,6,7
HAVING AMOUNT <> 0
;