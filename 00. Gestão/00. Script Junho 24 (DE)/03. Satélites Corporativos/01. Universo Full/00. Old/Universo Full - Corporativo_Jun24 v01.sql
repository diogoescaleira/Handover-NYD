---------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | Código para geração do universo de contratos por satélite                             --
---------------------------------------------------------------------------------------------------------------------
-- Neyond 2023                                                                                                     --
---------------------------------------------------------------------------------------------------------------------
-- 1.286 registos pilot jun23
-- 1.287 registos dez23
-- 1.287 registos jun24 (Dados Dez23)
---- drop table if exists bu_esg_work.pilar3_satelites_idcomb_Jun24;
create table
    bu_esg_work.pilar3_satelites_idcomb_Jun24 (
        csatelite tinyint,
        gsatelite string,
        idcomb string,
        idcomb01 string,
        idcomb02 string,
        idcomb03 string,
        idcomb04 string,
        idcomb05 string,
        idcomb06 string,
        idcomb07 string,
        idcomb08 string,
        idcomb09 string,
        idcomb10 string,
        idcomb11 string
    ) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE;

DESCRIBE EXTENDED bu_esg_work.pilar3_satelites_idcomb_Jun24;

INVALIDATE METADATA bu_esg_work.pilar3_satelites_idcomb_Jun24;

--Definição de data de reporte
ref_fate = "${ref_date}"
-- Substituição dos IDcombs '' por NULL
-- 1.286 registos pilot jun23
-- 1.287 registos dez23
-- 1.287 registos jun24 (Dados dez23)
-- drop table bu_esg_work.rf_pilar3_satelites_idcomb_v2_Jun24;
create table
    bu_esg_work.rf_pilar3_satelites_idcomb_v2_Jun24 as
select distinct
    csatelite,
    gsatelite,
    replace (idcomb, '.', ';') as idcomb,
    -- Se a repartição do IdComb for vazia vai buscar NULL se não, vai buscar a repartição do IdComb
    case
        when (idcomb01 like '') then null
        else idcomb01
    end as idcomb01,
    case
        when (idcomb02 like '') then null
        else idcomb02
    end as idcomb02,
    case
        when (idcomb03 like '') then null
        else idcomb03
    end as idcomb03,
    case
        when (idcomb04 like '') then null
        else idcomb04
    end as idcomb04,
    case
        when (idcomb05 like '') then null
        else idcomb05
    end as idcomb05,
    case
        when (idcomb06 like '') then null
        else idcomb06
    end as idcomb06,
    case
        when (idcomb07 like '') then null
        else idcomb07
    end as idcomb07,
    case
        when (idcomb08 like '') then null
        else idcomb08
    end as idcomb08,
    case
        when (idcomb09 like '') then null
        else idcomb09
    end as idcomb09,
    case
        when (idcomb10 like '') then null
        else idcomb10
    end as idcomb10,
    case
        when (idcomb11 like '') then null
        else idcomb11
    end as idcomb11
from
    bu_esg_work.pilar3_satelites_idcomb_Jun24;

-- Informação da CT001 - IDcombo a vazio é colocado um ';' para cruzar com a info da corporação p/ contratos ativos 
-- 11.978.935 registos correspondentes a 6.560.595 contratos distintos piloto jun23
-- 11.804.009 registos correspondentes a 6.512.884 contratos distintos dez23
-- 11.805.195 Dez23 -> Nova corrida Dez23
-- 11.806.340 jun24 (Dados dez23) -> Mais registos apenas da natureza CMAH introduzidos no universo porque a tabela CT001 foi alterada em Abril
-- drop table bu_esg_work.rf_pilar3_ct001_Jun24_v2;
create table
    bu_esg_work.rf_pilar3_ct001_Jun24_v2 as
select
    ct001.*,
    split_part (ccontab_final_idcomb, ';', 01) as idcomb01,
    case
        when split_part (ccontab_final_idcomb, ';', 02) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 02)
    end as idcomb02,
    case
        when split_part (ccontab_final_idcomb, ';', 03) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 03)
    end as idcomb03,
    case
        when split_part (ccontab_final_idcomb, ';', 04) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 04)
    end as idcomb04,
    case
        when split_part (ccontab_final_idcomb, ';', 05) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 05)
    end as idcomb05,
    case
        when split_part (ccontab_final_idcomb, ';', 06) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 06)
    end as idcomb06,
    case
        when split_part (ccontab_final_idcomb, ';', 07) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 07)
    end as idcomb07,
    case
        when split_part (ccontab_final_idcomb, ';', 08) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 08)
    end as idcomb08,
    case
        when split_part (ccontab_final_idcomb, ';', 09) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 09)
    end as idcomb09,
    case
        when split_part (ccontab_final_idcomb, ';', 10) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 10)
    end as idcomb10,
    case
        when split_part (ccontab_final_idcomb, ';', 11) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 11)
    end as idcomb11,
    case
        when split_part (ccontab_final_idcomb, ';', 12) = '' then ";"
        else split_part (ccontab_final_idcomb, ';', 12)
    end as idcomb12
