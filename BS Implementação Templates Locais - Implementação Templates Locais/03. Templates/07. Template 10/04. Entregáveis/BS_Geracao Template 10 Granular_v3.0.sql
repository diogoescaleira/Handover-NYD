/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 30/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 10																		                 ****
****  ( Other climate change mitigating actions that are not covered in the EU Taxonomy )               								 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: Obtenção do universo a reportar no âmbito do Template 10 + Marcação de metricas relevantes       	     		   */
/*=========================================================================================================================================*/ 

INSERT OVERWRITE BU_ESG_WORK.AG10_TEMP_CTO_GRA PARTITION (REF_DATE)

SELECT
    A.CEMPRESA, 
    A.CBALCAO, 
    A.CNUMECTA, 
    A.ZDEPOSIT,
	A.ZCLIENTE,
    A.TIPO_COLATERAL,
    A.INSTRUMENTO_FINANCEIRO,
    A.CONTRAPARTE,
	A.CEMPBEM,
	A.CKBALBEM,
	A.CKCTABEM,
	A.CKREFBEM,
    -SUM(A.SALDO_CT) AS AMOUNT,

	CASE
		WHEN SFICS.NOME_CTGR_SFICS <> 'Nao Aplicavel' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Building renovation loans' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'GFI1'
		WHEN SFICS.NOME_CTGR_SFICS <> 'Nao Aplicavel' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Motor vehicle loans' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'GFI1'
		WHEN SFICS.NOME_CTGR_SFICS <> 'Nao Aplicavel' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Building acquisition' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'GFI1'
		WHEN SFICS.NOME_CTGR_SFICS <> 'Nao Aplicavel' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Other purpose' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'GFI1'
		ELSE 'GFI2'
	END AS GREEN_FINANCIAL_INSTRUMENT,
	
	CASE
		WHEN SFICS.NOME_CTGR_SFICS <> 'Nao Aplicavel' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Building renovation loans' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'PESG1'
		WHEN SFICS.NOME_CTGR_SFICS <> 'Nao Aplicavel' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Motor vehicle loans' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'PESG2'
		WHEN SFICS.NOME_CTGR_SFICS <> 'Nao Aplicavel' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Building acquisition' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'PESG3'
		WHEN SFICS.NOME_CTGR_SFICS <> 'Nao Aplicavel' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Other purpose' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'PESG4'
		ELSE ''
	END AS PURPOSE_ESG,
	
	CASE
		WHEN SFICS.NOME_CTGR_SFICS = 'A.1.1.' THEN 'Electricity generation using solar photovoltaic technology'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.1.3.' THEN 'Electricity generation from wind power'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.1.5.' THEN 'Electricity generation from hydropower'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.1.6.' THEN 'Electricity generation from geothermal energy'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.1.9.' THEN 'Transmission and distribution of electricity'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.2.1.' THEN 'Passenger interurban rail transport'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.2.2.' THEN 'Freight rail transport'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.2.3.' THEN 'Urban and suburban transport, road passenger transport'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.2.5.' THEN 'Transport by motorbikes, passenger cars and light commercial vehicles'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.2.7.' THEN 'Inland passenger water transport'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.2.14.' THEN 'Infrastructure for rail transport'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.3.1.' THEN 'Construction of new buildings'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.3.2.' THEN 'Renovation of existing buildings'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.3.7.' THEN 'Acquisition and ownership'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.5.2.' THEN 'Emergency services'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.6.19.' THEN 'Treatment of hazardous waste'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.7.7.' THEN 'Sustainable growing of crops'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.7.12.' THEN 'Agricultural Structures'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.7.18.' THEN 'Sustainable Agricultural Production'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.8.10.' THEN 'Manufacture of iron and steel'
		WHEN SFICS.NOME_CTGR_SFICS = 'A.8.23.' THEN 'Manufacture of plastic packaging goods'
		WHEN SFICS.NOME_CTGR_SFICS = 'KPI Linked - Green' THEN 'KPI Linked - Green'
		WHEN SFICS.NOME_CTGR_SFICS = 'Pure Green counterparty - Default' THEN 'Pure Green counterparty - Default'
		WHEN SFICS.NOME_CTGR_SFICS = 'Student loans' THEN 'Student loans'	
		ELSE ''
	END DCON,

    CASE 
        WHEN FLG_ACT_PHYSCL_RSK_PRTCTN > 0 THEN 'ACUT1'
        WHEN (FLG_ACT_PHYSCL_RSK_PRTCTN IS NULL OR FLG_ACT_PHYSCL_RSK_PRTCTN=0) AND FLG_ACT_PHYSCL_RSK_ENTTY > 0 THEN 'ACUT1' 
        ELSE 'ACUT2' 
    END AS ACUTE_CHANGES,
	
    CASE 
        WHEN FLG_CHRNC_PHYSCL_RSK_PRTCTN > 0 THEN 'CHRO1'
        WHEN (FLG_CHRNC_PHYSCL_RSK_PRTCTN IS NULL OR FLG_CHRNC_PHYSCL_RSK_PRTCTN=0) AND FLG_CHRNC_PHYSCL_RSK_ENTTY > 0 THEN 'CHRO1' 
        ELSE 'CHRO2' 
    END AS CHRONIC_CHANGES,
    
	CASE
        WHEN FLG_ACT_PHYSCL_RSK_PRTCTN > 0 OR FLG_ACT_PHYSCL_RSK_ENTTY > 0 OR FLG_CHRNC_PHYSCL_RSK_PRTCTN > 0 OR FLG_CHRNC_PHYSCL_RSK_ENTTY > 0 THEN 1
        ELSE 0
    END AS FLAG_PHYSICAL_RISK,

	-- PARTICAO
	'${REF_DATE}' AS REF_DATE	

