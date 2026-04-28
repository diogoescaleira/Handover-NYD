

-- 1) Tabela auxiliar LT002

DROP TABLE bu_captools_work.REP_LT002_JUN25;
CREATE TABLE bu_captools_work.REP_LT002_JUN25 AS  
SELECT *
FROM bu_loantape_work.lt002_instrument
WHERE ref_date='${ref_date}'
    AND nome_perimetro= 'Individual IDComb'
    AND segmento= 'ESTR' 
    AND ambito= 'PILAR3'
    AND entidade = '00100'
    and cod_visao=1
;

-- 2) Tabela auxiliar LT007

DROP TABLE bu_captools_work.REP_LT007_JUN25;
CREATE TABLE bu_captools_work.REP_LT007_JUN25 AS  
SELECT *
FROM bu_loantape_work.lt007_instr_activity
WHERE ref_date='${ref_date}'
    AND nome_perimetro= 'Individual IDComb'
    AND segmento= 'ESTR' 
    AND ambito= 'PILAR3'
    AND entidade = '00100'
    and cod_visao=1
;
-- 3) Tabela auxiliar CdG

DROP TABLE bu_captools_work.prod_esg_sfcs_2025;
CREATE TABLE bu_captools_work.prod_esg_sfcs_2025 AS  
SELECT *
FROM bu_ctrlgest.prod_esg_sfcs_2025
;
-- 4) Auxiliar de CDG 
DROP TABLE bu_captools_work.AUX_CDG;
CREATE TABLE bu_captools_work.AUX_CDG AS  

SELECT *
FROM 
    (
    SELECT DISTINCT  concat(cempcta,ckbalcao,cknumcta,zdeposit) AS CHAVE_CDG,
        CASE 
            WHEN concat(cempcta,ckbalcao,cknumcta,zdeposit)='31000320331434096000000000000000' THEN 'A.3.' --AGFSO001 OU A.3.
            WHEN TRIM(activity_template)='AGFGR001' THEN 'A.1.'
            WHEN TRIM(activity_template) IN ('AGFGR002','AGFGR003') THEN 'A.2.'
            WHEN TRIM(activity_template)='AGFGR005' THEN 'A.7.'
            WHEN TRIM(activity_template) IN ('AGFGR006','AGFGR007','AGFGR008') THEN 'A.3.'
            WHEN TRIM(activity_template)='AGFGR009' THEN 'A.9.'
            WHEN TRIM(activity_template)='AGFGR010' THEN 'A.8.'
            WHEN TRIM(activity_template)='AGFSL001' THEN 'AGFSL001'
            WHEN TRIM(activity_template)='AGFSO001' THEN 'AGFSO001'
        END AS SFICS
    FROM bu_captools_work.prod_esg_sfcs_2025 
    WHERE ref_date='2025-06-30'
    )L1
LEFT JOIN 
    (
    SELECT DISTINCT L1.CHAVE_FINREP,L1.CHAVE_MASTER,L2.CHAVE_MIS
    FROM 
        (
        SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempresa_fr,cbalcao_fr,cnumecta_fr,zdeposit_fr) AS CHAVE_FINREP
        FROM cd_captools.kt_chaves_finrep
        WHERE REF_DATE='2025-06-30'
        )L1
    FULL JOIN
        (
        SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempcta,ckbalcao,cknumcta,zdeposit_mis) AS CHAVE_MIS
        FROM cd_captools.kt_chaves_mis
        WHERE REF_DATE='2025-06-30'
        )L2 ON L1.CHAVE_MASTER=L2.CHAVE_MASTER 
    )L2 ON L1.CHAVE_CDG=L2.CHAVE_MIS
;

--5)Análise comparativa 

