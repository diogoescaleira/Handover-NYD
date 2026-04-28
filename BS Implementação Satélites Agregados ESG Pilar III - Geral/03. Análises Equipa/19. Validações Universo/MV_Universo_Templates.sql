
/*===================================================================================================================================================
                                                      
											     SIMULAÇÃO TABELA UNIVERSO MODELO VERDE
										                    NEYOND 2024 - V.F.
															    
 ===================================================================================================================================================*/
 
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 0. Tabelas auxiliares 
	--> 31000100200606273000000000000000 - Chave master com 2 chaves finrep 
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 11121215 row(s)
	
DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL;
CREATE TABLE BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL AS 

SELECT DISTINCT L1.CHAVE,L1.ccontab_final_idcomb,L3.ccontab_final_idcomb_total
FROM 
    (
    SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
	    ,ccontab_final_ifrs,ccontab_final_pcsb,ccontab_final_st_sgps,ccontab_final_idcomb,sum(msaldo_final) as amount
	FROM cd_captools.ct001_univ_saldo
    WHERE REF_DATE='${ref_date}'
		AND FLAG_ATIVO=1
	GROUP BY 1,2,3,4,5,6,7,8,9
	)L1
LEFT JOIN 
    (
    SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempresa_fr,cbalcao_fr,cnumecta_fr,zdeposit_fr) AS CHAVE_FINREP
    FROM cd_captools.kt_chaves_finrep
    WHERE REF_DATE='${ref_date}'
    )L2 ON L1.CHAVE=L2.CHAVE_MASTER
LEFT JOIN 
    (
    SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_FR012,ccontab_final_idcomb,ccontab_final_idcomb_total
    FROM cd_captools.fr012_master_cto
    WHERE REF_DATE='${ref_date}'
    )L3 ON L2.CHAVE_FINREP=L3.CHAVE_FR012 AND L1.ccontab_final_idcomb=L3.ccontab_final_idcomb


--------------------------------------------------------------------------------------------------------------------------------------------------
-- 1A. Template 1
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 840.146 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_TEMP1;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_TEMP1 AS 

SELECT *
FROM
    (
    SELECT *
        ,RANK() OVER (PARTITION BY CONCAT(entidade,cempresa,cbalcao,cnumecta,zdeposit,ccontab_final_pcsbS,ccontab_final_ifrs,ccontab_final_st_sgps_cons,ccontab_final_idcomb) ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT
    FROM 
        (
        	SELECT 
        		'Template 1' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,1 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)='outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IND'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null)
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IFRS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL AND ccontab_final_idcomb_total IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 1' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,2 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)='outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'ST_SGPS_CONS'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null)
        		)F4 ON TRIM(F1.CCONTAB_FINAL_ST_SGPS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL AND ccontab_final_idcomb_total IS NOT NULL
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 1' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,3 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)='outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IDCOMB'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null)
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IDCOMB)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL AND ccontab_final_idcomb_total IS NOT NULL
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
    	)AUX 
    )AUX_2 WHERE RANK_TRAT=1
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 1B. Template 2
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 716.753 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_TEMP2;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_TEMP2 AS 

SELECT *
FROM
    (
    SELECT *
        ,RANK() OVER (PARTITION BY CONCAT(entidade,cempresa,cbalcao,cnumecta,zdeposit,ccontab_final_pcsbS,ccontab_final_ifrs,ccontab_final_st_sgps_cons,ccontab_final_idcomb) ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT
    FROM 
        (
        	SELECT 
        		'Template 2' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,1 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IND'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros')
        		and bruto_imparidade='valor bruto' 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IFRS)=TRIM(F4.CONTA)
        	INNER JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb_total LIKE '%COLL2%' OR ccontab_final_idcomb_total LIKE '%COLL3%' 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 2' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,2 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'ST_SGPS_CONS'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros')
        		and bruto_imparidade='valor bruto' 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_ST_SGPS)=TRIM(F4.CONTA)
        	INNER JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb_total LIKE '%COLL2%' OR ccontab_final_idcomb_total LIKE '%COLL3%' 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 2' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,3 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IDCOMB'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros')
        		and bruto_imparidade='valor bruto' 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IDCOMB)=TRIM(F4.CONTA)
        	INNER JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb_total LIKE '%COLL2%' OR ccontab_final_idcomb_total LIKE '%COLL3%' 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
    	)AUX 
    )AUX_2 WHERE RANK_TRAT=1
