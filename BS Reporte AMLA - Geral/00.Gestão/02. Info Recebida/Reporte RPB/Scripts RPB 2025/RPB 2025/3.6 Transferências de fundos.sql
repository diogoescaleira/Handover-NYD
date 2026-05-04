-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### 3.6 Transferências de Fundos

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6 Transferências de fundos							
-- MAGIC 3.6.1 Informação geral  
-- MAGIC "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC
-- MAGIC i. Número total; [Resposta: campo numérico]"							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]"							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------



-- COMMAND ----------

select '3.6 -a.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R'


-- COMMAND ----------

select '3.6 -a.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R'  
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos )

union all

select '3.6-a.ii' as Pergunta, sum(montante_eur) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R'
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos )

union all

select '3.6-a.iii' as Pergunta, count(distinct customer_id_final) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos
where direcao='R'
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos )

union all 

select '3.6 -b.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E'
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos )

union all

select '3.6-b.ii' as Pergunta, sum(montante_eur) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E'
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos )

union all

select '3.6-b.iii' as Pergunta, count(distinct customer_id_final) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos
where direcao='E'
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos )

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.6.2.1 Clientes “pessoas singulares” (dados agregados):
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6.2.1 Clientes “pessoas singulares” (dados agregados):				  
-- MAGIC "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência:
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------

select * from production.workbench_fcc.rpb25_universo_parties_trf_fundos

-- COMMAND ----------

select '3.6.2.1. -a.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.1.-a.ii' as Pergunta, sum(montante_eur) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.1.-a.iii' as Pergunta, count(distinct customer_id_final) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.1. -b.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.1.-b.ii' as Pergunta, sum(montante_eur) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.1.-b.iii' as Pergunta, count(distinct customer_id_final) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final  in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='N')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.6.2.2 Clientes “pessoas singulares” com residência permanente em Portugal:    
-- MAGIC a) Transferências de fundos recebidas no período de referência:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC  3.6.2.2 Clientes “pessoas singulares” com residência permanente em Portugal:  "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC  i. Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência: 
-- MAGIC i.Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii.Número de clientes-ordenantes das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------

select '3.6.2.2. -a.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal='PT' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.2.-a.ii' as Pergunta, sum(montante_eur) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal='PT' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.2.-a.iii' as Pergunta, count(distinct customer_id_final) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal='PT' and centro_inter_colec_s_person_juridica='N')

union all 

select '3.6.2.2. -b.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal='PT' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.2.-b.ii' as Pergunta, sum(montante_eur) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal='PT' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.2.-b.iii' as Pergunta, count(distinct customer_id_final) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal='PT' and centro_inter_colec_s_person_juridica='N')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3.6.2.3 Clientes “pessoas singulares” com residência permanente no estrangeiro:

-- COMMAND ----------

select '3.6.2.2. -a.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal<>'PT' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.2.-a.ii' as Pergunta, sum(montante_eur) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal<>'PT' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.2.-a.iii' as Pergunta, count(distinct customer_id_final) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal<>'PT' and centro_inter_colec_s_person_juridica='N')

union all 

select '3.6.2.2. -b.i' as Pergunta, count(REFERENCIA) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal<>'PT' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.2.-b.ii' as Pergunta, sum(montante_eur) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal<>'PT' and centro_inter_colec_s_person_juridica='N')

union all

select '3.6.2.2.-b.iii' as Pergunta, count(distinct customer_id_final) as Resposta 
from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' 
and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and Residencia_Principal<>'PT' and centro_inter_colec_s_person_juridica='N')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.6.3 Informação sobre clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica”

-- COMMAND ----------


select '3.6.3.1-a.i' as Pergunta, count(referencia) AS Resposta 
FROM(
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J')
  union all
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S')
)

union all

select '3.6.3.1-a.ii' as Pergunta, sum(montante_eur) AS Resposta 
FROM(
  select referencia, montante_eur
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J')
  union all
  select referencia, montante_eur 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S')
)

union all

select '3.6.3.1-a.iii' as Pergunta, count( distinct customer_id_final) AS Resposta 
FROM(
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J')
  union all
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S')
)