from
    (
        select
            *
        from
            cd_captools.ct001_univ_saldo
        where
            ref_date = "${ref_date}"
            and flag_ativo = 1
            and cempresa in ('00100', '31', '89')
    ) AS ct001;

-- Filtrar informação da tabela FR012 para a data de referência de reporte, código corporativo do Santander Portugal e saldo > 0
-- Registos: 10.101.133 correspondentes a 5.926.468 contratos distintos | piloto jun23    
-- Registos: 10.068.531 correspondentes a 5.927.137 contratos distintos | dez23
-- Registos: 10.068.547 -> Nova corrida Dez23
-- Registos: 10.069.401 Jun24 (Dados Dez23) -> Temos mais 873 registos da natureza de CMAH e perdemos 19 face ao exercicio anterior (a tabela fr012 foi alterada em Abril)
-- drop table bu_esg_work.rf_pilar3_nm001_Jun24_v2;
create table
    bu_esg_work.rf_pilar3_nm001_Jun24_v2 as
select
    *
from
    cd_captools.fr012_master_cto
where
    ref_date = "${ref_date}"
    and trim(codigo_espanha) = '00411'
    and abs(msaldo_final) > 0;

-- Informação de todos os IDcombs da FR012 
-- 1.488 IDcombs distintos (Piloto Junho 2023)
-- 1.429 IDcombs distintos (Dez 2023)
-- 1.444 IDcombs distintos (Dez 2023) -> Nova corrida Dez23
-- 1.460 IDCombs distintos (Jun24 - Dados de Dez23)
-- drop table bu_esg_work.rf_pilar3_fr012_idcombs_Jun24_v2;
create table
    bu_esg_work.rf_pilar3_fr012_idcombs_Jun24_v2 as
select
    ccontab_final_idcomb_total as idcomb_fr012,
    count(*)
from
    bu_esg_work.rf_pilar3_nm001_Jun24_v2
group by
    1
order by
    1;

-------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- Base Universo Satélites ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-- Tabela com os IDcomb das satélite + Idcomb da FR012 para posterior mapeamento
-- 1.841 registos | teste dez com dados de jun23
-- 1.720 registos | Dez23
-- 1.731 registos | Dez23 -> Nova corrida Dez23
-- 1.744 registos | Jun24 (Dados de Dez23)
-- drop table bu_esg_work.rf_pilar3_satelite_fr012_v2_Jun24_v2;
create table
    bu_esg_work.rf_pilar3_satelite_fr012_v2_Jun24_v2 as
select distinct
    a.csatelite,
    a.gsatelite,
    a.idcomb as idcomb_satelite,
    b.idcomb_fr012
from
    bu_esg_work.rf_pilar3_satelites_idcomb_v2_Jun24 a, -- tabela inicial do processo com IDcombs da corporação 
    bu_esg_work.rf_pilar3_fr012_idcombs_Jun24_v2 b -- tabela com IDcombs da FR012 
where
    locate (
        coalesce(concat (";", a.idcomb01), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and -- vai buscar ou a repartição o ; porque o ; vai existir em qualquer repartição da FR012 (IDcomb mais completo do que é preciso da corporação)
    locate (
        coalesce(concat (";", a.idcomb02), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb03), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb04), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb05), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb06), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb07), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb08), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb09), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb10), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
    and locate (
        coalesce(concat (";", a.idcomb11), ";"),
        concat (";", b.idcomb_fr012)
    ) > 0
order by
    1,
    2,
    3;

-- Passagem pelo tradutor de chaves -> (Satélites -> FR012 -> KT -> CT001)
-- 1º Passo: Ir buscar as chaves FinRep 
-- 5.511.332 | teste dez com dados de jun23
-- 5.430.112 | Dez23
-- 5.430.134 | Dez23 -> Nova corrida Dez23
-- 5.430.580 | Jun24 (Dados de Dez23) (446 a mais face a Dez23 - os registos que estão a mais são de caracter CMAH) 
-- drop table if exists bu_esg_work.rf_pilar3_univ_fr012_v2_Jun24_v2;
create table
    bu_esg_work.rf_pilar3_univ_fr012_v2_Jun24_v2 as
select
    a.csatelite,
    a.idcomb_satelite,
    a.idcomb_fr012,
    b.cempresa as cempresa_fr012,
    b.cbalcao as cbalcao_fr012,
    b.cnumecta as cnumecta_fr012,
    b.zdeposit as zdeposit_fr012,
    b.cod_ajust,
    b.sociedade_contraparte,
    b.msaldo_final as saldo_fr012
    -- Selecionar os IDcombs da FR012 e da Satélite inicial
