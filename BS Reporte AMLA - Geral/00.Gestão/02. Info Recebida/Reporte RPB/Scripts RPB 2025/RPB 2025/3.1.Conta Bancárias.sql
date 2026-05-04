-- Databricks notebook source
-- MAGIC %md
-- MAGIC ####Universo contas bancárias 

-- COMMAND ----------

select distinct common_table_name from (
select *,
        contract_id,
        product_id,
        subproduct_id,
        concat(cbalcao, cnumecta) as cconta,
        row_number() over (partition by contract_id order by data_date_part desc) = 1
    from
        common_contracts_core.contract
    where
        1 = 1
        and data_date_part = '2025-12-31'
        and concat(product_id, subproduct_id) not in ('020806','024806') -- Exclusão de produtos contas de encerramento
    order by
        contract_id
) b
inner join(
    select
        *
    from
        production.curated_internal_mainframe_estruturais.tat91_tabelas
    where
        tayd91c0_CTABELA = '925'
        and data_date_part = '2025-12-31'
        and (
            substr(tayd91c0_nelemc04, 3, 3) in ('101','103','104') -- NELEMC04 (posição 3, len 3) in (101, 103, 104)
            or (tayd91c0_celemtab like '070%' or tayd91c0_celemtab like '071%')-- as 105 --> tayd91c0_celemtab begins with 070/071
        )
) c
on concat(b.product_id, b.subproduct_id) = c.tayd91c0_celemtab

-- COMMAND ----------

-- MAGIC %python
-- MAGIC tbl_contratos_CB = spark.sql(f"""
-- MAGIC select distinct
-- MAGIC 	a.contract_id,
-- MAGIC     contract_intervention_type_code,	
-- MAGIC     contract_intervention_order_num,
-- MAGIC 	relationship_start_date,
-- MAGIC 	product_id,
-- MAGIC 	subproduct_id,
-- MAGIC 	a.party_id,
-- MAGIC 	cconta,
-- MAGIC 	d.tipo_cliente,
-- MAGIC 	d.partenon_id,
-- MAGIC 	case
-- MAGIC 		when
-- MAGIC 			e.cae in ('64300','68322') or f.CTIPSOC in (18,	19)	then '1' else '0' end as centro_interesses_coletivos,
-- MAGIC    g.contract_status_code
-- MAGIC from(
-- MAGIC     select
-- MAGIC         *
-- MAGIC     from
-- MAGIC         production.common_contracts_core.contract_party_relationship
-- MAGIC     where
-- MAGIC         data_date_part = '2025-12-31'
-- MAGIC ) a
-- MAGIC inner join(
-- MAGIC     select
-- MAGIC         contract_id,
-- MAGIC         product_id,
-- MAGIC         subproduct_id,
-- MAGIC         concat(cbalcao, cnumecta) as cconta,
-- MAGIC         row_number() over (partition by contract_id order by data_date_part desc) = 1
-- MAGIC     from
-- MAGIC         common_contracts_core.contract
-- MAGIC     where
-- MAGIC         1 = 1
-- MAGIC         and data_date_part = '2025-12-31'
-- MAGIC         and concat(product_id, subproduct_id) not in ('020806','024806') -- Exclusão de produtos contas de encerramento
-- MAGIC     order by
-- MAGIC         contract_id
-- MAGIC ) b
-- MAGIC on trim(a.contract_id) = trim(b.contract_id)
-- MAGIC inner join(
-- MAGIC     select
-- MAGIC         *
-- MAGIC     from
-- MAGIC         production.curated_internal_mainframe_estruturais.tat91_tabelas
-- MAGIC     where
-- MAGIC         tayd91c0_CTABELA = '925'
-- MAGIC         and data_date_part = '2025-12-31'
-- MAGIC         and (
-- MAGIC             substr(tayd91c0_nelemc04, 3, 3) in ('101','103','104') -- NELEMC04 (posição 3, len 3) in (101, 103, 104)
-- MAGIC             or (tayd91c0_celemtab like '070%' or tayd91c0_celemtab like '071%')-- as 105 --> tayd91c0_celemtab begins with 070/071
-- MAGIC         )
-- MAGIC ) c
-- MAGIC on concat(b.product_id, b.subproduct_id) = c.tayd91c0_celemtab
-- MAGIC inner join(
-- MAGIC     select distinct
-- MAGIC         party_id,
-- MAGIC         partenon_id,
-- MAGIC         party_type_code as tipo_cliente
-- MAGIC     from
-- MAGIC         common_parties_core.party
-- MAGIC     where
-- MAGIC         1 = 1
-- MAGIC         and data_date_part = '2025-12-31'
-- MAGIC ) d
-- MAGIC on a.party_id = d.party_id
-- MAGIC --- centros de interesses coletivos
-- MAGIC left join(
-- MAGIC     select distinct
-- MAGIC         party_id,
-- MAGIC         econ_activity_category_code as cae
-- MAGIC     from
-- MAGIC         common_parties_individuals.individual_economic_activity
-- MAGIC     where
-- MAGIC         data_date_part = '2025-12-31'
-- MAGIC ) e
-- MAGIC on a.party_id = e.party_id
-- MAGIC left join (
-- MAGIC     select distinct
-- MAGIC         cl.ZCLIENTE,
-- MAGIC         cl.NOMER,
-- MAGIC         cl.CTIPSOC,
-- MAGIC         es.TAYD91C0_GELEMTAB as DSC_TIPSOC
-- MAGIC     from
-- MAGIC         curated_internal_mainframe_clientes.clt45_fcli cl
-- MAGIC     left join (
-- MAGIC         select
-- MAGIC             *
-- MAGIC         from
-- MAGIC             curated_internal_mainframe_estruturais.tat91_tabelas
-- MAGIC         where
-- MAGIC             TAYD91C0_CTABELA = 'J90'
-- MAGIC             and data_date_part = '2025-12-31'
-- MAGIC     ) es
-- MAGIC     on cl.CTIPSOC = es.TAYD91C0_CELEMTAB
-- MAGIC     where
-- MAGIC         cl.data_date_part = '2025-12-31'
-- MAGIC         and cl.CTIPSOC in (18, 19)
-- MAGIC ) f
-- MAGIC on a.party_id = f.ZCLIENTE
-- MAGIC left join(
-- MAGIC     select contract_id, contract_status_code
-- MAGIC     from common_contracts_incomesavingaccounts.incomesaving_account
-- MAGIC     where data_date_part = '2025-12-31'
-- MAGIC     union all
-- MAGIC     select contract_id, contract_status_code
-- MAGIC     from common_contracts_savingsaccounts.saving_account
-- MAGIC     where data_date_part = '2025-12-31'
-- MAGIC     union all
-- MAGIC     select contract_id, contract_status_code
-- MAGIC     from common_contracts_currentaccounts.current_account
-- MAGIC     where data_date_part = '2025-12-31'
-- MAGIC ) g
-- MAGIC on b.contract_id = g.contract_id
-- MAGIC left join (
-- MAGIC     select * from common_referencedata_core.param_reference_data_table
-- MAGIC     where data_table_code = '001'                                 -- Elementos para tradução
-- MAGIC     and element_description like '%CANCELLED%'                -- Exclusão de Contratos Cancelados
-- MAGIC     and data_date_part = '2025-12-31'
-- MAGIC ) h
-- MAGIC on g.contract_status_code = h.element_code
-- MAGIC where h.element_code is null
-- MAGIC
-- MAGIC """)
-- MAGIC ###tbl_contratos_CB.display()
-- MAGIC # tbl_contratos_CB.createOrReplaceTempView("ContasBancarias")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC tbl_contratos_CB.write.format("delta").mode("overwrite").option("mergeSchema", "true").saveAsTable("workbench_fcc.rpb25_universo_parties_contas_bancarias")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###  3.1.1 Informação geral 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Número total de contas bancárias à data do termo do período de referência do RPB (31 de dezembro) 

