-- Databricks notebook source
-- MAGIC %md
-- MAGIC QUERY DEPÓSITOS EM NUMERÁRIOS 

-- COMMAND ----------

-- DBTITLE 1,Tabela Temporária depositos todos
-- MAGIC %python
-- MAGIC tbl_DepositosNumerarios = spark.sql(f"""
-- MAGIC select
-- MAGIC   a.*, 
-- MAGIC   trim(c.element_description) as desc_moeda, 
-- MAGIC   case
-- MAGIC     when a.currency_code <> '978' then round(amount * d.TCMBME,2)
-- MAGIC     else round(amount,2)
-- MAGIC   end as montante_eur,
-- MAGIC   e.depositant_type as tipo_depositante
-- MAGIC from(
-- MAGIC   select 
-- MAGIC     * 
-- MAGIC   from 
-- MAGIC     production.common_payments_occasionaltransactions.occasional_transaction
-- MAGIC   where 
-- MAGIC     transaction_request_date between '2025-01-01' and '2025-12-31' 
-- MAGIC ) a
-- MAGIC inner join( -- define tipos de depósitos com base no BANKTELLER (700 Dep Numerario Balcao, 713 Dep Numerario SelBanking, 709 Entregas Reduzidas, 708 Compra de Moeda Estrangeira)
-- MAGIC   select 
-- MAGIC     * 
-- MAGIC   from 
-- MAGIC     common_referencedata_core.param_general_code_converter
-- MAGIC   where 
-- MAGIC     data_date_part = '2026-02-09' 
-- MAGIC     and source_code = 'BKT'
-- MAGIC     and target_field = 'transaction_detail_code'
-- MAGIC     and source_value in ('700', '713', '708') 
-- MAGIC ) b
-- MAGIC on a.transaction_detail_code = b.target_value
-- MAGIC left join( -- tradução do código da moeda
-- MAGIC   select 
-- MAGIC     * 
-- MAGIC   from 
-- MAGIC     common_referencedata_core.reference_data_table
-- MAGIC   where 
-- MAGIC     data_date_part = '2026-02-09' 
-- MAGIC     and data_table_code = '000206'
-- MAGIC ) c
-- MAGIC on a.currency_code = c.element_code
-- MAGIC left join(
-- MAGIC   select 
-- MAGIC     * 
-- MAGIC   from curated_internal_mainframe_cambios.cbt02_cambios 
-- MAGIC   where 
-- MAGIC     CTBCAMB = 'F' 
-- MAGIC     and cmarca = 'BT' 
-- MAGIC     and zseqcamb = '99' 
-- MAGIC ) d
-- MAGIC on a.currency_code = d.cmoeda and a.data_date_part = d.data_date_part
-- MAGIC left join(
-- MAGIC   select 
-- MAGIC     *
-- MAGIC   from production.curated_internal_bankteller.cr_log
-- MAGIC   where data_date_part between '2025-01-01' and '2025-12-31' 
-- MAGIC ) e
-- MAGIC on cast(a.transaction_id as bigint) = cast(e.id as bigint)
-- MAGIC
-- MAGIC """)
-- MAGIC
-- MAGIC tbl_DepositosNumerarios.write.format("delta").mode("overwrite").option("mergeSchema", "true").saveAsTable("workbench_fcc.rpb25_depositos_numerario")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **8.** REGISTOS INFORMATIZADOS E CENTRALIZADOS

-- COMMAND ----------

select
  count(distinct transaction_id),
  sum(montante_eur)
from workbench_fcc.rpb25_depositos_numerario
where
  tipo_depositante = 'Terceiro'
  and montante_eur > 0

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **8.1.2.** Montante agregado, em euros, dos depósitos em numerário realizados por terceiros em contas tituladas por clientes no período de referência

-- COMMAND ----------

select
  count(distinct transaction_id),
  sum(montante_eur)
from workbench_fcc.rpb25_depositos_numerario
where
  tipo_depositante = 'Terceiro'
  and montante_eur > 0