create table bu_captools_work.anl_cdg_sfics_jun25 as 
SELECT 
    CASE
        WHEN L1.INSTRMNT_ID IS NOT NULL AND L2.CHAVE_FINREP IS NOT NULL THEN 'UNIV COMUM'
        WHEN L1.INSTRMNT_ID IS NULL AND L2.CHAVE_FINREP IS NOT NULL THEN 'UNIV EXCL CDG'
        WHEN L1.INSTRMNT_ID IS NOT NULL AND L2.CHAVE_FINREP IS NULL THEN 'UNIV EXCL REPORTE'
    END AS VALID_UNIV
    ,CASE
        WHEN (CASE WHEN TRIM(L1.SSTNBL_CTGRY) IN ('5104','510201','4301','3603','4102','3504','3602','3502','3601') THEN 'AGFSL001' ELSE L1.SFICS_MOD END)=L2.SFICS THEN 'OK'
        ELSE 'NOK' 
    END AS VALID_SFICS,*
    -- ,L1.SFICS_MOD
    -- ,L2.SFICS
    -- ,SUM(L1.grss_crryng_amnt_instrmnt) AS SALDO_LT
    -- ,SUM(L2.VB) AS SALDO_CDG
    -- ,COUNT(*) AS NUM_REG
        
FROM 
    (
    SELECT S1.INSTRMNT_ID,
        CASE 
            WHEN TRIM(S1.SSTNBL_CTGRY) IN ('210103','210106','210101','210419','210105') THEN 'A.1.'
            WHEN TRIM(S1.SSTNBL_CTGRY) IN ('220101','220105','220201','220103','220402','220501','220405','220102') THEN 'A.2.'
            WHEN TRIM(S1.SSTNBL_CTGRY) IN ('2302','2301','2304') THEN 'A.3.'
            WHEN TRIM(S1.SSTNBL_CTGRY) IN ('260401','260404') THEN 'A.6.'
            WHEN TRIM(S1.SSTNBL_CTGRY) IN ('270301','270101','270306','270309') THEN 'A.7.'
            WHEN TRIM(S1.SSTNBL_CTGRY) IN ('280504','280603','280802') THEN 'A.8.'
            -- WHEN TRIM(S1.SSTNBL_CTGRY) IN ('5104','510201','4301','3603','4102','3504','3602','3502','3601') THEN 'AGFSL001'
            WHEN TRIM(S1.SSTNBL_CTGRY)='5201' THEN 'Pure Green'
            WHEN TRIM(S1.SSTNBL_CTGRY)='6001' THEN 'Sem sfics'
            ELSE S1.SSTNBL_CTGRY
        END AS SFICS_MOD,
        S1.SSTNBL_CTGRY,
        S2.grss_crryng_amnt_instrmnt,
        CASE WHEN S3.CHAVE_FINREP IS NOT NULL THEN 'Com traçabilidade' ELSE 'Sem traçabilidade' END AS TRACA_lt
    FROM 
        (
        SELECT *
        FROM bu_captools_work.REP_LT007_JUN25
        WHERE concat(instrmnt_id,sstnbl_ctgry) NOT IN 
                ('310000000000000009623048804597406001','310003156800680960000000000000006001','310003158664850960000000000000006001',
                '310003182977530960000000000000006001','310003192605780960000000000000006001','310003203569020960000000000000006001',
                '310003204164660960000000000000006001','310003204180580960000000000000006001','310003205734980960000000000000006001',
                '310003210701630960000000000000006001','310003210702620960000000000000006001','310003212604260960000000000000006001',
                '890000000010156240004300007003816001','890000000010185480004300007323216001','890000000010199770004300005168626001',
                '890000000010201970004300004721036001','890000202300003740004900C32172I16001','890000202300003740015202406774516001',
                '890000202300003740015202500317086001','890000202300003740015202500810046001','890000202300003740015202501415526001',
                '890000202300003740015202502008456001','890000202300003740015202502580296001','890000202300003740015202503116706001',
                '89000020230000374V00500C118752I26001')
        )S1
    LEFT JOIN 
        (
        SELECT INSTRMNT_ID,grss_crryng_amnt_instrmnt
        FROM bu_captools_work.REP_LT002_JUN25
        )S2 ON S1.INSTRMNT_ID=S2.INSTRMNT_ID
    LEFT JOIN 
        (
        SELECT DISTINCT L1.CHAVE_FINREP
        FROM 
            (
            SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempresa_fr,cbalcao_fr,cnumecta_fr,zdeposit_fr) AS CHAVE_FINREP
            FROM cd_captools.kt_chaves_finrep
            WHERE REF_DATE='2025-06-30'
            )L1
        INNER JOIN
            (
            SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempcta,ckbalcao,cknumcta,zdeposit_mis) AS CHAVE_MIS
            FROM cd_captools.kt_chaves_mis
            WHERE REF_DATE='2025-06-30'
            )L2 ON L1.CHAVE_MASTER=L2.CHAVE_MASTER 
        WHERE CHAVE_MIS IS NOT NULL 
        )S3 ON S1.INSTRMNT_ID=S3.CHAVE_FINREP
    )L1 
