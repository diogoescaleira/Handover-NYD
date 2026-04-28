/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 04/02/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 109  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: Obtenção do universo a reportar no âmbito do Satélite 109 + Marcação de metricas relevantes         			   */
/*=========================================================================================================================================*/

INSERT OVERWRITE TABLE BU_ESG_WORK.AG0109_CTO_R04_GRA PARTITION (REF_DATE)
SELECT * 
FROM (
SELECT DISTINCT
    A.*,
    'CONT1' as CONTINUING_OPERATIONS,
    'R04' AS BASE,
    CASE
        WHEN CMETACOM IN ('AA3000','AA3001','AA2290') THEN 'MC54' 
        WHEN CMETACOM IN ('AA3002','MM1440','EE2200','EE2201') THEN 'MC42'
        WHEN CMETACOM IN ('MM2000','MM4000','MM7300','MM7301','MM7500','JJ7000','EE3000') THEN 'MC54'
        WHEN CMETACOM IN('PP1000','MM1000','MM1050','MM1537') THEN 'MC45'
        WHEN CMETACOM = 'PP2000' THEN 'MC53'
        WHEN CMETACOM IN ('JJ5100','EE6120','EE6200') THEN 'MC41' 
        WHEN CMETACOM IN ('JJ4000','JJ4100','JJ4200') THEN 'MC43' 
        WHEN CMETACOM LIKE 'MM1%' THEN  'MC53'
        WHEN (CMETACOM LIKE 'QQ%' OR CMETACOM LIKE 'SS%' OR CMETACOM LIKE 'SX%') THEN  'MC45'
        WHEN CMETACOM LIKE 'MM%' THEN  'MC52'
        WHEN CMETACOM LIKE 'AA%' THEN 'MC52'
        WHEN CMETACOM LIKE 'CC%' THEN 'MC52'
        WHEN CMETACOM LIKE 'GH%' THEN 'MC54'
        WHEN CMETACOM LIKE 'JJ%' THEN 'MC52'
        WHEN CMETACOM LIKE 'EE%' THEN 'MC52'
        WHEN CMETACOM LIKE 'TT%' THEN 'MC52'
    END AS MAIN_CATEGORY,

    -- 'Fees and commisions income' AS INTEREST_COMMISIONS,
    
    CASE 
		WHEN A.CONTRAPARTE = 'outras empresas nao financeiras' THEN 'COSE1'
		ELSE 'COSE2'
	END AS COMISSION_SECTOR, 

    CASE
        -- Geografias que existiam à data: ver alterações em exercicios futuros
        WHEN A.CONTRAPARTE <> 'outras empresas nao financeiras' THEN '' 	--- de acordo com os MDDs forncedios pela corporação todos os registos que são marcados com COSE2 não reportam a métrica em questão        
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (620) THEN 'GEO3'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (724) THEN 'GEO1'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (826) THEN 'GEO2'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (840) THEN 'GEO4'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (616) THEN 'GEO5'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (276) THEN 'GEO6'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (250) THEN 'GEO7'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (578) THEN 'GEO8'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (484) THEN 'GEO9'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (152) THEN 'GEO10'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (076) THEN 'GEO11'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (032) THEN 'GEO12'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (604) THEN 'GEO13'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (170) THEN 'GEO14'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (858) THEN 'GEO15'
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (600,068,218,862,238,531) THEN 'GEO16' --Rest of Latam 
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (044,060,092,124,136,192,214,222,312,320,533,591,630,666,780) THEN 'GEO17' --Rest of North America
        WHEN CAST(A.CPAIS_RESIDENCIA AS INT) IN (020,040,056,100,191,196,203,208,246,292,300,336,348,352,372,380,428,438,440,442,470,492,498,528,642,643,674,688,703,705,752,756,792,804,807,831,832,833) THEN 'GEO18' --Rest of Europe
        ELSE 'GEO19'
    END AS GEO,
    
    CASE
        WHEN A.CONTRAPARTE <> 'outras empresas nao financeiras' THEN '' --- de acordo com os MDDs forncedios pela corporação todos os registos que são marcados com COSE2 não reportam a métrica em questão
        WHEN CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
            THEN 'EU1'
        WHEN CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
            THEN 'EU2'
        ELSE 'EU2' 
    END AS EUROPEAN_UNION,

    CASE
        WHEN A.CONTRAPARTE <> 'outras empresas nao financeiras' THEN ''	--- de acordo com os MDDs forncedios pela corporação todos os registos que são marcados com COSE2 não reportam a métrica em questão
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'A' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL1'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'D' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL4'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'C' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL3'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'E' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL5'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'F' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL6'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'G' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL7'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'B' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL2'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'H' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL8'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'I' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL9'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'J' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL10'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'L' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL11'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'M' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL12'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'N' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL13'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'O' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL14'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'P' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL15'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'Q' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL16'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'R' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL17'
        WHEN SUBSTR(NFIN.COD_NACE_ESG,1,1) = 'S' AND TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL18'
        WHEN TRIM(A.CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL18'
        ELSE ''
    END AS CNAEL,

    CASE
        WHEN A.CONTRAPARTE <> 'outras empresas nao financeiras' THEN ''	--- de acordo com os MDDs forncedios pela corporação todos os registos que são marcados com COSE2 não reportam a métrica em questão
        WHEN NACE_ESG.NACE_LEVEL4 IS NOT NULL THEN NACE_ESG.ID
        ELSE 'NACE19010303' --Nace default disponibilizado pela corporação
    END AS NACE_CODE_ESG,

    -- PARTICAO
    '${REF_DATE}' AS REF_DATE
FROM
    (
    SELECT 
        A.*,
        C.CNATUREZA_JURI, 
        C.NACE_CODE, 
        C.CPAIS_RESIDENCIA, 
        CASE 
            WHEN (C.CNATUREZA_JURI  LIKE '131%' OR C.CNATUREZA_JURI LIKE '231%')
                AND CONTRAPARTE IN ('outras empresas nao financeiras', '') THEN 'outras empresas nao financeiras'
            ELSE 'outros setores'
        END AS CONTRAPARTE,
        C.REF_DATE AS REF_DATE_CLI
    FROM 
    -- TABELA BASE DO UNIVERSO DE CONTRATOS, FILTRADA POR COMISSÕES NÃO FINANCEIRAS - T211_RENT_KPMCO
        (
        SELECT
            CEMPCTA,
            CKBALCAO,
            CKNUMCTA,
            ZDEPOSIT AS ZDEPOSIT_MIS,
            CONCAT(CEMPCTA,CKBALCAO,CKNUMCTA,ZDEPOSIT) AS CHAVE_MIS, 
            ZCLIENTE, 
            CMETACOM, 
            SUM(C457+C460) AS SALDO_COMIS
        FROM CD_CAPTOOLS.CT211_RENT_KPMCO
        WHERE REF_DATE = "${REF_DATE}"
        AND CEMPCTA = '31' 
        AND ORIGEM = 'MIS'
        AND TRIM(CMETACOM) IN ('AA1000','AA1100','AA1150','AA1190','AA1300','AA1410','AA1420','AA1431','AA1432','AA1433','AA1480','AA1490','AA2000','AA2100',
					         'AA2200','AA2290','AA2300','AA3000','AA3001','AA3002','AA310','AA3101','CC1010','CC1019','CC1020','CC1021','CC1022','CC1111',
						     'CC1200','CC1201','CC1210','CC1212','CC1220','CC1310','CC1311','CC1312','CC1320','CC1330','CC1351','CC1361','CC1362','CC1410',
						     'CC1420','CC1430','CC1440','CC1510','CC1520','CC1525','CC1540','CC1546','CC1547','CC155A','CC155B','CC1560','CC1565','CC1568',
						     'CC1570','CC1580','CC1600','CC1700','CC1800','CC1810','CC1950','CC2000','CC2200','CC2300','CC3000','CC3001','CC3002','CC3003',
						     'CC3051','CC3052','CC3053','CC3071','CC3072','CC3073','CC3100','CCC000','CCC001','EE200C','EE200D','EE200E','EE2190','EE2200',
						     'EE2201','EE3000','EE3090','EE5120','EE5130','EE6110','EE6120','EE6200','EE7221','EE7222','EE7231','EE7232','EE7242','EE7243',
						     'EE7252','EE7256','EE7261','EE7262','EE7265','EE7266','EE7267','EE7268','EE726D','EE726G','EE726H','EE726I','EE7272','EE72AA',
						     'EE72AB','EE72AC','EE72AD','EE72B3','EE72B4','EE72ZA','EE72ZB','EE72ZC','EE72ZD','EE72ZE','EE8000','GH1200','GH2210','GH2500',
						     'GH2650','GH3100','GH3200','GH3300','GH3610','GH3620','GH3900','GH4002','GH5000','GH5100','GH5996','GH5997','JJ1000','JJ1100',
                             'JJ2000','JJ2100','JJ3000','JJ4000','JJ4100','JJ4200','JJ5000','JJ500B','JJ5100','JJ6000','JJ7000','JJ8000','MM1000','MM1050',
                             'MM1100','MM1200','MM1310','MM1320','MM1350','MM1403','MM1404','MM1405','MM1411','MM1412','MM1415','MM1416','MM1431','MM1432',
						     'MM2000','MM2111','MM2112','MM2120','MM2130','MM3010','MM3021','MM3022','MM3023','MM3032','MM3033','MM3034','MM3037','MM3038',
						     'MM3100','MM4000','MM5201','MM5209','MM6000','MM7000','MM7110','MM7120','MM7131','MM7132','MM7200','MM7300','MM7301','MM7500',
						     'MM7710','MM7720','MM7800','MM7850','MM7950','MM7961','MM7962','MM7963','MM7964','PP1000','PP2000','PP3000','PP4000','QQ0110',
						     'QQ0120','QQ1000','SS0100','SS0111','SS0112','SS0121','SS0122','SS1000','SS1002','SS1003','SS1005','SS2100','SS2101','SS2102',
						     'SS2210','SS2220','SS2231','SS2232','SS2241','SS2242','SS2243','SS2250','SS2300','SS2301','SS2400','SS2510','SS2520','SS2530',
						     'SS2540','SS2550','SS2555','SS2560','SS2570','SS2580','SS2590','SS2591','SS2600','SS2700','SS280A','SS280B','SS280C','SS280D',
						     'SS2810','SS2910','SS2911','SS2930','SS2950','SS2951','SS2999','SX1100','SX1200','TT1100','TT2000','TT2100','TT3100','TT4000',
						     'TT4100','TT4210','TT5000','TT5100','TT5110','TT5200','UMC000','UMCGI0','UMCGP0','UMCGR0','EE7257','EE7259','AA1434','AA1435',
						     'AA3100','GH2000','EE4000','EE1500','MM1440','MM1510','MM1520','MM1525','MM1526','MM1530','MM1531','MM1532','MM1533','MM1534',
                             'MM1536','MM1537','MM1538',
                             'GH2310','GH3410','GH3420','JJ3150','TT3200','AA1200','AA1310','CC2100','EE9030','EE9040','EE9050','GH599B','JJ1200','MM5100',
                             'TT4220','MM5202','MM7400','MM7600','MM7900','MM7970','SS2261','SS2262','SS2710','SS2711','SS2952','TT1000','TT2200') -- alterados ('GH2310','GH3410','GH3420','JJ3150','TT3200') para não financeiras de acordo com o ficheiro da ana clara
        GROUP BY 1,2,3,4,5,6,7
        ) AS A

    -- ADIÇÃO DO CLIENTE COM MAIOR REF_DATE ASSOCIADA DENTRO DO ANO DE REPORTE
        INNER JOIN

        (
        SELECT
            C2.ZCLIENTE_CT003 AS ZCLIENTE, 
            C2.CNATUREZA_JURI_CT003 AS CNATUREZA_JURI, 
            C2.NACE_CODE_CT003 AS NACE_CODE, 
            C2.CPAIS_RESIDENCIA_CT003 AS CPAIS_RESIDENCIA, 
            C2.CONTRAPARTE_CT003 AS CONTRAPARTE,
            C2.REF_DATE_CT003 AS REF_DATE
        FROM
            (
            SELECT 
                ZCLIENTE,
                REF_DATE,
                MAX(REF_DATE) OVER(PARTITION BY ZCLIENTE) AS MAX_REF_DATE
            FROM CD_CAPTOOLS.CT003_UNIV_CLI
            -- WHERE REF_DATE >= '${REF_DATE_INICIO}' 
            WHERE REF_DATE < '${REF_DATE_FIM}' --
            ) C1
            
            INNER JOIN
            
            ( 
            SELECT 
                ZCLIENTE AS ZCLIENTE_CT003,
                CNATUREZA_JURI AS CNATUREZA_JURI_CT003, 
                NACE_CODE AS NACE_CODE_CT003, 
                CPAIS_RESIDENCIA AS CPAIS_RESIDENCIA_CT003, 
                CONTRAPARTE AS CONTRAPARTE_CT003,
                REF_DATE AS REF_DATE_CT003
            FROM CD_CAPTOOLS.CT003_UNIV_CLI
            -- WHERE REF_DATE >= '${REF_DATE_INICIO}' 
            WHERE REF_DATE < '${REF_DATE_FIM}'
            ) C2
            
            ON C1.ZCLIENTE=C2.ZCLIENTE_CT003
            AND C1.REF_DATE=C2.REF_DATE_CT003
            
            WHERE MAX_REF_DATE=REF_DATE
        ) C

        ON A.ZCLIENTE = C.ZCLIENTE
    ) A

    LEFT JOIN  

    (
    SELECT 
        ZCLIENTE,
        COD_NACE_ESG
    FROM  BUSINESS_ESG.MODESG_OUT_EMPR_INFO_NFIN 
    WHERE REF_DATE = '${REF_DATE}'
    ) NFIN

    ON A.ZCLIENTE = NFIN.ZCLIENTE
    
    LEFT JOIN

	(
    SELECT * 
    FROM BU_ESG_WORK.NACE_ESG_PILLAR3
    ) AS NACE_ESG

    ON CONCAT(SPLIT_PART(NFIN.COD_NACE_ESG,".",1),SPLIT_PART(NFIN.COD_NACE_ESG,".",2),SPLIT_PART(NFIN.COD_NACE_ESG,".",3)) = TRIM(SPLIT_PART(NACE_ESG.NACE_LEVEL4, "-",1))
	
	)A
	WHERE MAIN_CATEGORY IN ('MC45', 'MC52', 'MC53', 'MC54')
;