union all 

select '3.6.3.1-b.i' as Pergunta, count(referencia) AS Resposta 
FROM(
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J')
  union all
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S')
)

union all

select '3.6.3.1-b.ii' as Pergunta, sum(montante_eur) AS Resposta 
FROM(
  select referencia, montante_eur
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J')
  union all
  select referencia, montante_eur 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S')
)

union all

select '3.6.3.1-b.iii' as Pergunta, count(distinct customer_id_final) AS Resposta 
FROM(
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J')
  union all
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S')
)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.6.3.2 Clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica” com sede em Portugal:  

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6.3.2 Clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica” com sede em Portugal:  
-- MAGIC "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC 					
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência: 
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC 					
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------


select '3.6.3.2-a.i' as Pergunta, count(referencia) AS Resposta 
FROM(
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede = 'PT')
  union all
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade = 'PT')
)

union all

select '3.6.3.2-a.ii' as Pergunta, sum(montante_eur) AS Resposta 
FROM(
  select referencia, montante_eur
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede = 'PT')
  union all
  select referencia, montante_eur 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade = 'PT')
)

union all

select '3.6.3.2-a.iii' as Pergunta, count( distinct customer_id_final) AS Resposta 
FROM(
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede = 'PT')
  union all
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade = 'PT')
)

union all 

select '3.6.3.2-b.i' as Pergunta, count(referencia) AS Resposta 
FROM(
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede = 'PT')
  union all
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade = 'PT')
)

union all

select '3.6.3.2-b.ii' as Pergunta, sum(montante_eur) AS Resposta 
FROM(
  select referencia, montante_eur
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede = 'PT')
  union all
  select referencia, montante_eur 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade = 'PT')
)

union all

select '3.6.3.2-b.iii' as Pergunta, count( distinct customer_id_final) AS Resposta 
FROM(
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede = 'PT')
  union all
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade = 'PT')
)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.6.3.3 Clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica” com sede no estrangeiro:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6.3.2 Clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica” com sede em Portugal:  
-- MAGIC "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência: 
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------


select '3.6.3.3-a.i' as Pergunta, count(referencia) AS Resposta 
FROM(
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede <> 'PT')
  union all
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade <> 'PT')
)

union all

select '3.6.3.3-a.ii' as Pergunta, sum(montante_eur) AS Resposta 
FROM(
  select referencia, montante_eur
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede <> 'PT')
  union all
  select referencia, montante_eur 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade <> 'PT')
)

union all

select '3.6.3.3-a.iii' as Pergunta, count( distinct customer_id_final) AS Resposta 
FROM(
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede <> 'PT')
  union all
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='R' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade <> 'PT')
)

union all 

select '3.6.3.3-b.i' as Pergunta, count(referencia) AS Resposta 
FROM(
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede <> 'PT')
  union all
  select REFERENCIA 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade <> 'PT')
)

union all

select '3.6.3.3-b.ii' as Pergunta, sum(montante_eur) AS Resposta 
FROM(
  select referencia, montante_eur
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede <> 'PT')
  union all
  select referencia, montante_eur 
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade <> 'PT')
)

union all

select '3.6.3.3-b.iii' as Pergunta, count( distinct customer_id_final) AS Resposta 
FROM(
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'J' and Sede <> 'PT')
  union all
  select referencia, montante_eur, customer_id_final
  from production.workbench_fcc.rpb25_transf_fundos 
  where direcao='E' and customer_id_final in (select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos where tipo_cliente = 'F' and centro_inter_colec_s_person_juridica='S' and Nacionalidade <> 'PT')
)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.6.4 Informação sobre clientes com a qualidade de “PEP” 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **3.6.4.1 Clientes com a qualidade de “PEP” que representem o Estado Português:**
-- MAGIC "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-Beneficiários das operações. [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência: 
-- MAGIC i. Número total; [Resposta: campo numérico]"							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC
-- MAGIC 		
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------