-- COMMAND ----------

select count(distinct contract_id)
from workbench_fcc.rpb25_universo_parties_contas_bancarias

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **b)** Número total de clientes titulares de contas bancárias à data do termo do período de referência do RPB (31 de dezembro)

-- COMMAND ----------

select count(distinct party_id)
from workbench_fcc.rpb25_universo_parties_contas_bancarias
where contract_intervention_type_code = '1'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **c)** Montante agregado, em euros, dos saldos das contas bancárias à data do termo do período de referência do RPB (31 de dezembro)

-- COMMAND ----------

select
	sum(saldos.Saldo_PASSIVO),
	count(AC.AccountID)
from(
    select distinct
        cconta as AccountID
    from
        workbench_fcc.rpb25_universo_parties_contas_bancarias
    where
        contract_intervention_type_code = 1
        and contract_intervention_order_num = 1
        
) AC
inner join (
    select
        concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d,
        sum(case when nivel_2 = 'P' then ct.c001 end) as Saldo_PASSIVO,
        sum(case when nivel_2 = 'A' then ct.c001 end) as Saldo_ACTIVO,
        sum(ct.c001) as VN
    from
        production.curated_internal_datalake_ctools.ct209_rent_kpm as ct
    left join (
        select distinct
            nivel_1,
            nivel_2,
            nivel_3,
            nivel_12
        from
            production.curated_internal_datalake_ctools.ct011_dim_hier
        where
            ref_date = '2025-12-31'
    ) as hier
    on hier.nivel_12 = ct.ckmetamis
    where
        ct.ref_Date = '2025-12-31'
    group by
        concat(ct.ckbalcao, ct.cknumcta)
) as saldos
on saldos.num_conta_15d = AC.AccountID

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.1.2 Clientes “pessoas SINGULARES

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Número total de clientes titulares de contas bancárias à data do termo do período de referência do RPB (31 de dezembro)

-- COMMAND ----------

SELECT  count(DISTINCT party_id)
from  workbench_fcc.rpb25_universo_parties_contas_bancarias
WHERE tipo_cliente='F' and centro_interesses_coletivos ='0' and contract_intervention_type_code=1

-- COMMAND ----------

-- MAGIC %md
-- MAGIC b) Montante agregado, em euros, dos saldos das contas bancárias à data do termo do período de referência do reporte (31 de dezembro)

-- COMMAND ----------

select
	sum(saldos.saldo_passivo),
	count(AC.AccountID)
from(
    select distinct
        cconta as AccountID
    from
        workbench_fcc.rpb25_universo_parties_contas_bancarias
    where
        tipo_cliente='F'
        and centro_interesses_coletivos = '0'
        and contract_intervention_type_code = '1'
        and contract_intervention_order_num = '1'
) AC
inner join (
    select
        concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d,
        sum(case when nivel_2 = 'P' then ct.c001 end) as Saldo_PASSIVO,
        sum(case when nivel_2 = 'A' then ct.c001 end) as Saldo_ACTIVO,
        sum(ct.c001) as VN
    from
        production.curated_internal_datalake_ctools.ct209_rent_kpm as ct
    left join (
        select distinct
            nivel_1,
            nivel_2,
            nivel_3,
            nivel_12
        from
            production.curated_internal_datalake_ctools.ct011_dim_hier
        where
            ref_date = '2025-12-31'
    ) as hier
    on hier.nivel_12 = ct.ckmetamis
    where
        ct.ref_Date = '2025-12-31'
    group by
        concat(ct.ckbalcao, ct.cknumcta)
) as saldos
on saldos.num_conta_15d = AC.AccountID

-- COMMAND ----------

-- MAGIC %md
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.1.3 Clientes “pessoas COLETIVAS e “centros de interesses coletivos sem personalidade jurídica”

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC **a)** Número total de clientes titulares de contas bancárias à data do termo do período de referência do RPB (31 de dezembro)

