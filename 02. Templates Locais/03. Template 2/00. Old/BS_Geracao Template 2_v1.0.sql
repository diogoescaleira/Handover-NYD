/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 29/04/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 2  																					 ****
****  (Banking book - Climate change transition risk: Loans collateralised by immovable property - Energy efficiency of the collateral ) ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: Obtenção do universo a reportar no âmbito do Template 2 + Marcação de metricas relevantes          			       */
/*=========================================================================================================================================*/

-- REGISTOS: 365.743 | MONTANTE: -26 856 052 668.538
-- INSERT OVERWRITE TABLE BU_ESG_WORK.AG02_TEMP_CTO_GRA PARTITION (ID_CORRIDA,REF_DATE)
SELECT 
	 A.*,
	 B.`13_GROSS_CARRYING_AMOUNT`,
	 B.CKBALBEM, 
	 B.CKCTABEM,
	 B.CKREFBEM, 
	 B.EPC, 
	 CASE 
		WHEN B.QUALITY_SCORE IS NULL THEN 'NULO'
		ELSE B.QUALITY_SCORE 
	 end as QUALITY_SCORE,
	 B.CONSUMOS,
	 CASE
	 	  WHEN TRIM(B.EPC) LIKE 'A' THEN 'A'
		  WHEN TRIM(B.EPC) LIKE 'A%' THEN 'A+'
		  WHEN TRIM(B.EPC) LIKE 'B' THEN 'B'
		  WHEN TRIM(B.EPC) LIKE 'B%' THEN 'B-'
		  WHEN TRIM(B.EPC) LIKE 'C%' THEN 'C'
		  WHEN TRIM(B.EPC) LIKE 'D%' THEN 'D'
		  WHEN TRIM(B.EPC) LIKE 'E%' THEN 'E'
		  WHEN TRIM(B.EPC) LIKE 'F%' THEN 'F'
		  WHEN TRIM(B.EPC) LIKE 'G%' THEN 'G'
		  ELSE 'Sem dados'
	 END AS EPC_LABEL, 
	 CASE 
		  WHEN B.CONSUMOS <= 100 THEN 'menor_100'
		  WHEN B.CONSUMOS > 100 AND B.CONSUMOS <= 200 THEN 'menor_200'
		  WHEN B.CONSUMOS > 200 AND B.CONSUMOS <= 300 THEN 'menor_300'
		  WHEN B.CONSUMOS > 300 AND B.CONSUMOS <= 400 THEN 'menor_400'
		  WHEN B.CONSUMOS > 400 AND B.CONSUMOS <= 500 THEN 'menor_500'
		  WHEN B.CONSUMOS > 500 THEN 'maior_500'
		  ELSE 'Sem dados'
	 END AS EP_SCORE,
	 CASE                                                    
		  WHEN B.COUNTRY_CODE IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
		   THEN 'EU-area'
		  WHEN B.COUNTRY_CODE NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428', '')
		   THEN 'Non EU-area'
		  WHEN B.CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
		   THEN 'EU-area'
		  WHEN B.CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
		   THEN 'Non EU-area'
	 ELSE '' 
	 END AS EUROPEAN_UNION,
	 
	 	-- PARTICAO
	RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	'${REF_DATE}' AS REF_DATE
	
FROM 

-- TABELA DE UNIVERSO
(
 SELECT DISTINCT 
	  CEMPRESA,
	  CBALCAO,
	  CNUMECTA,
	  ZDEPOSIT,
	  TIPO_COLATERAL,
	  CCONTAB_FINAL_IDCOMB_TOTAL,
	  BRUTO_IMPARIDADE
 FROM BU_ESG_WORK.P3_FULL_CTR_CLI_LOCAL_DEZ24_V2 
 WHERE DT_RFRNC = '${REF_DATE}' AND 
	   TEMPLATE2=1
) AS A