select '3.6.4.1-a.i' as Pergunta, count(referencia)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null
union all

 select '3.6.4.1-a.ii' as Pergunta, sum(montante_eur)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null

union all
 select '3.6.4.1-a.iii' as Pergunta, count(distinct trx.customer_id_final)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null

union all
 select '3.6.4.1-b.i' as Pergunta, count(referencia)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='E' and peps_id.customer_id_final is not null
union all

 select '3.6.4.1-b.ii' as Pergunta, sum(montante_eur)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='E' and peps_id.customer_id_final is not null

union all
 select '3.6.4.1-b.iii' as Pergunta, count(distinct trx.customer_id_final)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='E' and peps_id.customer_id_final is not null





-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.6.4.2 Clientes com a qualidade de “PEP” que representem país ou jurisdição estrangeira:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Indicação, para cada um dos 10 países ou jurisdições de representação mais relevantes identificados na questão 2.5.2. b) da Parte 2: 	  
-- MAGIC "a) Transferências de fundos recebidas no período de referência com origem no país ou jurisdição identificada: 
-- MAGIC i. Número total;  
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos;  
-- MAGIC iii. Número de clientes-beneficiários das operações;							
-- MAGIC
-- MAGIC "b) Transferências de fundos enviadas no período de referência no período de referência com destino ao país ou jurisdição identificada:  
-- MAGIC i. Número total;"							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados;							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta em linhas, com cinco colunas:  
-- MAGIC  1) escolha do país ou jurisdição previamente identificado;  
-- MAGIC   2) n.º de transferências de fundos recebidas  
-- MAGIC   3) montante agregado, em euros, dos fundos recebidos;  
-- MAGIC    4) n.º de clientesbeneficiários das operações;  
-- MAGIC     5) n.º de transferências de fundos enviadas;  
-- MAGIC      6) montante agregado, em euros, dos fundos enviados;  
-- MAGIC       7) n.º de clientesordenantes das operações;]							

-- COMMAND ----------

select '3.6.4.2-a.i' as Pergunta,Nacionalidade, count(referencia)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final,b.Nacionalidade from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.Nacionalidade IN ('AO','BR','GB','ES','GW','IN','ST','UA','IT','US') and  b.party_id is not null
) peps_id
on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null

group BY Pergunta, peps_id.Nacionalidade order by  count(referencia) desc



-- COMMAND ----------

select '3.6.4.2-a.ii' as Pergunta,Nacionalidade, SUM(montante_eur),count(referencia)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final,b.Nacionalidade from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.Nacionalidade IN ('AO','BR','GB','ES','GW','IN','ST','UA','IT','US') and  b.party_id is not null
) peps_id
on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null

group BY Pergunta, peps_id.Nacionalidade order by  count(referencia) desc

-- COMMAND ----------

select '3.6.4.2-a.iii' as Pergunta,Nacionalidade,count(distinct trx.customer_id_final)  from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final,b.Nacionalidade from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.Nacionalidade IN ('AO','BR','GB','ES','GW','IN','ST','UA','IT','US') and  b.party_id is not null
) peps_id
on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null

group BY Pergunta, peps_id.Nacionalidade order by  count(referencia) desc

-- COMMAND ----------

select '3.6.4.2-a.iiii' as Pergunta,Nacionalidade, SUM(montante_eur),count(referencia),  count(distinct trx.customer_id_final) from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final,b.Nacionalidade from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.Nacionalidade IN ('AO','BR','GB','ES','GW','IN','ST','UA','IT','US') and  b.party_id is not null
) peps_id
on trx.customer_id_final=peps_id.customer_id_final
 where direcao='E' and peps_id.customer_id_final is not null

group BY Pergunta, peps_id.Nacionalidade order by  count(referencia) desc

-- COMMAND ----------

select '3.6.4.2-a.i' as Pergunta, count(referencia)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='Representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null
union all

 select '3.6.4.2-a.ii' as Pergunta, sum(montante_eur)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='Representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null

union all
 select '3.6.4.2-a.iii' as Pergunta, count(distinct trx.customer_id_final)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='Representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='R' and peps_id.customer_id_final is not null

