
/********************************************************************************************************************************************
****   Projeto: Calculadora de Emissões                                                                         						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 22/12/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Cálculo de Emissões de Real Estate				     										     ****
********************************************************************************************************************************************/

 -- #1 - EPC
 
SELECT 
    PURPOSE_CODE,
    EPC,
    CASE 
        WHEN CEMPBEM IS NULL THEN 'Montante não coberto'
        WHEN origem_scp1_emss='Nao Aplicavel' THEN 'Garagem ou Estacionamento'
        WHEN TRIM(EPC)<>'' AND EPC IS NOT NULL AND TRIM(QUALITY_SCORE) IN ('SANTANDER','1-REAL') THEN 'EPC Real' 
        WHEN TRIM(EPC)<>'' AND EPC IS NOT NULL THEN 'EPC Estimado'
        WHEN TRIM(EPC)='' OR EPC IS NULL THEN 'Sem informação'
    END AS FLAG_TIPO_EPC,
    SUM(-AMOUNT) AS VALOR_BRUTO,
    SUM(EMISS_OP2B)
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V3
WHERE FLAG_CTO_BEM='CTO_IMO' AND PURPOSE_CODE IN ('CRE_OUTRO','Habitacao') --AND TRIM(origem_scp1_emss) in ('RE_DQS3_2A') 
GROUP BY 1,2,3
;

 -- #2 - Área Bruta 
 
SELECT 
    PURPOSE_CODE,
    ORIGEM_SCP1_EMSS_OP2B,
    ORIGEM_SCP2_EMSS_OP2B,
    CASE 
        WHEN CEMPBEM IS NULL THEN 'Montante não coberto'
        WHEN origem_scp1_emss='Nao Aplicavel' THEN 'Garagem ou Estacionamento'
        WHEN NET_FLOOR_AREA IS NULL OR NET_FLOOR_AREA=0 THEN 'Sem informação da área'
        WHEN NET_FLOOR_AREA IS NOT NULL THEN 'Com informação da área'
    END AS FLAG_AREA,
    SUM(-AMOUNT) AS VALOR_BRUTO,
    SUM(EMISS_OP2B)
SELECT COUNT(*)
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V3
WHERE FLAG_CTO_BEM='CTO_IMO' AND PURPOSE_CODE IN ('CRE_OUTRO','Habitacao')
GROUP BY 1,2,3,4
; 

-- #2 Finalidade
SELECT 
    PURPOSE_CODE,
	CASE 
		WHEN TRIM(PROPERTY_PURPOSE_CODE)<>'08' THEN TRIM(PROPERTY_PURPOSE_CODE)
		WHEN TRIM(PROPERTY_PURPOSE_CODE)='08' AND TRIM(CGARANT_BEM) IN ('5101','5102') THEN '01'
		WHEN TRIM(PROPERTY_PURPOSE_CODE)='08' AND TRIM(CGARANT_BEM) IN ('5201','5202') THEN '02'
		WHEN TRIM(PROPERTY_PURPOSE_CODE)='08' AND TRIM(CGARANT_BEM) IN ('5213') THEN '10'
		WHEN TRIM(PROPERTY_PURPOSE_CODE)='08' AND TRIM(CGARANT_BEM) IN ('5215') THEN '11'
		WHEN TRIM(PROPERTY_PURPOSE_CODE)='08' THEN '08'
	END AS FINALIDADE_MOD,
    SUM(-AMOUNT) AS VALOR_BRUTO,
    SUM(EMISS_OP2B)
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V3
WHERE FLAG_CTO_BEM='CTO_IMO' AND PURPOSE_CODE IN ('CRE_OUTRO','Habitacao')
GROUP BY 1,2

;

SELECT *
FROM BU_CAPTOOLS_WORK.BENS_IMOVEIS_MV_DEZ24_OP2
WHERE origem_scp1_emss='MISS' AND concat(cempbem,ckbalbem,ckctabem,ckrefbem) IN 
    (
    SELECT DISTINCT concat(cempbem,ckbalbem,ckctabem,ckrefbem)
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V3
    WHERE FLAG_CTO_BEM='CTO_IMO' AND PURPOSE_CODE IN ('CRE_OUTRO','Habitacao') 
    )
;

select sum(amount)
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V3
    WHERE FLAG_CTO_BEM='CTO_IMO' AND PURPOSE_CODE IN ('CRE_OUTRO','Habitacao') and concat(cempbem,ckbalbem,ckctabem,ckrefbem) in (
'31003215729440000000000000000000','31084015177880000000000000000000','31084015188700000000000000000000')
;

-- Área Ponderada 

SELECT origem_scp1_emss,SUM(net_floor_area*ratio_op2)
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V3
WHERE FLAG_CTO_BEM='CTO_IMO' AND PURPOSE_CODE IN ('CRE_OUTRO') --AND TRIM(origem_scp1_emss) in ('RE_DQS3_2A') 
--AND cempbem IS NOT NULL 
GROUP BY 1
;

-- Área Ponderada 
SELECT origem_scp1_emss,SUM(net_floor_area*ratio_op2)
FROM BU_CAPTOOLS_WORK.MODESG_OUT_GRA_EMSS_FNCD_V3
WHERE FLAG_CTO_BEM='CTO_IMO' AND PURPOSE_CODE IN ('Habitacao') --AND TRIM(origem_scp1_emss) in ('RE_DQS3_2A') 
--AND cempbem IS NOT NULL 
GROUP BY 1
