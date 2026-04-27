
/*******************************************************************************************************************************************
****   Projeto: Certificação Bail-In                                                                          						    ****
****   Autor: Neyond                                                                                                                    ****
****   Data: 22/10/2025                                                                                                                 ****
****   SQL Script Descrição: Simulação da Tabela LT001       																		    ****
********************************************************************************************************************************************

/*=========================================================================================================================================*/
/*  1. TABELA GRANULAR: SIMULAÇÃO DA TABELA LT001                                                                            			   */
/*=========================================================================================================================================*/

INSERT OVERWRITE TABLE BU_CAPTOOLS_WORK.SIMUL_LT001 PARTITION (ID_CORRIDA,REF_DATE)

SELECT 
	UNIV.CEMPRESA,
	UNIV.CBALCAO,
	UNIV.CNUMECTA,
	UNIV.ZDEPOSIT
    UNIV.INSTRMNT_ID,
    UNIV.FLAG_ORIGEM,
    F1.ZCLIENTE,
	F1.CCONTAB_FINAL_PCSB,
	F1.CCONTAB_FINAL_CARGABAL,
    F1.CCONTAB_FINAL_IFRS_AUX AS CCONTAB_FINAL_IFRS,
    CAST(F1.SUM_MSALDO_FINAL_AUX AS DECIMAL(21,6)) AS AMOUNT,
    F2.CARTEIRA_CONTABILISTICA,
    F2.INSTRUMENTO_FINANCEIRO,
    F2.TIPO_CONTA,
    F2.COMPOSICAO_VALOR,
	F2.BRUTO_IMPARIDADE,
    CASE
		-- EXP_ON_A_RESTO
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.TIPO_CONTA),' ','' )) IN ('a')
			AND LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','' )) NOT IN ( 'outrosativos-resto')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.COMPOSICAO_VALOR),' ','' )) NOT IN ('juros/rendimentosareceber', 'juros/encargosapagar', 'capital/nocional/custodeaquisicao')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.BRUTO_IMPARIDADE),' ','' )) NOT IN ('imparidade')
        THEN '1'
		-- EXP_ON_A_CJ
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.TIPO_CONTA),' ','' )) IN ('a')
			AND LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','' )) NOT IN ( 'outrosativos-resto')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.COMPOSICAO_VALOR),' ','' )) IN ('juros/rendimentosareceber', 'juros/encargosapagar', 'capital/nocional/custodeaquisicao')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.BRUTO_IMPARIDADE),' ','' )) NOT IN ('imparidade')
        THEN '1'
		-- EXP_ON_P_CJ
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.TIPO_CONTA),' ','' )) IN ('p')
			AND LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','' )) NOT IN ( 'provisoesparacompromissosegarantiasconcedidas')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.COMPOSICAO_VALOR),' ','' )) IN ('juros/rendimentosareceber', 'juros/encargosapagar', 'capital/nocional/custodeaquisicao')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.BRUTO_IMPARIDADE),' ','' )) NOT IN ('imparidade')
        THEN '1'
		-- EXP_ON_P_DERV
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.TIPO_CONTA),' ','' )) IN ('p')
			AND LOWER(REGEXP_REPLACE(TRIM(F2.INSTRUMENTO_FINANCEIRO),' ','' )) IN ('derivados')
        THEN '1'
		-- EQUITY
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.TIPO_CONTA),' ','' )) IN ('c') THEN '1'
        ELSE '0'
    END AS FLAG_VALOR_BRUTO_ON,
	CASE 
		-- PROV_ON
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.TIPO_CONTA),' ','' )) IN ('a') 
			AND LOWER(REGEXP_REPLACE(TRIM(F2.BRUTO_IMPARIDADE),' ','' )) IN ('imparidade')
		THEN '1'
        ELSE '0'
    END AS FLAG_PROVISAO_ON,
	CASE
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','' )) IN ('ativosfinanceirosdetidosparanegociacao', 'ativosfinanceirosaojustovaloratravesderesultados', 'ativosnaocorrentesdetidosparavenda','passivosfinanceirosdetidosparanegociacao','passivosfinanceirosaocustoamortizado','outrospassivosfinanceirosaojustovaloratravesderesultados')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.INSTRUMENTO_FINANCEIRO),' ','' )) IN ('instrumentosdedivida', 'titulosdedividaemitidos', 'instrumentosdecapital')
        THEN '1'		
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','' )) IN ('ativosfinanceirosaojustovaloratravesdeoutrorendimentointegral') 
            AND LOWER(REGEXP_REPLACE(TRIM(F2.INSTRUMENTO_FINANCEIRO),' ','' )) IN ('instrumentosdedivida')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.TIPO_CONTA),' ','' )) IN ('a')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.COMPOSICAO_VALOR),' ','' )) NOT IN ('valiasecorrecoesdevalor-outras','valiasecorrecoesdevalorporoperacoesmicrocobertura')
        THEN '1'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','' )) IN ('ativosfinanceirosaocustoamortizado','ativosfinanceirosmandatoriamenteaojustovaloratravesderesultados')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.INSTRUMENTO_FINANCEIRO),' ','' )) IN ('instrumentosdedivida')
            AND LOWER(REGEXP_REPLACE(TRIM(F2.TIPO_CONTA),' ','' )) IN ('a')
        THEN '1'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.INSTRUMENTO_FINANCEIRO),' ','' )) IN ('instrumentosdecapital') THEN '1'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','' )) IN ('acoesproprias') THEN '1'
        ELSE '0'
    END AS FLAG_INST_TITULOS,
    CASE 
        WHEN LOWER( REGEXP_REPLACE( TRIM(F2.CARTEIRA_CONTABILISTICA) , ' ','' ) ) IN ('ativosfinanceirosaocustoamortizado','ativosfinanceirosmandatoriamenteaojustovaloratravesderesultados') 
			AND LOWER( REGEXP_REPLACE( TRIM(F2.INSTRUMENTO_FINANCEIRO) , ' ','' ) ) = 'instrumentosdedivida' 
			AND LOWER( REGEXP_REPLACE( TRIM(F2.TIPO_CONTA) , ' ','' ) ) = 'a' 
		THEN '1'
        WHEN LOWER( REGEXP_REPLACE( TRIM(F2.CARTEIRA_CONTABILISTICA) , ' ','' ) ) IN ('ativosfinanceirosaojustovaloratravesdeoutrorendimentointegral') 
			AND LOWER( REGEXP_REPLACE( TRIM(F2.INSTRUMENTO_FINANCEIRO) , ' ','' ) ) = 'instrumentosdedivida' 
			AND LOWER( REGEXP_REPLACE( TRIM(F2.TIPO_CONTA) , ' ','' ) ) = 'a' 
			AND LOWER( REGEXP_REPLACE( TRIM(F2.COMPOSICAO_VALOR) , ' ','' ) ) NOT IN ('valiasecorrecoesdevalor-outras','valiasecorrecoesdevalorporoperacoesmicrocobertura') 
		THEN  '1'
        WHEN LOWER( REGEXP_REPLACE( TRIM(F2.CARTEIRA_CONTABILISTICA) , ' ','' ) ) = 'passivosfinanceirosaocustoamortizado' 
			AND LOWER( REGEXP_REPLACE( TRIM(F2.INSTRUMENTO_FINANCEIRO) , ' ','' ) ) = 'titulosdedividaemitidos' 
			AND LOWER( REGEXP_REPLACE( TRIM(F2.TIPO_CONTA) , ' ','' ) ) = 'p' 
		THEN '1'
        ELSE '0'
    END AS FLAG_INST_DIV,
    CASE
        WHEN LOWER( REGEXP_REPLACE( TRIM(F2.INSTRUMENTO_FINANCEIRO) , ' ','' ) ) = 'instrumentosdecapital' THEN '1'
        ELSE '0'
	END AS FLAG_INST_CAP,
	CASE 
		WHEN F3.CHAVE_FR IS NOT NULL THEN '1' 
		ELSE '0'
	END AS FLAG_GAR_INTRG_SAN,
    CASE
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) IN ('garantiasecompromissosconcedidos', 'provisoesparacompromissosegarantiasconcedidas') THEN '11111111111'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) = 'ativosfinanceirosaojustovaloratravesdeoutrorendimentointegral' THEN '8'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) = 'passivosfinanceirosdetidosparanegociacao' THEN '010 Financial liabilities held for trading' --'1002'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) IN ('disponibilidadesembancoscentrais', 'disponibilidadesemoutrasinstituicoesdecredito') THEN '14'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) = 'ativosfinanceirosaojustovaloratravesderesultados' THEN '4'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) = 'ativosfinanceirosaocustoamortizado' THEN '6'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) IN ('outrosinstrumentosdecapital', 'acoesproprias', 'capital') THEN '300 Total equity' --'1100' + '1200' + '1300'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) = 'passivosfinanceirosaocustoamortizado' THEN '110 Financial liabilities at amortized cost' --'1006'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.CARTEIRA_CONTABILISTICA),' ','')) = 'ativosfinanceirosdetidosparanegociacao' THEN '2'
        WHEN LOWER(REGEXP_REPLACE(TRIM(F2.carteira_contabilistica),' ','')) = 'ativosfinanceirosmandatoriamenteaojustovaloratravesderesultados' THEN '41'
    END AS ACCNTNG_CLSSFCTN,

	-- PARTIÇÃO DA TABELA 
    RT.NEW_ID_CORRIDA AS ID_CORRIDA,
    '${REF_DATE}' AS REF_DATE

