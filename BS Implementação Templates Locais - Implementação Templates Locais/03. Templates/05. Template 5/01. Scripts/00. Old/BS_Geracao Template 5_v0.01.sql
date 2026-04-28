/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 23/04/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 5 																					     ****
****  ( Banking book - Climate change physical risk: Exposures subject to physical risk  ) 												 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: Obtenção do universo a reportar no âmbito do Template 5 + Marcação de metricas relevantes             			   */
/*=========================================================================================================================================*/
       
-- REGISTOS:  | MONTANTE: 	   --
-- INSERT OVERWRITE TABLE BU_ESG_WORK.AG05_TEMP_CTO_GRA (ID_CORRIDA,REF_DATE)
CREATE TABLE BU_ESG_WORK.AG05_TEMP_CTO_GRA AS
SELECT
    UNI.ZCLIENTE, 
    UNI.COD_AJUST, 
    UNI.SOCIEDADE_CONTRAPARTE,
    UNI.CEMPRESA,
    UNI.CBALCAO,
    UNI.CNUMECTA,
    UNI.ZDEPOSIT,
    SUM(UNI.MSALDO_FINAL) AS MSALDO_FINAL,
    UNI.BRUTO_IMPARIDADE AS VB_IMP, 
    UNI.STAGES AS STAGE, 
    UNI.CONTRAPARTE, 
    CASE
        WHEN INSTRUMENTO_FINANCEIRO = 'instrumentos de capital' THEN -3 -- 'INSTRUMENTOS DE CAPITAL' : > 20 ANOS
        WHEN DATA_VENCIMENTO  IN ('','0001-01-01','9999-12-31',NULL) THEN -2 -- FALTA DE DATA QUALITY DE DADOS
        WHEN UPPER(PRODUTO) LIKE 'CART%CR%DITO%' OR UPPER(PRODUTO) LIKE '%REPOS%'  OR UPPER(PRODUTO) LIKE '%VISTA, DESCOBERTOS E CO%' THEN -1 -- 'COUNTERPARTY HAVING THE CHOICE OF THE REPAYMENT DATE'
        WHEN DATA_VENCIMENTO  < '${REF_DATE}' THEN -4 --'OLD CONTRACTS' 
        ELSE ROUND(DATEDIFF(TO_DATE(DATA_VENCIMENTO), TO_DATE('${REF_DATE}'))/365.25, 4)
    END AS YEARS_TO_MATURITY, 
	SUBSTR(NFIN.COD_NACE_ESG,1,1) AS COD_NACE_ESG,
    CPAIS_RESIDENCIA,
    TIPO_COLATERAL,
    ACUTE_CHANGES,    
	CHRONIC_CHANGES
	
FROM 
-- TABELA DE UNIVERSO
(
	SELECT * 
	FROM BU_ESG_WORK.P3_FULL_CTR_CLI_LOCAL_DEZ24_V4 
	WHERE TEMPLATE5 = 1 AND
		  DT_RFRNC = '${REF_DATE}'
)UNI

-- OBTENÇÃO DE CARACTERISTICAS DE CONTRATOS (EX. CÓDIGO NACE)
LEFT JOIN (SELECT * FROM BU_ESG_WORK.MODESG_OUT_EMPR_INFO_NFIN WHERE REF_DATE='${REF_DATE}') NFIN
ON UNI.ZCLIENTE = NFIN.ZCLIENTE