-- COMMAND ----------

select
	count(distinct party_id)
from(
     select
          party_id
     from
          workbench_fcc.rpb25_universo_parties_contas_bancarias
     where
          tipo_cliente = 'J'
          and contract_intervention_type_code = 1 
     union all
     ---CENTROS DE INTERESSE COLETIVOS SEM PERSONALIDADES JURÍDICAS (que são F)
     select
          party_id
     from
          workbench_fcc.rpb25_universo_parties_contas_bancarias
     where
          tipo_cliente = 'F'
          and centro_interesses_coletivos = '1'
          and contract_intervention_type_code = 1
)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **b)** Montante agregado, em euros, dos saldos das contas bancárias à data do termo do período de referência do reporte (31 de dezembro). [Resposta: campo numérico]

-- COMMAND ----------

select
	sum(saldos.saldo_passivo),
	count(distinct AC.AccountID)
from(
    select distinct
        cconta as AccountID
    from
        workbench_fcc.rpb25_universo_parties_contas_bancarias
    where
        1 = 1
        and tipo_cliente = 'J'
        and contract_intervention_type_code = 1
        and contract_intervention_order_num = 1
    union all
    --CENTROS DE INTERESSE COLETIVOS SEM PERSONALIDADES JURÍDICAS
    select
    distinct
        cconta as AccountID
    from
        workbench_fcc.rpb25_universo_parties_contas_bancarias
    where
        1 = 1
        and tipo_cliente = 'F'
        and centro_interesses_coletivos = '1'
        and contract_intervention_type_code = 1
        and contract_intervention_order_num = 1
) as AC
inner join (
    select
        concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d,
        sum(case when nivel_2 = 'P' then ct.c001 end) as Saldo_PASSIVO,
        sum(case when nivel_2 = 'A' then ct.c001 end) as Saldo_ACTIVO,
        sum(ct.c001) as VN
    from
        production.curated_internal_datalake_ctools.ct209_rent_kpm as ct
    left join (
        select distinct
            nivel_1,
            nivel_2,
            nivel_3,
            nivel_12
        from
            production.curated_internal_datalake_ctools.ct011_dim_hier
        where
            ref_date = '2025-12-31'
    ) as hier
    on hier.nivel_12 = ct.ckmetamis
    where
    ct.ref_Date = '2025-12-31'
    group by
    concat(ct.ckbalcao, ct.cknumcta)
) as saldos
on saldos.num_conta_15d = AC.AccountID

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.1.4 Depósitos em numerário:

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Universo

-- COMMAND ----------

-- MAGIC %python
-- MAGIC tbl_DepositosNumerarios = spark.sql(f"""
-- MAGIC select a.*,
-- MAGIC   trim(c.element_description) as desc_moeda, 
-- MAGIC   case
-- MAGIC     when a.currency_code <> '978' then round(amount * d.TCMBME,2)
-- MAGIC     else round(amount,2)
-- MAGIC   end as montante_eur
-- MAGIC from(
-- MAGIC   select 
-- MAGIC     * 
-- MAGIC   from 
-- MAGIC     production.common_payments_occasionaltransactions.occasional_transaction
-- MAGIC   where 
-- MAGIC     transaction_request_date between '2025-01-01' and '2025-12-31' 
-- MAGIC     -- and transaction_detail_code in ('CDP', 'SDP', 'FXS') 
-- MAGIC     --and party_id <> '#N/A'
-- MAGIC ) a
-- MAGIC inner join( -- define tipos de depósitos com base no BANKTELLER (700 Dep Numerario Balcao, 713 Dep Numerario SelBanking, 709 Entregas Reduzidas, 708 Compra de Moeda Estrangeira)
-- MAGIC   select 
-- MAGIC     * 
-- MAGIC   from 
-- MAGIC     common_referencedata_core.param_general_code_converter
-- MAGIC   where 
-- MAGIC     data_date_part = '2026-02-16' 
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
-- MAGIC     data_date_part = '2026-02-16' 
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
-- MAGIC
-- MAGIC """)
-- MAGIC
-- MAGIC # tbl_DepositosNumerarios.createOrReplaceTempView("DepositosNumerarios")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC tbl_DepositosNumerarios.write.format("delta").mode("overwrite").option("mergeSchema", "true").saveAsTable("workbench_fcc.rpb25_dep_num_contas_bancarias")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Número de depósitos em numerário de valor unitário igual ou superior a €100.000 realizados no período de referência em contas tituladas por:  
-- MAGIC **i.** Clientes “pessoas singulares”;

-- COMMAND ----------

select
	count(distinct transaction_id)
from(
  select
    *
  from
    workbench_fcc.rpb25_universo_parties_contas_bancarias
  where
    tipo_cliente = 'F'
    and centro_interesses_coletivos = '0'
    and contract_intervention_type_code = 1
    and contract_intervention_order_num = 1
) CB
inner join(
  select
    *
  from
    workbench_fcc.rpb25_dep_num_contas_bancarias
  where montante_eur >= 100000
) D
on trim(associated_contract_id) = trim(contract_id)    


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Número de depósitos em numerário de valor unitário igual ou superior a €100.000 realizados no período de referência em contas tituladas por:  
-- MAGIC **ii.** Clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica”
-- MAGIC

-- COMMAND ----------

select
	count(distinct transaction_id)
