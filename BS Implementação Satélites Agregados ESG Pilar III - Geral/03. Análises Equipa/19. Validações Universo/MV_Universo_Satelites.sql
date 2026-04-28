
/*===================================================================================================================================================
                                                      
											     SIMULAÇÃO TABELA UNIVERSO MODELO VERDE
										                    NEYOND 2024 - V.F.
															    
 ===================================================================================================================================================*/
 
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 0. Tabelas auxiliares 
	--> 31000100200606273000000000000000 - Chave master com 2 chaves finrep 
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 564 row(s)

CREATE TABLE BU_CAPTOOLS_WORK.BASE_PARAM AS
SELECT *
    ,CASE WHEN split_part(IDCOMB_SAT,';',01)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',01) END AS IDCOMB1
    ,CASE WHEN split_part(IDCOMB_SAT,';',02)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',02) END AS IDCOMB2
    ,CASE WHEN split_part(IDCOMB_SAT,';',03)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',03) END AS IDCOMB3
    ,CASE WHEN split_part(IDCOMB_SAT,';',04)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',04) END AS IDCOMB4
    ,CASE WHEN split_part(IDCOMB_SAT,';',05)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',05) END AS IDCOMB5
    ,CASE WHEN split_part(IDCOMB_SAT,';',06)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',06) END AS IDCOMB6
    ,CASE WHEN split_part(IDCOMB_SAT,';',07)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',07) END AS IDCOMB7
    ,CASE WHEN split_part(IDCOMB_SAT,';',08)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',08) END AS IDCOMB8
    ,CASE WHEN split_part(IDCOMB_SAT,';',09)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',09) END AS IDCOMB9 -- Apenas até aqui 
    ,CASE WHEN split_part(IDCOMB_SAT,';',10)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',10) END AS IDCOMB10
    ,CASE WHEN split_part(IDCOMB_SAT,';',11)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',11) END AS IDCOMB11
    ,CASE WHEN split_part(IDCOMB_SAT,';',12)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',12) END AS IDCOMB12
    ,CASE WHEN split_part(IDCOMB_SAT,';',13)='' THEN ';' ELSE split_part(IDCOMB_SAT,';',13) END AS IDCOMB13 
FROM
    (
    SELECT reporte_granular,ccontab_final_idcomb_total,
    substring(TRIM(replace(replace(ccontab_final_idcomb_total,"IN (",""),")","")),2,length(TRIM(replace(replace(ccontab_final_idcomb_total,"IN (",""),")","")))-2) AS IDCOMB_SAT
    FROM bu_captools_work.param_satel_univ
    WHERE reporte_granular LIKE "%Satelite%"
    ) AUX 
;

	-- Inserted 91 row(s)
	
DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.AUX_SATELITE;
CREATE TABLE BU_CAPTOOLS_WORK.AUX_SATELITE AS 

select L1.*,L3.ccontab_final_idcomb_total
FROM 
    (
    SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
	    ,ccontab_final_ifrs,ccontab_final_pcsb,ccontab_final_st_sgps,ccontab_final_idcomb,sum(msaldo_final) as amount
	FROM cd_captools.ct001_univ_saldo
	WHERE REF_DATE='${ref_date}'
	    and flag_ativo=1
		AND TRIM(cempresa) in ('00100', '31', '89') 
	GROUP BY 1,2,3,4,5,6,7,8,9
	)L1
INNER JOIN 
    (
    SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempresa_fr,cbalcao_fr,cnumecta_fr,zdeposit_fr) AS CHAVE_FINREP
    FROM cd_captools.kt_chaves_finrep
    WHERE REF_DATE='${ref_date}'
    HAVING CHAVE_FINREP <>'310001002006062730000000000000PC' --(MASTER 31000100200606273000000000000000 COM 2 FINREPS: 31000100200606273000000000000000 & 310001002006062730000000000000PC) 
    )L2 ON L1.CHAVE=L2.CHAVE_MASTER
INNER JOIN 
    (
    SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_FR012,ccontab_final_idcomb,ccontab_final_idcomb_total
    FROM cd_captools.fr012_master_cto
    WHERE REF_DATE='${ref_date}'
    )L3 ON L2.CHAVE_FINREP=L3.CHAVE_FR012 AND L1.ccontab_final_idcomb=L3.ccontab_final_idcomb
;

	-- Inserted 91 row(s)
	
DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.AUX_IDCOMB;
CREATE TABLE BU_CAPTOOLS_WORK.AUX_IDCOMB AS 