LEFT JOIN 
--- TABELA DE MARCAÇÃO DE RISCO FÍSICO AO NÍVEL DO CONTRATO
(
	SELECT 
		A.CEMPRESA,
		A.CBALCAO,
		A.CNUMECTA,
		A.ZDEPOSIT,
		CASE WHEN SUM(FLG_ACT_PHYSCL_RSK_ENTTY + FLG_ACT_PHYSCL_RSK_PRTCTN) > 0 THEN 'ACUT1' ELSE 'ACUT2' END AS ACUTE_CHANGES,
		CASE WHEN SUM(FLG_CHRNC_PHYSCL_RSK_ENTTY + FLG_CHRNC_PHYSCL_RSK_PRTCTN) > 0 THEN 'CHRO1' ELSE 'CHRO2' END AS CHRONIC_CHANGES
	FROM 
	(
		SELECT * 
		FROM BU_ESG_WORK.P3_FULL_CTR_CLI_LOCAL_DEZ24_V4 
		WHERE   TEMPLATE5 = 1 AND
				DT_RFRNC = '${REF_DATE}'
	) AS A

	LEFT JOIN 
	(
		SELECT *
		FROM BU_ESG_WORK.P3_REPARTICAO_GARANTIAS_LOCAL
		WHERE DT_RFRNC='${REF_DATE}' AND 
		      ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.P3_REPARTICAO_GARANTIAS_LOCAL WHERE DT_RFRNC = '${REF_DATE}') 
	)AS B
	ON  A.CEMPRESA = B.CEMPRESA AND 
		A.CBALCAO  = B.CBALCAO AND 
		A.CNUMECTA = B.CNUMECTA AND 
		A.ZDEPOSIT = B.ZDEPOSIT

	LEFT JOIN 
	-- OBTENÇÃO DO RISCO AO NÍVEL DO CLIENTE
	(
		SELECT *, FLG_RSC_FSC_AGD AS FLG_ACT_PHYSCL_RSK_ENTTY, FLG_RSC_FSC_CRNC AS FLG_CHRNC_PHYSCL_RSK_ENTTY  
		FROM BU_ESG_WORK.MODESG_OUT_EMPR_INFO_NFIN 
		WHERE REF_DATE='${REF_DATE}'
	) NFIN
	ON B.ZCLIENTE = NFIN.ZCLIENTE  

	LEFT JOIN 
	-- OBTENÇÃO DO RISCO AO NÍVEL DO COLATERAL IMÓVEL
	(
		SELECT *, FLG_RSC_FSC_AGD AS FLG_ACT_PHYSCL_RSK_PRTCTN, FLG_RSC_FSC_CRNC AS FLG_CHRNC_PHYSCL_RSK_PRTCTN  
		FROM BU_ESG_WORK.MODESG_OUT_BENS_IMOVEIS 
		WHERE REF_DATE='${REF_DATE}'
	) MODESG_OUT_BENS_IMOVEIS
	ON 
		-- 	MODESG_OUT_BENS_IMOVEIS.CEMPBEM = B.CEMPBEM AND
		MODESG_OUT_BENS_IMOVEIS.CKBALBEM =	B.CKBALBEM AND
		MODESG_OUT_BENS_IMOVEIS.CKCTABEM = B.CKCTABEM AND
		MODESG_OUT_BENS_IMOVEIS.CKREFBEM = B.CKREFBEM
	GROUP BY 1,2,3,4
) RS_FISICO
ON  UNI.CEMPRESA = RS_FISICO.CEMPRESA AND 
	UNI.CBALCAO  = RS_FISICO.CBALCAO AND 
	UNI.CNUMECTA = RS_FISICO.CNUMECTA AND 
	UNI.ZDEPOSIT = RS_FISICO.ZDEPOSIT
GROUP BY 1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17
;

/*=========================================================================================================================================*/
/*  2. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO TEMPLATE 5                  							       */
/*=========================================================================================================================================*/

-- INSERT OVERWRITE BU_ESG_WORK.AG05_TEMP_CTO_AGR (ID_CORRIDA,REF_DATE)
SELECT *,
		CASE 
			WHEN VB_IMP = 'valor bruto' AND MATURITY > 0 THEN MATURITY*AMOUNT				
			ELSE NULL
		END AS AVEG_AUX
