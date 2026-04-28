/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: Bs & Neyond                                                                                                                ****
****   Data: 29/04/2025                                                                                                                  ****
****   Sql Script Descrição: Geração Do Satélite 80  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela final: obtenção das métricas agregadas a reportar no âmbito do satélite 80                							       */
/*=========================================================================================================================================*/


-- INSERT OVERWRITE TABLE BU_ESG_WORK.AG080_ENPC_CTO_AGR PARTITION (ID_CORRIDA,REF_DATE)

SELECT
	A.*,
	RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	'${REF_DATE}' AS REF_DATE
FROM 
	(
	SELECT
		'00411' AS INFORMING_SOC,
		CASE 
			WHEN SOCIEDADE_CONTRAPARTE = '' THEN '00000'
			ELSE SOCIEDADE_CONTRAPARTE
		END AS COUNTERPARTY_SOC,
		'BI00411' AS ADJUSTMENT_CODE,
		CONCAT(IDCOMB_SATELITE,';',EP_SCORE_DATA,';',EP_SCORE,';',EP_LABEL_DATA,';',EPC_LABEL) AS COMB_CODE,
		ROUND(SUM(AMOUNT),0) AS AMOUNT,
		EUROPEAN_UNION AS EU 
	FROM BU_ESG_WORK.AG080_ENPC_CTO_GRA
	WHERE ID_CORRIDA IN (	SELECT
								MAX(ID_CORRIDA)
							FROM BU_ESG_WORK.AG080_ENPC_CTO_GRA
							WHERE REF_DATE = '${REF_DATE}'
						)
	GROUP BY 1,2,3,4,6
	) A

	LEFT JOIN

	(
    SELECT 
        NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
    FROM BU_ESG_WORK.AG080_ENPC_CTO_AGR
    WHERE REF_DATE = '${REF_DATE}'
    ) RT

    ON 1=1
;