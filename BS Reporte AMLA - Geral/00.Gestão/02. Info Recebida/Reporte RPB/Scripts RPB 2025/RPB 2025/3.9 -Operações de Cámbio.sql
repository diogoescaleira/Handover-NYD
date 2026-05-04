-- Databricks notebook source
-- MAGIC %md
-- MAGIC #### 3.9 Operações de câmbio

-- COMMAND ----------

-- MAGIC %md
-- MAGIC  **3.9.1.** Número de operações de câmbio realizadas no período de referência. [Resposta: campo numérico] N/A

-- COMMAND ----------

 SELECT count(distinct transaction_id)  from (select 
  a.*, 
  trim(c.element_description) as desc_moeda, 
  case
    when a.currency_code <> '978' then round(amount * d.TCMBME,2)
    else round(amount,2)
  end as montante_eur
from(
  select 
    * 
  from 
    production.common_payments_occasionaltransactions.occasional_transaction
  where 
    transaction_request_date between '2025-01-01' and '2025-12-31' 
    -- and transaction_detail_code in ('CDP', 'SDP', 'FXS') 
    and party_id <> '#N/A'
) a
inner join( -- define tipos de depósitos com base no BANKTELLER (700 Dep Numerario Balcao, 713 Dep Numerario SelBanking, 708 Compra de Moeda Estrangeira)
  select 
    * 
  from 
    common_referencedata_core.param_general_code_converter
  where 
    data_date_part = '2026-02-09' 
    and source_code = 'BKT'
    and target_field = 'transaction_detail_code'
    and source_value in ('706','708') 
) b
on a.transaction_detail_code = b.target_value
left join( -- tradução do código da moeda
  select 
    * 
  from 
    common_referencedata_core.reference_data_table
  where 
    data_date_part = '2026-02-09' 
    and data_table_code = '000206'
) c
on a.currency_code = c.element_code
left join(
  select 
    * 
  from curated_internal_mainframe_cambios.cbt02_cambios 
  where 
    CTBCAMB = 'F' 
    and cmarca = 'BT' 
    and zseqcamb = '99' 
) d
on a.currency_code = d.cmoeda and a.data_date_part = d.data_date_part) 

-- COMMAND ----------

-- 3.9 Operações de câmbio
-- 3.9.1. Número de operações de câmbio realizadas no período de referência. [Resposta: campo numérico] N/A
SELECT count(DISTINCT A.txn_id) 
       FROM  production.curated_internal_norkom.transactions AS A, production.curated_internal_norkom.san_familias  AS B
       
                  WHERE  A.sa_code_reda=B.sa_code_reda 
                      AND B.sa_cod_familia in ('0014', '0015') --- Compra e venda de Moéda
                   
                      AND a.run_date BETWEEN '2025-01-01' AND '2025-12-31';
                      

 

   

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **3.9.2.** Montante agregado, em euros, das operações de câmbio realizadas no período de referência. [Resposta: campo numérico] N/A

-- COMMAND ----------

-- 3.9.2. Montante agregado, em euros, das operações de câmbio realizadas no período de referência. [Resposta: campo numérico] N/A


SELECT count(DISTINCT A.txn_id), sum(A.txn_amount_base) AS Montante 
               FROM  production.curated_internal_norkom.transactions AS A, production.curated_internal_norkom.san_familias  AS B
               
                          WHERE  A.sa_code_reda=B.sa_code_reda 
                              AND B.sa_cod_familia in ('0014', '0015') 
                              -- -AND B.sa_cod_familia in ('0014', '0015', '0018') 
                             
                              AND a.run_date BETWEEN '2025-01-01' AND '2025-12-31'
                            ;

-- COMMAND ----------

 SELECT  count( distinct transaction_id), sum(montante_eur)  from (select 
  a.*, 
  trim(c.element_description) as desc_moeda, 
  case
    when a.currency_code <> '978' then round(amount * d.TCMBME,2)
    else round(amount,2)
  end as montante_eur
from(
  select 
    * 
  from 
    production.common_payments_occasionaltransactions.occasional_transaction
  where 
    transaction_request_date between '2025-01-01' and '2025-12-31' 
    -- and transaction_detail_code in ('CDP', 'SDP', 'FXS') 
    and party_id <> '#N/A'
) a
inner join( -- define tipos de depósitos com base no BANKTELLER (700 Dep Numerario Balcao, 713 Dep Numerario SelBanking, 708 Compra de Moeda Estrangeira)
  select 
    * 
  from 
    common_referencedata_core.param_general_code_converter
  where 
    data_date_part = '2026-02-09' 
    and source_code = 'BKT'
    and target_field = 'transaction_detail_code'
    and source_value in ('706','708') 
) b
on a.transaction_detail_code = b.target_value
left join( -- tradução do código da moeda
  select 
    * 
  from 
    common_referencedata_core.reference_data_table
  where 
    data_date_part = '2026-02-09' 
    and data_table_code = '000206'
) c
on a.currency_code = c.element_code
left join(
  select 
    * 
  from curated_internal_mainframe_cambios.cbt02_cambios 
  where 
    CTBCAMB = 'F' 
    and cmarca = 'BT' 
    and zseqcamb = '99' 
) d
on a.currency_code = d.cmoeda and a.data_date_part = d.data_date_part)
 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.9.4. Identificação das 10 divisas estrangeiras objeto de maior volume de transação, com indicação do montante agregado, em euros, associado às mesmas. [Resposta em linhas, duas colunas: 1) escolha da divisa a partir de uma lista prédefinida; 2) indicação do montante associado] N/A							
-- MAGIC

-- COMMAND ----------

SELECT  desc_moeda as Divisa, sum(montante_eur) as Montante  from (select 
  a.*, 
  trim(c.element_description) as desc_moeda, 
  case
    when a.currency_code <> '978' then round(amount * d.TCMBME,2)
    else round(amount,2)
  end as montante_eur
from(
  select 
    * 
  from 
    production.common_payments_occasionaltransactions.occasional_transaction
  where 
    transaction_request_date between '2025-01-01' and '2025-12-31' 
    -- and transaction_detail_code in ('CDP', 'SDP', 'FXS') 
    and party_id <> '#N/A'
) a
inner join( -- define tipos de depósitos com base no BANKTELLER (700 Dep Numerario Balcao, 713 Dep Numerario SelBanking, 708 Compra de Moeda Estrangeira)
  select 
    * 
  from 
    common_referencedata_core.param_general_code_converter
  where 
    data_date_part = '2026-02-09' 
    and source_code = 'BKT'
    and target_field = 'transaction_detail_code'
    and source_value in ('706','708') 
) b
on a.transaction_detail_code = b.target_value
left join( -- tradução do código da moeda
  select 
    * 
  from 
    common_referencedata_core.reference_data_table
  where 
    data_date_part = '2026-02-09' 
    and data_table_code = '000206'
) c
on a.currency_code = c.element_code
left join(
  select 
    * 
  from curated_internal_mainframe_cambios.cbt02_cambios 
  where 
    CTBCAMB = 'F' 
    and cmarca = 'BT' 
    and zseqcamb = '99' 
) d
on a.currency_code = d.cmoeda and a.data_date_part = d.data_date_part)
 GROUP by desc_moeda ORDER BY sum(montante_eur) DESC LIMIT 10