from
    (
        select distinct
            csatelite,
            idcomb_satelite,
            idcomb_fr012
        from
            bu_esg_work.rf_pilar3_satelite_fr012_v2_Jun24_v2
    ) as a
    -- Cruzar com a FR012 para ir buscar a chave FinRep - Já identificados os IDcombs que interessam, vamos depois à FR012 buscar os contratos que nos interessam
    left join bu_esg_work.rf_pilar3_nm001_Jun24_v2 as b on a.idcomb_fr012 = b.ccontab_final_idcomb_total;

-- 2º Passo: Passar pelo tradutor de chaves 
-- 7.645.433 | teste dez com dados de jun23
-- 7.479.533 | Dez23 
-- 7.479.555 | Dez23 -> Nova corrida Dez23
-- 7.480.001 | Jun24 (Dados de Dez23) (446 a mais face a Dez23 - os registos que estão a mais são de caracter CMAH) 
-- drop table if exists bu_esg_work.rf_pilar3_tabaux_ct_v2_Jun24_v2;
create table
    bu_esg_work.rf_pilar3_tabaux_ct_v2_Jun24_v2 as
select
    a.*,
    c.cempresa as cempresa_ct,
    c.cbalcao as cbalcao_ct,
    c.cnumecta as cnumecta_ct,
    c.zdeposit as zdeposit_ct
from
    bu_esg_work.rf_pilar3_univ_fr012_v2_Jun24_v2 as a
    left join (
        select
            *
        from
            cd_captools.kt_chaves_finrep
        where
            ref_date = "${ref_date}"
    ) as c on a.cempresa_fr012 = c.cempresa_fr
    and a.cbalcao_fr012 = c.cbalcao_fr
    and a.cnumecta_fr012 = c.cnumecta_fr
    and a.zdeposit_fr012 = c.zdeposit_fr;

-- Criação da tabela com o universo completo para reporte corporativo -> 8.965.950 registos
-- 8.983.638 piloto jun23
-- 8.645.565 Dez23
-- 8.645.605 Dez23 -> Nova corrida Dez23
-- 8.643.842 Jun24 (Dados de Dez23) 
insert overwrite table bu_esg_work.RF_PILAR3_UNIVERSO_FULL partition (ID_CORRIDA, DT_RFRNC)
--create table  bu_esg_work.RF_PILAR3_UNIVERSO_FULL_Jun24 as
select
    csatelite,
    idcomb_satelite,
    idcomb_fr012,
    cempresa_fr012,
    cbalcao_fr012,
    cnumecta_fr012,
    zdeposit_fr012,
    cod_ajust,
    sociedade_contraparte,
    saldo_fr012,
    cempresa_ct,
    cbalcao_ct,
    cnumecta_ct,
    zdeposit_ct,
    sociedade_contraparte_ct,
    idcomb_ct,
    pcsb_ct,
    cargabal_ct,
    ifrs_ct,
    cod_ajust_ct, --campo da estrutura do satélite
    saldo_ct, -- não é igual ao contrato FR porque 1 contrato FR pode estar alocado a n contratos da CT   
    PS_DATE,
    -- Particao
    CAST(NEW_ID_CORRIDA AS STRING) as ID_CORRIDA,
    DT_RFRNC
