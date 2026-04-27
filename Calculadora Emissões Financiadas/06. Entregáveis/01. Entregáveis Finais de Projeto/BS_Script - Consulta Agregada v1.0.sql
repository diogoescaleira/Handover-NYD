
/********************************************************************************************************************************************
****   Projeto: Convergência de Calculadora de Emissões Financiadas                                                              	     ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 12/01/2026                                                                                                                  ****
****   SQL Script Descrição: Query de Consulta de Dados Agregados 			                    								         ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  QUERY DE CONSULTA DE DADOS AGREGADOS                                                                                                   */
/*=========================================================================================================================================*/

SELECT 
    UNIV.CRE_RRE,
    CASE
		WHEN UNIV.CEMPBEM IS NOT NULL AND UNIV.CKBALBEM IS NOT NULL AND UNIV.CKCTABEM IS NOT NULL AND UNIV.CKREFBEM IS NOT NULL AND (TRIM(FINALIDADE_BEM)='' OR FINALIDADE_BEM IS NULL) THEN 'Sem informação'
		ELSE TRIM(FINALIDADE_BEM)
	END AS FINALIDADE_BEM,
    TRIM(UPPER(EPC.EPC)) AS EPC,
    CASE 
        WHEN EPC.PROPERTY_BRANCH_CODE IS NOT NULL AND TRIM(QUALITY_SCORE) IN ('1-REAL', 'SANTANDER') THEN 'Certificado Real'
        WHEN EPC.PROPERTY_BRANCH_CODE IS NOT NULL AND (TRIM(EPC)='' OR EPC IS NULL) THEN 'Sem Certificado'
        WHEN EPC.PROPERTY_BRANCH_CODE IS NOT NULL THEN 'Certificado Estimado' 
    END AS TIPOLOGIA_CERTIFICADO,
    SUM(AREA_PONDERADA) AS AREA_PONDERADA,
    ORIGEM_SCP1_EMSS,
    ORIGEM_SCP2_EMSS,
    SUM(SCP1_EMSS_FNCD) AS EMISSAO_SCP1,
    SUM(SCP2_EMSS_FNCD) AS EMISSAO_SCP2,
    SUM(SCP1_EMSS_FNCD+SCP2_EMSS_FNCD) AS EMISSAO,
    CASE 
        WHEN UNIV.CEMPBEM IS NOT NULL AND UNIV.CKBALBEM IS NOT NULL AND UNIV.CKCTABEM IS NOT NULL AND UNIV.CKREFBEM IS NOT NULL THEN 'Montante Colaterizado'
        ELSE 'Montante Não Colaterizado'
    END AS TIPOLOGIA_MONTANTE,
    SUM(-AMOUNT) AS AMOUNT,
	'${REF_DATE}' AS REF_DATE

FROM 
-- OBTER OS DADOS DA TABELA DE EMISSÕES FINANCIADAS POR IMÓVEL (REAL ESTATE)

(
    SELECT *
    FROM BU_CAPTOOLS_WORK.PA_OUT_EMSS_FNCD_RE
	WHERE REF_DATE = '${REF_DATE}'
) UNIV 

LEFT JOIN 
-- LIGAÇÃO COM A TABELA PROPERTY_ENERGY_CERTIFICATE PARA OBTENÇÃO DO CAMPO EPC DO BEM IMÓVEL

(
	SELECT  PROPERTY_BANK_ID,PROPERTY_BRANCH_CODE,PROPERTY_CONTRACT_ID,PROPERTY_REFERENCE_CODE,EPC,QUALITY_SCORE
	FROM BUSINESS_ASSETS.PROPERTY_ENERGY_CERTIFICATE
	WHERE DATA_DATE_PART = '${REF_DATE}'
) EPC 
ON  UNIV.CEMPBEM  = EPC.PROPERTY_BANK_ID AND
    UNIV.CKBALBEM = EPC.PROPERTY_BRANCH_CODE AND
    UNIV.CKCTABEM = EPC.PROPERTY_CONTRACT_ID AND
    UNIV.CKREFBEM = EPC.PROPERTY_REFERENCE_CODE 

GROUP BY 1, 2, 3, 4, 6, 7, 11, 13