-- NOTAS PARA FUTURO:
-- - O campo "nome_atributo_dim" é MEGA inconstante, temos de standardizar o ataque e filtragens com este campo, ISTO É CRITICO
-- - Nas Queries: query_for_filter_for_query__0030 e query_for_filter_for_query__003b os campos sum_of_mcoberto_me e sum_of_mcoberto_eu estão trocados entre o que vem da tabela fonte e onde acabam no destino ver pasta "Erros detetados", ao lado dos scripts originais
-- - Talvez tenha de ter de vir a adaptar algumas destas queries visto que o hive não aceita nomes de variaveis criadas nos select, serem usadas nos group bys, este problema trornar-se-a aparente se correr a query T30.01 no HIVE
-- - Está sempre a ser utilizado o ccontab_final_ifrs embora também se tenha de produzir este report para o SGPS_CONSOLIDADO


-- Queries a converter:
-- balanco_ind;---------------------------------- DONE
-- ct008_refdate;-------------------------------- DONE
-- query_for_ct007_pv_planos;-------------------- DONE
-- filter_for_ct011_dim_hier;-------------------- DONE
-- filter_for_ct010_dim_valor;------------------- DONE
-- filter_for_ct063_univ_pme;-------------------- DONE
-- filter_for_ct081_finrep;---------------------- DONE
-- filter_for_ct004_univ_cto;-------------------- DONE
-- filter_for_ct003_univ_cli;-------------------- DONE
-- filter_for_clientes_intragrupo;--------------- DONE
-- query_for_perimetro;-------------------------- DONE
-- filter_for_al001_cnt_core;-------------------- DONE
-- query_for_ct008_refdate;---------------------- DONE
-- filter_for_ct010_dim_valor_0000;-------------- DONE
-- filter_for_ct010_dim_valor_0001;-------------- DONE
-- query_for_filter_for_clientes_in;------------- DONE
-- query_for_filter_for_al001__0000;------------- DONE
-- query_for_filter_for_ct008_pv_co;------------- DONE
-- query_for_filter_for_ct081__0000;------------- DONE
-- passivo;-------------------------------------- DONE
-- ativo;---------------------------------------- DONE
-- query_for_filter_for_ct008__0001;------------- DONE
-- query_for_filter_for_ct081;------------------- DONE
-- query_for_filter_for_ct010_dim_v;------------- DONE
-- query_for_filter_for_ct010__0000;------------- DONE
-- query_for_filter_for_ct010__0001;------------- DONE
-- query_for_filter_for_ct010__0002;------------- DONE
-- query_for_balanco_ind_0000;------------------- DONE
-- query_for_filter_for_ct001_0005;-------------- DONE
-- query_for_filter_for_ct001_0006;-------------- DONE
-- query_for_filter_for_ct001_0008;-------------- DONE
-- query_for_filter_for_ct001;------------------- DONE
-- query_for_filter_for_ct001_0007;-------------- DONE
-- query_for_filter_for_ct001_0009;-------------- DONE
-- query_for_filter_for_ct001_000f;-------------- DONE
-- ldrmasterindividual202212;-------------------- DONE
-- query_for_ldrmaster;-------------------------- DONE
-- query_for_al015_act_fin;---------------------- DONE
-- filter_for_ct610_titulos;--------------------- DONE
-- filter_for_ct069_univ_gr_ec_0000;------------- DONE
-- filter_for_ct070_univ_gr_cl_0000;------------- DONE
-- query_for_ldrmaster_0004;--------------------- DONE - Não adaptei esta query na T03.01, ela filtra a query_for_ldrmaster t1 através de cod_contavirt = 'C_32' mas mais à frente estes contratos são de novo excluidos na QUERY_FOR_APPEND_TABLE_0001 (WHERE t1.cod_contavirt <> 'C_32' OR t1.cod_contavirt IS NULL;)
-- QUERY_FOR_LDRMASTER_0005_0000;---------------- DONE
-- query_for_ldrmaster_0005_00_0002;------------- DONE
-- filter_for_query_for_ldrmas_000e;------------- DONE
-- filter_for_query_for_ldrmas_0002;------------- DONE
-- filter_for_query_for_ldrmas_000c;------------- DONE
-- filter_for_query_for_ldrmaster;--------------- DONE
-- query_for_ldrmaster_0007;--------------------- DONE
-- filter_for_query_for_ldrmas_0006;------------- DONE
-- query_for_ldrmaster_0013;
-- query_for_ldrmaster_0014;
-- query_for_ldrmaster1;
-- query_for_ldrmaster_0011;
-- FILTER_FOR_FG001_FGD;------------------------- DONE
-- filter_for_fg001_fgd_0000;-------------------- DONE
-- FILTER_FOR_CQ_ISDA_0000;---------------------- DONE
-- query_for_filter_for_query_0015;
-- query_for_filter_for_ct610_titul;------------- DONE
-- query_for_filter_for_ct069__0000;------------- DONE
-- filter_for_t_06_01_zclientes_22;-------------- DONE
-- filter_for_balencete_22;---------------------- DONE
-- query_for_ldrmaster_0000;--------------------- DONE
-- query_for_ldrmaster_0005;--------------------- DONE - Não adaptei esta query na T03.01, pelas mesmas razões da query_for_ldrmaster_0004 contratos são de novo excluidos na QUERY_FOR_APPEND_TABLE_0001 (WHERE t1.cod_contavirt <> 'C_32' OR t1.cod_contavirt IS NULL;)
-- filter_for_query_for_ldrmas_000d;------------- DONE
-- query_for_ldrmaster_0005_00;------------------ DONE
-- query_for_filter_for_query__0034;------------- DONE
-- query_for_filter_for_query__003d;------------- DONE
-- validacao_balanco_2;
-- validacao_balanco;
-- query_for_filter_for_query__001f;------------- DONE
-- query_for_filter_for_query__002c;------------- DONE
-- query_for_filter_for_query__002e;------------- DONE
-- query_for_filter_for_query_for_l;
-- query_for_filter_for_query__000f;------------- DONE
-- query_for_filter_for_query_fo;
-- filter_for_query_for_ldrmaster_0;------------- DONE
-- query_for_filter_for_query__0013;------------- DONE
-- query_for_ldrmaster_0005_00_0001;------------- DONE
-- query_for_ldrmaster1_0001;
-- query_for_ldrmaster1_0001_0000;
-- query_for_ldrmaster1_0000;
-- query_for_ldrmaster_000e;
-- query_for_filter_for_fg001_fgd;--------------- DONE
-- query_for_ldrmaster_0018;--------------------- DONE
-- query_for_ldrmaster_000a;--------------------- DONE
-- query_for_ldrmaster_000a_0000;---------------- DONE
-- QUERY_FOR_FILTER_FOR_QUERY__0037;------------- DONE
-- QUERY_FOR_LDRMASTER_0005_00_0007;------------- DONE
-- query_for_filter_for_query__0031;------------- DONE
-- query_for_filter_for_query__0032;------------- DONE
-- filter_for_query_for_ldrmas_0009;------------- DONE
-- query_for_filter_for_query__002f;------------- DONE
-- query_for_al015_act_fin_0000;----------------- DONE
-- query_for_ldrmaster2_0001;
-- query_for_filter_for_query__0015;------------- DONE
-- query_for_filter_for_query__0025;
-- QUERY_FOR_FILTER_FOR_QUERY__003A;
-- filter_for_query_for_filter_0007;------------- DONE
-- query_for_filter_for_query_0043;
-- query_for_filter_for_query_000e;
-- query_for_ldrmaster_0005_00_0003;------------- DONE
-- query_for_filter_for_fg001_fgd1;
-- query_for_filter_for_query__0020;
-- query_for_ldrmaster_000a_0001;---------------- DONE
-- filter_for_query_for_ldrmas_0008;------------- DONE
-- query_for_filter_for_query_0033;-------------- DONE
-- query_for_filter_for_query_0045;-------------- DONE
-- query_for_filter_for_query__0039;
-- query_for_filter_for_query__0029;
-- filter_for_query_for_ldrmas_000a;------------- DONE
-- filter_for_query_for_ldrmas_000b;------------- DONE
-- query_for_filter_for_query__0024;------------- DONE
-- query_for_filter_for_query__0023;------------- DONE
-- QUERY_FOR_AL015_ACT_FIN_0001;----------------- DONE
-- query_for_ldrmaster2_0002;
-- QUERY_FOR_FILTER_FOR_QUERY_003C;-------------- DONE
-- filter_for_query_for_filter;------------------ DONE
-- filter_for_query_for_filter_0006;
-- query_for_filter_for_query2;
-- query_for_filter_for_query_001d;
-- query_for_filter_for_query_001e;
-- filter_for_query_for_ldrmas_0007;------------- DONE
-- query_for_filter_for_query__0022;------------- DONE
-- query_for_filter_for_query_0037;-------------- DONE
-- query_for_filter_for_query_0029;
-- query_for_filter_for_query__0011;------------- DONE
-- query_for_filter_for_query__0017;------------- DONE
-- query_for_filter_for_query;------------------- DONE
-- query_for_filter_for_query__0033;------------- DONE
-- query_for_ldrmaster_0005_00_0004;------------- DONE
-- query_for_filter_for_query__001a;------------- DONE
-- query_for_filter_for_query_0030;-------------- DONE
-- query_for_filter_for_query__002d;------------- DONE
-- query_for_filter_for_query_0038;-------------- DONE
-- query_for_filter_for_query_002a;
-- query_for_filter_for_query_0022;-------------- DONE
-- filter_for_query_for_filter_0004;------------- DONE
-- filter_for_query_for_filter_0005;------------- DONE
-- query_for_filter_for_query_002f;-------------- DONE
-- query_for_filter_for_balencete;
-- QUERY_FOR_FILTER_FOR_BALENC_0000;------------- DONE
-- query_for_filter_for_query_004b;
-- QUERY_FOR_LDRMASTER_0005_00_0005;------------- DONE
-- query_for_filter_for_query__002a;------------- DONE
-- query_for_filter_for_query__002b;------------- DONE
-- query_for_filter_for_query_0036;-------------- DONE
-- query_for_filter_for_query_0023;-------------- DONE
-- query_for_filter_for_query__0019;------------- DONE
-- query_for_filter_for_query__001e;
-- query_for_filter_for_query__0028;------------- DONE
-- query_for_filter_for_query__003b;------------- DONE
-- query_for_filter_for_query__0030;
-- query_for_filter_for_query_0032;-------------- DONE
-- query_for_filter_for_query_003b;-------------- DONE
-- filter_for_query_for_filter_for_;------------- DONE
-- filter_for_query_for_filter_0001;------------- DONE
-- query_for_filter_for_query_002b;
-- QUERY_FOR_FILTER_FOR_QUERY_0046;-------------- DONE
-- query_for_filter_for_query_0040;
-- query_for_filter_for_query_0034;-------------- DONE
-- QUERY_FOR_FILTER_FOR_QUERY__0027;------------- DONE
-- query_for_filter_for_query__001b;------------- DONE
-- query_for_filter_for_query__001d;
-- query_for_filter_for_query_for_f;------------- DONE
-- query_for_filter_for_query_0049;
-- query_for_filter_for_query_003a;-------------- DONE
-- query_for_filter_for_query_0048;
-- query_for_filter_for_query__001c;
-- query_for_filter_for_query_0028;--------------- DONE
-- query_for_filter_for_query__0038;-------------- DONE
-- query_for_filter_for_query_002c;
-- query_for_filter_for_query_002d;--------------- DONE
-- append_table_0000;----------------------------- DONE: É exatamente igual à query_for_filter_for_query__0038 devido à explicação das queries 'query_for_ldrmaster_0005' e 'query_for_ldrmaster_0004'
-- query_for_filter_for_query_003d;
-- query_for_filter_for_query_0041;
-- query_for_filter_for_query_0047;
-- query_for_filter_for_query__0018;
-- QUERY_FOR_FILTER_FOR_QUERY__0026;-------------- DONE
-- query_for_append_table;------------------------ DONE
-- QUERY_FOR_APPEND_TABLE_0001;------------------- DONE: É exatamente igual à query_for_append_table
-- query_for_append_table_0002;



