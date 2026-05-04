---------------------
-- VALIDACOES INCREMENTO
------------------------

--1) Universo


SELECT VALIDACAO, COUNT(*) FROM (
SELECT CASE WHEN JUN.CODIGO_BANCO IS NULL THEN 'UNIV EX DEZ'
            WHEN DEZ.CODIGO_BANCO IS NULL THEN 'UNIV EX JUN'
            ELSE 'UNIVERSO COMUM'
            END AS VALIDACAO
FROM
  (SELECT * --273.572
   FROM bu_esg_work.p3_gloval
   WHERE ref_date = '2024-06-30') jun
FULL OUTER JOIN
  (SELECT * -- 272.480
   FROM bu_esg_work.p3_gloval
   WHERE ref_date = '2023-12-31') DEZ ON JUN.CODIGO_BANCO = DEZ.CODIGO_BANCO

) XX
GROUP BY 1;

--2) Duplicados (caso existam duplicado spor qualidade de dados, será retirado o regisot de "lixo" do excel a enviar a GLOVAL)


select codigo_banco, count(*) 

from (
SELECT NEW.* FROM
  (SELECT * --273.572
   FROM bu_esg_work.p3_gloval
   WHERE ref_date = '2024-06-30') NEW
LEFT JOIN
  (SELECT * -- 272.480
   FROM bu_esg_work.p3_gloval
   WHERE ref_date = '2023-12-31') OLD ON NEW.CODIGO_BANCO = OLD.CODIGO_BANCO

WHERE OLD.CODIGO_BANCO IS NULL

) xx
group by 1
having count(*) >1;


;