from(
  select
    *
  from
    workbench_fcc.rpb25_universo_parties_contas_bancarias
  where
    tipo_cliente = 'J'
    and contract_intervention_type_code = 1
    and contract_intervention_order_num = 1
  union all
  select
    *
  from
    workbench_fcc.rpb25_universo_parties_contas_bancarias
  where
    tipo_cliente = 'F'
    and centro_interesses_coletivos = '1'
    and contract_intervention_type_code = 1
    and contract_intervention_order_num = 1
) CB
inner join(
  select
    *
  from
    workbench_fcc.rpb25_dep_num_contas_bancarias
  where montante_eur >= 100000
) D
on trim(associated_contract_id) = trim(contract_id)    

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **b)** Clientes que tenham realizado depósitos em numerário de forma intensiva no período de referência identificados na questão 2.6.4 da Parte 2:    
-- MAGIC **i.** Número de clientes:

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
-- MAGIC **ii.** Número de depósitos em numerário realizados
-- MAGIC
-- MAGIC **iii.** Montante agregado, em euros, dos fundos depositados

-- COMMAND ----------

select count(distinct party_id), sum(n_trx) n_trx, sum(montante) montante
from(
  
  select  cli.party_id, count(transaction_id) n_trx, sum(montante_eur) montante 
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

select sum(Montante_Total)
from (

    select cli.customer_id, sum(Montante) as Montante_Total, count(*) as Num_TRX 
    from production.business_garantias.cl001_interv_cto a
    
    inner join production.workbench_fcc.clientes_ativos_rpb_2024 cli
    on (cast(a.zcliente as bigint) =cast( cli.ccliente as bigint))
    
    inner join 
            (
            select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
            where tayd91c0_CTABELA = '925' and data_date_part = '2024-12-31'
                and (
                        (tayd91c0_celemtab not in ('020806','024806') -- excluir as contas de encerramento
                        and substr(tayd91c0_nelemc04,3,3) in ('101','103','104'))-- NELEMC04 (posição 3, len 3) in (101, 103, 104)
                
                    or (tayd91c0_celemtab like '070%' or tayd91c0_celemtab like '071%') -- as 105 --> tayd91c0_celemtab begins with 070/071
                ) 
            ) b
            
    on concat (a.cproduto, a.csubprod) = b.tayd91c0_celemtab
    
    inner join 
            (select concat(nkyr0033_ckbalcao_sintra, nkyr0033_cknumcta_sintra) as AccountID, nkyr0033_contravalor_dgoapli as Montante
            from cd_clientes.movimentos_dia
            where nkyr0033_fecha_operacion between '2024-01-01' and '2024-12-31'
                and concat(nkyr0033_codoper_concepto,nkyr0033_naturaleza_operacion) in 
                                    (select concat(sa_code_reda,sa_nat_ope)
                                    from curated_internal_norkom.san_familias
                                    where sa_cod_familia='0001' and data_date_part = '2024-12-31')
            ) AS tr
    on concat(a.cbalcao, a.cnumecta) = tr.AccountID
    
    where a.dfim_relacao ='9999-12-31' and a.ref_date = '2024-12-31'
            and a.crelacao_cl_cnt = '1' and a.csequencia_rel = '00001'
    group by cli.customer_id

) Z

where Montante_Total > 1000000
-- 692 409 367,82



-- COMMAND ----------

-- MAGIC %md
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### **3.2.** CONTAS DE PAGAMENTO

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #####Universo

-- COMMAND ----------

select distinct common_table_name from (
select *,
        contract_id,
        product_id,
        subproduct_id,
        concat(cbalcao, cnumecta) as cconta,
        row_number() over (partition by contract_id order by data_date_part desc) = 1
    from
        common_contracts_core.contract
    where
        1 = 1
        and data_date_part = '2025-12-31'
    order by
        contract_id
) b
inner join(
    select
        *
    from
        production.curated_internal_mainframe_estruturais.tat91_tabelas
    where
        tayd91c0_CTABELA = '925'
        and data_date_part = '2025-12-31'
        and (
        (tayd91c0_celemtab in ('020806','024806') -- incLuir as contas de encerramento
            or substr(tayd91c0_nelemc04, 3, 3) in ('301') -- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
            or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab, 4, 3) not in ('001','002')))
        )
) c
on concat(b.product_id, b.subproduct_id) = c.tayd91c0_celemtab

-- COMMAND ----------