--------------------------------------------------------------------------VARIAVEIS INICIAIS----------------------------------------------------------------------------------------------------------------------

SET VAR:REFDATE	= '2023-10-31';
SET VAR:PERIMETRO = 'Individual Local';
SET VAR:DATADATEPART = '2023-10-31';

----------------------------------------------------------------------------DROPS INICIAIS------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS bu_captools_work.test1_query_for_balanco_ind_0000 purge;         --Tabela auxiliar
--DROP TABLE IF EXISTS bu_captools_work.test1_query_for_filter_for_ct081 purge;         --Tabela auxiliar
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_ldrmaster purge;                --Tabela auxiliar
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_append_table_0001 purge;        --T03.01
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_filter_for_query__0037 purge;   --T03.02
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_ldrmaster_0005_00_0007 purge;   --T03.03
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_filter_for_query__0027 purge;   --T04.00
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_filter_for_query__0026 purge;   --T05.01
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_filter_for_query_0046 purge;    --T06.01
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_al015_act_fin_0001 purge;       --T07.00
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_filter_for_query_003c purge;    --T08.00
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_filter_for_balenc_0000 purge;   --T09.00
DROP TABLE IF EXISTS bu_captools_work.test1_query_for_ldrmaster_0005_00_0005 purge;   --T12.00

-----------------------------------------------------------------------CRIAR TABELAS AUXILIARES-------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_balanco_ind_0000 AS
  SELECT ct001.cempresa,
         ct001.cbalcao,
         ct001.cnumecta,
         ct001.zdeposit,
         ct001.zcliente,
         ct001.descritivo,
         ct001.cmoeda,
         ct001.msaldo_final,
         ct001.ccontab_final_pcsb,
         ct001.ccontab_final_sgps_cons,
         ct001.ccontab_final_ifrs,
         ct001.flag_ativo,
         ct00_7_8.cod_contavirt,
         ct00_7_8.nome_contavirt,
         ct010_conta.nome_atributo_dim,
         ct010_dim3.nome_atributo_dim AS nome_atributo_dim3,
         ct010_dim4.nome_atributo_dim AS nome_atributo_dim4,
         ct010_dim5.nome_atributo_dim AS nome_atributo_dim5,
         ct001.ref_date
  FROM
  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, descritivo, cmoeda, msaldo_final, ccontab_final_pcsb,
         ccontab_final_ifrs, ccontab_final_sgps_cons, flag_ativo, ref_date
    FROM cd_captools.ct001_univ_saldo
    WHERE ref_date=${VAR:REFDATE}
    AND flag_ativo=1
  ) AS ct001

  INNER JOIN

  (
    SELECT cbalcao, cempresa, cnumecta, zdeposit, zcliente, nome_perimetro, ref_date
    FROM cd_captools.ct005_univ_perim
    WHERE ref_date=${VAR:REFDATE}
    AND nome_perimetro=${VAR:PERIMETRO}
  ) AS ct005
  ON  (ct001.cbalcao = ct005.cbalcao)
  AND (ct001.cempresa = ct005.cempresa)
  AND (ct001.cnumecta = ct005.cnumecta)
  AND (ct001.zdeposit = ct005.zdeposit)
  AND (ct001.zcliente = ct005.zcliente)

  LEFT JOIN

  (
      SELECT ct008.cod_plano, ct008.conta, ct007.cod_contavirt, ct007.nome_contavirt FROM
      (
        SELECT cod_plano, cod_contavirt, conta
        FROM cd_captools.ct008_pv_contas
        WHERE ref_date=${VAR:REFDATE}
        AND cod_plano = 'BST_IFRS_IFRS'
      ) AS ct008

      INNER JOIN

      (
        SELECT cod_plano, cod_contavirt, nome_contavirt
        FROM cd_captools.ct007_pv_planos t1
        WHERE ref_date=${VAR:REFDATE}
      ) AS ct007
      ON  ct008.cod_plano = ct007.cod_plano
      AND ct008.cod_contavirt = ct007.cod_contavirt
  ) as ct00_7_8
  ON ct00_7_8.conta=ct001.ccontab_final_ifrs

  LEFT JOIN

  (
    SELECT cod_atributo_dim, nome_atributo_dim
    FROM cd_captools.ct010_dim_valor
    WHERE ref_date = ${VAR:REFDATE}
    AND id_dimensao = 44
  ) AS ct010_conta
  ON ct00_7_8.conta = ct010_conta.cod_atributo_dim

  LEFT JOIN

  (
    SELECT nivel_3, nivel_4, nivel_5, nivel_12
    FROM cd_captools.ct011_dim_hier
    WHERE ref_date=${VAR:REFDATE}
    AND id_dimensao = 44
  ) AS ct011
  ON ct00_7_8.conta = ct011.nivel_12

  LEFT JOIN

  (
    SELECT cod_atributo_dim, nome_atributo_dim
    FROM cd_captools.ct010_dim_valor
    WHERE ref_date = ${VAR:REFDATE}
    AND id_dimensao = 44
  ) AS ct010_dim3
  ON ct010_dim3.cod_atributo_dim = ct011.nivel_3

  LEFT JOIN

  (
    SELECT cod_atributo_dim, nome_atributo_dim
    FROM cd_captools.ct010_dim_valor
    WHERE ref_date = ${VAR:REFDATE}
    AND id_dimensao = 44
  ) AS ct010_dim4
  ON ct010_dim4.cod_atributo_dim = ct011.nivel_4

  LEFT JOIN

  (
    SELECT cod_atributo_dim, nome_atributo_dim
    FROM cd_captools.ct010_dim_valor
    WHERE ref_date = ${VAR:REFDATE}
    AND id_dimensao = 44
  ) AS ct010_dim5
  ON ct010_dim5.cod_atributo_dim = ct011.nivel_5

  GROUP BY ct001.cempresa,
           ct001.cbalcao,
           ct001.cnumecta,
           ct001.zdeposit,
           ct001.zcliente,
           ct001.descritivo,
           ct001.cmoeda,
           ct001.msaldo_final,
           ct001.ccontab_final_pcsb,
           ct001.ccontab_final_ifrs,
           ct001.ccontab_final_sgps_cons,
           ct001.flag_ativo,
           ct001.ref_date,
           ct00_7_8.cod_contavirt,
           ct00_7_8.nome_contavirt,
           ct010_conta.nome_atributo_dim,
           nome_atributo_dim3,
           nome_atributo_dim4,
           nome_atributo_dim5
;


--Esta tabela já não é necessária, a sua informação vem agora da ct003 e fr802

