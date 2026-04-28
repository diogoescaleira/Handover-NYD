/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: Bs & Neyond                                                                                                                ****
****   Data: 29/04/2025                                                                                                                  ****
****   Sql Script Descrição: Geração Do Satélite 80  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: obtenção do universo a reportar no âmbito do satélite 80 + marcação de metricas relevantes         			       */
/*=========================================================================================================================================*/


-- DROP TABLE BU_ESG_WORK.AG080_ENPC_CTO_GRA;

-- CREATE TABLE BU_ESG_WORK.AG080_ENPC_CTO_GRA AS

SELECT
    X.*,
    -- CASE
		-- WHEN TRIM(B.FIABILIDAD) IN ('7-SIN DATO', NULL) THEN 'EPSD3'
		-- WHEN TRIM(B.FIABILIDAD) = '7-SIN DATO' OR B.FIABILIDAD IS NULL THEN 'EPSD3'
		-- WHEN CONSUMOS IS NULL THEN 'EPSD3'
		-- ELSE 'EPSD2' -- QUANDO HOUVER UMA NOVA TABELA COM AS FIABILIDADES DE CONSUMO TEMOS DE DESDOBRAR ISTO EM CONDIÇÕES COMO CONSUMO REAL E ESTIMADO
	-- END AS EP_SCORE_DATA, -- CONSUMOS ATUALMENTE VÊM TODOS DA GLOVAL POR ISSO SÃO TODOS ESTIMADOS --PASSAMOS A TER HIPÓTESE DE TER CONSUMOS REAIS (EPSD1)	
	
    CASE
        WHEN CONSUMOS IS NOT NULL THEN 'EPSD2'
        WHEN CONSUMOS IS NULL THEN 'EPSD3'
    END AS EP_SCORE_DATA,
    
    -- 'EPSD2' AS EP_SCORE_DATA, --OS CONSUMOS DOS IMÓVEIS ADJUDICADOS SÃO TODOS ESTIMADOS
    
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
	ELSE '' END AS EUROPEAN_UNION
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
    	B.`13_GROSS_CARRYING_AMOUNT` AS AMOUNT,
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
        	  GAR.CEMPRESA_CT,
        	  GAR.CBALCAO_CT,
        	  GAR.CNUMECTA_CT,
        	  GAR.ZDEPOSIT_CT,
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
        	FROM BU_ESG_WORK.P3_REPARTICAO_GARANTIAS
        	WHERE DT_RFRNC='${REF_DATE}'
        		AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.P3_REPARTICAO_GARANTIAS WHERE DT_RFRNC = '${REF_DATE}') 
        
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
         ) PROPERTY 
         
         --GAR.CEMPBEM = PROPERTY.PROPERTY_BANK_ID AND
         ON GAR.CKBALBEM = PROPERTY.PROPERTY_BRANCH_CODE 
         AND GAR.CKCTABEM = PROPERTY.PROPERTY_CONTRACT_ID 
         AND GAR.CKREFBEM = PROPERTY.PROPERTY_REFERENCE_CODE 
        
        LEFT JOIN
        -- LIGAÇÃO COM A TABELA PROPERTY_ENERGY_CERTIFICATE PARA OBTENÇÃO DE CAMPOS DE CERTIFICADOS ENERGÉTICOS
         (
          SELECT *
          FROM BU_ESG_WORK.PROPERTY_ENERGY_CERTIFICATE
          WHERE DATA_DATE_PART = '${REF_DATE}'
         ) CERT_ENERG
         
         ON GAR.CKBALBEM = CERT_ENERG.PROPERTY_BRANCH_CODE
         AND GAR.CKCTABEM = CERT_ENERG.PROPERTY_CONTRACT_ID 
         AND GAR.CKREFBEM = CERT_ENERG.PROPERTY_REFERENCE_CODE
        
        GROUP BY 
          GAR.CEMPRESA_CT,
          GAR.CBALCAO_CT,
          GAR.CNUMECTA_CT,
          GAR.ZDEPOSIT_CT,
          GAR.CKBALBEM, 
          GAR.CKCTABEM,
          GAR.CKREFBEM,
          GAR.CPAIS_RESIDENCIA, 
          CERT_ENERG.EPC, 
          CERT_ENERG.QUALITY_SCORE,
          CERT_ENERG.EP_SCORE,
          PROPERTY.COUNTRY_CODE
        ) AS B
        
        ON  A.CEMPRESA_CT = B.CEMPRESA_CT
        AND A.CBALCAO_CT  = B.CBALCAO_CT
        AND A.CNUMECTA_CT = B.CNUMECTA_CT
        AND A.ZDEPOSIT_CT = B.ZDEPOSIT_CT
    
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
            C.CONSUMOS,
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
                CERT_ENERG.CONSUMOS
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
                    Q1.PROPERTY_BANK_ID,
                    Q1.PROPERTY_BRANCH_CODE,
                    Q1.PROPERTY_CONTRACT_ID,
                    Q1.PROPERTY_REFERENCE_CODE,

                    -- CONCAT(Q1.property_bank_id,Q1.property_branch_code,Q1.property_contract_id,Q1.property_reference_code) AS CHAVE_BEM,
                    Q2.classe_energetica AS EPC,                    
                    CASE 
                        WHEN TRIM(Q2.FIABILIDAD)='SANTANDER' THEN '1-REAL' 
                        ELSE Q2.FIABILIDAD 
                    END AS QUALITY_SCORE,                    
                    Q2.CONSUMOS AS CONSUMOS,
                    Q2.EMISSIONES AS CARBON_EMISSION_VALUE_YEAR
                FROM 
                    (
                    SELECT *
                    FROM 
                        (
                        SELECT 
                            data_envio,
                            property_bank_id,
                            property_branch_code,
                            property_contract_id,
                            property_reference_code,
                            chave_gloval,
                            RANK() OVER (PARTITION BY CONCAT(NVL(property_bank_id,''),NVL(property_branch_code,''),NVL(property_contract_id,''),NVL(property_reference_code,'')) ORDER BY DATA_ENVIO DESC) AS RANK_1
                            FROM 
                                (
                                SELECT DISTINCT 
                                    data_envio,
                                    property_bank_id,
                                    property_branch_code,
                                    property_contract_id,
                                    property_reference_code,
                                    chave_gloval 
                                FROM cd_esg.energy_certificate_est_input
                                ) X

                                WHERE 1=1 --TRIM(classe_energetica) NOT IN ('+','-','S','N','J','')
                                AND TRIM(data_envio)<>''
                        ) AUX
                        
                        WHERE RANK_1=1 
                    ) Q1
                
                    LEFT JOIN

                    (
                    SELECT *
                    FROM
                        (
                        SELECT *,
                            RANK() OVER (PARTITION BY CHAVE_GLOVAL ORDER BY FLAG_ORDEM_EPC DESC, FLAG_ORDEM_FIABI DESC, AVG_VALUES DESC) AS RANK_TRAT_2
                        FROM
                        (
                        SELECT 
                            chave_gloval,
                            ref_date,
                            FIABILIDAD,
                            classe_energetica,
                            EMISSIONES,
                            CONSUMOS,
                            RANK() OVER (PARTITION BY CHAVE_GLOVAL ORDER BY REF_DATE DESC) AS RANK_TRAT,
                            CASE 
                                WHEN TRIM(classe_energetica)='A+' THEN 1
                                WHEN TRIM(classe_energetica)='A' THEN 2
                                WHEN TRIM(classe_energetica)='A-' THEN 3
                                WHEN TRIM(classe_energetica)='B+' THEN 4
                                WHEN TRIM(classe_energetica)='B' THEN 5
                                WHEN TRIM(classe_energetica)='B-' THEN 6
                                WHEN TRIM(classe_energetica)='C' THEN 7
                                WHEN TRIM(classe_energetica)='D' THEN 8
                                WHEN TRIM(classe_energetica)='E' THEN 9
                                WHEN TRIM(classe_energetica)='F' THEN 10
                                WHEN TRIM(classe_energetica)='G' THEN 11
                                WHEN TRIM(classe_energetica)='' THEN 12
                            END AS FLAG_ORDEM_EPC,

                            CASE
                                WHEN TRIM(FIABILIDAD) IN ('SANTANDER','1-REAL') THEN 1
                                WHEN TRIM(FIABILIDAD) ='2-MUY ALTA' THEN 2
                                WHEN TRIM(FIABILIDAD)='3-ALTA' THEN 3
                                WHEN TRIM(FIABILIDAD) ='4-MEDIA' THEN 4
                                WHEN TRIM(FIABILIDAD) ='5-MEDIA BAJA' THEN 5
                                WHEN TRIM(FIABILIDAD) ='6-BAJA' THEN 6
                                WHEN TRIM(FIABILIDAD) ='7-SIN DATO' THEN 7
                                WHEN TRIM(FIABILIDAD) ='' THEN 8
                            END AS FLAG_ORDEM_FIABI,
                            0.5*(NVL(EMISSIONES,0)+NVL(CONSUMOS,0)) AS AVG_VALUES                            
                        FROM 
                            (
                            SELECT DISTINCT 
                                chave_gloval,
                                ref_date,
                                FIABILIDAD,
                                classe_energetica,
                                EMISSIONES,
                                CONSUMOS 
                            FROM cd_esg.energy_certificate_est_input
                            ) Y

                            WHERE 1=1 --TRIM(classe_energetica) NOT IN ('+','-','S','N','J','')'

                            ) AUX 
                            WHERE RANK_TRAT=1 
                    ) AUX_2 
                    WHERE RANK_TRAT_2=1
                ) Q2 
            
                ON Q1.chave_gloval=Q2.CHAVE_GLOVAL
                ) CERT_ENERG
                
                ON ADJUD_INPUTS.COD_IMOVEL=CERT_ENERG.PROPERTY_BRANCH_CODE

                LEFT JOIN
                
                (
                SELECT DISTINCT 
                    IDCOMB_SATELITE,
                    SOCIEDADE_CONTRAPARTE,
                    -- CEMPRESA_CT, 
                    -- CBALCAO_CT,
                    -- CNUMECTA_CT, 
                    -- ZDEPOSIT_CT,
                    CARGABAL_CT
                FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL
                WHERE DT_RFRNC = '${REF_DATE}' AND 
                    ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL WHERE DT_RFRNC = '${REF_DATE}') AND 
                	CSATELITE IN (80) AND IDCOMB_SATELITE LIKE '%MC10%'
                ) UNIV_FULL
                
                ON ADJUD_INPUTS.CARGABAL_VC=UNIV_FULL.CARGABAL_CT
            ) C
    ) X
    
    WHERE AMOUNT IS NOT NULL
    ;
