-- Databricks notebook source
-- MAGIC %md
-- MAGIC #### 2.1 Informação geral à data do termo do período de referência do RPB (31 de dezembro)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.1 Informação geral à data do termo do período de referência do RPB (31 de dezembro)	
-- MAGIC
-- MAGIC a) Número total de clientes; [Resposta: campo numérico]	  
-- MAGIC
-- MAGIC
-- MAGIC b) Número de clientes “pessoas singulares”; [Resposta: campo numérico]	  
-- MAGIC
-- MAGIC    
-- MAGIC
-- MAGIC c) Número de clientes “pessoas coletivas”; [Resposta: campo numérico]	  
-- MAGIC  	  
-- MAGIC
-- MAGIC d) Número de clientes “centros de interesses coletivos sem personalidade jurídica”. [Resposta: campo numérico]	
-- MAGIC 	  
-- MAGIC
-- MAGIC
-- MAGIC  	  
-- MAGIC
-- MAGIC
-- MAGIC

-- COMMAND ----------

-- DBTITLE 1,Cell 2
select '2.1.a' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties
where Tipo_Cliente <>'BEF' 

union all

select '2.1.b' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='F' and centro_inter_colec_s_person_juridica='N'

union all

select '2.1.c' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties
where Tipo_Cliente ='J' and centro_inter_colec_s_person_juridica='N'

union all

select '2.1.d' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where centro_inter_colec_s_person_juridica='S' and Tipo_Cliente <>'BEF' 

union all

select '2.2.1' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='F' 
and Nacionalidade='PT' 
and centro_inter_colec_s_person_juridica='N'

union all

select '2.2.2-a' as Pergunta, count(distinct party_id) as Resposta
from production.workbench_fcc.rpb25_universo_parties
where Tipo_Cliente ='F' 
and Nacionalidade in ('BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE') 
and centro_inter_colec_s_person_juridica='N'

union all

select '2.2.2-b' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties
where Tipo_Cliente ='F' 
and Nacionalidade not in ('PT','BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE') 
and centro_inter_colec_s_person_juridica='N'


-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.2.2.c) Identificação dos 10 países ou jurisdições de nacionalidade mais relevantes, com indicação do número de clientes por país ou jurisdição.
-- MAGIC [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de clientes nacionais desse país ou jurisdição]"	

-- COMMAND ----------

select Nacionalidade, count(distinct party_id) as totalclientes 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente = 'F' 
and Nacionalidade <> 'PT'
and centro_inter_colec_s_person_juridica='N'
group by Nacionalidade 
order by count(party_id) desc 
limit 10
 


-- COMMAND ----------

-- MAGIC %md
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 2.2 Pessoas Singulares demografia 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.2.3 Número de clientes “pessoas singulares” com residência permanente em Portugal. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC 2.2.4 Clientes “pessoas singulares” com residência permanente no estrangeiro:	
-- MAGIC a)Número total de clientes; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) Número de clientes com residência permanente em Estado membro da União Europeia; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC c) Número de clientes com residência permanente em país terceiro; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC d) Identificação dos 10 países ou jurisdições de residência permanente mais relevantes, com indicação do número de clientes por país ou jurisdição; [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de clientes com residência permanente nesse país ou jurisdição]	
-- MAGIC

-- COMMAND ----------

select '2.2.3' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='F' 
and Residencia_Principal='PT'
and centro_inter_colec_s_person_juridica='N'

union all

select '2.2.4-a' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='F' 
and Residencia_Principal<>'PT'
and centro_inter_colec_s_person_juridica='N'

union all

select '2.2.4-b' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='F' 
and Residencia_Principal in ('BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')
and centro_inter_colec_s_person_juridica='N'

union all

select '2.2.4-c' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties
where Tipo_Cliente ='F' 
and Residencia_Principal not in ('PT','BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')
and centro_inter_colec_s_person_juridica='N'

-- COMMAND ----------