-- MAGIC %python
-- MAGIC tbl_contratos_CBP = spark.sql(f"""
-- MAGIC select distinct
-- MAGIC 	a.contract_id,
-- MAGIC 	contract_intervention_order_num,
-- MAGIC 	contract_intervention_type_code,
-- MAGIC 	relationship_start_date,
-- MAGIC 	product_id,
-- MAGIC 	subproduct_id,
-- MAGIC 	a.party_id,
-- MAGIC 	cconta,
-- MAGIC 	d.tipo_cliente,
-- MAGIC 	d.partenon_id,
-- MAGIC 	case when e.cae in ('64300','68322') or f.CTIPSOC in (18,19) then '1' else '0' end as centro_interesses_coletivos
-- MAGIC from(
-- MAGIC     select
-- MAGIC         *
-- MAGIC     from
-- MAGIC         production.common_contracts_core.contract_party_relationship
-- MAGIC     where
-- MAGIC         data_date_part = '2025-12-31'
-- MAGIC ) a
-- MAGIC inner join (
-- MAGIC     select
-- MAGIC         contract_id,
-- MAGIC         product_id,
-- MAGIC         subproduct_id,
-- MAGIC         concat(cbalcao, cnumecta) as cconta,
-- MAGIC         row_number() over (partition by contract_id order by data_date_part desc) = 1
-- MAGIC     from
-- MAGIC         common_contracts_core.contract
-- MAGIC     where
-- MAGIC         1 = 1
-- MAGIC         and data_date_part = '2025-12-31'
-- MAGIC     order by
-- MAGIC         contract_id
-- MAGIC ) b
-- MAGIC on trim(a.contract_id) = trim(b.contract_id)
-- MAGIC inner join (
-- MAGIC     select
-- MAGIC         *
-- MAGIC     from
-- MAGIC         curated_internal_mainframe_estruturais.TAT91_TABELAS
-- MAGIC     where
-- MAGIC         tayd91c0_CTABELA = '925'
-- MAGIC         and data_date_part = '2025-12-31'
-- MAGIC         and (tayd91c0_celemtab in ('020806','024806') -- incLuir as contas de encerramento
-- MAGIC             or substr(tayd91c0_nelemc04, 3, 3) in ('301') -- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
-- MAGIC             or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab, 4, 3) not in ('001','002')))
-- MAGIC ) c
-- MAGIC on concat(b.product_id, b.subproduct_id) = c.tayd91c0_celemtab
-- MAGIC inner join (
-- MAGIC     select distinct
-- MAGIC         party_id,
-- MAGIC         partenon_id,
-- MAGIC         party_type_code as tipo_cliente
-- MAGIC     from
-- MAGIC         common_parties_core.party
-- MAGIC     where
-- MAGIC         1 = 1
-- MAGIC         and data_date_part = '2025-12-31'
-- MAGIC ) d
-- MAGIC on a.party_id = d.party_id
-- MAGIC left join --- centros de interesses coletivos
-- MAGIC (
-- MAGIC     select distinct
-- MAGIC         party_id,
-- MAGIC         econ_activity_category_code as cae
-- MAGIC     from
-- MAGIC         common_parties_individuals.individual_economic_activity
-- MAGIC     where
-- MAGIC         data_date_part = '2025-12-31'
-- MAGIC ) e
-- MAGIC on a.party_id = e.party_id
-- MAGIC left join (
-- MAGIC     select distinct
-- MAGIC         cl.ZCLIENTE,
-- MAGIC         cl.NOMER,
-- MAGIC         cl.CTIPSOC,
-- MAGIC         es.TAYD91C0_GELEMTAB as DSC_TIPSOC
-- MAGIC     from
-- MAGIC         curated_internal_mainframe_clientes.clt45_fcli cl
-- MAGIC     left join(
-- MAGIC         select
-- MAGIC             *
-- MAGIC         from
-- MAGIC             curated_internal_mainframe_estruturais.tat91_tabelas
-- MAGIC         where
-- MAGIC             TAYD91C0_CTABELA = 'J90'
-- MAGIC             and data_date_part = '2025-12-31'
-- MAGIC     ) es
-- MAGIC     on cl.CTIPSOC = es.TAYD91C0_CELEMTAB
-- MAGIC     where
-- MAGIC         cl.data_date_part = '2025-12-31'
-- MAGIC         and cl.CTIPSOC in (18,19)
-- MAGIC ) f
-- MAGIC on a.party_id = f.ZCLIENTE
-- MAGIC left join(
-- MAGIC     select contract_id, contract_status_code
-- MAGIC     from common_contracts_internalaccounts.internal_account
-- MAGIC     where data_date_part = '2025-12-31'
-- MAGIC     union all
-- MAGIC     select contract_id, contract_status_code
-- MAGIC     from common_contracts_creditcards.credit_card_contract
-- MAGIC     where data_date_part = '2025-12-31'
-- MAGIC     union all
-- MAGIC     select contract_id, contract_status_code
-- MAGIC     from common_contracts_currentaccounts.current_account
-- MAGIC     where data_date_part = '2025-12-31'
-- MAGIC ) g
-- MAGIC on b.contract_id = g.contract_id
-- MAGIC left join (
-- MAGIC     select * from common_referencedata_core.param_reference_data_table
-- MAGIC     where data_table_code = '001'                                 -- Elementos para tradução
-- MAGIC     and element_description like '%CANCELLED%'                -- Exclusão de Contratos Cancelados
-- MAGIC     and data_date_part = '2025-12-31'
-- MAGIC ) h
-- MAGIC on g.contract_status_code = h.element_code
-- MAGIC where h.element_code is null
-- MAGIC """)
-- MAGIC ###tbl_contratos_CB.display()
-- MAGIC tbl_contratos_CBP.createOrReplaceTempView("ContasDePagamento")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC
-- MAGIC tbl_contratos_CBP.write.format("delta").mode("overwrite").option("mergeSchema", "true").saveAsTable("workbench_fcc.rpb25_universo_parties_contas_pagamento")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #####3.2.1. Informação geral

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Número total de contas de pagamento à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]

-- COMMAND ----------

select count(distinct contract_id)
from workbench_fcc.rpb25_universo_parties_contas_pagamento

-- COMMAND ----------

 						
 						
---a) Número total de contas de pagamento à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]						

select count(distinct cconta)
from production.workbench_fcc.rpb25_universo_contratos_relacoes a

inner join production.workbench_fcc.rpb25_universo_parties cli
on (a.party_id = cli.party_id)

inner join 
        (
        select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
        where tayd91c0_CTABELA = '925' and data_date_part = '2025-12-31'
            and (
                    (tayd91c0_celemtab in ('020806','024806') -- inlcuir as contas de encerramento
                    or substr(tayd91c0_nelemc04,3,3) in ('301')-- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
                    or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab,4,3) not in ('001','002'))) -- as 105 --> tayd91c0_celemtab begins with 070/071
            ) 
        ) b
        
on concat (a.product_id, a.subproduct_id) = b.tayd91c0_celemtab

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **b)** Número total de clientes titulares de contas de pagamento à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]

-- COMMAND ----------

select count(distinct party_id) 
from workbench_fcc.rpb25_universo_parties_contas_pagamento
where contract_intervention_type_code = 1

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **c)** Montante agregado, em euros, dos saldos das contas de pagamento à data do termo do período de referência do RPB (31 de dezembro). [Resposta: campo numérico]

-- COMMAND ----------

select
	sum(saldos.Saldo_PASSIVO),
	count(AC.AccountID)
