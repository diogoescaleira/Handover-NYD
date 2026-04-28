/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 09/07/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Universo Full Local																			     ****
********************************************************************************************************************************************/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1. DEFINIÇÃO DE UNIVERSO LOCAL 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- INSERT OVERWRITE TABLE BU_CAPTOOLS_WORK.AUXILIAR_UNIV_LOCAL_CTO PARTITION (ID_CORRIDA,REF_DATE)
SELECT
         X.ENTIDADE
        ,X.CEMPRESA	
        ,X.CBALCAO	
        ,X.CNUMECTA	
        ,X.ZDEPOSIT	
        ,X.ZCLIENTE	
        ,X.SOCIEDADE_CONTRAPARTE	
        ,SUM(X.MSALDO_FINAL) AS MSALDO_FINAL
        ,X.COD_AJUST	
        ,X.INSTRUMENTO_FINANCEIRO
        ,X.CARTEIRA_CONTABILISTICA	
        ,X.STAGES	
        ,X.PRODUTO
        ,X.CONTRAPARTE	
        ,X.CCONTAB_FINAL_IDCOMB_TOTAL
		,X.COMPOSICAO_VALOR
        ,X.CONTRAGARANTIA
		,X.TIPO_COLATERAL
        ,CASE WHEN TRIM(BRUTO_IMPARIDADE) = '' AND COMPOSICAO_VALOR IN (
	                                                                    'capital/ nocional/ custo de aquisicao',
	                                                                    'valias e correcoes de valor - outras',
	                                                                    'despesas/comissoes com rendimento diferido associadas ao custo amortizado',
	                                                                    'despesas/comissoes com encargo diferido associadas ao custo amortizado',
	                                                                    'valias e correcoes de valor por operacoes microcobertura',
	                                                                    'juros/encargos a pagar',
	                                                                    'juros/rendimentos a receber',
	                                                                    'despesas/comissões diferidas',
	                                                                    'valias e correcoes de valor por operacoes microcobertura') THEN 'valor bruto'
	    ELSE BRUTO_IMPARIDADE END AS BRUTO_IMPARIDADE,
        CASE WHEN UPPER(CARTEIRA_CONTABILISTICA) IN ('ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVES DE RESULTADOS', 
        									         'ATIVOS FINANCEIROS AO CUSTO AMORTIZADO', 
        									         'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE OUTRO RENDIMENTO INTEGRAL',
        									         'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE RESULTADOS',
        									         'INVESTIMENTOS EM ASSOCIADOS E FILIAIS EXCLUSIVAS DA CONSOLIDACAO'
        									         )
        	 AND UPPER(INSTRUMENTO_FINANCEIRO)   IN ('CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS',  
        										     'INSTRUMENTOS DE DIVIDA', 
        										     'INSTRUMENTOS DE CAPITAL')
        	 AND (TRIM(BRUTO_IMPARIDADE) <> ''  OR COMPOSICAO_VALOR IS NOT NULL)
        	 AND CONTRAPARTE = 'outras empresas nao financeiras'
        THEN 1 ELSE 0 END AS TEMPLATE1,
        	
        CASE WHEN UPPER(CARTEIRA_CONTABILISTICA) IN ('ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVES DE RESULTADOS', 
        									         'ATIVOS FINANCEIROS AO CUSTO AMORTIZADO', 
        									         'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE OUTRO RENDIMENTO INTEGRAL',
        									         'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE RESULTADOS')
        	 AND UPPER(INSTRUMENTO_FINANCEIRO) IN ('CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS')
             AND (UPPER(TIPO_COLATERAL) = 'GARANTIA RESIDENCIAL' OR UPPER(TIPO_COLATERAL) = 'GARANTIA COMERCIAL')
            --  AND UPPER(CONTRAGARANTIA) IN ('GARHIP')
             AND BRUTO_IMPARIDADE = 'valor bruto'
        THEN 1 ELSE 0 END AS TEMPLATE2,
         
        CASE WHEN UPPER(CARTEIRA_CONTABILISTICA) IN ('ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVES DE RESULTADOS', 
        									         'ATIVOS FINANCEIROS AO CUSTO AMORTIZADO', 
        									         'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE OUTRO RENDIMENTO INTEGRAL',
        									         'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE RESULTADOS')
        	 AND UPPER(INSTRUMENTO_FINANCEIRO)   IN ('CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS',  
        										     'INSTRUMENTOS DE DIVIDA', 
        										     'INSTRUMENTOS DE CAPITAL')
        	AND (TRIM(BRUTO_IMPARIDADE) <> ''  OR COMPOSICAO_VALOR IS NOT NULL)
        	AND (CONTRAPARTE = 'outras empresas nao financeiras' OR
            -- UPPER(CONTRAGARANTIA) IN ('GARHIP')
            (UPPER(TIPO_COLATERAL) = 'GARANTIA RESIDENCIAL' OR UPPER(TIPO_COLATERAL) = 'GARANTIA COMERCIAL'))
        THEN 1 ELSE 0 END AS TEMPLATE5,
        	
        CASE WHEN UPPER(CARTEIRA_CONTABILISTICA) IN ('ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVES DE RESULTADOS', 
												     'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE RESULTADOS',
												     'ATIVOS FINANCEIROS AO CUSTO AMORTIZADO', 
												     'DISPONIBILIDADES EM BANCOS CENTRAIS', 
												     'DISPONIBILIDADES EM OUTRAS INSTITUICOES DE CREDITO', 
												     'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE OUTRO RENDIMENTO INTEGRAL',
												     'ATIVOS INTANGIVEIS',
												     'OUTROS ATIVOS TANGIVEIS',
												     'PROPRIEDADES DE INVESTIMENTO',
												     'DERIVADOS DE COBERTURA',
												     'ATIVOS POR IMPOSTOS CORRENTES',
												     'ATIVOS POR IMPOSTOS DIFERIDOS',
												     'OUTROS ATIVOS - RESTO',
												     'INVESTIMENTOS EM ASSOCIADOS E FILIAIS EXCLUSIVAS DA CONSOLIDACAO',
												     'ATIVOS POR IMPOSTOS', 
												     'ATIVOS NAO CORRENTES DETIDOS PARA VENDA', 
												     'ATIVOS FINANCEIROS DETIDOS PARA NEGOCIACAO',
												     'CAIXA')
        	 AND UPPER(INSTRUMENTO_FINANCEIRO)   IN ('CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS',  
        										     'INSTRUMENTOS DE DIVIDA', 
        										     'INSTRUMENTOS DE CAPITAL',
        										     'DERIVADOS','')
        AND (TRIM(BRUTO_IMPARIDADE) <> 'imparidade') 
        AND ((COMPOSICAO_VALOR) NOT IN ('imp/prov - analise coletiva','imp/prov - analise individual ou n/a', 'amortizacoes','imparidade acumulada')
         OR (COMPOSICAO_VALOR) IS NULL)
        THEN 1 ELSE 0 END AS TEMPLATE7,
        
        CASE WHEN UPPER(CARTEIRA_CONTABILISTICA) IN ('ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVES DE RESULTADOS', 
        									         'ATIVOS FINANCEIROS AO CUSTO AMORTIZADO', 
        									         'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE OUTRO RENDIMENTO INTEGRAL',
        									         'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE RESULTADOS',
        									         'CAIXA',
        									         'DISPONIBILIDADES EM BANCOS CENTRAIS',
        									         'DISPONIBILIDADES EM OUTRAS INSTITUICOES DE CREDITO',
        									         'ATIVOS FINANCEIROS DETIDOS PARA NEGOCIACAO',
        									         'ATIVOS NAO CORRENTES DETIDOS PARA VENDA')
        	 AND UPPER(INSTRUMENTO_FINANCEIRO)   IN ('CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS',  
        										     'INSTRUMENTOS DE DIVIDA')
        										     
        	 AND (TRIM(BRUTO_IMPARIDADE) = 'valor bruto' OR COMPOSICAO_VALOR IN('capital/ nocional/ custo de aquisicao','juros/rendimentos a receber','valias e correcoes de valor - outras'))
        THEN 1 ELSE 0 END AS TEMPLATE10

        -- PARTICAO
       ,RT.NEW_ID_CORRIDA AS ID_CORRIDA
       ,'${REF_DATE}' AS REF_DATE
        