select * from production.workbench_fcc.rpb25_universo_parties
where Tipo_Cliente = 'F'  and centro_inter_colec_s_person_juridica='N' and Residencia_Principal is null
-- cliente sem morada porque abriu conta no dia 31/12, no entanto a residência é PT -> acrescentado diretamente no excel na 2.2.3 - 2 514 109

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.2.4-d) Identificação dos 10 países ou jurisdições de residência permanente mais relevantes, com indicação do número de clientes por país ou jurisdição; [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de clientes com residência permanente nesse país ou jurisdição]

-- COMMAND ----------

select Residencia_Principal, count(distinct party_id) as totalclientes 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='F' 
and Residencia_Principal<>'PT'
and centro_inter_colec_s_person_juridica='N'
group by Residencia_Principal 
order by count(party_id) desc 
limit 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 2.3 Informação sobre clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica” à data do termo do período de referência do RPB (31 de dezembro)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC  2.3.1. Número de Clientes "pessoas coletivas" e "centros de interesses coletivos sem presonalidade jurídica"  com sede em Portugal	
-- MAGIC 	
-- MAGIC 2.3.2. Número de clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica” com sede no estrangeiro:	
-- MAGIC
-- MAGIC a) Número total de clientes; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) Número de clientes com sede em Estado membro da União Europeia; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC c) Número de clientes com sede em país terceiro; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC d) Identificação dos 10 países ou jurisdições de local da sede mais relevantes, com indicação do número de clientes por país ou jurisdição. [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de clientes com sede nesse país ou jurisdição]	
-- MAGIC

-- COMMAND ----------

select '2.3.1' as Pergunta, count(distinct party_id) as Resposta 
from(
  select party_id  
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente = 'J' and Sede = 'PT'
  union all
  select party_id  
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente ='F' and Nacionalidade = 'PT' and centro_inter_colec_s_person_juridica='S'
)

union all

select '2.3.2-a' as Pergunta, count(distinct party_id) as Resposta 
from(
  select distinct party_id  
  from production.workbench_fcc.rpb25_universo_parties
  where Tipo_Cliente = 'J' and Sede <> 'PT'
  union all
  select distinct party_id  
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente = 'F' AND Nacionalidade <> 'PT' and centro_inter_colec_s_person_juridica='S' 
)

union all

select '2.3.2-b' as Pergunta, count(distinct party_id) as Resposta 
from(
  select distinct party_id 
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente ='J' 
  and Sede in ('BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')
  union all 
  select distinct party_id 
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente ='F' 
  and Nacionalidade in ('BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')
  and centro_inter_colec_s_person_juridica='S' 
)

union all

select '2.3.2-c' as Pergunta, count(distinct party_id) as Resposta 
from(
  select distinct party_id 
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente ='J' 
  and Sede not in ('PT','BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')
  union all 
  select distinct party_id 
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente ='F' 
  and Nacionalidade not in ('PT','BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')
  and centro_inter_colec_s_person_juridica='S' 
)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC d) Identificação dos 10 países ou jurisdições de local da sede mais relevantes, com indicação do número de clientes por país ou jurisdição. [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de clientes com sede nesse país ou jurisdição]

-- COMMAND ----------

select PAIS, count(distinct party_id) Resposta 
from(
  select distinct party_id, Sede AS PAIS 
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente = 'J' 
  and Sede <> 'PT'
  union all 
  select distinct party_id, Nacionalidade AS PAIS 
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente = 'F' 
  and Nacionalidade <> 'PT' 
  and centro_inter_colec_s_person_juridica= 'S' 
)
group by PAIS 
order by count(party_id) desc 
limit 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2.4 BENEFICIÁRIOS EFETIVOS 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 2.4 -BEFS NACIONALIDADE

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.4. Informação sobre beneficiários efetivos à data do termo do período de referência do RPB (31 de dezembro)	
-- MAGIC
-- MAGIC 2.4.1 Número total de beneficiários efetivos. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC 2.4.2 Número de beneficiários efetivos com nacionalidade portuguesa. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC 2.4.3 Beneficiários efetivos com nacionalidade estrangeira:	
-- MAGIC
-- MAGIC a) Número de beneficiários efetivos com nacionalidade de Estado membro da União Europeia; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) Número de beneficiários efetivos com nacionalidade de país terceiro; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC "c) Identificação dos 10 países ou jurisdições de nacionalidade mais relevantes, com indicação do número de beneficiários efetivos por país ou jurisdição. 
-- MAGIC [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de beneficiários efetivos nacionais desse país ou jurisdição]"	
-- MAGIC

