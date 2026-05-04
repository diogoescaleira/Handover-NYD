-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### 7. Monitorização contínua

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC **7.1.8.** Indicação, relativamente ao período de referência, do número total de alertas gerados:
-- MAGIC
-- MAGIC  **a)** Pelos sistemas informáticos de filtragem; [Resposta: campo numérico]

-- COMMAND ----------

-- Para NORKOM
select
  count(*)
from
  (
    select
      cd.id,
      cd.transaction_id,
      cd.customer_id,
      cd.alert_identifier,
      cd.alert_score,
      cd.WORKFLOW_WORKITEM_ID,
      cd.alert_match_count,
      ww.assigned_by,
      ww.assigned_timestamp,
      ww.assigned_to,
      ww.creation_timestamp,
      ww.domain_id,
      ww.entity_name,
      ww.latest_action_timestamp,
      ww.latest_action_userid,
      ww.status_id,
      ww.status_timestamp,
      cd.check_definition_id,
      dc.check_name,
      dc.description
    from
      production.curated_internal_norkom.wlm_rule_alert cd,
      production.curated_internal_norkom.workflow_workitem ww,
      production.curated_internal_norkom.check_definition dc
    where
      cd.source_system = 'WLM RT'
      and cd.id = ww.ENTITY_KEY_NUM
      and ww.ENTITY_NAME = 'WLM Alert'
      and cd.check_definition_id = dc.id
      and cd.data_date_part = '2026-02-12'
      and ww.data_date_part = '2026-02-12'
      and dc.data_date_part = '2026-02-12'
      and substr(ww.creation_timestamp, 1, 4) = '2025'
  ) as t;
-- 191.032

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **7.1.8.** Indicação, relativamente ao período de referência, do número total de alertas gerados:  
-- MAGIC **i.** Provenham de atividades criminosas (que não estejam relacionadas com o FT);

-- COMMAND ----------



select count(distinct alert_identifier) 
from(
  select alert_identifier
  from production.business_fcc.alertas_kyc_alm
  where 1=1
    and data_date_part = '2025-12-31'
    and domain_code like '%AML%'
    and date(creation_timestamp) between '2025-01-01' and '2025-12-31' 
    and status_id <> 1440
    and scenario not like 'Cenario 058%'
  union all
  select alert_identifier
  from production.business_fcc.alertas_kyc_alm
  where 1=1
    and data_date_part = '2025-12-31'
    and domain_code like '%AML%'
    and date(creation_timestamp) between '2025-01-01' and '2025-12-31' 
    and status_id = 1440
    and scenario not like 'Cenario 058%'
    and scenario not like 'Cenario 001%'
)
    
; -- ANO2024 - 155.861 - total reportado
  -- ANO2025 - 30 200 - total Norkom


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **ii.** Estejam relacionados com o FT; [Resposta: campo numérico] 

-- COMMAND ----------

select count(distinct alert_identifier) 
from production.business_fcc.alertas_kyc_alm
where data_date_part = '2025-12-31'
  and domain_code like '%AML%'
  and date(creation_timestamp) between '2025-01-01' and '2025-12-31' 
  and status_id <> 1440
  and scenario like 'Cenario 058%'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **7.1.9.** Indicação, relativamente ao período de referência, do número total de alertas  
-- MAGIC **a)** Pelos sistemas informáticos de filtragem, que:
-- MAGIC **i.** Desencadearam o dever de exame

-- COMMAND ----------

-- Para Norkom
select count(*)
FROM production.curated_internal_norkom.workflow_action_log
where  data_date_part= '2026-02-12'
and comment_text like ('%Escalado N2%')
and substr(logtimestamp,1,4)='2025';


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Pelos sistemas informáticos de filtragem, que:  
-- MAGIC **ii.** Não Desencadearam o dever de exame

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **b)** Pelos sistemas informáticos de monitorização, que:  
-- MAGIC **i.** Desencadearam o dever de exame;

-- COMMAND ----------

-- fechados com estado: 
--Revisto. Inicia comunicação (novo caso)
--Revisto. Inicia comunicação (caso existente)
--Já notificado.

select count(distinct alert_identifier) 
from production.business_fcc.alertas_kyc_alm
where data_date_part = '2025-12-31'
  and domain_code like '%AML%'
  and date(creation_timestamp) between '2025-01-01' and '2025-12-31' 
  and status_id in (1121, 1122, 1148)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **ii.** Não desencadearam o dever de exame. [Resposta: campo numérico] 

-- COMMAND ----------

-- fechados com estado: 
--Revisto.Considerado.
--Revisto.Notificar balcão.

select count(distinct alert_identifier) 
from production.business_fcc.alertas_kyc_alm
where data_date_part = '2025-12-31'
  and domain_code like '%AML%'
  and date(creation_timestamp) between '2025-01-01' and '2025-12-31' 
  and status_id in (1145, 1147)