union all
 select '3.6.4.2-b.i' as Pergunta, count(referencia)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='Representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='E' and peps_id.customer_id_final is not null
union all

 select '3.6.4.2-b.ii' as Pergunta, sum(montante_eur)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='Representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='E' and peps_id.customer_id_final is not null

union all
 select '3.6.4.2-b.iii' as Pergunta, count(distinct trx.customer_id_final)  Resposta from production.workbench_fcc.rpb25_transf_fundos trx
left join
(select a.party_id,a.customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos a 
left join  production.workbench_fcc.rpb_25_universo_peps_2025 b 
on a.party_id=b.party_id
where b.`Classificação_ChatGPT`='Representam o estado português' 
) peps_id

on trx.customer_id_final=peps_id.customer_id_final
 where direcao='E' and peps_id.customer_id_final is not null





-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.6.5 Informação sobre operações associadas a certas categorias de clientes 3.6.5.1. Clientes com um “elevado património líquido”:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6.5 Informação sobre operações associadas a certas categorias de clientes							
-- MAGIC 3.6.5.1. Clientes com um “elevado património líquido”:  
-- MAGIC "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC 												
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência: 
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------

select '3.6.5 -a.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where valor_patrimonio_liquido >= 1000000
) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all

select '3.6.5.-a.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos
a left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where valor_patrimonio_liquido >= 1000000
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all

select '3.6.5.-a.iii' as Pergunta, count(distinct a.customer_id_final) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where valor_patrimonio_liquido >=1000000
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all 

select '3.6.5. -b.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where valor_patrimonio_liquido >= 1000000
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

union all

select '3.6.5.-b.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos
a left join
    (
      select  customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where valor_patrimonio_liquido >= 1000000
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

union all

select '3.6.5.-b.iii' as Pergunta, count(distinct a.customer_id_final) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where valor_patrimonio_liquido >= 1000000
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####3.6.5.2. Clientes “organizações sem fins lucrativos”:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6.5.2. Clientes “organizações sem fins lucrativos”:  
-- MAGIC "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência: 
-- MAGIC  i. Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------

select '3.6.5.2-a.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where org_s_fins_lucrativos='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all

select '3.6.5.2-a.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos
a left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where org_s_fins_lucrativos='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all

select '3.6.5.2.-a.iii' as Pergunta, count(distinct a.customer_id_final) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where org_s_fins_lucrativos='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all 

select '3.6.5.2. -b.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where org_s_fins_lucrativos='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

union all

select '3.6.5.2.-b.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos
a left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where org_s_fins_lucrativos='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

union all

select '3.6.5.2.-b.iii' as Pergunta, count(distinct a.customer_id_final) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where org_s_fins_lucrativos='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.6.5.3. Clientes detentores de “ARI”:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6.5.3. Clientes detentores de “ARI”:				  
-- MAGIC   "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC   i. Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência:
-- MAGIC  i. Número total; [Resposta: campo numérico]
-- MAGIC "							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC

-- COMMAND ----------

select '3.6.5.3-a.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where where ARI='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all

select '3.6.5.3-a.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos
a left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where ARI='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all

select '3.6.5.3.-a.iii' as Pergunta, count(distinct a.customer_id_final) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where ARI='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all 

select '3.6.5.3. -b.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where ARI='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

union all

select '3.6.5.3.-b.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos
a left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where ARI='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

union all

select '3.6.5.3.-b.iii' as Pergunta, count(distinct a.customer_id_final) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where ARI='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6.5.4. Clientes que prossigam atividades em áreas de negócio de risco mais elevado  
-- MAGIC "a) Transferências de fundos recebidas no período de referência, por área de negócio de risco mais elevado identificada na questão 2.6.5 da Parte 2:  
-- MAGIC i. Número total;  
-- MAGIC  ii. Montante agregado, em euros, dos fundos recebidos;  
-- MAGIC  iii. Número de clientes-beneficiários das operações;  
-- MAGIC  
-- MAGIC  "b) Transferências de fundos enviadas no período de referência, por área de negócio de risco mais elevado identificada na questão 2.6.5 da Parte 2: 
-- MAGIC  i. Número total;						
-- MAGIC Área de Negócio	Nº Transferência						
-- MAGIC 					
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados;  
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta em linhas, com cinco colunas: 1) área de negócio de risco mais elevado previamente identificada; 2) n.º de transferências de fundos recebidas; 3) montante agregado, em euros, dos fundos recebidos; 4) n.º de clientesbeneficiários das operações; 5) n.º de transferências de fundos enviadas; 6) montante agregado, em euros, dos fundos enviados; 7) n.º de clientesordenantes das operações]							
-- MAGIC 	es	
-- MAGIC

