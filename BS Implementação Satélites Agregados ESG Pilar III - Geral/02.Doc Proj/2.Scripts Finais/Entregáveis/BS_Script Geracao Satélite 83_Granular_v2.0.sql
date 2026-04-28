/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 27/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 83  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: Obtenção do universo a reportar no âmbito do Satélite 83 + Marcação de metricas relevantes         			       */
/*=========================================================================================================================================*/


-- INSERT OVERWRITE BU_ESG_WORK.AG83_MITI_CTO_GRA PARTITION (REF_DATE)

SELECT
    IDCOMB_SATELITE,
    SOCIEDADE_CONTRAPARTE,
    A.CEMPRESA, 
    A.CBALCAO, 
    A.CNUMECTA, 
    A.ZDEPOSIT,

    -(A.SALDO) AS AMOUNT,

	CASE
		WHEN SFICS.NOME_PURPOSE_ESG_NALINH_TAX='Building renovation loans' THEN 'GFI1'
		WHEN SFICS.NOME_PURPOSE_ESG_NALINH_TAX='Motor vehicle loans' THEN 'GFI1'
		WHEN SFICS.NOME_PURPOSE_ESG_NALINH_TAX='Building acquisition' THEN 'GFI1'
		WHEN SFICS.NOME_PURPOSE_ESG_NALINH_TAX='Other purpose' THEN 'GFI1'
		ELSE 'GFI2'
	END AS GREEN_FINANCIAL_INSTRUMENT,
	
	CASE
		WHEN SFICS.NOME_PURPOSE_ESG_NALINH_TAX='Building renovation loans' THEN 'PESG1'
		WHEN SFICS.NOME_PURPOSE_ESG_NALINH_TAX='Motor vehicle loans' THEN 'PESG2'
		WHEN SFICS.NOME_PURPOSE_ESG_NALINH_TAX='Building acquisition' THEN 'PESG3'
		WHEN SFICS.NOME_PURPOSE_ESG_NALINH_TAX='Other purpose' THEN 'PESG4'
		ELSE ''
	END AS PURPOSE_ESG,
	
	CASE
		WHEN SFICS.NOME_CTGR_SFICS IN ('A.7.7.','A.7.12.','A.7.18.') THEN 'FUTY1'
		WHEN SFICS.NOME_CTGR_SFICS ='Sustainability Linked Finance - Default' THEN 'FUTY2'
		WHEN SFICS.NOME_CTGR_SFICS IN ('A.6.19.') THEN 'FUTY4'
		WHEN SFICS.NOME_CTGR_SFICS IN ('A.1.1.','A.1.3.','A.1.5.','A.1.6.','A.1.9.') THEN 'FUTY5'
		WHEN SFICS.NOME_CTGR_SFICS IN ('A.2.1.','A.2.2.','A.2.3.','A.2.5.','A.2.7.','A.2.14.','A.3.1.','A.3.2.','A.3.7.','A.5.2.','A.8.10.','A.8.23.','KPI Linked - Green','Pure Green counterparty - Default','Student loans') THEN 'FUTY6'	
		ELSE ''
	END AS FUNDING_TYPE,	
	
	'RMCT1' AS RISK_MITIGATED_CCT,
	
	CASE
		WHEN SFICS.NOME_CTGR_SFICS IN ('A.7.2','A.7.4','A.7.5.','A.7.6.') THEN 'RMCP1' 
	ELSE 'RMCP3'
	END AS RISK_MITIGATED_CCP,    	
	
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

	'${REF_DATE}' AS REF_DATE

FROM
(
	SELECT  
			A1.CCONTAB_FINAL_IDCOMB_TOTAL AS IDCOMB_SATELITE,
			A1.CEMPRESA, 
			A1.CBALCAO,
			A1.CNUMECTA, 
			A1.ZDEPOSIT, 
			A3.SOCIEDADE_CONTRAPARTE,
			SUM(A1.MSALDO_FINAL) AS SALDO
	FROM 
		(
		SELECT *
		FROM BUSINESS_ESG.MODESG_OUT_REPORTE_GRANULAR
		WHERE REF_DATE = '${REF_DATE}'
			AND REPORTE_GRANULAR='Satelite 83'
			AND MSALDO_FINAL<>0
		) A1
	LEFT JOIN 
		(
		SELECT DISTINCT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,CEMPRESA_FR,CBALCAO_FR,CNUMECTA_FR,ZDEPOSIT_FR
		FROM CD_CAPTOOLS.KT_CHAVES_FINREP
		WHERE REF_DATE='${REF_DATE}'
		) A2 ON A1.CEMPRESA=A2.CEMPRESA
				AND A1.CBALCAO=A2.CBALCAO
				AND A1.CNUMECTA=A2.CNUMECTA
				AND A1.ZDEPOSIT=A2.ZDEPOSIT
	LEFT JOIN 
		(
		SELECT DISTINCT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,SOCIEDADE_CONTRAPARTE,CCONTAB_FINAL_IDCOMB,CCONTAB_FINAL_IDCOMB_TOTAL
		FROM CD_CAPTOOLS.FR012_MASTER_CTO
		WHERE REF_DATE='${REF_DATE}'
		) A3 ON A2.CEMPRESA_FR=A3.CEMPRESA
				AND A2.CBALCAO_FR=A3.CBALCAO
				AND A2.CNUMECTA_FR=A3.CNUMECTA
				AND A2.ZDEPOSIT_FR=A3.ZDEPOSIT
				AND A1.CCONTAB_FINAL_IDCOMB=A3.CCONTAB_FINAL_IDCOMB		
	GROUP BY 1,2,3,4,5,6
	
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
		NOME_PURPOSE_ESG_NALINH_TAX,
		NOME_SPECIFIC_ELIGIBLE, 
		NOME_SPECIFIC_SUSTAINABLE        
	FROM BUSINESS_ESG.MODESG_OUT_SFICS_TAXON_EUROPEIA
	WHERE REF_DATE= '${REF_DATE}'
) SFICS

ON A.CEMPRESA = SFICS.CEMPRESA
AND A.CBALCAO  = SFICS.CBALCAO
AND A.CNUMECTA = SFICS.CNUMECTA
AND A.ZDEPOSIT = SFICS.ZDEPOSIT

;