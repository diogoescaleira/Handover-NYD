/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 23/05/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 79  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: Obtenção do universo a reportar no âmbito do Satélite 79 + Marcação de metricas relevantes         			       */
/*=========================================================================================================================================*/


-- INSERT OVERWRITE TABLE BU_ESG_WORK.AG079_CESG_CTO_GRA PARTITION (ID_CORRIDA,REF_DATE)

SELECT
    METRICAS.IDCOMB_SATELITE,
	METRICAS.CEMPRESA_CT,
	METRICAS.CBALCAO_CT,
	METRICAS.CNUMECTA_CT,
	METRICAS.ZDEPOSIT_CT,
	METRICAS.CEMPBEM,
	METRICAS.CKBALBEM,
    METRICAS.CKCTABEM,
    METRICAS.CKREFBEM,
	METRICAS.SOCIEDADE_CONTRAPARTE,
	METRICAS.CHAVE_CT, 
	METRICAS.ZCLIENTE,
	METRICAS.DDVENCIM,
	METRICAS.MATURITY_ESG,
	METRICAS.FLAG_MATURITY,
	METRICAS.EUROPEAN_UNION,
	METRICAS.CONTRAPARTE,
	METRICAS.EXCLUDED_PARIS,
	METRICAS.CNAEL,
	METRICAS.NACE_ESG,
	METRICAS.INVESTMENT_SECTOR,
	METRICAS.GEO,         
    METRICAS.AMOUNT,
    CASE 
	    WHEN SUM(COALESCE(NFIN.FLG_ACT_PHYSCL_RSK_ENTTY,0) + COALESCE(MODESG_OUT_BENS_IMOVEIS.FLG_ACT_PHYSCL_RSK_PRTCTN,0)) > 0 THEN 'ACUT1' 
		ELSE 'ACUT2' 
	END AS ACUTE_CHANGES,

	CASE 
	    WHEN SUM(COALESCE(NFIN.FLG_CHRNC_PHYSCL_RSK_ENTTY,0) + COALESCE(MODESG_OUT_BENS_IMOVEIS.FLG_CHRNC_PHYSCL_RSK_PRTCTN,0)) > 0 THEN 'CHRO1' 
		ELSE 'CHRO2'
	END AS CHRONIC_CHANGES,
    RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	'${REF_DATE}' AS REF_DATE
FROM

