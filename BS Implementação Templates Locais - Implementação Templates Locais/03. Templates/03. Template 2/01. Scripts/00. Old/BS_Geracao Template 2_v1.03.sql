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


-- INSERT OVERWRITE TABLE BU_ESG_WORK.AG02_TEMP_CTO_GRA PARTITION (ID_CORRIDA,REF_DATE)
SELECT X.*,
    -- PARTICAO
	RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	'${REF_DATE}' AS REF_DATE
FROM
(
    SELECT 
        A.CEMPRESA,
        A.CBALCAO,
        A.CNUMECTA,
        A.ZDEPOSIT,
        A.TIPO_COLATERAL,
        A.CCONTAB_FINAL_IDCOMB_TOTAL,
        A.BRUTO_IMPARIDADE,
        B.AMOUNT,
        B.CEMPBEM,
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
            WHEN A.ZCLIENTE = '0000000000' THEN 'EU-area'                                                  
            WHEN B.COUNTRY_CODE IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                THEN 'EU-area'
            WHEN B.COUNTRY_CODE NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428', '')
                THEN 'Non EU-area'
            WHEN A.CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                THEN 'EU-area'
            WHEN A.CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
                THEN 'Non EU-area'
        ELSE '' 
        END AS EUROPEAN_UNION
        
    FROM 
    -- TABELA DE UNIVERSO
    (
    SELECT DISTINCT
        ZCLIENTE, 
        CEMPRESA,
        CBALCAO,
        CNUMECTA,
        ZDEPOSIT,
        TIPO_COLATERAL,
        CCONTAB_FINAL_IDCOMB_TOTAL,
        BRUTO_IMPARIDADE,
        CPAIS_RESIDENCIA
    FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO 
    WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO WHERE REF_DATE = '${REF_DATE}')
        AND TEMPLATE2=1
    ) AS A

    LEFT JOIN  
    (
    SELECT  
        GAR.CEMPRESA,
        GAR.CBALCAO,
        GAR.CNUMECTA,
        GAR.ZDEPOSIT,
        -1*SUM(GAR.AMOUNT) AS AMOUNT,
        GAR.CEMPBEM,
        GAR.CKBALBEM,
        GAR.CKCTABEM,
        GAR.CKREFBEM,
        CERT_ENERG.EPC, 
        CERT_ENERG.QUALITY_SCORE,
        CERT_ENERG.EP_SCORE AS CONSUMOS,
        PROPERTY.COUNTRY_CODE 
    FROM
    (
        SELECT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,ZCLIENTE,CEMPBEM,CKBALBEM,CKCTABEM,CKREFBEM,SUM(AMOUNT) AS AMOUNT 
        FROM BU_CAPTOOLS_WORK.EMI_FINAN_JUN25
        WHERE FLAG_PERIMETRO LIKE '%Local%'
        -- AND REF_DATE = '${REF_DATE}'
        GROUP BY 1,2,3,4,5,6,7,8,9
    ) GAR
    
    LEFT JOIN
    -- LIGAÇÃO COM A TABELA PROPERTY PARA OBTENÇÃO DE CAMPOS CARACTERIZADORES DO BEM
    (
        SELECT DISTINCT
            PROPERTY_BANK_ID,   
            PROPERTY_BRANCH_CODE, 
            PROPERTY_CONTRACT_ID, 
            PROPERTY_REFERENCE_CODE,
            COUNTRY_CODE 
        FROM BU_ESG_WORK.PROPERTY
        WHERE DATA_DATE_PART = '${REF_DATE}'
    ) PROPERTY ON CONCAT(PROPERTY.PROPERTY_BANK_ID,PROPERTY.PROPERTY_BRANCH_CODE,PROPERTY.PROPERTY_CONTRACT_ID,PROPERTY.PROPERTY_REFERENCE_CODE) = CONCAT(GAR.CEMPBEM,GAR.CKBALBEM,GAR.CKCTABEM,GAR.CKREFBEM)

    LEFT JOIN
    -- LIGAÇÃO COM A TABELA PROPERTY_ENERGY_CERTIFICATE PARA OBTENÇÃO DE CAMPOS DE CERTIFICADOS ENERGÉTICOS
    (
        SELECT *
        FROM BU_ESG_WORK.PROPERTY_ENERGY_CERTIFICATE
        WHERE DATA_DATE_PART = '${REF_DATE}'
    ) CERT_ENERG ON CONCAT(CERT_ENERG.PROPERTY_BANK_ID,CERT_ENERG.PROPERTY_BRANCH_CODE,CERT_ENERG.PROPERTY_CONTRACT_ID,CERT_ENERG.PROPERTY_REFERENCE_CODE) = CONCAT(GAR.CEMPBEM,GAR.CKBALBEM,GAR.CKCTABEM,GAR.CKREFBEM)

    GROUP BY 1,2,3,4,6,7,8,9,10,11,12,13
    ) AS B
    ON  A.CEMPRESA = B.CEMPRESA
    AND A.CBALCAO  = B.CBALCAO
    AND A.CNUMECTA = B.CNUMECTA
    AND A.ZDEPOSIT = B.ZDEPOSIT
    WHERE AMOUNT IS NOT NULL

    UNION ALL
    -- ADJUDICADOS
    SELECT 
        NULL AS CEMPRESA,
        NULL AS CBALCAO,
        NULL AS CNUMECTA,
        NULL AS ZDEPOSIT,
        'Stock' AS TIPO_COLATERAL,
        NULL AS CCONTAB_FINAL_IDCOMB_TOTAL,
        NULL AS BRUTO_IMPARIDADE,
        ADJUD_INPUTS.V_CONTAB AS AMOUNT,
        ADJUD_INPUTS.PROPERTY_BANK_ID,
        ADJUD_INPUTS.PROPERTY_BRANCH_CODE,
        ADJUD_INPUTS.PROPERTY_CONTRACT_ID,
        ADJUD_INPUTS.PROPERTY_REFERENCE_CODE,
        CERT_ENERG.EPC, 
        CASE 
            WHEN CERT_ENERG.QUALITY_SCORE IS NULL THEN 'NULO'
            ELSE CERT_ENERG.QUALITY_SCORE 
        end as QUALITY_SCORE,
        CERT_ENERG.EP_SCORE AS CONSUMOS,
        CASE
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'A' THEN 'A'
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'A%' THEN 'A+'
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'B' THEN 'B'
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'B%' THEN 'B-'
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'C%' THEN 'C'
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'D%' THEN 'D'
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'E%' THEN 'E'
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'F%' THEN 'F'
            WHEN TRIM(CERT_ENERG.EPC) LIKE 'G%' THEN 'G'
            ELSE 'Sem dados'
        END AS EPC_LABEL, 
        CASE 
            WHEN CERT_ENERG.EP_SCORE <= 100 THEN 'menor_100'
            WHEN CERT_ENERG.EP_SCORE > 100 AND CERT_ENERG.EP_SCORE <= 200 THEN 'menor_200'
            WHEN CERT_ENERG.EP_SCORE > 200 AND CERT_ENERG.EP_SCORE <= 300 THEN 'menor_300'
            WHEN CERT_ENERG.EP_SCORE > 300 AND CERT_ENERG.EP_SCORE <= 400 THEN 'menor_400'
            WHEN CERT_ENERG.EP_SCORE > 400 AND CERT_ENERG.EP_SCORE <= 500 THEN 'menor_500'
            WHEN CERT_ENERG.EP_SCORE > 500 THEN 'maior_500'
            ELSE 'Sem dados'
        END AS EP_SCORE,
        CASE                                                    
            WHEN PROPERTY.COUNTRY_CODE IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
            THEN 'EU-area'
            WHEN PROPERTY.COUNTRY_CODE NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428', '')
            THEN 'Non EU-area'
        ELSE '' 
        END AS EUROPEAN_UNION
        
    FROM 
    -- TABELA DE UNIVERSO
    (
    SELECT
        '31' as PROPERTY_BANK_ID,
        'CMAH' AS PROPERTY_BRANCH_CODE, 
        'IMOVELGIDAP' AS PROPERTY_CONTRACT_ID,
        REPLACE(UPPER(LPAD(COD_IMOVEL,15,'0')),' ', '0') AS PROPERTY_REFERENCE_CODE,
        V_CONTAB
    FROM CD_CAPTOOLS.CT666_ADJUDIC_PROPR
    WHERE REF_DATE='${REF_DATE}'
    AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')

    UNION ALL

    SELECT
        '89' AS PROPERTY_BANK_ID , 
        'CMAH' AS PROPERTY_BRANCH_CODE, 
        'IMOVELIFICS' AS PROPERTY_CONTRACT_ID,
        LPAD(N_IMOVEL,15,'0') AS PROPERTY_REFERENCE_CODE,
        V_CONTAB
    FROM CD_CAPTOOLS.CT668_IMOVEIS_IFIC
    WHERE REF_DATE='${REF_DATE}'
    AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')

    UNION ALL

    SELECT
        '00160' AS PROPERTY_BANK_ID , 
        'CMAH' AS PROPERTY_BRANCH_CODE, 
        'IMOVELGIDTU' AS PROPERTY_CONTRACT_ID, 
        LPAD(COD_IMOVEL,15,'0') AS PROPERTY_REFERENCE_CODE,
        V_CONTAB
    FROM CD_CAPTOOLS.CT665_STOCK_URBE
    WHERE REF_DATE='${REF_DATE}'
    ) ADJUD_INPUTS

    LEFT JOIN
    -- LIGAÇÃO COM A TABELA PROPERTY PARA OBTENÇÃO DE CAMPOS CARACTERIZADORES DO BEM
    (
        SELECT DISTINCT
            PROPERTY_BANK_ID,
            PROPERTY_BRANCH_CODE, 
            PROPERTY_CONTRACT_ID, 
            PROPERTY_REFERENCE_CODE,
            COUNTRY_CODE 
        FROM BU_ESG_WORK.PROPERTY
        WHERE DATA_DATE_PART = '${REF_DATE}'
    ) PROPERTY 
    ON CONCAT(PROPERTY.PROPERTY_BANK_ID,PROPERTY.PROPERTY_BRANCH_CODE,PROPERTY.PROPERTY_CONTRACT_ID,PROPERTY.PROPERTY_REFERENCE_CODE) = CONCAT(ADJUD_INPUTS.PROPERTY_BANK_ID,ADJUD_INPUTS.PROPERTY_BRANCH_CODE,ADJUD_INPUTS.PROPERTY_CONTRACT_ID,ADJUD_INPUTS.PROPERTY_REFERENCE_CODE)
    
    LEFT JOIN
    -- LIGAÇÃO COM A TABELA PROPERTY_ENERGY_CERTIFICATE PARA OBTENÇÃO DE CAMPOS DE CERTIFICADOS ENERGÉTICOS
    (
        SELECT *
        FROM BU_ESG_WORK.PROPERTY_ENERGY_CERTIFICATE
        WHERE DATA_DATE_PART = '${REF_DATE}'
    ) CERT_ENERG 
    ON CONCAT(CERT_ENERG.PROPERTY_BANK_ID,CERT_ENERG.PROPERTY_BRANCH_CODE,CERT_ENERG.PROPERTY_CONTRACT_ID,CERT_ENERG.PROPERTY_REFERENCE_CODE) = CONCAT(ADJUD_INPUTS.PROPERTY_BANK_ID,ADJUD_INPUTS.PROPERTY_BRANCH_CODE,ADJUD_INPUTS.PROPERTY_CONTRACT_ID,ADJUD_INPUTS.PROPERTY_REFERENCE_CODE) 

    WHERE CONCAT(ADJUD_INPUTS.PROPERTY_BANK_ID,ADJUD_INPUTS.PROPERTY_BRANCH_CODE,ADJUD_INPUTS.PROPERTY_CONTRACT_ID,ADJUD_INPUTS.PROPERTY_REFERENCE_CODE) IN (SELECT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) FROM CD_CAPTOOLS.CT001_UNIV_SALDO WHERE REF_DATE='${REF_DATE}' AND CCONTAB_FINAL_IDCOMB LIKE '%MC1005%')
) X

LEFT JOIN
(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_ESG_WORK.AG02_TEMP_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}'
) RT
ON 1=1
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
        ROUND(SUM(AMOUNT),0) AS AMOUNT,
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