;
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 1C. Template 4
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 2.789.538 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_TEMP4;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_TEMP4 AS 

SELECT *
FROM
    (
    SELECT *
        ,RANK() OVER (PARTITION BY CONCAT(entidade,cempresa,cbalcao,cnumecta,zdeposit,ccontab_final_pcsbS,ccontab_final_ifrs,ccontab_final_st_sgps_cons,ccontab_final_idcomb) ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT
    FROM 
        (
        	SELECT 
        		'Template 4' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,1 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IND'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and bruto_imparidade='valor bruto' 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IFRS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 4' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,2 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'ST_SGPS_CONS'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and bruto_imparidade='valor bruto'
        		)F4 ON TRIM(F1.CCONTAB_FINAL_ST_SGPS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 4' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,3 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IDCOMB'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and bruto_imparidade='valor bruto'
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IDCOMB)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
    	)AUX 
    )AUX_2 WHERE RANK_TRAT=1
;
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 1D. Template 5
--------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- AUX 1 

		-- Inserted 2.519.655 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_AUX1_TEMP5;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_AUX1_TEMP5 AS 


        	SELECT 
        		'Template 5' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,1 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)='outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IND'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null) 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IFRS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 5' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,2 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)='outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'ST_SGPS_CONS'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null) 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_ST_SGPS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 5' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,3 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)='outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IDCOMB'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null) 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IDCOMB)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
;

	-- AUX 2
		-- Inserted 3.192.183 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_AUX2_TEMP5;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_AUX2_TEMP5 AS 

        	SELECT 
        		'Template 5' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,1 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)<>'outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IND'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null) 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IFRS)=TRIM(F4.CONTA)
        	INNER JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb_total LIKE '%COLL2%' OR ccontab_final_idcomb_total LIKE '%COLL3%' 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 5' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,2 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)<>'outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'ST_SGPS_CONS'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null) 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_ST_SGPS)=TRIM(F4.CONTA)
        	INNER JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb_total LIKE '%COLL2%' OR ccontab_final_idcomb_total LIKE '%COLL3%' 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 5' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,3 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        			AND TRIM(CONTRAPARTE)<>'outras empresas nao financeiras'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IDCOMB'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'investimentos em associados e filiais exclusivas da consolidacao')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital')
        		and (bruto_imparidade<>'' or composicao_valor is not null) 
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IDCOMB)=TRIM(F4.CONTA)
        	INNER JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb_total LIKE '%COLL2%' OR ccontab_final_idcomb_total LIKE '%COLL3%' 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
;

	-- TABELA FINAL 
			-- Inserted 1.904.211 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_TEMP5;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_TEMP5 AS 