FULL JOIN 
    (
    SELECT T1.*,T2.*
        ,CASE WHEN T3.CHAVE_FINREP IS NOT NULL THEN 'Com traçabilidade' ELSE 'Sem traçabilidade' END AS TRACA_cdg
    FROM 
        (
        SELECT DISTINCT CHAVE_FINREP,SFICS
        FROM bu_captools_work.AUX_CDG
        WHERE CHAVE_FINREP IS NOT NULL 
        )T1
    LEFT JOIN 
        (
        SELECT concat(cempresa,cbalcao,cnumecta,zdeposit) as chave_saldo, sum(valor_bruto_on_a) as vb
        FROM cd_captools.fr004_cto
        WHERE REF_DATE='2025-06-30'
        GROUP BY 1 
        )T2 ON T1.CHAVE_FINREP=T2.chave_saldo
    LEFT JOIN 
        (
        SELECT DISTINCT L1.CHAVE_FINREP
        FROM 
            (
            SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempresa_fr,cbalcao_fr,cnumecta_fr,zdeposit_fr) AS CHAVE_FINREP
            FROM cd_captools.kt_chaves_finrep
            WHERE REF_DATE='2025-06-30'
            )L1
        INNER JOIN
            (
            SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempcta,ckbalcao,cknumcta,zdeposit_mis) AS CHAVE_MIS
            FROM cd_captools.kt_chaves_mis
            WHERE REF_DATE='2025-06-30'
            )L2 ON L1.CHAVE_MASTER=L2.CHAVE_MASTER 
        WHERE CHAVE_MIS IS NOT NULL 
        )T3 ON T1.CHAVE_FINREP=T3.CHAVE_FINREP
    )L2 ON L1.INSTRMNT_ID=L2.CHAVE_FINREP
-- GROUP BY 1,2,3,4
;

-- 6) Extração sheet 2.1

SELECT *
FROM 
    (
    SELECT instrmnt_id,sstnbl_ctgry,grss_crryng_amnt_instrmnt
    FROM bu_captools_work.anl_cdg_sfics_jun25
    WHERE VALID_UNIV='UNIV COMUM'
        AND VALID_SFICS='NOK'
        AND SFICS_MOD='Sem sfics'
    )F1
LEFT JOIN 
    (
    SELECT DISTINCT CHAVE_CDG,CHAVE_FINREP,CHAVE_MASTER
    FROM bu_captools_work.AUX_CDG
    )F2 ON F1.instrmnt_id=F2.CHAVE_FINREP
LEFT JOIN 
    (
    SELECT concat(cempcta,ckbalcao,cknumcta,zdeposit) AS CHAVE_REP,CEMPCTA,CKBALCAO,CKNUMCTA,ZDEPOSIT,CKMETAMIS,CKPRODMI,CMETANSEG,ACTIVITY_TEMPLATE,
        CASE 
            WHEN concat(cempcta,ckbalcao,cknumcta,zdeposit)='31000320331434096000000000000000' THEN 'A.3.' --AGFSO001 OU A.3.
            WHEN TRIM(activity_template)='AGFGR001' THEN 'A.1.'
            WHEN TRIM(activity_template) IN ('AGFGR002','AGFGR003') THEN 'A.2.'
            WHEN TRIM(activity_template)='AGFGR005' THEN 'A.7.'
            WHEN TRIM(activity_template) IN ('AGFGR006','AGFGR007','AGFGR008') THEN 'A.3.'
            WHEN TRIM(activity_template)='AGFGR009' THEN 'A.9.'
            WHEN TRIM(activity_template)='AGFGR010' THEN 'A.8.'
            WHEN TRIM(activity_template)='AGFSL001' THEN 'AGFSL001'
            WHEN TRIM(activity_template)='AGFSO001' THEN 'AGFSO001'
        END AS SFICS
    FROM bu_captools_work.prod_esg_sfcs_2025 
    WHERE ref_date='2025-06-30'
    )F3 ON F2.CHAVE_CDG=F3.CHAVE_REP