SELECT DISTINCT A.ccontab_final_idcomb_total,B.idcomb_sat,B.reporte_granular
FROM 
    (
    SELECT DISTINCT ccontab_final_idcomb_total 
    FROM BU_CAPTOOLS_WORK.AUX_SATELITE
    ) A, 
    (
    SELECT reporte_granular,idcomb_sat,idcomb1,idcomb2,idcomb3,idcomb4,idcomb5,idcomb6,idcomb7,idcomb8,idcomb9 
    FROM BU_CAPTOOLS_WORK.BASE_PARAM
    ) B
WHERE instr(A.ccontab_final_idcomb_total,B.idcomb1)>0
    AND instr(A.ccontab_final_idcomb_total,B.idcomb2)>0
    AND instr(A.ccontab_final_idcomb_total,B.idcomb3)>0
    AND instr(A.ccontab_final_idcomb_total,B.idcomb4)>0
    AND instr(A.ccontab_final_idcomb_total,B.idcomb5)>0
    AND instr(A.ccontab_final_idcomb_total,B.idcomb6)>0
    AND instr(A.ccontab_final_idcomb_total,B.idcomb7)>0
    AND instr(A.ccontab_final_idcomb_total,B.idcomb8)>0
    AND instr(A.ccontab_final_idcomb_total,B.idcomb9)>0
	
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 0. Tabelas auxiliares 
	--> 31000100200606273000000000000000 - Chave master com 2 chaves finrep 
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 92429 row(s)
	
DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_SAT;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_SAT AS 

SELECT 
	'Satelite 79' as reporte_granular
	,'' AS entidade
	,cempresa
	,cbalcao
	,cnumecta
	,zdeposit
	,ccontab_final_pcsb AS ccontab_final_pcsbS
	,ccontab_final_ifrs
	,ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
	,ccontab_final_idcomb
	,ccontab_final_idcomb_total
	,amount as msaldo_final
	,'' AS carteira_contabilistica
	,'' AS instrumento_financeiro
	,'' AS contraparte
	,'' AS detalhe_conta
	,'' AS tipo_conta
	,'' AS bruto_imparidade
	,'' AS composicao_valor
	,'' AS cod_plano
	,'' AS nome_perimetro
	,'ESG CORPORATIVO' AS ambito
	,1 AS FLAG_ORDEM
FROM 
    (
    SELECT * 
    FROM BU_CAPTOOLS_WORK.AUX_SATELITE 
    WHERE ccontab_final_idcomb_total IN 
            (
            SELECT ccontab_final_idcomb_total
            FROM BU_CAPTOOLS_WORK.AUX_IDCOMB
            WHERE reporte_granular='Satelite 79'
            )
    ) SAT79
UNION ALL 
SELECT 
	'Satelite 80' as reporte_granular
	,'' AS entidade
	,cempresa
	,cbalcao
	,cnumecta
	,zdeposit
	,ccontab_final_pcsb AS ccontab_final_pcsbS
	,ccontab_final_ifrs
	,ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
	,ccontab_final_idcomb
	,ccontab_final_idcomb_total
	,amount as msaldo_final
	,'' AS carteira_contabilistica
	,'' AS instrumento_financeiro
	,'' AS contraparte
	,'' AS detalhe_conta
	,'' AS tipo_conta
	,'' AS bruto_imparidade
	,'' AS composicao_valor
	,'' AS cod_plano
	,'' AS nome_perimetro
	,'ESG CORPORATIVO' AS ambito
	,1 AS FLAG_ORDEM
FROM 
    (
    SELECT * 
    FROM BU_CAPTOOLS_WORK.AUX_SATELITE 
    WHERE ccontab_final_idcomb_total IN 
            (
            SELECT ccontab_final_idcomb_total
            FROM BU_CAPTOOLS_WORK.AUX_IDCOMB
            WHERE reporte_granular='Satelite 80'
            )
    ) SAT80
UNION ALL
SELECT 
	'Satelite 83' as reporte_granular
	,'' AS entidade
	,cempresa
	,cbalcao
	,cnumecta
	,zdeposit
	,ccontab_final_pcsb AS ccontab_final_pcsbS
	,ccontab_final_ifrs
	,ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
	,ccontab_final_idcomb
	,ccontab_final_idcomb_total
	,amount as msaldo_final
	,'' AS carteira_contabilistica
	,'' AS instrumento_financeiro
	,'' AS contraparte
	,'' AS detalhe_conta
	,'' AS tipo_conta
	,'' AS bruto_imparidade
	,'' AS composicao_valor
	,'' AS cod_plano
	,'' AS nome_perimetro
	,'ESG CORPORATIVO' AS ambito
	,1 AS FLAG_ORDEM
FROM 
    (
    SELECT * 
    FROM BU_CAPTOOLS_WORK.AUX_SATELITE 
    WHERE ccontab_final_idcomb_total IN 
            (
            SELECT ccontab_final_idcomb_total
            FROM BU_CAPTOOLS_WORK.AUX_IDCOMB
            WHERE reporte_granular='Satelite 83'
            )
    ) SAT83
