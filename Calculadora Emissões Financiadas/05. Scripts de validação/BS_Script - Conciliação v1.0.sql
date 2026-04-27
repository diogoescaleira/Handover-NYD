
/********************************************************************************************************************************************
****   Projeto: Calculadora de Emissões                                                                         						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 10/12/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Cálculo de Emissões de Real Estate				     										     ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: Obtenção do universo a reportar no âmbito da carteira de RE + Marcação de metricas relevantes             	       */
/*=========================================================================================================================================*/

	-- VALIDAÇÃO UNIVERSO 

SELECT 
    CASE 
        WHEN F1.CHAVE IS NOT NULL AND F2.CHAVE IS NOT NULL THEN 'UNIV COMUM'
        WHEN F1.CHAVE IS NOT NULL AND F2.CHAVE IS NULL THEN 'EXCLUSIVO CALCULADORA'
        WHEN F1.CHAVE IS NULL AND F2.CHAVE IS NOT NULL THEN 'EXCLUSIVO REPORTE'
    END AS VALID_UNIV,
    SUM(F1.AMOUNT) AS AMOUNT_CALCULADORA,
    SUM(F2.AMOUNT) AS AMOUNT_REPORTE,
	SUM(F1.SCOPE1) AS SCOPE1_CALCULADORA,
	SUM(F2.SCOPE1) AS SCOPE1_REPORTE,
	SUM(F1.SCOPE2) AS SCOPE2_CALCULADORA,
	SUM(F2.SCOPE2) AS SCOPE2_REPORTE,
	SUM(F1.EMI_TOTAL) AS TOTAL_EMI_CALCULADORA,
	SUM(F2.SCOPE1+F2.SCOPE2) AS SCOPE2_REPORTE,
    COUNT(*) AS NUM_REG
    
FROM 
    (
    SELECT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,SUM(-AMOUNT) AS AMOUNT,SUM(EMISS_SCP1_OP2) AS SCOPE1,SUM(EMISS_SCP2_OP2) AS SCOPE2,SUM(EMISS_OP2) AS EMI_TOTAL
    FROM BU_CAPTOOLS_WORK.CAL_EMI_GRA
    WHERE purpose_code='CRE_OUTRO'
        and contraparte='outras empresas nao financeiras'
        and FLAG_CTO_BEM='CTO_IMO'
    GROUP BY 1
    )F1
FULL JOIN 
    (
    SELECT CONCAT(CEMPRESA_CT,CBALCAO_CT,CNUMECTA_CT,ZDEPOSIT_CT) AS CHAVE,SUM(ASCI_AUX_2) AS AMOUNT,SUM(GESI_AUX_2) AS SCOPE1,SUM(GESII_AUX_2) AS SCOPE2
    FROM BU_ESG_WORK.SAT93_AGREGACAO2_DEZ24_1_V3
    WHERE CALCULATION_APPROACH_2='Real Estate'
    GROUP BY 1 
    )F2 ON F1.CHAVE=F2.CHAVE
GROUP BY 1 
;

	-- UNIVERSO - ANÁLISE #1 
	
	-- Maior difença: 185 Eur 
		-- Reporte Dez24: 12 381 275.50 (12381461.41 na coluna do contrato)
		-- Tático Calculadora: 12 381 461.41

SELECT AMOUNT,ASCI_AUX_2
FROM BU_ESG_WORK.SAT93_AGREGACAO2_DEZ24_1_V3
WHERE CONCAT(CEMPRESA_CT,CBALCAO_CT,CNUMECTA_CT,ZDEPOSIT_CT)='31000801473204096000000000000000'
;

	-- UNIVERSO - ANÁLISE #2 EXCLUSIVOS REPORTE DEZ24 
	
SELECT *
from bu_esg_work.sat93_agregacao2_dez24_1_v3
where CONCAT(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) in 
    (
    SELECT f1.chave 
    FROM 
        (
        SELECT CONCAT(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,sum(-amount) as amount
        FROM BU_CAPTOOLS_WORK.CAL_EMI_GRA
        WHERE purpose_code='CRE_OUTRO'
            and contraparte='outras empresas nao financeiras'
            and FLAG_CTO_BEM='CTO_IMO'
        GROUP BY 1
        )F1
    FULL JOIN 
        (
        SELECT CONCAT(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) AS CHAVE,sum(asci_aux_2) as amount  
        from bu_esg_work.sat93_agregacao2_dez24_1_v3
        where calculation_approach_2='Real Estate'
        GROUP BY 1 
        )F2 ON F1.CHAVE=F2.CHAVE
    WHERE F1.CHAVE IS NOT NULL AND F2.CHAVE IS NULL
    )
;

SELECT *,
	ABS(F2.SCOPE1+F2.SCOPE2-F1.EMI_TOTAL) AS DIFF
    
FROM 
    (
    SELECT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE,SUM(-AMOUNT) AS AMOUNT,SUM(EMISS_SCP1_OP2) AS SCOPE1,SUM(EMISS_SCP2_OP2) AS SCOPE2,SUM(EMISS_OP2) AS EMI_TOTAL
    FROM BU_CAPTOOLS_WORK.CAL_EMI_GRA
    WHERE purpose_code='CRE_OUTRO'
        and contraparte='outras empresas nao financeiras'
        and FLAG_CTO_BEM='CTO_IMO'
    GROUP BY 1
    )F1
INNER JOIN 
    (
    SELECT CONCAT(CEMPRESA_CT,CBALCAO_CT,CNUMECTA_CT,ZDEPOSIT_CT) AS CHAVE,SUM(ASCI_AUX_2) AS AMOUNT,SUM(GESI_AUX_2) AS SCOPE1,SUM(GESII_AUX_2) AS SCOPE2
    FROM BU_ESG_WORK.SAT93_AGREGACAO2_DEZ24_1_V3
    WHERE CALCULATION_APPROACH_2='Real Estate'
    GROUP BY 1 
    )F2 ON F1.CHAVE=F2.CHAVE
ORDER BY ABS(F2.SCOPE1+F2.SCOPE2-EMI_TOTAL) DESC	
	
	
	
	