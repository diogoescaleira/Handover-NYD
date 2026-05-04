-- Databricks notebook source
-- MAGIC %md
-- MAGIC #### 6.4.6. Descrição dos perfis de risco, com indicação:											
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC c) Percentagem de clientes associada a cada perfil de risco face ao número total de clientes à data do termo do período de referência do RPB (31 de dezembro);							
-- MAGIC 							
-- MAGIC 							
-- MAGIC 						
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------

SELECT
  risco_dsc,
  COUNT(DISTINCT partenon_id) AS Total
FROM
  production.workbench_fcc.rpb25_universo_parties
WHERE
  'BEF' <> 'S'
GROUP by
  risco_dsc
ORDER BY
  total DESC

-- COMMAND ----------

-- DBTITLE 1,Cell 4
WITH RISCO AS (
  SELECT risco_dsc, COUNT(DISTINCT partenon_id) AS Perfil
  FROM production.workbench_fcc.rpb25_universo_parties 
  WHERE 'BEF' <> 'S'
  GROUP BY risco_dsc
),
TotalClientes AS (
  SELECT COUNT(DISTINCT partenon_id) AS Total
  FROM production.workbench_fcc.rpb25_universo_parties 
  WHERE 'BEF' <> 'S'
)
SELECT 
  CASE
    WHEN TotalClientes.Total = 0 THEN 0
    WHEN RISCO.risco_dsc = 'A' THEN RISCO.Perfil / TotalClientes.Total
    ELSE 0
  END AS RiscoAlto,

  CASE
    WHEN TotalClientes.Total = 0 THEN 0
    WHEN RISCO.risco_dsc = 'M' THEN RISCO.Perfil / TotalClientes.Total
    ELSE 0
  END AS RiscoMedio
  ,
   CASE
    WHEN TotalClientes.Total = 0 THEN 0
    WHEN RISCO.risco_dsc = 'B' THEN RISCO.Perfil / TotalClientes.Total
    ELSE 0
  END AS RiscoBaixo
FROM RISCO
CROSS JOIN TotalClientes
--WHERE RISCO.risco_dsc = 'A'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC "d) Periodicidade da atualização da informação para cada perfil de risco.
-- MAGIC [Resposta em linhas, com 5 colunas: 1) designação do perfil de risco; 2) caracterização; 3) percentagem de clientes; 4) periodicidade da atualização da informação; 5) observações]"							
-- MAGIC designação do perfil de risco	caracterização	 percentagem de clientes	periodicidade atualização da info.	observações			