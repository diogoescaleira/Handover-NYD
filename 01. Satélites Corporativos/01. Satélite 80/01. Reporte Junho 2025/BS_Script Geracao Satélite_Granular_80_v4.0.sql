/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: Bs & Neyond                                                                                                                ****
****   Data: 29/04/2025                                                                                                                  ****
****   Sql Script Descrição: Geração Do Satélite 80  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: obtenção do universo a reportar no âmbito do satélite 80 + marcação de metricas relevantes         			       */
/*=========================================================================================================================================*/


-- INSERT OVERWRITE TABLE BU_ESG_WORK.AG080_ENPC_CTO_GRA PARTITION (ID_CORRIDA,REF_DATE)


SELECT
    X.*,	
    CASE
        WHEN CONSUMOS IS NOT NULL THEN 'EPSD2'
        WHEN CONSUMOS IS NULL THEN 'EPSD3'
    END AS EP_SCORE_DATA,
    
    CASE 
		WHEN CONSUMOS <= 100 THEN 'EPSC1'
		WHEN CONSUMOS > 100 AND CONSUMOS <= 200 THEN 'EPSC2'
		WHEN CONSUMOS > 200 AND CONSUMOS <= 300 THEN 'EPSC3'
		WHEN CONSUMOS > 300 AND CONSUMOS <= 400 THEN 'EPSC4'
		WHEN CONSUMOS > 400 AND CONSUMOS <= 500 THEN 'EPSC5'
		WHEN CONSUMOS > 500 THEN 'EPSC6'
		ELSE 'EPSC7'
	END AS EP_SCORE,	

	CASE WHEN QUALITY_SCORE  IN ('1-REAL', 'SANTANDER') THEN 'EPCD1'
		 WHEN QUALITY_SCORE IN ('2-MUY ALTA', '3-ALTA', '4-MEDIA', '5-MEDIA BAJA', '6-BAJA') THEN 'EPCD2'
		 ELSE 'EPCD3'
	END AS EP_LABEL_DATA,
	
	CASE
		WHEN TRIM(EPC) LIKE 'A%' THEN 'EPCL1'
		WHEN TRIM(EPC) LIKE 'B%' THEN 'EPCL2'
		WHEN TRIM(EPC) LIKE 'C%' THEN 'EPCL3'
		WHEN TRIM(EPC) LIKE 'D%' THEN 'EPCL4'
		WHEN TRIM(EPC) LIKE 'E%' THEN 'EPCL5'
		WHEN TRIM(EPC) LIKE 'F%' THEN 'EPCL6'
		WHEN TRIM(EPC) LIKE 'G%' THEN 'EPCL7'
		ELSE 'EPCL8'
	END AS EPC_LABEL, 
	CASE                                                    
		WHEN COUNTRY_CODE IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
			THEN 'EU1'
		WHEN COUNTRY_CODE NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428', '')
			THEN 'EU2'
		WHEN CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
			THEN 'EU1'
		WHEN CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
			THEN 'EU2'
	ELSE '' END AS EUROPEAN_UNION, 
	RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	'${REF_DATE}' AS REF_DATE
