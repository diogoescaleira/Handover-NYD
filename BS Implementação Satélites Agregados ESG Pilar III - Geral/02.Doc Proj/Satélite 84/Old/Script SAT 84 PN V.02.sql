CREATE TABLE bu_esg_work.SAT84_PN AS

SELECT
    IDCOMB_SATELITE,
    SOCIEDADE_CONTRAPARTE,
    B.zcliente, 
    A.CEMPRESA_CT, 
    A.CBALCAO_CT, 
    A.CNUMECTA_CT, 
    A.ZDEPOSIT_CT,

    -(a.saldo_ct)*pesos.peso as amount,

    CASE    
        WHEN A.IDCOMB_SATELITE like '%MC42%' OR A.IDCOMB_SATELITE like '%MC43%' THEN ''
        WHEN A.IDCOMB_SATELITE like '%MC13%' THEN ''
        -- WHEN SFICS.NOME_GENERAL_SPECIFIC_PURPOSE='General Purpose' THEN 'GSPUR1'
        WHEN SFICS.NOME_GENERAL_SPECIFIC_PURPOSE='Specific purpose' THEN 'GSPUR2'
        ELSE 'GSPUR1'
    END AS GENERAL_SPECIFIC_PURPOSE,

    CASE 
        WHEN ((IDCOMB_SATELITE LIKE '%SC02%') OR (`33_COUNTERPARTY_TYPE` = 'instituicoes de credito')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS2'
        WHEN ((IDCOMB_SATELITE LIKE '%SC0301%') OR (`33_COUNTERPARTY_TYPE` = 'setor publico')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS3'
        WHEN ((IDCOMB_SATELITE LIKE '%SC0302%')  OR (`33_COUNTERPARTY_TYPE` = 'outras instituicoes financeiras')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS4'
        WHEN ((IDCOMB_SATELITE LIKE '%SC0303%')  OR (`33_COUNTERPARTY_TYPE` = 'outras empresas nao financeiras')) AND IDCOMB_SATELITE LIKE '%MC08%' THEN 'INVS5'
        ELSE '' 
    END AS INVESTMENT_SECTOR,

    case
        when a.idcomb_satelite like '%SC0301%' 
            and b.`33_counterparty_type` = 'setor publico' 
            and ct003.cnatureza_juri in ('121100','121210','121220','211110','211120','211130','221100','221210','121231') 
            then'ESGS2'  --- LISTA PARA DEFINIR SOVEREINGS PARTILHADA POR LUÍSA E DADA POR CAPITAL
        when a.idcomb_satelite like '%SC0301%' 
            and b.`33_counterparty_type` = 'setor publico' 
            then 'ESGS1'
        when a.idcomb_satelite like '%SC0301%' then 'ESGS1'
        when a.idcomb_satelite like '%SC0302%' 
            and b.`14_nace` in ('K65.3.0','K66.1.1','K64.3.0','K66.1.2','K66.3.0')    ---  campo nace passará a vir do universo full
            and b.`33_counterparty_type` = 'outras instituicoes financeiras' 
            then 'ESGS3'
        when a.idcomb_satelite like '%SC0302%' 
            and b.`14_nace` in ('K66.1.9','K64.2.0')   ---  campo nace passará a vir do universo full
            and b.`33_counterparty_type` = 'outras instituicoes financeiras' 
            then 'ESGS4'
        when a.idcomb_satelite like '%SC0302%' 
            and  b.`14_nace` in ('K65.1.1','K65.1.2','K65.2.0', 'K66.2.1','K66.2.2','K66.2.9')    ---  campo nace passará a vir do universo full
            and b.`33_counterparty_type` = 'outras instituicoes financeiras' 
            then 'ESGS5'
        when a.idcomb_satelite like '%SC0302%' 
            and b.`33_counterparty_type` = 'outras instituicoes financeiras' 
            then 'ESGS6'
        when a.idcomb_satelite like '%SC0302%' 
            and b.`33_counterparty_type` = 'instituicoes de credito'  
            and b.`14_nace` in ('K64.1.1','K64.1.9','K64.9.1','K64.9.2','K64.9.9') 
            then 'ESGS6' ---  campo nace passará a vir do universo full            
        when a.idcomb_satelite like '%SC0302%' then 'ESGS6'
        when (a.idcomb_satelite like '%MC08%' 
            and b.`33_counterparty_type` = 'outras instituicoes financeiras') 
            then 'ESGS6'
        else '' 
        end as esg_subsector_name,

        CASE
            WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX='Building renovation loans' THEN 'PESG1'
            WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX='Motor vehicle loans' THEN 'PESG2'
            WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX='Building acquisition' THEN 'PESG3'
            WHEN SFICS.NOME_PURPOSE_ESG_ALINH_TAX='Other purpose' THEN 'PESG4'
            ELSE ''
        END AS PURPOSE_ESG,

        CASE
            WHEN A.IDCOMB_SATELITE LIKE '%MC13%' THEN ''
            WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='CCM' THEN 'SELI1'
            WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='CCA' THEN 'SELI2'
            WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='No' THEN 'SELI3'
            WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='Transition to a circular economy' THEN 'SELI4'

            -- WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='Pollution' THEN 'SELI5' ESTA MARCAÇÃO NÃO CONSTA NA TABELA
            -- WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='CCM' Biodiversity and Ecosystems 'SELI6' ESTA MARCAÇÃO NÃO CONSTA NA TABELA
            -- WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='Water and marine resources' THEN 'SELI7' ESTA MARCAÇÃO NÃO CONSTA NA TABELA
            ELSE ''
        END AS SPECIFIC_ELIGIBLE, 
        
        CASE
            WHEN SFICS.NOME_SPECIFIC_SUSTAINABLE='Transitional' THEN 'SSUS1'
            -- WHEN SFICS.NOME_SPECIFIC_SUSTAINABLE='Enabling' THEN 'SSUS2' ESTA OPÇÃO NÃO CONSTA NA TABELA
            WHEN SFICS.NOME_SPECIFIC_SUSTAINABLE='Pure' THEN 'SSUS3'
            WHEN SFICS.NOME_SPECIFIC_SUSTAINABLE='NO' THEN 'SSUS4'
            ELSE ''
        END AS SPECIFIC_SUSTAINABLE,

        CASE
            WHEN A.IDCOMB_SATELITE NOT LIKE '%SC0303%' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
            WHEN SFICS.NOME_SPECIFIC_SUSTAINABLE='NO' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
            WHEN SFICS.NOME_SPECIFIC_ELIGIBLE='No' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
            -- WHEN NFIN.FLG_CSRD='' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
            WHEN CAST(CT004.FLAG_PROJECT_FINANCE AS STRING) = '0' AND SFICS.NOME_PURPOSE_ESG_ALINH_TAX='Building renovation loans' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
            WHEN CAST(CT004.FLAG_PROJECT_FINANCE AS STRING) = '1' AND SFICS.NOME_SPECIFIC_ELIGIBLE='No' THEN 'SPLE2' -- FORÇADO COM BASE NO EMAIL DA CORPORAÇÃO DE DIA 09/01/2025
            WHEN CAST(CT004.FLAG_PROJECT_FINANCE AS STRING) = '0' AND SFICS.NOME_GENERAL_SPECIFIC_PURPOSE='Specific purpose' THEN 'SPLE2' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
            WHEN SFICS.NOME_GENERAL_SPECIFIC_PURPOSE='General Purpose' THEN '' -- REGRA DEFINIDA COM BASE NAS COMBINAÇÕES POSSÍVEIS DE IDCOMBS
            ELSE ''
            -- WHEN CAST(CT004.FLAG_PROJECT_FINANCE AS STRING) = '1' THEN 'SPLE1' --CONFIRMAR SE 1 EQUIVALE AO "YES" DAS GUIDELINES
            -- WHEN CAST(CT004.FLAG_PROJECT_FINANCE AS STRING) = '0' THEN 'SPLE2' --CONFIRMAR SE 0 EQUIVALE AO "NO" DAS GUIDELINES
            -- ELSE ''
        END AS SPECIALISED_LENDING,

        CASE
            WHEN (A.IDCOMB_SATELITE LIKE '%SC0302%' OR A.IDCOMB_SATELITE LIKE '%SC0303%')
                AND NFIN.FLG_CSRD = 1 
            THEN 'NFRD1'

            WHEN A.IDCOMB_SATELITE LIKE '%MC08%' 
                AND B.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                AND NFIN.FLG_CSRD = 1 
            THEN 'NFRD1'

            WHEN A.IDCOMB_SATELITE LIKE '%SC02%'
                AND NFIN.FLG_CSRD = 1 
            THEN 'NFRD1'

            WHEN (A.IDCOMB_SATELITE LIKE '%SC0302%' OR A.IDCOMB_SATELITE LIKE '%SC0303%')
                AND (NFIN.FLG_CSRD <> 1 OR NFIN.FLG_CSRD IS NULL)
                THEN 'NFRD2'

            WHEN A.IDCOMB_SATELITE LIKE '%MC08%'
                AND B.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito')
                AND (NFIN.FLG_CSRD <> 1 OR NFIN.FLG_CSRD IS NULL)
                THEN 'NFRD2'    
            
            WHEN A.IDCOMB_SATELITE LIKE '%SC02%'
                AND (NFIN.FLG_CSRD <> 1 OR NFIN.FLG_CSRD IS NULL)
                THEN 'NFRD2'
            
            WHEN (A.IDCOMB_SATELITE LIKE '%SC0302%' OR A.IDCOMB_SATELITE LIKE '%SC0303%' OR A.IDCOMB_SATELITE LIKE '%SC02%') THEN 'NFRD2'
            WHEN A.IDCOMB_SATELITE LIKE '%MC08%' AND B.`33_counterparty_type` in ('outras instituicoes financeiras','outras empresas nao financeiras','instituicoes de credito') THEN 'NFRD2'

            ELSE ''
        
            -- WHEN NFIN.FLG_CSRD=1 THEN 'NFRD1'
            -- WHEN NFIN.FLG_CSRD=0 THEN 'NFRD2'
            -- ELSE ''
        END AS NFRD_DISCLOSURES,

        --Turnover
		---Mitigation
        NFIN.CCM_TRNVR_TTL_ELGBL AS TUCCM,
        NFIN.CCM_TRNVR_OWN_PRFRMNCE_ALGND AS ETCCM,
        NFIN.CCM_TRNVR_TRNSTN_ALIGND AS TRANT,
        NFIN.CCM_TRNVR_ENBLNG_ALGND AS ENTCCM,
		---Adaptation
		NFIN.CCA_TRNVR_TTL_ELGBL AS TUCCA,
        NFIN.CCA_TURNOVER_OWN_PRFRMNCE_ALGND AS ETCCA,
        NFIN.CCA_TRNVR_ENBLNG_ALIGND AS ENTCCA,
		--Water & Waste management
		NFIN.WTR_TRNVR_TTL_ELGBL AS TUWTR,
		NFIN.WTR_TURNOVER_OWN_PRFRMNCE_ALGND AS ETWTR,
		NFIN.WTR_TRNVR_ENBLNG_ALIGND AS ENTWTR,
		---Circular Economy
		NFIN.CE_TRNVR_TTL_ELGBL AS TUCE,
		NFIN.CE_TURNOVER_OWN_PRFRMNCE_ALGND AS ETCE,
		NFIN.CE_TRNVR_ENBLNG_ALIGND AS ENTCE,
		---Pollution
		NFIN.PPC_TRNVR_TTL_ELGBL AS TUPPC,
		NFIN.PPC_TURNOVER_OWN_PRFRMNCE_ALGND AS ETPPC,
		--Biodiversity
		NFIN.BIO_TRNVR_TTL_ELGBL AS TUBIO,
		NFIN.BIO_TURNOVER_OWN_PRFRMNCE_ALGND AS ETBIO,
		
		--Capex
		---Mitigation
	    NFIN.CCM_CAPEX_TTL_ELGBL AS CACCM,
	    NFIN.CCM_CAPEX_OWN_PRFRMNCE_ALGND AS ECCCM,
	    NFIN.CCM_CAPEX_TRNSTN_ALGND AS TRANC,
	    NFIN.CCM_CAPEX_ENBLNG_ALGND AS ENCCCM,
		---Adaptation 
	    NFIN.CCA_CAPEX_TTL_ELGBL AS CACCA,
	    NFIN.CCA_CAPEX_OWN_PRFRMNCE_ALGND AS ECCCA,
	    NFIN.CCA_CAPEX_ENBLNG_ALGND AS ENCCCA,		
		---Water & Waste Management
		NFIN.WTR_CAPEX_TTL_ELGBL AS CAWTR,
		NFIN.WTR_CAPEX_OWN_PRFRMNCE_ALGND AS ECWTR,
		NFIN.WTR_CAPEX_ENBLNG_ALGND AS ENCWTR,
		---Circular Economy
		NFIN.CE_CAPEX_TTL_ELGBL AS CACE,
		NFIN.CE_CAPEX_OWN_PRFRMNCE_ALGND AS ECCE,
		NFIN.CE_CAPEX_ENBLNG_ALGND AS ENCCE,
		--Pollution
		NFIN.PPC_CAPEX_TTL_ELGBL AS CAPPC,
		NFIN.PPC_CAPEX_OWN_PRFRMNCE_ALGND AS ECPPC,
		--Biodiversity
		NFIN.BIO_CAPEX_TTL_ELGBL AS CABIO,
		NFIN.BIO_CAPEX_OWN_PRFRMNCE_ALGND AS ECBIO,


        CASE 
            WHEN B.`84_dt_origination` >= '${ref_date_ini}' THEN 'ORDP1'		-- No reporte de junho 2024 foi utilizada a data 2024-01-01.
            ELSE 'ORDP2'
        END AS ORIGINATED_DURING_PERIOD, 

        CASE
            WHEN B.CPAIS_RESIDENCIA IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428')
			    THEN 'EU1'
		    WHEN B.CPAIS_RESIDENCIA NOT IN ('276', '040',  '056', '100', '196', '191', '208','705', '724',  '233','246', '250','300','348','372','380', '440', '442',  '470', '616', '620', '203','703', '642', '752', '528', '428','')
			    THEN 'EU2'
	ELSE '' END AS EUROPEAN_UNION,

        CASE
            WHEN idcomb_satelite like '%SC0302%' and concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct) in ('31641600005800050PTNOFIIE0000000','31641600005800050PTPLG8IM0001000','31641600005800050PTPL1AIM0000000','31641600005800050PTPLGEIM0004000') then '' -- correção devido a incorreto mapeamento de Contabilidade (email Nuno Pinheiro dia 26/01)
			WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'A' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL1'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'B' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL2'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'C' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL3'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'D' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL4'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'E' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL5'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'F' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL6'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'G' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL7'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'H' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL8'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'I' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL9'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'J' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL10'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'L' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL11'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'M' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL12'  
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'N' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL13'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'O' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL14'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'P' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL15'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'Q' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL16'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'R' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL17'
            WHEN substr(NFIN.COD_NACE_ESG,1,1) = 'S' and trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
            WHEN trim(b.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
			WHEN trim(b.`33_counterparty_type`) = '' and idcomb_satelite like '%SC0303%' then 'CNAEL18'		--Adicionada nova linha de código. Validado com Luísa
			WHEN idcomb_satelite like '%SC0303%' and b.zcliente = '0000000000' then 'CNAEL18' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
			WHEN idcomb_satelite like '%SC0303%' and concat(a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct)='6416SUPRIMENTOSPTTAE0AN0006000' then 'CNAEL18' --Indicação do Nuno Pinheiro devido a assignação errada de contrato sem conta pcsb
            ELSE ''
        END AS CNAEL,

    CASE
        WHEN TRIM(`33_COUNTERPARTY_TYPE`) = 'outras empresas nao financeiras' AND NACE_LEVEL4 IS NOT NULL THEN ID
        WHEN TRIM(`33_COUNTERPARTY_TYPE`) = 'outras empresas nao financeiras' THEN 'NACE19010303' --NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO            
        WHEN TRIM(`33_COUNTERPARTY_TYPE`) IN ('', 'resto setores / clientes') AND IDCOMB_SATELITE LIKE '%SC0303%' AND NACE_LEVEL4 IS NOT NULL THEN ID	
        WHEN TRIM(`33_COUNTERPARTY_TYPE`) IN ('', 'resto setores / clientes') AND IDCOMB_SATELITE LIKE '%SC0303%' THEN 'NACE19010303' --NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO
        
        WHEN IDCOMB_SATELITE LIKE '%MC08%' AND NACE_LEVEL4 IS NOT NULL THEN ID           
        WHEN IDCOMB_SATELITE LIKE '%MC08%' THEN 'NACE19010303' -- NACE DEFAULT DISPONIBILIZADO PELA CORPORAÇÃO
        
        WHEN IDCOMB_SATELITE LIKE '%SC0303%' AND B.ZCLIENTE = '0000000000' THEN 'NACE19010303' --INDICAÇÃO DA CONTABILIDADE DEVIDO A ASSIGNAÇÃO ERRADA DE CONTRATO SEM CONTA PCSB
        ELSE ''									
    END AS NACE_ESG
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
        'BI00411' as COD_AJUST,
        SUM(SALDO_CT) as SALDO_CT, -- Exposição
        CASE 
            when idcomb_satelite like '%SC0302%' then 'FC'       
            when idcomb_satelite like '%SC0303%' then 'NFC'
            else ''
            end as setor
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
        zdeposit_ct,
        'BI00411',
        case 
            when idcomb_satelite like '%SC0302%' then 'FC'          
            when idcomb_satelite like '%SC0303%' then 'NFC'
            else '' end
    ) as a

    LEFT JOIN

    (
    SELECT DISTINCT 
	    GAR.cempresa_ct,
	    GAR.cbalcao_ct,
	    GAR.cnumecta_ct,
	    GAR.zdeposit_ct,
	    GAR.zcliente,
	    GAR.`13_gross_carrying_amount`,
	    GAR.`32_type_collateral`,
	    GAR.`16_percent_collateral`,
	    GAR.ckbalbem,	
	    GAR.ckctabem,
	    GAR.ckrefbem,	
	    GAR.`19_type_of_asset`,
	    GAR.flag_colateral,
	    GAR.`14_nace`,
	    GAR.`15_nace_esg`,
	    GAR.`84_dt_origination`,
	    GAR.`33_counterparty_type`,
	    GAR.`29_flag_specialised_lending`,
	    GAR.`5_collateral_zip_code` ,
	    GAR.`23_counterparty_ZIPcode`,					
	    GAR.flag_SPV,
	    GAR.`93_european_union`,
        GAR.`4_collateral_nuts`,
        GAR.`22_counterparty_nuts`,	
        GAR.cpais_residencia,
	    CERT_ENERG.clase_energetica,	
	    CERT_ENERG.fiabilidad,
	    CERT_ENERG.consumos
    FROM
    	(
        SELECT * 
        FROM bu_esg_work.p3_reparticao_garantias
        where DT_RFRNC = '${ref_date}' 
        and ID_CORRIDA in (select max(id_corrida) from  bu_esg_work.p3_reparticao_garantias  where DT_RFRNC = '${ref_date}' ) 
        ) GAR
        
        LEFT JOIN
        
        (
        SELECT *
        FROM bu_esg_work.gloval_clase_energetica_Dez24
        ) CERT_ENERG
	    ON CONCAT(GAR.ckbalbem,GAR.ckctabem,GAR.ckrefbem) = chave_banco_atual

    ) as b

    on  a.cempresa_ct = b.cempresa_ct 
    and a.cbalcao_ct  = b.cbalcao_ct 
    and a.cnumecta_ct = b.cnumecta_ct 
    and a.zdeposit_ct = b.zdeposit_ct

    LEFT JOIN

    (
    select distinct
        cempresa_ct,
        cbalcao_ct,
        cnumecta_ct,
        zdeposit_ct,
        ckbalbem,
        ckctabem,
        ckrefbem,
        peso
    from bu_esg_work.rf_pilar3_pesos_Dez24
    ) as pesos

    on  a.cempresa_ct = pesos.cempresa_ct
    and a.cbalcao_ct  = pesos.cbalcao_ct
    and a.cnumecta_ct = pesos.cnumecta_ct
    and a.zdeposit_ct = pesos.zdeposit_ct
    and coalesce(b.ckbalbem,'0') = coalesce(pesos.ckbalbem, '0')
    and coalesce(b.ckctabem,'0') = coalesce(pesos.ckctabem, '0')
    and coalesce(b.ckrefbem,'0') = coalesce(pesos.ckrefbem, '0')

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
    SELECT
        cempresa, 
        cbalcao, 
        cnumecta, 
        zdeposit, 
        flag_project_finance, 
        cproduto,
        csubprod
    FROM cd_captools.ct004_univ_cto
    WHERE ref_date='${ref_date}'
    ) ct004

    on a.cempresa_ct = ct004.cempresa
    and a.cbalcao_ct  = ct004.cbalcao
    and a.cnumecta_ct = ct004.cnumecta
    and a.zdeposit_ct = ct004.zdeposit

    LEFT JOIN 
    
    (
    SELECT *
    FROM BU_ESG_WORK.NACE_ESG_PILLAR3 
    ) AS NACE_ESG		--CRIAR TABELA DE EXCEL A IMPORTAR COM BASE NA NOVA MARCAÇÃO DO EXCEL SAT 79 CASO MUDEM OS NACE QUE A CORPORAÇÃO ENVIA

    ON CONCAT(SPLIT_PART(B.`15_NACE_ESG`,".",1),SPLIT_PART(B.`15_NACE_ESG`,".",2),SPLIT_PART(B.`15_NACE_ESG`,".",3)) = TRIM(SPLIT_PART(NACE_ESG.NACE_LEVEL4, "-",1))

    WHERE concat(A.cempresa_ct,A.cbalcao_ct,A.cnumecta_ct,A.zdeposit_ct) NOT IN ('00100CMAHAJID0000232600421BI0041100') -- Contrato removido por estar a gerar combinação inválida, não tem peso relevante (1 €) e foi decidido remover

;



-- AGREGADO --



WITH AA AS(
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
			OR (IDCOMB_SATELITE like '%MC02%'  and IDCOMB_SATELITE like '%SC01%') -- Adição de condição para "Cash and cash balances at central banks and other demand deposits" de central banks com base no MdD 	
			then concat(IDCOMB_SATELITE,';',ORIGINATED_DURING_PERIOD)
		
		when IDCOMB_SATELITE like '%MC02%'  and IDCOMB_SATELITE like '%SC02%' and IDCOMB_SATELITE like '%ACPF1%'      -- Adição de condição para "Cash and cash balances at central banks and other demand deposits" de credit institutions com base no MdD 	
			then concat(IDCOMB_SATELITE,';',NFRD_DISCLOSURES,';', ORIGINATED_DURING_PERIOD)
		
		when IDCOMB_SATELITE like '%SC0302%'
			then concat(IDCOMB_SATELITE,';', ESG_SUBSECTOR_NAME,';', NFRD_DISCLOSURES, ';', ORIGINATED_DURING_PERIOD, ';', GENERAL_SPECIFIC_PURPOSE, ';', SPECIALISED_LENDING, ';', SPECIFIC_ELIGIBLE,';', SPECIFIC_SUSTAINABLE) 
		else concat(IDCOMB_SATELITE,';',INVESTMENT_SECTOR,';', ESG_SUBSECTOR_NAME,';',PURPOSE_ESG,';', NFRD_DISCLOSURES, ';', ORIGINATED_DURING_PERIOD, ';', GENERAL_SPECIFIC_PURPOSE, ';', SPECIALISED_LENDING,';',SPECIFIC_ELIGIBLE,';', SPECIFIC_SUSTAINABLE) 
	end as COMB_CODE,
	SUM(AMOUNT) as AMOUNT,
	EUROPEAN_UNION AS EU,
	CNAEL,
	NACE_ESG AS NACE,
	
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
	
FROM bu_esg_work.SAT84_PN
WHERE amount <> 0
GROUP BY 1,2,3,4,6,7,8
)
SELECT DISTINCT
    REGEXP_REPLACE(REGEXP_REPLACE(comb_code, ';+', ';'),';$','') as comb_code_2
    -- count(*)
FROM AA
;