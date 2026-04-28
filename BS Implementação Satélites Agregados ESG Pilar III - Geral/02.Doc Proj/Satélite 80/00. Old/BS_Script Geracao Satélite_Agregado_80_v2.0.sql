/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: Bs & Neyond                                                                                                                ****
****   Data: 29/04/2025                                                                                                                  ****
****   Sql Script Descrição: Geração Do Satélite 80  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela final: obtenção das métricas agregadas a reportar no âmbito do satélite 80                							       */
/*=========================================================================================================================================*/

-- DROP TABLE BU_ESG_WORK.AG080_ENPC_CTO_AGR;
-- CREATE TABLE BU_ESG_WORK.AG080_ENPC_CTO_AGR AS
SELECT
    '00411' AS REPORTING_SOC,
	CASE 
		WHEN SOCIEDADE_CONTRAPARTE = '' THEN '00000'
		ELSE SOCIEDADE_CONTRAPARTE
	END AS COUNTERPARTY_SOC,
	'BI00411' AS ADJUSTMENT_CODE,
	CONCAT(IDCOMB_SATELITE,';',EP_SCORE_DATA,';',EP_SCORE,';',EP_LABEL_DATA,';',EPC_LABEL) AS COMB_CODE,
	ROUND(SUM(AMOUNT),0) AS AMOUNT,
	-- EP_SCORE_DATA,
    -- EP_SCORE,
    -- EP_LABEL_DATA,
    -- EPC_LABEL,
    EUROPEAN_UNION AS EU 
FROM BU_ESG_WORK.AG080_ENPC_CTO_GRA
GROUP BY 1,2,3,4,6
;