
---------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | Criação de tabelas importantes ao processo
---------------------------------------------------------------------------------------------------------------------
--  Desenvolvedor: Neyond
---------------------------------------------------------------------------------------------------------------------
-----------------------------------------TRADUTOR DE CHAVES CDG PARA MASTER ---------------------------------------------
-- 508.994 --  Registos Jun23 
-- 522.252 -- Registos Dez23 
-- drop table bu_esg_work.rf_tradutor_CdG_Master_Jun24;
create table bu_esg_work.rf_tradutor_CdG_Master_Jun24 as 
select  
    b.cempresa,
    b.cbalcao,
    b.cnumecta,
    b.zdeposit as zdeposit_ct,
    a.*,
    case when sfcs_tag_comgloval = 'Green' and trim(cmetanseg) not like 'EB%' then 1  -- Não CIB 
                         when sfcs_tag_comgloval = 'Sustainability Linked' and trim(cmetanseg) like 'EB%' then 2 -- CIB não alinhado com Taxonomia Europeia 
                     when sfcs_tag_comgloval <> 'Sustainability Linked' and trim(cmetanseg) like 'EB%' then 3  -- CIB alinhado com Taxonomia Europeia
                        else null end as flag_green_dashboard
from 
(
    select *
    from bu_ctrlgest.prod_esg_sfcs_2023_versaodezembro_pilariii_v2  --- ALTERAR TABELA
) a 
inner join (select distinct * from cd_captools.kt_chaves_mis where ref_date = "${ref_date}") b
on a.cempcta = b.cempcta   
and a.ckbalcao = b.ckbalcao
and a.cknumcta = b.cknumcta
and a.zdeposit = b.zdeposit_mis
;
-- tabela auxiliar do controlo de gestão
-- 455 875 Registos a Jun23
-- 442 809 Registos a Dez23
-- drop table bu_esg_work.rf_pilar3_cdg_tabaux1_Jun24_v2;
create table bu_esg_work.rf_pilar3_cdg_tabaux1_Jun24_v2 as
select distinct  
        a.cempresa_fr012,
        a.cbalcao_fr012,
        a.cnumecta_fr012,
        a.zdeposit_fr012,
        a.cempresa_ct,
        a.cbalcao_ct,
        a.cnumecta_ct,
        a.zdeposit_ct,
        b.ckbalbem,
        b.ckctabem,
        b.ckrefbem,
        b.sfcs_tag_comgloval,
        b.sfcs_green_activity_comgloval,
        b.tipo_produto,
        b.flag_green_dashboard,
        b.cmetanseg,
        b.fonte_n1,
        b.des_combustivel, 
        b.des_detalle_lease,
        b.co2,
        b.dinioper,
        c.ckprodmi
from (  select distinct 
            cempresa_fr012,
            cbalcao_fr012,
            cnumecta_fr012,
            zdeposit_fr012,
            cempresa_ct,
            cbalcao_ct,
            cnumecta_ct,
            zdeposit_ct,
            saldo_ct
        from bu_esg_work.rf_pilar3_universo_full  -- NOVO UNIVERSO FULL PARA DEZ23
        where DT_RFRNC = '${ref_date}' and ID_CORRIDA = '2'
        ) as a
inner join   (select distinct 
                    cempresa,
                    cbalcao,
                    cnumecta,
                    zdeposit_ct,
                    ckbalbem,
                    ckctabem,
                    ckrefbem,
                    sfcs_tag_comgloval,
                    sfcs_green_activity_comgloval,
                    tipo_produto,
                    cmetanseg,
                    fonte_n1,
                    des_combustivel, 
                    des_detalle_lease,
                    co2,
                    case when ckprodmi in ('000045','000051','000053') then dinioper else '' end as dinioper,
                    case when sfcs_tag_comgloval = 'Green' and trim(cmetanseg) not like 'EB%' then 1  -- Não CIB  
                         when sfcs_tag_comgloval = 'Sustainability Linked' and trim(cmetanseg) like 'EB%' then 2 -- CIB não alinhado com Taxonomia Europeia 
                         when sfcs_tag_comgloval <> 'Sustainability Linked' and trim(cmetanseg) like 'EB%' then 3  -- CIB alinhado com Taxonomia Europeia
                            else null end as flag_green_dashboard
            from bu_esg_work.rf_tradutor_CdG_Master_Jun24
            ) as b 