UNION ALL 
SELECT 
	'Satelite 84' as reporte_granular
	,'' AS entidade
	,cempresa
	,cbalcao
	,cnumecta
	,zdeposit
	,ccontab_final_pcsb AS ccontab_final_pcsbS
	,ccontab_final_ifrs
	,ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
	,ccontab_final_idcomb
	,ccontab_final_idcomb_total
	,amount as msaldo_final
	,'' AS carteira_contabilistica
	,'' AS instrumento_financeiro
	,'' AS contraparte
	,'' AS detalhe_conta
	,'' AS tipo_conta
	,'' AS bruto_imparidade
	,'' AS composicao_valor
	,'' AS cod_plano
	,'' AS nome_perimetro
	,'ESG CORPORATIVO' AS ambito
	,1 AS FLAG_ORDEM
FROM 
    (
    SELECT * 
    FROM BU_CAPTOOLS_WORK.AUX_SATELITE 
    WHERE ccontab_final_idcomb_total IN 
            (
            SELECT ccontab_final_idcomb_total
            FROM BU_CAPTOOLS_WORK.AUX_IDCOMB
            WHERE reporte_granular='Satelite 84'
            )
    ) SAT84
UNION ALL
SELECT 
	'Satelite 93' as reporte_granular
	,'' AS entidade
	,cempresa
	,cbalcao
	,cnumecta
	,zdeposit
	,ccontab_final_pcsb AS ccontab_final_pcsbS
	,ccontab_final_ifrs
	,ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
	,ccontab_final_idcomb
	,ccontab_final_idcomb_total
	,amount as msaldo_final
	,'' AS carteira_contabilistica
	,'' AS instrumento_financeiro
	,'' AS contraparte
	,'' AS detalhe_conta
	,'' AS tipo_conta
	,'' AS bruto_imparidade
	,'' AS composicao_valor
	,'' AS cod_plano
	,'' AS nome_perimetro
	,'ESG CORPORATIVO' AS ambito
	,1 AS FLAG_ORDEM
FROM 
    (
    SELECT * 
    FROM BU_CAPTOOLS_WORK.AUX_SATELITE 
    WHERE ccontab_final_idcomb_total IN 
            (
            SELECT ccontab_final_idcomb_total
            FROM BU_CAPTOOLS_WORK.AUX_IDCOMB
            WHERE reporte_granular='Satelite 93'
            )
    ) SAT93
UNION ALL
SELECT 
	'Satelite 109' as reporte_granular
	,'' AS entidade
	,cempresa
	,cbalcao
	,cnumecta
	,zdeposit
	,ccontab_final_pcsb AS ccontab_final_pcsbS
	,ccontab_final_ifrs
	,ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
	,ccontab_final_idcomb
	,ccontab_final_idcomb_total
	,amount as msaldo_final
	,'' AS carteira_contabilistica
	,'' AS instrumento_financeiro
	,'' AS contraparte
	,'' AS detalhe_conta
	,'' AS tipo_conta
	,'' AS bruto_imparidade
	,'' AS composicao_valor
	,'' AS cod_plano
	,'' AS nome_perimetro
	,'ESG CORPORATIVO' AS ambito
	,1 AS FLAG_ORDEM
FROM 
    (
    SELECT * 
    FROM BU_CAPTOOLS_WORK.AUX_SATELITE 
    WHERE ccontab_final_idcomb_total IN 
            (
            SELECT ccontab_final_idcomb_total
            FROM BU_CAPTOOLS_WORK.AUX_IDCOMB
            WHERE reporte_granular='Satelite 109'
            )
    ) SAT109
;

-- TESTE DUPLICADOS

SELECT 
	CONCAT(reporte_granular,cempresa,cbalcao,cnumecta,zdeposit,ccontab_final_pcsbS,ccontab_final_ifrs,
	ccontab_final_st_sgps_cons,ccontab_final_idcomb,ccontab_final_idcomb_total) AS CHAVE, count(*) AS N 
FROM BU_CAPTOOLS_WORK.UNIV_SAT
GROUP BY 1 ORDER BY N DESC
;

-- Tabela para comparação 

;
create table BU_CAPTOOLS_WORK.UNIV_SAT_AGR AS
SELECT F1.*,F2.idcomb_sat
FROM 
    (
    SELECT *
    FROM BU_CAPTOOLS_WORK.UNIV_SAT
    )F1
LEFT JOIN 
    (
    SELECT *
    FROM BU_CAPTOOLS_WORK.AUX_IDCOMB
    )F2 ON F1.ccontab_final_idcomb_total=F2.ccontab_final_idcomb_total
    AND F1.REPORTE_GRANULAR=F2.reporte_granular