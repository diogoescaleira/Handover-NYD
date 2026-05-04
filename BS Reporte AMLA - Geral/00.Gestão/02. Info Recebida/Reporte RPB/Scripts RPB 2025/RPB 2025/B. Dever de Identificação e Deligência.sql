-- Databricks notebook source
-- MAGIC %md
-- MAGIC ##### 1.3. Procedimentos de identificação de beneficiários efetivos

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **1.3.1.** Indicação do número total de relações de negócio com clientes “pessoas coletivas” e “centros de
-- MAGIC  interesses coletivos sem personalidade jurídica” sem beneficiários efetivos identificados. [Resposta: campo numérico]	

-- COMMAND ----------

--- Pessoas Juridicas 
select count(distinct party_id) from 
     (
              SELECT DISTINCT a.party_id
              FROM
                    (
                      select * from production.workbench_fcc.rpb25_universo_dever_id_dil
                      where Tipo_Cliente = 'J' 
                    ) a

              LEFT JOIN
                    (
                      select * from production.workbench_fcc.rpb25_universo_befs_periodo_ref 
                    )b
              ON a.party_id  = b.party_id_empresa
                
              WHERE b.party_id_empresa is null
      


 UNION ALL
-- centros de interesses coletivos sem personalidade juridica

              SELECT DISTINCT aa.party_id
              FROM
                    (
                      select * from production.workbench_fcc.rpb25_universo_dever_id_dil
                      where  centro_inter_colec_s_person_juridica='S' and Tipo_Cliente = 'J' 
                    ) aa

              LEFT JOIN
                    (
                      select * from production.workbench_fcc.rpb25_universo_befs_periodo_ref 
                    )bb
              ON aa.party_id  = bb.party_id_empresa
                
              WHERE bb.party_id_empresa is null 
      )

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **1.3.2.** Indicação do número de relações de negócio estabelecidas durante o período de referência 
-- MAGIC com clientes  
-- MAGIC **a)** Sem beneficiários efetivos identificados

-- COMMAND ----------

-- DBTITLE 1,Cell 5
--- Pessoas Juridicas 
select count(distinct party_id) from 
     (
              SELECT DISTINCT a.party_id
              FROM
                    (
                      select * from production.workbench_fcc.rpb25_universo_dever_id_dil
                      where Tipo_Cliente = 'J' and nova_rel = 'S'
                    ) a

              LEFT JOIN
                    (
                      select * from production.workbench_fcc.rpb25_universo_befs_periodo_ref 
                    )b
              ON a.party_id  = b.party_id_empresa
                
              WHERE b.party_id_empresa is null
      


 UNION ALL
-- centros de interesses coletivos sem personalidade juridica

              SELECT DISTINCT aa.party_id
              FROM
                    (
                      select * from production.workbench_fcc.rpb25_universo_dever_id_dil
                      where  nova_rel='S' and centro_inter_colec_s_person_juridica='S' and Tipo_Cliente = 'J' 
                    ) aa

              LEFT JOIN
                    (
                      select * from production.workbench_fcc.rpb25_universo_befs_periodo_ref 
                    )bb
              ON aa.party_id  = bb.party_id_empresa
                
              WHERE bb.party_id_empresa is null 
      )

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 1.4. Procedimentos complementares de diligência
-- MAGIC Relativamente ao período em referência, indicação do número de relações de negócio estabelecidas e respetiva percentagem face ao total de relações de negócio estabelecidas nesse período:    

-- COMMAND ----------

-- MAGIC %md
-- MAGIC a) Em que foi recolhida informação sobre a finalidade e a natureza da relação; [Resposta: campo numérico]  
-- MAGIC
-- MAGIC 	
-- MAGIC

-- COMMAND ----------

select count(distinct party_id) 
from production.workbench_fcc.rpb25_universo_dever_id_dil
where nova_rel='S'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC b) Em que foi recolhida informação sobre a origem e destino dos fundos. [Resposta: campo numérico]

-- COMMAND ----------

select count(distinct party_id) 
from(
    select distinct party_id
    from production.workbench_fcc.rpb25_universo_dever_id_dil
    where nova_rel='S' and risco_alto='S'
    union all
    select distinct party_id
    from production.workbench_fcc.rpb25_universo_dever_id_dil
    where nova_rel='S' and risco_atual = 'A'
)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **2.3.** [Em caso de resposta afirmativa à questão 2.2.] Indicação, por perfil de risco, do número de clientes nesta situação. [Resposta em linhas, com 2 colunas: 1) Perfil de risco; 2) Número de clientes	
-- MAGIC Risco	Nº Clientes
-- MAGIC 	
-- MAGIC 	
-- MAGIC 	
-- MAGIC

-- COMMAND ----------

---Ana Marta está a preparar a tabela com a visão a 31/12/2025
select*from workbench_fcc.dashboard_seguimentokyc_metricas

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. DILIGÊNCIA REFORÇADA

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.1. Informações gerais
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.1.1. Indicação do número de relações de negócio sujeitas a medidas de diligência reforçada à data do termo do período de referência do RPB (31 de dezembro)
-- MAGIC

-- COMMAND ----------

