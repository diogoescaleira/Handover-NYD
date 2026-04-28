/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 27/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 84  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. Tabela granular: Obtenção do universo a reportar no âmbito do Satélite 84 + Marcação de metricas relevantes         			       */
/*=========================================================================================================================================*/

INSERT OVERWRITE TABLE BU_ESG_WORK.AG084_GAR_CTO_GRA PARTITION (REF_DATE)

SELECT
    IDCOMB_SATELITE,
    SOCIEDADE_CONTRAPARTE, 
    ZCLIENTE, 
    CEMPRESA, 
    CBALCAO, 
    CNUMECTA, 
    ZDEPOSIT,
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
    NACE_ESG,

	'${REF_DATE}' AS REF_DATE

FROM
    (
    SELECT
        IDCOMB_SATELITE,
        SOCIEDADE_CONTRAPARTE,
        zcliente, 
        CEMPRESA, 
        CBALCAO, 
        CNUMECTA, 
        ZDEPOSIT,

        -(SALDO) as amount,

        CASE
            WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN 'GSPUR2' -- REFERIDO NAS GUIDELINES DE OUT23_V2 QUE TODOS OS ADJUDICADOS DEVERÃO TER PROPÓSITO ESPECIFICO
            WHEN IDCOMB_SATELITE like '%MC42%' OR IDCOMB_SATELITE like '%MC43%' THEN ''
            WHEN IDCOMB_SATELITE like '%MC13%' THEN ''
            WHEN IDCOMB_SATELITE LIKE '%SC0301%' AND CONTRAPARTE = 'setor publico'
                AND CNATUREZA_JURI IN ('121100','121210','121220','211110','211120','211130','221100','221210','121231') THEN 'GSPUR1' --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL        
            WHEN NOME_GENERAL_SPECIFIC_PURPOSE in('Specific purpose','Specific Purpose') THEN 'GSPUR2'
            ELSE 'GSPUR1'
        END AS GENERAL_SPECIFIC_PURPOSE,

        CASE
            WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
            WHEN ((IDCOMB_SATELITE LIKE '%SC02%') OR (CONTRAPARTE = 'instituicoes de credito')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS2'
            WHEN ((IDCOMB_SATELITE LIKE '%SC0301%') OR (CONTRAPARTE = 'setor publico')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS3'
            WHEN ((IDCOMB_SATELITE LIKE '%SC0302%')  OR (CONTRAPARTE = 'outras instituicoes financeiras')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS4'
            WHEN ((IDCOMB_SATELITE LIKE '%SC0303%')  OR (CONTRAPARTE = 'outras empresas nao financeiras')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS5'
            ELSE '' 
        END AS INVESTMENT_SECTOR,

        case
            WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
            when idcomb_satelite like '%SC0301%' 
                and CONTRAPARTE = 'setor publico' 
                and cnatureza_juri in ('121100','121210','121220','211110','211120','211130','221100','221210','121231') 
                then'ESGS2'  --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
            when idcomb_satelite like '%SC0301%' 
                and CONTRAPARTE = 'setor publico' 
                then 'ESGS1'
            when idcomb_satelite like '%SC0301%' then 'ESGS1'
            when idcomb_satelite like '%SC0302%' 
                and COD_NACE_ESG in ('K65.3.0','K66.1.1','K64.3.0','K66.1.2','K66.3.0')    ---  campo nace passará a vir do universo full
                and CONTRAPARTE = 'outras instituicoes financeiras' 
                then 'ESGS3'
            when idcomb_satelite like '%SC0302%' 
                and COD_NACE_ESG in ('K66.1.9','K64.2.0')   ---  campo nace passará a vir do universo full
                and CONTRAPARTE = 'outras instituicoes financeiras' 
                then 'ESGS4'
            when idcomb_satelite like '%SC0302%' 
                and COD_NACE_ESG in ('K65.1.1','K65.1.2','K65.2.0', 'K66.2.1','K66.2.2','K66.2.9')    ---  campo nace passará a vir do universo full
                and CONTRAPARTE = 'outras instituicoes financeiras' 
                then 'ESGS5'
            when idcomb_satelite like '%SC0302%' 
                and CONTRAPARTE = 'outras instituicoes financeiras' 
                then 'ESGS6'
            when idcomb_satelite like '%SC0302%' 
                and CONTRAPARTE = 'instituicoes de credito'  
                and COD_NACE_ESG in ('K64.1.1','K64.1.9','K64.9.1','K64.9.2','K64.9.9') 
                then 'ESGS6' ---  campo nace passará a vir do universo full            
            when idcomb_satelite like '%SC0302%' then 'ESGS6'
            when (idcomb_satelite like '%MC08%' 
                and CONTRAPARTE = 'outras instituicoes financeiras') 
                then 'ESGS6'
            else '' 
            end as esg_subsector_name,

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
                WHEN IDCOMB_SATELITE LIKE '%MC42%' OR IDCOMB_SATELITE LIKE '%MC43%' THEN '' -- Off balance
                WHEN IDCOMB_SATELITE LIKE '%MC13%' THEN ''
                WHEN IDCOMB_SATELITE LIKE '%SC0301%' AND CONTRAPARTE = 'setor publico' AND CNATUREZA_JURI IN ('121100','121210','121220','211110','211120','211130','221100','221210','121231') THEN '' --LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
        
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
                WHEN IDCOMB_SATELITE LIKE '%SC0301%' AND CONTRAPARTE = 'setor publico' AND
                    CNATUREZA_JURI IN ('121100','121210','121220','211110','211120','211130','221100','221210','121231') THEN 'General' --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
                WHEN NOME_SPECIFIC_ELIGIBLE='Climate change mitigation' THEN 'SELI1'
                WHEN NOME_SPECIFIC_ELIGIBLE='Climate change adaptation' THEN 'SELI2'
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
                WHEN NOME_SPECIFIC_SUSTAINABLE='Transitional activity' THEN 'SSUS1'
                WHEN NOME_SPECIFIC_SUSTAINABLE='Enabling activity' THEN 'SSUS2'
                WHEN NOME_SPECIFIC_SUSTAINABLE='Pure activity' THEN 'SSUS3'
                WHEN NOME_SPECIFIC_SUSTAINABLE='No' THEN 'SSUS4'
                ELSE ''
            END AS SPECIFIC_SUSTAINABLE,

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
                -- WHEN A.IDCOMB_SATELITE NOT LIKE '%SC0303%' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN NOME_SPECIFIC_SUSTAINABLE='No' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN NOME_SPECIFIC_ELIGIBLE='No' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                -- WHEN NFIN.FLG_CSRD='' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN NOME_PURPOSE_ESG_ALINH_TAX='Building renovation loans' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN CAST(FLAG_PROJECT_FINANCE AS STRING) = '1' AND NOME_SPECIFIC_ELIGIBLE='No' THEN 'SPLE2' -- FORÇADO COM BASE NO EMAIL DA CORPORAÇÃO DE DIA 09/01/2025
                WHEN CAST(FLAG_PROJECT_FINANCE AS STRING) = '0' AND NOME_GENERAL_SPECIFIC_PURPOSE in('Specific purpose', 'Specific Purpose') THEN 'SPLE2' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                WHEN NOME_GENERAL_SPECIFIC_PURPOSE='General Purpose' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
                ELSE ''
            END AS SPECIALISED_LENDING,

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN '' -- Na satellite structure é sempre N/A
                WHEN (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%')
                    AND FLG_CSRD = 1 
                THEN 'NFRD1'

                WHEN IDCOMB_SATELITE LIKE '%MC08%' 
                    AND CONTRAPARTE in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    AND FLG_CSRD = 1 
                THEN 'NFRD1'

                WHEN IDCOMB_SATELITE LIKE '%SC02%'
                    AND FLG_CSRD = 1 
                THEN 'NFRD1'

                WHEN (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%')
                    AND (FLG_CSRD <> 1 OR FLG_CSRD IS NULL)
                    THEN 'NFRD2'

                WHEN IDCOMB_SATELITE LIKE '%MC08%'
                    AND CONTRAPARTE in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    AND (FLG_CSRD <> 1 OR FLG_CSRD IS NULL)
                    THEN 'NFRD2'    
                
                WHEN IDCOMB_SATELITE LIKE '%SC02%'
                    AND (FLG_CSRD <> 1 OR FLG_CSRD IS NULL)
                    THEN 'NFRD2'
                
                WHEN (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%' OR IDCOMB_SATELITE LIKE '%SC02%') THEN 'NFRD2'
                WHEN IDCOMB_SATELITE LIKE '%MC08%' AND CONTRAPARTE in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') THEN 'NFRD2'
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
                WHEN DABERTUR >= '${ref_date_ini}' THEN 'ORDP1'		-- No reporte de junho 2024 foi utilizada a data 2024-01-01.
                ELSE 'ORDP2'
            END AS ORIGINATED_DURING_PERIOD,

            CASE
                WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN ''-- Apenas aplicável a id_comb SC0303 (NFC) o que não acontece para adjudicados
                -- WHEN ZCLIENTE ='0000000000' THEN 'EU1'

                WHEN ZCLIENTE ='0000000000' AND (FLG_CSRD <> 1 or FLG_CSRD IS NULL) 
                    AND (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%') 
                    THEN 'EU1'
 
                WHEN ZCLIENTE ='0000000000' AND (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC08%' 
                    AND CONTRAPARTE IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    THEN 'EU1'
 
                WHEN ZCLIENTE ='0000000000' AND (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC41%'
                    AND CONTRAPARTE IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    THEN 'EU1'
                WHEN  ZCLIENTE ='0000000000' AND (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%SC02%'
                    THEN 'EU1'

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL) 
                    AND (IDCOMB_SATELITE LIKE '%SC0302%' OR IDCOMB_SATELITE LIKE '%SC0303%') 
                    AND CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                    THEN 'EU1'

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC08%' 
                    AND CONTRAPARTE IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                    AND CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
                    THEN 'EU1' 

                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC41%'
                    AND CONTRAPARTE IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
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
                    AND CONTRAPARTE IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') 
                    AND CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
                    THEN 'EU2'   
                        
                WHEN (FLG_CSRD <> 1 or FLG_CSRD IS NULL)
                    AND IDCOMB_SATELITE LIKE '%MC41%'
                    AND CONTRAPARTE IN ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
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
                WHEN idcomb_satelite like '%SC0302%' and concat(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT) in ('31641600005800050PTNOFIIE0000000','31641600005800050PTPLG8IM0001000','31641600005800050PTPL1AIM0000000','31641600005800050PTPLGEIM0004000') then '' -- correção devido a incorreto mapeamento de Contabilidade (email Nuno Pinheiro dia 26/01)
                WHEN substr(COD_NACE_ESG,1,1) = 'A' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL1'
                WHEN substr(COD_NACE_ESG,1,1) = 'B' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL2'
                WHEN substr(COD_NACE_ESG,1,1) = 'C' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL3'
                WHEN substr(COD_NACE_ESG,1,1) = 'D' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL4'
                WHEN substr(COD_NACE_ESG,1,1) = 'E' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL5'
                WHEN substr(COD_NACE_ESG,1,1) = 'F' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL6'
                WHEN substr(COD_NACE_ESG,1,1) = 'G' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL7'
                WHEN substr(COD_NACE_ESG,1,1) = 'H' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL8'
                WHEN substr(COD_NACE_ESG,1,1) = 'I' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL9'
                WHEN substr(COD_NACE_ESG,1,1) = 'J' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL10'
                WHEN substr(COD_NACE_ESG,1,1) = 'L' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL11'
                WHEN substr(COD_NACE_ESG,1,1) = 'M' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL12'  
                WHEN substr(COD_NACE_ESG,1,1) = 'N' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL13'
                WHEN substr(COD_NACE_ESG,1,1) = 'O' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL14'
                WHEN substr(COD_NACE_ESG,1,1) = 'P' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL15'
                WHEN substr(COD_NACE_ESG,1,1) = 'Q' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL16'
                WHEN substr(COD_NACE_ESG,1,1) = 'R' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL17'
                WHEN substr(COD_NACE_ESG,1,1) = 'S' and trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL18'
                WHEN trim(CONTRAPARTE) = 'outras empresas nao financeiras' then 'CNAEL18'
                WHEN trim(CONTRAPARTE) = '' and idcomb_satelite like '%SC0303%' then 'CNAEL18'		--Adicionada nova linha de código. Validado com Contabilidade
                WHEN idcomb_satelite like '%SC0303%' and zcliente = '0000000000' then 'CNAEL18' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
                WHEN idcomb_satelite like '%SC0303%' and concat(CBALCAO,CNUMECTA,ZDEPOSIT)='6416SUPRIMENTOSPTTAE0AN0006000' then 'CNAEL18' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
                ELSE ''
            END AS CNAEL,

        CASE
            WHEN IDCOMB_SATELITE LIKE '%MC10%' THEN ''
            WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' AND NACE_LEVEL4 IS NOT NULL THEN ID
            WHEN TRIM(CONTRAPARTE) = 'outras empresas nao financeiras' THEN 'NACE19010303' --NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO            
            WHEN TRIM(CONTRAPARTE) IN ('', 'resto setores / clientes') AND IDCOMB_SATELITE LIKE '%SC0303%' AND NACE_LEVEL4 IS NOT NULL THEN ID	
            WHEN TRIM(CONTRAPARTE) IN ('', 'resto setores / clientes') AND IDCOMB_SATELITE LIKE '%SC0303%' THEN 'NACE19010303' --NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO
            
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
        A.CEMPRESA, 
        A.CBALCAO, 
        A.CNUMECTA, 
        A.ZDEPOSIT,
        A.SALDO,
        CT004.ZCLIENTE,
        CT004.DABERTUR,
        CT003.CONTRAPARTE,
        CT004.FLAG_PROJECT_FINANCE,
        CT003.CPAIS_RESIDENCIA,
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
				A1.CCONTAB_FINAL_IDCOMB_TOTAL AS IDCOMB_SATELITE,
				A3.SOCIEDADE_CONTRAPARTE,
				A1.CEMPRESA, 
				A1.CBALCAO,
				A1.CNUMECTA, 
				A1.ZDEPOSIT, 
				SUM(A1.MSALDO_FINAL) AS SALDO
		FROM 
			(
			SELECT *
			FROM BUSINESS_ESG.MODESG_OUT_REPORTE_GRANULAR
			WHERE REF_DATE = '${REF_DATE}'
				AND REPORTE_GRANULAR='Satelite 84'
				AND CCONTAB_FINAL_IDCOMB_TOTAL NOT LIKE '%MC10%'
			) A1
		LEFT JOIN 
			(
			SELECT DISTINCT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,CEMPRESA_FR,CBALCAO_FR,CNUMECTA_FR,ZDEPOSIT_FR
			FROM CD_CAPTOOLS.KT_CHAVES_FINREP
			WHERE REF_DATE='${REF_DATE}'
			) A2 ON A1.CEMPRESA=A2.CEMPRESA
					AND A1.CBALCAO=A2.CBALCAO
					AND A1.CNUMECTA=A2.CNUMECTA
					AND A1.ZDEPOSIT=A2.ZDEPOSIT
		LEFT JOIN 
			(
			SELECT DISTINCT CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT,SOCIEDADE_CONTRAPARTE,CCONTAB_FINAL_IDCOMB,CCONTAB_FINAL_IDCOMB_TOTAL
			FROM CD_CAPTOOLS.FR012_MASTER_CTO
			WHERE REF_DATE='${REF_DATE}'
			) A3 ON A2.CEMPRESA_FR=A3.CEMPRESA
					AND A2.CBALCAO_FR=A3.CBALCAO
					AND A2.CNUMECTA_FR=A3.CNUMECTA
					AND A2.ZDEPOSIT_FR=A3.ZDEPOSIT
					AND A1.CCONTAB_FINAL_IDCOMB=A3.CCONTAB_FINAL_IDCOMB		
		GROUP BY 1,2,3,4,5,6
        ) AS A

        LEFT JOIN

        (
        SELECT
            CEMPRESA, 
            CBALCAO, 
            CNUMECTA, 
            ZDEPOSIT, 
            DDVENCIM,
            FLAG_PROJECT_FINANCE, 
            DABERTUR,
			ZCLIENTE
        FROM CD_CAPTOOLS.CT004_UNIV_CTO
        WHERE REF_DATE='${REF_DATE}'     
        ) CT004

        ON  A.CEMPRESA = CT004.CEMPRESA
        AND A.CBALCAO  = CT004.CBALCAO
        AND A.CNUMECTA = CT004.CNUMECTA
        AND A.ZDEPOSIT = CT004.ZDEPOSIT

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
        FROM BUSINESS_ESG.MODESG_OUT_SFICS_TAXON_EUROPEIA
        WHERE REF_DATE= '${REF_DATE}'
        ) SFICS

        on a.CEMPRESA = sfics.cempresa
        and a.CBALCAO  = sfics.cbalcao
        and a.CNUMECTA = sfics.cnumecta
        and a.ZDEPOSIT = sfics.zdeposit

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
        FROM BUSINESS_ESG.MODESG_OUT_EMPR_INFO_NFIN
        WHERE REF_DATE='${REF_DATE}'
        ) NFIN

        ON CT004.ZCLIENTE = NFIN.ZCLIENTE

        LEFT JOIN

        (
        SELECT
            ZCLIENTE, 
            CPAIS_RESIDENCIA, 
            CONTRAPARTE,
            CNATUREZA_JURI
        FROM CD_CAPTOOLS.CT003_UNIV_CLI
        WHERE REF_DATE='${REF_DATE}'
        ) CT003

        ON CT004.ZCLIENTE=CT003.ZCLIENTE
        
        LEFT JOIN
        
        (
        SELECT *
        FROM BU_ESG_WORK.NACE_ESG_PILLAR3 
        ) AS NACE_ESG		--CRIAR TABELA DE EXCEL A IMPORTAR COM BASE NA NOVA MARCAÇÃO DO EXCEL SAT 79 CASO MUDEM OS NACE QUE A CORPORAÇÃO ENVIA

        ON CONCAT(SPLIT_PART(NFIN.COD_NACE_ESG,".",1),SPLIT_PART(NFIN.COD_NACE_ESG,".",2),SPLIT_PART(NFIN.COD_NACE_ESG,".",3)) = TRIM(SPLIT_PART(NACE_ESG.NACE_LEVEL4, "-",1))


        UNION ALL

       SELECT DISTINCT
            sociedade_contraparte AS SOCIEDADE_CONTRAPARTE,     
            IDCOMB AS IDCOMB_SATELITE,
            CEMPRESA, 
            CBALCAO,
            CNUMECTA,
            ZDEPOSIT, 
            CASE 
                WHEN IDCOMB LIKE '%MC1005%' AND IDCOMB LIKE '%ORIG4%' THEN V_CONTAB * -1
                ELSE MSALDO_FINAL
            END AS AMOUNT,

            NULL AS ZCLIENTE,
            DATA_AQUISICAO,
            NULL AS CONTRAPARTE,
            NULL AS FLAG_PROJECT_FINANCE,
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
			SELECT * FROM
			(
				SELECT FULL_SAT84.IDCOMB, CT001.CEMPRESA, CT001.CBALCAO, CT001.CNUMECTA, CT001.ZDEPOSIT, ccontab_final_idcomb, sociedade_contraparte, ccontab_final_cargabal, SUM(msaldo_final) AS MSALDO_FINAL
				FROM
				(
				SELECT DISTINCT SUBSTRING(TRIM(REPLACE(REPLACE(TRIM(UPPER(CCONTAB_FINAL_IDCOMB_TOTAL)),"IN (",""),")","")),2,LENGTH(TRIM(REPLACE(REPLACE(TRIM(UPPER(CCONTAB_FINAL_IDCOMB_TOTAL)),"IN (",""),")","")))-2) AS IDCOMB
				FROM BUSINESS_SATELLITEREPORTINGENGINE.PARAM_SATEL_UNIV
				WHERE REF_DATE = '${REF_DATE}'
					AND REPORTE_GRANULAR='Satelite 84'
				) FULL_SAT84

				LEFT JOIN
				(
					SELECT
                        CEMPRESA, 
                        CBALCAO, 
                        CNUMECTA, 
                        ZDEPOSIT, 
                        ccontab_final_idcomb,
                        SUM(MSALDO_FINAL) AS MSALDO_FINAL, 
                        sociedade_contraparte, 
                        ccontab_final_cargabal
					FROM CD_CAPTOOLS.CT001_UNIV_SALDO
					WHERE REF_DATE='${REF_DATE}' AND CCONTAB_FINAL_IDCOMB LIKE '%MC10%'
                    AND ORIGEM <> 'B_IDCOMB'
                    AND CEMPRESA in ('00100', '31', '89')
                    GROUP BY 1,2,3,4,5,7,8
				) CT001
				ON 
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  1)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  2)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  3)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  4)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  5)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  6)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  7)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  8)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';',  9)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 10)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 11)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 12)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 13)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 14)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 15)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 16)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 17)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0 AND
				LOCATE(COALESCE(CONCAT(';',SPLIT_PART(FULL_SAT84.IDCOMB, ';', 18)),';'), CONCAT(';',CT001.CCONTAB_FINAL_IDCOMB)) > 0
				WHERE CNUMECTA IS NOT NULL
                GROUP BY 1,2,3,4,5,6,7,8
			) AS A

			LEFT JOIN

			(
			SELECT
				'31' AS PROPERTY_BANK_ID,
				'CMAH' AS PROPERTY_BRANCH_CODE, 
				'IMOVELGIDAP' AS PROPERTY_CONTRACT_ID,
				REPLACE(UPPER(LPAD(COD_IMOVEL,15,'0')),' ', '0') AS PROPERTY_REFERENCE_CODE,
				CASE
					WHEN V_CONTAB_IFRS = '19910000' THEN '1605010'
					WHEN V_CONTAB_IFRS = '1910000' THEN '1605010'
					WHEN V_CONTAB_IFRS = '19911000' THEN '160510'
					WHEN V_CONTAB_IFRS = '19910001' THEN '2642300'
					WHEN V_CONTAB_IFRS = '1910008' THEN '2642300'
					WHEN V_CONTAB_IFRS = '19911001' THEN '26423100'
					WHEN V_CONTAB_IFRS = '199100200' THEN '1605010'
					WHEN V_CONTAB_IFRS = '199100210' THEN '1605010'
					WHEN V_CONTAB_IFRS = '199100201' THEN '2642300'
					WHEN V_CONTAB_IFRS = '199100211' THEN '2642300'
					WHEN V_CONTAB_IFRS = '199100240' THEN '1605000'
					WHEN V_CONTAB_IFRS = '199100241' THEN '2642300'
				END AS CARGABAL_VC,
				
				CASE
					WHEN PROV_IFRS = '19910000' THEN '1605010'
					WHEN PROV_IFRS = '1910000' THEN '1605010'
					WHEN PROV_IFRS = '19911000' THEN '160510'
					WHEN PROV_IFRS = '19910001' THEN '2642300'
					WHEN PROV_IFRS = '1910008' THEN '2642300'
					WHEN PROV_IFRS = '19911001' THEN '26423100'
					WHEN PROV_IFRS = '199100200' THEN '1605010'
					WHEN PROV_IFRS = '199100210' THEN '1605010'
					WHEN PROV_IFRS = '199100201' THEN '2642300'
					WHEN PROV_IFRS = '199100211' THEN '2642300'
					WHEN PROV_IFRS = '199100240' THEN '1605000'
					WHEN PROV_IFRS = '199100241' THEN '2642300'
				END AS CARGABAL_PROV,
				
				V_CONTAB_IFRS, 
				V_CONTAB, 
				DATA_AQUISICAO
			FROM CD_CAPTOOLS.CT666_ADJUDIC_PROPR
			WHERE REF_DATE='${REF_DATE}'
			AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')

			UNION ALL
						
			SELECT
				'31' AS PROPERTY_BANK_ID , 
				'CMAH' AS PROPERTY_BRANCH_CODE, 
				'IMOVELRECUP' AS PROPERTY_CONTRACT_ID,
				LPAD(REPLACE( REPLACE( REPLACE( CONCAT( IFNULL(UPPER(N_PROCESSO_TC), ''), CONCAT( UPPER( TRIM(ARTIGO_MATRICIAL) ), CONCAT( IFNULL(UPPER(N_CLIENTE), ''), IFNULL(UPPER(ORIGEM), '') ))), '_', '0' ), ' ', '0' ), CHR(10), '0' ),15,'0') AS PROPERTY_REFERENCE_CODE,
				CASE
					WHEN V_CONTAB_IFRS = '19910000' THEN '1605010'
					WHEN V_CONTAB_IFRS = '1910000' THEN '1605010'
					WHEN V_CONTAB_IFRS = '19911000' THEN '160510'
					WHEN V_CONTAB_IFRS = '19910001' THEN '2642300'
					WHEN V_CONTAB_IFRS = '1910008' THEN '2642300'
					WHEN V_CONTAB_IFRS = '19911001' THEN '26423100'
					WHEN V_CONTAB_IFRS = '199100200' THEN '1605010'
					WHEN V_CONTAB_IFRS = '199100210' THEN '1605010'
					WHEN V_CONTAB_IFRS = '199100201' THEN '2642300'
					WHEN V_CONTAB_IFRS = '199100211' THEN '2642300'
					WHEN V_CONTAB_IFRS = '199100240' THEN '1605000'
					WHEN V_CONTAB_IFRS = '199100241' THEN '2642300'
				END AS CARGABAL_VC,
				
				CASE
					WHEN PROV_IFRS = '19910000' THEN '1605010'
					WHEN PROV_IFRS = '1910000' THEN '1605010'
					WHEN PROV_IFRS = '19911000' THEN '160510'
					WHEN PROV_IFRS = '19910001' THEN '2642300'
					WHEN PROV_IFRS = '1910008' THEN '2642300'
					WHEN PROV_IFRS = '19911001' THEN '26423100'
					WHEN PROV_IFRS = '199100200' THEN '1605010'
					WHEN PROV_IFRS = '199100210' THEN '1605010'
					WHEN PROV_IFRS = '199100201' THEN '2642300'
					WHEN PROV_IFRS = '199100211' THEN '2642300'
					WHEN PROV_IFRS = '199100240' THEN '1605000'
					WHEN PROV_IFRS = '199100241' THEN '2642300'
				END AS CARGABAL_PROV,
				
				V_CONTAB_IFRS, 
				V_CONTAB, 
				STRLEFT(CAST(DATE_ADD('1899-12-30', CAST(DATA_AQUISICAO AS DECIMAL(12,0))) AS STRING), 10) AS DATA_AQUISICAO
			FROM CD_CAPTOOLS.CT667_DACOES_ARREM
			WHERE REF_DATE='${REF_DATE}'
			AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')

			UNION ALL

			SELECT
				'89' AS PROPERTY_BANK_ID , 
				'CMAH' AS PROPERTY_BRANCH_CODE, 
				'IMOVELIFICS' AS PROPERTY_CONTRACT_ID,
				LPAD(N_IMOVEL,15,'0') AS PROPERTY_REFERENCE_CODE,
				CASE
					WHEN V_CONTAB_IFRS = '19910000' THEN '1605010'
					WHEN V_CONTAB_IFRS = '1910000' THEN '1605010'
					WHEN V_CONTAB_IFRS = '19911000' THEN '160510'
					WHEN V_CONTAB_IFRS = '19910001' THEN '2642300'
					WHEN V_CONTAB_IFRS = '1910008' THEN '2642300'
					WHEN V_CONTAB_IFRS = '19911001' THEN '26423100'
					WHEN V_CONTAB_IFRS = '199100200' THEN '1605010'
					WHEN V_CONTAB_IFRS = '199100210' THEN '1605010'
					WHEN V_CONTAB_IFRS = '199100201' THEN '2642300'
					WHEN V_CONTAB_IFRS = '199100211' THEN '2642300'
					WHEN V_CONTAB_IFRS = '199100240' THEN '1605000'
					WHEN V_CONTAB_IFRS = '199100241' THEN '2642300'
				END AS CARGABAL_VC,
				
				CASE
					WHEN PROV_IFRS = '19910000' THEN '1605010'
					WHEN PROV_IFRS = '1910000' THEN '1605010'
					WHEN PROV_IFRS = '19911000' THEN '160510'
					WHEN PROV_IFRS = '19910001' THEN '2642300'
					WHEN PROV_IFRS = '1910008' THEN '2642300'
					WHEN PROV_IFRS = '19911001' THEN '26423100'
					WHEN PROV_IFRS = '199100200' THEN '1605010'
					WHEN PROV_IFRS = '199100210' THEN '1605010'
					WHEN PROV_IFRS = '199100201' THEN '2642300'
					WHEN PROV_IFRS = '199100211' THEN '2642300'
					WHEN PROV_IFRS = '199100240' THEN '1605000'
					WHEN PROV_IFRS = '199100241' THEN '2642300'
				END AS CARGABAL_PROV,
				
				V_CONTAB_IFRS, 
				V_CONTAB, 
				STRLEFT(CAST(DATE_ADD('1899-12-30', CAST(DATA_ENTRADA AS DECIMAL(12,0))) AS STRING), 10) AS DATA_AQUISICAO
			FROM CD_CAPTOOLS.CT668_IMOVEIS_IFIC
			WHERE REF_DATE='${REF_DATE}'
			AND V_CONTAB_IFRS IN('199100240', '19910000', '1910000', '199100200', '199100210', '19910001', '1910008', '199100201', '199100211', '199100241')
			) ADJUD_INPUTS
			ON CONCAT(CEMPRESA,CBALCAO,CNUMECTA,ZDEPOSIT)=CONCAT(PROPERTY_BANK_ID,PROPERTY_BRANCH_CODE,PROPERTY_CONTRACT_ID,PROPERTY_REFERENCE_CODE)
        ) AUX_1
    ) AUX_2
) SAT84

;