from(
    select distinct
        cconta as AccountID
    from
        workbench_fcc.rpb25_universo_parties_contas_pagamento
    where
        contract_intervention_type_code = 1
        and contract_intervention_order_num = 1
        
) AC
inner join (
    select
        concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d,
        sum(case when nivel_2 = 'P' then ct.c001 end) as Saldo_PASSIVO,
        sum(case when nivel_2 = 'A' then ct.c001 end) as Saldo_ACTIVO,
        sum(ct.c001) as VN
    from
        production.curated_internal_datalake_ctools.ct209_rent_kpm as ct
    left join (
        select distinct
            nivel_1,
            nivel_2,
            nivel_3,
            nivel_12
        from
            production.curated_internal_datalake_ctools.ct011_dim_hier
        where
            ref_date = '2025-12-31'
    ) as hier
    on hier.nivel_12 = ct.ckmetamis
    where
        ct.ref_Date = '2025-12-31'
    group by
        concat(ct.ckbalcao, ct.cknumcta)
) as saldos
on saldos.num_conta_15d = AC.AccountID

-- COMMAND ----------

 SELECT  sum(saldos.Saldo_Recursos), count(DISTINCT AC.AccountID)
FROM 
    (SELECT AccountID,partenon_id
    FROM (
            select distinct cconta as AccountID, cli.partenon_id
            from production.workbench_fcc.rpb25_universo_contratos_relacoes a

            inner join production.workbench_fcc.rpb25_universo_parties cli
            on a.party_id  = cli.party_id

            inner join 
                    (
                    select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
                    where tayd91c0_CTABELA = '925' and data_date_part = '2025-12-31'
                    and (
                            (tayd91c0_celemtab in ('020806','024806') -- inlcuir as contas de encerramento
                            or substr(tayd91c0_nelemc04,3,3) in ('301')-- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
                            or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab,4,3) not in ('001','002'))) -- as 105 --> tayd91c0_celemtab begins with 070/071
                        ) 
                    ) b
                    
            on concat (a.product_id, a.subproduct_id) = b.tayd91c0_celemtab

            where  a.tipo_interv = 'TITULAR'  AND contract_intervention_order_num=1

        ) z
        
    ) AS AC        

INNER JOIN 

    (SELECT concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d, 
            sum(case when (nivel_2='P' or hier.nivel_3='SO0300') then (ct.c007+ct.c224) end) as Saldo_Recursos,
            sum(case when  nivel_2='A' then (ct.c007+ct.c224) end) as Saldo_Creditos,
            sum(case when  nivel_1<>'VN' and hier.nivel_3<>'SO0300' then (ct.c007+ct.c224) end) as Saldos_Outros
                
        FROM production.curated_internal_datalake_ctools.ct209_rent_kpm as ct 
        LEFT JOIN (SELECT DISTINCT nivel_1, nivel_2, nivel_3, nivel_12 FROM production.curated_internal_datalake_ctools.ct011_dim_hier WHERE ref_date = '2025-12-31') AS hier 
        ON hier.nivel_12=ct.ckmetamis 
        WHERE ct.ref_Date = '2025-12-31'  
        GROUP BY  concat(ct.ckbalcao,ct.cknumcta) 
                
    )  AS saldos  ON trim(saldos.num_conta_15d)=trim(AC.AccountID)
    
  


-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.2.2. Clientes “pessoas singulares”

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Número total de clientes titulares de contas de pagamento à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]

-- COMMAND ----------

SELECT  count(DISTINCT party_id)
from  workbench_fcc.rpb25_universo_parties_contas_pagamento
WHERE tipo_cliente='F' and centro_interesses_coletivos ='0' and contract_intervention_type_code=1

-- COMMAND ----------

 select count(distinct a.partenon_id)
from production.workbench_fcc.rpb25_universo_contratos_relacoes a

inner join (select * from production.workbench_fcc.rpb25_universo_parties
            where Tipo_Cliente = 'F') cli
on (a.party_id = cli.party_id)

inner join 
        (
        select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
        where tayd91c0_CTABELA = '925' and data_date_part = '2025-12-31'
            and (
                    (tayd91c0_celemtab in ('020806','024806') -- inlcuir as contas de encerramento
                    or substr(tayd91c0_nelemc04,3,3) in ('301')-- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
                    or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab,4,3) not in ('001','002'))) -- as 105 --> tayd91c0_celemtab begins with 070/071
            ) 
        ) b
        
on concat (a.product_id, a.subproduct_id) = b.tayd91c0_celemtab

where tipo_interv='TITULAR'  AND contract_intervention_order_num=1 and centro_inter_colec_s_person_juridica ='N' 
     
    

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **b)** Montante agregado, em euros, dos saldos das contas bancárias à data do termo do período de referência do RPB (31 de dezembro). [Resposta: campo numérico]

-- COMMAND ----------

select
	sum(saldos.saldo_passivo),
	count(AC.AccountID)
from(
    select distinct
        cconta as AccountID
    from
        workbench_fcc.rpb25_universo_parties_contas_pagamento
    where
        tipo_cliente='F'
        and centro_interesses_coletivos = '0'
        and contract_intervention_type_code = '1'
        and contract_intervention_order_num = '1'
) AC
inner join (
    select
        concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d,
        sum(case when nivel_2 = 'P' then ct.c001 end) as Saldo_PASSIVO,
        sum(case when nivel_2 = 'A' then ct.c001 end) as Saldo_ACTIVO,
        sum(ct.c001) as VN
    from
        production.curated_internal_datalake_ctools.ct209_rent_kpm as ct
    left join (
        select distinct
            nivel_1,
            nivel_2,
            nivel_3,
            nivel_12
        from
            production.curated_internal_datalake_ctools.ct011_dim_hier
        where
            ref_date = '2025-12-31'
    ) as hier
    on hier.nivel_12 = ct.ckmetamis
    where
        ct.ref_Date = '2025-12-31'
    group by
        concat(ct.ckbalcao, ct.cknumcta)
) as saldos
on saldos.num_conta_15d = AC.AccountID

-- COMMAND ----------