LEFT JOIN 
    (
    SELECT DISTINCT CHAVE_CTO,purpose_code,CHAVE_BEM_12,combustivel,TIPO_EQP,CHAVE_BEM_8,EPC
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_JUN25
    )F4 ON F2.CHAVE_MASTER=F4.CHAVE_CTO
ORDER BY grss_crryng_amnt_instrmnt DESC
;

-- 7) Extração sheet 2.2

SELECT *
FROM 
    (
    SELECT instrmnt_id,case when sstnbl_ctgry='2301' then 'A.3.1.'
        WHEN sstnbl_ctgry='2304' then 'A.3.7.'
        WHEN sstnbl_ctgry='220105' then 'A.2.5.'
        ELSE sstnbl_ctgry
    END AS sstnbl_ctgry
    
    ,grss_crryng_amnt_instrmnt
    FROM bu_captools_work.anl_cdg_sfics_jun25
    WHERE VALID_UNIV='UNIV EXCL REPORTE'
        AND VALID_SFICS='NOK'
        AND SFICS_MOD in ('Pure Green')
    )F1
LEFT JOIN 
    (
    SELECT DISTINCT L1.*,l2.CHAVE_MIS,cempcta,ckbalcao,cknumcta,zdeposit_mis
    FROM 
        (
        SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempresa_fr,cbalcao_fr,cnumecta_fr,zdeposit_fr) AS CHAVE_FINREP
        FROM cd_captools.kt_chaves_finrep
        WHERE REF_DATE='2025-06-30'
        )L1
    INNER JOIN
        (
        SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempcta,ckbalcao,cknumcta,zdeposit_mis) AS CHAVE_MIS
            ,cempcta,ckbalcao,cknumcta,zdeposit_mis
        FROM cd_captools.kt_chaves_mis
        WHERE REF_DATE='2025-06-30'
        )L2 ON L1.CHAVE_MASTER=L2.CHAVE_MASTER 
    WHERE CHAVE_MIS IS NOT NULL 
    )F2 ON F1.instrmnt_id=F2.CHAVE_FINREP
LEFT JOIN 
    (
    SELECT DISTINCT CHAVE_CTO,chave_207,ckmetamis,ckprodmi,cmetanseg,purpose_code,CHAVE_BEM_12,combustivel,TIPO_EQP,CHAVE_BEM_8,EPC,zcliente
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_JUN25
        -- where ckprodmi in ('096FOR', '096K32', '096KEI', '096CFE','096CFP', '096CFU','096CPE','096CPP','096CTC','096KPP','096KPT','096YFF','096YFP')
    )F4 ON F2.CHAVE_MIS=F4.chave_207
ORDER BY grss_crryng_amnt_instrmnt DESC

-- 8)comuns 


SELECT *,
    CASE
        WHEN F5.CHAVE IS NOT NULL THEN 'Operação'
        WHEN L2.cempresa IN ('80') AND L2.cbalcao IN ('6416') AND L2.zdeposit IN ('521431150000000','504121590000000') THEN 'Operação v2'
        WHEN L2.cempresa IN ('31') and L2.zdeposit IN

('962304820433740',
'962304880468590',
'962304820433730',
'962304880447100',
'962304820473700',
'962304880466560',
'962304820459670',
'962304880468580',
'962304880378030',
'962304880423030',
'962304880419810',
'962304880402100',
'962304820433890',
'962304820443480',
'962304820434610',
'962304880458990',
'962304890449290',
'962304880423310',
'962304880427990',
'962304880457370',
'962304880427230',
'962304880468630',
'962304890435500',
'962304880423040',
'962304820443470',
'962304880473880',
'962304880366120',
'962304880460800',
'962304880419270',
'962304880460790',
'962304880402110',
'962304880419020',
'962304880444710',
'962304890421450',
'962304820426880',
'962304880436270',
'962304880423020',
'962304880432120',
'962304820464140',
'962304880423010',
'962304880428430',
'962304880441620',
'962304880468620',
'962304880435030',
'962304880464290',
'962304880418860',
'962304880428400',
'962304880437120',
'962304820428200',
'962304880447060',
'962304880468610',
'962304880449620',
'962304880458980',
'962304880419800',
'962304880465780',
'962304820364880',
'962304880444350',
'962304880460780',
'962304820433900',
'962304880398950',
'962304880468600',
'962304880441630',
'962304820451180',
'962304880464950',
'962304880441610',
'962304880459430',
'962304820465310',
'962304880423270',
'962304880460770',
'962304880468720',
'962304880440190',
'962304880459740',
'962304820470440',
'962304880471940',
'962304880423060',
'962304880423170',
'962304820466790',
'962304880437990',
'962304880460760',
'962304820459660',
'962304880441640',
'962304880427010',
'962304880436280',
'962304880468570',
'962304880423000',
'962304880460080',
'962304880407590',
'962304880453120',
'962304880410990',
'962304880438000',
'962304880429700',
'962304820443460',
'962304880447600',
'962304880423340',
'962304820434630',
'962304880438140',
'962304880444100') THEN 'Operação v3'
        WHEN SFICS_V2='Pure Green counterparty - Default' THEN 'Cliente'
        ELSE 'Produto'
    END AS METODO
