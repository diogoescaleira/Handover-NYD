/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 23/05/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 79  																					 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO SATÉLITE 79                							       */
/*=========================================================================================================================================*/

	
INSERT OVERWRITE TABLE BU_ESG_WORK.AG079_CESG_CTO_AGR PARTITION (REF_DATE)

SELECT
    A.*,
	'${REF_DATE}' AS REF_DATE
FROM
    (
    SELECT 
        '00411' AS INFORMING_SOC,
        CASE
            WHEN SOCIEDADE_CONTRAPARTE='01278' THEN '00000'
        ELSE SOCIEDADE_CONTRAPARTE
        END AS COUNTERPARTY_SOC,
        'BI00411' AS ADJUSTMENT_CODE,
        CASE
                WHEN IDCOMB_SATELITE LIKE '%TYVA02%' AND EXCLUDED_PARIS <>'' AND INVESTMENT_SECTOR = ''  THEN
                CONCAT(IDCOMB_SATELITE,";",EXCLUDED_PARIS,";",MATURITY_ESG) 

                WHEN IDCOMB_SATELITE LIKE '%TYVA02%' AND EXCLUDED_PARIS <>'' AND INVESTMENT_SECTOR <> ''  THEN 
                CONCAT(IDCOMB_SATELITE,";",INVESTMENT_SECTOR,";",EXCLUDED_PARIS)
                                        
                WHEN IDCOMB_SATELITE LIKE '%TYVA02%' AND EXCLUDED_PARIS = '' AND INVESTMENT_SECTOR <> ''  THEN 
                CONCAT(IDCOMB_SATELITE,";",INVESTMENT_SECTOR)
                
                WHEN IDCOMB_SATELITE LIKE '%MC06%' AND IDCOMB_SATELITE NOT LIKE '%SC0303%' THEN
                CONCAT(IDCOMB_SATELITE,";",MATURITY_ESG)

                WHEN IDCOMB_SATELITE LIKE '%TYVA02%' AND EXCLUDED_PARIS = '' AND INVESTMENT_SECTOR = ''  AND MATURITY_ESG = '' THEN IDCOMB_SATELITE

                WHEN IDCOMB_SATELITE LIKE '%TYVA01%' AND EXCLUDED_PARIS = '' AND IDCOMB_SATELITE LIKE '%MC08%' THEN 
                CONCAT(IDCOMB_SATELITE,";",INVESTMENT_SECTOR,";",MATURITY_ESG)

                WHEN IDCOMB_SATELITE LIKE '%TYVA01%' AND EXCLUDED_PARIS <> '' AND IDCOMB_SATELITE LIKE '%MC08%' THEN
                CONCAT(IDCOMB_SATELITE,";",INVESTMENT_SECTOR,";",EXCLUDED_PARIS,";",MATURITY_ESG)						
        
                WHEN IDCOMB_SATELITE LIKE '%MC06%' AND IDCOMB_SATELITE LIKE '%SC0303%' THEN 
                CONCAT(IDCOMB_SATELITE,";",EXCLUDED_PARIS,";",MATURITY_ESG)				

                WHEN FLAG_MATURITY=1 AND EXCLUDED_PARIS <>'' AND INVESTMENT_SECTOR <>'' THEN 
                CONCAT(IDCOMB_SATELITE,";",INVESTMENT_SECTOR,";",EXCLUDED_PARIS,";",MATURITY_ESG)
                
                WHEN FLAG_MATURITY=1 AND EXCLUDED_PARIS =''  THEN 
                CONCAT(IDCOMB_SATELITE,";",MATURITY_ESG)
                
                WHEN FLAG_MATURITY=0 AND MATURITY_ESG = 'MESG5' AND INVESTMENT_SECTOR <>'' THEN 
                CONCAT(IDCOMB_SATELITE,";",INVESTMENT_SECTOR,";",EXCLUDED_PARIS,";",MATURITY_ESG)
                
                WHEN FLAG_MATURITY=0 AND EXCLUDED_PARIS <>'' AND INVESTMENT_SECTOR <>'' THEN 
                CONCAT(IDCOMB_SATELITE,";",INVESTMENT_SECTOR,";",EXCLUDED_PARIS) 
                
                WHEN FLAG_MATURITY=0 AND EXCLUDED_PARIS ='' AND INVESTMENT_SECTOR <>'' THEN 
                CONCAT(IDCOMB_SATELITE,";",INVESTMENT_SECTOR,";",MATURITY_ESG)
                
                ELSE CONCAT(IDCOMB_SATELITE,";",MATURITY_ESG)
            END   AS COMB_CODE,						
        SUM(ROUND(AMOUNT,0)) AS AMOUNT,
        EUROPEAN_UNION AS EU,
        CHRONIC_CHANGES AS CHRO,
        ACUTE_CHANGES AS ACUT,
        GEO,
        CNAEL,
        NACE_ESG AS NACE

    FROM BU_ESG_WORK.AG079_CESG_CTO_GRA
	WHERE REF_DATE = '${REF_DATE}'                        
    GROUP BY 1,2,3,4,6,7,8,9,10,11
    ) A

    HAVING AMOUNT <> 0
;