SELECT sum(saldos.Saldo_Recursos), count(DISTINCT AC.AccountID)
 FROM 
    (SELECT AccountID,partenon_id
      FROM (
            select distinct CCONTA as AccountID, cli.partenon_id
              from production.workbench_fcc.rpb25_universo_contratos_relacoes a

            inner join

            (select*from production.workbench_fcc.rpb25_universo_parties
                        where Tipo_Cliente = 'F'
            ) cli
            on a.party_id  = cli.party_id 

            inner join 
                    (
                    select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
                    where tayd91c0_CTABELA = '925' and data_date_part = '2025-12-31'
                    and (
                            (tayd91c0_celemtab in ('020806','024806') -- inlcuir as contas de encerramento
                            or substr(tayd91c0_nelemc04,3,3) in ('301')-- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
                            or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab,4,3) not in ('001','002'))) -- as 105 --> tayd91c0_celemtab begins with 070/071
                        ) 
                    ) b
                    
            on concat (a.product_id, a.subproduct_id) = b.tayd91c0_celemtab

            where tipo_interv='TITULAR' AND contract_intervention_order_num=1 AND centro_inter_colec_s_person_juridica='N'

        ) z
        
    ) AS AC        

INNER JOIN 

    (SELECT concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d, 
            sum(case when (nivel_2='P' or hier.nivel_3='SO0300') then (ct.c007+ct.c224) end) as Saldo_Recursos,
            sum(case when  nivel_2='A' then (ct.c007+ct.c224) end) as Saldo_Creditos,
            sum(case when  nivel_1<>'VN' and hier.nivel_3<>'SO0300' then (ct.c007+ct.c224) end) as Saldos_Outros
                
        FROM production.curated_internal_datalake_ctools.ct209_rent_kpm as ct 
        LEFT JOIN (SELECT DISTINCT nivel_1, nivel_2, nivel_3, nivel_12 FROM production.curated_internal_datalake_ctools.ct011_dim_hier WHERE ref_date = '2025-12-31') AS hier 
        ON hier.nivel_12=ct.ckmetamis 
        WHERE ct.ref_Date = '2025-12-31'  
        GROUP BY  concat(ct.ckbalcao,ct.cknumcta) 
                
    )  AS saldos  ON trim(saldos.num_conta_15d)=trim(AC.AccountID)
    
    


-- COMMAND ----------

-- MAGIC %md 
-- MAGIC ##### 3.2.3. Clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica”:  
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC **a)** Número total de clientes titulares de contas de pagamento à data do termo do período de referência do RPB (31 de dezembro); [Resposta: campo numérico]

-- COMMAND ----------

select
	count(distinct party_id)
from(
     select
          party_id
     from
          workbench_fcc.rpb25_universo_parties_contas_pagamento
     where
          tipo_cliente = 'J'
          and contract_intervention_type_code = 1 
     union all
     ---CENTROS DE INTERESSE COLETIVOS SEM PERSONALIDADES JURÍDICAS (que são F)
     select
          party_id
     from
          workbench_fcc.rpb25_universo_parties_contas_pagamento
     where
          tipo_cliente = 'F'
          and centro_interesses_coletivos = '1'
          and contract_intervention_type_code = 1
)

-- COMMAND ----------


SELECT count(partenon_id) FROM (
select distinct a.partenon_id
from production.workbench_fcc.rpb25_universo_contratos_relacoes a

inner join (select * from production.workbench_fcc.rpb25_universo_parties
            where Tipo_Cliente = 'J') cli
on (a.party_id = cli.party_id)

inner join 
        (
        select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
        where tayd91c0_CTABELA = '925' and data_date_part = '2025-12-31'
            and (
                    (tayd91c0_celemtab in ('020806','024806') -- inlcuir as contas de encerramento
                    or substr(tayd91c0_nelemc04,3,3) in ('301')-- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
                    or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab,4,3) not in ('001','002'))) -- as 105 --> tayd91c0_celemtab begins with 070/071
            ) 
        ) b
        
on concat (a.product_id, a.subproduct_id) = b.tayd91c0_celemtab

where tipo_interv='TITULAR'  AND contract_intervention_order_num=1 

union all 

select distinct a.partenon_id
from production.workbench_fcc.rpb25_universo_contratos_relacoes a

inner join (select * from production.workbench_fcc.rpb25_universo_parties
            where Tipo_Cliente = 'F') cli
on (a.party_id = cli.party_id)

inner join 
        (
        select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
        where tayd91c0_CTABELA = '925' and data_date_part = '2025-12-31'
            and (
                    (tayd91c0_celemtab in ('020806','024806') -- inlcuir as contas de encerramento
                    or substr(tayd91c0_nelemc04,3,3) in ('301')-- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
                    or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab,4,3) not in ('001','002'))) -- as 105 --> tayd91c0_celemtab begins with 070/071
            ) 
        ) b
        
on concat (a.product_id, a.subproduct_id) = b.tayd91c0_celemtab

where tipo_interv='TITULAR'  AND contract_intervention_order_num=1 and centro_inter_colec_s_person_juridica ='Y' 
     
)

     


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **b)** Montante agregado, em euros, dos saldos das contas de pagamento à data do termo do período de referência do RPB (31 de dezembro). [Resposta: campo numérico]

-- COMMAND ----------

select
	sum(saldos.saldo_passivo),
	count(distinct AC.AccountID)
