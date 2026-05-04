-- Databricks notebook source
-- MAGIC %md
-- MAGIC ##### 5.1. Jurisdições de risco elevado, identificadas pela União Europeia ou pelo GAFI como tendo deficiências estratégicas em matéria de prevenção e combate ao BC, ao FT e ao financiamento da proliferação Indicação, para cada jurisdição, da seguinte informação: 	

-- COMMAND ----------

-- MAGIC %md			
-- MAGIC a) Transferências de fundos recebidas no período de referência: 
-- MAGIC i. Número total; 	
-- MAGIC 				
-- MAGIC a) Transferências de fundos recebidas no período de referência: 
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; 				
-- MAGIC 				
-- MAGIC b) Transferências de fundos enviadas no período de referência:  
-- MAGIC i. Número total; 				
-- MAGIC 				
-- MAGIC 				
-- MAGIC

-- COMMAND ----------

select '5.1 -a.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos
where direcao='R' and   
pais_ord in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG')

union all

select '5.1-a.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' and   
pais_ord in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG') 

union all 

select '5.1-b.i' as Pergunta, count(referencia) as Resposta from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' and   
pais_ben in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG') 



-- COMMAND ----------

-- MAGIC %md
-- MAGIC b) Transferências de fundos enviadas no período de referência:  
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados. [Resposta em linhas, com cinco colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º
-- MAGIC de transferências recebidas; 3) montante agregado, em euros, dos fundos recebidos; 4) n.º de transferências enviadas; 5) montante agregado, em euros, dos fundos enviados]

-- COMMAND ----------

select '5.1-b.ii' as Pergunta,direcao, pais_ord, count(REFERENCIA), sum(montante_eur) from production.workbench_fcc.rpb25_transf_fundos ---a 
--inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on trim(a.customer_id_final)=trim(b.customer_id_final)
where   trim(pais_ord) in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG') 
 and direcao='R'  group by direcao, pais_ord  order by count(REFERENCIA) desc

-- COMMAND ----------

select '5.1-b.ii' as Pergunta,direcao, pais_ben, count(REFERENCIA), sum(montante_eur)  from production.workbench_fcc.rpb25_transf_fundos 
--a 
----inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where 1=1 and  (pais_ben in ('AF','ZA','BB','BF','CM','AE','PH','GI','JM','MM','MZ','NG','PA','CD','SN','SY','TZ','TT','UG','VU','VN','KP','HT','IR','LB','ML','SS','TR','VE','DZ','AO','BG','CI','HR','KE','MC','NA','YE','LA','NP','BO','VG') 
 and direcao='E' ) group by direcao, pais_ben order by count(REFERENCIA) desc 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 5.2. Jurisdições sujeitas a medidas restritivas adotadas pelo Conselho de Segurança das Nações Unidas ou pela União Europeia Indicação, para cada jurisdição, da seguinte informação: 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 5.2. Jurisdições sujeitas a medidas restritivas adotadas pelo Conselho de Segurança das Nações Unidas ou pela União Europeia Indicação, para cada jurisdição, da seguinte informação:  
-- MAGIC a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; 				
-- MAGIC
-- MAGIC a) Transferências de fundos recebidas no período de referência:  
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos;				
-- MAGIC 				
-- MAGIC b) Transferências de fundos enviadas no período de referência:  
-- MAGIC i.Número total;				
-- MAGIC 				
-- MAGIC b) Transferências de fundos enviadas no período de referência:  
-- MAGIC ii.Montante agregado, em euros, dos fundos enviados. 
-- MAGIC [Resposta em linhas, com cinco colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de transferências recebidas; 3) montante agregado, em euros, dos fundos recebidos; 4) n.º de transferências enviadas; 5) montante				
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC

-- COMMAND ----------

select '5.2.-a.i' as Pergunta, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' and   
pais_ord in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US') 
union all
select '5.2.-a.ii' as Pergunta, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos 
where direcao='R' and   
pais_ord in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US') 

union all 

select '5.2.-b.i' as Pergunta, count(referencia) as Resposta from production.workbench_fcc.rpb25_transf_fundos 
where direcao='E' and   
pais_ben in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US') 

-- COMMAND ----------