-- COMMAND ----------

select '2.4.1' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='BEF' 

union all

select '2.4.2' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente = 'BEF' AND Nacionalidade = 'PT'

union all

select '2.4.3-a' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='BEF' 
and Nacionalidade in ('BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')

union all

select '2.4.3-b' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='BEF' 
and Nacionalidade not in ('PT','BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')



-- COMMAND ----------

-- MAGIC %md
-- MAGIC "c) Identificação dos 10 países ou jurisdições de nacionalidade mais relevantes, com indicação do número de beneficiários efetivos por país ou jurisdição. [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de beneficiários efetivos nacionais desse país ou jurisdição]"

-- COMMAND ----------

-- '2.4.3-c'
select Nacionalidade, count(distinct party_id) as Resposta 
from(
  select distinct party_id,  Nacionalidade 
  from production.workbench_fcc.rpb25_universo_parties 
  where Tipo_Cliente ='BEF' and Nacionalidade not in ('PT')
)
group by Nacionalidade 
order by count(party_id) desc 
limit 10


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 2.4  BEFS - RESIDÊNCIA 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.4.4 Número de beneficiários efetivos com residência permanente em Portugal. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC 2.4.5 Beneficiários efetivos com residência permanente no estrangeiro:	
-- MAGIC a) Número de beneficiários efetivos com residência permanente em Estado membro da União Europeia; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) Número de beneficiários efetivos com residência permanente em país terceiro; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC "c)	Identificação dos 10 países ou jurisdições de residência permanente mais relevantes, com indicação do número de beneficiários efetivos por país ou jurisdição. 
-- MAGIC [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição de uma lista pré-definida; 2) n.º de beneficiários efetivos com residência permanente nesse país ou jurisdição]"	
-- MAGIC

-- COMMAND ----------


select '2.4.4' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties
where Tipo_Cliente = 'BEF' and Residencia_Principal = 'PT'

union all

select '2.4.5-a' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente = 'BEF' 
and Residencia_Principal in ('BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')

union all

select '2.4.5-b' as Pergunta, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente = 'BEF' 
and Residencia_Principal not in ('PT','BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC "c) Identificação dos 10 países ou jurisdições de residência permanente mais relevantes, com indicação do número de beneficiários efetivos por país ou jurisdição. [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição de uma lista pré-definida; 2) n.º de beneficiários efetivos com residência permanente nesse país ou jurisdição]"

-- COMMAND ----------

--'2.4.5-c'
select Residencia_Principal, count(distinct party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente ='BEF' AND Residencia_Principal not in ('PT') 
group by Residencia_Principal 
order by count(distinct party_id) desc
limit 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 2.5 Clientes e BEFs que são PEPs - PESSOAS POLITICAMENTE EXPOSTAS

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.5 Informação sobre clientes e beneficiários efetivos com a qualidade de “Pessoa politicamente exposta” (“PEP”) ou outras qualidades relevantes à data do termo do período de referência do RPB (31 de dezembro)  
-- MAGIC 2.5.1 Que representem o Estado Português  
-- MAGIC
-- MAGIC a) Número total de clientes com a qualidade de “PEP”. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) Número total de beneficiários efetivos com a qualidade de “PEP”. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC 2.5.2 Que representem país ou jurisdição estrangeira ou instituição/organização internacional  
-- MAGIC
-- MAGIC a) Número total de clientes com a qualidade de “PEP” que representem país ou jurisdição estrangeira; [Resposta: campo numérico];	
-- MAGIC 	
-- MAGIC "b)	Identificação dos 10 países ou jurisdições de representação mais relevantes, com indica-ção do número de clientes com a qualidade de “PEP” que representem esse país ou jurisdi-ção; 
-- MAGIC [Resposta em linhas, com duas colunas: 1) escolha do país ou jurisdição a partir de uma lista pré-definida; 2) n.º de clientes com qualidade de “PEP” que representem esse país ou jurisdição]"	
-- MAGIC Pais	Nº Clientes
-- MAGIC 	
-- MAGIC c) Número total de clientes com a qualidade de “PEP” que representem instituição/organização internacional; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC d) Número total de beneficiários efetivos com a qualidade de “PEP”. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC
-- MAGIC

