-- CREATE TABLE bu_esg_work.SAT84_PN AS

SELECT
    IDCOMB_SATELITE,
    SOCIEDADE_CONTRAPARTE, 
    ZCLIENTE, 
    CEMPRESA_CT, 
    CBALCAO_CT,
    CNUMECTA_CT, 
    ZDEPOSIT_CT,
    AMOUNT,
    GENERAL_SPECIFIC_PURPOSE,
    INVESTMENT_SECTOR,
    ESG_SUBSECTOR_NAME,
    PURPOSE_ESG,
    SPECIFIC_ELIGIBLE,
    SPECIFIC_SUSTAINABLE,
    SPECIALISED_LENDING,
    NFRD_DISCLOSURES,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * TUCCM / 100,0) ELSE 0 END AS TUCCM,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ETCCM / 100,0) ELSE 0 END AS ETCCM,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * TRANT / 100,0) ELSE 0 END AS TRANT,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ENTCCM / 100,0) ELSE 0 END AS ENTCCM, 
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * TUCCA / 100,0) ELSE 0 END AS TUCCA,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ETCCA / 100,0) ELSE 0 END AS ETCCA,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ENTCCA / 100,0) ELSE 0 END AS ENTCCA,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * TUWTR / 100,0) ELSE 0 END AS TUWTR,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ETWTR / 100,0) ELSE 0 END AS ETWTR,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ENTWTR / 100,0) ELSE 0 END AS ENTWTR,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * TUCE / 100,0) ELSE 0 END AS TUCE,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ETCE / 100,0) ELSE 0 END AS ETCE,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ENTCE / 100,0) ELSE 0 END AS ENTCE,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * TUPPC / 100,0) ELSE 0 END AS TUPPC,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ETPPC / 100,0) ELSE 0 END AS ETPPC,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * TUBIO / 100,0) ELSE 0 END AS TUBIO,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ETBIO / 100,0) ELSE 0 END AS ETBIO,    
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * CACCM / 100,0) ELSE 0 END AS CACCM,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ECCCM / 100,0) ELSE 0 END AS ECCCM,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * TRANC / 100,0) ELSE 0 END AS TRANC,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ENCCCM / 100,0) ELSE 0 END AS ENCCCM,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * CACCA / 100,0) ELSE 0 END AS CACCA,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ECCCA / 100,0) ELSE 0 END AS ECCCA,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ENCCCA / 100,0) ELSE 0 END AS ENCCCA,		
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * CAWTR / 100,0) ELSE 0 END AS CAWTR,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ECWTR / 100,0) ELSE 0 END AS ECWTR,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ENCWTR / 100,0) ELSE 0 END AS ENCWTR,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * CACE / 100,0) ELSE 0 END AS CACE,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ECCE / 100,0) ELSE 0 END AS ECCE,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ENCCE / 100,0) ELSE 0 END AS ENCCE,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * CAPPC / 100,0) ELSE 0 END AS CAPPC,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ECPPC / 100,0) ELSE 0 END AS ECPPC,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * CABIO / 100,0) ELSE 0 END AS CABIO,
    CASE WHEN GENERAL_SPECIFIC_PURPOSE = 'GSPUR1' THEN COALESCE(AMOUNT * ECBIO / 100,0) ELSE 0 END AS ECBIO,

    ORIGINATED_DURING_PERIOD,
    EUROPEAN_UNION,
    CNAEL,
    NACE_ESG