select '5.2-b.ii' as Pergunta,direcao, pais_ben, count(REFERENCIA), sum(montante_eur) , count(distinct customer_id_final) from production.workbench_fcc.rpb25_transf_fundos 
where 1=1 and  (pais_ben in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US') 
 and direcao='E' ) group by direcao, pais_ben order by count(REFERENCIA) desc 

-- COMMAND ----------

select '5.2-b.ii' as Pergunta,direcao, pais_ord, count(REFERENCIA), sum(montante_eur) , count(distinct customer_id_final) from production.workbench_fcc.rpb25_transf_fundos 

where 1=1 and  (pais_ord in ('AF','MM','CD','SY','BY','BA','BI','CN','KP','GT','GN','GW','HT','IR','LB','LY','ML','MD','NE','RU','SS','TR','UA','VE','YE','IQ','ME','NI','CF','SO','SD','RS','TN','ZW','US') 
 and direcao='R' ) group by direcao, pais_ord order by count(REFERENCIA) desc 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 5.3. Informação relativa a clientes com residência permanente ou sede no estrangeiro				
-- MAGIC ##### 5.3.1 Relativamente a clientes “pessoas singulares” com residência permanente no estrangeiro, indicação, para cada um dos 10 países ou jurisdições de residência permanente mais relevantes identificados na questão 2.2.4. d) da Parte 2: 

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC a) Transferências de fundos recebidas no período de referência:  
-- MAGIC i. Número total; 				
-- MAGIC 		
-- MAGIC
-- MAGIC a) Transferências de fundos recebidas no período de referência: 
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; 				
-- MAGIC 		
-- MAGIC
-- MAGIC  				
-- MAGIC b) Transferências de fundos enviadas no período de referência: 
-- MAGIC i. Número total; 
-- MAGIC
-- MAGIC  				
-- MAGIC b) Transferências de fundos enviadas no período de referência: 
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados.
-- MAGIC [Resposta em linhas, com cinco colunas: 1) escolha o país ou jurisdição previamente identificado; 2) n.º de transferências recebidas; 3) montante agregado, em euros, dos fundos recebidos; 4) n.º de transferências enviadas; 5) montante agregado, em euros, dos fundos enviados]				
-- MAGIC 	
-- MAGIC 5.3.2 Relativamente a clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica” com sede no estrangeiro, indicação, para cada um dos 10 países ou jurisdições de local da sede mais relevantes identificados na questão 2.3.2. d) da Parte 2:   
-- MAGIC a) Transferências de fundos recebidas no período de referência: 
-- MAGIC i. Número total; 				
-- MAGIC 		
-- MAGIC
-- MAGIC a) Transferências de fundos recebidas no período de referência: 
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; 				
-- MAGIC 		
-- MAGIC
-- MAGIC b) Transferências de fundos enviadas no período de referência: 
-- MAGIC i. Número total; [Resposta em linhas, com cinco colunas: 1) escolha o país ou jurisdição previamente identificado; 2) n.º de transferências recebidas; 3) montante agregado, em euros, dos fundos recebidos; 4) n.º de transferências enviadas; 5) montante agregado, em euros, dos fundos enviados]				
-- MAGIC 		
-- MAGIC
-- MAGIC b) Transferências de fundos enviadas no período de referência: 
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados.     [Resposta em linhas, com cinco colunas: 1) escolha o país ou jurisdição previamente identificado; 2) n.º de transferências recebidas; 3) montante agregado, em euros, dos fundos recebidos; 4) n.º de transferências enviadas; 5) montante agregado, em euros, dos fundos enviados]				
-- MAGIC

-- COMMAND ----------

drop table if exists production.workbench_fcc.rpb_25_universo_peps_2025

-- COMMAND ----------

select '5.3 -a.i' as Pergunta,pais_ord, count(REFERENCIA) as Resposta from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='R' and Tipo_Cliente = 'F' and centro_inter_colec_s_person_juridica='N' and
a.pais_ord in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES') group by Pergunta, pais_ord order by count(REFERENCIA) desc 



-- COMMAND ----------

select '5.3 -a.ii' as Pergunta,pais_ord, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='R' and Tipo_Cliente = 'F' and centro_inter_colec_s_person_juridica='N' and
a.pais_ord in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES') group by Pergunta, pais_ord order by SUM(montante_eur) desc 
 

-- COMMAND ----------