-- COMMAND ----------

select '2.5.1-a' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where b.iclipep = 'S' 
and Tipo_Cliente <> 'BEF'
and peps.`Classificação_ChatGPT` = 'representam o estado português'

union all 

select '2.5.1-b' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where Tipo_Cliente = 'BEF'
and b.iclipep = 'S' 
AND peps.`Classificação_ChatGPT` = 'representam o estado português'

union all 
 
select '2.5.2-a' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where peps.`Classificação_ChatGPT` <> 'representam o estado português' 
and b.iclipep = 'S' 
and Tipo_Cliente <> 'BEF'

union all 
 
select '2.5.2-c' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where  peps.`Classificação_ChatGPT` = 'instituição/organização internacional'
and b.iclipep = 'S' 
and Tipo_Cliente <> 'BEF'

union all

select '2.5.2-d' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where  peps.`Classificação_ChatGPT` <> 'representam o estado português' 
and b.iclipep = 'S' 
and Tipo_Cliente = 'BEF'

-- COMMAND ----------

--'2.5.2-b'
select b.Nacionalidade, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where  peps.`Classificação_ChatGPT`<>'representam o estado português' 
and b.Nacionalidade <>'PT' 
and b.iclipep = 'S' 
and Tipo_Cliente <> 'BEF'
group by b.Nacionalidade 
order by resposta desc 
limit 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **2.5.3** Relativamente ao período de referência, indicação:  
-- MAGIC **a)** Do número de relações de negócio estabelecidas com clientes com a qualidade de “PEP”; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC **b)** Percentagem que o número indicado em a) representa face ao total de relações de negócio estabelecidas no mesmo período. [Resposta: campo numérico]	

-- COMMAND ----------

SELECT*FROM  production.workbench_fcc.rpb25_universo_dever_id_dil

-- COMMAND ----------

select * from rpb25_universo_parties_peri_ref

-- COMMAND ----------

SELECT count(distinct a.party_id) FROM production.workbench_fcc.rpb25_universo_dever_id_dil a 
LEFT JOIN production.workbench_fcc.rpb_25_universo_peps_2025 peps on a.party_id=peps.party_id 
where peps.cargo_pep='PEP'  
and a.Tipo_Cliente <> 'BEF'
and nova_rel='S'

-- COMMAND ----------

SELECT count(distinct party_id) as total_rel 
FROM production.workbench_fcc.rpb25_universo_dever_id_dil 
WHERE nova_rel='S'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 	
-- MAGIC 2.5.4 Identificação da percentagem de clientes que, face ao total de clientes, detêm a qualidade de:  
-- MAGIC a) “PEP”; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) “Membro próximo da família”; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC c) “Pessoa reconhecida como estreitamente associada”; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC d) “Titular de outro cargo político ou público”. [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC
-- MAGIC 	
-- MAGIC

-- COMMAND ----------


---a) “PEP”; [Resposta: campo numérico]	

SELECT COUNT(DISTINCT party_id) AS total_peps
FROM production.workbench_fcc.rpb25_universo_parties
WHERE iclipep = 'S' and cargo_pep='PEP' and Tipo_Cliente <> 'BEF'


-- COMMAND ----------

--b) “Membro próximo da família”; [Resposta: campo numérico]

SELECT COUNT(DISTINCT party_id) AS total_membros_proximos_familia
FROM production.workbench_fcc.rpb25_universo_parties 
WHERE iclipep = 'S' and cargo_pep='PROXIMO FAMILIA' and Tipo_Cliente <> 'BEF'


