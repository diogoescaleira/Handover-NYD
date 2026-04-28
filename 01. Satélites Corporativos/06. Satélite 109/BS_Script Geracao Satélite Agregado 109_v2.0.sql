
/********************************************************************************************************************************************
****   Projeto: Implementação Satélites Corporativos                                                                     				 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 09/07/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Satélite 109  																					 ****
********************************************************************************************************************************************/


/*=========================================================================================================================================*/
/*  1. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO SATELITE 109                                                */
/*=========================================================================================================================================*/

INSERT OVERWRITE TABLE BU_ESG_WORK.AG0109_CTO_R04_AGR PARTITION (REF_DATE)

SELECT
    A.*,
    '${REF_DATE}' AS REF_DATE
FROM 
    (
    SELECT
        '00411' as informing_soc,
        '00000'as counterparty_soc,
        'BI00411' as adjustment_code,
        CONCAT(CONTINUING_OPERATIONS,';',BASE,';',MAIN_CATEGORY,';',COMISSION_SECTOR) AS COMB_CODE,
        ROUND(-SUM(SALDO_COMIS)) AS AMOUNT, 
        EUROPEAN_UNION AS EU,
        GEO,
        CNAEL,
        NACE_CODE_ESG AS NACE
    FROM BU_ESG_WORK.AG0109_CTO_R04_GRA
    WHERE REF_DATE = "${REF_DATE}"
    GROUP BY 1,2,3,4,6,7,8,9
    ) A
;