SELECT *
FROM
    (
    SELECT *
        ,RANK() OVER (PARTITION BY CONCAT(entidade,cempresa,cbalcao,cnumecta,zdeposit,ccontab_final_pcsbS,ccontab_final_ifrs,ccontab_final_st_sgps_cons,ccontab_final_idcomb) ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT
    FROM 
        (
            SELECT * FROM BU_CAPTOOLS_WORK.UNIV_AUX1_TEMP5
        UNION ALL 
            SELECT * FROM BU_CAPTOOLS_WORK.UNIV_AUX2_TEMP5

    	)AUX 
    )AUX_2 WHERE RANK_TRAT=1
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 1E. Template 7
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 2.881.692 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_TEMP7;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_TEMP7 AS 

SELECT *
FROM
    (
    SELECT *
        ,RANK() OVER (PARTITION BY CONCAT(entidade,cempresa,cbalcao,cnumecta,zdeposit,ccontab_final_pcsbS,ccontab_final_ifrs,ccontab_final_st_sgps_cons,ccontab_final_idcomb) ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT
    FROM 
        (
        	SELECT 
        		'Template 7' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,1 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IND'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'disponibilidades em bancos centrais', 'disponibilidades em outras instituicoes de credito', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos intangiveis', 'outros ativos tangiveis', 'propriedades de investimento', 'derivados de cobertura', 'ativos por impostos correntes', 'ativos por impostos diferidos', 'outros ativos - resto', 'investimentos em associados e filiais exclusivas da consolidacao', 'ativos por impostos', 'ativos nao correntes detidos para venda', 'ativos financeiros detidos para negociacao', 'caixa')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital', 'derivados','')
        		AND bruto_imparidade<>'imparidade'
        		and (composicao_valor IS NULL or composicao_valor not in ('imp/prov - analise coletiva','imp/prov - analise individual ou n/a', 'amortizacoes','imparidade acumulada'))
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IFRS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 7' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,2 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'ST_SGPS_CONS'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'disponibilidades em bancos centrais', 'disponibilidades em outras instituicoes de credito', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos intangiveis', 'outros ativos tangiveis', 'propriedades de investimento', 'derivados de cobertura', 'ativos por impostos correntes', 'ativos por impostos diferidos', 'outros ativos - resto', 'investimentos em associados e filiais exclusivas da consolidacao', 'ativos por impostos', 'ativos nao correntes detidos para venda', 'ativos financeiros detidos para negociacao', 'caixa')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital', 'derivados','')
        		AND bruto_imparidade<>'imparidade'
        		and (composicao_valor IS NULL or composicao_valor not in ('imp/prov - analise coletiva','imp/prov - analise individual ou n/a', 'amortizacoes','imparidade acumulada'))
        		)F4 ON TRIM(F1.CCONTAB_FINAL_ST_SGPS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 7' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,3 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IDCOMB'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'disponibilidades em bancos centrais', 'disponibilidades em outras instituicoes de credito', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos intangiveis', 'outros ativos tangiveis', 'propriedades de investimento', 'derivados de cobertura', 'ativos por impostos correntes', 'ativos por impostos diferidos', 'outros ativos - resto', 'investimentos em associados e filiais exclusivas da consolidacao', 'ativos por impostos', 'ativos nao correntes detidos para venda', 'ativos financeiros detidos para negociacao', 'caixa')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida', 'instrumentos de capital', 'derivados','')
        		AND bruto_imparidade<>'imparidade'
        		and (composicao_valor IS NULL or composicao_valor not in ('imp/prov - analise coletiva','imp/prov - analise individual ou n/a', 'amortizacoes','imparidade acumulada'))
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IDCOMB)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
    	)AUX 
    )AUX_2 WHERE RANK_TRAT=1
;
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 1F. Template 10
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 2.789.719 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_TEMP10;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_TEMP10 AS 

SELECT *
FROM
    (
    SELECT *
        ,RANK() OVER (PARTITION BY CONCAT(entidade,cempresa,cbalcao,cnumecta,zdeposit,ccontab_final_pcsbS,ccontab_final_ifrs,ccontab_final_st_sgps_cons,ccontab_final_idcomb) ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT
    FROM 
        (
        	SELECT 
        		'Template 10' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,1 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IND'
        		AND trim(CONTA) <> ''
    		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'caixa', 'disponibilidades em bancos centrais', 'disponibilidades em outras instituicoes de credito', 'ativos financeiros detidos para negociacao', 'ativos nao correntes detidos para venda')
    		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida')
    		and (bruto_imparidade='valor bruto' or composicao_valor in('capital/ nocional/ custo de aquisicao','juros/rendimentos a receber','valias e correcoes de valor - outras'))
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IFRS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 10' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,2 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'ST_SGPS_CONS'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'caixa', 'disponibilidades em bancos centrais', 'disponibilidades em outras instituicoes de credito', 'ativos financeiros detidos para negociacao', 'ativos nao correntes detidos para venda')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida')
        		and (bruto_imparidade='valor bruto' or composicao_valor in('capital/ nocional/ custo de aquisicao','juros/rendimentos a receber','valias e correcoes de valor - outras'))
        		)F4 ON TRIM(F1.CCONTAB_FINAL_ST_SGPS)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
        UNION ALL
        	SELECT 
        		'Template 10' as reporte_granular
        		,F3.entidade
        		,F1.cempresa
        		,F1.cbalcao
        		,F1.cnumecta
        		,F1.zdeposit
        		,F1.ccontab_final_pcsb AS ccontab_final_pcsbS
        		,F1.ccontab_final_ifrs
        		,F1.ccontab_final_st_sgps AS ccontab_final_st_sgps_cons
        		,F1.ccontab_final_idcomb
        		,CASE WHEN F5.CHAVE IS NULL THEN '' ELSE F5.ccontab_final_idcomb_total END AS ccontab_final_idcomb_total
        		,F1.amount as msaldo_final
        		,F4.carteira_contabilistica
        		,F4.instrumento_financeiro
        		,F2.contraparte
        		,F4.detalhe_conta
        		,F4.tipo_conta
        		,F4.bruto_imparidade
        		,F4.composicao_valor
        		,F4.cod_plano
        		,F3.nome_perimetro
        		,'ESG LOCAL' AS ambito
        		,3 AS FLAG_ORDEM
        
        	FROM 
        		(
        		SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,cempresa,cbalcao,cnumecta,zdeposit
        			,ccontab_final_ifrs,ccontab_final_st_sgps,ccontab_final_pcsb,ccontab_final_idcomb,sum(msaldo_final) as amount
        		FROM cd_captools.ct001_univ_saldo
        		WHERE REF_DATE='${ref_date}'
					AND FLAG_ATIVO=1
        		GROUP BY 1,2,3,4,5,6,7,8,9
        		)F1
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,CONTRAPARTE
        		FROM cd_captools.ct004_univ_cto
        		WHERE REF_DATE='${ref_date}'
        		)F2 ON F1.CHAVE=F2.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE,entidade,nome_perimetro
        		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
        		WHERE REF_DATE='${ref_date}'
        			AND NOME_PERIMETRO='ST SGPS Cons'
        		)F3 ON F2.CHAVE=F3.CHAVE
        	INNER JOIN 
        		(
        		SELECT DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        		AND TIPO_CONTA = 'A' 
        		AND COD_PLANO = 'BST_IDCOMB'
        		AND trim(CONTA) <> ''
        		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'caixa', 'disponibilidades em bancos centrais', 'disponibilidades em outras instituicoes de credito', 'ativos financeiros detidos para negociacao', 'ativos nao correntes detidos para venda')
        		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida')
        		and (bruto_imparidade='valor bruto' or composicao_valor in('capital/ nocional/ custo de aquisicao','juros/rendimentos a receber','valias e correcoes de valor - outras'))
        		)F4 ON TRIM(F1.CCONTAB_FINAL_IDCOMB)=TRIM(F4.CONTA)
        	LEFT JOIN 
        	    (
                SELECT *
        		FROM BU_CAPTOOLS_WORK.AUX_IDCOMB_FINAL
        		WHERE ccontab_final_idcomb IS NOT NULL 
        	    )F5 ON F1.CHAVE=F5.CHAVE AND F1.ccontab_final_idcomb=F5.ccontab_final_idcomb
    	)AUX 
    )AUX_2 WHERE RANK_TRAT=1
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Tabela Final 
--------------------------------------------------------------------------------------------------------------------------------------------------

	-- Inserted 11.920.249 row(s)