FROM 
(

    SELECT 
         UNI.ENTIDADE
        ,UNI.CEMPRESA	
        ,UNI.CBALCAO	
        ,UNI.CNUMECTA	
        ,UNI.ZDEPOSIT	
        ,UNI.ZCLIENTE	
        ,UNI.SOCIEDADE_CONTRAPARTE
        ,UNI.BRUTO_IMPARIDADE	
        ,SUM(UNI.MSALDO_FINAL) as MSALDO_FINAL
        ,UNI.COD_AJUST	
        ,UNI.INSTRUMENTO_FINANCEIRO
        ,UNI.CARTEIRA_CONTABILISTICA	
        ,UNI.STAGES	
        ,UNI.PRODUTO	
        ,UNI.CONTRAGARANTIA
        ,UNI.COMPOSICAO_VALOR
        ,TIPO_COLATERAL
        ,CCONTAB_FINAL_IDCOMB_TOTAL 
        ,CONTRAPARTE
        ,CCONTAB_FINAL_IFRS

FROM 
(
    SELECT 
            ENTIDADE
            ,COD_ESPANA
            ,CEMPRESA	
            ,CBALCAO	
            ,CNUMECTA	
            ,ZDEPOSIT	
            ,ZCLIENTE	
            ,CONTRAPART_IDCOMB
            ,SOCIEDADE_CONTRAPARTE	
            ,CCONTAB_FINAL_IDCOMB
            ,CCONTAB_FINAL_ST_SGPS
            ,SUM(MSALDO_FINAL) AS MSALDO_FINAL
            ,COD_AJUST	
            ,INSTRUMENTO_FINANCEIRO
            ,CARTEIRA_CONTABILISTICA	
            ,BRUTO_IMPARIDADE	
            ,STAGES	
            ,CONTRAGARANTIA
            ,COMPOSICAO_VALOR
            ,PRODUTO
            ,CONTRAPARTE
            ,CCONTAB_FINAL_IFRS
    FROM 
    (
        SELECT 
            CT005.ENTIDADE,
            PERIMETRO.COD_ESPANA,
            CONTAS.*,
            CT623.*,
            NVL(-SALDO_CT623,MSALDO_FINAL_CT) AS MSALDO_FINAL,
            COALESCE(COMP_VALOR_CT623,COMPOSICAO_VALOR_CT) AS COMPOSICAO_VALOR,
            COALESCE(CONTRAPART_IDCOMB,CT004.CONTRAPARTE) AS CONTRAPARTE
            
        FROM 
        -- CRUZAMENTO COM A CT005 PARA O PERÍMETRO LOCAL 'ST SGPS CONS' E FAZER INNER PARA AFERIR AQUILO QUE É PERÍMETRO REGULATÓRIO 
        (
            SELECT ENTIDADE, CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT
            FROM CD_CAPTOOLS.CT005_UNIV_PERIM
            WHERE NOME_PERIMETRO = 'ST SGPS Cons'
            AND REF_DATE = '${REF_DATE}'
        ) CT005
        
        INNER JOIN
        (
            SELECT DISTINCT COD_SOC_CPUS, COD_ESPANA
            FROM CD_CAPTOOLS.PERIMETRO
            WHERE ST_SGPS_PORTUGAL_REGULATORIO = 'x'
        ) PERIMETRO 
            ON CT005.ENTIDADE = PERIMETRO.COD_SOC_CPUS
        
        INNER JOIN
        -- CRUZAMENTO PARA IR BUSCAR AQUILO QUE ESTÁ ATIVO EM CARTEIRA E O UNIVERSO DE CONTAS CONTABILISTICAS A POPULAR NO SATÉLITE ENVIADAS PELA CONTABILIDADE
        (
            SELECT CT.CEMPRESA,
                CT.CBALCAO,
                CT.CNUMECTA,
                CT.ZDEPOSIT,
                CT.ZCLIENTE,
                CT.CONTRAPART_IDCOMB,
                CT.SOCIEDADE_CONTRAPARTE,
                CT.MSALDO_FINAL AS MSALDO_FINAL_CT,
                CT.CCONTAB_FINAL_ST_SGPS,
                CT.CCONTAB_FINAL_IFRS,
                CT.CCONTAB_FINAL_IDCOMB,
                CT.COD_AJUST,
                PC.TIPO_CONTA, 
                PC.INSTRUMENTO_FINANCEIRO, 
                PC.CARTEIRA_CONTABILISTICA, 
                PC.BRUTO_IMPARIDADE,
                PC.STAGES,
                PC.PRODUTO,
                PC_IFRS.CONTRAGARANTIA,
                COALESCE(PC_IFRS.COMPOSICAO_VALOR,
                            CASE WHEN TYVA_IDCOMB = 'TYVA01' THEN 'capital/ nocional/ custo de aquisicao'
                                WHEN TYVA_IDCOMB = 'TYVA02' THEN 'imparidade acumulada' END ) AS COMPOSICAO_VALOR_CT

            FROM
                (	
                    SELECT *,		
                        CASE WHEN CCONTAB_FINAL_IDCOMB LIKE '%SC0303%' THEN  'outras empresas nao financeiras'
                            WHEN CCONTAB_FINAL_IDCOMB LIKE '%SC0304%' THEN  'particulares'
                            WHEN CCONTAB_FINAL_IDCOMB LIKE '%SC0302%' THEN  'outras instituicoes financeiras'
                            WHEN CCONTAB_FINAL_IDCOMB LIKE '%SC0301%' THEN  'setor publico'
                            WHEN CCONTAB_FINAL_IDCOMB LIKE '%SC02%' THEN    'instituicoes de credito'
                            WHEN CCONTAB_FINAL_IDCOMB LIKE '%SC01%' THEN    'bancos centrais'
                        END AS CONTRAPART_IDCOMB,
                        
                        CASE WHEN CCONTAB_FINAL_IDCOMB LIKE '%TYVA01%' THEN  'TYVA01'
                            WHEN CCONTAB_FINAL_IDCOMB LIKE '%TYVA01%' THEN  'TYVA02'
                        END AS TYVA_IDCOMB
                                    
                    FROM CD_CAPTOOLS.CT001_UNIV_SALDO
                    WHERE REF_DATE = '${REF_DATE}'
                        AND FLAG_ATIVO=1 
                ) CT
            
            INNER JOIN
                (
                    SELECT *
                    FROM CD_CAPTOOLS.FR802_PL_CONTAS
                    WHERE REF_DATE = '${REF_DATE}'
                    AND DETALHE_CONTA = 'I'
                    AND TIPO_CONTA = 'A' 
                    AND COD_PLANO = 'ST_SGPS_CONS'
                    AND CONTA <> ''
                    AND UPPER(INSTRUMENTO_FINANCEIRO) IN ('CREDITO CONCEDIDO E OUTROS ATIVOS FINANCEIROS',  
                                                            'INSTRUMENTOS DE DIVIDA', 
                                                            'INSTRUMENTOS DE CAPITAL',
                                                            'DERIVADOS',
                                                            '')
                                                            
                        AND UPPER(CARTEIRA_CONTABILISTICA) IN ('ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVES DE RESULTADOS', 
                                                            'ATIVOS FINANCEIROS MANDATORIAMENTE AO JUSTO VALOR ATRAVÉS DE RESULTADOS', 
                                                            'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE RESULTADOS',
                                                            'ATIVOS FINANCEIROS AO CUSTO AMORTIZADO', 
                                                            'DISPONIBILIDADES EM BANCOS CENTRAIS', 
                                                            'DISPONIBILIDADES EM OUTRAS INSTITUIÇÕES DE CRÉDITO', 
                                                            'DISPONIBILIDADES EM OUTRAS INSTITUICOES DE CREDITO', 
                                                            'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVES DE OUTRO RENDIMENTO INTEGRAL', 
                                                            'ATIVOS FINANCEIROS AO JUSTO VALOR ATRAVÉS DE OUTRO RENDIMENTO INTEGRAL', 
                                                            'ATIVOS INTANGÍVEIS',
                                                            'ATIVOS INTANGIVEIS',
                                                            'OUTROS ATIVOS TANGIVEIS',
                                                            'DERIVADOS DE COBERTURA',
                                                            'ATIVOS POR IMPOSTOS CORRENTES',
                                                            'ATIVOS POR IMPOSTOS DIFERIDOS',
                                                            'PROPRIEDADES DE INVESTIMENTO',
                                                            'OUTROS ATIVOS - RESTO',
                                                            'INVESTIMENTOS EM ASSOCIADOS E FILIAIS EXCLUSIVAS DA CONSOLIDACAO',
                                                            'INVESTIMENTOS EM ASSOCIADAS E FILIAIS EXCLUIDAS DA CONSOLIDACAO',
                                                            'ATIVOS POR IMPOSTOS', 
                                                            'ATIVOS NÃO CORRENTES DETIDOS PARA VENDA',
                                                            'ATIVOS NAO CORRENTES DETIDOS PARA VENDA', 
                                                            'ATIVOS FINANCEIROS DETIDOS PARA NEGOCIACAO',
                                                            'ATIVOS FINANCEIROS DETIDOS PARA NEGOCIACAO',
                                                            'CAIXA')  
                ) PC
            ON PC.CONTA = CT.CCONTAB_FINAL_ST_SGPS 
            
            LEFT JOIN 
                (
                    SELECT DISTINCT CONTA, CONTRAPARTE_I, CONTRAGARANTIA, COMPOSICAO_VALOR
                    FROM CD_CAPTOOLS.FR802_PL_CONTAS 
                    WHERE COD_PLANO = 'BST_IND'
                        AND REF_DATE = '${REF_DATE}'
                ) PC_IFRS
            ON  CT.CCONTAB_FINAL_IFRS = PC_IFRS.CONTA
        )CONTAS
        ON  CT005.CEMPRESA = CONTAS.CEMPRESA
        AND CT005.CBALCAO  = CONTAS.CBALCAO
        AND CT005.CNUMECTA = CONTAS.CNUMECTA
        AND CT005.ZDEPOSIT = CONTAS.ZDEPOSIT

        LEFT JOIN 
        (
            SELECT ENTIDADE AS ENTIDADE_CT623,
                CASE 
                    WHEN TRIM(SOC_IG) = 'FCCS_No Intercompany' THEN '00000' 
                    ELSE SOC_IG 
                END AS SOC_CT623,
                CONTA AS CONTA_CT623,
                SALDO AS SALDO_CT623, 
                COMP_VALOR_DESCRICAO AS COMP_VALOR_CT623
            FROM  CD_CAPTOOLS.CT623_BALM_SGPSC 
            WHERE REF_DATE = '${REF_DATE}'
                AND CLASSIFICACAO = 'A'
                AND TRIM(VB_VS_IMP) = ''
        ) CT623
        ON  CONTAS.CCONTAB_FINAL_ST_SGPS = CT623.CONTA_CT623 
        AND CT005.ENTIDADE =  RIGHT(CT623.ENTIDADE_CT623,5)
        AND CONTAS.SOCIEDADE_CONTRAPARTE = RIGHT(CT623.SOC_CT623,5)
            
        LEFT JOIN
        (
			SELECT CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT, CONTRAPARTE
			FROM CD_CAPTOOLS.CT004_UNIV_CTO 
			WHERE REF_DATE = '${REF_DATE}'
        ) CT004
        ON CONTAS.CEMPRESA  = CT004.CEMPRESA
        AND CONTAS.CBALCAO  = CT004.CBALCAO
        AND CONTAS.CNUMECTA = CT004.CNUMECTA
        AND CONTAS.ZDEPOSIT = CT004.ZDEPOSIT
    ) XX
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,19,20,21,22
    ) UNI

    LEFT JOIN
    (
    SELECT DISTINCT KT.CEMPRESA, KT.CBALCAO, KT.CNUMECTA, KT.ZDEPOSIT,CCONTAB_FINAL_IDCOMB_TOTAL, CODIGO_ESPANHA,TIPO_COLATERAL FROM
    (
        SELECT DISTINCT CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT, CEMPRESA_FR, CBALCAO_FR, CNUMECTA_FR, ZDEPOSIT_FR 
        FROM CD_CAPTOOLS.KT_CHAVES_FINREP WHERE REF_DATE = '${REF_DATE}'
    ) KT
    LEFT JOIN 
    (
        SELECT DISTINCT CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT, CCONTAB_FINAL_IDCOMB_TOTAL, CODIGO_ESPANHA,
            CASE 
                WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL1%' THEN 'Sem Garantia'
                WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL2%' THEN 'Garantia Residencial'
                WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL3%' THEN 'Garantia Comercial'
                WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL4%' THEN 'Garantia Real'
            END AS TIPO_COLATERAL
        FROM CD_CAPTOOLS.FR012_MASTER_CTO WHERE REF_DATE = '${REF_DATE}' 
    )FR12_AUX
    ON CONCAT(CEMPRESA_FR, CBALCAO_FR, CNUMECTA_FR, ZDEPOSIT_FR) = CONCAT(FR12_AUX.CEMPRESA, FR12_AUX.CBALCAO, FR12_AUX.CNUMECTA, FR12_AUX.ZDEPOSIT) 
    ) FR12
    ON  UNI.CEMPRESA = FR12.CEMPRESA
    AND UNI.CBALCAO  = FR12.CBALCAO
    AND UNI.CNUMECTA = FR12.CNUMECTA
    AND UNI.ZDEPOSIT = FR12.ZDEPOSIT 
    AND UNI.COD_ESPANA = FR12.CODIGO_ESPANHA
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  1)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  2)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  3)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  4)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  5)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  6)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  7)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  8)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';',  9)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 10)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 11)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 12)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 13)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 14)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 15)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 16)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 17)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0
    AND LOCATE(COALESCE(CONCAT(';',SPLIT_PART(UNI.CCONTAB_FINAL_IDCOMB, ';', 18)),';'), CONCAT(';',FR12.CCONTAB_FINAL_IDCOMB_TOTAL)) > 0

    GROUP BY 1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20
) X