FROM 

-- TABELA DE UNIVERSO
    (
    SELECT *
    FROM 
        (
        SELECT ROW_NUMBER() OVER (PARTITION BY INSTRMNT_ID ORDER BY FLAG_ORIGEM DESC) AS RANK_1,INSTRMNT_ID,FLAG_ORIGEM
        FROM 
            (
                SELECT DISTINCT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS INSTRMNT_ID,'1' AS FLAG_ORIGEM
                FROM BU_LOANTAPE_WORK.LT801_PARAM_SEGM
                WHERE REF_DATE = '${REF_DATE}'
                    AND SEGMENTO = 'ESTR'
                    AND AMBITO='SRB_MBDT'
                    AND CBALCAO IS NOT NULL
            UNION ALL 
                SELECT DISTINCT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS INSTRMNT_ID,'2' AS FLAG_ORIGEM
                FROM BU_LOANTAPE_WORK.LT001_UNIV_OPER
                WHERE REF_DATE = '${REF_DATE}'
                    AND AMBITO='SRB_MBDT' 
            	    AND SEGMENTO='ESTR'
                    AND NOME_PERIMETRO= 'Individual Local'
            	    AND ENTIDADE='00100'
            )AUX_TRAT  
        )TRAT WHERE RANK_1=1
    )UNIV 