DROP TABLE IF EXISTS BU_CAPTOOLS_WORK.UNIV_TEMP;
CREATE TABLE BU_CAPTOOLS_WORK.UNIV_TEMP AS 

    SELECT * FROM BU_CAPTOOLS_WORK.UNIV_TEMP1
UNION ALL 
    SELECT * FROM BU_CAPTOOLS_WORK.UNIV_TEMP2
UNION ALL 
    SELECT * FROM BU_CAPTOOLS_WORK.UNIV_TEMP4
UNION ALL 
    SELECT * FROM BU_CAPTOOLS_WORK.UNIV_TEMP5
UNION ALL 
    SELECT * FROM BU_CAPTOOLS_WORK.UNIV_TEMP7
UNION ALL 
    SELECT * FROM BU_CAPTOOLS_WORK.UNIV_TEMP10
	
;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Validação contra reporte 
--------------------------------------------------------------------------------------------------------------------------------------------------

-- 31000310171753091069949830100000 / Exemplo com 2 cod planos 

SELECT *
FROM 
    (
    SELECT entidade,cempresa,cbalcao,cnumecta,zdeposit,bruto_imparidade,instrumento_financeiro,carteira_contabilistica,contraparte,ccontab_final_idcomb,sum(msaldo_final) AS AMOUNT
    FROM 
        (
        SELECT *
            ,RANK() OVER (PARTITION BY CONCAT(reporte_granular,entidade,cempresa,cbalcao,cnumecta,zdeposit) ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT_2
        FROM BU_CAPTOOLS_WORK.UNIV_TEMP 
        WHERE reporte_granular='Template 1'
        )AUX WHERE RANK_TRAT_2=1
    GROUP BY 1,2,3,4,5,6,7,8,9,10
    )F1
FULL JOIN 
    (
    SELECT entidade,cempresa,cbalcao,cnumecta,zdeposit,bruto_imparidade,instrumento_financeiro,carteira_contabilistica,contraparte,ccontab_final_idcomb,sum(msaldo_final) AS AMOUNT
    FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO 
    WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA=1
        AND TEMPLATE1=1
    GROUP BY 1,2,3,4,5,6,7,8,9,10
    )F2 
ON F1.entidade=F2.entidade
    AND F1.cempresa=F2.cempresa
    AND F1.cbalcao=F2.cbalcao
    AND F1.cnumecta=F2.cnumecta
    AND F1.zdeposit=F2.zdeposit
    AND F1.bruto_imparidade=F2.bruto_imparidade
    AND F1.instrumento_financeiro=F2.instrumento_financeiro
    AND F1.carteira_contabilistica=F2.carteira_contabilistica
    AND F1.contraparte=F2.contraparte
    AND F1.ccontab_final_idcomb=F2.ccontab_final_idcomb

WHERE F2.cbalcao IS NULL
;


SELECT *
FROM 
    (
    SELECT entidade,cempresa,cbalcao,cnumecta,zdeposit,instrumento_financeiro,COMPOSICAO_VALOR,bruto_imparidade_mod,carteira_contabilistica,
        contraparte,ccontab_final_idcomb,cod_plano,sum(msaldo_final) AS AMOUNT
    FROM 
        (
        SELECT *
         ,CASE WHEN TRIM(bruto_imparidade)='' AND (COMPOSICAO_VALOR IN 
                                                (
                            	               'capital/ nocional/ custo de aquisicao',
                            	               'valias e correcoes de valor - outras',
                            	               'despesas/comissoes com rendimento diferido associadas ao custo amortizado',
                            	               'despesas/comissoes com encargo diferido associadas ao custo amortizado',
                            	               'valias e correcoes de valor por operacoes microcobertura',
                            	               'juros/encargos a pagar',
                            	               'juros/rendimentos a receber',
                            	               'despesas/comissões diferidas',
                            	               'valias e correcoes de valor por operacoes microcobertura') 
                            	               OR (ccontab_final_idcomb LIKE '%TYVA01%' AND flag_ordem IN (2,3))
                            	               ) THEN  'valor bruto'
        ELSE bruto_imparidade END AS bruto_imparidade_MOD
            ,RANK() OVER (PARTITION BY CONCAT(reporte_granular,entidade,cempresa,cbalcao,cnumecta,zdeposit) ORDER BY FLAG_ORDEM ASC) AS RANK_TRAT_2
        FROM BU_CAPTOOLS_WORK.UNIV_TEMP7
        WHERE reporte_granular='Template 7'
            AND msaldo_final<>0
            and concat(cempresa,cbalcao,cnumecta,zdeposit) in 
                                    (
                            		SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE
                            		FROM CD_CAPTOOLS.CT005_UNIV_PERIM
                            		WHERE REF_DATE='${ref_date}'
                            			AND NOME_PERIMETRO='ST SGPS Cons'
                                    )
        )AUX WHERE RANK_TRAT_2=1
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12
    )F1
FULL JOIN 
    (
    SELECT entidade,cempresa,cbalcao,cnumecta,zdeposit,bruto_imparidade,instrumento_financeiro,carteira_contabilistica,contraparte,ccontab_final_idcomb,sum(msaldo_final) AS AMOUNT
    FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO 
    WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA=1
        AND TEMPLATE7=1
    GROUP BY 1,2,3,4,5,6,7,8,9,10
    )F2 
ON F1.entidade=F2.entidade
    AND F1.cempresa=F2.cempresa
    AND F1.cbalcao=F2.cbalcao
    AND F1.cnumecta=F2.cnumecta
    AND F1.zdeposit=F2.zdeposit
    -- AND F1.COMPOSICAO_VALOR=F2.COMPOSICAO_VALOR
    -- AND F1.bruto_imparidade_MOD=F2.bruto_imparidade
    -- AND F1.instrumento_financeiro=F2.instrumento_financeiro
    AND F1.carteira_contabilistica=F2.carteira_contabilistica
    AND F1.contraparte=F2.contraparte
    AND F1.ccontab_final_idcomb=F2.ccontab_final_idcomb

WHERE F2.cbalcao IS NULL

 --F1.bruto_imparidade_MOD<>F2.bruto_imparidade
-- and CONCAT(F1.cempresa,F1.cbalcao,F1.cnumecta,F1.zdeposit)<>'03162CMAHCONS03162000100C1992199SC0'

-- GROUP BY 1

;
SELECT *--entidade,cempresa,cbalcao,cnumecta,zdeposit,bruto_imparidade,instrumento_financeiro,carteira_contabilistica,contraparte,ccontab_final_idcomb,sum(msaldo_final) AS AMOUNT
FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO 
WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA=1
    AND CONCAT(cempresa,cbalcao,cnumecta,zdeposit)='31CMAHIFRN100I18119159P482150SC0'
;
-- 12 155 023 710.054302
select *
from BU_CAPTOOLS_WORK.UNIV_TEMP7
where concat(cempresa,cbalcao,cnumecta,zdeposit)='31CMAHIFRN100I18119159P482150SC0'

;

SELECT *
FROM cd_captools.ct001_univ_saldo
WHERE ref_date='2025-06-30'
    AND concat(cempresa,cbalcao,cnumecta,zdeposit)='90081CMAHSGPS0090081000000000SECAMB'
;
SELECT *
FROM CD_CAPTOOLS.CT003_UNIV_CLI
WHERE ref_date='2025-06-30'
    AND ZCLIENTE='SPA0000001'
;


SELECT *
FROM cd_captools.ct004_univ_cto
WHERE ref_date='2025-06-30'
    AND concat(cempresa,cbalcao,cnumecta,zdeposit)='90081CMAHSGPS0090081000000000SECAMB'
;

        		SELECT *--DISTINCT conta,carteira_contabilistica,instrumento_financeiro,detalhe_conta,tipo_conta,bruto_imparidade,composicao_valor,cod_plano
        		FROM CD_CAPTOOLS.FR802_PL_CONTAS
        		WHERE REF_DATE = '${ref_date}'
        -- 		AND TIPO_CONTA = 'A' 
        -- 		AND COD_PLANO = 'BST_IND'
        		AND  trim(CONTA) IN ( '911')
        -- 		and carteira_contabilistica in ('ativos financeiros mandatoriamente ao justo valor atraves de resultados', 'ativos financeiros ao custo amortizado', 'ativos financeiros ao justo valor atraves de outro rendimento integral', 'ativos financeiros ao justo valor atraves de resultados', 'caixa', 'disponibilidades em bancos centrais', 'disponibilidades em outras instituicoes de credito', 'ativos financeiros detidos para negociacao', 'ativos nao correntes detidos para venda')
        -- 		and instrumento_financeiro in ('credito concedido e outros ativos financeiros', 'instrumentos de divida')
        -- 		and (bruto_imparidade='valor bruto' or composicao_valor in('capital/ nocional/ custo de aquisicao','juros/rendimentos a receber','valias e correcoes de valor - outras'))
        ORDER BY ref_date DESC
;

SELECT *
FROM 
    (
    SELECT *
    FROM BU_CAPTOOLS_WORK.UNIV_TEMP1 
    WHERE reporte_granular='Template 1'
    )F1
FULL JOIN 
    (
    SELECT *--entidade,cempresa,cbalcao,cnumecta,zdeposit,bruto_imparidade,instrumento_financeiro,carteira_contabilistica,contraparte,ccontab_final_idcomb,sum(msaldo_final) AS AMOUNT
    FROM bu_captools_work.modesg_out_reporte_granular
    WHERE REF_DATE = '${REF_DATE}' AND reporte_granular='Template 1'
    )F2 
ON F1.reporte_granular=F2.reporte_granular
    AND F1.entidade=F2.entidade
    AND F1.cempresa=F2.cempresa
    AND F1.cbalcao=F2.cbalcao
    AND F1.cnumecta=F2.cnumecta
    AND F1.zdeposit=F2.zdeposit
    AND F1.ccontab_final_pcsbs=F2.ccontab_final_pcsbs
    AND F1.ccontab_final_ifrs=F2.ccontab_final_ifrs
    AND F1.ccontab_final_st_sgps_cons=F2.ccontab_final_st_sgps_cons
    AND F1.ccontab_final_idcomb=F2.ccontab_final_idcomb
    AND F1.ccontab_final_idcomb_total=nvl(F2.ccontab_final_idcomb_total,'')
    AND F1.carteira_contabilistica=F2.carteira_contabilistica
    AND F1.instrumento_financeiro=F2.instrumento_financeiro
    AND F1.contraparte=F2.contraparte
    AND F1.detalhe_conta=F2.detalhe_conta
    AND F1.tipo_conta=F2.tipo_conta
    AND F1.bruto_imparidade=F2.bruto_imparidade
    AND F1.composicao_valor=F2.composicao_valor
    AND F1.cod_plano=F2.cod_plano
    AND F1.nome_perimetro=F2.nome_perimetro
    AND F1.ambito=F2.ambito

where F1.reporte_granular is null 