from(
    select distinct
        cconta as AccountID
    from
        workbench_fcc.rpb25_universo_parties_contas_pagamento
    where
        1 = 1
        and tipo_cliente = 'J'
        and contract_intervention_type_code = 1
        and contract_intervention_order_num = 1
    union all
    --CENTROS DE INTERESSE COLETIVOS SEM PERSONALIDADES JURÍDICAS
    select
    distinct
        cconta as AccountID
    from
        workbench_fcc.rpb25_universo_parties_contas_pagamento
    where
        1 = 1
        and tipo_cliente = 'F'
        and centro_interesses_coletivos = '1'
        and contract_intervention_type_code = 1
        and contract_intervention_order_num = 1
) as AC
inner join (
    select
        concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d,
        sum(case when nivel_2 = 'P' then ct.c001 end) as Saldo_PASSIVO,
        sum(case when nivel_2 = 'A' then ct.c001 end) as Saldo_ACTIVO,
        sum(ct.c001) as VN
    from
        production.curated_internal_datalake_ctools.ct209_rent_kpm as ct
    left join (
        select distinct
            nivel_1,
            nivel_2,
            nivel_3,
            nivel_12
        from
            production.curated_internal_datalake_ctools.ct011_dim_hier
        where
            ref_date = '2025-12-31'
    ) as hier
    on hier.nivel_12 = ct.ckmetamis
    where
    ct.ref_Date = '2025-12-31'
    group by
    concat(ct.ckbalcao, ct.cknumcta)
) as saldos
on saldos.num_conta_15d = AC.AccountID

-- COMMAND ----------

SELECT sum(saldos.Saldo_Recursos), count(DISTINCT AC.AccountID) FROM (
select distinct cconta AS AccountID, a.partenon_id
from production.workbench_fcc.rpb25_universo_contratos_relacoes a

inner join (select * from production.workbench_fcc.rpb25_universo_parties
            where Tipo_Cliente = 'J') cli
on (a.party_id = cli.party_id)

inner join 
        (
        select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
        where tayd91c0_CTABELA = '925' and data_date_part = '2025-12-31'
            and (
                    (tayd91c0_celemtab in ('020806','024806') -- inlcuir as contas de encerramento
                    or substr(tayd91c0_nelemc04,3,3) in ('301')-- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
                    or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab,4,3) not in ('001','002'))) -- as 105 --> tayd91c0_celemtab begins with 070/071
            ) 
        ) b
        
on concat (a.product_id, a.subproduct_id) = b.tayd91c0_celemtab

where tipo_interv='TITULAR'  AND contract_intervention_order_num=1 

union all 

select distinct cconta AS AccountID , a.partenon_id
from production.workbench_fcc.rpb25_universo_contratos_relacoes a

inner join (select * from production.workbench_fcc.rpb25_universo_parties
            where Tipo_Cliente = 'F') cli
on (a.party_id = cli.party_id)

inner join 
        (
        select * from curated_internal_mainframe_estruturais.TAT91_TABELAS
        where tayd91c0_CTABELA = '925' and data_date_part = '2025-12-31'
            and (
                    (tayd91c0_celemtab in ('020806','024806') -- inlcuir as contas de encerramento
                    or substr(tayd91c0_nelemc04,3,3) in ('301')-- NELEMC04 (posição 3, len 3) in (301) - cartão de crédito
                    or (tayd91c0_celemtab like '025%' and substr(tayd91c0_celemtab,4,3) not in ('001','002'))) -- as 105 --> tayd91c0_celemtab begins with 070/071
            ) 
        ) b
        
on concat (a.product_id, a.subproduct_id) = b.tayd91c0_celemtab

where tipo_interv='TITULAR'  AND contract_intervention_order_num=1 and centro_inter_colec_s_person_juridica ='Y' 
     
)
AC
INNER JOIN 

    (SELECT concat(ct.ckbalcao,ct.cknumcta) AS num_conta_15d, 
            sum(case when (nivel_2='P' or hier.nivel_3='SO0300') then (ct.c007+ct.c224) end) as Saldo_Recursos,
            sum(case when  nivel_2='A' then (ct.c007+ct.c224) end) as Saldo_Creditos,
            sum(case when  nivel_1<>'VN' and hier.nivel_3<>'SO0300' then (ct.c007+ct.c224) end) as Saldos_Outros
                
        FROM production.curated_internal_datalake_ctools.ct209_rent_kpm as ct 
        LEFT JOIN (SELECT DISTINCT nivel_1, nivel_2, nivel_3, nivel_12 FROM production.curated_internal_datalake_ctools.ct011_dim_hier WHERE ref_date = '2025-12-31') AS hier 
        ON hier.nivel_12=ct.ckmetamis 
        WHERE ct.ref_Date = '2025-12-31'  
        GROUP BY  concat(ct.ckbalcao,ct.cknumcta) 
                
    )  AS saldos  ON trim(saldos.num_conta_15d)=trim(AC.AccountID)



-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 3.2.4. Depósitos em numerário: 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Número de depósitos em numerário de valor unitário igual ou superior a €100.000 realizados durante o período de referência em contas tituladas por:  
-- MAGIC **i.** Clientes “pessoas singulares”; [Resposta: campo numérico]

-- COMMAND ----------

select
	count(distinct transaction_id)
from(
  select
    *
  from
    workbench_fcc.rpb25_universo_parties_contas_pagamento
  where
    tipo_cliente = 'F'
    and centro_interesses_coletivos = '0'
    and contract_intervention_type_code = 1
    and contract_intervention_order_num = 1
) CB
inner join(
  select
    *
  from
    workbench_fcc.rpb25_dep_num_contas_bancarias
  where montante_eur >= 100000
) D
on trim(associated_contract_id) = trim(contract_id)    


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **a)** Número de depósitos em numerário de valor unitário igual ou superior a €100.000 realizados durante o período de referência em contas tituladas por:  
-- MAGIC **ii.** Clientes “pessoas coletivas” e “centros de interesses coletivos sem personalidade jurídica”. [Resposta: campo numérico] 

-- COMMAND ----------

SELECT   count(montante_eur),count(DISTINCT contract_id) from (
select montante_eur, party_id, associated_contract_id, contract_id from 
(select * FROM  ContasDePagamento  where contract_intervention_type_code=1 
and contract_intervention_order_num=1 ) CB

inner join (select*from DepositosNumerarios) D on trim(associated_contract_id)=trim(contract_id) 

where (tipo_cliente='J' OR centro_interesses_coletivos ='1') and  montante_eur>100000  

)