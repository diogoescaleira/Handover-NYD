    /********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 27/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 84  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO SATÉLITE 84                							       */
/*=========================================================================================================================================*/


INSERT OVERWRITE TABLE BU_ESG_WORK.AG084_GAR_CTO_AGR PARTITION (REF_DATE)

SELECT
    INFORMING_SOC, 
    COUNTERPARTY_SOC, 
    ADJUSTMENT_CODE,
    REGEXP_REPLACE(REGEXP_REPLACE(comb_code, ';+', ';'),';$','') as COMB_CODE,
    AMOUNT,
    EU,
    CNAEL, 
    NACE, 
    COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCCM IS NULL THEN 0 ELSE TUCCM END , 0) AS TUCCM,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCCM IS NULL THEN 0 ELSE ETCCM END , 0) AS ETCCM,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TRANT IS NULL THEN 0 ELSE TRANT END , 0) AS TRANT,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCCM IS NULL THEN 0 ELSE ENTCCM END , 0) AS ENTCCM,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCCA IS NULL THEN 0 ELSE TUCCA END , 0) AS TUCCA,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCCA IS NULL THEN 0 ELSE ETCCA END , 0) AS ETCCA,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCCA IS NULL THEN 0 ELSE ENTCCA END , 0) AS ENTCCA,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUWTR IS NULL THEN 0 ELSE TUWTR END , 0) AS TUWTR,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETWTR IS NULL THEN 0 ELSE ETWTR END , 0) AS ETWTR,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTWTR IS NULL THEN 0 ELSE ENTWTR END , 0) AS ENTWTR,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUCE IS NULL THEN 0 ELSE TUCE END , 0) AS TUCE,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETCE IS NULL THEN 0 ELSE ETCE END , 0) AS ETCE,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENTCE IS NULL THEN 0 ELSE ENTCE END , 0) AS ENTCE,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUPPC IS NULL THEN 0 ELSE TUPPC END , 0) AS TUPPC,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETPPC IS NULL THEN 0 ELSE ETPPC END , 0) AS ETPPC,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TUBIO IS NULL THEN 0 ELSE TUBIO END , 0) AS TUBIO,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ETBIO IS NULL THEN 0 ELSE ETBIO END , 0) AS ETBIO,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACCM IS NULL THEN 0 ELSE CACCM END , 0) AS CACCM,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCCM IS NULL THEN 0 ELSE ECCCM END , 0) AS ECCCM,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN TRANC IS NULL THEN 0 ELSE TRANC END , 0) AS TRANC,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCCM IS NULL THEN 0 ELSE ENCCCM END , 0) AS ENCCCM,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACCA IS NULL THEN 0 ELSE CACCA END , 0) AS CACCA,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCCA IS NULL THEN 0 ELSE ECCCA END , 0) AS ECCCA,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCCA IS NULL THEN 0 ELSE ENCCCA END , 0) AS ENCCCA,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CAWTR IS NULL THEN 0 ELSE CAWTR END , 0) AS CAWTR,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECWTR IS NULL THEN 0 ELSE ECWTR END , 0) AS ECWTR,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCWTR IS NULL THEN 0 ELSE ENCWTR END , 0) AS ENCWTR,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CACE IS NULL THEN 0 ELSE CACE END , 0) AS CACE,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECCE IS NULL THEN 0 ELSE ECCE END , 0) AS ECCE,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ENCCE IS NULL THEN 0 ELSE ENCCE END , 0) AS ENCCE,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CAPPC IS NULL THEN 0 ELSE CAPPC END , 0) AS CAPPC,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECPPC IS NULL THEN 0 ELSE ECPPC END , 0) AS ECPPC,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN CABIO IS NULL THEN 0 ELSE CABIO END , 0) AS CABIO,
	COALESCE(CASE WHEN COMB_CODE LIKE '%SC0304%' THEN NULL WHEN COMB_CODE NOT LIKE '%GSPUR1%' THEN NULL WHEN ECBIO IS NULL THEN 0 ELSE ECBIO END , 0)  AS ECBIO,
		
	    '${REF_DATE}' AS REF_DATE
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

            WHEN (IDCOMB_SATELITE LIKE '%MC10%' AND IDCOMB_SATELITE LIKE '%ORIG3%')
            OR (IDCOMB_SATELITE LIKE '%MC10%' AND IDCOMB_SATELITE like '%ORIG2%') 
            OR (IDCOMB_SATELITE LIKE '%MC10%' AND IDCOMB_SATELITE LIKE '%ORIG1%') 
            or idcomb_satelite like '%MC1001%'
            or idcomb_satelite like '%MC1002%'
            or idcomb_satelite like '%MC1003%'
            or idcomb_satelite like '%MC1004%'
            then concat(idcomb_satelite,';', ESG_SUBSECTOR_NAME, ';', originated_during_period)

      
      when IDCOMB_SATELITE like '%MC02%'  and IDCOMB_SATELITE like '%SC02%' and IDCOMB_SATELITE like '%ACPF1%'      -- Adição de condição para ""Cash and cash balances at central banks and other demand deposits"" de credit institutions com base no MdD  
       then CONCAT(IDCOMB_SATELITE,';',NFRD_DISCLOSURES,';', ORIGINATED_DURING_PERIOD)
      
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
     
    FROM bu_esg_work.AG084_GAR_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}'
    GROUP BY 1,2,3,4,6,7,8
    ) X

    WHERE amount <> 0
;