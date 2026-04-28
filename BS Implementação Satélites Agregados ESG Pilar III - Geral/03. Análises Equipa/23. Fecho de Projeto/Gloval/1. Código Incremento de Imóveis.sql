-- CREATE TABLE BU_ESG_WORK.FICHEIRO_GLOVAL_PN_JUN25 AS

WITH AA AS(

SELECT DISTINCT
    PROPERTY_BANK_ID, 
    PROPERTY_BRANCH_CODE, 
    PROPERTY_CONTRACT_ID, 
    PROPERTY_REFERENCE_CODE, 
    concat(PROPERTY_BANK_ID, PROPERTY_BRANCH_CODE, PROPERTY_CONTRACT_ID, PROPERTY_REFERENCE_CODE) AS CHAVE_BEM,
    -- CHAVE_GLOVAL
    REPLACE(CODIGO_DISTRITO,";"," ") AS CODIGO_DISTRITO, 
    REPLACE(NOME_DISTRITO,";"," ") AS NOME_DISTRITO,
    REPLACE(CODIGO_CONCEJO,";"," ") AS CODIGO_CONCEJO,
    REPLACE(NOMBRE_CONCEJO,";"," ") AS NOMBRE_CONCEJO,
    REPLACE(CODIGO_FREGUESIA,";"," ") AS CODIGO_FREGUESIA,
    REPLACE(NOMBRE_FREGUESIA,";"," ") AS NOMBRE_FREGUESIA,
    REPLACE(LOCALIDADE,";"," ") AS LOCALIDADE, 
    REPLACE(TIPO_VIA,";"," ") AS TIPO_VIA,
    REPLACE(NOMBRE_TIPO_VIA,";"," ") AS NOMBRE_TIPO_VIA,
    REPLACE(NOMBRE_VIA,";"," ") AS NOMBRE_VIA,
    REPLACE(NUMERO_VIA,";"," ") AS NUMERO_VIA, 
    REPLACE(LOTE,";"," ") AS LOTE, 
    REPLACE(URBANIZACION,";"," ") AS URBANIZACION, 
    REPLACE(CAGLURB,";"," ") AS CAGLURB,
    REPLACE(RESTO_DIRECCION,";"," ") AS RESTO_DIRECCION, 
    '' AS LATITUDE, 
    '' AS LONGITUDE, 
    REPLACE(CODIGO_POSTAL,";"," ") AS CODIGO_POSTAL,
    REPLACE(SUBCODIGO_POSTAL,";"," ") AS SUBCODIGO_POSTAL, 
    REPLACE(CAST(ASSUPERFICIE_UTIL AS STRING),";"," ") AS ASSUPERFICIE_UTIL,
    REPLACE(ANIO_CONSTRUCCION,";"," ") AS ANIO_CONSTRUCCION,
    TIPO_INMUEBLE_HABITACAO, 
    PISO_APARTAMENTO, 
    CASA_UNIFAMILIAR, 
    TIPO_INMUEBLE_COMERCIO_SERVICOS, 
    REPLACE(COALESCE(TAT91E.TAYD91C0_GELEMTAB,''),";"," ") AS NOME_CONSERVATORIA,
    COALESCE(REPLACE(COD_CONSERVATORIA,";"," "),"") AS COD_CONSERVATORIA, 
    REPLACE(REGISTRO_CONSERVATORIA,";"," ") AS REGISTRO_CONSERVATORIA,
    REPLACE(ART_MATRICIAIS,";"," ") AS ART_MATRICIAIS, 
    COALESCE(REPLACE(FRACCAO_AUTONOMA,";"," "),"") AS FRACCAO_AUTONOMA, 
    REPLACE(FINALIDADE_BEM_2,";"," ") AS FINALIDADE_BEM, 
    COALESCE(CLASS_EPC,"") AS CLASS_EPC,
    '' AS CLASS_STCLIM, 
    '' AS CONF_STCLIM    

FROM
    (
    SELECT
        B.*,
        CASE
            WHEN A.CHAVE_ENERGY_CERTIFICATE IS NULL AND B.CHAVE_PROPERTY IS NOT NULL THEN 'EXCLUSIVO PROPERTY'
            WHEN A.CHAVE_ENERGY_CERTIFICATE IS NOT NULL AND B.CHAVE_PROPERTY IS NULL THEN 'EXCLUSIVO ENERGY CERTIFICATE'
            WHEN A.CHAVE_ENERGY_CERTIFICATE IS NOT NULL AND B.CHAVE_PROPERTY IS NOT NULL THEN 'COMUM'
        END AS ANALISE_UNIV,
        COALESCE(GPT14C.CODCONSV, CST08.CCONSERV) AS COD_CONSERVATORIA,
        
        -- COALESCE(CST08.CCONSERV,'') AS COD_CONSERVATORIA,
        -- coalesce(GPT14a.codconsv,aux3.cod_conservatoria)
        
        CASE 
            WHEN GPT14B.CKCTABEM IS NOT NULL THEN GPT14B.GFRACCAO
            ELSE GPT14A.GFRACCAO
        END AS FRACCAO_AUTONOMA,
        COALESCE(TAT91A.TAYD91C0_GELEMTAB,'') AS NOME_DISTRITO,
        COALESCE(TAT91B.TAYD91C0_GELEMTAB,'') AS NOMBRE_CONCEJO,
        COALESCE(TAT91C.TAYD91C0_GELEMTAB,'') AS NOMBRE_FREGUESIA,
        COALESCE(TAT91F.TAYD91C0_GELEMTAB, '') AS NOMBRE_TIPO_VIA,
        COALESCE(TAT91F.TAYD91C0_GELEMTAB, '') AS CAGLURB,
        -- COALESCE(TAT91E.TAYD91C0_GELEMTAB,'') AS NOME_CONSERVATORIA,
        COALESCE(TAT91D.TAYD91C0_GELEMTAB,'') AS FINALIDADE_BEM_2,

		CASE 
			WHEN PROPERTY.EPC IS NOT NULL AND SOURCE_CODE = 'ADENE' THEN PROPERTY.EPC
			WHEN PROPERTY.EPC IS NOT NULL AND SOURCE_CODE = 'OCR' THEN PROPERTY.EPC
			WHEN PROPERTY.EPC IS NOT NULL AND SOURCE_CODE = 'GPT31' THEN PROPERTY.EPC
		END AS CLASS_EPC
        
    FROM
        (
        SELECT DISTINCT
            CONCAT(PROPERTY_BANK_ID, PROPERTY_BRANCH_CODE, PROPERTY_CONTRACT_ID, PROPERTY_REFERENCE_CODE) AS CHAVE_ENERGY_CERTIFICATE
        FROM CD_ESG.ENERGY_CERTIFICATE_EST_INPUT
        -- WHERE DATA_ENVIO<>''
        WHERE PROPERTY_BANK_ID IS NOT NULL
        AND PROPERTY_CONTRACT_ID IS NOT NULL
        AND PROPERTY_REFERENCE_CODE IS NOT NULL
        ) A
        
        FULL JOIN
     
        (
        SELECT
            PROPERTY_BANK_ID,
            PROPERTY_BRANCH_CODE, 
            PROPERTY_CONTRACT_ID, 
            PROPERTY_REFERENCE_CODE,
            COALESCE(SUBSTRING(DISTRICT_MUNICIP_PARISH_CODE,1,2),'') AS CODIGO_DISTRITO,
            COALESCE(SUBSTRING(DISTRICT_MUNICIP_PARISH_CODE,3,2),'') AS CODIGO_CONCEJO,
            COALESCE(SUBSTRING(DISTRICT_MUNICIP_PARISH_CODE,5,2),'') AS CODIGO_FREGUESIA,
            COALESCE(LOCALITY,'') AS LOCALIDADE,
    		COALESCE(ADDRESS_CODE,'') AS TIPO_VIA,
            COALESCE(ADDRESS,'') AS NOMBRE_VIA,
            COALESCE(PROPERTY_NUMBER,'') AS NUMERO_VIA,
            COALESCE(PROPERTY_LOT,'') AS LOTE,
            COALESCE(URBANIZATION,'') AS URBANIZACION,
            COALESCE(SUBSTRING(POSTAL_CODE,1,4),'') AS CODIGO_POSTAL,
            
            CASE 
    		    WHEN SUBSTRING((COALESCE(SUBSTRING(POSTAL_CODE,5,3),'')),3,1)= ' ' THEN ''
    		    ELSE COALESCE(SUBSTRING(POSTAL_CODE,5,3),'')
    		END AS SUBCODIGO_POSTAL,
    		NET_FLOOR_AREA AS ASSUPERFICIE_UTIL,
    		
        	CASE
                WHEN (TRIM(PROPERTY_PURPOSE_CODE) IN ('01','06','07')) OR (TRIM(PROPERTY_PURPOSE_CODE) = '08' AND TRIM(PROPERTY_TYPE_CODE) IN ('1121','1130')) THEN 1
                ELSE 0
            END AS TIPO_INMUEBLE_HABITACAO,
            
            CASE
                WHEN ((TRIM(PROPERTY_PURPOSE_CODE) IN ('01','06','07')) OR (TRIM(PROPERTY_PURPOSE_CODE) = '08' AND TRIM(PROPERTY_TYPE_CODE) IN ('1121','1130'))) AND PROPERTY_TYPE_CODE IN ('1112','1122','1130') THEN 1
                ELSE 0
            END AS PISO_APARTAMENTO,
            
            CASE
                WHEN ((TRIM(PROPERTY_PURPOSE_CODE) IN ('01','06','07')) OR (TRIM(PROPERTY_PURPOSE_CODE) = '08' AND TRIM(PROPERTY_TYPE_CODE) IN ('1121','1130'))) AND PROPERTY_TYPE_CODE in ('1121') THEN 1
            ELSE 0
            END AS CASA_UNIFAMILIAR,
            
            CASE
                WHEN TRIM(PROPERTY_PURPOSE_CODE) IN ('02','03','04','05') THEN 1 
                ELSE 0
            END AS TIPO_INMUEBLE_COMERCIO_SERVICOS,
            
        COALESCE(CADASTRAL_REGISTER_CODE,'') AS ART_MATRICIAIS,
        FLOOR_NUMBER AS RESTO_DIRECCION,
        CONSERVATORY_REG_FILE_ID AS REGISTRO_CONSERVATORIA,
		COALESCE(PROPERTY_PURPOSE_CODE, '') AS FINALIDADE_BEM,
		CONSTRUCTION_YEAR AS ANIO_CONSTRUCCION,
        CONCAT(property_bank_id, property_branch_code, property_contract_id, property_reference_code) AS CHAVE_PROPERTY
        
        FROM business_assets.property
        WHERE data_date_part='${REF_DATE}'
        ) B
        
        ON A.CHAVE_ENERGY_CERTIFICATE=B.CHAVE_PROPERTY
        
        LEFT JOIN
        
        (
        SELECT DISTINCT 
            A.*
        FROM 
            (
            SELECT DISTINCT *
            FROM CD_GARANTIAS.CST08_CAUCBEM
            WHERE DATA_DATE_PART = '${REF_DATE}'
            ) A
            
            INNER JOIN
            
            (
            SELECT 
                CKBALCAO, 
                CKNUMCTA, 
                ZBEM, 
                ZCAUCAO, 
                MAX(DAVALIA) AS DAVALIA
            from CD_GARANTIAS.CST08_CAUCBEM 
            WHERE DATA_DATE_PART IN (
                                    SELECT 
                                        MAX(DATA_DATE_PART) 
                                    FROM CD_GARANTIAS.CST08_CAUCBEM
                                    WHERE DATA_DATE_PART <= '${REF_DATE}'
                                    )
            AND DAVALIA<>'0001-01-01'
            GROUP BY 1,2,3,4
            ) AS B 
            
            ON A.CKBALCAO = B.CKBALCAO
            AND A.CKNUMCTA = B.CKNUMCTA
            AND A.ZBEM = B.ZBEM
            AND A.ZCAUCAO = B.ZCAUCAO
            AND A.DAVALIA = B.DAVALIA
        ) AS CST08
        
        ON B.PROPERTY_BRANCH_CODE = CST08.CKBALCAO 
        AND B.PROPERTY_CONTRACT_ID = CST08.CKNUMCTA
        AND CAST(SUBSTR(PROPERTY_REFERENCE_CODE,1,10) AS INT) = CST08.ZCAUCAO
        AND cast(SUBSTR(PROPERTY_REFERENCE_CODE,11,5) AS INT) = CST08.ZBEM
        
        LEFT JOIN
        
        (
    	SELECT 
    	    CKBALBEM, 
    	    CKCTABEM, 
    	    GFRACCAO
    	FROM
    	    (
    	    SELECT
    	        ROW_NUMBER () OVER (PARTITION BY CEMPBEM,CKBALBEM,CKCTABEM ORDER BY GFRACCAO DESC) AS ORDEM, 
    	        CEMPRESA, 
    	        CKBALCAO,
    	        CKNUMCTA, 
    	        MAX_ZVERSAO, 
    	        CEMPBEM,
    	        CKBALBEM, 
    	        CKCTABEM, 
    	        GFRACCAO
    	    FROM
    	        (
    		    SELECT 
    		        CEMPRESA,
    		        CKBALCAO,
    		        CKNUMCTA,
    		        MAX(ZVERSAO) AS MAX_ZVERSAO, 
    		        CEMPBEM,
    		        CKBALBEM,
    		        CKCTABEM,
    		        TRIM(REPLACE(GFRACCAO,'"','')) AS GFRACCAO
    		    FROM CD_EMPRESTIMOS.GPT14_REGISTOS
    		    WHERE DATA_DATE_PART IN (
    		                            SELECT 
    		                                MAX(DATA_DATE_PART) 
    		                            FROM CD_EMPRESTIMOS.GPT14_REGISTOS 
    		                            WHERE DATA_DATE_PART <= '${REF_DATE}'
    		                            )
    		    AND TRIM(GFRACCAO) NOT LIKE '' 
    		    AND TRIM(GFRACCAO) NOT LIKE '.' 
    		    GROUP BY CEMPRESA, CKBALCAO, CKNUMCTA, CEMPBEM, CKBALBEM, CKCTABEM, GFRACCAO
    	        ) BL
    	    ) FS_2
    	    WHERE ORDEM = 1
        ) AS GPT14A
    
    ON  PROPERTY_BRANCH_CODE = GPT14A.CKBALBEM
    AND PROPERTY_CONTRACT_ID = GPT14A.CKCTABEM
    
    LEFT JOIN
    
    (
    SELECT 
        X.CKBALBEM, 
        X.CKCTABEM, 
        XX.GFRACCAO
    FROM
        (
        SELECT 
            CKBALBEM, 
            CKCTABEM, 
            COUNT(DISTINCT GFRACCAO) AS N
        FROM 
            (
            SELECT 
                ROW_NUMBER () OVER (PARTITION BY CEMPBEM,CKBALBEM,CKCTABEM ORDER BY GFRACCAO DESC) AS ORDEM,
                CEMPRESA,
    	        CKBALCAO,
    	        CKNUMCTA, 
    	        MAX_ZVERSAO, 
    	        CEMPBEM,
    	        CKBALBEM, 
    	        CKCTABEM, 
    	        GFRACCAO
            FROM
                (
            	SELECT 
            	    CEMPRESA,
            	    CKBALCAO,
            	    CKNUMCTA,
            	    MAX(ZVERSAO) AS MAX_ZVERSAO,
            	    CEMPBEM,
            	    CKBALBEM,
            	    CKCTABEM,
            	    TRIM(REPLACE(GFRACCAO,'"','')) AS GFRACCAO
            	from CD_EMPRESTIMOS.GPT14_REGISTOS
            	WHERE DATA_DATE_PART IN (   
            	                        SELECT 
            	                            MAX(DATA_DATE_PART) 
            	                        FROM CD_EMPRESTIMOS.GPT14_REGISTOS 
            	                        WHERE DATA_DATE_PART <= '${REF_DATE}'
            	                        )
                AND TRIM(GFRACCAO) NOT LIKE '' 
                AND TRIM(GFRACCAO) NOT LIKE '.' 
            	GROUP BY CEMPRESA, CKBALCAO, CKNUMCTA, CEMPBEM, CKBALBEM, CKCTABEM, GFRACCAO
                ) BL 
            ) FS_2
            
        WHERE ORDEM = 1
        GROUP BY 1,2
        HAVING N>1
        ) X 
        
        INNER JOIN
        
        (
        SELECT 
            CKBALBEM, 
            CKCTABEM, 
            GFRACCAO
        FROM 
            (
            SELECT 
                ROW_NUMBER () OVER (PARTITION BY CKBALBEM, CKCTABEM ORDER BY LENGTH(TRIM(GFRACCAO)) DESC, GFRACCAO DESC) AS ORDEM,
                CKBALBEM,
                CKCTABEM,
                GFRACCAO,
                LENGTH(TRIM(GFRACCAO))
            FROM
                (
            	SELECT DISTINCT 
            	    CKBALBEM,
            	    CKCTABEM,
            	    TRIM(REPLACE(GFRACCAO,'"','')) AS GFRACCAO
            	FROM CD_EMPRESTIMOS.GPT14_REGISTOS
            	WHERE DATA_DATE_PART IN (   
            	                        SELECT 
            	                            MAX(DATA_DATE_PART) 
                                        FROM CD_EMPRESTIMOS.GPT14_REGISTOS WHERE DATA_DATE_PART <= '${REF_DATE}'
                                        )
            	                        AND TRIM(GFRACCAO) NOT LIKE '' 
            	                        AND TRIM(GFRACCAO) NOT LIKE '.' 
                ) BL 
            ) FS_2
            WHERE ORDEM = 1
        ) XX
        
        ON X.ckbalbem=XX.ckbalbem AND X.ckctabem=XX.ckctabem
    ) GPT14B
    
    ON PROPERTY_BRANCH_CODE = GPT14B.CKBALBEM
    and PROPERTY_CONTRACT_ID = GPT14B.CKCTABEM

    LEFT JOIN

    (
	SELECT 
	    CKBALBEM,
	    CKCTABEM,
	    CODCONSV
	FROM
        (
        SELECT 
            ROW_NUMBER () OVER (PARTITION BY CKBALBEM,CKCTABEM ORDER BY CKBALCAO, ZVERSAO DESC) AS ORDEM,
            CKBALBEM,
            CKCTABEM,
            CODCONSV
        FROM
            (
		    SELECT 
		        A.CKBALCAO,
		        A.ZVERSAO,
		        A.CKNUMCTA,
		        A.CKBALBEM,
		        A.CKCTABEM,
		        A.CODCONSV
		    FROM
                (
		        SELECT 
		            CKBALCAO,
		            CKNUMCTA,
		            ZVERSAO,
		            CKBALBEM,
		            CKCTABEM,
		            CODCONSV
		        FROM CD_EMPRESTIMOS.GPT14_REGISTOS
		        WHERE DATA_DATE_PART IN (
		                                SELECT 
		                                    MAX(DATA_DATE_PART) 
                                        FROM CD_EMPRESTIMOS.GPT14_REGISTOS 
                                        WHERE DATA_DATE_PART <= '${REF_DATE}'
                                        ) 
                AND TRIM(CODCONSV) NOT LIKE '' AND TRIM(CODCONSV) <> '999' 
                ) A
                
		        LEFT JOIN
		        
		        (
		        SELECT 
		            CEMPRESA,
		            CKBALCAO,
		            CKNUMCTA,
		            ZSEQVER
		        FROM CD_EMPRESTIMOS.GPT21_PROCESSOS
		        WHERE DATA_DATE_PART IN (
		                                SELECT 
		                                    MAX(DATA_DATE_PART) 
		                                FROM CD_EMPRESTIMOS.GPT14_REGISTOS 
		                                WHERE data_date_part <= '${REF_DATE}'
		                                )
		        ) B
		        
		        
		        ON CONCAT(A.CKBALCAO,A.CKNUMCTA,CAST(A.ZVERSAO AS STRING))=CONCAT(B.CKBALCAO,B.CKNUMCTA,CAST(B.ZSEQVER AS STRING))
		        ) BL 
		    ) FS_2
		WHERE ORDEM = 1
    ) AS GPT14C

    ON  PROPERTY_BRANCH_CODE = GPT14C.CKBALBEM
    AND PROPERTY_CONTRACT_ID = GPT14C.CKCTABEM

    LEFT JOIN 
    
    (
    SELECT *
    FROM CD_ESTRUTURAIS.TAT91_TABELAS
    WHERE DATA_DATE_PART IN (
                            SELECT 
                                MAX(DATA_DATE_PART) 
                            FROM CD_ESTRUTURAIS.TAT91_TABELAS 
                            WHERE DATA_DATE_PART <= '${REF_DATE}'
                            )
    AND TAYD91C0_CTABELA = 'J48'
    ) AS TAT91A
    
    ON CONCAT(B.CODIGO_DISTRITO,'0000')=TRIM(TAT91A.TAYD91C0_CELEMTAB)

    LEFT JOIN 
    
    (
    SELECT *
    FROM CD_ESTRUTURAIS.TAT91_TABELAS
    WHERE DATA_DATE_PART IN (
                            SELECT 
                                MAX(DATA_DATE_PART) 
                            FROM CD_ESTRUTURAIS.TAT91_TABELAS 
                            WHERE DATA_DATE_PART <= '${REF_DATE}'
                            ) 
    AND TAYD91C0_CTABELA = 'J48'
    ) AS TAT91B

    ON CONCAT(B.CODIGO_DISTRITO,B.CODIGO_CONCEJO,'00')=TRIM(TAT91B.TAYD91C0_CELEMTAB)

    LEFT JOIN 
    
    (
    SELECT * 
    FROM CD_ESTRUTURAIS.TAT91_TABELAS
    WHERE DATA_DATE_PART IN    (
                                SELECT 
                                    MAX(DATA_DATE_PART) 
                                FROM CD_ESTRUTURAIS.TAT91_TABELAS 
                                WHERE DATA_DATE_PART <= '${REF_DATE}'
                                ) 
    AND TAYD91C0_CTABELA = 'J48'
    ) AS TAT91C

    ON CONCAT(B.CODIGO_DISTRITO,B.CODIGO_CONCEJO,B.CODIGO_FREGUESIA)=TRIM(TAT91C.TAYD91C0_CELEMTAB)

    LEFT JOIN 
    
    (
    SELECT * 
    FROM CD_ESTRUTURAIS.TAT91_TABELAS
    WHERE DATA_DATE_PART IN (
                            SELECT 
                                MAX(DATA_DATE_PART) 
                            FROM CD_ESTRUTURAIS.TAT91_TABELAS 
                            WHERE DATA_DATE_PART <= '${REF_DATE}'
                            )
    AND TAYD91C0_CTABELA = '438') as TAT91D
    
    ON TRIM(B.FINALIDADE_BEM) = TRIM(TAT91D.TAYD91C0_CELEMTAB)

    LEFT JOIN 
    
    (
    SELECT * 
    FROM CD_ESTRUTURAIS.TAT91_TABELAS
    WHERE DATA_DATE_PART in (
                            SELECT 
                                MAX(DATA_DATE_PART) 
                            from CD_ESTRUTURAIS.TAT91_TABELAS 
                            WHERE DATA_DATE_PART <= '${REF_DATE}'
                            ) 
    AND TAYD91C0_CTABELA = '437'
    ) AS TAT91F
    
    ON B.TIPO_VIA = TAT91F.TAYD91C0_CELEMTAB

    LEFT JOIN

    (
    SELECT *
    FROM BUSINESS_ASSETS.PROPERTY_ENERGY_CERTIFICATE
    WHERE DATA_DATE_PART='${REF_DATE}' AND SOURCE_CODE IN ('ADENE','OCR','GPT31')
    ) AS PROPERTY

    ON B.PROPERTY_BRANCH_CODE = PROPERTY.PROPERTY_BRANCH_CODE 
    AND B.PROPERTY_CONTRACT_ID = PROPERTY.PROPERTY_CONTRACT_ID 
    AND B.PROPERTY_REFERENCE_CODE = PROPERTY.PROPERTY_REFERENCE_CODE

    ) X
    
    LEFT JOIN 
    
    (
    SELECT * 
    FROM CD_ESTRUTURAIS.TAT91_TABELAS
    WHERE DATA_DATE_PART IN (
                            SELECT 
                                MAX(DATA_DATE_PART) 
                            FROM CD_ESTRUTURAIS.TAT91_TABELAS 
                            WHERE DATA_DATE_PART <= '${REF_DATE}'
                            ) 
    AND TAYD91C0_CTABELA = '190'
    ) AS TAT91E

    ON TRIM(COD_CONSERVATORIA) = TRIM(TAT91E.TAYD91C0_CELEMTAB)

    WHERE X.ANALISE_UNIV='EXCLUSIVO PROPERTY'
)
SELECT *
    -- count(*)
FROM AA
-- 13 072
;





----------------------------------------------------------------
----------------------- TESTE DUPLICADOS -----------------------
----------------------------------------------------------------

WITH AA AS(
SELECT *, 
    count(*) over(PARTITION BY property_bank_id, property_branch_code, property_contract_id, property_reference_code) AS COUNT_R
FROM BU_ESG_WORK.FICHEIRO_GLOVAL_PN_JUN25
)
SELECT
    COUNT_R, 
    count(*)
FROM AA
GROUP BY 1
ORDER BY 1
;