FROM
(
    SELECT 
    	F1.CEMPRESA,
    	F1.CBALCAO,
    	F1.CNUMECTA,
    	F1.ZDEPOSIT,
    	F1.CONTRAPARTE,
    	F2.ZCLIENTE,
    	F1.INSTRUMENTO_FINANCEIRO,
    	F1.TIPO_COLATERAL,
    	F2.CEMPBEM,
    	F2.CKBALBEM,
    	F2.CKCTABEM,
    	F2.CKREFBEM,
    	F2. SALDO AS SALDO_CT
    FROM 
        (
		
		SELECT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,CONTRAPARTE,INSTRUMENTO_FINANCEIRO,
			CASE 
				WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL1%' THEN 'Sem Garantia'
				WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL2%' THEN 'Garantia Residencial'
				WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL3%' THEN 'Garantia Comercial'
				WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL4%' THEN 'Garantia Real'
			END AS TIPO_COLATERAL, SUM(MSALDO_FINAL) AS MSALDO_FINAL
		FROM BUSINESS_ESG.MODESG_OUT_REPORTE_GRANULAR
		WHERE REF_DATE = '${REF_DATE}'
			AND REPORTE_GRANULAR='Template 10'
		GROUP BY 1,2,3,4,5,6,7
		HAVING MSALDO_FINAL<>0
    	)F1
    LEFT JOIN 
        (
        SELECT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,ZCLIENTE,CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM,SUM(AMOUNT) AS SALDO
		FROM BUSINESS_ESG.MODESG_OUT_EMSS_FNCD
		WHERE REF_DATE = '${REF_DATE}'
			AND NOME_PERIMETRO LIKE '%ST SGPS Cons%'
        GROUP BY 1,2,3,4,5,6,7,8,9
        )F2 ON F1.CEMPRESA=F2.CEMPRESA AND F1.CBALCAO=F2.CBALCAO AND F1.CNUMECTA=F2.CNUMECTA AND F1.ZDEPOSIT=F2.ZDEPOSIT
 ) AS A

LEFT JOIN

(
	SELECT
		CEMPRESA, 
		CBALCAO, 
		CNUMECTA, 
		ZDEPOSIT,
		NOME_CTGR_SFICS,
		NOME_GENERAL_SPECIFIC_PURPOSE,
		NOME_PURPOSE_ESG_ALINH_TAX,
		NOME_SPECIFIC_ELIGIBLE, 
		NOME_SPECIFIC_SUSTAINABLE        
	FROM BUSINESS_ESG.MODESG_OUT_SFICS_TAXON_EUROPEIA
	WHERE REF_DATE= '${REF_DATE}'
) SFICS

ON A.CEMPRESA = SFICS.CEMPRESA
AND A.CBALCAO  = SFICS.CBALCAO
AND A.CNUMECTA = SFICS.CNUMECTA
AND A.ZDEPOSIT = SFICS.ZDEPOSIT

LEFT JOIN 
-- OBTENÇÃO DO RISCO AO NÍVEL DO CLIENTE
(
    SELECT *, FLG_RSC_FSC_AGD AS FLG_ACT_PHYSCL_RSK_ENTTY, FLG_RSC_FSC_CRNC AS FLG_CHRNC_PHYSCL_RSK_ENTTY  
    FROM BUSINESS_ESG.MODESG_OUT_EMPR_INFO_NFIN 
    WHERE REF_DATE='${REF_DATE}'
) NFIN
ON A.ZCLIENTE = NFIN.ZCLIENTE

LEFT JOIN 
-- OBTENÇÃO DO RISCO AO NÍVEL DO COLATERAL IMÓVEL
(
    SELECT *, FLG_RSC_FSC_AGD AS FLG_ACT_PHYSCL_RSK_PRTCTN, FLG_RSC_FSC_CRNC AS FLG_CHRNC_PHYSCL_RSK_PRTCTN  
    FROM BUSINESS_ESG.MODESG_OUT_BENS_IMOVEIS 
    WHERE REF_DATE='${REF_DATE}'
) MODESG_OUT_BENS_IMOVEIS
ON  CONCAT(MODESG_OUT_BENS_IMOVEIS.CEMPBEM,MODESG_OUT_BENS_IMOVEIS.CKBALBEM,MODESG_OUT_BENS_IMOVEIS.CKCTABEM,MODESG_OUT_BENS_IMOVEIS.CKREFBEM) = CONCAT(A.CEMPBEM,A.CKBALBEM,A.CKCTABEM,A.CKREFBEM)

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,21
;