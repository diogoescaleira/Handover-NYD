/********************************************************************************************************************************************
****   Projeto: Implementação Templates Locais                                                                     						 ****
****   Autor: BS & Neyond                                                                                                                ****
****   Data: 18/06/2025                                                                                                                  ****
****   SQL Script Descrição: Geração do Template 6,7,8,9 																				 ****
****  ( Summary of KPIs on the Taxonomy-aligned exposures )                                      										 ****
****  ( Mitigating actions: Assets for the calculation of GAR )                                      									 ****
****  ( GAR (%) )                                      										 											 ****
****  ( Mitigating actions: BTAR )                                      																 ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  2. TABELA FINAL: OBTENÇÃO DAS MÉTRICAS AGREGADAS A REPORTAR NO ÂMBITO DO TEMPLATE 6,7,8,9             							       */
/*=========================================================================================================================================*/

-- INSERT OVERWRITE BU_ESG_WORK.AG07_TEMP_CTO_AGR PARTITION (ID_CORRIDA,REF_DATE)
SELECT  INSTRUMENTO_FINANCEIRO,
        CARTEIRA_CONTABILISTICA ,
        CONTRAPARTE ,
        ESG_SUBSECTOR_NAME ,
        TIPO_COLATERAL ,
        NOME_GENERAL_SPECIFIC_PURPOSE,
        NOME_PURPOSE_ESG_ALINH_TAX,
        FLAG_CSRD,
        EUROPEAN_UNION ,
        NOME_SPECIFIC_ELIGIBLE ,
        NOME_SPECIFIC_SUSTAINABLE,
        SPECIALISED_LENDING ,
        ORIGINATED_DURING_PERIOD,
        SUM(TUCCM) AS TUCCM,
        SUM(ETCCM) AS ETCCM,
        SUM(TRANT) AS TRANT,
        SUM(ENTCCM) AS ENTCCM,
        SUM(TUCCA) AS TUCCA,
        SUM(ETCCA) AS ETCCA,
        SUM(ENTCCA) AS ENTCCA,
        SUM(AMOUNT) AS AMOUNT,
        FLG_SAT84,

        -- PARTICAO
        RT.NEW_ID_CORRIDA AS ID_CORRIDA,
	    '${REF_DATE}' AS REF_DATE

FROM (
        SELECT *
        FROM BU_ESG_WORK.AG07_TEMP_CTO_GRA
        WHERE REF_DATE = '${REF_DATE}' 
                    AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_ESG_WORK.AG07_TEMP_CTO_GRA WHERE REF_DATE = '${REF_DATE}')) X

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,22,23,24
;