FROM
    (
    SELECT
        IDCOMB_SATELITE,
        SOCIEDADE_CONTRAPARTE,
        zcliente, 
        CEMPRESA_CT, 
        CBALCAO_CT, 
        CNUMECTA_CT, 
        ZDEPOSIT_CT,

        -(saldo_ct) as amount,

        CASE
            WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN 'GSPUR2' -- REFERIDO NAS GUIDELINES DE OUT23_V2 QUE TODOS OS ADJUDICADOS DEVERÃO TER PROPÓSITO ESPECIFICO
            WHEN IDCOMB_SATELITE like '%MC42%' OR IDCOMB_SATELITE like '%MC43%' THEN ''
            WHEN IDCOMB_SATELITE like '%MC13%' THEN ''
            WHEN IDCOMB_SATELITE LIKE '%SC0301%' AND `33_counterparty_type` = 'setor publico'
                AND CNATUREZA_JURI IN ('121100','121210','121220','211110','211120','211130','221100','221210','121231') THEN 'GSPUR1' --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL        
            WHEN NOME_GENERAL_SPECIFIC_PURPOSE='Specific purpose' THEN 'GSPUR2'
            ELSE 'GSPUR1'
        END AS GENERAL_SPECIFIC_PURPOSE,

        CASE
            WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
            WHEN ((IDCOMB_SATELITE LIKE '%SC02%') OR (`33_COUNTERPARTY_TYPE` = 'instituicoes de credito')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS2'
            WHEN ((IDCOMB_SATELITE LIKE '%SC0301%') OR (`33_COUNTERPARTY_TYPE` = 'setor publico')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS3'
            WHEN ((IDCOMB_SATELITE LIKE '%SC0302%')  OR (`33_COUNTERPARTY_TYPE` = 'outras instituicoes financeiras')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS4'
            WHEN ((IDCOMB_SATELITE LIKE '%SC0303%')  OR (`33_COUNTERPARTY_TYPE` = 'outras empresas nao financeiras')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS5'
            ELSE '' 
        END AS INVESTMENT_SECTOR,

        case
            WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
            when idcomb_satelite like '%SC0301%' 
                and `33_counterparty_type` = 'setor publico' 
                and cnatureza_juri in ('121100','121210','121220','211110','211120','211130','221100','221210','121231') 
                then'ESGS2'  --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
            when idcomb_satelite like '%SC0301%' 
                and `33_counterparty_type` = 'setor publico' 
                then 'ESGS1'
            when idcomb_satelite like '%SC0301%' then 'ESGS1'
            when idcomb_satelite like '%SC0302%' 
                and COD_NACE_ESG in ('K65.3.0','K66.1.1','K64.3.0','K66.1.2','K66.3.0')    ---  campo nace passará a vir do universo full
                and `33_counterparty_type` = 'outras instituicoes financeiras' 
                then 'ESGS3'
            when idcomb_satelite like '%SC0302%' 
                and COD_NACE_ESG in ('K66.1.9','K64.2.0')   ---  campo nace passará a vir do universo full
                and `33_counterparty_type` = 'outras instituicoes financeiras' 
                then 'ESGS4'
            when idcomb_satelite like '%SC0302%' 
                and COD_NACE_ESG in ('K65.1.1','K65.1.2','K65.2.0', 'K66.2.1','K66.2.2','K66.2.9')    ---  campo nace passará a vir do universo full
                and `33_counterparty_type` = 'outras instituicoes financeiras' 
                then 'ESGS5'
            when idcomb_satelite like '%SC0302%' 
                and `33_counterparty_type` = 'outras instituicoes financeiras' 
                then 'ESGS6'
            when idcomb_satelite like '%SC0302%' 
                and `33_counterparty_type` = 'instituicoes de credito'  
                and COD_NACE_ESG in ('K64.1.1','K64.1.9','K64.9.1','K64.9.2','K64.9.9') 
                then 'ESGS6' ---  campo nace passará a vir do universo full            
            when idcomb_satelite like '%SC0302%' then 'ESGS6'
            when (idcomb_satelite like '%MC08%' 
                and `33_counterparty_type` = 'outras instituicoes financeiras') 
                then 'ESGS6'
            else '' 
            end as esg_subsector_name,

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
                WHEN IDCOMB_SATELITE LIKE '%MC42%' OR IDCOMB_SATELITE LIKE '%MC43%' THEN '' -- Off balance
                WHEN IDCOMB_SATELITE LIKE '%MC13%' THEN ''
                WHEN IDCOMB_SATELITE LIKE '%SC0301%' AND `33_counterparty_type` = 'setor publico' AND CNATUREZA_JURI IN ('121100','121210','121220','211110','211120','211130','221100','221210','121231') THEN '' --LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
        
                WHEN NOME_PURPOSE_ESG_ALINH_TAX='Building renovation loans' THEN 'PESG1'
                WHEN NOME_PURPOSE_ESG_ALINH_TAX='Motor vehicle loans' THEN 'PESG2'
                WHEN NOME_PURPOSE_ESG_ALINH_TAX='Building acquisition' THEN 'PESG3'
                WHEN NOME_PURPOSE_ESG_ALINH_TAX='Other purpose' THEN 'PESG4'
            -- Specialised Lending
                -- WHEN B.`29_flag_specialised_lending` = '1' THEN 'PESG4' --QD OS MODELOS FOREM ATUALIZADOS, JÁ NÃO É NECESSÁRIO TER ESTA CONDIÇÃO
                ELSE ''
            END AS PURPOSE_ESG,
            
            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN 'SELI3' -- Segundo email da Corporação o universo de adjudicados deverá sempre ser mapeado como 'No'
                WHEN IDCOMB_SATELITE LIKE '%MC13%' THEN ''
                WHEN IDCOMB_SATELITE LIKE '%MC42%' OR IDCOMB_SATELITE LIKE '%MC43%' THEN '' -- Loan commitments given e Other commitments given
                -- Sovereings
                WHEN IDCOMB_SATELITE LIKE '%SC0301%' AND `33_counterparty_type` = 'setor publico' AND
                    CNATUREZA_JURI IN ('121100','121210','121220','211110','211120','211130','221100','221210','121231') THEN 'General' --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
                WHEN NOME_SPECIFIC_ELIGIBLE='CCM' THEN 'SELI1'
                WHEN NOME_SPECIFIC_ELIGIBLE='CCA' THEN 'SELI2'
                WHEN NOME_SPECIFIC_ELIGIBLE='No' THEN 'SELI3'
                WHEN NOME_SPECIFIC_ELIGIBLE='Transition to a circular economy' THEN 'SELI4'

                -- WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='Pollution' THEN 'SELI5' ESTA MARCAÇÃO NÃO CONSTA NA TABELA
                -- WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='CCM' Biodiversity and Ecosystems 'SELI6' ESTA MARCAÇÃO NÃO CONSTA NA TABELA
                -- WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='Water and marine resources' THEN 'SELI7' ESTA MARCAÇÃO NÃO CONSTA NA TABELA
                ELSE ''
            END AS SPECIFIC_ELIGIBLE, 
            
            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Segundo email da Corporação o universo de adjudicados deverá sempre ser mapeado como 'No'
                WHEN IDCOMB_SATELITE LIKE '%MC42%' OR IDCOMB_SATELITE LIKE '%MC43%' THEN '' -- Loan commitments given e Other commitments given
                WHEN IDCOMB_SATELITE LIKE '%MC13%' THEN ''
                WHEN NOME_SPECIFIC_SUSTAINABLE='Transitional' THEN 'SSUS1'
                -- WHEN SFICS.NOME_SPECIFIC_SUSTAINABLE='Enabling' THEN 'SSUS2' ESTA OPÇÃO NÃO CONSTA NA TABELA
                WHEN NOME_SPECIFIC_SUSTAINABLE='Pure' THEN 'SSUS3'
                WHEN NOME_SPECIFIC_SUSTAINABLE='NO' THEN 'SSUS4'
                ELSE ''
            END AS SPECIFIC_SUSTAINABLE,

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
                -- WHEN A.IDCOMB_SATELITE NOT LIKE '%SC0303%' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN NOME_SPECIFIC_SUSTAINABLE='NO' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN NOME_SPECIFIC_ELIGIBLE='No' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                -- WHEN NFIN.FLG_CSRD='' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN NOME_PURPOSE_ESG_ALINH_TAX='Building renovation loans' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN CAST(`29_flag_specialised_lending` AS STRING) = '1' AND NOME_SPECIFIC_ELIGIBLE='No' THEN 'SPLE2' -- FORÇADO COM BASE NO EMAIL DA CORPORAÇÃO DE DIA 09/01/2025
                WHEN CAST(`29_flag_specialised_lending` AS STRING) = '0' AND NOME_GENERAL_SPECIFIC_PURPOSE='Specific purpose' THEN 'SPLE2' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN NOME_GENERAL_SPECIFIC_PURPOSE='General Purpose' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                ELSE ''
            END AS SPECIALISED_LENDING,

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
                WHEN (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%')
                    AND FLG_CSRD = 1 
                THEN 'NFRD1'

                WHEN IDCOMB_SATELITE LIKE '%MC08%' 
                    AND `33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    AND FLG_CSRD = 1 
                THEN 'NFRD1'

                WHEN IDCOMB_SATELITE LIKE '%SC02%'
                    AND FLG_CSRD = 1 
                THEN 'NFRD1'

                WHEN (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%')
                    AND (FLG_CSRD <> 1 OR FLG_CSRD IS NULL)
                    THEN 'NFRD2'

                WHEN IDCOMB_SATELITE LIKE '%MC08%'
                    AND `33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    AND (FLG_CSRD <> 1 OR FLG_CSRD IS NULL)
                    THEN 'NFRD2'    
                
                WHEN IDCOMB_SATELITE LIKE '%SC02%'
                    AND (FLG_CSRD <> 1 OR FLG_CSRD IS NULL)
                    THEN 'NFRD2'
                
                WHEN (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%' OR IDCOMB_SATELITE LIKE '%SC02%') THEN 'NFRD2'
                WHEN IDCOMB_SATELITE LIKE '%MC08%' AND `33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') THEN 'NFRD2'
                ELSE ''
            END AS NFRD_DISCLOSURES,

            --Turnover
            ---Mitigation
            COALESCE(CCM_TRNVR_TTL_ELGBL,0) AS TUCCM,
            COALESCE(CCM_TRNVR_OWN_PRFRMNCE_ALGND,0) AS ETCCM,
            COALESCE(CCM_TRNVR_TRNSTN_ALIGND,0) AS TRANT,
            COALESCE(CCM_TRNVR_ENBLNG_ALGND,0) AS ENTCCM, 
            ---Adaptation
            COALESCE(CCA_TRNVR_TTL_ELGBL,0) AS TUCCA,
            COALESCE(CCA_TURNOVER_OWN_PRFRMNCE_ALGND,0) AS ETCCA,
            COALESCE(CCA_TRNVR_ENBLNG_ALIGND,0) AS ENTCCA,
            --Water & Waste management
            COALESCE(WTR_TRNVR_TTL_ELGBL,0) AS TUWTR,
            COALESCE(WTR_TURNOVER_OWN_PRFRMNCE_ALGND,0) AS ETWTR,
            COALESCE(WTR_TRNVR_ENBLNG_ALIGND,0) AS ENTWTR,
            ---Circular Economy
            COALESCE(CE_TRNVR_TTL_ELGBL,0) AS TUCE,
            COALESCE(CE_TURNOVER_OWN_PRFRMNCE_ALGND,0) AS ETCE,
            COALESCE(CE_TRNVR_ENBLNG_ALIGND,0) AS ENTCE,
            ---Pollution
            COALESCE(PPC_TRNVR_TTL_ELGBL,0) AS TUPPC,
            COALESCE(PPC_TURNOVER_OWN_PRFRMNCE_ALGND,0) AS ETPPC,
            --Biodiversity
            COALESCE(BIO_TRNVR_TTL_ELGBL,0) AS TUBIO,
            COALESCE(BIO_TURNOVER_OWN_PRFRMNCE_ALGND,0) AS ETBIO,
            
            --Capex
            ---Mitigation
            COALESCE(CCM_CAPEX_TTL_ELGBL,0) AS CACCM,
            COALESCE(CCM_CAPEX_OWN_PRFRMNCE_ALGND,0) AS ECCCM,
            COALESCE(CCM_CAPEX_TRNSTN_ALGND,0) AS TRANC,
            COALESCE(CCM_CAPEX_ENBLNG_ALGND,0) AS ENCCCM,
            ---Adaptation 
            COALESCE(CCA_CAPEX_TTL_ELGBL,0) AS CACCA,
            COALESCE(CCA_CAPEX_OWN_PRFRMNCE_ALGND,0) AS ECCCA,
            COALESCE(CCA_CAPEX_ENBLNG_ALGND,0) AS ENCCCA,		
            ---Water & Waste Management
            COALESCE(WTR_CAPEX_TTL_ELGBL,0) AS CAWTR,
            COALESCE(WTR_CAPEX_OWN_PRFRMNCE_ALGND,0) AS ECWTR,
            COALESCE(WTR_CAPEX_ENBLNG_ALGND,0) AS ENCWTR,
            ---Circular Economy
            COALESCE(CE_CAPEX_TTL_ELGBL,0) AS CACE,
            COALESCE(CE_CAPEX_OWN_PRFRMNCE_ALGND,0) AS ECCE,
            COALESCE(CE_CAPEX_ENBLNG_ALGND,0) AS ENCCE,
            --Pollution
            COALESCE(PPC_CAPEX_TTL_ELGBL,0) AS CAPPC,
            COALESCE(PPC_CAPEX_OWN_PRFRMNCE_ALGND,0) AS ECPPC,
            --Biodiversity
            COALESCE(BIO_CAPEX_TTL_ELGBL,0) AS CABIO,
            COALESCE(BIO_CAPEX_OWN_PRFRMNCE_ALGND,0) AS ECBIO,

            CASE
                WHEN `84_dt_origination` >= '${ref_date_ini}' THEN 'ORDP1'		-- No reporte de junho 2024 foi utilizada a data 2024-01-01.
                ELSE 'ORDP2'
            END AS ORIGINATED_DURING_PERIOD, 

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN ''-- Apenas aplicável a id_comb SC0303 (NFC) o que não acontece para adjudicados
                WHEN ZCLIENTE ='000000' THEN 'EU1'

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL) 
                    AND (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%') 
                    AND CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                    THEN 'EU1'

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC08%' 
                    AND `33_counterparty_type` IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    AND CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                    THEN 'EU1' 

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC41%'
                    AND `33_counterparty_type` IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    AND CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                    THEN 'EU1'
                
                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%SC02%'
                    AND CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                    THEN 'EU1'           	         	   

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%') 
                    AND CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
                    THEN 'EU2' 

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC08%' 
                    AND `33_counterparty_type` IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') 
                    AND CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
                    THEN 'EU2'   
                        
                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC41%'
                    AND `33_counterparty_type` IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    AND CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
                    THEN 'EU2'

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%SC02%'
                    AND CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
                    THEN 'EU2'
            ELSE ''
            END AS EUROPEAN_UNION,

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN ''
                WHEN idcomb_satelite like '%SC0302%' and concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) in ('31641600005800050PTNOFIIE0000000','31641600005800050PTPLG8IM0001000','31641600005800050PTPL1AIM0000000','31641600005800050PTPLGEIM0004000') then '' -- correção devido a incorreto mapeamento de Contabilidade (email Nuno Pinheiro dia 26/01)
                WHEN substr(COD_NACE_ESG,1,1) = 'A' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL1'
                WHEN substr(COD_NACE_ESG,1,1) = 'B' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL2'
                WHEN substr(COD_NACE_ESG,1,1) = 'C' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL3'
                WHEN substr(COD_NACE_ESG,1,1) = 'D' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL4'
                WHEN substr(COD_NACE_ESG,1,1) = 'E' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL5'
                WHEN substr(COD_NACE_ESG,1,1) = 'F' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL6'
                WHEN substr(COD_NACE_ESG,1,1) = 'G' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL7'
                WHEN substr(COD_NACE_ESG,1,1) = 'H' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL8'
                WHEN substr(COD_NACE_ESG,1,1) = 'I' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL9'
                WHEN substr(COD_NACE_ESG,1,1) = 'J' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL10'
                WHEN substr(COD_NACE_ESG,1,1) = 'L' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL11'
                WHEN substr(COD_NACE_ESG,1,1) = 'M' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL12'  
                WHEN substr(COD_NACE_ESG,1,1) = 'N' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL13'
                WHEN substr(COD_NACE_ESG,1,1) = 'O' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL14'
                WHEN substr(COD_NACE_ESG,1,1) = 'P' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL15'
                WHEN substr(COD_NACE_ESG,1,1) = 'Q' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL16'
                WHEN substr(COD_NACE_ESG,1,1) = 'R' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL17'
                WHEN substr(COD_NACE_ESG,1,1) = 'S' and trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
                WHEN trim(`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
                WHEN trim(`33_counterparty_type`) = '' and idcomb_satelite like '%SC0303%' then 'CNAEL18'		--Adicionada nova linha de código. Validado com Luísa
                WHEN idcomb_satelite like '%SC0303%' and zcliente = '0000000000' then 'CNAEL18' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
                WHEN idcomb_satelite like '%SC0303%' and concat(cbalcao_ct,cnumecta_ct,zdeposit_ct)='6416SUPRIMENTOSPTTAE0AN0006000' then 'CNAEL18' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
                ELSE ''
            END AS CNAEL,

        CASE
            WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN ''
            WHEN TRIM(`33_COUNTERPARTY_TYPE`) = 'outras empresas nao financeiras' AND NACE_LEVEL4 IS NOT NULL THEN ID
            WHEN TRIM(`33_COUNTERPARTY_TYPE`) = 'outras empresas nao financeiras' THEN 'NACE19010303' --NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO            
            WHEN TRIM(`33_COUNTERPARTY_TYPE`) IN ('', 'resto setores / clientes') AND IDCOMB_SATELITE LIKE '%SC0303%' AND NACE_LEVEL4 IS NOT NULL THEN ID	
            WHEN TRIM(`33_COUNTERPARTY_TYPE`) IN ('', 'resto setores / clientes') AND IDCOMB_SATELITE LIKE '%SC0303%' THEN 'NACE19010303' --NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO
            
            WHEN IDCOMB_SATELITE LIKE '%MC08%' AND NACE_LEVEL4 IS NOT NULL THEN ID           
            WHEN IDCOMB_SATELITE LIKE '%MC08%' THEN 'NACE19010303' -- NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO
            
            WHEN IDCOMB_SATELITE LIKE '%SC0303%' AND ZCLIENTE = '0000000000' THEN 'NACE19010303' --INDICAÇÃO DA CONTABILIDADE DEVIDO A ASSIGNAÇÃO ERRADA DE CONTRATO SEM CONTA PCSB
            ELSE ''									
        END AS NACE_ESG
    FROM
    (
    SELECT
        A.SOCIEDADE_CONTRAPARTE,
        A.IDCOMB_SATELITE, 
        A.CEMPRESA_CT, 
        A.CBALCAO_CT, 
        A.CNUMECTA_CT, 
        A.ZDEPOSIT_CT,
        A.SALDO_CT,
        B.ZCLIENTE,
        B.`84_dt_origination`,
        B.`33_counterparty_type`,
        B.`29_flag_specialised_lending`,
        B.CPAIS_RESIDENCIA,
        SFICS.NOME_CTGR_SFICS,
        SFICS.NOME_GENERAL_SPECIFIC_PURPOSE,
        SFICS.NOME_PURPOSE_ESG_ALINH_TAX,
        SFICS.NOME_SPECIFIC_ELIGIBLE,
        SFICS.NOME_SPECIFIC_SUSTAINABLE,
        NFIN.COD_NACE_ESG,
        NFIN.FLG_CSRD,
        NFIN.CCA_TRNVR_TTL_ELGBL,
        NFIN.CCA_TRNVR_ENBLNG_ALIGND,
        NFIN.CCA_TURNOVER_OWN_PRFRMNCE_ALGND,
        NFIN.CCA_CAPEX_TTL_ELGBL,
        NFIN.CCA_CAPEX_ENBLNG_ALGND,
        NFIN.CCA_CAPEX_OWN_PRFRMNCE_ALGND,
        NFIN.CCM_TRNVR_TTL_ELGBL,
        NFIN.CCM_TRNVR_ENBLNG_ALGND,
        NFIN.CCM_TRNVR_TRNSTN_ALIGND,
        NFIN.CCM_TRNVR_OWN_PRFRMNCE_ALGND,
        NFIN.CCM_CAPEX_TTL_ELGBL,
        NFIN.CCM_CAPEX_ENBLNG_ALGND,
        NFIN.CCM_CAPEX_TRNSTN_ALGND,
        NFIN.CCM_CAPEX_OWN_PRFRMNCE_ALGND,
        NFIN.PPC_TRNVR_TTL_ELGBL,
        NFIN.PPC_TURNOVER_OWN_PRFRMNCE_ALGND,
        NFIN.PPC_CAPEX_TTL_ELGBL,
        NFIN.PPC_CAPEX_OWN_PRFRMNCE_ALGND,
        NFIN.BIO_TRNVR_TTL_ELGBL,
        NFIN.BIO_TURNOVER_OWN_PRFRMNCE_ALGND,
        NFIN.BIO_CAPEX_TTL_ELGBL,
        NFIN.BIO_CAPEX_OWN_PRFRMNCE_ALGND,
        NFIN.WTR_TRNVR_TTL_ELGBL,
        NFIN.WTR_TRNVR_ENBLNG_ALIGND,
        NFIN.WTR_TURNOVER_OWN_PRFRMNCE_ALGND,
        NFIN.WTR_CAPEX_TTL_ELGBL,
        NFIN.WTR_CAPEX_ENBLNG_ALGND,
        NFIN.WTR_CAPEX_OWN_PRFRMNCE_ALGND,
        NFIN.CE_TRNVR_TTL_ELGBL,
        NFIN.CE_TRNVR_ENBLNG_ALIGND,
        NFIN.CE_TURNOVER_OWN_PRFRMNCE_ALGND,
        NFIN.CE_CAPEX_TTL_ELGBL,
        NFIN.CE_CAPEX_ENBLNG_ALGND,
        NFIN.CE_CAPEX_OWN_PRFRMNCE_ALGND,
        CT003.CNATUREZA_JURI,
        NACE_ESG.ID,
        NACE_ESG.NACE_LEVEL4

    FROM
        (
        SELECT
            CSATELITE,
            SOCIEDADE_CONTRAPARTE,        
            IDCOMB_SATELITE,
            CEMPRESA_CT, 
            CBALCAO_CT,
            CNUMECTA_CT,
            ZDEPOSIT_CT,
            SUM(SALDO_CT) AS SALDO_CT -- Exposição
        from bu_esg_work.rf_pilar3_universo_full                       -- ALTERADA TABELA PARA NOVA TABELA DE IDCOMBS DA DATA DE REPORTE
        where DT_RFRNC = '${ref_date}' 
        and ID_CORRIDA = '1'
        and csatelite in (84) 
        and idcomb_satelite not like '%MC10%'       	
        group by 
            csatelite,
            sociedade_contraparte, 
            idcomb_satelite,
            cempresa_ct, 
            cbalcao_ct,
            cnumecta_ct,
            zdeposit_ct
        ) as a

        LEFT JOIN

        (
        SELECT DISTINCT
            cempresa_ct,
            cbalcao_ct,
            cnumecta_ct,
            zdeposit_ct,
            zcliente,
            `84_dt_origination`,
            `33_counterparty_type`,
            `29_flag_specialised_lending`,		
        
            cpais_residencia
        FROM bu_esg_work.p3_reparticao_garantias
        where DT_RFRNC = '${ref_date}' 
        and ID_CORRIDA in (select max(id_corrida) from  bu_esg_work.p3_reparticao_garantias  where DT_RFRNC = '${ref_date}' ) 
        ) as b

        on  a.cempresa_ct = b.cempresa_ct 
        and a.cbalcao_ct  = b.cbalcao_ct 
        and a.cnumecta_ct = b.cnumecta_ct 
        and a.zdeposit_ct = b.zdeposit_ct

        LEFT JOIN

        (
        SELECT
            CEMPRESA, 
            CBALCAO, 
            CNUMECTA, 
            ZDEPOSIT,

            NOME_CTGR_SFICS,
            NOME_GENERAL_SPECIFIC_PURPOSE,
            NOME_PURPOSE_ESG_ALINH_TAX,
            NOME_SPECIFIC_ELIGIBLE, 
            NOME_SPECIFIC_SUSTAINABLE        
        FROM bu_esg_work.modesg_out_sfics_taxon_europeia
        WHERE REF_DATE= '${ref_date}'
        ) SFICS

        on a.cempresa_ct = sfics.cempresa
        and a.cbalcao_ct  = sfics.cbalcao
        and a.cnumecta_ct = sfics.cnumecta
        and a.zdeposit_ct = sfics.zdeposit

        LEFT JOIN 
        
        (
        SELECT
            ZCLIENTE,
            COD_NACE_ESG,
            FLG_CSRD, 
            CCA_TRNVR_TTL_ELGBL,
            CCA_TRNVR_ENBLNG_ALIGND,
            CCA_TURNOVER_OWN_PRFRMNCE_ALGND,
            CCA_CAPEX_TTL_ELGBL,
            CCA_CAPEX_ENBLNG_ALGND,
            CCA_CAPEX_OWN_PRFRMNCE_ALGND,
            CCM_TRNVR_TTL_ELGBL,
            CCM_TRNVR_ENBLNG_ALGND,
            CCM_TRNVR_TRNSTN_ALIGND,
            CCM_TRNVR_OWN_PRFRMNCE_ALGND,
            CCM_CAPEX_TTL_ELGBL,
            CCM_CAPEX_ENBLNG_ALGND,
            CCM_CAPEX_TRNSTN_ALGND,
            CCM_CAPEX_OWN_PRFRMNCE_ALGND,
            PPC_TRNVR_TTL_ELGBL,
            PPC_TURNOVER_OWN_PRFRMNCE_ALGND,
            PPC_CAPEX_TTL_ELGBL,
            PPC_CAPEX_OWN_PRFRMNCE_ALGND,
            BIO_TRNVR_TTL_ELGBL,
            BIO_TURNOVER_OWN_PRFRMNCE_ALGND,
            BIO_CAPEX_TTL_ELGBL,
            BIO_CAPEX_OWN_PRFRMNCE_ALGND,
            WTR_TRNVR_TTL_ELGBL,
            WTR_TRNVR_ENBLNG_ALIGND,
            WTR_TURNOVER_OWN_PRFRMNCE_ALGND,
            WTR_CAPEX_TTL_ELGBL,
            WTR_CAPEX_ENBLNG_ALGND,
            WTR_CAPEX_OWN_PRFRMNCE_ALGND,
            CE_TRNVR_TTL_ELGBL,
            CE_TRNVR_ENBLNG_ALIGND,
            CE_TURNOVER_OWN_PRFRMNCE_ALGND,
            CE_CAPEX_TTL_ELGBL,
            CE_CAPEX_ENBLNG_ALGND,
            CE_CAPEX_OWN_PRFRMNCE_ALGND
        FROM BU_ESG_WORK.MODESG_OUT_EMPR_INFO_NFIN
        WHERE REF_DATE='${ref_date}'
        ) NFIN

        ON B.ZCLIENTE = NFIN.ZCLIENTE

        LEFT JOIN

        (
        SELECT
            zcliente, 
            cnatureza_juri
        FROM cd_captools.ct003_univ_cli
        WHERE ref_date='${ref_date}'
        ) AS ct003
        
        ON b.zcliente=ct003.ZCLIENTE

        LEFT JOIN
        
        (
        SELECT *
        FROM BU_ESG_WORK.NACE_ESG_PILLAR3 
        ) AS NACE_ESG		--CRIAR TABELA DE EXCEL A IMPORTAR COM BASE NA NOVA MARCAÇÃO DO EXCEL SAT 79 CASO MUDEM OS NACE QUE A CORPORAÇÃO ENVIA

        -- ON CONCAT(SPLIT_PART(B.`15_NACE_ESG`,".",1),SPLIT_PART(B.`15_NACE_ESG`,".",2),SPLIT_PART(B.`15_NACE_ESG`,".",3)) = TRIM(SPLIT_PART(NACE_ESG.NACE_LEVEL4, "-",1))

        ON CONCAT(SPLIT_PART(NFIN.COD_NACE_ESG,".",1),SPLIT_PART(NFIN.COD_NACE_ESG,".",2),SPLIT_PART(NFIN.COD_NACE_ESG,".",3)) = TRIM(SPLIT_PART(NACE_ESG.NACE_LEVEL4, "-",1))

        WHERE concat(A.cempresa_ct,A.cbalcao_ct,A.cnumecta_ct,A.zdeposit_ct) NOT IN ('00100CMAHAJID0000232600421BI0041100') -- Contrato removido por estar a gerar combinação inválida, não tem peso relevante (1 €) e foi decidido remover

        UNION ALL

        SELECT
            A.SOCIEDADE_CONTRAPARTE,        
            A.IDCOMB_SATELITE,
            NULL AS CEMPRESA_CT, 
            NULL AS CBALCAO_CT,
            NULL AS CNUMECTA_CT,
            NULL AS ZDEPOSIT_CT,
            CASE 
                WHEN A.CARGABAL_CT = '' THEN -A.SALDO_CT
                ELSE ADJUD_INPUTS.V_CONTAB * -1
            END AS AMOUNT,
            NULL AS ZCLIENTE,
            DATA_AQUISICAO,
            NULL AS `33_counterparty_type`,
            NULL AS `29_flag_specialised_lending`,
            NULL AS CPAIS_RESIDENCIA,
            NULL AS NOME_CTGR_SFICS,
            NULL AS NOME_GENERAL_SPECIFIC_PURPOSE,
            NULL AS NOME_PURPOSE_ESG_ALINH_TAX,
            NULL AS NOME_SPECIFIC_ELIGIBLE,
            NULL AS NOME_SPECIFIC_SUSTAINABLE,
            NULL AS COD_NACE_ESG,
            NULL AS FLG_CSRD,
            NULL AS CCA_TRNVR_TTL_ELGBL,
            NULL AS CCA_TRNVR_ENBLNG_ALIGND,
            NULL AS CCA_TURNOVER_OWN_PRFRMNCE_ALGND,
            NULL AS CCA_CAPEX_TTL_ELGBL,
            NULL AS CCA_CAPEX_ENBLNG_ALGND,
            NULL AS CCA_CAPEX_OWN_PRFRMNCE_ALGND,
            NULL AS CCM_TRNVR_TTL_ELGBL,
            NULL AS CCM_TRNVR_ENBLNG_ALGND,
            NULL AS CCM_TRNVR_TRNSTN_ALIGND,
            NULL AS CCM_TRNVR_OWN_PRFRMNCE_ALGND,
            NULL AS CCM_CAPEX_TTL_ELGBL,
            NULL AS CCM_CAPEX_ENBLNG_ALGND,
            NULL AS CCM_CAPEX_TRNSTN_ALGND,
            NULL AS CCM_CAPEX_OWN_PRFRMNCE_ALGND,
            NULL AS PPC_TRNVR_TTL_ELGBL,
            NULL AS PPC_TURNOVER_OWN_PRFRMNCE_ALGND,
            NULL AS PPC_CAPEX_TTL_ELGBL,
            NULL AS PPC_CAPEX_OWN_PRFRMNCE_ALGND,
            NULL AS BIO_TRNVR_TTL_ELGBL,
            NULL AS BIO_TURNOVER_OWN_PRFRMNCE_ALGND,
            NULL AS BIO_CAPEX_TTL_ELGBL,
            NULL AS BIO_CAPEX_OWN_PRFRMNCE_ALGND,
            NULL AS WTR_TRNVR_TTL_ELGBL,
            NULL AS WTR_TRNVR_ENBLNG_ALIGND,
            NULL AS WTR_TURNOVER_OWN_PRFRMNCE_ALGND,
            NULL AS WTR_CAPEX_TTL_ELGBL,
            NULL AS WTR_CAPEX_ENBLNG_ALGND,
            NULL AS WTR_CAPEX_OWN_PRFRMNCE_ALGND,
            NULL AS CE_TRNVR_TTL_ELGBL,
            NULL AS CE_TRNVR_ENBLNG_ALIGND,
            NULL AS CE_TURNOVER_OWN_PRFRMNCE_ALGND,
            NULL AS CE_CAPEX_TTL_ELGBL,
            NULL AS CE_CAPEX_ENBLNG_ALGND,
            NULL AS CE_CAPEX_OWN_PRFRMNCE_ALGND,
            NULL AS CNATUREZA_JURI,
            NULL ID,
            NULL NACE_LEVEL4

        FROM        
            (
            SELECT
                CSATELITE,
                SOCIEDADE_CONTRAPARTE,        
                IDCOMB_SATELITE,
                -- CEMPRESA_CT, 
                -- CBALCAO_CT,
                -- CNUMECTA_CT,
                -- ZDEPOSIT_CT,
                CARGABAL_CT,
                SUM(SALDO_CT) as SALDO_CT -- Exposição
            from bu_esg_work.rf_pilar3_universo_full                       -- ALTERADA TABELA PARA NOVA TABELA DE IDCOMBS DA DATA DE REPORTE
            where DT_RFRNC = '${ref_date}' 
            and ID_CORRIDA = '1'
            and csatelite in (84) 
            and idcomb_satelite  like '%MC10%'       	
            group by 
                csatelite,
                sociedade_contraparte, 
                idcomb_satelite,
                -- cempresa_ct, 
                -- cbalcao_ct,
                -- cnumecta_ct,
                -- zdeposit_ct,
                CARGABAL_CT
            ) as A

            LEFT JOIN

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

                V_CONTAB_IFRS, 
                V_CONTAB, 
                DATA_AQUISICAO
            FROM cd_captools.ct666_adjudic_propr
            WHERE ref_date='${ref_date}'
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
                
                V_CONTAB_IFRS, 
                V_CONTAB,
                strleft(CAST(DATE_ADD('1899-12-30', cast(data_aquisicao AS DECIMAL(12,0))) AS STRING), 10) AS DATA_AQUISICAO
            FROM cd_captools.ct667_dacoes_arrem
            WHERE ref_date='${ref_date}'
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

                V_CONTAB_IFRS, 
                V_CONTAB,
                -- DATA_ENTRADA AS DATA_AQUISICAO
                strleft(CAST(DATE_ADD('1899-12-30', cast(DATA_ENTRADA AS DECIMAL(12,0))) AS STRING), 10) AS DATA_AQUISICAO
            FROM cd_captools.ct668_imoveis_ific
            WHERE ref_date='${ref_date}'
            AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')
            ) ADJUD_INPUTS
            
            ON A.CARGABAL_CT= ADJUD_INPUTS.CARGABAL_VC    
        ) X1
    ) X

;






-- AGREGADO --

SELECT
    INFORMING_SOC, 
    COUNTERPARTY_SOC, 
    ADJUSTMENT_CODE,
    REGEXP_REPLACE(REGEXP_REPLACE(comb_code, ';+', ';'),';$','') as COMB_CODE,
    AMOUNT,
    EU,
    CNAEL, 
    NACE,  
    TUCCM,
    etccm,
    trant,
    entccm,
    tucca,
    etcca,
    entcca,
    TUWTR,
    ETWTR,
    ENTWTR,
    TUCE,
    ETCE,
    ENTCE,
    TUPPC,
    ETPPC,
    TUBIO,
    ETBIO,
    CACCM,
    ecccm,
    tranc,
    encccm,
    cacca,
    eccca,
    enccca,
    CAWTR,
    ECWTR,
    ENCWTR,
    CACE,
    ECCE,
    ENCCE,
    CAPPC,
    ECPPC,
    CABIO,
    ECBIO
FROM 
    (
    SELECT
        '00411' as INFORMING_SOC,
        CASE 
            WHEN SOCIEDADE_CONTRAPARTE = '' then '00000'
      WHEN SOCIEDADE_CONTRAPARTE = '01278' then '00000'           
            else SOCIEDADE_CONTRAPARTE
        end as COUNTERPARTY_SOC,
        'BI00411' as ADJUSTMENT_CODE,
        case 
            when IDCOMB_SATELITE like  'M01;MC42%'      
       OR IDCOMB_SATELITE like 'M01;MC4302%'    
       OR IDCOMB_SATELITE like 'M01;MC4301%'    
       OR IDCOMB_SATELITE like '%MC1301%'       
       OR IDCOMB_SATELITE like '%ACPF7%'        
       OR IDCOMB_SATELITE like '%ACPF2%'        
       OR IDCOMB_SATELITE like '%MC02;TYVA01%'  
       OR IDCOMB_SATELITE like '%MC06;TYVA01%'  
       OR IDCOMB_SATELITE like '%MC01%'         
       OR IDCOMB_SATELITE like '%MC05%'         
       OR IDCOMB_SATELITE like '%MC11%'         
       OR IDCOMB_SATELITE like '%MC12%'         
       OR IDCOMB_SATELITE like '%MC13%'         
       OR (IDCOMB_SATELITE like '%MC02%'  and IDCOMB_SATELITE like '%SC01%') -- Adição de condição para ""Cash and cash balances at central banks and other demand deposits"" de central banks com base no MdD  
       then concat(IDCOMB_SATELITE,';',ORIGINATED_DURING_PERIOD)
      
      when IDCOMB_SATELITE like '%MC02%'  and IDCOMB_SATELITE like '%SC02%' and IDCOMB_SATELITE like '%ACPF1%'      -- Adição de condição para ""Cash and cash balances at central banks and other demand deposits"" de credit institutions com base no MdD  
       then concat(IDCOMB_SATELITE,';',NFRD_DISCLOSURES,';', ORIGINATED_DURING_PERIOD)
      
      when IDCOMB_SATELITE like '%SC0302%'
       then concat(IDCOMB_SATELITE,';', ESG_SUBSECTOR_NAME,';', NFRD_DISCLOSURES, ';', ORIGINATED_DURING_PERIOD, ';', GENERAL_SPECIFIC_PURPOSE, ';', SPECIALISED_LENDING, ';', SPECIFIC_ELIGIBLE,';', SPECIFIC_SUSTAINABLE) 
      else concat(IDCOMB_SATELITE,';',INVESTMENT_SECTOR,';', ESG_SUBSECTOR_NAME,';',PURPOSE_ESG,';', NFRD_DISCLOSURES, ';', ORIGINATED_DURING_PERIOD, ';', GENERAL_SPECIFIC_PURPOSE, ';', SPECIALISED_LENDING,';',SPECIFIC_ELIGIBLE,';', SPECIFIC_SUSTAINABLE) 
     end as COMB_CODE,
     ROUND(SUM(AMOUNT),0) as AMOUNT,
     EUROPEAN_UNION AS EU,
        CASE 
            WHEN idcomb_satelite like '%SC0304%' and cnael<>'' then '' 
            when idcomb_satelite not like '%SC0303%' and Investment_Sector <> 'INVS5' then ''
            ELSE CNAEL 
        END AS CNAEL, 
        CASE 
            WHEN idcomb_satelite like '%SC0304%' and NACE_ESG <>'' then '' 
            when idcomb_satelite not like '%SC0303%' and Investment_Sector <> 'INVS5' then ''
            ELSE NACE_ESG
        END AS NACE,
     
        round (sum(TUCCM),0) as TUCCM,
        round (sum(etccm),0) as etccm,
        round (sum(trant),0) as trant,
        round (sum(entccm),0) as entccm,
        round (sum(tucca),0) as tucca,
        round (sum(etcca),0) as etcca,
        round (sum(entcca),0) as entcca,
        round (sum(TUWTR),0) as TUWTR,
        round (sum(ETWTR),0) as ETWTR,
        round (sum(ENTWTR),0) as ENTWTR,
        round (sum(TUCE),0) as TUCE,
        round (sum(ETCE),0) as ETCE,
        round (sum(ENTCE),0) as ENTCE,
        round (sum(TUPPC),0) as TUPPC,
        round (sum(ETPPC),0) as ETPPC,
        round (sum(TUBIO),0) as TUBIO,
        round (sum(ETBIO),0) as ETBIO,
        round (sum(CACCM),0) as CACCM,
        round (sum(ecccm),0) as ecccm,
        round (sum(tranc),0) as tranc,
        round (sum(encccm),0) as encccm,
        round (sum(cacca),0) as cacca,
        round (sum(eccca),0) as eccca,
        round (sum(enccca),0) as enccca,
     round (sum(CAWTR),0) as CAWTR,
        round (sum(ECWTR),0) as ECWTR,
        round (sum(ENCWTR),0) as ENCWTR,
        round (sum(CACE),0) as CACE,
        round (sum(ECCE),0) as ECCE,
        round (sum(ENCCE),0) as ENCCE,
        round (sum(CAPPC),0) as CAPPC,
        round (sum(ECPPC),0) as ECPPC,
        round (sum(CABIO),0) as CABIO,
        round (sum(ECBIO),0) as ECBIO
     
    FROM bu_esg_work.SAT84_PN_01
    GROUP BY 1,2,3,4,6,7,8
    ) X
WHERE amount <> 0
;











SELECT
    INFORMING_SOC, 
    COUNTERPARTY_SOC, 
    ADJUSTMENT_CODE,
    REGEXP_REPLACE(REGEXP_REPLACE(comb_code, ';+', ';'),';$','') as COMB_CODE,
    AMOUNT,
    EU,
    CNAEL, 
    NACE,
    
    CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCCM IS NULL THEN 0 ELSE TUCCM END AS TUCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCCM IS NULL THEN 0 ELSE ETCCM END AS ETCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TRANT IS NULL THEN 0 ELSE TRANT END AS TRANT,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCCM IS NULL THEN 0 ELSE ENTCCM END AS ENTCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCCA IS NULL THEN 0 ELSE TUCCA END AS TUCCA,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCCA IS NULL THEN 0 ELSE ETCCA END AS ETCCA,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCCA IS NULL THEN 0 ELSE ENTCCA END AS ENTCCA,

		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUWTR IS NULL THEN 0 ELSE TUWTR END AS TUWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETWTR IS NULL THEN 0 ELSE ETWTR END AS ETWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTWTR IS NULL THEN 0 ELSE ENTWTR END AS ENTWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCE IS NULL THEN 0 ELSE TUCE END AS TUCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCE IS NULL THEN 0 ELSE ETCE END AS ETCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCE IS NULL THEN 0 ELSE ENTCE END AS ENTCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUPPC IS NULL THEN 0 ELSE TUPPC END AS TUPPC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETPPC IS NULL THEN 0 ELSE ETPPC END AS ETPPC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUBIO IS NULL THEN 0 ELSE TUBIO END AS TUBIO,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETBIO IS NULL THEN 0 ELSE ETBIO END AS ETBIO,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACCM IS NULL THEN 0 ELSE CACCM END AS CACCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCCM IS NULL THEN 0 ELSE ECCCM END AS ECCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TRANC IS NULL THEN 0 ELSE TRANC END AS TRANC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCCM IS NULL THEN 0 ELSE ENCCCM END AS ENCCCM,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACCA IS NULL THEN 0 ELSE CACCA END AS CACCA,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCCA IS NULL THEN 0 ELSE ECCCA END AS ECCCA,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCCA IS NULL THEN 0 ELSE ENCCCA END AS ENCCCA,

		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CAWTR IS NULL THEN 0 ELSE CAWTR END AS CAWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECWTR IS NULL THEN 0 ELSE ECWTR END AS ECWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCWTR IS NULL THEN 0 ELSE ENCWTR END AS ENCWTR,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACE IS NULL THEN 0 ELSE CACE END AS CACE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCE IS NULL THEN 0 ELSE ECCE END AS ECCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCE IS NULL THEN 0 ELSE ENCCE END AS ENCCE,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CAPPC IS NULL THEN 0 ELSE CAPPC END AS CAPPC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECPPC IS NULL THEN 0 ELSE ECPPC END AS ECPPC,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CABIO IS NULL THEN 0 ELSE CABIO END AS CABIO,
		CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECBIO IS NULL THEN 0 ELSE ECBIO END AS ECBIO
FROM 
    (
    SELECT
        '00411' as INFORMING_SOC,
        CASE 
            WHEN SOCIEDADE_CONTRAPARTE = '' then '00000'
      WHEN SOCIEDADE_CONTRAPARTE = '01278' then '00000'           
            else SOCIEDADE_CONTRAPARTE
        end as COUNTERPARTY_SOC,
        'BI00411' as ADJUSTMENT_CODE,
        case 
            when IDCOMB_SATELITE like  'M01;MC42%'      
       OR IDCOMB_SATELITE like 'M01;MC4302%'    
       OR IDCOMB_SATELITE like 'M01;MC4301%'    
       OR IDCOMB_SATELITE like '%MC1301%'       
       OR IDCOMB_SATELITE like '%ACPF7%'        
       OR IDCOMB_SATELITE like '%ACPF2%'        
       OR IDCOMB_SATELITE like '%MC02;TYVA01%'  
       OR IDCOMB_SATELITE like '%MC06;TYVA01%'  
       OR IDCOMB_SATELITE like '%MC01%'         
       OR IDCOMB_SATELITE like '%MC05%'         
       OR IDCOMB_SATELITE like '%MC11%'         
       OR IDCOMB_SATELITE like '%MC12%'         
       OR IDCOMB_SATELITE like '%MC13%'         
       OR (IDCOMB_SATELITE like '%MC02%'  and IDCOMB_SATELITE like '%SC01%') -- Adição de condição para ""Cash and cash balances at central banks and other demand deposits"" de central banks com base no MdD  
       then concat(IDCOMB_SATELITE,';',ORIGINATED_DURING_PERIOD)
      
      when IDCOMB_SATELITE like '%MC02%'  and IDCOMB_SATELITE like '%SC02%' and IDCOMB_SATELITE like '%ACPF1%'      -- Adição de condição para ""Cash and cash balances at central banks and other demand deposits"" de credit institutions com base no MdD  
       then concat(IDCOMB_SATELITE,';',NFRD_DISCLOSURES,';', ORIGINATED_DURING_PERIOD)
      
      when IDCOMB_SATELITE like '%SC0302%'
       then concat(IDCOMB_SATELITE,';', ESG_SUBSECTOR_NAME,';', NFRD_DISCLOSURES, ';', ORIGINATED_DURING_PERIOD, ';', GENERAL_SPECIFIC_PURPOSE, ';', SPECIALISED_LENDING, ';', SPECIFIC_ELIGIBLE,';', SPECIFIC_SUSTAINABLE) 
      else concat(IDCOMB_SATELITE,';',INVESTMENT_SECTOR,';', ESG_SUBSECTOR_NAME,';',PURPOSE_ESG,';', NFRD_DISCLOSURES, ';', ORIGINATED_DURING_PERIOD, ';', GENERAL_SPECIFIC_PURPOSE, ';', SPECIALISED_LENDING,';',SPECIFIC_ELIGIBLE,';', SPECIFIC_SUSTAINABLE) 
     end as COMB_CODE,
     SUM(AMOUNT) as AMOUNT,
     EUROPEAN_UNION AS EU,
        CASE 
            WHEN idcomb_satelite like '%SC0304%' and cnael<>'' then '' 
            when idcomb_satelite not like '%SC0303%' and Investment_Sector <> 'INVS5' then ''
            ELSE CNAEL 
        END AS CNAEL, 
        CASE 
            WHEN idcomb_satelite like '%SC0304%' and NACE_ESG <>'' then '' 
            when idcomb_satelite not like '%SC0303%' and Investment_Sector <> 'INVS5' then ''
            ELSE NACE_ESG
        END AS NACE,
     
        round (sum(TUCCM),0) as TUCCM,
        round (sum(etccm),0) as etccm,
        round (sum(trant),0) as trant,
        round (sum(entccm),0) as entccm,
        round (sum(tucca),0) as tucca,
        round (sum(etcca),0) as etcca,
        round (sum(entcca),0) as entcca,
        round (sum(TUWTR),0) as TUWTR,
        round (sum(ETWTR),0) as ETWTR,
        round (sum(ENTWTR),0) as ENTWTR,
        round (sum(TUCE),0) as TUCE,
        round (sum(ETCE),0) as ETCE,
        round (sum(ENTCE),0) as ENTCE,
        round (sum(TUPPC),0) as TUPPC,
        round (sum(ETPPC),0) as ETPPC,
        round (sum(TUBIO),0) as TUBIO,
        round (sum(ETBIO),0) as ETBIO,
        round (sum(CACCM),0) as CACCM,
        round (sum(ecccm),0) as ecccm,
        round (sum(tranc),0) as tranc,
        round (sum(encccm),0) as encccm,
        round (sum(cacca),0) as cacca,
        round (sum(eccca),0) as eccca,
        round (sum(enccca),0) as enccca,
     round (sum(CAWTR),0) as CAWTR,
        round (sum(ECWTR),0) as ECWTR,
        round (sum(ENCWTR),0) as ENCWTR,
        round (sum(CACE),0) as CACE,
        round (sum(ECCE),0) as ECCE,
        round (sum(ENCCE),0) as ENCCE,
        round (sum(CAPPC),0) as CAPPC,
        round (sum(ECPPC),0) as ECPPC,
        round (sum(CABIO),0) as CABIO,
        round (sum(ECBIO),0) as ECBIO
     
    FROM bu_esg_work.SAT84_PN_01
    WHERE amount <> 0
    GROUP BY 1,2,3,4,6,7,8
    ) X
;