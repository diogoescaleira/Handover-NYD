-- Databricks notebook source
-- MAGIC %md
-- MAGIC **1.1.**/**1.2.** Indicação da contagem e do montante agregado, em euros, das operações examinadas no período de referência

-- COMMAND ----------

-- DBTITLE 1,NORKOM - execpto Rutura Perfil
--1 alerta perdido porque é do 58 que não tem transações

select count(distinct d.txn_id) as n_trx, sum(montante_eur) montante_total from(
  select alert_key, alert_identifier, case_key, case_identifier
  from production.curated_internal_norkom.v_alert_details_aml
  where data_date_part = '2025-12-31'
  and date(created_on) between '2025-01-01' and '2025-12-31' 
  and status_id in (1121, 1122, 1148) 
  and alert_identifier not like '%DK'
  and scenario not like 'Cenario 001%'
) a
inner join(
  select id, mon_base_alert_id 
  from production.curated_internal_norkom.mon_alert
  where data_date_part = '2025-12-31'
) b
on a.alert_key = b.mon_base_alert_id
inner join(
  select txn_id, mon_alert_id, 'transaction_perfcor_alert_tag' as src_tbl
  from production.curated_internal_norkom.transaction_perfcor_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxbancagcb_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxbancagcb_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxcartoes_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxcartoes_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxclientesan_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxclientesan_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxclientesdiario_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxclientesdiario_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxclientesmens_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxclientesmens_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxclientesmenst_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxclientesmenst_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxcofresaluguer_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxcofresaluguer_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxcontasamort_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxcontasamort_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxcontasdiario_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxcontasdiario_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxcontasmens_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxcontasmens_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxcontassem_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxcontassem_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxnoclientes_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxnoclientes_alert_tag
  where data_date_part = '2025-12-31'
  union all
  select txn_id, mon_alert_id, 'trxperfilbp_alert_tag' as src_tbl
  from production.curated_internal_norkom.trxperfilbp_alert_tag
  where data_date_part = '2025-12-31'
) c
on b.id = cast(c.mon_alert_id as int)
left join(
  select concat(txn_id, source_txn_num, account_id) as txn_id, txn_amount_base as montante_eur
  from curated_internal_norkom.transactions
  where data_date_part between '2024-10-01' and '2025-12-31'
  union all
  select  SA_NMOVIM as txn_id, SA_IMPORTE as montante_eur
  from curated_internal_norkom.san_transactions_amortizacion
  where data_date_part between '2024-10-01' and '2025-12-31'
  union all 
  select concat(date(SA_FECHA_OPERACION),SA_NMOVIM,SA_COD_TITULO,SA_ACCOUNT_ID) as txn_id, SA_IMPORTE as montante_eur
  from curated_internal_norkom.san_transactions_titulos
  where data_date_part between '2024-10-01' and '2025-12-31'
) d
on c.txn_id = d.txn_id



-- COMMAND ----------

-- DBTITLE 1,DATALAKE
--falta 1 alerta que não consigo encontrar na tabela dos alertas de DL

select count(distinct id_movimento), sum(montante_eur) montante_total from(
  select alert_key, alert_identifier, case_key, case_identifier, concat(date_add(date(created_on),-1), customer_id, scenario) as chave
  from production.curated_internal_norkom.v_alert_details_aml
  where data_date_part = '2025-12-31'
  and date(created_on) between '2025-01-01' and '2025-12-31' 
  and status_id in (1121, 1122, 1148) 
  and alert_identifier like '%DK'
) a
inner join(
  select ID_ALERTA_DATALAKE, concat(concat(substr(DATA_CRIACAO_ALERTA_DATALAKE,7,4),'-',substr(DATA_CRIACAO_ALERTA_DATALAKE,4,2),'-',substr(DATA_CRIACAO_ALERTA_DATALAKE,1,2)), 
  ID_CLIENTE, CENARIO_ALERTA_DATALAKE) as chave
  from business_fcc.cenarios_alerts
  where concat(substr(DATA_CRIACAO_ALERTA_DATALAKE,7,4),'-',substr(DATA_CRIACAO_ALERTA_DATALAKE,4,2),'-',substr(DATA_CRIACAO_ALERTA_DATALAKE,1,2)) between '2025-01-01' and '2025-12-31'
) b
on a.chave = b.chave
inner join(
  select ID_ALERTA_DATALAKE, ID_MOVIMENTO, cast(replace(VALOR_MOVIMENTO,',','.') as double) as montante_eur
  from business_fcc.cenarios_transactions
) c
on b.ID_ALERTA_DATALAKE = c.ID_ALERTA_DATALAKE


-- COMMAND ----------

-- DBTITLE 1,NORKOM - Rutura de Perfil
select count(distinct b.txn_id) as n_trx, sum(montante_eur) montante_total from(
  select alert_key, alert_identifier, case_key, case_identifier, customer_id, date(created_on)
  from production.curated_internal_norkom.v_alert_details_aml
  where data_date_part = '2025-12-31'
  and date(created_on) between '2025-01-01' and '2025-12-31' 
  and status_id in (1121, 1122, 1148) 
  and scenario like 'Cenario 001%'
) a
inner join(
  select concat(txn_id, source_txn_num, account_id) as txn_id, txn_amount_base as montante_eur,
  case when SA_ORIGINATOR_CUSTOMERID is null then SA_BENEFICIARY_CUSTOMERID else SA_ORIGINATOR_CUSTOMERID end as customer_id
  from curated_internal_norkom.transactions
  where data_date_part between '2024-01-01' and '2025-01-31'
) b
on a.customer_id = b.customer_id