FROM 
    (
    SELECT *
        ,CASE
            WHEN TRIM(sstnbl_ctgry)='270101' THEN 'A.7.1.'
            WHEN TRIM(sstnbl_ctgry)='220201' THEN 'A.2.7.'
            WHEN TRIM(sstnbl_ctgry)='260404' THEN 'A.6.19.'
            WHEN TRIM(sstnbl_ctgry)='280802' THEN 'A.8.23.'
            WHEN TRIM(sstnbl_ctgry)='220501' THEN 'A.2.21.'
            WHEN TRIM(sstnbl_ctgry)='3504' THEN 'Student loans'
            WHEN TRIM(sstnbl_ctgry)='220103' THEN 'A.2.3.'
            WHEN TRIM(sstnbl_ctgry)='220402' THEN 'A.2.15.'
            WHEN TRIM(sstnbl_ctgry)='5201' THEN 'Pure Green counterparty - Default'
            WHEN TRIM(sstnbl_ctgry)='210105' THEN 'A.1.5.'
            WHEN TRIM(sstnbl_ctgry)='4301' THEN 'Lending to non-profit organizations and charities that meet Banco Santander´s guidelines and advance the green and social themes'
            WHEN TRIM(sstnbl_ctgry)='210106' THEN 'A.1.6.'
            WHEN TRIM(sstnbl_ctgry)='270309' THEN 'A.7.18.'
            WHEN TRIM(sstnbl_ctgry)='260401' THEN 'A.6.4.'
            WHEN TRIM(sstnbl_ctgry)='2301' THEN 'A.3.1.'
            WHEN TRIM(sstnbl_ctgry)='3502' THEN 'Sports and cultural education centres'
            WHEN TRIM(sstnbl_ctgry)='2304' THEN 'A.3.7.'
            WHEN TRIM(sstnbl_ctgry)='270306' THEN 'A.7.12.'
            WHEN TRIM(sstnbl_ctgry)='5104' THEN 'Sustainability Linked Finance - Default'
            WHEN TRIM(sstnbl_ctgry)='280603' THEN 'A.8.10.'
            WHEN TRIM(sstnbl_ctgry)='210419' THEN 'A.1.9.'
            WHEN TRIM(sstnbl_ctgry)='3602' THEN 'Building of healthcare facilities'
            WHEN TRIM(sstnbl_ctgry)='280504' THEN 'A.8.27.'
            WHEN TRIM(sstnbl_ctgry)='510201' THEN 'KPI Linked - Green'
            WHEN TRIM(sstnbl_ctgry)='220101' THEN 'A.2.1.'
            WHEN TRIM(sstnbl_ctgry)='210101' THEN 'A.1.1.'
            WHEN TRIM(sstnbl_ctgry)='3603' THEN 'Health services'
            WHEN TRIM(sstnbl_ctgry)='2302' THEN 'A.3.2.'
            WHEN TRIM(sstnbl_ctgry)='270301' THEN 'A.7.7.'
            WHEN TRIM(sstnbl_ctgry)='210103' THEN 'A.1.3.'
            WHEN TRIM(sstnbl_ctgry)='220102' THEN 'A.2.2.'
            WHEN TRIM(sstnbl_ctgry)='220105' THEN 'A.2.5.'
            WHEN TRIM(sstnbl_ctgry)='4102' THEN 'Financing with preferential financial or payment terms to entities and individuals that have been impacted by natural, armed, health and/or human-made disasters, as well as severe socioeconomic situations.'
            WHEN TRIM(sstnbl_ctgry)='3601' THEN 'Research and develpment (R&D), pharmaceutical and medical manufacturing'
            WHEN TRIM(sstnbl_ctgry)='220405' THEN 'A.2.14.'
        END AS SFICS_V2
    FROM bu_captools_work.anl_cdg_sfics_jun25
    WHERE VALID_UNIV='UNIV COMUM'
        AND SFICS_MOD not in ('Sem sfics')
    )F1 