FROM
(
	SELECT
		STAGE, 
		CONTRAPARTE,
		VB_IMP,
		TIPO_COLATERAL,
		ROUND(YEARS_TO_MATURITY,0) AS MATURITY,
		COD_NACE_ESG, 
		ACUTE_CHANGES,
		CHRONIC_CHANGES,
		ROUND(-SUM(MSALDO_FINAL)) AS AMOUNT		
	FROM BU_ESG_WORK.AG05_TEMP_CTO_GRA
	GROUP BY 1,2,3,4,5,6,7,8
)X
;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                                                        Adjudicados                                                                                    --
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--drop table bu_esg_work.local_pilar3_temp5_dez24_adj_1;
--create table bu_esg_work.local_pilar3_temp5_dez24_adj_1 as
--
--SELECT adj.*, 
--    CASE
--		when PR_CP2.rs_acute = 'Yes' then 'ACUT1'
--        WHEN coalesce(prhipotec1.rs_acute, prhipotec2.rs_acute) = 'Yes' THEN 'ACUT1'
--        ELSE 'ACUT2'
--    END AS acute_changes,
--    CASE
--		when PR_CP2.rs_chronic = 'Yes' then 'CHRO1'
--        WHEN coalesce(prhipotec1.rs_chronic, prhipotec2.rs_chronic) = 'Yes' THEN 'CHRO1'
--        ELSE 'CHRO2'
--    END AS chronic_changes
--
--FROM 
--
--(select * 
--from bu_esg_work.adjudicados_dez24_final
--where tipo_adjudicado <> 'Dações+Arrematações' and (cargabal_vc in ('1605000', '1605010') OR cargabal_prov = '2642300')) AS adj									

;																

--REGISTOS:80
--REGISTOS:78 dez24 
-- 7º Passo: Criação da tabela final com flag vb_imp
--drop table bu_esg_work.local_pilar3_temp5_dez24_adj_2;
--create table bu_esg_work.local_pilar3_temp5_dez24_adj_2 as
--
--SELECT 
--    cargabal_vc AS conta,
--    tipo_adjudicado,
--    'valor bruto' AS vb_imp,
--    round(sum(valor_cargabal_vc)) AS amount,
--    acute_changes,
--    chronic_changes,
--    4_collateral_nuts										
--FROM bu_esg_work.local_pilar3_temp5_dez24_adj_1
--GROUP BY 1, 2, 3, 5, 6, 7
--
--union all
--
--SELECT 
--    cargabal_prov AS conta,
--    tipo_adjudicado,
--    'imparidade' AS vb_imp,
--    round(sum(-1*valor_cargabal_prov)) AS amount,
--    acute_changes,
--    chronic_changes,
--    4_collateral_nuts										
--FROM bu_esg_work.local_pilar3_temp5_dez24_adj_1
--GROUP BY 1, 2, 3, 5, 6, 7;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                                                          Tabela Final                                                                                 --
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DROP TABLE bu_esg_work.local_pilar3_temp5_final_dez24;
--CREATE TABLE bu_esg_work.local_pilar3_temp5_final_dez24 AS								
--SELECT
--    '' AS stage,
--    '' AS contraparte,
--    vb_imp,
--    'Stock' AS tipo_colateral, 
--    -5 AS maturity,																		
--    '' AS nace_esg,
--    '' AS non_performing,
--    acute_changes,
--    chronic_changes,
--    amount,
--    4_collateral_nuts As nuts,
--    0 AS aveg_aux,
--    CASE
--        WHEN acute_changes = 'ACUT1' OR chronic_changes = 'CHRO1' THEN 1
--        ELSE 0
--    END AS flag_physical_risk
--FROM bu_esg_work.local_pilar3_temp5_dez24_adj_2
--
--union all
--
--SELECT *,
--    CASE 
--        WHEN vb_imp = 'valor bruto' AND maturity > 0 THEN maturity*amount				
--        ELSE NULL
--    END AS aveg_aux,
--    CASE
--        WHEN acute_changes = 'ACUT1' OR chronic_changes = 'CHRO1' THEN 1
--        ELSE 0
--    END AS flag_physical_risk
--FROM bu_esg_work.local_pilar3_temp5_dez24_aux4
--