select count(distinct party_id)
from  production.workbench_fcc.rpb25_universo_dever_id_dil 
where risco_atual='A'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.2 Jurisdições de risco 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.2.1. Indicação do número de RELAÇÕES DE NEGÓCIO que, no período de referência,foram sujeitas a medidas de diligência reforçada associadas a:
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC  a) Jurisdições de risco elevado, identificadas pela União Europeia ou pelo GAFI como tendo deficiências estratégicas em matéria de prevenção e combate ao BC, ao FT e ao financiamento da proliferação; [Resposta: campo numérico]

-- COMMAND ----------

--- PENDENTE DOS CLIENTES ATIVOS E DA LISTA DO GAFI.

select count(distinct party_id)
from  production.workbench_fcc.rpb25_universo_dever_id_dil 
where 1=1 
and (risco_atual='A' or risco_alto='S') 
and (Nacionalidade in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG') 
 or Sede in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG')
 or Residencia_Principal in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG')
 or Naturalidade in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG'))



-- COMMAND ----------

-- MAGIC %md
-- MAGIC Comsiderando a lista do ano passado para análisa da diferenças

-- COMMAND ----------


---Lista do GAFI 2024.
select count(distinct party_id)
from  production.workbench_fcc.rpb25_universo_dever_id_dil 
where risco_atual='A' and
 (Nacionalidade in ('ZA','BF','CM','PH','JM','MM','MZ','NG','CD','SN','SY','TZ','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','AF','BB','AE','GI','PA','TT','UG','VU') or Sede in ('ZA','BF','CM','PH','JM','MM','MZ','NG','CD','SN','SY','TZ','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','AF','BB','AE','GI','PA','TT','UG','VU'))

-- COMMAND ----------

-- MAGIC %md
-- MAGIC  b) Jurisdições sujeitas a medidas restritivas adotadas pelo Conselho de Segurança das Nações Unidas ou pela União Europeia

-- COMMAND ----------

select count(distinct party_id)
from  production.workbench_fcc.rpb25_universo_dever_id_dil 
where 1=1 and (risco_atual='A' or risco_alto='S') 
and 
 (Nacionalidade in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US') 
 or 
 Sede in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US')
  or 
 Residencia_Principal in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US')
  or 
 Naturalidade in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US')
 )

-- COMMAND ----------

---Lista ONU/EU 2024 

select count(distinct party_id)
from  production.workbench_fcc.rpb25_universo_dever_id_dil 
where risco_atual='A' 
and
 (Nacionalidade in ('AF','BB','KY','JM','JO','MM','PA','CD','SN','SY','TT','UG','VU','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NI','NE','RU','SS','TR','UA','VE','ZW','YE','BA','KH','GH','MA','PK','CF','ME','RS') 
or 
 Sede in ('AF','BB','KY','JM','JO','MM','PA','CD','SN','SY','TT','UG','VU','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NI','NE','RU','SS','TR','UA','VE','ZW','YE','BA','KH','GH','MA','PK','CF','ME','RS'))




-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.2.2. Indicação do número transações ocasionais que, no período de referência, foram sujeitas a medidas de diligência reforçada associadas a:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC a) Jurisdições de risco elevado, identificadas pela União Europeia ou pelo GAFI com tendo deficiências estratégicas em matéria de prevenção e combate ao BC, ao FT e ao financiamento da proliferação; [Resposta: campo numérico]"	
-- MAGIC 	
-- MAGIC b) Jurisdições sujeitas a medidas restritivas adotadas pelo Conselho de Segurança das Nações Unidas ou pela União Europeia. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.2.3. Indicação do número de relações de negócio que, no período de referência, foram sujeitas a  medidas de diligência reforçada associadas a:
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC a) Clientes “pessoas singulares” com nacionalidade estrangeira; [Resposta: campo numérico]

-- COMMAND ----------

select count(distinct party_id)
from  production.workbench_fcc.rpb25_universo_dever_id_dil  
where (risco_alto='S' And Tipo_Cliente='F' AND Nacionalidade <> 'PT') OR (risco_atual='A' And Tipo_Cliente='F' AND Nacionalidade <> 'PT')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC b) Clientes “pessoas singulares” com residência permanente no estrangeiro; [Resposta: campo numérico]

-- COMMAND ----------

select count(distinct party_id)
from  production.workbench_fcc.rpb25_universo_dever_id_dil  
where (risco_alto='S' And Tipo_Cliente='F' AND Residencia_Principal <> 'PT') OR (risco_atual='A' And Tipo_Cliente='F' AND Residencia_Principal <> 'PT')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC c) Clientes “pessoas coletivas” ou “centro de interesses coletivos sem personalidade jurídica” com sede no estrangeiro. [Resposta: campo numérico]

-- COMMAND ----------

select count(distinct party_id)
from  production.workbench_fcc.rpb25_universo_dever_id_dil  
where (risco_alto='S' And Tipo_Cliente = 'J' AND Sede <> 'PT') 
OR (risco_atual='A' And  Tipo_Cliente = 'J' AND Sede <> 'PT') 
OR (risco_atual='A' And  Tipo_Cliente = 'F' AND centro_inter_colec_s_person_juridica = 'S' AND Nacionalidade <> 'PT') 
OR (risco_alto='S' And  Tipo_Cliente = 'F' AND centro_inter_colec_s_person_juridica = 'S' AND Nacionalidade <> 'PT')