-- OBTER INFO DAS CONTAS E SALDOS
LEFT JOIN 
	(
	SELECT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE_SALDO
	    ,ZCLIENTE
		,CCONTAB_FINAL_PCSB
		,CCONTAB_FINAL_CARGABAL
		,TRIM(CCONTAB_FINAL_IFRS) AS CCONTAB_FINAL_IFRS_AUX 
		,SUM(MSALDO_FINAL) AS SUM_MSALDO_FINAL_AUX
	FROM CD_CAPTOOLS.FR001_UNIV_SALDO
	WHERE REF_DATE = '${REF_DATE}'
	GROUP BY 1,2,3,4,5
	)F1 ON UNIV.INSTRMNT_ID=F1.CHAVE_SALDO
	
-- OBTER CARACTERISTICAS DAS CONTAS 
LEFT JOIN 
	(
	SELECT TRIM(CONTA) AS CONTA_AUX,CARTEIRA_CONTABILISTICA,INSTRUMENTO_FINANCEIRO,TIPO_CONTA,COMPOSICAO_VALOR,BRUTO_IMPARIDADE
	FROM CD_CAPTOOLS.FR802_PL_CONTAS
	WHERE REF_DATE = '${REF_DATE}'
		AND COD_PLANO = 'BST_IND' 
		AND TRIM(CONTA) <> ''
	)F2 ON F1.CCONTAB_FINAL_IFRS_AUX=F2.CONTA_AUX
	