-- CREATE TABLE bu_captools_work.test1_query_for_filter_for_ct081 AS
--   SELECT ct081.cempresa,
--          ct081.cbalcao,
--          ct081.cnumecta,
--          ct081.zdeposit,
--          MIN(ct081.contraparte_i) AS MIN_of_contraparte_i,
--          MIN(ct010_contraparte.nome_atributo_dim) AS MIN_of_contraparte_i_desc
--   FROM
--   (
--     SELECT cempresa, cbalcao, cnumecta, zdeposit, contraparte_i
--     FROM cd_captools.ct081_finrep
--     WHERE ref_date=${VAR:REFDATE}
--     AND contraparte_i <> ''
--   ) AS ct081
--
--   LEFT JOIN
--
--   (
--     SELECT cod_atributo_dim, nome_atributo_dim
--     FROM cd_captools.ct010_dim_valor
--     WHERE ref_date = ${VAR:REFDATE}
--     AND id_dimensao = 43
--   ) AS ct010_contraparte
--   ON ct081.contraparte_i = ct010_contraparte.cod_atributo_dim
--
--   GROUP BY ct081.cempresa,
--            ct081.cbalcao,
--            ct081.cnumecta,
--            ct081.zdeposit
-- ;


-- A ligação entre as tabelas ct001 e al001 está mal feita, tem de passar pelo tradutor de chaves
CREATE TABLE bu_captools_work.test1_query_for_ldrmaster AS
  SELECT balanco_ind.cempresa,
         balanco_ind.cbalcao,
         balanco_ind.cnumecta,
         balanco_ind.zdeposit,
         balanco_ind.zcliente,
         balanco_ind.descritivo,
         balanco_ind.cmoeda,
         balanco_ind.flag_ativo,
         balanco_ind.msaldo_final,
         balanco_ind.ccontab_final_pcsb,
         balanco_ind.ccontab_final_ifrs,
         balanco_ind.cod_contavirt,
         balanco_ind.nome_contavirt,
         balanco_ind.nome_atributo_dim,
         balanco_ind.nome_atributo_dim3,
         balanco_ind.nome_atributo_dim4,
         balanco_ind.nome_atributo_dim5,
         NVL(ct003.contraparte,fr802.contraparte_i) AS contraparte_i_desc,
         ct063.flag_pme,
         ct003.ccae,
         ct003.gcliente,
         ct003.clei,
         ct003.cpais_residencia,
         ct003.ccli_grupo,
         ct003.csector_inst,
         ct004.dabertur,
         ct004.ddvencim,
         clientes_intragrupo.nome AS empresa_intragrupo,
         al001_pas.tx_contrato_pas,
         al001_act.tx_contrato_act,
         perimetro.st_sgps_portugal_ifrs,
         balanco_ind.ref_date
  FROM
  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, descritivo, cmoeda, msaldo_final, ccontab_final_pcsb, ccontab_final_ifrs, flag_ativo,
           cod_contavirt, nome_contavirt, nome_atributo_dim, nome_atributo_dim3, nome_atributo_dim4, nome_atributo_dim5, ref_date,
           IF(${VAR:PERIMETRO} = 'Individual Local', ccontab_final_ifrs, ccontab_final_sgps_cons) as ccontab_final
    FROM bu_captools_work.test1_query_for_balanco_ind_0000
  ) AS balanco_ind

  -- LEFT JOIN
  --
  -- (
  --   SELECT cempresa, cbalcao, cnumecta, zdeposit, MIN_of_contraparte_i, MIN_of_contraparte_i_desc
  --   FROM bu_captools_work.test1_query_for_filter_for_ct081
  -- ) AS filter_for_ct081
  -- ON  balanco_ind.cempresa = filter_for_ct081.cempresa
  -- AND balanco_ind.cbalcao = filter_for_ct081.cbalcao
  -- AND balanco_ind.cnumecta = filter_for_ct081.cnumecta
  -- AND balanco_ind.zdeposit = filter_for_ct081.zdeposit

  LEFT JOIN

  (
    SELECT zcliente, ccli_grupo, gcliente, ccae, clei, cpais_residencia, csector_inst, contraparte
    FROM cd_captools.ct003_univ_cli
    WHERE ref_date=${VAR:REFDATE}
  ) AS ct003
  ON balanco_ind.zcliente = ct003.zcliente

  LEFT JOIN

  (
    SELECT zcliente, cempresa, cbalcao, cnumecta, zdeposit, dabertur, ddvencim
    FROM cd_captools.ct004_univ_cto
    WHERE ref_date=${VAR:REFDATE}
  ) AS ct004
  ON  balanco_ind.cempresa = ct004.cempresa
  AND balanco_ind.cbalcao = ct004.cbalcao
  AND balanco_ind.cnumecta = ct004.cnumecta
  AND balanco_ind.zdeposit = ct004.zdeposit
  AND balanco_ind.zcliente = ct004.zcliente

  LEFT JOIN

  (
    SELECT zcliente, flag_pme
    FROM cd_captools.ct063_univ_pme
    WHERE ref_date=${VAR:REFDATE}
  ) AS ct063
  ON balanco_ind.zcliente = ct063.zcliente

  LEFT JOIN

  (
    SELECT zcliente, nome, consolpt, consoles
    FROM cd_captools.clientes_intragrupo
    WHERE data_date_part=${VAR:DATADATEPART}
  ) AS clientes_intragrupo
  ON  balanco_ind.zcliente = clientes_intragrupo.zcliente

  LEFT JOIN

  (
    SELECT cod_espana, cod_soc_cpus, st_sgps_portugal_ifrs
    FROM cd_captools.perimetro
    WHERE data_date_part=${VAR:DATADATEPART}
  ) AS perimetro
  ON  clientes_intragrupo.consolpt = perimetro.cod_soc_cpus
  AND clientes_intragrupo.consoles = perimetro.cod_espana

  LEFT JOIN

  -- Não se estva a usar o tradutor de chaves para ligar o universo alm com o captools, tomei a liberdade de o fazer
  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, cempresa_master, cbalcao_master, cnumecta_master, zdeposit_master
    FROM cd_alm.kt_chaves_alm_m
    WHERE ref_date=${VAR:REFDATE}
  ) as chaves
  on balanco_ind.cempresa = chaves.cempresa_master
  and balanco_ind.cbalcao = chaves.cbalcao_master
  and balanco_ind.cnumecta = chaves.cnumecta_master
  and balanco_ind.zdeposit = chaves.zdeposit_master

  LEFT JOIN

  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, tx_contrato_pas
    FROM cd_alm.al001_cnt_core
    WHERE ref_date=${VAR:REFDATE}
    AND tx_contrato_pas IS NOT NULL
    GROUP BY cempresa, cbalcao, cnumecta, zdeposit, zcliente, tx_contrato_pas
  ) AS al001_pas
  ON  chaves.cempresa = al001_pas.cempresa
  AND chaves.cbalcao = al001_pas.cbalcao
  AND chaves.cnumecta = al001_pas.cnumecta
  AND chaves.zdeposit = al001_pas.zdeposit
  AND balanco_ind.zcliente = al001_pas.zcliente

  LEFT JOIN

  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, tx_contrato_act
    FROM cd_alm.al001_cnt_core
    WHERE ref_date=${VAR:REFDATE}
    AND tx_contrato_act IS NOT NULL
    GROUP BY cempresa, cbalcao, cnumecta, zdeposit, zcliente, tx_contrato_act
  ) AS al001_act
  ON  chaves.cempresa = al001_act.cempresa
  AND chaves.cbalcao = al001_act.cbalcao
  AND chaves.cnumecta = al001_act.cnumecta
  AND chaves.zdeposit = al001_act.zdeposit
  AND balanco_ind.zcliente = al001_act.zcliente

  LEFT JOIN
  (
    SELECT conta, contraparte_i
    FROM cd_captools.fr802_pl_contas
    WHERE ref_date = ${VAR:REFDATE}
    AND ( instrumento_financeiro <> ''
    OR contraparte_i <> ''
    OR produto <> ''
    OR carteira_contabilistica <> '' )
    AND cod_plano = IF(${VAR:PERIMETRO} = 'Individual Local', 'BST_IND', 'SGPS_CONSOLIDADO')
  ) as fr802
  ON TRIM(balanco_ind.ccontab_final)=fr802.conta

  WHERE balanco_ind.msaldo_final IS NOT NULL

  GROUP BY balanco_ind.cempresa,
           balanco_ind.cbalcao,
           balanco_ind.cnumecta,
           balanco_ind.zdeposit,
           balanco_ind.zcliente,
           balanco_ind.descritivo,
           balanco_ind.cmoeda,
           balanco_ind.flag_ativo,
           balanco_ind.msaldo_final,
           balanco_ind.ccontab_final_pcsb,
           balanco_ind.ccontab_final_ifrs,
           balanco_ind.cod_contavirt,
           balanco_ind.nome_contavirt,
           balanco_ind.nome_atributo_dim,
           balanco_ind.nome_atributo_dim3,
           balanco_ind.nome_atributo_dim4,
           balanco_ind.nome_atributo_dim5,
           contraparte_i_desc,
           ct063.flag_pme,
           ct003.ccae,
           ct003.gcliente,
           ct003.clei,
           ct003.cpais_residencia,
           ct003.ccli_grupo,
           ct003.csector_inst,
           ct004.dabertur,
           ct004.ddvencim,
           empresa_intragrupo,
           al001_pas.tx_contrato_pas,
           al001_act.tx_contrato_act,
           balanco_ind.ref_date,
           perimetro.st_sgps_portugal_ifrs
;


-------------------------------------------------------------------------------------T03.01-----------------------------------------------------------------------------------------------------------------------------------
-- Aqui iremos ter diferenças nos campos SUM_of_mcoberto_eu e SUM_of_mcoberto_me visto que nos script deles são trocados das tabelas fontes, tomei por iniciativa corrigir este lapso (CONFIRMAR NO FUTURO)

