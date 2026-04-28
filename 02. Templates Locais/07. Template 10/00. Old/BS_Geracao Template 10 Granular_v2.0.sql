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

-- INSERT OVERWRITE BU_ESG_WORK.AG10_TEMP_CTO_GRA PARTITION (ID_CORRIDA,REF_DATE)
SELECT
    A.CEMPRESA, 
    A.CBALCAO, 
    A.CNUMECTA, 
    A.ZDEPOSIT,
	A.ZCLIENTE,
    A.TIPO_COLATERAL,
    A.INSTRUMENTO_FINANCEIRO,
    A.CONTRAPARTE,
    -SUM(A.SALDO_CT) AS AMOUNT,

	CASE
		WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Building renovation loans' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'GFI1'
		WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Motor vehicle loans' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'GFI1'
		WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Building acquisition' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'GFI1'
		WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Other purpose' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'GFI1'
		ELSE 'GFI2'
	END AS GREEN_FINANCIAL_INSTRUMENT,
	
	CASE
		WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Building renovation loans' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'PESG1'
		WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Motor vehicle loans' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'PESG2'
		WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Building acquisition' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'PESG3'
		WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX ='Other purpose' AND NOME_SPECIFIC_SUSTAINABLE IN ('No','Nao Aplicavel') THEN 'PESG4'
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

	-- PARTICAO
	RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	'${REF_DATE}' AS REF_DATE	

FROM
(
	SELECT
		CEMPRESA,
		CBALCAO,
		CNUMECTA,
		ZDEPOSIT,
		CONTRAPARTE,
		ZCLIENTE,
		INSTRUMENTO_FINANCEIRO,
		TIPO_COLATERAL,
		SUM(MSALDO_FINAL) AS SALDO_CT
	FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO
	WHERE TEMPLATE10=1  
    AND REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO WHERE REF_DATE = '${REF_DATE}')
	GROUP BY 1,2,3,4,5,6,7,8
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
	FROM BU_ESG_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA
	WHERE REF_DATE= '${REF_DATE}'
) SFICS

ON A.CEMPRESA = SFICS.CEMPRESA
AND A.CBALCAO  = SFICS.CBALCAO
AND A.CNUMECTA = SFICS.CNUMECTA
AND A.ZDEPOSIT = SFICS.ZDEPOSIT

LEFT JOIN

(
SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
FROM BU_ESG_WORK.AG10_TEMP_CTO_GRA
WHERE REF_DATE = '${REF_DATE}'
) RT

ON 1=1

GROUP BY 1,2,3,4,5,6,7,8,10,11,12,13,14
;