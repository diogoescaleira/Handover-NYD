SELECT	distinct 
        CCAE,
		CASE WHEN ref_date <='2024-12-31'
				THEN VALOR_DESTINO
			 WHEN ref_date >'2024-12-31'  AND ref_date <= '2025-11-01' AND TRIM(AUX_2_2025)='' 
				THEN AUX_1 
			 WHEN ref_date >'2024-12-31'  AND ref_date <= '2025-11-01' AND TRIM(AUX_2_2025)<>'' 
				THEN CONCAT( AUX_1, ".", TRIM(AUX_2_2025)) 
			 WHEN ref_date > '2025-11-01' AND TRIM(AUX_2_POST_2025)='' 
				THEN AUX_1
			 WHEN ref_date > '2025-11-01' AND TRIM(AUX_2_POST_2025)<>'' 
				THEN CONCAT( AUX_1, ".", TRIM(AUX_2_POST_2025)) 
		END AS NACE_NEW
From
(
    SELECT DISTINCT
    VALOR_ORIGEM_1,
    VALOR_DESTINO,
    CASE WHEN b.ref_date <= '2024-12-31' 
    					THEN b.ccae
    				 ELSE TRIM(SUBSTR(b.ccae,1,4))
    			END AS CCAE,
    			CASE WHEN b.ref_date >'2024-12-31'  AND b.ref_date <= '2025-11-01' 
    					THEN SUBSTRING(TAYD91C0_NELEMC16, 2, LOCATE('.',TAYD91C0_NELEMC16)-2) 
    				 WHEN b.ref_date > '2025-11-01'
    					THEN SUBSTRING(TAYD91C0_NELEMC18, 2, LOCATE('.',TAYD91C0_NELEMC18)-2)
    			END AS AUX_1,
				
    			CASE WHEN b.ref_date >'2024-12-31'  AND b.ref_date <= '2025-11-01' AND RIGHT(TAYD91C0_NELEMC16, 3) like '.%0' 
    			        THEN REPLACE(SUBSTRING(TAYD91C0_NELEMC16, LOCATE('.',TAYD91C0_NELEMC16)+1, length(TAYD91C0_NELEMC16)),'0','') 
    			     WHEN b.ref_date >'2024-12-31'  AND b.ref_date <= '2025-11-01' AND RIGHT(TAYD91C0_NELEMC16, 3) not like '.%0'    
    					THEN SUBSTRING(TAYD91C0_NELEMC16, LOCATE('.',TAYD91C0_NELEMC16)+1) 
    			END AS AUX_2_2025,
				
    			CASE WHEN b.ref_date >= '2025-11-01' AND RIGHT(TAYD91C0_NELEMC18, 3) like '.%0' 
    					THEN REPLACE(SUBSTRING(TAYD91C0_NELEMC18, LOCATE('.',TAYD91C0_NELEMC18)+1, length(TAYD91C0_NELEMC18)),'0','') 
    				WHEN b.ref_date >= '2025-11-01' AND RIGHT(TAYD91C0_NELEMC18, 3) not like '.%0' 
    					THEN SUBSTRING(TAYD91C0_NELEMC18, LOCATE('.',TAYD91C0_NELEMC18)+1,length(TAYD91C0_NELEMC18)) 	
    			END AS AUX_2_POST_2025
    	FROM (SELECT DISTINCT ref_date,ccae FROM cd_captools.CT003_UNIV_CLI --where CCAE LIKE '16240'
    	) B
    	LEFT JOIN 
    		(SELECT * FROM cd_loan_tapes_bce.LT831_PARAM_CONCEITOS 
    		WHERE CAMPO_CONCEITO = 'ECNMC_ACTVTY' --and trim(valor_origem_1)='1624'
    		) C
    	ON C.VALOR_ORIGEM_1 = TRIM(SUBSTR(b.CCAE,1,4)) 
    	AND b.ref_date <= '2024-12-31' AND C.ref_date <= '2024-12-31'
    	LEFT JOIN 
    		(SELECT * FROM CD_ESTRUTURAIS.TAT91_TABELAS
    			WHERE TAYD91C0_CTABELA = '154') D
    	ON D.TAYD91C0_CELEMTAB = B.CCAE AND b.ref_date > '2024-12-31' 
    	AND D.data_date_part  > '2024-12-31'
) xx