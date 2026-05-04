------------------------------------------------------------------------------------------------------------------
-- AGREGAÇÃO DE INFORMAÇÃO RECEBIDA DA GLOVAL                                                                  --
------------------------------------------------------------------------------------------------------------------

-- ADICIONAR À KT CHAVES GLOVAL OS IMÓVEIS APÓS DEFINIÇÃO DE CHAVE ENCRIPTADA                                               --
--- CREATE TABLE 
--drop table bu_esg_work.kt_chave_gloval;
--create table bu_esg_work.kt_chave_gloval
--(
--chave_banco_utilizada string,
--chave_banco_atual string,
--chave_gloval_enviada string,
--data_envio string
--)
;

--- ADICIONAR VALORES 
INSERT INTO TABLE bu_esg_work.kt_chave_gloval
VALUES
('{chave_banco_utilizada}','{chave_banco_atual}','{chave_gloval_enviada}','{data_envio}'),
('{chave_banco_utilizada}','{chave_banco_atual}','{chave_gloval_enviada}','{data_envio}'),
('{chave_banco_utilizada}','{chave_banco_atual}','{chave_gloval_enviada}','{data_envio}')



-- AGREGAÇÃO DE INFORMAÇÃO  DE CERTIFICADOS
---318049
--DROP TABLE bu_esg_work.gloval_clase_energetica;
CREATE TABLE bu_esg_work.gloval_clase_energetica_jun24 AS

SELECT *
FROM
(
    SELECT ROW_NUMBER () OVER (PARTITION BY CHAVE_BANCO_ATUAL
                                         ORDER BY FLG_CHAVE DESC, FLG_ENVIO DESC) AS N,
                     INFO_GLOVAL.*
    FROM
    (
        (
            SELECT DISTINCT  CONCAT(ckbalbem, ckctabem, ckrefbem) AS CHAVE_BANCO_ATUAL, clase_energetica, fiabilidad, emisiones, consumos, 
            '0' AS FLG_ADJUDICADOS, 1 AS FLG_CHAVE, 0 AS FLG_ENVIO
            FROM bu_captools_work.rf_metricas_pilar3_ctr_v7 
            WHERE fiabilidad IS NOT NULL 
        )
        UNION ALL
        (
            SELECT cod_imovel AS CHAVE_BANCO_ATUAL, CLASE_ENERGETICA,FIABILIDAD,EMISIONES,CONSUMOS, '1' AS FLG_ADJUDICADOS,1 AS FLG_CHAVE, 2 AS FLG_ENVIO
            FROM bu_esg_work.adjudicados_final_JUN23 
        )
        UNION ALL
        (
            SELECT cod_imovel AS CHAVE_BANCO_ATUAL, CLASE_ENERGETICA,FIABILIDAD,EMISIONES,CONSUMOS, '1' AS FLG_ADJUDICADOS,1 AS FLG_CHAVE, 1 AS FLG_ENVIO
            FROM bu_captools_work.rf_metricas_adjudicad_final_v2 
        )
        UNION ALL
        (
        SELECT KT_CHAVE.CHAVE_BANCO_ATUAL,CLASE_ENERGETICA,FIABILIDAD,EMISIONES,CONSUMOS,FLG_ADJUDICADOS,2 AS FLG_CHAVE, FLG_ENVIO
        FROM
        (
            SELECT *, CASE WHEN LENGTH(CHAVE_BANCO_ATUAL) < 30 THEN '1' ELSE '0' END AS FLG_ADJUDICADOS
            FROM bu_esg_work.kt_chave_gloval
        ) KT_CHAVE
        INNER JOIN
        (
            SELECT CHAVE_GLOVAL,FIABILIDAD,CLASE_ENERGETICA,EMISIONES,CONSUMOS,FLG_ENVIO
            FROM
             (SELECT ROW_NUMBER () OVER (PARTITION BY CHAVE_GLOVAL
                                         ORDER BY FLG_ENVIO DESC) AS ORDEM,
                     X.*
              FROM
                (SELECT CHAVE_GLOVAL,FIABILIDAD,CLASE_ENERGETICA,EMISIONES,CONSUMOS,    
                        CASE 
                            WHEN CARTERA = 'cartera_2022' THEN 1
                            WHEN CARTERA = 'cartera_2023' THEN 2 
                        END AS FLG_ENVIO
                    FROM bu_esg_work.informacao_gloval_agrupada
                    UNION ALL
                    (
                        SELECT CHAVE_GLOVAL,FIABILIDAD,CLASE_ENERGETICA,EMISIONES,CONSUMOS,3 AS FLG_ENVIO
                        FROM bu_esg_work.informacao_gloval_incr_dez23
                    )
                )X
            ) XX
            WHERE ORDEM = 1      
        ) JUN23_DEZ23    
        ON KT_CHAVE.CHAVE_GLOVAL_ENVIADA = JUN23_DEZ23.CHAVE_GLOVAL
        )
		
	UNION ALL 
	

       ( SELECT KT_CHAVE.CHAVE_BANCO_ATUAL,CLASE_ENERGETICA,FIABILIDAD,EMISIONES,CONSUMOS,FLG_ADJUDICADOS,2 AS FLG_CHAVE, FLG_ENVIO
        FROM
        (
            SELECT *, CASE WHEN LENGTH(CHAVE_BANCO_ATUAL) < 30 THEN '1' ELSE '0' END AS FLG_ADJUDICADOS
            FROM bu_esg_work.kt_chave_gloval
        ) KT_CHAVE
        INNER JOIN
        ( SELECT CHAVE_GLOVAL,FIABILIDAD,CLASE_ENERGETICA,EMISIONES,CONSUMOS,4 AS FLG_ENVIO
          FROM bu_esg_work.informacao_gloval_incr_JUN24 ) JUN24
   
        ON KT_CHAVE.CHAVE_GLOVAL_ENVIADA = JUN24.CHAVE_GLOVAL
      
        )
		
    ) INFO_GLOVAL  
)INFO_FINAL
WHERE N = 1 


;