select '5.3 -B.i' as Pergunta,pais_ben, count(referencia) as Resposta from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='E' and Tipo_Cliente = 'F' and centro_inter_colec_s_person_juridica='N' and
a.pais_ben in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES') group by Pergunta, pais_ben order by count(referencia) desc 

-- COMMAND ----------

select '5.3 -B.ii' as Pergunta,pais_ben, sum(montante_eur) as Resposta from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='E' and Tipo_Cliente = 'F' and centro_inter_colec_s_person_juridica='N' and
a.pais_ben in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES') group by Pergunta, pais_ben order by sum(montante_eur) desc 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 5.3.2 Relativamente a clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica” com sede no estrangeiro, indicação, para cada um dos 10 países ou jurisdições de local da sede mais relevantes identificados na questão 2.3.2. d) da Parte 2: 

-- COMMAND ----------

-- MAGIC %md				
-- MAGIC "a) Transferências de fundos recebidas no período de referência: 
-- MAGIC i. Número total; "				
-- MAGIC 				
-- MAGIC "a) Transferências de fundos recebidas no período de referência: 
-- MAGIC ii. Montante agregado, em euros, dos fundos recebidos; "				
-- MAGIC 				
-- MAGIC "b) Transferências de fundos enviadas no período de referência:  
-- MAGIC i. Número total; [Resposta em linhas, com cinco colunas: 1) escolha o país ou jurisdição previamente identificado; 2) n.º de transferências recebidas; 3) montante agregado, em euros, dos fundos recebidos; 4) n.º de transferências enviadas; 5) montante agregado, em euros, dos fundos enviados]"				
-- MAGIC
-- MAGIC "b) Transferências de fundos enviadas no período de referência:  
-- MAGIC ii. Montante agregado, em euros, dos fundos enviados.   [Resposta em linhas, com cinco colunas: 1) escolha o país ou jurisdição previamente identificado; 2) n.º de transferências recebidas; 3) montante agregado, em euros, dos fundos recebidos; 4) n.º de transferências enviadas; 5) montante agregado, em euros, dos fundos enviados]"				
-- MAGIC

-- COMMAND ----------

select '5.3.2.a.i' Pergunta, pais_ord, count(referencia)
from (
select pais_ord, REFERENCIA  from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='R' and Tipo_Cliente = 'J' and
a.pais_ord in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES')

union all 

select pais_ord, REFERENCIA  from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='R' and Tipo_Cliente = 'F' and centro_inter_colec_s_person_juridica='S'
 and
a.pais_ord in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES') )

 group by Pergunta, pais_ord order by count(REFERENCIA) desc 





-- COMMAND ----------

select '5.3.2.a.ii' Pergunta, pais_ord, count(referencia),sum(montante_eur)
from (
select pais_ord, REFERENCIA,montante_eur  from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='R' and Tipo_Cliente = 'J' and
a.pais_ord in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES')

union all 

select pais_ord, REFERENCIA,montante_eur  from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='R' and Tipo_Cliente = 'F' and centro_inter_colec_s_person_juridica='S'
 and
a.pais_ord in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES') )

 group by Pergunta, pais_ord order by count(REFERENCIA) desc 



-- COMMAND ----------

select '5.3.2.b.i' Pergunta, pais_ben, count(referencia),sum(montante_eur)
from (
select pais_ben, REFERENCIA,montante_eur  from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='E' and Tipo_Cliente = 'J' and
a.pais_ben in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES')

union all 

select pais_ben, REFERENCIA,montante_eur  from production.workbench_fcc.rpb25_transf_fundos a 
inner join production.workbench_fcc.rpb25_universo_parties_trf_fundos b  on a.customer_id_final=b.customer_id_final
where direcao='E' and Tipo_Cliente = 'F' and centro_inter_colec_s_person_juridica='S'
 and
a.pais_ben in ('FR','GB','CH','US','VE','DE','CA','ZA','BR','ES') )

 group by Pergunta, pais_ben order by count(REFERENCIA) desc 

-- COMMAND ----------

select *
from workbench_fcc.rpb25_transf_fundos
where 1=1
--and (pais_ben = 'VE' or pais_ord = 'VE')
and (left(iban_ordenante, 2) like 'VE' or substring(bic_ordenante, 5, 2) like 'VE' or left(iban_destino, 2) like 'VE' or substring(bic_destino, 5, 2) like 'VE')
limit 100