-- COMMAND ----------

--c) “Pessoa reconhecida como estreitamente associada”; [Resposta: campo numérico]	

SELECT COUNT(DISTINCT party_id) AS total_RCA
FROM production.workbench_fcc.rpb25_universo_parties
WHERE  iclipep = 'S' and cargo_pep ='PESSOA RECONH ESTRIT ASSOC' AND Tipo_Cliente <> 'BEF'


-- COMMAND ----------

--d) “Titular de outro cargo político ou público”. [Resposta: campo numérico]

SELECT COUNT(DISTINCT party_id) AS total_TOCPP
FROM production.workbench_fcc.rpb25_universo_parties
WHERE TOCPP='S' AND Tipo_Cliente <> 'BEF'


-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 2.5.5 Identificação da percentagem de beneficiários efetivos que, face ao total de beneficiários efetivos, detêm a qualidade de:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC a) “PEP”; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) “Membro próximo da família”; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC c) “Pessoa reconhecida como estreitamente associada”; [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC d) “Titular de outro cargo político ou público”. [Resposta: campo numérico]	

-- COMMAND ----------

select '2.5.5-a' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where Tipo_Cliente ='BEF'
AND peps.cargo_pep = 'PEP'

union all 

select '2.5.5-b' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where Tipo_Cliente ='BEF'
AND peps.cargo_pep = 'PROXIMO FAMILIA'

union all 

select '2.5.5-c' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where Tipo_Cliente ='BEF'
AND peps.cargo_pep = 'PESSOA RECONH ESTRIT ASSOC'

union all

select '2.5.5-d' as Pergunta, count(distinct b.party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties b
left join production.workbench_fcc.rpb_25_universo_peps_2025 peps on b.party_id=peps.party_id
where Tipo_Cliente ='BEF'
AND TOCPP='S'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2.6 Informações sobre certas categorias de clientes

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.6.1 Clientes com um “elevado património líquido” Número total de clientes com um elevado património líquido à data do termo do período de referência do RPB (31 de dezembro). [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC 2.6.2 Clientes “organizações sem fins lucrativos”	
-- MAGIC a) Número de clientes “organizações sem fins lucrativos” com sede em Portugal líquido à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) Número de clientes “organizações sem fins lucrativos” com sede em Estado membro da União Europeia à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC c) Número de clientes “organizações sem fins lucrativos” com sede em país terceiro à data do termo do período de referência do RPB (31 de dezembro). [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC

-- COMMAND ----------

select '2.6.1' as Pergunta, count(party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where Tipo_Cliente <> 'BEF'
and valor_patrimonio_liquido >= 1000000

union all

select '2.6.2-a' as Pergunta, count(party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where org_s_fins_lucrativos = 'S' and Sede = 'PT'

union all

select '2.6.2-b' as Pergunta, count(party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where org_s_fins_lucrativos = 'S' 
and Sede in ('BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE')

union ALL

select '2.6.2-c' as Pergunta, count(party_id) as Resposta 
from production.workbench_fcc.rpb25_universo_parties 
where org_s_fins_lucrativos = 'S' 
and Sede not in ('PT','BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','RO','SI','SK','FI','SE') 


-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 2.6.3 Clientes com autorização de residência para atividade de investimento em Portugal (“ARI”) ou candidatos a “ARI”:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC a) Número total de clientes detentores de “ARI” à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]	
-- MAGIC 	
-- MAGIC b) Número total de clientes candidatos a “ARI” à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]	- resposta com base no ficheiro do ARI
-- MAGIC 	
-- MAGIC c) Número de clientes que adquiriram “ARI” durante o período de referência; [Resposta: campo numérico]	- resposta 
-- MAGIC N/A  
-- MAGIC d) Número de clientes que se candidataram a “ARI” durante o período de referência. [Resposta: campo numérico]	- resposta com base no ficheiro do ARI
-- MAGIC
-- MAGIC 	
-- MAGIC

-- COMMAND ----------