-- OBTER INFO DE CLIENTES INTRAGRUPO
	
LEFT JOIN 
	(
	SELECT DISTINCT FR001.CHAVE_FR
	FROM
		(
		SELECT CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE_FR
		FROM CD_CAPTOOLS.FR001_UNIV_SALDO
		WHERE REF_DATE = '${REF_DATE}'
		) FR001
	INNER JOIN
		(
		SELECT CONCAT(CEMPRESA_FR,CBALCAO_FR,CNUMECTA_FR,ZDEPOSIT_FR) AS CHAVE_FR,
			  CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) AS CHAVE_ICS
		FROM CD_CAPTOOLS.KT_CHAVES_FINREP
		WHERE REF_DATE = '${REF_DATE}'
		) KT_FR ON FR001.CHAVE_FR = KT_FR.CHAVE_FR
	INNER JOIN
		(
		SELECT CONCAT(CEMPRESP,CKBALRES,CKCTARES,CKREFRESP) AS CHAVE_ICS,
			  *
	   FROM CD_GARANTIAS.GT018_RATEIO_AVAL
	   WHERE TIPOLOGIA = 'PES'
			AND REF_DATE = '${REF_DATE}'
		) GT018 ON GT018.CHAVE_ICS = KT_FR.CHAVE_ICS
	INNER JOIN
		(
		SELECT *
		FROM CD_CAPTOOLS.CLIENTES_INTRAGRUPO
		WHERE DATA_DATE_PART = '${REF_DATE}'
		) INTRAGRUPO ON GT018.ZCLIENTE_GARANTE = INTRAGRUPO.ZCLIENTE
	INNER JOIN
		(
		SELECT *
		FROM CD_CAPTOOLS.PERIMETRO
		WHERE ESPANHA_IFRS IN ('x','B')
			AND COD_SOC_CPUS <> '00100'
			AND DATA_DATE_PART = '${REF_DATE}'
		) PERIMETRO ON INTRAGRUPO.CONSOLES = PERIMETRO.COD_ESPANA 

	) F3 ON UNIV.INSTRMNT_ID=F3.CHAVE_FR 

-- PARTIÇÃO DA TABELA 
LEFT JOIN 
    (
    SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
    FROM BU_CAPTOOLS_WORK.SIMUL_LT001
    WHERE REF_DATE = '${REF_DATE}'
    )RT ON 1=1 
;

/*=========================================================================================================================================*/
/*  AUX. Criação da tabela                                                                             			                           */
/*=========================================================================================================================================*/

DROP TABLE BU_CAPTOOLS_WORK.SIMUL_LT001;
CREATE TABLE BU_CAPTOOLS_WORK.SIMUL_LT001  
(

	CEMPRESA STRING,
	CBALCAO STRING,
	CNUMECTA STRING,
	ZDEPOSIT STRING,
	INSTRMNT_ID STRING,
	FLAG_ORIGEM STRING,
	ZCLIENTE STRING,
	CCONTAB_FINAL_PCSB STRING,
	CCONTAB_FINAL_CARGABAL STRING,
	CCONTAB_FINAL_IFRS STRING,
	AMOUNT DECIMAL(21,6),
	CARTEIRA_CONTABILISTICA STRING,
	INSTRUMENTO_FINANCEIRO STRING,
	TIPO_CONTA STRING,
	COMPOSICAO_VALOR STRING,
	BRUTO_IMPARIDADE STRING,
	FLAG_VALOR_BRUTO_ON STRING,
	FLAG_PROVISAO_ON STRING,
	FLAG_INST_TITULOS STRING,
	FLAG_INST_DIV STRING,
	FLAG_INST_CAP STRING,
	FLAG_GAR_INTRG_SAN STRING,
	ACCNTNG_CLSSFCTN STRING

)
PARTITIONED BY (ID_CORRIDA BIGINT, REF_DATE STRING);