LEFT JOIN
(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_CAPTOOLS_WORK.AUXILIAR_UNIV_LOCAL_CTO
	WHERE REF_DATE = '${REF_DATE}'
) RT
ON  1=1
GROUP BY 1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26
;


-- INSERT OVERWRITE TABLE BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO PARTITION (ID_CORRIDA,REF_DATE)
SELECT
         X.ENTIDADE
        ,X.CEMPRESA	
        ,X.CBALCAO	
        ,X.CNUMECTA	
        ,X.ZDEPOSIT	
        ,X.ZCLIENTE	
        ,X.SOCIEDADE_CONTRAPARTE
        ,X.BRUTO_IMPARIDADE	
        ,SUM(X.MSALDO_FINAL) as MSALDO_FINAL
        ,X.COD_AJUST	
        ,X.INSTRUMENTO_FINANCEIRO
        ,X.CARTEIRA_CONTABILISTICA	
        ,X.STAGES	
        ,X.PRODUTO	
        ,X.TIPO_COLATERAL
        ,X.CCONTAB_FINAL_IDCOMB_TOTAL 
        ,X.CONTRAPARTE   
        ,CT004.DDVENCIM AS DATA_VENCIMENTO
        ,CT004.DABERTUR AS DATA_ABERTURA
        ,CT004.FLAG_PROJECT_FINANCE	
        ,CL.CNATUREZA_JURI	
        ,CL.CPAIS_RESIDENCIA
        ,X.TEMPLATE1
        ,X.TEMPLATE2
        ,X.TEMPLATE5
        ,X.TEMPLATE7
        ,X.TEMPLATE10
       
       -- PARTICAO
       ,RT.NEW_ID_CORRIDA AS ID_CORRIDA
       ,'${REF_DATE}' AS REF_DATE
        