CREATE TABLE bu_captools_work.test1_query_for_append_table_0001 AS
  SELECT * FROM
  (
    SELECT ldrmaster.zdeposit,
           ldrmaster.zcliente,
           tat91_206.tayd91c0_gelem30 as cmoeda, -- Coloquei este nome em vez de tayd91c0_gelem301 para ser mais indicativo
           CAST(SUM(IF(ldrmaster.flag_grup=TRUE,ldrmaster.saldos, NULL)) AS DECIMAL(23,6)) AS SUM_of_saldo,
           CAST(SUM(IF(ldrmaster.flag_grup=TRUE,ldrmaster.juros, NULL)) AS DECIMAL(23,6)) AS SUM_of_juros,
           ldrmaster.cod_contavirt,
           ldrmaster.contraparte_i_desc,
           ldrmaster.flag_pme,
           ldrmaster.empresa_intragrupo,
           tat91_015.tayd91c0_gelem30 as cpais_residencia, -- Coloquei este nome em vez de tayd91c0_gelem30 para ser mais indicativo
           CAST(AVG(IF(ldrmaster.flag_grup=TRUE,ldrmaster.tx_contrato_pas_saldos, NULL)) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
           CAST(AVG(IF(ldrmaster.flag_grup=TRUE,ldrmaster.tx_contrato_pas_juros, NULL)) AS DECIMAL(10,5)) AS AVG_of_juros,
           CAST(SUM(IF(ldrmaster.flag_grup=TRUE AND ldrmaster.nome_atributo_dim NOT LIKE '%Juros%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Despesa%', fg001.mcoberto_eur, NULL)) AS DECIMAL(21,8)) AS SUM_of_mcoberto_eu, --Nota que o mcoberto_me e o mcoberto_eur estavam trocados, eu corrigi
           CAST(SUM(IF(ldrmaster.flag_grup=TRUE AND ldrmaster.nome_atributo_dim NOT LIKE '%Juros%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Despesa%', fg001.mcoberto_me, NULL)) AS DECIMAL(21,8)) AS SUM_of_mcoberto_me, --Nota que o mcoberto_me e o mcoberto_eur estavam trocados, eu corrigi
           IF(ldrmaster.flag_grup=TRUE AND ldrmaster.csector_inst LIKE 'S128%', ldrmaster.csector_inst, NULL) as csector_inst, -- Diria que este campo devia estar a ser sempre trazido
           ct610.eleg_fund_prop,
           CAST(SUM(IF(ldrmaster.flag_grup=TRUE,ct610.mon_fund_prop, NULL)) AS DECIMAL(19,2)) AS SUM_of_mon_fund_prop,
           ct610.termo_estruturado,
           ct610.dt_emissao,
           ct610.dt_vencim,
           IF(ldrmaster.flag_grup=TRUE AND ldrmaster.csector_inst LIKE 'S128%', ldrmaster.clei, NULL) as clei, -- Diria que este campo devia estar a ser sempre trazido
           ldrmaster.st_sgps_portugal_ifrs,
           ldrmaster.ref_date
    FROM
    (
      SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, cmoeda, cod_contavirt, nome_atributo_dim, contraparte_i_desc, flag_pme,
             csector_inst, empresa_intragrupo, cpais_residencia, tx_contrato_pas, clei, st_sgps_portugal_ifrs, ref_date,
             IF(nome_atributo_dim NOT LIKE '%Juros%' AND nome_atributo_dim NOT LIKE '%Despesa%',CAST(SUM(msaldo_final) AS DECIMAL(23,6)),NULL) as saldos,
             IF(nome_atributo_dim LIKE '%Juros%' OR nome_atributo_dim LIKE '%Despesa%',msaldo_final,NULL) as juros,
             IF(nome_atributo_dim NOT LIKE '%Juros%' AND nome_atributo_dim NOT LIKE '%Despesa%',tx_contrato_pas,NULL) as tx_contrato_pas_saldos,
             IF(nome_atributo_dim LIKE '%Juros%' OR nome_atributo_dim LIKE '%Despesa%',tx_contrato_pas,NULL) as tx_contrato_pas_juros,
             IF((empresa_intragrupo <> '' AND (cod_contavirt IN ('P_20','P_21','P_22','P_23','P_24','P_27.1','P_27.2','C_33','C_36') OR cod_contavirt LIKE '%P_30%'))
                OR cod_contavirt = 'C_31',
                TRUE,FALSE) as flag_grup
      FROM bu_captools_work.test1_query_for_ldrmaster
      WHERE (cod_contavirt LIKE '%C%' OR cod_contavirt LIKE '%P%')
      GROUP BY cempresa, cbalcao, cnumecta, zdeposit, zcliente, cmoeda, cod_contavirt, nome_atributo_dim, contraparte_i_desc, flag_pme,
               csector_inst, empresa_intragrupo, cpais_residencia, tx_contrato_pas, clei, st_sgps_portugal_ifrs, ref_date,
               juros, tx_contrato_pas_saldos, tx_contrato_pas_juros, flag_grup
    ) AS ldrmaster

    LEFT JOIN

    (
      SELECT cbalcao, cnumecta, zdeposit, eleg_fund_prop, mon_fund_prop, lei_aplicavel, termo_estruturado, dt_emissao, dt_vencim
      FROM cd_captools.ct610_titulos
      WHERE ref_date=${VAR:REFDATE}
      GROUP BY cbalcao, cnumecta, zdeposit, eleg_fund_prop, mon_fund_prop, lei_aplicavel, termo_estruturado, dt_emissao, dt_vencim
    ) AS ct610
    ON  ldrmaster.cbalcao = ct610.cbalcao
    AND ldrmaster.cnumecta = ct610.cnumecta
    AND ldrmaster.zdeposit = ct610.zdeposit

    LEFT JOIN

    (
      SELECT cempresa, cbalcao, cnumecta, zdeposit,
             CAST(SUM(mcoberto_me) AS DECIMAL(21,8)) AS mcoberto_me,
             CAST(SUM(mcoberto_eur) AS DECIMAL(21,8)) AS mcoberto_eur
      FROM cd_alm.fg001_fgd
      WHERE ref_date = ${VAR:REFDATE}
      AND   calinea = '#'
      GROUP BY cempresa, cbalcao, cnumecta, zdeposit
    ) fg001
    ON  ldrmaster.cempresa = fg001.cempresa
    AND ldrmaster.cbalcao = fg001.cbalcao
    AND ldrmaster.cnumecta = fg001.cnumecta
    AND ldrmaster.zdeposit = fg001.zdeposit

    LEFT JOIN

    (
      SELECT tayd91c0_celemtab, tayd91c0_gelem30
      FROM cd_captools.tat91_206
    ) tat91_206
    ON (ldrmaster.cmoeda = tat91_206.tayd91c0_celemtab)

    LEFT JOIN

    (
      SELECT tayd91c0_celemtab, tayd91c0_gelem30
      FROM cd_captools.tat91_015
    ) tat91_015
    ON (ct610.lei_aplicavel = tat91_015.tayd91c0_celemtab)

    GROUP BY ldrmaster.zdeposit,
             ldrmaster.zcliente,
             cmoeda,
             ldrmaster.cod_contavirt,
             ldrmaster.contraparte_i_desc,
             ldrmaster.flag_pme,
             ldrmaster.empresa_intragrupo,
             cpais_residencia,
             csector_inst,
             ct610.eleg_fund_prop,
             ct610.termo_estruturado,
             ct610.dt_emissao,
             ct610.dt_vencim,
             clei,
             ldrmaster.st_sgps_portugal_ifrs,
             ldrmaster.ref_date
  ) as pre_filter
  WHERE SUM_of_saldo IS NOT NULL OR SUM_of_juros IS NOT NULL
;


-------------------------------------------------------------------------------------T03.02-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_filter_for_query__0037 AS
  SELECT ldrmaster.gcliente,
         ldrmaster.clei,
         ldrmaster.zcliente,
         CAST(SUM(ldrmaster.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
         CAST(SUM(al015.mon_equiv_util_ae) AS DECIMAL(23,6)) AS SUM_of_Colateral, -- ISTO VEM SEMPRE A NULL (ESTRANHO)
         ct610.lei_aplicavel, -- ISTO VEM SEMPRE A NULL (ESTRANHO)
         ldrmaster.zdeposit as zdeposit1,
         ldrmaster.st_sgps_portugal_ifrs
  FROM
  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, gcliente, msaldo_final, clei, st_sgps_portugal_ifrs
    FROM bu_captools_work.test1_query_for_ldrmaster
    WHERE (cod_contavirt = '' OR cod_contavirt is NULL)
    AND empresa_intragrupo <> ''
    AND substr(ccontab_final_ifrs,1,2) = '91'
  ) as ldrmaster

  LEFT JOIN

  (
    SELECT cempresa_pas, cbalcao_pas, cnumecta_pas, zdeposit_pas, zcliente_pas, mon_equiv_util_ae
    FROM cd_alm.al015_act_fin
    WHERE ref_date=${VAR:REFDATE}
    AND nome_perimetro = 'Individual Local' -- Aqui também devemos ter de atacar esta tabela por uma variavel de perimetro
  ) as al015
  ON  ldrmaster.cempresa = al015.cempresa_pas
  AND ldrmaster.cbalcao = al015.cbalcao_pas
  AND ldrmaster.cnumecta = al015.cnumecta_pas
  AND ldrmaster.zdeposit = al015.zdeposit_pas

  LEFT JOIN

  (
    SELECT cbalcao, cnumecta, zdeposit, lei_aplicavel
    FROM cd_captools.ct610_titulos
    WHERE ref_date=${VAR:REFDATE}
    GROUP BY cbalcao, cnumecta, zdeposit, lei_aplicavel
  ) as ct610
  ON  ldrmaster.cbalcao = ct610.cbalcao
  AND ldrmaster.cnumecta = ct610.cnumecta
  AND ldrmaster.zdeposit = ct610.zdeposit

  GROUP BY ldrmaster.gcliente,
           ldrmaster.clei,
           ldrmaster.zcliente,
           ct610.lei_aplicavel,
           ldrmaster.zdeposit,
           ldrmaster.st_sgps_portugal_ifrs
;


-------------------------------------------------------------------------------------T03.03-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_ldrmaster_0005_00_0007 AS
  SELECT ldrmaster.gcliente,
         ldrmaster.clei,
         ldrmaster.zcliente,
         CAST(SUM(ldrmaster.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
         CAST(SUM(al015.mon_equiv_util_ae) AS DECIMAL(23,6)) AS SUM_of_Colateral, -- ISTO VEM SEMPRE A NULL (ESTRANHO)
         ct610.lei_aplicavel, -- ISTO VEM SEMPRE A NULL (ESTRANHO)
         ldrmaster.zdeposit as zdeposit1,
         ldrmaster.st_sgps_portugal_ifrs
  FROM
  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, gcliente, msaldo_final, clei, st_sgps_portugal_ifrs
    FROM bu_captools_work.test1_query_for_ldrmaster
    WHERE cod_contavirt like '%E%'
    AND empresa_intragrupo <> ''
    AND substr(ccontab_final_ifrs,1,2) = '90'
  ) as ldrmaster

  LEFT JOIN

  (
    SELECT cempresa_pas, cbalcao_pas, cnumecta_pas, zdeposit_pas, zcliente_pas, mon_equiv_util_ae
    FROM cd_alm.al015_act_fin
    WHERE ref_date=${VAR:REFDATE}
    AND nome_perimetro = 'Individual Local' -- Aqui também devemos ter de atacar esta tabela por uma variavel de perimetro
  ) as al015
  ON  ldrmaster.cempresa = al015.cempresa_pas
  AND ldrmaster.cbalcao = al015.cbalcao_pas
  AND ldrmaster.cnumecta = al015.cnumecta_pas
  AND ldrmaster.zdeposit = al015.zdeposit_pas

  LEFT JOIN

  (
    SELECT cbalcao, cnumecta, zdeposit, lei_aplicavel
    FROM cd_captools.ct610_titulos
    WHERE ref_date=${VAR:REFDATE}
    GROUP BY cbalcao, cnumecta, zdeposit, lei_aplicavel
  ) as ct610
  ON  ldrmaster.cbalcao = ct610.cbalcao
  AND ldrmaster.cnumecta = ct610.cnumecta
  AND ldrmaster.zdeposit = ct610.zdeposit

  GROUP BY ldrmaster.gcliente,
           ldrmaster.clei,
           ldrmaster.zcliente,
           ct610.lei_aplicavel,
           ldrmaster.zdeposit,
           ldrmaster.st_sgps_portugal_ifrs
;


-------------------------------------------------------------------------------------T04.00-----------------------------------------------------------------------------------------------------------------------------------
-- Neste caso iremos ter diferenças no campo cmoeda (daqui) vs tayd91c0_gelem30 que eles usam visot que isto me parecia um erro

CREATE TABLE bu_captools_work.test1_query_for_filter_for_query__0027 AS
  SELECT tat91_206.tayd91c0_gelem30 as cmoeda, -- Aqui ao contrário deles estou a trazer o cmoeda da tat91_206, visto que eles estão a trazer o equivalente ao lei aplicavel
         --tat91_015.tayd91c0_gelem30 as cmoeda, -- ISto era o que eles tinham
         CAST(SUM(ldrmaster_montantes.saldos) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
         ldrmaster_universo.descritivo,
         ldrmaster_universo.nome_atributo_dim5,
         ldrmaster_universo.zdeposit,
         ldrmaster_universo.contraparte_i_desc,
         CAST(SUM(ldrmaster_montantes.juros) AS DECIMAL(23,6)) AS SUM_of_juros,
         ct610.isin AS isin1,
         ct610.tipo_titulo AS tipo_titulo1,
         ct610.tipo_tx AS tipo_tx1,
         ct610.tx_fixa AS tx_fixa1,
         ct610.indx_tx_var AS indx_tx_var1,
         ct610.sprd_tx_var AS sprd_tx_var1,
         ct610.dt_emissao AS dt_emissao1,
         ct610.dt_vencim AS dt_vencim1,
         tat91_015.tayd91c0_gelem30 AS lei_aplicavel, -- Coloquei este nome em vez de tayd91c0_gelemtab1 pois acho que é mais indicativo. Para além de que estou a trazer o tayd91c0_gelem30 em vez do tayd91c0_gelemtab
         ct610.agente_pagador AS agente_pagador1,
         ct610.trustee AS trustee1,
         ct610.depositario AS depositario1,
         ct610.bolsa_valores AS bolsa_valores1,
         ct610.sist_liquidacao AS sist_liquidacao1,
         ct610.termo_estruturado AS termo_estruturado1,
         ct610.eleg_fund_prop AS eleg_fund_prop1,
         ct610.mon_fund_prop AS mon_fund_prop1,
         ct610.eleg_eurosistema AS eleg_eurosistema1,
         ct610.nom_tot_inic,
         CAST(SUM(al015.mon_equiv_util_ae) AS DECIMAL(23,6)) AS SUM_of_SUM_of_Calculation
  FROM
  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, cmoeda, nome_atributo_dim5, contraparte_i_desc, empresa_intragrupo,
           IF(descritivo = 'Hipotecárias XXII', 'Hipotecária XXII', IF(descritivo = 'Hipotecárias XXIII', 'Hipotecária XXIII', descritivo)) as descritivo
    FROM bu_captools_work.test1_query_for_ldrmaster
    WHERE cod_contavirt = 'P_22'
    AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
    AND (UPPER(nome_atributo_dim) LIKE '%CAPITAL/ NOCIONAL/ CUSTO%'
         OR UPPER(nome_atributo_dim) LIKE 'VALIAS E CORRE%ES DE VALOR POR OPERA%ES MICROCOBERTURA')
    GROUP BY cempresa, cbalcao, cnumecta, zdeposit, zcliente, cmoeda, nome_atributo_dim5, contraparte_i_desc, empresa_intragrupo, descritivo
  ) as ldrmaster_universo

  LEFT JOIN

  (
    SELECT cmoeda, contraparte_i_desc, empresa_intragrupo,
           IF(descritivo = 'Hipotecárias XXII', 'Hipotecária XXII', IF(descritivo = 'Hipotecárias XXIII', 'Hipotecária XXIII', descritivo)) as descritivo,
           CAST(SUM(IF(UPPER(nome_atributo_dim) LIKE '%CAPITAL/ NOCIONAL/ CUSTO%' OR UPPER(nome_atributo_dim) LIKE 'VALIAS E CORRE%ES DE VALOR POR OPERA%ES MICROCOBERTURA',msaldo_final,NULL)) AS DECIMAL(23,6)) as saldos,
           CAST(SUM(IF(UPPER(nome_atributo_dim) IN ("DESPESAS/COM. DIFERIDAS", "JUROS/ENCARGOS A PAGAR"),msaldo_final,NULL)) AS DECIMAL(23,6)) as juros
    FROM bu_captools_work.test1_query_for_ldrmaster
    WHERE cod_contavirt = 'P_22'
    AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
    AND (UPPER(nome_atributo_dim) LIKE '%CAPITAL/ NOCIONAL/ CUSTO%'
         OR UPPER(nome_atributo_dim) LIKE 'VALIAS E CORRE%ES DE VALOR POR OPERA%ES MICROCOBERTURA'
         OR UPPER(nome_atributo_dim) IN ("DESPESAS/COM. DIFERIDAS", "JUROS/ENCARGOS A PAGAR"))
    GROUP BY cmoeda, descritivo, contraparte_i_desc, empresa_intragrupo
  ) as ldrmaster_montantes
  ON  ldrmaster_universo.cmoeda = ldrmaster_montantes.cmoeda
  AND ldrmaster_universo.descritivo = ldrmaster_montantes.descritivo

  LEFT JOIN

  (
    SELECT cempresa_pas, cbalcao_pas, cnumecta_pas, zdeposit_pas, zcliente_pas,
           CAST(SUM(mon_equiv_util_ae) AS DECIMAL(23,6)) as mon_equiv_util_ae
    FROM cd_alm.al015_act_fin
    WHERE ref_date=${VAR:REFDATE}
    AND nome_perimetro = 'Individual Local' -- Aqui também devemos ter de atacar esta tabela por uma variavel de perimetro
    GROUP BY cempresa_pas, cbalcao_pas, cnumecta_pas, zdeposit_pas, zcliente_pas
  ) as al015
  ON  ldrmaster_universo.cempresa = al015.cempresa_pas
  AND ldrmaster_universo.cbalcao = al015.cbalcao_pas
  AND ldrmaster_universo.cnumecta = al015.cnumecta_pas
  AND ldrmaster_universo.zdeposit = al015.zdeposit_pas
  AND ldrmaster_universo.zcliente = al015.zcliente_pas

  LEFT JOIN

  (
    SELECT zdeposit, isin, tipo_titulo, tipo_tx, tx_fixa, indx_tx_var, sprd_tx_var, dt_emissao, dt_vencim, lei_aplicavel, agente_pagador, trustee,
           depositario, bolsa_valores, sist_liquidacao, termo_estruturado, eleg_fund_prop, mon_fund_prop, eleg_eurosistema, nom_tot_inic
    FROM cd_captools.ct610_titulos
    WHERE ref_date=${VAR:REFDATE}
    GROUP BY zdeposit, isin, tipo_titulo, tipo_tx, tx_fixa, indx_tx_var, sprd_tx_var, dt_emissao, dt_vencim, lei_aplicavel, agente_pagador, trustee,
             depositario, bolsa_valores, sist_liquidacao, termo_estruturado, eleg_fund_prop, mon_fund_prop, eleg_eurosistema, nom_tot_inic
  ) as ct610
  ON  ldrmaster_universo.zdeposit = ct610.zdeposit

  LEFT JOIN

  (
    SELECT tayd91c0_celemtab, tayd91c0_gelem30
    FROM cd_captools.tat91_206
  ) tat91_206
  ON ldrmaster_universo.cmoeda = tat91_206.tayd91c0_celemtab

  LEFT JOIN

  (
    SELECT tayd91c0_celemtab, tayd91c0_gelem30
    FROM cd_captools.tat91_015
  ) tat91_015
  ON ct610.lei_aplicavel = tat91_015.tayd91c0_celemtab

  GROUP BY cmoeda,
           ldrmaster_universo.descritivo,
           ldrmaster_universo.nome_atributo_dim5,
           ldrmaster_universo.zdeposit,
           isin1,
           tipo_titulo1,
           tipo_tx1,
           tx_fixa1,
           indx_tx_var1,
           sprd_tx_var1,
           dt_emissao1,
           dt_vencim1,
           lei_aplicavel,
           agente_pagador1,
           trustee1,
           depositario1,
           bolsa_valores1,
           sist_liquidacao1,
           termo_estruturado1,
           eleg_fund_prop1,
           mon_fund_prop1,
           eleg_eurosistema1,
           ct610.nom_tot_inic,
           ldrmaster_universo.contraparte_i_desc
;


-------------------------------------------------------------------------------------T05.01-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_filter_for_query__0026 AS
  SELECT cmoeda,
         CAST(SUM(SUM_of_SUM_of_msaldo_final11) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
         CAST(SUM(SUM_of_msaldo_final_juros) AS DECIMAL(23,6)) AS SUM_of_msaldo_final_juros,
         CAST(SUM(SUM_of_SUM_of_msaldo_final11_s128) AS DECIMAL(23,6)) AS SUM_of_msaldo_final_s128,
         CAST(SUM(SUM_of_msaldo_final_juros_s128) AS DECIMAL(23,6)) AS SUM_of_msaldo_final_juros_s128,
         contraparte_i_desc,
         flag_pme,
         CAST(AVG(AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
         CAST(AVG(AVG_of_tx_contrato_pas_j) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas_juros,
         CAST(AVG(AVG_of_tx_contrato_pas_s128) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas_s128,
         CAST(AVG(AVG_of_tx_contrato_pas_j_s128) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas_juro_s128,
         GROUP_CONCAT(DISTINCT csector_inst) AS csector_inst,
         CAST(SUM(SUM_of_SUM_of_mcoberto_eur2) AS DECIMAL(21,8)) AS SUM_of_mcoberto_eu,
         CAST(SUM(SUM_of_SUM_of_mcoberto_me2) AS DECIMAL(21,8)) AS SUM_of_mcoberto_me,
         CAST(SUM(SUM_of_SUM_of_mcoberto_eur2_s128) AS DECIMAL(21,8)) AS SUM_of_mcoberto_eur_s128,
         CAST(SUM(SUM_of_SUM_of_mcoberto_me2_s128) AS DECIMAL(21,8)) AS SUM_of_mcoberto_me_s128,
         ref_date
  FROM
  (
    SELECT IF(ldrmaster.csector_inst LIKE 'S128%', ldrmaster.csector_inst, NULL) as csector_inst,
           tat91_206.tayd91c0_gelem30 as cmoeda,
           CAST(SUM(ldrmaster.saldos) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final11,
           CAST(SUM(ldrmaster.juros) AS DECIMAL(23,6)) AS SUM_of_msaldo_final_juros,
           CAST(SUM(ldrmaster.saldos_S128) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final11_s128,
           CAST(SUM(ldrmaster.juros_s128) AS DECIMAL(23,6)) AS SUM_of_msaldo_final_juros_s128,
           ldrmaster.contraparte_i_desc,
           ldrmaster.flag_pme,
           CAST(AVG(ldrmaster.tx_contrato_pas_saldos) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
           CAST(AVG(ldrmaster.tx_contrato_pas_juros) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas_j,
           CAST(AVG(ldrmaster.tx_contrato_pas_saldos_s128) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas_s128,
           CAST(AVG(ldrmaster.tx_contrato_pas_juros_s128) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas_j_s128,
           CAST(SUM(IF(ldrmaster.csector_inst NOT LIKE 'S128%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Juros%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Despesa%', fg001.mcoberto_eur, NULL)) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur2,
           CAST(SUM(IF(ldrmaster.csector_inst NOT LIKE 'S128%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Juros%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Despesa%', fg001.mcoberto_me, NULL)) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me2,
           CAST(SUM(IF(ldrmaster.csector_inst LIKE 'S128%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Juros%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Despesa%', fg001.mcoberto_eur, NULL)) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur2_s128,
           CAST(SUM(IF(ldrmaster.csector_inst LIKE 'S128%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Juros%' AND ldrmaster.nome_atributo_dim NOT LIKE '%Despesa%', fg001.mcoberto_me, NULL)) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me2_s128,
           ldrmaster.ref_date
    FROM
    (
      SELECT cempresa, cbalcao, cnumecta, zdeposit, cmoeda, contraparte_i_desc, flag_pme, csector_inst, empresa_intragrupo, nome_atributo_dim, ref_date,
             CAST(SUM(IF(csector_inst NOT LIKE 'S128%' AND nome_atributo_dim NOT LIKE '%Juros%' AND nome_atributo_dim NOT LIKE '%Despesa%', msaldo_final, NULL)) AS DECIMAL(23,6)) AS saldos,
             CAST(SUM(IF(csector_inst NOT LIKE 'S128%' AND (nome_atributo_dim LIKE '%Juros%' OR nome_atributo_dim LIKE '%Despesa%'), msaldo_final, NULL)) AS DECIMAL(23,6)) AS juros,
             CAST(SUM(IF(csector_inst LIKE 'S128%' AND nome_atributo_dim NOT LIKE '%Juros%' AND nome_atributo_dim NOT LIKE '%Despesa%', msaldo_final, NULL)) AS DECIMAL(23,6)) AS saldos_s128,
             CAST(SUM(IF(csector_inst LIKE 'S128%' AND (nome_atributo_dim LIKE '%Juros%' OR nome_atributo_dim LIKE '%Despesa%'), msaldo_final, NULL)) AS DECIMAL(23,6)) AS juros_s128,
             IF(csector_inst NOT LIKE 'S128%' AND nome_atributo_dim NOT LIKE '%Juros%' AND nome_atributo_dim NOT LIKE '%Despesa%',tx_contrato_pas,NULL) as tx_contrato_pas_saldos,
             IF(csector_inst NOT LIKE 'S128%' AND (nome_atributo_dim LIKE '%Juros%' OR nome_atributo_dim LIKE '%Despesa%'),tx_contrato_pas,NULL) as tx_contrato_pas_juros,
             IF(csector_inst LIKE 'S128%' AND nome_atributo_dim NOT LIKE '%Juros%' AND nome_atributo_dim NOT LIKE '%Despesa%',tx_contrato_pas,NULL) as tx_contrato_pas_saldos_s128,
             IF(csector_inst LIKE 'S128%' AND (nome_atributo_dim LIKE '%Juros%' OR nome_atributo_dim LIKE '%Despesa%'),tx_contrato_pas,NULL) as tx_contrato_pas_juros_s128
      FROM bu_captools_work.test1_query_for_ldrmaster
      WHERE ( cod_contavirt= 'P_21' OR (cod_contavirt= 'P_20' AND UPPER(nome_atributo_dim4) LIKE 'DEP%SITOS A PRAZO') )
      AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
      GROUP BY cempresa, cbalcao, cnumecta, zdeposit, cmoeda, contraparte_i_desc, flag_pme, csector_inst, empresa_intragrupo, nome_atributo_dim,
               tx_contrato_pas, ref_date
    ) as ldrmaster

    LEFT JOIN

    (
      SELECT cempresa, cbalcao, cnumecta, zdeposit,
             CAST(SUM(mgarantido_eur) AS DECIMAL(21,8)) AS mgarantido_eur,
             CAST(SUM(mgarantido_me) AS DECIMAL(21,8)) AS mgarantido_me,
             CAST(SUM(mcoberto_eur) AS DECIMAL(21,8)) AS mcoberto_eur,
             CAST(SUM(mcoberto_me) AS DECIMAL(21,8)) AS mcoberto_me
      FROM cd_alm.fg001_fgd
      WHERE ref_date = ${VAR:REFDATE}
      AND   calinea = '#'
      GROUP BY cempresa, cbalcao, cnumecta, zdeposit
    ) as fg001
    ON  ldrmaster.cempresa = fg001.cempresa
    AND ldrmaster.cbalcao = fg001.cbalcao
    AND ldrmaster.cnumecta = fg001.cnumecta
    AND ldrmaster.zdeposit = fg001.zdeposit

    LEFT JOIN

    (
      SELECT tayd91c0_celemtab, tayd91c0_gelem30
      FROM cd_captools.tat91_206
    ) tat91_206
    ON ldrmaster.cmoeda = tat91_206.tayd91c0_celemtab

    GROUP BY tat91_206.tayd91c0_gelem30,
             ldrmaster.contraparte_i_desc,
             ldrmaster.flag_pme,
             ldrmaster.csector_inst,
             ldrmaster.ref_date
  ) as filter_for_query_for_filter_for_
  WHERE SUM_of_SUM_of_msaldo_final11 <> 0
  OR    SUM_of_msaldo_final_juros <> 0
  OR    csector_inst LIKE 'S128%'

  GROUP BY cmoeda,
           contraparte_i_desc,
           flag_pme,
           ref_date
;


-------------------------------------------------------------------------------------T06.01-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_filter_for_query_0046 AS
  SELECT IF(ldrmaster.flag_grup>2,ldrmaster.zcliente,NULL) as zcliente,
         tat91_206.tayd91c0_gelem30 as cmoeda, -- Tomei a liberdade de colocar aqui o nome do campo em vez de ficar tayd91c0_gelem30
         ldrmaster.clei,
         CAST(SUM(IF(ldrmaster.flag_grup<>20,ldrmaster.msaldo_final,NULL)) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
         CAST(SUM(IF(ldrmaster.flag_grup=20,ldrmaster.msaldo_final,IF(ldrmaster.flag_grup=2,ldrmaster.tx_contrato_pas,NULL))) AS DECIMAL(23,6)) AS SUM_juros,
         CAST(AVG(IF(ldrmaster.flag_grup=10,ldrmaster.tx_contrato_pas,IF(ldrmaster.flag_grup=1,ldrmaster.tx_contrato_pas,NULL))) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
         IF(ldrmaster.flag_grup<>2,ldrmaster.contraparte_i_desc,NULL) AS contraparte_i_desc,
         IF(ldrmaster.flag_grup>2,ldrmaster.gcliente,NULL) AS gcliente,
         IF(ldrmaster.flag_grup>2,0,flag_grup) AS Calculation,
         t_06_01_zclientes.classification,
         ldrmaster.ref_date
  FROM
  (
    SELECT zcliente, cmoeda, clei, contraparte_i_desc, gcliente,  msaldo_final, tx_contrato_pas, ref_date,
           CASE
             WHEN cod_contavirt = 'P_20'
                  AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
                  AND UPPER(nome_atributo_dim4) LIKE 'DEP%SITOS % ORDEM, OVERNIGHTS'
                  AND UPPER(nome_atributo_dim5) LIKE '%CAPITAL/ NOCIONAL/ CUSTO%'
             THEN 10
             WHEN cod_contavirt = 'P_20'
                  AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
                  AND UPPER(nome_atributo_dim4) LIKE 'DEP%SITOS % ORDEM, OVERNIGHTS'
                  AND (UPPER(nome_atributo_dim5) LIKE 'JUROS/ENCARGOS A PAGAR'
                       OR UPPER(nome_atributo_dim5) LIKE 'JUROS/RENDIMENTOS A RECEBER')
             THEN 20
             WHEN cod_contavirt IN ('P_20', 'P_24', 'P_28.1', 'P_28.2')
                  AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
                  AND (UPPER(nome_atributo_dim) LIKE 'CREDORES POR OPERA%ES SO'
                        OR UPPER(nome_atributo_dim) LIKE 'CREDORES POR FORNECIMENTO')
             THEN 1
             WHEN cod_contavirt IN ('P_28.1', 'P_28.2')
                  OR (cod_contavirt IN ('P_20', 'P_24')
                      AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
                      AND (UPPER(nome_atributo_dim) LIKE 'IMPOSTO DO SELO'
                            OR UPPER(nome_atributo_dim) LIKE 'IMPOSTO SOBRE VALOR ACRES%'
                            OR UPPER(nome_atributo_dim) LIKE 'RETEN%O DE IMPOSTOS NA F%'
                            OR UPPER(nome_atributo_dim) LIKE 'CONTRIBUI%ES PARA A SEGU%'))
             THEN 2
             ELSE NULL
           END AS flag_grup
    FROM bu_captools_work.test1_query_for_ldrmaster
    WHERE (
           (
            cod_contavirt = 'P_20'
            AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
            AND UPPER(nome_atributo_dim4) LIKE 'DEP%SITOS % ORDEM, OVERNIGHTS'
            AND (UPPER(nome_atributo_dim5) LIKE '%CAPITAL/ NOCIONAL/ CUSTO%'
                 OR UPPER(nome_atributo_dim5) LIKE 'JUROS/ENCARGOS A PAGAR'
                 OR UPPER(nome_atributo_dim5) LIKE 'JUROS/RENDIMENTOS A RECEBER')
           ) -- query_for_filter_for_query
           OR
           (
            cod_contavirt IN ('P_20', 'P_24', 'P_28.1', 'P_28.2')
            AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
            AND (UPPER(nome_atributo_dim) LIKE 'CREDORES POR OPERA%ES SO'
                 OR UPPER(nome_atributo_dim) LIKE 'CREDORES POR FORNECIMENTO')
           ) -- query_for_filter_for_query__001f
           OR
           (
            cod_contavirt IN ('P_28.1', 'P_28.2')
            OR (cod_contavirt IN ('P_20', 'P_24')
                AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
                AND (UPPER(nome_atributo_dim) LIKE 'IMPOSTO DO SELO'
                     OR UPPER(nome_atributo_dim) LIKE 'IMPOSTO SOBRE VALOR ACRES%'
                     OR UPPER(nome_atributo_dim) LIKE 'RETEN%O DE IMPOSTOS NA F%'
                     OR UPPER(nome_atributo_dim) LIKE 'CONTRIBUI%ES PARA A SEGU%'))
           ) -- query_for_filter_for_query__002c
          )
    AND msaldo_final <> 0
    AND msaldo_final IS NOT NULL
  ) as ldrmaster

  LEFT JOIN

  (
    SELECT tayd91c0_celemtab, tayd91c0_gelem30
    FROM cd_captools.tat91_206
  ) tat91_206
  ON ldrmaster.cmoeda = tat91_206.tayd91c0_celemtab

  LEFT JOIN

  (
    SELECT zcliente, classification
    FROM bu_captools_work.t_06_01_zclientes_31_12_2021 -- TRocar quando se souber onde fica esta tabela manual, ou se dá para automatizar
  ) t_06_01_zclientes
  ON (IF(ldrmaster.zcliente IS NULL OR ldrmaster.flag_grup < 10, '', ldrmaster.zcliente) = t_06_01_zclientes.zcliente)

  GROUP BY zcliente,
           tat91_206.tayd91c0_gelem30,
           ldrmaster.clei,
           contraparte_i_desc,
           gcliente,
           Calculation,
           t_06_01_zclientes.classification,
           ldrmaster.ref_date
;


-------------------------------------------------------------------------------------T07.00-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_al015_act_fin_0001 AS
  SELECT ldrmaster.gcliente,
         ldrmaster.clei,
         tat91_015.tayd91c0_gelem30 as cpais_residencia, -- Tomei a liberdade de colocar aqui o nome do campo em vez de ficar tayd91c0_gelem30
         cq_isda.cod_ref_cq,
         cq_isda.cod_tip_contrato,
         CAST(SUM(ldrmaster.msaldo_final) AS DECIMAL(23,6)) AS Calculation,
         ldrmaster.empresa_intragrupo,
         ldrmaster.contraparte_i_desc,
         ldrmaster.flag_pme,
         ldrmaster.zcliente, -- Tomei a liberdade de colocar o nome deste campo com zcliente e não zcliente1
         cq_isda.dt_fim,
         CAST(COUNT(ldrmaster.msaldo_final) AS DECIMAL(23,6)) AS Calculation1,
         CAST(SUM(al015.Calculation) AS DECIMAL(23,6)) AS Calculation2
  FROM
  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, gcliente, clei, cpais_residencia, msaldo_final, empresa_intragrupo, contraparte_i_desc, flag_pme
    FROM bu_captools_work.test1_query_for_ldrmaster
    WHERE cod_contavirt IN ('P_17', 'P_25')
  ) as ldrmaster

  LEFT JOIN

  (
    SELECT zcliente, cod_ref_cq, cod_tip_contrato, dt_fim
    FROM cd_alm.cq_isda
    WHERE data_date_part = ${VAR:DATADATEPART}
  ) cq_isda
  ON ldrmaster.zcliente = cq_isda.zcliente

  LEFT JOIN

  (
    SELECT cempresa_pas, cbalcao_pas, cnumecta_pas, zdeposit_pas, zcliente_pas, nome_perimetro,
           CAST(SUM(mon_equiv_util_ae) AS DECIMAL(23,6)) AS Calculation
    FROM cd_alm.al015_act_fin
    WHERE ref_date=${VAR:REFDATE}
    AND nome_perimetro = 'Individual Local' -- Aqui também devemos ter de atacar esta tabela por uma variavel de perimetro
    GROUP BY cempresa_pas, cbalcao_pas, cnumecta_pas, zdeposit_pas, zcliente_pas, nome_perimetro
  ) as al015
  ON  al015.cempresa_pas = ldrmaster.cempresa
  AND al015.cbalcao_pas = ldrmaster.cbalcao
  AND al015.cnumecta_pas = ldrmaster.cnumecta
  AND al015.zdeposit_pas = ldrmaster.zdeposit

  LEFT JOIN

  (
    SELECT tayd91c0_celemtab, tayd91c0_gelem30
    FROM cd_captools.tat91_015
  ) tat91_015
  ON ldrmaster.cpais_residencia = tat91_015.tayd91c0_celemtab

  WHERE ldrmaster.msaldo_final <> 0

  GROUP BY ldrmaster.gcliente,
           ldrmaster.clei,
           tat91_015.tayd91c0_gelem30,
           cq_isda.cod_ref_cq,
           cq_isda.cod_tip_contrato,
           ldrmaster.empresa_intragrupo,
           ldrmaster.contraparte_i_desc,
           ldrmaster.flag_pme,
           ldrmaster.zcliente,
           cq_isda.dt_fim
;


-------------------------------------------------------------------------------------T08.00-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_filter_for_query_003c AS
  SELECT ldrmaster.zcliente,
         ldrmaster.contraparte_i_desc,
         ldrmaster.gcliente,
         ldrmaster.clei,
         tat91_015.tayd91c0_gelem30 as cpais_residencia, -- Tomei a liberdade de colocar aqui o nome do campo em vez de ficar tayd91c0_gelem30
         CAST(SUM(ldrmaster.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
         CAST(SUM(al015.Calculation) AS DECIMAL(23,6)) AS SUM_of_Calculation1,
         cq_isda.cod_ref_cq,
         COUNT(ldrmaster.msaldo_final) AS COUNT_of_msaldo_final
  FROM
  (
    SELECT cempresa, cbalcao, cnumecta, zdeposit, zcliente, contraparte_i_desc, gcliente, clei, cpais_residencia, msaldo_final
    FROM bu_captools_work.test1_query_for_ldrmaster
    WHERE cod_contavirt = 'P_19'
    OR cod_contavirt = 'P_20' AND UPPER(nome_atributo_dim4) = 'VENDAS COM ACORDO DE RECOMPRA (REPOS)'
  ) as ldrmaster

  LEFT JOIN

  (
    SELECT zcliente, cod_ref_cq, cod_tip_contrato, dt_fim
    FROM cd_alm.cq_isda
    WHERE data_date_part = ${VAR:DATADATEPART}
  ) cq_isda
  ON ldrmaster.zcliente = cq_isda.zcliente

  LEFT JOIN

  (
    SELECT cempresa_pas, cbalcao_pas, cnumecta_pas, zdeposit_pas, zcliente_pas, nome_perimetro,
           CAST(SUM(mon_equiv_util_ae) AS DECIMAL(23,6)) AS Calculation
    FROM cd_alm.al015_act_fin
    WHERE ref_date=${VAR:REFDATE}
    AND nome_perimetro = 'Individual Local' -- Aqui também devemos ter de atacar esta tabela por uma variavel de perimetro
    GROUP BY cempresa_pas, cbalcao_pas, cnumecta_pas, zdeposit_pas, zcliente_pas, nome_perimetro
  ) as al015
  ON  al015.cempresa_pas = ldrmaster.cempresa
  AND al015.cbalcao_pas = ldrmaster.cbalcao
  AND al015.cnumecta_pas = ldrmaster.cnumecta
  AND al015.zdeposit_pas = ldrmaster.zdeposit

  LEFT JOIN

  (
    SELECT tayd91c0_celemtab, tayd91c0_gelem30
    FROM cd_captools.tat91_015
  ) tat91_015
  ON ldrmaster.cpais_residencia = tat91_015.tayd91c0_celemtab

  GROUP BY ldrmaster.zcliente,
           ldrmaster.contraparte_i_desc,
           ldrmaster.gcliente,
           ldrmaster.clei,
           tat91_015.tayd91c0_gelem30,
           cq_isda.cod_ref_cq
;


-------------------------------------------------------------------------------------T09.00-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_filter_for_balenc_0000 AS
  SELECT tat91_206.tayd91c0_gelem30 as cmoeda, -- Tomei a liberdade de colocar aqui o nome do campo em vez de ficar tayd91c0_gelem30
         CAST(SUM(ldrmaster.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fin1,
         ldrmaster.contraparte_i_desc,
         ldrmaster.flag_pme,
         balencete_man.line,
         balencete_man.insolvency_ranking,
         balencete_man.type_of_non_financial_liabilitie,
         ldrmaster.ccontab_final_ifrs,
         ldrmaster.ref_date
  FROM
  (
    SELECT cmoeda, msaldo_final, contraparte_i_desc, nome_atributo_dim, flag_pme, ccontab_final_ifrs, ref_date
    FROM bu_captools_work.test1_query_for_ldrmaster
    --Tomei liberdades criativas com estas condições (REVER)
    WHERE (cod_contavirt LIKE '%P_30%' OR cod_contavirt LIKE '%P_27%' OR cod_contavirt = 'P_24')
    AND (empresa_intragrupo = '' OR empresa_intragrupo is NULL)
    AND (UPPER(nome_atributo_dim) NOT LIKE '%CREDORES POR FORNECIMENTO%'
         AND UPPER(nome_atributo_dim) NOT LIKE '%CREDORES POR OPERA%ES SO%'
         AND UPPER(nome_atributo_dim) NOT LIKE '%IMPOSTO SOBRE VALOR ACRES%'
         AND UPPER(nome_atributo_dim) NOT LIKE '%IMPOSTO DO SELO%'
         AND UPPER(nome_atributo_dim) NOT LIKE '%CONTRIBUI%ES PARA A SEGU%'
         AND UPPER(nome_atributo_dim) NOT LIKE '%RETEN%O DE IMPOSTOS NA F%'
         OR  nome_atributo_dim IS NULL)
  ) as ldrmaster

  LEFT JOIN

  (
    SELECT tayd91c0_celemtab, tayd91c0_gelem30
    FROM cd_captools.tat91_206
  ) tat91_206
  ON ldrmaster.cmoeda = tat91_206.tayd91c0_celemtab

  LEFT JOIN

  (
    SELECT ccontab_final_ifrs,
           correcao_linhas AS line,
           insolvency_ranking_0001 AS insolvency_ranking,
           type_of_non_financial_liabi_0001 AS type_of_non_financial_liabilitie
    FROM  bu_captools_work.balancete_t_09_00
  ) balencete_man
  ON ldrmaster.ccontab_final_ifrs = balencete_man.ccontab_final_ifrs

  GROUP BY tat91_206.tayd91c0_gelem30,
           ldrmaster.contraparte_i_desc,
           ldrmaster.flag_pme,
           balencete_man.line,
           balencete_man.insolvency_ranking,
           balencete_man.type_of_non_financial_liabilitie,
           ldrmaster.ccontab_final_ifrs,
           ldrmaster.ref_date
;


-------------------------------------------------------------------------------------T12.00-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE bu_captools_work.test1_query_for_ldrmaster_0005_00_0005 AS
  SELECT ct_069_070.nomegrup,
         ct_069_070.zcliente_princ,
         tat91_015.tayd91c0_gelem30 as cpais_residencia, -- Tomei a liberdade de colocar aqui o nome do campo em vez de ficar tayd91c0_gelem30
         ldrmaster.contraparte_i_desc,
         CAST(SUM(ldrmaster.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final1,
         ldrmaster.Calculation,
         COUNT(*) as Numero_de_entidades
  FROM
  (
    SELECT zcliente, cpais_residencia, contraparte_i_desc,
           substr(ccontab_final_ifrs,1,2) as Calculation,
           CAST(SUM(msaldo_final) AS DECIMAL(23,6)) AS msaldo_final
    FROM bu_captools_work.test1_query_for_ldrmaster
    WHERE (cod_contavirt LIKE '%E%' OR cod_contavirt = '' OR cod_contavirt IS NULL)
    AND substr(ccontab_final_ifrs,1,2) IN ('91', '93')
    GROUP BY zcliente, cpais_residencia, contraparte_i_desc, Calculation
  ) as ldrmaster

  LEFT JOIN

  (
    SELECT ct069.zgrupo, ct069.nomegrup, ct070.zcliente, ct069.zcliente_princ
    FROM
    (
      SELECT zgrupo, nomegrup, zcliente_princ
      FROM cd_captools.ct069_univ_gr_ec
      WHERE ref_date=${VAR:REFDATE}
    ) ct069
    FULL JOIN
    (
      SELECT zcliente, zgrupo
      FROM cd_captools.ct070_univ_gr_cli
      WHERE ref_date=${VAR:REFDATE}
    ) ct070
    ON ct069.zgrupo = ct070.zgrupo
  ) ct_069_070
  ON ldrmaster.zcliente = ct_069_070.zcliente

  LEFT JOIN

  (
    SELECT tayd91c0_celemtab, tayd91c0_gelem30
    FROM cd_captools.tat91_015
  ) tat91_015
  ON ldrmaster.cpais_residencia = tat91_015.tayd91c0_celemtab

  WHERE ct_069_070.nomegrup <> ''
  AND ct_069_070.nomegrup IS NOT NULL

  GROUP BY ct_069_070.nomegrup,
           ct_069_070.zcliente_princ,
           tat91_015.tayd91c0_gelem30,
           ldrmaster.contraparte_i_desc,
           Calculation

  ORDER BY SUM_of_SUM_of_msaldo_final1 LIMIT 10
;


----------------------------------------------------------------------------DROPS FINAIS------------------------------------------------------------------------------------------------------------------------

-- DROP TABLE IF EXISTS bu_captools_work.query_for_balanco_ind_0000 purge;         --Tabela auxiliar
-- DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct081 purge;         --Tabela auxiliar
-- DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster purge;                --Tabela auxiliar