on a.cempresa_ct = b.cempresa
and a.cbalcao_ct = b.cbalcao
and a.cnumecta_ct = b.cnumecta
and a.zdeposit_ct = b.zdeposit_ct
left join   (select distinct 
                    cempresa,
                    cbalcao,
                    cnumecta,
                    zdeposit_ct,
                    ckbalbem,
                    ckctabem,
                    ckrefbem,
                    sfcs_tag_comgloval,
                    sfcs_green_activity_comgloval,
                    tipo_produto,
                    cmetanseg,
                    ckprodmi,
                    case when sfcs_tag_comgloval = 'Green' and trim(cmetanseg) not like 'EB%' then 1  -- Não CIB  
                         when sfcs_tag_comgloval = 'Sustainability Linked' and trim(cmetanseg) like 'EB%' then 2 -- CIB não alinhado com Taxonomia Europeia 
                         when sfcs_tag_comgloval <> 'Sustainability Linked' and trim(cmetanseg) like 'EB%' then 3  -- CIB alinhado com Taxonomia Europeia
                            else null end as flag_green_dashboard
            from bu_esg_work.rf_tradutor_CdG_Master_Jun24
            where ckprodmi in ('000042','000045','000051','000053','096HGP','0960H8','096065','113EMP','075EMP')) as c 
on a.cempresa_ct = c.cempresa
and a.cbalcao_ct = c.cbalcao
and a.cnumecta_ct = c.cnumecta
and a.zdeposit_ct = c.zdeposit_ct
;

--Tabela dos pesos 

-- 1.858.655 Jun23
-- 1.821.635 Dez23
-- 1.821.639 Dez23 --> Nova corrida Dez23
-- 2.075.910 Jun24

-- drop table bu_esg_work.rf_pilar3_pesos_Jun24;
create table bu_esg_work.rf_pilar3_pesos_Jun24 as 
select  a.cempresa_ct,
        a.cbalcao_ct,
        a.cnumecta_ct,
        a.zdeposit_ct,
        a.ckbalbem,
        a.ckctabem,
        a.ckrefbem,
        case when a.n_union = 1 then 1 
            else round(cast(a.`13_gross_carrying_amount` as decimal (21,6))/b.amount,6) end as peso
from (select * from bu_esg_work.reparticao_garantias_final_Jun24) as a

inner join (select  cempresa_ct,
                    cbalcao_ct,
                    cnumecta_ct,
                    zdeposit_ct,
                    sum(cast(`13_gross_carrying_amount` as decimal (21,6))) as amount
            from (select * from bu_esg_work.reparticao_garantias_final_Jun24) a
            group by 1,2,3,4 ) as b
on a.cempresa_ct = b.cempresa_ct
and a.cbalcao_ct = b.cbalcao_ct
and a.cnumecta_ct = b.cnumecta_ct
and a.zdeposit_ct = b.zdeposit_ct
;
---- Valida peso
select *
from 
(
    select  cempresa_ct,
            cbalcao_ct,
            cnumecta_ct,
            zdeposit_ct,
            sum(peso) as peso
    from bu_esg_work.rf_pilar3_pesos_Jun24
    group by 1,2,3,4
) a 
where 
--peso <1
--peso >1
--peso <0
---

-- Tabela com os certificados, consumos, e emissões para enviar a CdG
-- 1 821 635 Dez23
-- 2 075 910 Jun24 

-- drop table bu_captools_work.rf_pilar3_pesos_certificados_Jun24;
create table bu_captools_work.rf_pilar3_pesos_certificados_Jun24 as 
select  a.cempresa_ct,
        a.cbalcao_ct,
        a.cnumecta_ct,
        a.zdeposit_ct,
        a.ckbalbem,
        a.ckctabem,
        a.ckrefbem,
        a.fiabilidad,
        a.clase_energetica, 
        a.emisiones, 
        a.consumos,
        b.peso
from 
(
SELECT *
FROM
	(
	    SELECT * 
	    FROM bu_esg_work.reparticao_garantias_final_Jun24
	) GAR
	LEFT JOIN
	(
	    SELECT *
	    FROM bu_esg_work.gloval_clase_energetica_Jun24
	) CERT_ENERG
	ON CONCAT(GAR.ckbalbem,GAR.ckctabem,GAR.ckrefbem) = chave_banco_atual
)
as a
inner join 
(
    select *
    from bu_esg_work.rf_pilar3_pesos_Jun24
) as b
on a.cempresa_ct = b.cempresa_ct
and a.cbalcao_ct = b.cbalcao_ct
and a.cnumecta_ct = b.cnumecta_ct
and a.zdeposit_ct = b.zdeposit_ct
and coalesce(a.ckbalbem,'0') = coalesce(b.ckbalbem, '0')
and coalesce(a.ckctabem,'0') = coalesce(b.ckctabem, '0')
and coalesce(a.ckrefbem,'0') = coalesce(b.ckrefbem, '0')
;

