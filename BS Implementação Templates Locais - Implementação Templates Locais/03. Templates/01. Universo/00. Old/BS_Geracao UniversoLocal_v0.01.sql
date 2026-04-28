/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 09/07/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Universo Full Local																			     ****
********************************************************************************************************************************************/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1. DEFINIÇÃO DE UNIVERSO LOCAL ST SGPS CONS 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE TABLE BU_CAPTOOLS_WORK.P3_UNIV_LOCAL_CTO AS 
SELECT
         X.ENTIDADE
        ,X.CEMPRESA	
        ,X.CBALCAO	
        ,X.CNUMECTA	
        ,X.ZDEPOSIT	
        ,X.ZCLIENTE	
        ,X.SOCIEDADE_CONTRAPARTE	
        ,X.MSALDO_FINAL
        ,X.COD_AJUST	
        ,X.INSTRUMENTO_FINANCEIRO
        ,X.CARTEIRA_CONTABILISTICA	
        ,X.STAGES	
        ,X.PRODUTO
        ,X.CONTRAPARTE_FINAL AS CONTRAPARTE	
        ,X.DATA_VENCIMENTO
        ,X.DATA_ABERTURA
        ,X.FLAG_PROJECT_FINANCE	
        ,X.CNATUREZA_JURI	
        ,X.CPAIS_RESIDENCIA
        ,X.TIPO_COLATERAL
        ,X.CCONTAB_FINAL_IDCOMB_TOTAL,
        CASE WHEN TRIM(BRUTO_IMPARIDADE) = '' AND COMPOSICAO_VALOR IN (
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
             AND UPPER(CONTRAGARANTIA) IN ('GARHIP')
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
        	AND (CONTRAPARTE = 'outras empresas nao financeiras' OR UPPER(CONTRAGARANTIA) IN ('GARHIP'))
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
       ,STRLEFT(CAST(CURRENT_TIMESTAMP() AS STRING), 10) AS PS_DATE
        -- PARTICAO
       ,1 AS ID_CORRIDA
       ,'${REF_DATE}' AS DT_RFRNC
        
FROM 
(
SELECT  DISTINCT UNI.*,
				 TIPO_COLATERAL,
				 CCONTAB_FINAL_IDCOMB_TOTAL, 
                  CASE WHEN CONCAT(UNI.CEMPRESA,UNI.CBALCAO,UNI.CNUMECTA, UNI.ZDEPOSIT) IN ('00280NCONS0000000280153108896900000')	THEN 'outras empresas nao financeiras'
                        WHEN CONCAT(UNI.CEMPRESA,UNI.CBALCAO,UNI.CNUMECTA, UNI.ZDEPOSIT) IN ('31CMAHCARG00000100C1732911SC1330')	THEN 'outras empresas nao financeiras'
                        WHEN CONCAT(UNI.CEMPRESA,UNI.CBALCAO,UNI.CNUMECTA, UNI.ZDEPOSIT) IN ('31CMAHCARG00000100C1732911SC4016')	THEN 'outras empresas nao financeiras'
                        WHEN CONCAT(UNI.CEMPRESA,UNI.CBALCAO,UNI.CNUMECTA, UNI.ZDEPOSIT) IN ('31CMAHCARG00000100C1732911SC4017')	THEN 'outras empresas nao financeiras'
                        ELSE UNI.CONTRAPARTE 
                  END AS CONTRAPARTE_FINAL                 

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
            ,DATA_VENCIMENTO
            ,DATA_ABERTURA
            ,FLAG_PROJECT_FINANCE	
            ,CNATUREZA_JURI	
            ,CPAIS_RESIDENCIA
    FROM 
    (
        SELECT 
            CT005.ENTIDADE,
            PERIMETRO.COD_ESPANA,
            CONTAS.*,
            CT623.*,
            NVL(-SALDO_CT623,MSALDO_FINAL_CT) AS MSALDO_FINAL,
            CASE WHEN CONCAT(CT005.CEMPRESA, CT005.CBALCAO, CT005.CNUMECTA, CT005.ZDEPOSIT) ='90081CMAHSGPS900810000100C180091SC0' THEN 'valias e correcoes de valor - outras' -- AJUSTE PORQUE ERRADAMENTE A CONTABILIDADE COLOCOU ESTA OPERAÇÃO NUMA CONTA DE CAPITAL E DEVERÁ SER 'valias e correcoes de valor - outras'
                WHEN CONCAT(CT005.CEMPRESA, CT005.CBALCAO, CT005.CNUMECTA, CT005.ZDEPOSIT) IN ('31CMAHCARG0000000000100C16100SC0','31CMAHCARG0000000000100C16102SC0') THEN 'amortizacoes' -- AJUSTE PORQUE ERRADAMENTE A CONTABILIDADE COLOCOU ESTA OPERAÇÃO NUMA CONTA DE CAPITAL E DEVERÁ SER 'amortizacoes'
                WHEN CONCAT(CT005.CEMPRESA, CT005.CBALCAO, CT005.CNUMECTA, CT005.ZDEPOSIT) = '00160CMAHSGPS00160000100C1991200SC1' THEN 'imp/prov - analise individual ou n/a' -- AJUSTE PORQUE ERRADAMENTE A CONTABILIDADE COLOCOU ESTA OPERAÇÃO NUMA CONTA DE CAPITAL E DEVERÁ SER 'imp/prov - analise individual ou n/a'
                ELSE COALESCE(COMP_VALOR_CT623,COMPOSICAO_VALOR_CT) END AS COMPOSICAO_VALOR,
            COALESCE(CONTRAPART_IDCOMB,FR.CONTRAPARTE) AS CONTRAPARTE, 
            FR.DATA_VENCIMENTO, 
            FR.DATA_ABERTURA,
            FR.FLAG_PROJECT_FINANCE,
            CL.CNATUREZA_JURI,
            CL.CPAIS_RESIDENCIA
            
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
        -- CRUZAMENTO PARA IR BUSCAR AQUILO QUE ESTÁ ATIVO EM CARTEIRA E O UNIVERSO DE CONTAS CONTABILISTICAS A POPULAR NO SATÉLITE ENVIADAS PELA LUÍSA SIMÕES DA CONTABILIDADE
        (
            SELECT CT.CEMPRESA,
                CT.CBALCAO,
                CT.CNUMECTA,
                CT.ZDEPOSIT,
                CT.ZCLIENTE,
                CT.CONTRAPART_IDCOMB,
                CT.SOCIEDADE_CONTRAPARTE,
                CT.MSALDO_FINAL AS MSALDO_FINAL_CT ,
                CT.CCONTAB_FINAL_ST_SGPS,
                CT.CCONTAB_FINAL_IFRS_AJUST,
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
                        END AS TYVA_IDCOMB,

            -- AJUSTES RECONCILIAÇÃO (CONTRATOS SUBIDOS COM ERRO NA CT001):
            
                        CASE 
                            WHEN  CONCAT(CEMPRESA,CBALCAO,CNUMECTA, ZDEPOSIT)='03162CMAHSGPS0316200100C18211900SC1' THEN '182119000' -- ALOCAR MOTANTE A CONTA DE VALOR BRUTO (POR ERRO DE CONTAB ESTAVA LANÇADO EM AMORTIZAÇÃO) 
                            WHEN  CONCAT(CEMPRESA,CBALCAO,CNUMECTA, ZDEPOSIT)='00280CMAHSGPS00280000100C1811912SC1' THEN '18119120'	-- ALOCAR MOTANTE A CONTA DE VALOR BRUTO (POR ERRO DE CONTAB ESTAVA LANÇADO EM AMORTIZAÇÃO) 		
                            WHEN  CONCAT(CEMPRESA,CBALCAO,CNUMECTA, ZDEPOSIT)='00280CMAHSGPS00280000100C1811914SC1' THEN '18119140' -- ALOCAR MOTANTE A CONTA DE VALOR BRUTO (POR ERRO DE CONTAB ESTAVA LANÇADO EM AMORTIZAÇÃO) 			
                            ELSE CCONTAB_FINAL_IFRS
                        END AS CCONTAB_FINAL_IFRS_AJUST
                                    
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
                                                            'INVESTIMENTOS EM ASSOCIADAS E FILIAIS EXCLUÍDAS DA CONSOLIDAÇÃO',
                                                            'ATIVOS POR IMPOSTOS', 
                                                            'ATIVOS NÃO CORRENTES DETIDOS PARA VENDA',
                                                            'ATIVOS NAO CORRENTES DETIDOS PARA VENDA', 
                                                            'ATIVOS FINANCEIROS DETIDOS PARA NEGOCIACAO',
                                                            'ATIVOS FINANCEIROS DETIDOS PARA NEGOCIAÇÃO',
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
            ON  CT.CCONTAB_FINAL_IFRS_AJUST = PC_IFRS.CONTA
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
            SELECT DISTINCT KT.CEMPRESA, KT.CBALCAO, KT.CNUMECTA, KT.ZDEPOSIT, CONTRAPARTE, DATA_VENCIMENTO,DATA_ABERTURA, FLAG_PROJECT_FINANCE
            FROM 
                (
                    SELECT CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT, CEMPRESA_FR, CBALCAO_FR, CNUMECTA_FR, ZDEPOSIT_FR 
                    FROM CD_CAPTOOLS.KT_CHAVES_FINREP WHERE REF_DATE = '${REF_DATE}'
                ) KT
            
            LEFT JOIN 
                (
                    SELECT CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT, CONTRAPARTE, DATA_VENCIMENTO, DATA_ABERTURA, FLAG_PROJECT_FINANCE 
                    FROM CD_CAPTOOLS.FR004_CTO 
                    WHERE REF_DATE = '${REF_DATE}'
                )FR4
            ON  KT.CEMPRESA_FR = FR4.CEMPRESA
            AND KT.CBALCAO_FR  = FR4.CBALCAO
            AND KT.CNUMECTA_FR = FR4.CNUMECTA
            AND KT.ZDEPOSIT_FR = FR4.ZDEPOSIT
        ) FR
        ON CONTAS.CEMPRESA  = FR.CEMPRESA
        AND CONTAS.CBALCAO  = FR.CBALCAO
        AND CONTAS.CNUMECTA = FR.CNUMECTA
        AND CONTAS.ZDEPOSIT = FR.ZDEPOSIT

        LEFT JOIN 
        (
            SELECT DISTINCT ZCLIENTE,
                CNATUREZA_JURI,
                CPAIS_RESIDENCIA, 
                NACE_CODE, 
                CCLI_GRUPO, 
                CCLI_KGL,
                CNUM_DOC_IDENTIF1
            FROM CD_CAPTOOLS.CT003_UNIV_CLI
            WHERE REF_DATE = '${REF_DATE}'
        ) CL
        ON CL.ZCLIENTE = CONTAS.ZCLIENTE
    ) XX
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,19,20,21,22,23,24,25,26
    ) UNI

    LEFT JOIN
    (
        SELECT DISTINCT CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT, CEMPRESA_FR, CBALCAO_FR, CNUMECTA_FR, ZDEPOSIT_FR 
        FROM CD_CAPTOOLS.KT_CHAVES_FINREP WHERE REF_DATE = '${REF_DATE}'
    ) KT
    ON CONCAT(KT.CEMPRESA, KT.CBALCAO, KT.CNUMECTA, KT.ZDEPOSIT) = CONCAT(UNI.CEMPRESA, UNI.CBALCAO, UNI.CNUMECTA, UNI.ZDEPOSIT) 
        
    LEFT JOIN 
    (
        SELECT DISTINCT CEMPRESA, CBALCAO, CNUMECTA, ZDEPOSIT, CCONTAB_FINAL_IDCOMB_TOTAL, CODIGO_ESPANHA,
            CASE 
                WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL1%' THEN 'Sem Garantia'
                WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL2%' THEN 'Garantia Residencial'
                WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL3%' THEN 'Garantia Comercial'
                WHEN CCONTAB_FINAL_IDCOMB_TOTAL LIKE '%COLL4%' THEN 'Garantia Real'
            END AS TIPO_COLATERAL
        FROM BU_CAPTOOLS_WORK.FR012_MASTER_CTO WHERE REF_DATE = '${REF_DATE}' 
    )FR12
        ON  KT.CEMPRESA_FR = FR12.CEMPRESA
        AND KT.CBALCAO_FR  = FR12.CBALCAO
        AND KT.CNUMECTA_FR = FR12.CNUMECTA
        AND KT.ZDEPOSIT_FR = FR12.ZDEPOSIT 
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
) X
;