FROM
    (
    SELECT
        a.IDCOMB_SATELITE,
        a.SOCIEDADE_CONTRAPARTE,
    	a.CEMPRESA_CT,
        a.CBALCAO_CT,
        a.CNUMECTA_CT,
        a.ZDEPOSIT_CT,
        A.CARGABAL_CT,
    	B.AMOUNT AS AMOUNT,
    	B.CKBALBEM AS PROPERTY_BRANCH_CODE,	
    	B.CKCTABEM AS PROPERTY_CONTRACT_ID,
    	B.CKREFBEM AS PROPERTY_REFERENCE_CODE,
        B.EPC,
        B.QUALITY_SCORE,
        B.CONSUMOS,
        B.COUNTRY_CODE, 
        b.CPAIS_RESIDENCIA
    FROM
        (
        SELECT DISTINCT 
            IDCOMB_SATELITE,
            SOCIEDADE_CONTRAPARTE,
            CEMPRESA_CT, 
            CBALCAO_CT,
            CNUMECTA_CT, 
            ZDEPOSIT_CT, 
            CARGABAL_CT
        FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL 
        WHERE DT_RFRNC = '${REF_DATE}' AND 
            ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL WHERE DT_RFRNC = '${REF_DATE}') AND 
        	CSATELITE IN (80) AND IDCOMB_SATELITE NOT LIKE '%MC10%'
        ) AS A
        
        LEFT JOIN

        (
        SELECT  
            EMISS.CEMPRESA,
            EMISS.CBALCAO,
            EMISS.CNUMECTA,
            EMISS.ZDEPOSIT,
            SUM(EMISS.AMOUNT) AS AMOUNT,
            EMISS.CKBALBEM, 
            EMISS.CKCTABEM,
            EMISS.CKREFBEM,
            CT003.CPAIS_RESIDENCIA, 
            CERT_ENERG.EPC, 
            CERT_ENERG.QUALITY_SCORE,
            CERT_ENERG.EP_SCORE AS CONSUMOS,
            PROPERTY.COUNTRY_CODE
        FROM

        (
        SELECT
            CEMPRESA, 
            CBALCAO, 
            CNUMECTA, 
            ZDEPOSIT, 
            CEMPBEM, 
            CKBALBEM, 
            CKCTABEM, 
            CKREFBEM,                
            ZCLIENTE,
            SUM(AMOUNT) AS AMOUNT
        FROM BU_ESG_WORK.MODESG_OUT_EMSS_FNCD 
        WHERE REF_DATE='${REF_DATE}'
        AND NOME_PERIMETRO LIKE '%Individual Idcomb%'
        GROUP BY 1,2,3,4,5,6,7,8,9
        ) EMISS

        LEFT JOIN

        (
        SELECT
            ZCLIENTE, 
            CPAIS_RESIDENCIA, 
            CONTRAPARTE
        FROM CD_CAPTOOLS.CT003_UNIV_CLI
        WHERE REF_DATE='${REF_DATE}'
        ) CT003

        ON EMISS.ZCLIENTE=CT003.ZCLIENTE
           
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
         ) PROPERTY 
         
         ON EMISS.CKBALBEM = PROPERTY.PROPERTY_BRANCH_CODE 
         AND EMISS.CKCTABEM = PROPERTY.PROPERTY_CONTRACT_ID 
         AND EMISS.CKREFBEM = PROPERTY.PROPERTY_REFERENCE_CODE 
        
        LEFT JOIN
        -- LIGAÇÃO COM A TABELA PROPERTY_ENERGY_CERTIFICATE PARA OBTENÇÃO DE CAMPOS DE CERTIFICADOS ENERGÉTICOS
        (
        SELECT *
        FROM BU_ESG_WORK.PROPERTY_ENERGY_CERTIFICATE
        WHERE DATA_DATE_PART = '${REF_DATE}'
        ) CERT_ENERG
         
         ON EMISS.CKBALBEM = CERT_ENERG.PROPERTY_BRANCH_CODE
         AND EMISS.CKCTABEM = CERT_ENERG.PROPERTY_CONTRACT_ID 
         AND EMISS.CKREFBEM = CERT_ENERG.PROPERTY_REFERENCE_CODE
        
        GROUP BY 
          EMISS.CEMPRESA,
          EMISS.CBALCAO,
          EMISS.CNUMECTA,
          EMISS.ZDEPOSIT,
          EMISS.CKBALBEM, 
          EMISS.CKCTABEM,
          EMISS.CKREFBEM,
          CT003.CPAIS_RESIDENCIA, 
          CERT_ENERG.EPC, 
          CERT_ENERG.QUALITY_SCORE,
          CERT_ENERG.EP_SCORE,
          PROPERTY.COUNTRY_CODE
        ) AS B
        
        ON  A.CEMPRESA_CT = B.CEMPRESA
        AND A.CBALCAO_CT  = B.CBALCAO
        AND A.CNUMECTA_CT = B.CNUMECTA
        AND A.ZDEPOSIT_CT = B.ZDEPOSIT
    
        UNION ALL
        
        SELECT
            -- NULL AS IDCOMB_SATELITE,
            -- NULL AS SOCIEDADE_CONTRAPARTE,
            C.IDCOMB_SATELITE, 
            C.SOCIEDADE_CONTRAPARTE,
            
            
            NULL as CEMPRESA_CT,
            NULL as CBALCAO_CT,
            NULL as CNUMECTA_CT,
            NULL as ZDEPOSIT_CT,
            
            C.CARGABAL_VC,
            C.VALOR_CARGABAL_VC,
            C.PROPERTY_BRANCH_CODE_ADJUD,
            C.PROPERTY_CONTRACT_ID_ADJUD,
            C.PROPERTY_REFERENCE_CODE_ADJUD,
            
            C.EPC,
            C.QUALITY_SCORE,
            C.EP_SCORE,
            C.COUNTRY_CODE, 
            '' AS CPAIS_RESIDENCIA
            
        FROM
            (
            SELECT
                UNIV_FULL.IDCOMB_SATELITE, 
                UNIV_FULL.SOCIEDADE_CONTRAPARTE,
            
                PROPERTY_BANK_ID_ADJUD, 
                PROPERTY_BRANCH_CODE_ADJUD,
                PROPERTY_CONTRACT_ID_ADJUD,
                PROPERTY_REFERENCE_CODE_ADJUD,                
                PROPERTY.COUNTRY_CODE,

                ADJUD_INPUTS.CARGABAL_VC, 
                ADJUD_INPUTS.VALOR_CARGABAL_VC * -1 AS VALOR_CARGABAL_VC,

                CERT_ENERG.EPC, 
                CERT_ENERG.QUALITY_SCORE,
                CERT_ENERG.EP_SCORE
            FROM
                (
                SELECT
                    PROPERTY_BANK_ID_ADJUD, 
                    PROPERTY_BRANCH_CODE_ADJUD,
                    PROPERTY_CONTRACT_ID_ADJUD,
                    PROPERTY_REFERENCE_CODE_ADJUD,
                    COD_IMOVEL,
                    CARGABAL_VC, 
                    VALOR_CARGABAL_VC * -1 AS VALOR_CARGABAL_VC
                FROM
                    (
                    SELECT
                        '31' as PROPERTY_BANK_ID_ADJUD,
                        'CMAH' AS PROPERTY_BRANCH_CODE_ADJUD, 
                        'IMOVELGIDAP' AS PROPERTY_CONTRACT_ID_ADJUD, 
                        replace(upper(lpad(COD_IMOVEL,15,'0')),' ', '0') AS PROPERTY_REFERENCE_CODE_ADJUD,
                        COD_IMOVEL,
                        CASE
                            WHEN V_CONTAB_IFRS = '19910000' then '1605010'
                            WHEN V_CONTAB_IFRS = '1910000' then '1605010'
                            WHEN V_CONTAB_IFRS = '19911000' then '160510'
                            WHEN V_CONTAB_IFRS = '19910001' then '2642300'
                            WHEN V_CONTAB_IFRS = '1910008' then '2642300'
                            WHEN V_CONTAB_IFRS = '19911001' then '26423100'
                            WHEN V_CONTAB_IFRS = '199100200' then '1605010'
                            WHEN V_CONTAB_IFRS = '199100210' then '1605010'
                            WHEN V_CONTAB_IFRS = '199100201' then '2642300'
                            WHEN V_CONTAB_IFRS = '199100211' then '2642300'
                            WHEN V_CONTAB_IFRS = '199100240' then '1605000'
                            WHEN V_CONTAB_IFRS = '199100241' then '2642300'
                        END AS CARGABAL_VC, 
                        V_CONTAB AS VALOR_CARGABAL_VC
                    FROM cd_captools.ct666_adjudic_propr
                    WHERE ref_date='${REF_DATE}'
                    AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210')
            
                    UNION ALL
            
                    SELECT
                        '31' AS property_bank_id_ADJUD, 
                        'CMAH' AS PROPERTY_BRANCH_CODE_ADJUD, 
                        'IMOVELRECUP' AS PROPERTY_CONTRACT_ID_ADJUD,
                        lpad(replace( replace( replace( concat( ifnull(upper(n_processo_tc), ''), concat( upper( trim(artigo_matricial) ), concat( ifnull(upper(n_cliente), ''), ifnull(upper(origem), '') ))), '_', '0' ), ' ', '0' ), chr(10), '0' ),15,'0') as property_reference_code,
                        N_CLIENTE AS COD_IMOVEL,
                        CASE
                            WHEN V_CONTAB_IFRS = '19910000' then '1605010'
                            WHEN V_CONTAB_IFRS = '1910000' then '1605010'
                            WHEN V_CONTAB_IFRS = '19911000' then '160510'
                            WHEN V_CONTAB_IFRS = '19910001' then '2642300'
                            WHEN V_CONTAB_IFRS = '1910008' then '2642300'
                            WHEN V_CONTAB_IFRS = '19911001' then '26423100'
                            WHEN V_CONTAB_IFRS = '199100200' then '1605010'
                            WHEN V_CONTAB_IFRS = '199100210' then '1605010'
                            WHEN V_CONTAB_IFRS = '199100201' then '2642300'
                            WHEN V_CONTAB_IFRS = '199100211' then '2642300'
                            WHEN V_CONTAB_IFRS = '199100240' then '1605000'
                            WHEN V_CONTAB_IFRS = '199100241' then '2642300'
                        END AS cargabal_vc,
                        v_contab AS valor_cargabal_vc
                    FROM cd_captools.ct667_dacoes_arrem
                    WHERE ref_date='${REF_DATE}'
                    AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210')
            
                    UNION ALL
            
                    SELECT DISTINCT
                        '89' AS property_bank_id_ADJUD, 
                        'CMAH' AS PROPERTY_BRANCH_CODE_ADJUD, 
                        'IMOVELIFICS' AS PROPERTY_CONTRACT_ID_ADJUD,
                        lpad(n_imovel,15,'0') AS PROPERTY_REFERENCE_CODE_ADJUD,
                        N_IMOVEL AS COD_IMOVEL,
                        CASE
                            WHEN V_CONTAB_IFRS = '19910000' then '1605010'
                            WHEN V_CONTAB_IFRS = '1910000' then '1605010'
                            WHEN V_CONTAB_IFRS = '19911000' then '160510'
                            WHEN V_CONTAB_IFRS = '19910001' then '2642300'
                            WHEN V_CONTAB_IFRS = '1910008' then '2642300'
                            WHEN V_CONTAB_IFRS = '19911001' then '26423100'
                            WHEN V_CONTAB_IFRS = '199100200' then '1605010'
                            WHEN V_CONTAB_IFRS = '199100210' then '1605010'
                            WHEN V_CONTAB_IFRS = '199100201' then '2642300'
                            WHEN V_CONTAB_IFRS = '199100211' then '2642300'
                            WHEN V_CONTAB_IFRS = '199100240' then '1605000'
                            WHEN V_CONTAB_IFRS = '199100241' then '2642300'
                        END AS cargabal_vc,
                        v_contab AS valor_cargabal_vc
                    FROM cd_captools.ct668_imoveis_ific
                    WHERE ref_date='${REF_DATE}'
                    AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210')
                    ) X

                WHERE CONCAT(property_bank_id_ADJUD,PROPERTY_BRANCH_CODE_ADJUD,PROPERTY_CONTRACT_ID_ADJUD,property_reference_code_ADJUD) IN (
                                                                                                                SELECT 
                                                                                                                    CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) 
                                                                                                                FROM cd_captools.ct001_univ_saldo 
                                                                                                                WHERE ref_date='${REF_DATE}' 
                                                                                                                AND ccontab_final_idcomb LIKE '%MC1005%'
                                                                                                                )

                ) ADJUD_INPUTS
            
                LEFT JOIN
                
                (
            	SELECT DISTINCT
            	   PROPERTY_BRANCH_CODE,
            	   PROPERTY_CONTRACT_ID, 
            	   PROPERTY_REFERENCE_CODE,
            	   COUNTRY_CODE
            	FROM BU_ESG_WORK.PROPERTY
            	WHERE DATA_DATE_PART = '${REF_DATE}'
                ) PROPERTY
            
                ON ADJUD_INPUTS.PROPERTY_BRANCH_CODE_ADJUD = PROPERTY.PROPERTY_BRANCH_CODE
                AND ADJUD_INPUTS.PROPERTY_CONTRACT_ID_ADJUD = PROPERTY.PROPERTY_CONTRACT_ID
                AND ADJUD_INPUTS.PROPERTY_REFERENCE_CODE_ADJUD = PROPERTY.PROPERTY_REFERENCE_CODE
            
                LEFT JOIN
            
                (
                SELECT
                    PROPERTY_BANK_ID, 
                    PROPERTY_BRANCH_CODE,
                    PROPERTY_CONTRACT_ID,
                    PROPERTY_REFERENCE_CODE,
                    EPC,
                    QUALITY_SCORE, 
                    EP_SCORE
                FROM BU_ESG_WORK.PROPERTY_ENERGY_CERTIFICATE
                WHERE DATA_DATE_PART = '${REF_DATE}'
                ) CERT_ENERG

                ON ADJUD_INPUTS.PROPERTY_BANK_ID_ADJUD = CERT_ENERG.PROPERTY_BANK_ID
                AND ADJUD_INPUTS.PROPERTY_BRANCH_CODE_ADJUD = CERT_ENERG.PROPERTY_BRANCH_CODE
                AND ADJUD_INPUTS.PROPERTY_CONTRACT_ID_ADJUD = CERT_ENERG.PROPERTY_CONTRACT_ID
                AND ADJUD_INPUTS.PROPERTY_REFERENCE_CODE_ADJUD = CERT_ENERG.PROPERTY_REFERENCE_CODE
                
                LEFT JOIN
                
                (
                SELECT DISTINCT 
                    IDCOMB_SATELITE,
                    SOCIEDADE_CONTRAPARTE,
                    CARGABAL_CT
                FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL
                WHERE DT_RFRNC = '${REF_DATE}' AND 
                    ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL WHERE DT_RFRNC = '${REF_DATE}') AND 
                	CSATELITE IN (80) AND IDCOMB_SATELITE LIKE '%MC10%'
                ) UNIV_FULL
                
                ON ADJUD_INPUTS.CARGABAL_VC=UNIV_FULL.CARGABAL_CT
            ) C
    ) X

    LEFT JOIN

	(
	SELECT
	    NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
    FROM BU_ESG_WORK.AG080_ENPC_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}'
	) RT
	
	ON 1=1

    WHERE AMOUNT IS NOT NULL
;