select '2.6.3 - a' as Pergunta, count(distinct party_id) as Resposta 
from (
  select party_id 
  from production.workbench_fcc.rpb25_universo_parties 
  where ARI='S' and Tipo_Cliente<>'BEF'

  union all 

  select distinct a.party_id 
  from production.workbench_fcc.rpb25_universo_parties a
  left join(
    select distinct b.party_id
    from production.workbench_fcc.listagem_declaracoes_emitidas_visto_gold_ano_2025 a 
    left join production.common_parties_individuals.individual_identity_document b on a.`Nº documento` = b.document_number
    where `Declaração` in ('Nova','Renovação')
  ) b
  on a.party_id = b.party_id
  where ARI='S' and b.party_id is not null
)

-- COMMAND ----------

  select '2.6.3 - b' as Pergunta, count(distinct a.party_id ) as Resposta
  from production.workbench_fcc.rpb25_universo_parties a
  left join(
    select distinct b.party_id
    from production.workbench_fcc.listagem_declaracoes_emitidas_visto_gold_ano_2025 a 
    left join production.common_parties_individuals.individual_identity_document b on a.`Nº documento` = b.document_number
    where `Declaração` in ('Nova','Renovação')
  ) b
  on a.party_id = b.party_id
  where ARI='S' and b.party_id is not null

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.6.4 Clientes que realizaram depósitos em numerário de forma intensiva	
-- MAGIC Número total de clientes que realizaram depósitos em numerário de forma intensiva no período de referência. [Resposta: campo numérico]	
-- MAGIC

-- COMMAND ----------


select count(distinct party_id) 
from(
  
  select  cli.party_id, sum(montante_eur) montante 
  from(
    select
      *
    from
      workbench_fcc.rpb25_universo_parties
  ) cli
  inner join(
    select
      *
    from
      workbench_fcc.rpb25_dep_num_contas_bancarias
  ) D
  on trim(cli.party_id) = trim(d.party_id)   
  group by cli.party_id
)
where montante >= 1000000

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.6.5 Clientes que prossigam atividades em áreas de negócio de risco mais elevado	
-- MAGIC "Número total de clientes que prossigam atividades em áreas de negócio de risco mais elevado, por área de negócio, à data do termo do período de referência do RPB (31 de dezembro). 
-- MAGIC [Resposta em linhas, com duas colunas: 1) escolha da área de negócio de a partir de uma lista pré-definida; 2) n.º de clientes]"	
-- MAGIC

-- COMMAND ----------

select 
       activ_area_risco_elevado_grupo,
       count(distinct party_id)
 from production.workbench_fcc.rpb25_universo_parties
where activ_area_risco_elevado='S' 
group by activ_area_risco_elevado_grupo 
order by count(distinct party_id) desc

-- COMMAND ----------


---SELECT count(DISTINCT party_id) FROM (
SELECT clre.*,CSEGMENTO,GSEGMENTO,GSUBSEGMENTO from
-- clientes Risco Elevado
(select DISTINCT party_id,econ_activity_category_code,econ_activity_category_desc from production.workbench_fcc.rpb25_universo_parties where activ_area_risco_elevado='S') clre 
LEFT join
-- Segmentos
(select  DISTINCT ccliente,CSEGMENTO,GSEGMENTO,GSUBSEGMENTO

 FROM  production.curated_internal_datawarehouse_dw.dwt1116_vincul_emp where data_date_part='2025-12-31') sgmt

on cast(clre.party_id as bigint)=cast(sgmt.ccliente as bigint)
--)





-- COMMAND ----------

-- MAGIC %md
-- MAGIC 2.6.6 Clientes com uma estrutura de propriedade complexa	
-- MAGIC a) Número total de clientes com uma estrutura de propriedade complexa à data do termo do período de referência do RPB (31 de dezembro). [Resposta: campo numérico]	
-- MAGIC

-- COMMAND ----------

select '2.6.6' as Pergunta, count(party_id)
from production.workbench_fcc.rpb25_universo_parties 
where estrutura_complexa='S'