from
    (
        select distinct
            a.csatelite,
            a.idcomb_satelite,
            a.idcomb_fr012,
            a.cempresa_fr012,
            a.cbalcao_fr012,
            a.cnumecta_fr012,
            a.zdeposit_fr012,
            a.cod_ajust,
            a.sociedade_contraparte,
            a.saldo_fr012,
            a.cempresa_ct,
            a.cbalcao_ct,
            a.cnumecta_ct,
            a.zdeposit_ct,
            b.sociedade_contraparte as sociedade_contraparte_ct,
            b.ccontab_final_idcomb as idcomb_ct,
            b.ccontab_final_pcsb as pcsb_ct,
            b.ccontab_final_cargabal as cargabal_ct,
            b.ccontab_final_ifrs as ifrs_ct,
            b.cod_ajust as cod_ajust_ct, --campo da estrutura do satélite
            b.msaldo_final as saldo_ct, -- não é igual ao contrato FR porque 1 contrato FR pode estar alocado a n contratos da CT   
            strleft (cast(current_timestamp() as STRING), 10) as PS_DATE,
            '${ref_date}' as DT_RFRNC
        from
            bu_esg_work.rf_pilar3_tabaux_ct_v2_Jun24_v2 as a,
            bu_esg_work.rf_pilar3_ct001_Jun24_v2 as b
        where
            locate (b.idcomb01, a.idcomb_fr012) > 0
            and locate (b.idcomb02, a.idcomb_fr012) > 0
            and locate (b.idcomb03, a.idcomb_fr012) > 0
            and locate (b.idcomb04, a.idcomb_fr012) > 0
            and locate (b.idcomb05, a.idcomb_fr012) > 0
            and locate (b.idcomb06, a.idcomb_fr012) > 0
            and locate (b.idcomb07, a.idcomb_fr012) > 0
            and locate (b.idcomb08, a.idcomb_fr012) > 0
            and locate (b.idcomb09, a.idcomb_fr012) > 0
            and locate (b.idcomb10, a.idcomb_fr012) > 0
            and locate (b.idcomb11, a.idcomb_fr012) > 0
            and locate (b.idcomb12, a.idcomb_fr012) > 0
            and a.cempresa_ct = b.cempresa
            and a.cbalcao_ct = b.cbalcao
            and a.cnumecta_ct = b.cnumecta
            and a.zdeposit_ct = b.zdeposit
            and a.cod_ajust = b.cod_ajust
    ) x
    left join (
        Select
            nvl (max(CAST(ID_CORRIDA AS INT)), 0) + 1 as NEW_ID_CORRIDA
        from
            bu_esg_work.RF_PILAR3_UNIVERSO_FULL
    ) ID_COR on 1 = 1;

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- Controlos & Validações -----------------------------------------
---------------------------------------------------------------------------------------------------------------------
-- validar saldo por satélite e comparar
select
    a.csatelite,
    a.cont_dez23,
    a.saldo_dez23,
    b.cont_Jun24,
    b.saldo_Jun24,
    b.cont_Jun24 - a.cont_dez23 as dif_count,
    b.saldo_Jun24 - a.saldo_dez23 as dif_saldo
from
    (
        SELECT
            csatelite,
            count(*) as cont_dez23,
            sum(saldo_ct) as saldo_dez23
        FROM
            bu_esg_work.RF_PILAR3_UNIVERSO_FULL
        WHERE
            dt_rfrnc = '${ref_date_jun}'
        GROUP BY
            csatelite
    ) a
    left join (
        SELECT
            count(*) as cont_Jun24,
            sum(saldo_ct) as saldo_Jun24,
            csatelite
        FROM
            bu_esg_work.RF_PILAR3_UNIVERSO_FULL
        WHERE
            dt_rfrnc = '${ref_date_dez}'
        GROUP BY
            csatelite
    ) b on a.csatelite = b.csatelite
    -- Resumo dos saldos presentes nas satélites (com adjudicados %MC10% - bens tangíveis)
select
    sum(saldo_ct),
    csatelite
from
    bu_esg_work.rf_pilar3_universo_full
where
    DT_RFRNC = '${ref_date}'
group by
    csatelite
order by
    2 asc;

-- Resumo dos saldos presentes nas satélites (sem adjudicados %MC10% - bens tangíveis)
select
    csatelite,
    sum(saldo_ct)
from
    bu_esg_work.rf_pilar3_universo_full
where
    DT_RFRNC = '${ref_date}'
    and idcomb_ct not like '%MC10%'
group by
    1;

-- Resumo do saldo da satélite por IDcomb
select
    idcomb_ct,
    sum(saldo_ct)
from
    bu_esg_work.rf_pilar3_universo_full
where
    DT_RFRNC = '${ref_date}'
    and idcomb_ct not like '%MC10%'
group by
    1;

Select
    *
from
    (
        select
            idcomb_ct,
            sum(saldo_ct)
        from
            bu_esg_work.rf_pilar3_universo_full
        where
            DT_RFRNC = '${ref_date}'
            and idcomb_ct not like '%MC10%'
        group by
            1
        order by
            1 asc
    ) A
    full outer join (
        select
            idcomb_ct,
            sum(saldo_ct)
        from
            bu_esg_work.rf_pilar3_universo_full_Jun24
        where
            DT_RFRNC = '${ref_date}'
            and idcomb_ct not like '%MC10%'
        group by
            1
        order by
            1 asc
    ) B on A.idcomb_ct = B.idcomb_ct;

-- Validação de colunas sem estarem a NULL
Select
    *
from
    bu_esg_work.RF_PILAR3_UNIVERSO_FULL
where
    DT_RFRNC = '${ref_date}'
    and csatelite is null
    or idcomb_satelite is null
    or idcomb_fr012 is null
    or cempresa_fr012 is null
    or cbalcao_fr012 is null
    or cnumecta_fr012 is null
    or zdeposit_fr012 is null
    or cod_ajust is null
    or sociedade_contraparte is null
    or saldo_fr012 is null
    or cempresa_ct is null
    or cbalcao_ct is null
    or cnumecta_ct is null
    or zdeposit_ct is null
    or sociedade_contraparte_ct is null
    or idcomb_ct is null
    or cargabal_ct is null
    or cod_ajust_ct is null
    or saldo_ct is null
    or ifrs_ct is null;