(
SELECT
    IDCOMB_SATELITE,
	CEMPRESA_CT,
	CBALCAO_CT,
	CNUMECTA_CT,
	ZDEPOSIT_CT,
	CEMPBEM,
    CKBALBEM,
    CKCTABEM,
    CKREFBEM,
	-- IFRS_CT,
	SOCIEDADE_CONTRAPARTE,
	CONCAT(CEMPRESA_CT, CBALCAO_CT, CNUMECTA_CT, ZDEPOSIT_CT) AS CHAVE_CT, 
	ZCLIENTE,
	DDVENCIM,
    CASE
        WHEN IDCOMB_SATELITE LIKE '%MC06%' THEN 'MESG4' -- REGRA DE ACORDO COM SATELITE_STRUCUTRE
        WHEN IDCOMB_SATELITE LIKE '%MC08%' THEN 'MESG4' -- REGRA DE ACORDO COM SATELITE_STRUCUTRE
        WHEN IDCOMB_SATELITE LIKE '%MC10%' AND IDCOMB_SATELITE LIKE '%TYVA01%' THEN 'MESG4' -- MAPEAMENTO DE MATURIDADE PARA ADJUDICADOS 
        WHEN IDCOMB_SATELITE LIKE '%MC10%' AND IDCOMB_SATELITE LIKE '%TYVA02%' THEN '' -- MAPEAMENTO DE MATURIDADE PARA ADJUDICADOS (PROVISÕES NÃO DEVERÃO BUCKET DE MATURIDADE)
        WHEN UPPER(PRODUTO) LIKE 'CART%CR%DITO%' OR UPPER(PRODUTO) LIKE '%REPOS%' OR UPPER(PRODUTO) LIKE '%VISTA, DESCOBERTOS E CO%' THEN 'MESG5'  -- COUNTERPARTY HAVING THE CHOICE OF THE REPAYMENT DATE
        WHEN DDVENCIM < '${REF_DATE}' AND (DDVENCIM NOT IN ('','0001-01-01','9999-12-31') OR DDVENCIM IS NOT NULL) THEN 'MESG1' -- CONTRATOS COM MATURIDADE INFERIOR À DATA DE REPORTE OU FALTA DE DATA QUALITY DE DADOS
        WHEN (DDVENCIM IN ('','0001-01-01','9999-12-31') OR DDVENCIM IS NULL)AND IDCOMB_SATELITE LIKE '%MC02%' AND IDCOMB_SATELITE LIKE '%COLL2%' THEN 'MESG4' -- UNKNOWN MATURITY RESIDENCIAL (REGRA DE ACORDO COM SATELITE_STRUCUTRE)
        WHEN (DDVENCIM IN ('','0001-01-01','9999-12-31') OR DDVENCIM IS NULL)AND IDCOMB_SATELITE LIKE '%MC02%' AND IDCOMB_SATELITE LIKE '%COLL3%' THEN 'MESG1' -- UNKNOWN MATURITY COMERCIAL (REGRA DE ACORDO COM SATELITE_STRUCUTRE)
        WHEN (DDVENCIM IN ('','0001-01-01','9999-12-31') OR DDVENCIM IS NULL)AND IDCOMB_SATELITE LIKE '%MC02%' AND IDCOMB_SATELITE NOT LIKE '%COLL2%' AND IDCOMB_SATELITE NOT LIKE '%COLL3%' THEN 'MESG1' -- UNKNOWN MATURITY REST OF LOANS (REGRA DE ACORDO COM SATELITE_STRUCUTRE)
        WHEN (DDVENCIM IN ('','0001-01-01','9999-12-31') OR DDVENCIM IS NULL)AND IDCOMB_SATELITE LIKE '%MC04%' THEN 'MESG1' -- UNKNOWN MATURITY BEBT SECURITIES (REGRA DE ACORDO COM SATELITE_STRUCUTRE)
        WHEN (DDVENCIM IN ('','0001-01-01','9999-12-31') OR DDVENCIM IS NULL)THEN 'MESG6' -- OTHER CONTRACTS WITH NO STATED MATURITY
        WHEN ROUND(DATEDIFF(TO_DATE(DDVENCIM), TO_DATE('${REF_DATE}'))/365.25,4) <= 05 THEN 'MESG1' 
        WHEN ROUND(DATEDIFF(TO_DATE(DDVENCIM), TO_DATE('${REF_DATE}'))/365.25,4) <= 10 THEN 'MESG2'
        WHEN ROUND(DATEDIFF(TO_DATE(DDVENCIM), TO_DATE('${REF_DATE}'))/365.25,4) <= 20 THEN 'MESG3'
        WHEN ROUND(DATEDIFF(TO_DATE(DDVENCIM), TO_DATE('${REF_DATE}'))/365.25,4) > 20 THEN 'MESG4'
        ELSE 'MESG6'
    END AS MATURITY_ESG,
            
    CASE
        WHEN IDCOMB_SATELITE LIKE '%MC06%' THEN 0		--EXCLUSÃO DE EQUITY
        WHEN IDCOMB_SATELITE LIKE '%MC08%' THEN 0
        WHEN UPPER(PRODUTO) LIKE 'CART%CR%DITO%' OR UPPER(PRODUTO) LIKE '%REPOS%' OR UPPER(PRODUTO) LIKE '%VISTA, DESCOBERTOS E CO%' THEN 0		--EXCLUSÃO DE COUNTERPARTY HAVING THE CHOICE OF REPAYMENT DATE
        WHEN (DDVENCIM IN ('','0001-01-01','9999-12-31') OR DDVENCIM IS NULL)   THEN 0
        WHEN DDVENCIM < "${REF_DATE}"                                                     THEN 0
        WHEN ROUND(DATEDIFF(TO_DATE(DDVENCIM), TO_DATE("${REF_DATE}"))/365.25,4) <= 05    THEN 1
        WHEN ROUND(DATEDIFF(TO_DATE(DDVENCIM), TO_DATE("${REF_DATE}"))/365.25,4) <= 10    THEN 1
        WHEN ROUND(DATEDIFF(TO_DATE(DDVENCIM), TO_DATE("${REF_DATE}"))/365.25,4) <= 20    THEN 1
        WHEN ROUND(DATEDIFF(TO_DATE(DDVENCIM), TO_DATE("${REF_DATE}"))/365.25,4) >  20    THEN 1
        ELSE 0			
    END AS FLAG_MATURITY, 

    CASE
        WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN 'EU1' -- CONSIDERA-SE QUE ADJUDICADOS ESTÃO ASSOCIADOS A PORTUGAL
        WHEN ZCLIENTE ='0000000000' THEN 'EU1'
        WHEN COUNTRY_CODE IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428') 
            THEN 'EU1'
        WHEN COUNTRY_CODE NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428', '')
            THEN 'EU2'
        WHEN CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
            THEN 'EU1'
        WHEN CPAIS_RESIDENCIA	NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
            THEN 'EU2'
        ELSE '' 
    END AS EUROPEAN_UNION,

    CONTRAPARTE,

    CASE
        WHEN  (IDCOMB_SATELITE LIKE '%SC0303%' OR TRIM(CONTRAPARTE) = 'outras empresas nao financeiras') AND FLG_EMPRS_EXCL_PARIS = 1 THEN 'EXC1' --EXCLUÍDO
        WHEN  (IDCOMB_SATELITE LIKE '%SC0303%' OR TRIM(CONTRAPARTE) = 'outras empresas nao financeiras') AND COALESCE(FLG_EMPRS_EXCL_PARIS,0) = 0 THEN 'EXC2' --NÃO EXCLUÍDO
        ELSE ''
    END AS EXCLUDED_PARIS,

    CASE 
        WHEN IDCOMB_SATELITE LIKE '%SC0302%' AND CONCAT(CEMPRESA_CT,CBALCAO_CT,CNUMECTA_CT,ZDEPOSIT_CT) IN ('31641600005800050PTNOFIIE0000000','31641600005800050PTPLG8IM0001000','31641600005800050PTPL1AIM0000000','31641600005800050PTPLGEIM0004000') THEN '' -- CORREÇÃO DEVIDO A INCORRETO MAPEAMENTO DE CONTABILIDADE (EMAIL NUNO PINHEIRO DIA 26/01)
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'A' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL1'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'B' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL2'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'D' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL4'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'C' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL3'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'E' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL5'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'F' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL6'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'G' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL7'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'H' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL8'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'I' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL9'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'J' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL10'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'L' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL11'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'M' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL12'  
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'N' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL13'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'O' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL14'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'P' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL15'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'Q' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL16'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'R' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL17'
        WHEN SUBSTR(COD_NACE_ESG,1,1) = 'S' AND TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL18'
        WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'CNAEL18'
        WHEN TRIM(CONTRAPARTE) = '' AND IDCOMB_SATELITE LIKE '%SC0303%' THEN 'CNAEL18'		--VALIDADO COM CONTABILIDADE QUE TODOS OS NFC DEVERÃO POSSUIR NACE, PELO QUE OS QUE NÃO DISPONHAM DESTA INFORMAÇÃO DEVERÃO SER MAPEADOS COM CNAEL DEFAULT
        WHEN IDCOMB_SATELITE LIKE '%SC0303%' AND ZCLIENTE = '0000000000' THEN 'CNAEL18' --INDICAÇÃO DA CONTABILIDADE DEVIDO A ASSIGNAÇÃO ERRADA DE CONTRATO SEM CONTA PCSB
        -- WHEN IDCOMB_SATELITE LIKE '%SC0303%' AND CONCAT(A.CBALCAO_CT,A.CNUMECTA_CT,A.ZDEPOSIT_CT)='6416SUPRIMENTOSPTTAE0AN0006000' THEN 'CNAEL18' --INDICAÇÃO DA CONTABILIDADE DEVIDO A ASSIGNAÇÃO ERRADA DE CONTRATO SEM CONTA PCSB
        ELSE ''
    END AS CNAEL,

    CASE
    WHEN IDCOMB_SATELITE LIKE '%SC0302%' AND CONCAT(CEMPRESA_CT,CBALCAO_CT,CNUMECTA_CT,ZDEPOSIT_CT) IN ('31641600005800050PTNOFIIE0000000','31641600005800050PTPLG8IM0001000','31641600005800050PTPL1AIM0000000','31641600005800050PTPLGEIM0004000') THEN '' -- CORREÇÃO DEVIDO A INCORRETO MAPEAMENTO DE CONTABILIDADE (EMAIL NUNO PINHEIRO DIA 26/01)
    WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND NACE_LEVEL4 IS NOT NULL THEN ID
    WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'NACE19010303' --NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO            
    WHEN TRIM(CONTRAPARTE) IN ('', 'resto setores / clientes') AND IDCOMB_SATELITE LIKE '%SC0303%' AND NACE_LEVEL4 IS NOT NULL THEN ID	
    WHEN TRIM(CONTRAPARTE) IN ('', 'resto setores / clientes') AND IDCOMB_SATELITE LIKE '%SC0303%' THEN 'NACE19010303' --NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO
    WHEN IDCOMB_SATELITE LIKE '%SC0303%' AND ZCLIENTE = '0000000000' THEN 'NACE19010303' --INDICAÇÃO DA CONTABILIDADE DEVIDO A ASSIGNAÇÃO ERRADA DE CONTRATO SEM CONTA PCSB
    -- WHEN IDCOMB_SATELITE LIKE '%SC0303%' AND CONCAT(A.CBALCAO_CT,A.CNUMECTA_CT,A.ZDEPOSIT_CT)='6416SUPRIMENTOSPTTAE0AN0006000' THEN 'NACE19010303' --INDICAÇÃO DA CONTABILIDADE DEVIDO A ASSIGNAÇÃO ERRADA DE CONTRATO SEM CONTA PCSB
    ELSE ''									
END AS NACE_ESG,

CASE 
    WHEN ((IDCOMB_SATELITE LIKE '%SC02%') OR (CONTRAPARTE = 'instituicoes de credito')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS2'
    WHEN ((IDCOMB_SATELITE LIKE '%SC0301%') OR (CONTRAPARTE = 'setor publico')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS3'
    WHEN ((IDCOMB_SATELITE LIKE '%SC0302%')  OR (CONTRAPARTE = 'outras instituicoes financeiras')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS4'
    WHEN ((IDCOMB_SATELITE LIKE '%SC0303%')  OR (CONTRAPARTE = 'outras empresas nao financeiras')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS5'
    ELSE '' 
END AS INVESTMENT_SECTOR,

--- MARCAÇÃO DO CAMPO PHYSICAL RISK_GEOGRAPHICAL AREA, VALIDANDO SE EXISTEM IMÓVEIS ASSOCIADOS: NO CASO DE EXISTIREM IMÓVEIS ASSOCIADOS - O MAPEAMENTO É REALIZADO COM O CAMPO 'COUNTRY_CODE'PROVENIENTE DO MODELO DE BENS IMÓVEIS, CASO CONTRÁRIO, É UTILIZADO O CAMPO 'CPAIS_RESIDENCIA'
CASE
    -- GEOGRAFIAS QUE EXISTIAM À DATA: VER ALTERAÇÕES EM EXERCICIOS FUTUROS
    WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN 'GEO3' -- CONSIDERA-SE QUE ADJUDICADOS ESTÃO ASSOCIADOS A PORTUGAL
    WHEN ZCLIENTE ='0000000000' THEN 'GEO3'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('620') THEN 'GEO3'    
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('724') THEN 'GEO1'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('826') THEN 'GEO2'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('840') THEN 'GEO4'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('616') THEN 'GEO5'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('276') THEN 'GEO6'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('250') THEN 'GEO7'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('578') THEN 'GEO8'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('484') THEN 'GEO9'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('152') THEN 'GEO10'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('076') THEN 'GEO11'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('032') THEN 'GEO12'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('604') THEN 'GEO13'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('170') THEN 'GEO14'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('858') THEN 'GEO15'
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('600','068','218','862','238','531') THEN 'GEO16' --REST OF LATAM 
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('044','060','092','124','136','192','214','222','312','320','533','591','630','666','780') THEN 'GEO17' --REST OF NORTH AMERICA
    WHEN COUNTRY_CODE IS NOT NULL AND COUNTRY_CODE IN ('020','040','056','100','191','196','203','208','246','292','300','336','348','352','372','380','428','438','440','442','470','492','498','528','642','643','674','688','703','705','752','756','792','804','807','831','832','833') THEN 'GEO18' --REST OF EUROPE    
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (620) THEN 'GEO3'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (724) THEN 'GEO1'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (826) THEN 'GEO2'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (840) THEN 'GEO4'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (616) THEN 'GEO5'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (276) THEN 'GEO6'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (250) THEN 'GEO7'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (578) THEN 'GEO8'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (484) THEN 'GEO9'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (152) THEN 'GEO10'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (076) THEN 'GEO11'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (032) THEN 'GEO12'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (604) THEN 'GEO13'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (170) THEN 'GEO14'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (858) THEN 'GEO15'
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (600,068,218,862,238,531) THEN 'GEO16' --REST OF LATAM 
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (044,060,092,124,136,192,214,222,312,320,533,591,630,666,780) THEN 'GEO17' --REST OF NORTH AMERICA
    WHEN CAST(CPAIS_RESIDENCIA AS INT) IN (020,040,056,100,191,196,203,208,246,292,300,336,348,352,372,380,428,438,440,442,470,492,498,528,642,643,674,688,703,705,752,756,792,804,807,831,832,833) THEN 'GEO18' --REST OF EUROPE
    ELSE 'GEO19'
END AS GEO,
-- PESO,        
CASE
    WHEN IDCOMB_SATELITE NOT LIKE '%MC10%' THEN -1 * AMOUNT
    ELSE AMOUNT
END AS AMOUNT

FROM
    (
        SELECT 
            UNIV.IDCOMB_SATELITE,
            UNIV.CEMPRESA_CT,
            UNIV.CBALCAO_CT,
            UNIV.CNUMECTA_CT, 
            UNIV.ZDEPOSIT_CT,
            UNIV.CARGABAL_CT,
            UNIV.AMOUNT,
            UNIV.SOCIEDADE_CONTRAPARTE,
            UNIV.CHAVE_CT,
            UNIV.CEMPBEM,
            UNIV.CKBALBEM,
            UNIV.CKCTABEM,
            UNIV.CKREFBEM,
            CT004.ZCLIENTE,
            CT004.DDVENCIM,
            CT003.CONTRAPARTE,
            UNIV.PRODUTO, 
            PROPERTY.COUNTRY_CODE,
            CT003.CPAIS_RESIDENCIA,
            NFIN.FLG_EMPRS_EXCL_PARIS,
            NFIN.COD_NACE_ESG, 
            NACE_ESG.NACE_LEVEL4,
            NACE_ESG.ID
        FROM
        (
            SELECT
                A.IDCOMB_SATELITE,
                A.CEMPRESA_CT,
                A.CBALCAO_CT,
                A.CNUMECTA_CT, 
                A.ZDEPOSIT_CT,
                A.CARGABAL_CT,
                EMISS.AMOUNT,
                A.SOCIEDADE_CONTRAPARTE,
                A.CHAVE_CT,
                EMISS.CEMPBEM,
                EMISS.CKBALBEM,
                EMISS.CKCTABEM,
                EMISS.CKREFBEM,
                EMISS.ZCLIENTE,
                PRODUTO
            FROM
        
                (                
                    SELECT DISTINCT
                        A1.IDCOMB_SATELITE,
                        A1.CEMPRESA_CT,
                        A1.CBALCAO_CT,
                        A1.CNUMECTA_CT,
                        A1.ZDEPOSIT_CT,
                        A1.CARGABAL_CT,
                        A1.SOCIEDADE_CONTRAPARTE,
                        A1.CHAVE_CT, 
                        FR802.PRODUTO
                    FROM 
                    (
                        SELECT 
                            IDCOMB_SATELITE,
                            CEMPRESA_CT,
                            CBALCAO_CT,
                            CNUMECTA_CT,
                            ZDEPOSIT_CT,
                            CARGABAL_CT,
                            IFRS_CT,
                            SOCIEDADE_CONTRAPARTE,
                            CONCAT(CEMPRESA_CT, CBALCAO_CT, CNUMECTA_CT, ZDEPOSIT_CT) AS CHAVE_CT ,
                            SUM(SALDO_CT) AS SALDO_CT
                        FROM bu_esg_work.RF_PILAR3_UNIVERSO_FULL
                        WHERE DT_RFRNC = '${REF_DATE}' 
                        AND ID_CORRIDA IN ( SELECT 
                                                MAX(ID_CORRIDA) 
                                            FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL 
                                            WHERE DT_RFRNC = '${REF_DATE}'
                                            ) 
                        AND CSATELITE IN (79) 
                        AND IDCOMB_SATELITE NOT LIKE '%MC10%' 
                        AND IDCOMB_SATELITE LIKE '%TYVA01%'
                        GROUP BY 1,2,3,4,5,6,7,8,9
                    ) A1
                    LEFT JOIN
                    
                    (
                        SELECT * 
                        FROM CD_CAPTOOLS.FR802_PL_CONTAS
                        WHERE COD_PLANO = 'BST_IND'
                        AND REF_DATE = "${REF_DATE}"
                    ) AS FR802
                    
                    ON A1.IFRS_CT = FR802.CONTA
                ) AS A
        
                LEFT JOIN
                
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
        
                ON  A.CEMPRESA_CT = EMISS.CEMPRESA
                AND A.CBALCAO_CT  = EMISS.CBALCAO
                AND A.CNUMECTA_CT = EMISS.CNUMECTA
                AND A.ZDEPOSIT_CT = EMISS.ZDEPOSIT
                
                UNION ALL
                
                SELECT
                    A.IDCOMB_SATELITE,
                    A.CEMPRESA_CT,
                    A.CBALCAO_CT,
                    A.CNUMECTA_CT, 
                    A.ZDEPOSIT_CT,
                    A.CARGABAL_CT,
                    SALDO_CT AS AMOUNT,
                    A.SOCIEDADE_CONTRAPARTE,
                    A.CHAVE_CT,
                    NULL AS CEMPBEM,
                    NULL AS CKBALBEM,
                    NULL AS CKCTABEM,
                    NULL AS CKREFBEM,
                    EMISS.ZCLIENTE,
                    FR802.PRODUTO
                FROM
            
                    (
                        SELECT 
                            IDCOMB_SATELITE,
                            CEMPRESA_CT,
                            CBALCAO_CT,
                            CNUMECTA_CT,
                            ZDEPOSIT_CT,
                            CARGABAL_CT,
                            IFRS_CT,
                            SOCIEDADE_CONTRAPARTE,
                            CONCAT(CEMPRESA_CT, CBALCAO_CT, CNUMECTA_CT, ZDEPOSIT_CT) AS CHAVE_CT ,
                            SUM(SALDO_CT) AS SALDO_CT
                        FROM bu_esg_work.RF_PILAR3_UNIVERSO_FULL
                        WHERE DT_RFRNC = '${REF_DATE}' AND
                                    ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL WHERE DT_RFRNC = '${REF_DATE}') AND
                                    CSATELITE IN (79) AND IDCOMB_SATELITE NOT LIKE '%MC10%' AND IDCOMB_SATELITE LIKE '%TYVA02%'
                        GROUP BY 1,2,3,4,5,6,7,8,9
                    )A
                
                LEFT JOIN
                    
                (
                    SELECT * 
                    FROM CD_CAPTOOLS.FR802_PL_CONTAS
                    WHERE COD_PLANO = 'BST_IND'
                    AND REF_DATE = "${REF_DATE}"
                ) AS FR802
                
                ON A.IFRS_CT = FR802.CONTA            
                
                LEFT JOIN
                
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
                        ZCLIENTE
                    FROM BU_ESG_WORK.MODESG_OUT_EMSS_FNCD 
                    WHERE REF_DATE='${REF_DATE}'
                    AND NOME_PERIMETRO LIKE '%Individual Idcomb%'
                    ) EMISS
        
                ON  A.CEMPRESA_CT = EMISS.CEMPRESA
                AND A.CBALCAO_CT  = EMISS.CBALCAO
                AND A.CNUMECTA_CT = EMISS.CNUMECTA
                AND A.ZDEPOSIT_CT = EMISS.ZDEPOSIT            
        ) UNIV
        
        LEFT JOIN

        (
        SELECT
            ZCLIENTE, 
            CPAIS_RESIDENCIA, 
            CONTRAPARTE
        FROM CD_CAPTOOLS.CT003_UNIV_CLI
        WHERE REF_DATE='${REF_DATE}'
        ) CT003
        
        ON UNIV.ZCLIENTE=CT003.ZCLIENTE
        
        LEFT JOIN
        (
        SELECT
            CEMPRESA, 
            CBALCAO, 
            CNUMECTA, 
            ZDEPOSIT, 
            DDVENCIM, 
            ZCLIENTE
        FROM CD_CAPTOOLS.CT004_UNIV_CTO
        WHERE REF_DATE='${REF_DATE}'     
        ) CT004
        
        ON  UNIV.CEMPRESA_CT = CT004.CEMPRESA
        AND UNIV.CBALCAO_CT  = CT004.CBALCAO
        AND UNIV.CNUMECTA_CT = CT004.CNUMECTA
        AND UNIV.ZDEPOSIT_CT = CT004.ZDEPOSIT
        
        LEFT JOIN 
        (
        SELECT * 
        FROM BU_ESG_WORK.MODESG_OUT_EMPR_INFO_NFIN
        WHERE REF_DATE='${REF_DATE}'
        ) NFIN
        
        ON UNIV.ZCLIENTE = NFIN.ZCLIENTE
        
        LEFT JOIN
        --- MODELO DE BENS IMÓVEIS - ASSOCIAÇÃO DO CAMPO 'COUNTRY_CODE' PARA MARCAÇÃO DA MÉTRICA GEO - PHYSICAL RISK_GEOGRAPHICAL AREA
        (
            SELECT DISTINCT 
                CONCAT(PROPERTY_BRANCH_CODE, PROPERTY_CONTRACT_ID, PROPERTY_REFERENCE_CODE) AS CHAVE_BEM_GAR, 
                COUNTRY_CODE
            FROM BU_ESG_WORK.PROPERTY
            WHERE DATA_DATE_PART = '${REF_DATE}'
        ) PROPERTY
        
        ON CONCAT(UNIV.CKBALBEM, UNIV.CKCTABEM, UNIV.CKREFBEM) = PROPERTY.CHAVE_BEM_GAR
        
        -- MAPEAMENTO PARA PREENCHIMENTO DO NACE ESG (PARA EMPRESAS NÃO FINANCEIRAS), QUE DE MOMENTO É IGUAL AO NACE
        LEFT JOIN BU_ESG_WORK.NACE_ESG_PILLAR3 AS NACE_ESG		--CRIAR TABELA DE EXCEL A IMPORTAR COM BASE NA NOVA MARCAÇÃO DO EXCEL SAT 79 CASO MUDEM OS NACE QUE A CORPORAÇÃO ENVIA
        ON CONCAT(SPLIT_PART(NFIN.COD_NACE_ESG,".",1),SPLIT_PART(NFIN.COD_NACE_ESG,".",2),SPLIT_PART(NFIN.COD_NACE_ESG,".",3)) = TRIM(SPLIT_PART(NACE_ESG.NACE_LEVEL4, "-",1))
        UNION ALL

        SELECT
            a.IDCOMB_SATELITE, 
            NULL AS CEMPRESA_CT,
            NULL AS CBALCAO_CT,
            NULL AS CNUMECTA_CT,
            NULL AS ZDEPOSIT_CT,
            A.CARGABAL_CT,
            case 
                when A.cargabal_ct = '' then -A.saldo_ct
                when IDCOMB_SATELITE LIKE '%TYVA01%' AND ADJUD_INPUTS.cargabal_vc in ('1605010', '160510', '1605000') then ADJUD_INPUTS.V_CONTAB
                WHEN IDCOMB_SATELITE LIKE '%TYVA02%' AND ADJUD_INPUTS.CARGABAL_PROV IN('2642300', '26423100') THEN -ADJUD_INPUTS.V_PROV
            end as AMOUNT,
            A.SOCIEDADE_CONTRAPARTE,
            NULL AS CHAVE_CT,
            ADJUD_INPUTS.PROPERTY_BANK_ID,
            ADJUD_INPUTS.PROPERTY_BRANCH_CODE,
            ADJUD_INPUTS.PROPERTY_CONTRACT_ID, 
            ADJUD_INPUTS.PROPERTY_REFERENCE_CODE,
            NULL AS ZCLIENTE, 
            NULL AS DDVENCIM,
            NULL AS CONTRAPARTE,
            NULL AS PRODUTO, 
            PROPERTY.COUNTRY_CODE,
            NULL AS CPAIS_RESIDENCIA,
            NULL AS FLG_EMPRS_EXCL_PARIS,
            NULL AS COD_NACE_ESG, 
            NULL AS NACE_LEVEL4,
            NULL AS ID
            
            -- NACE_ESG.NACE_LEVEL4,
            -- NACE_ESG.ID, 
            -- NULL AS PESO
        FROM
            (
            SELECT
                IDCOMB_SATELITE,
                CARGABAL_CT,
                SOCIEDADE_CONTRAPARTE,
                SUM(SALDO_CT) AS SALDO_CT
            FROM bu_esg_work.RF_PILAR3_UNIVERSO_FULL
            WHERE DT_RFRNC = '${REF_DATE}' 
            AND ID_CORRIDA IN ( SELECT 
                                    MAX(ID_CORRIDA) 
                                FROM BU_ESG_WORK.RF_PILAR3_UNIVERSO_FULL 
                                WHERE DT_RFRNC = '${REF_DATE}'
                                ) 
            AND CSATELITE IN (79) 
            AND IDCOMB_SATELITE LIKE '%MC10%'
            GROUP BY 1,2,3
            ) AS A
        
            LEFT JOIN

            (            
            SELECT *
            FROM
                (
                SELECT
                    '31' as PROPERTY_BANK_ID,
                    'CMAH' AS PROPERTY_BRANCH_CODE, 
                    'IMOVELGIDAP' AS PROPERTY_CONTRACT_ID,
                    replace(upper(lpad(COD_IMOVEL,15,'0')),' ', '0') AS PROPERTY_REFERENCE_CODE,
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
                    
                    CASE
                        WHEN PROV_IFRS = '19910000' then '1605010'
                        WHEN PROV_IFRS = '1910000' then '1605010'
                        WHEN PROV_IFRS = '19911000' then '160510'
                        WHEN PROV_IFRS = '19910001' then '2642300'
                        WHEN PROV_IFRS = '1910008' then '2642300'
                        WHEN PROV_IFRS = '19911001' then '26423100'
                        WHEN PROV_IFRS = '199100200' then '1605010'
                        WHEN PROV_IFRS = '199100210' then '1605010'
                        WHEN PROV_IFRS = '199100201' then '2642300'
                        WHEN PROV_IFRS = '199100211' then '2642300'
                        WHEN PROV_IFRS = '199100240' then '1605000'
                        WHEN PROV_IFRS = '199100241' then '2642300'
                    END AS CARGABAL_PROV,
                    
                    V_CONTAB_IFRS, 
                    V_CONTAB, 
                    PROV_LEGAL + PROV_ADICIONAL AS V_PROV
                FROM cd_captools.ct666_adjudic_propr
                WHERE ref_date='${REF_DATE}'
                AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')
                
                UNION ALL
                            
                SELECT
                    '31' AS property_bank_id , 
                    'CMAH' AS PROPERTY_BRANCH_CODE, 
                    'IMOVELRECUP' AS PROPERTY_CONTRACT_ID,
                    lpad(replace( replace( replace( concat( ifnull(upper(n_processo_tc), ''), concat( upper( trim(artigo_matricial) ), concat( ifnull(upper(n_cliente), ''), ifnull(upper(origem), '') ))), '_', '0' ), ' ', '0' ), chr(10), '0' ),15,'0') as property_reference_code,
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
                    
                    CASE
                        WHEN PROV_IFRS = '19910000' then '1605010'
                        WHEN PROV_IFRS = '1910000' then '1605010'
                        WHEN PROV_IFRS = '19911000' then '160510'
                        WHEN PROV_IFRS = '19910001' then '2642300'
                        WHEN PROV_IFRS = '1910008' then '2642300'
                        WHEN PROV_IFRS = '19911001' then '26423100'
                        WHEN PROV_IFRS = '199100200' then '1605010'
                        WHEN PROV_IFRS = '199100210' then '1605010'
                        WHEN PROV_IFRS = '199100201' then '2642300'
                        WHEN PROV_IFRS = '199100211' then '2642300'
                        WHEN PROV_IFRS = '199100240' then '1605000'
                        WHEN PROV_IFRS = '199100241' then '2642300'
                    END AS CARGABAL_PROV,
                    
                    V_CONTAB_IFRS, 
                    V_CONTAB, 
                    PROV_TOTAL AS V_PROV
                FROM cd_captools.ct667_dacoes_arrem
                WHERE ref_date='${REF_DATE}'
                AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')
                
                UNION ALL
                
                SELECT
                    '89' AS property_bank_id , 
                    'CMAH' AS PROPERTY_BRANCH_CODE, 
                    'IMOVELIFICS' AS PROPERTY_CONTRACT_ID,
                    lpad(n_imovel,15,'0') AS PROPERTY_REFERENCE_CODE,
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
                    
                    CASE
                        WHEN PROV_IFRS = '19910000' then '1605010'
                        WHEN PROV_IFRS = '1910000' then '1605010'
                        WHEN PROV_IFRS = '19911000' then '160510'
                        WHEN PROV_IFRS = '19910001' then '2642300'
                        WHEN PROV_IFRS = '1910008' then '2642300'
                        WHEN PROV_IFRS = '19911001' then '26423100'
                        WHEN PROV_IFRS = '199100200' then '1605010'
                        WHEN PROV_IFRS = '199100210' then '1605010'
                        WHEN PROV_IFRS = '199100201' then '2642300'
                        WHEN PROV_IFRS = '199100211' then '2642300'
                        WHEN PROV_IFRS = '199100240' then '1605000'
                        WHEN PROV_IFRS = '199100241' then '2642300'
                    END AS CARGABAL_PROV,
                    
                    V_CONTAB_IFRS, 
                    V_CONTAB, 
                    PROV_TOTAL AS V_PROV
                FROM cd_captools.ct668_imoveis_ific
                WHERE ref_date='${REF_DATE}'
                AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')
                ) A1
            
            WHERE CONCAT(property_bank_id,PROPERTY_BRANCH_CODE,PROPERTY_CONTRACT_ID,property_reference_code) IN (
                                                                                                                SELECT 
                                                                                                                    CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) 
                                                                                                                FROM cd_captools.ct001_univ_saldo 
                                                                                                                WHERE ref_date='${REF_DATE}' 
                                                                                                                AND ccontab_final_idcomb LIKE '%MC1005%'
                                                                                                                )
            
            ) ADJUD_INPUTS
            
            ON A.CARGABAL_CT= CASE
                                WHEN CARGABAL_CT IN('1605010', '160510', '1605000') THEN ADJUD_INPUTS.CARGABAL_VC
                                WHEN CARGABAL_CT IN('2642300', '26423100') THEN ADJUD_INPUTS.CARGABAL_PROV
                                END
        
            LEFT JOIN
        
            (
            SELECT DISTINCT 
                CONCAT(PROPERTY_BRANCH_CODE, PROPERTY_CONTRACT_ID, PROPERTY_REFERENCE_CODE) AS CHAVE_BEM_GAR, 
                COUNTRY_CODE
            FROM BU_ESG_WORK.PROPERTY
            WHERE DATA_DATE_PART = '${REF_DATE}'
            ) PROPERTY
            
            ON CONCAT(ADJUD_INPUTS.PROPERTY_BRANCH_CODE, ADJUD_INPUTS.PROPERTY_CONTRACT_ID, ADJUD_INPUTS.PROPERTY_REFERENCE_CODE ) = PROPERTY.CHAVE_BEM_GAR

        ) X
    
    ) METRICAS

    --- TABELA DE MARCAÇÃO DE RISCO FÍSICO
	LEFT JOIN

	(
	SELECT *, 
		FLG_RSC_FSC_AGD AS FLG_ACT_PHYSCL_RSK_ENTTY, 
		FLG_RSC_FSC_CRNC AS FLG_CHRNC_PHYSCL_RSK_ENTTY
	FROM BU_ESG_WORK.MODESG_OUT_EMPR_INFO_NFIN
	WHERE REF_DATE='${REF_DATE}'
	) NFIN

	ON METRICAS.ZCLIENTE = NFIN.ZCLIENTE

-- --- ADICIONADA MODESG_BENS_IMOV PARA RETIRAR AS FLGS DE RISCO FISICO
	LEFT JOIN

	(
	SELECT *, 
		FLG_RSC_FSC_AGD AS FLG_ACT_PHYSCL_RSK_PRTCTN, 
		FLG_RSC_FSC_CRNC AS FLG_CHRNC_PHYSCL_RSK_PRTCTN 
	FROM BU_ESG_WORK.MODESG_OUT_BENS_IMOVEIS
	WHERE REF_DATE='${REF_DATE}'
	) MODESG_OUT_BENS_IMOVEIS
	
	ON MODESG_OUT_BENS_IMOVEIS.CKBALBEM = METRICAS.CKBALBEM
	AND MODESG_OUT_BENS_IMOVEIS.CKCTABEM = METRICAS.CKCTABEM
	AND MODESG_OUT_BENS_IMOVEIS.CKREFBEM = METRICAS.CKREFBEM

	LEFT JOIN

	(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_ESG_WORK.AG079_CESG_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}'
	) RT
	
	ON 1=1

    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,26,27
;