LEFT JOIN 
    (
    SELECT DISTINCT CHAVE_CDG,CHAVE_FINREP,CHAVE_MASTER
    FROM bu_captools_work.AUX_CDG
    )F2 ON F1.instrmnt_id=F2.CHAVE_FINREP
LEFT JOIN 
    (
    SELECT concat(cempcta,ckbalcao,cknumcta,zdeposit) AS CHAVE_REP,CEMPCTA,CKBALCAO,CKNUMCTA,ZDEPOSIT,CKMETAMIS,CKPRODMI,CMETANSEG,ACTIVITY_TEMPLATE,
        CASE 
            WHEN concat(cempcta,ckbalcao,cknumcta,zdeposit)='31000320331434096000000000000000' THEN 'A.3.' --AGFSO001 OU A.3.
            WHEN TRIM(activity_template)='AGFGR001' THEN 'A.1.'
            WHEN TRIM(activity_template) IN ('AGFGR002','AGFGR003') THEN 'A.2.'
            WHEN TRIM(activity_template)='AGFGR005' THEN 'A.7.'
            WHEN TRIM(activity_template) IN ('AGFGR006','AGFGR007','AGFGR008') THEN 'A.3.'
            WHEN TRIM(activity_template)='AGFGR009' THEN 'A.9.'
            WHEN TRIM(activity_template)='AGFGR010' THEN 'A.8.'
            WHEN TRIM(activity_template)='AGFSL001' THEN 'AGFSL001'
            WHEN TRIM(activity_template)='AGFSO001' THEN 'AGFSO001'
        END AS SFICS,sum(end_of_period_balance) as saldo_rent
    FROM bu_captools_work.prod_esg_sfcs_2025 
    WHERE ref_date='2025-06-30'
    GROUP BY 1,2,3,4,5,6,7,8,9,10
    )F3 ON F2.CHAVE_CDG=F3.CHAVE_REP
LEFT JOIN 
    (
    SELECT DISTINCT CHAVE_CTO,purpose_code,CHAVE_BEM_12,combustivel,TIPO_EQP,CHAVE_BEM_8,EPC,ZCLIENTE,co2,DABERTUR
    FROM BU_CAPTOOLS_WORK.MODESG_OUT_SFICS_TAXON_EUROPEIA_BASE_AUX_JUN25
    )F4 ON F2.CHAVE_MASTER=F4.CHAVE_CTO 

LEFT JOIN 
    (
    SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE
    FROM bu_esg_work.modesg_param_sfics_taxon_europeia
    where ref_date='2025-06-30'
        and ordem='1'
    )F5 ON F2.CHAVE_MASTER=F5.CHAVE
LEFT JOIN 
    (
    SELECT DISTINCT L1.CHAVE_MASTER,cempresa,cbalcao,cnumecta,zdeposit
    FROM 
        (
        SELECT DISTINCT concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempresa_fr,cbalcao_fr,cnumecta_fr,zdeposit_fr) AS CHAVE_FINREP
        FROM cd_captools.kt_chaves_finrep
        WHERE REF_DATE='2025-06-30'
        )L1
    FULL JOIN
        (
        SELECT DISTINCT cempresa,cbalcao,cnumecta,zdeposit,concat(cempresa,cbalcao,cnumecta,zdeposit) AS CHAVE_MASTER,concat(cempcta,ckbalcao,cknumcta,zdeposit_mis) AS CHAVE_MIS
        FROM cd_captools.kt_chaves_mis
        WHERE REF_DATE='2025-06-30'
        )L2 ON L1.CHAVE_MASTER=L2.CHAVE_MASTER 
    )L2 ON F2.CHAVE_MASTER=L2.CHAVE_MASTER
ORDER BY SFICS_V2,F1.instrmnt_id