-- COMMAND ----------

select '3.6.5.4-a.i' as Pergunta,activ_area_risco_elevado_grupo, count(REFERENCIA) from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final,activ_area_risco_elevado_grupo from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where where activ_area_risco_elevado='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null
group by activ_area_risco_elevado_grupo



-- COMMAND ----------

select '3.6.5.4-a.ii' as Pergunta,activ_area_risco_elevado_grupo, sum(montante_eur) from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final,activ_area_risco_elevado_grupo from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where activ_area_risco_elevado='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null
group by activ_area_risco_elevado_grupo

-- COMMAND ----------

select '3.6.5.4-a.iii' as Pergunta,activ_area_risco_elevado_grupo, count(distinct b.customer_id_final) 
from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final,activ_area_risco_elevado_grupo from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where where activ_area_risco_elevado='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null
group by activ_area_risco_elevado_grupo

-- COMMAND ----------

select '3.6.5.4-b.ii' as Pergunta,activ_area_risco_elevado_grupo, count(referencia) 
from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final,activ_area_risco_elevado_grupo from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where where activ_area_risco_elevado='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null
group by activ_area_risco_elevado_grupo


-- COMMAND ----------

select '3.6.5.4-b.ii' as Pergunta,activ_area_risco_elevado_grupo, sum(montante_eur) 
from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final,activ_area_risco_elevado_grupo from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where where activ_area_risco_elevado='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null
group by activ_area_risco_elevado_grupo

-- COMMAND ----------


select '3.6.5.4-b.iii' as Pergunta,activ_area_risco_elevado_grupo, count(distinct b.customer_id_final) 
from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select customer_id_final,activ_area_risco_elevado_grupo from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where where activ_area_risco_elevado='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null
group by activ_area_risco_elevado_grupo

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 3.6.5.5. Clientes com uma estrutura de propriedade complexa  
-- MAGIC "a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]  
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; [Resposta: campo numérico]  
-- MAGIC iii. Número de clientes-beneficiários das operações; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC "b) Transferências de fundos enviadas no período de referência:  
-- MAGIC i. Número total; [Resposta: campo numérico]
-- MAGIC 							
-- MAGIC 							
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados; [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC iii. Número de clientes-ordenantes das operações. [Resposta: campo numérico]							
-- MAGIC 							
-- MAGIC
-- MAGIC

-- COMMAND ----------

select '3.6.5.5-a.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a  left join 
(
    select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
    where where estrutura_complexa='S'
) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all

select '3.6.5.5-a.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos
a left join
    (
      select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where estrutura_complexa='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all

select '3.6.5.5.-a.iii' as Pergunta, count(distinct a.customer_id_final) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where estrutura_complexa='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='R' and b.customer_id_final is not null

union all 

select '3.6.5.5. -b.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where estrutura_complexa='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

union all

select '3.6.5.5.-b.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos
a left join
    (
      select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where estrutura_complexa='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null

union all

select '3.6.5.5.-b.iii' as Pergunta, count(distinct a.customer_id_final) as Resposta from production.workbench_fcc.rpb25_transf_fundos a
 left join
    (
      select distinct customer_id_final from production.workbench_fcc.rpb25_universo_parties_trf_fundos 
      where estrutura_complexa='S'
    ) b
on a.customer_id_final=b.customer_id_final
where direcao='E' and b.customer_id_final is not null