FROM 
(SELECT * FROM BU_CAPTOOLS_WORK.AUXILIAR_UNIV_LOCAL_CTO
WHERE REF_DATE = '${REF_DATE}' AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.AUXILIAR_UNIV_LOCAL_CTO WHERE REF_DATE = '${REF_DATE}')
) X
LEFT JOIN
(
	SELECT CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT, CONTRAPARTE, DDVENCIM, DABERTUR, FLAG_PROJECT_FINANCE 
	FROM CD_CAPTOOLS.CT004_UNIV_CTO 
	WHERE REF_DATE = '${REF_DATE}'
) CT004
ON  X.CEMPRESA  = CT004.CEMPRESA AND 
    X.CBALCAO  = CT004.CBALCAO AND 
    X.CNUMECTA = CT004.CNUMECTA AND 
    X.ZDEPOSIT = CT004.ZDEPOSIT

LEFT JOIN 
(
    SELECT DISTINCT ZCLIENTE,
        CNATUREZA_JURI,
        CPAIS_RESIDENCIA
    FROM CD_CAPTOOLS.CT003_UNIV_CLI
    WHERE REF_DATE = '${REF_DATE}'
) CL
ON CL.ZCLIENTE = X.ZCLIENTE

LEFT JOIN
(
	SELECT NVL(MAX(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
	FROM BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO
	WHERE REF_DATE = '${REF_DATE}'
) RT
ON  1=1
GROUP BY 1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29
;