LEFT JOIN  
(
 SELECT  
	  GAR.CEMPRESA,
	  GAR.CBALCAO,
	  GAR.CNUMECTA,
	  GAR.ZDEPOSIT,
	  SUM(GAR.`13_GROSS_CARRYING_AMOUNT`) AS `13_GROSS_CARRYING_AMOUNT`,
	  GAR.CKBALBEM, 
	  GAR.CKCTABEM,
	  GAR.CKREFBEM,
	  GAR.CPAIS_RESIDENCIA, 
	  CERT_ENERG.EPC, 
	  CERT_ENERG.QUALITY_SCORE,
	  CERT_ENERG.EP_SCORE AS CONSUMOS,
	  PROPERTY.COUNTRY_CODE 
 FROM
 (
	  SELECT * 
	  FROM BU_ESG_WORK.P3_REPARTICAO_GARANTIAS_LOCAL_DEZ24
	  WHERE DT_RFRNC = '${REF_DATE}' 
 ) GAR
 
 LEFT JOIN
 -- LIGAÇÃO COM A TABELA PROPERTY PARA OBTENÇÃO DE CAMPOS CARACTERIZADORES DO BEM
 (
	  SELECT DISTINCT
		   PROPERTY_BRANCH_CODE, 
		   PROPERTY_CONTRACT_ID, 
		   PROPERTY_REFERENCE_CODE,
		   COUNTRY_CODE 
	  FROM BUSINESS_ASSETS.PROPERTY
	  WHERE DATA_DATE_PART = '${REF_DATE}'
 ) PROPERTY ON
	 --GAR.CEMPBEM = PROPERTY.PROPERTY_BANK_ID AND
	 GAR.CKBALBEM = PROPERTY.PROPERTY_BRANCH_CODE AND 
	 GAR.CKCTABEM = PROPERTY.PROPERTY_CONTRACT_ID AND
	 GAR.CKREFBEM = PROPERTY.PROPERTY_REFERENCE_CODE  
 LEFT JOIN
 -- LIGAÇÃO COM A TABELA PROPERTY_ENERGY_CERTIFICATE PARA OBTENÇÃO DE CAMPOS DE CERTIFICADOS ENERGÉTICOS
 (
	  SELECT *
	  FROM BU_ESG_WORK.PROPERTY_ENERGY_CERTIFICATE
	  WHERE DATA_DATE_PART = '${REF_DATE}'
 ) CERT_ENERG ON
	 --GAR.CEMPBEM = CERT_ENERG.PROPERTY_BANK_ID AND
	 GAR.CKBALBEM = CERT_ENERG.PROPERTY_BRANCH_CODE AND 
	 GAR.CKCTABEM = CERT_ENERG.PROPERTY_CONTRACT_ID AND
	 GAR.CKREFBEM = CERT_ENERG.PROPERTY_REFERENCE_CODE
GROUP BY 
	  GAR.CEMPRESA,
	  GAR.CBALCAO,
	  GAR.CNUMECTA,
	  GAR.ZDEPOSIT,
	  GAR.CKBALBEM, 
	  GAR.CKCTABEM,
	  GAR.CKREFBEM,
	  GAR.CPAIS_RESIDENCIA, 
	  CERT_ENERG.EPC, 
	  CERT_ENERG.QUALITY_SCORE,
	  CERT_ENERG.EP_SCORE,
	  PROPERTY.COUNTRY_CODE 
) AS B
ON  A.CEMPRESA = B.CEMPRESA
AND A.CBALCAO  = B.CBALCAO
AND A.CNUMECTA = B.CNUMECTA
AND A.ZDEPOSIT = B.ZDEPOSIT

LEFT JOIN
(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_ESG_WORK.AG02_TEMP_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}'
) RT
ON 1=1

WHERE `13_GROSS_CARRYING_AMOUNT` IS NOT NULL
;

/*=========================================================================================================================================*/
/*  2. Tabela final: obtenção das métricas agregadas a reportar no âmbito do Template 2                  							       */
/*=========================================================================================================================================*/

-- INSERT OVERWRITE TABLE BU_ESG_WORK.AG02_TEMP_CTO_AGR PARTITION (ID_CORRIDA,REF_DATE)
SELECT
        TIPO_COLATERAL,
        EPC_LABEL,
        EP_SCORE,
        EUROPEAN_UNION,
        ROUND(-SUM(`13_GROSS_CARRYING_AMOUNT`),0) AS AMOUNT,
        QUALITY_SCORE,
		
		-- PARTICAO
		RT.NEW_ID_CORRIDA AS ID_CORRIDA,
		'${REF_DATE}' AS REF_DATE
	
FROM (SELECT * FROM BU_ESG_WORK.AG02_TEMP_CTO_GRA WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.AG02_TEMP_CTO_GRA WHERE REF_DATE = '${REF_DATE}'))X
LEFT JOIN
(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_ESG_WORK.AG02_TEMP_CTO_AGR
	WHERE REF_DATE = '${REF_DATE}'
) RT
ON 1=1
GROUP BY 1,2,3,4,6,7,8
;


-- Adicionar adjudicados quando término dos testes.
