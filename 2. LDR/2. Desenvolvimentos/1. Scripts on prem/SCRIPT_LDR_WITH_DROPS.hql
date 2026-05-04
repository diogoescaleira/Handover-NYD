--Projecto - Balanço BST individual
SET VAR:REFDATE	= '2022-12-31';
SET VAR:PERIMETRO = 'Individual Local';
SET VAR:DATADATEPART = '2022-12-31';


DROP TABLE IF EXISTS bu_captools_work.balanco_ind purge;
DROP TABLE IF EXISTS bu_captools_work.ct008_refdate purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ct007_pv_planos purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct011_dim_hier purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct010_dim_valor purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct063_univ_pme purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct081_finrep purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct004_univ_cto purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct003_univ_cli purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_clientes_intragrupo purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_perimetro purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_al001_cnt_core purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ct008_refdate purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct010_dim_valor_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct010_dim_valor_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_clientes_in purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_al001__0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct008_pv_co purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct081__0000 purge;
DROP TABLE IF EXISTS bu_captools_work.passivo purge;
DROP TABLE IF EXISTS bu_captools_work.ativo purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct008__0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct081 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct010_dim_v purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct010__0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct010__0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct010__0002 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_balanco_ind_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0005 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0006 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0008 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0009 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_000f purge;
DROP TABLE IF EXISTS bu_captools_work.ldrmasterindividual202212 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_al015_act_fin purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct610_titulos purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct069_univ_gr_ec_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct070_univ_gr_cl_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0004 purge;
DROP TABLE IF EXISTS bu_captools_work.QUERY_FOR_LDRMASTER_0005_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0002 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000e purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0002 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000c purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmaster purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0006 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0013 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0014 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster1 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0011 purge;
DROP TABLE IF EXISTS bu_captools_work.FILTER_FOR_FG001_FGD purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_fg001_fgd_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.FILTER_FOR_CQ_ISDA_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0015 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct610_titul purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct069__0000 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_t_06_01_zclientes_22 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_balencete_22 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0034 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__003d purge;
DROP TABLE IF EXISTS bu_captools_work.validacao_balanco_2 purge;
DROP TABLE IF EXISTS bu_captools_work.validacao_balanco purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002c purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002e purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_for_l purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__000f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_fo purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmaster_0 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0013 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster1_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster1_0001_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster1_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_000e purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_fg001_fgd purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0018 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_000a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_000a_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0037 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0031 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0032 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0009 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_al015_act_fin_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster2_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0015 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0025 purge;
DROP TABLE IF EXISTS bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__003A purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0043 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_000e purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0003 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_fg001_fgd1 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0020 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_000a_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0008 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0033 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0045 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0039 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0029 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000a purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0024 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0023 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_al015_act_fin_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster2_0002 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_003c purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0006 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query2 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_001d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_001e purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0022 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0037 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0029 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0011 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0017 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0033 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0004 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0030 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0038 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0022 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0004 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0005 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_balencete purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_balenc_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_004b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0005 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0036 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0023 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0019 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001e purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0028 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__003b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0030 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0032 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_003b purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_for_ purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0046 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0040 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0034 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0027 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_for_f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0049 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_003a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0048 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001c purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0028 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0038 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002c purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002d purge;
DROP TABLE IF EXISTS bu_captools_work.append_table_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_003d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0041 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0047 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0018 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0026 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_append_table purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_append_table_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_append_table_0002 purge;



CREATE TABLE bu_captools_work.balanco_ind AS
SELECT t01.cempresa,
       t01.cbalcao,
       t01.cnumecta,
       t01.zdeposit,
       t01.zcliente,
       t01.descritivo,
       t01.caplic,
       t01.cgrupoic,
       t01.cmoeda,
       t01.cnaturic,
       t01.tipo_contrato,
       t01.sociedade_contraparte,
       t01.msaldo_inicial,
       t01.msaldo_final,
       t01.ccontab_inicial_pcsb,
       t01.ccontab_inicial_ifrs,
       t01.ccontab_inicial_cargabal,
       t01.ccontab_inicial_sgps_cons,
       t01.ccontab_final_pcsb,
       t01.ccontab_final_ifrs,
       t01.ccontab_final_cargabal,
       t01.ccontab_final_sgps_cons,
       t01.origem,
       t01.flag_ativo,
       t01.ref_date
FROM
  (SELECT *
   FROM cd_captools.ct001_univ_saldo
   WHERE ref_date=${VAR:REFDATE}
     AND flag_ativo=1) AS t01
INNER JOIN
  (SELECT cbalcao,
          cempresa,
          cnumecta,
          zdeposit,
          zcliente,
          nome_perimetro,
          entidade,
          ref_date
   FROM cd_captools.ct005_univ_perim
   WHERE ref_date=${VAR:REFDATE}
     AND nome_perimetro=${VAR:PERIMETRO} ) AS t05
ON (t01.cbalcao = t05.cbalcao)
AND (t01.cempresa = t05.cempresa)
AND (t01.cnumecta = t05.cnumecta)
AND (t01.zdeposit = t05.zdeposit)
AND (t01.zcliente = t05.zcliente)
;


CREATE TABLE bu_captools_work.ct008_refdate AS
SELECT t1.cod_plano,
       t1.cod_contavirt,
       t1.nome_plano_contas,
       t1.conta,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao
FROM cd_captools.ct008_pv_contas t1
WHERE t1.ref_date=${VAR:REFDATE}
;


CREATE TABLE bu_captools_work.query_for_ct007_pv_planos AS
SELECT t1.cod_plano,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.descritivo_contavirt,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao
FROM cd_captools.ct007_pv_planos t1
WHERE t1.ref_date=${VAR:REFDATE}
;


CREATE TABLE bu_captools_work.filter_for_ct011_dim_hier AS
SELECT t1.nivel_0,
       t1.nivel_1,
       t1.nivel_2,
       t1.nivel_3,
       t1.nivel_4,
       t1.nivel_5,
       t1.nivel_6,
       t1.nivel_7,
       t1.nivel_8,
       t1.nivel_9,
       t1.nivel_10,
       t1.nivel_11,
       t1.nivel_12,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao,
       t1.id_dimensao
FROM cd_captools.ct011_dim_hier t1
WHERE t1.ref_date=${VAR:REFDATE}
  AND t1.id_dimensao = 44
;


CREATE TABLE bu_captools_work.filter_for_ct010_dim_valor AS
SELECT t1.cod_atributo_dim,
       t1.nome_atributo_dim,
       t1.desc_atributo_dim,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao,
       t1.id_dimensao
FROM cd_captools.ct010_dim_valor t1
WHERE t1.ref_date=${VAR:REFDATE}
;


CREATE TABLE bu_captools_work.filter_for_ct063_univ_pme AS
SELECT t1.zcliente,
       t1.flag_pme,
       t1.flag_retalho,
       t1.cod_empr_pme,
       t1.tipo_crit_empr,
       t1.tipo_empr,
       t1.fatr_indv,
       t1.ativo_indv,
       t1.num_empg_indv,
       t1.data_dados_indv,
       t1.fatr_grup,
       t1.ativo_grup,
       t1.num_empg_grup,
       t1.data_dados_grup,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao
FROM cd_captools.ct063_univ_pme t1
WHERE t1.ref_date=${VAR:REFDATE}
;


CREATE TABLE bu_captools_work.filter_for_ct081_finrep AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.contraparte_i,
       t1.produto,
       t1.carteira_contabilistica,
       t1.tipo_conta,
       t1.instrumento_financeiro,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date
FROM cd_captools.ct081_finrep t1
WHERE t1.ref_date=${VAR:REFDATE};


CREATE TABLE bu_captools_work.filter_for_ct004_univ_cto AS
SELECT t1.zcliente,
       t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.cmoeda1,
       t1.cmoeda2,
       t1.ddiaop,
       t1.dabertur,
       t1.ddvencim,
       t1.ddvencim_orig,
       t1.dincump,
       t1.dias_incump,
       t1.classrisc,
       t1.sociedade_contraparte,
       t1.cnatjur,
       t1.cproduto,
       t1.csubprod,
       t1.ccontab,
       t1.tipo_contrato,
       t1.stage,
       t1.flag_poci,
       t1.tipo_analise,
       t1.flag_project_finance,
       t1.flag_debito_subordinado,
       t1.purpose_code,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao
FROM cd_captools.ct004_univ_cto t1
WHERE t1.ref_date=${VAR:REFDATE};


CREATE TABLE bu_captools_work.filter_for_ct003_univ_cli AS
SELECT t1.zcliente,
       t1.ccli_grupo,
       t1.gcliente,
       t1.iex_cliente,
       t1.cnum_doc_identif2,
       t1.ccae,
       t1.dnascimento,
       t1.dconstituicao,
       t1.cnif_resid,
       t1.ctipo_doc_identif1,
       t1.cnum_doc_identif1,
       t1.cpais_doc_identif1,
       t1.cemi_doc_identif1,
       t1.ctipo_doc_identif2,
       t1.cpais_doc_identif2,
       t1.cnum_empreg,
       t1.ccli_kgl,
       t1.estadent,
       t1.vmont_vendas,
       t1.cseg_risc,
       t1.dult_balanco,
       t1.dabertura_cliente,
       t1.cpersona,
       t1.cnatureza_juri,
       t1.clei,
       t1.nace_code,
       t1.cpais_residencia,
       t1.ccentro_gestor,
       t1.cgestor,
       t1.ggestor,
       t1.itip_cli,
       t1.csector_inst,
       t1.contraparte,
       t1.dobito,
       t1.ctipo_trabalho,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao,
       t1.origem
FROM cd_captools.ct003_univ_cli t1
WHERE t1.ref_date=${VAR:REFDATE};


CREATE TABLE bu_captools_work.filter_for_clientes_intragrupo AS
SELECT t1.cmes,
       t1.centidade,
       t1.zcliente,
       t1.nome,
       t1.consolpt,
       t1.consoles,
       t1.pais,
       t1.outros,
       t1.cdata,
       t1.iconspt,
       t1.data_date_part,
       t1.data_timestamp_part
FROM cd_captools.clientes_intragrupo t1
WHERE t1.data_date_part=${VAR:DATADATEPART};


CREATE TABLE bu_captools_work.query_for_perimetro AS
SELECT t1.cmes,
       t1.cod_espana,
       t1.cod_soc_cpus,
       t1.descricao,
       t1.espanha_regulatorio,
       t1.espanha_ifrs,
       t1.st_sgps_portugal_regulatorio,
       t1.st_sgps_portugal_ifrs,
       t1.bst_consolidado_portugal_ifrs,
       t1.portugal_individual,
       t1.data_date_part
FROM cd_captools.perimetro t1
WHERE t1.data_date_part=${VAR:DATADATEPART};



CREATE TABLE bu_captools_work.filter_for_al001_cnt_core AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.tipo_balanco,
       t1.caplic,
       t1.cproduto,
       t1.csubprod,
       t1.ind_capit,
       t1.ind_renov,
       t1.prz_renov,
       t1.dfim_care,
       t1.cproduto_mis,
       t1.cmetamis,
       t1.csecuritizacao,
       t1.dinicio,
       t1.dfim,
       t1.flag_cons_alm,
       t1.conta_contab,
       t1.cmoeda_pas,
       t1.cmoeda_act,
       t1.dt_prox_amort_capital_pas,
       t1.dt_prox_amort_capital_act,
       t1.cod_freq_amort_capital_pas,
       t1.cod_freq_amort_capital_act,
       t1.cod_tipo_amortizacao,
       t1.dt_prox_liq_juros_pas,
       t1.dt_prox_liq_juros_act,
       t1.cod_freq_liq_jur_pas,
       t1.cod_freq_liq_jur_act,
       t1.cod_tipo_dias_calc_pas,
       t1.cod_tipo_dias_calc_act,
       t1.dt_prox_renov_taxa_pas,
       t1.dt_prox_renov_taxa_act,
       t1.cod_tipo_taxa_pas,
       t1.cod_tipo_taxa_act,
       t1.cod_freq_taxa_pas,
       t1.cod_freq_taxa_act,
       t1.cod_tipo_taxa_ref_pas,
       t1.cod_tipo_taxa_ref_act,
       t1.tx_contrato_pas,
       t1.tx_contrato_act,
       t1.cod_sinal_spread_pas_1,
       t1.cod_sinal_spread_act_1,
       t1.tx_spread_pas_1,
       t1.tx_spread_act_1,
       t1.tx_indexante,
       t1.tipo_contrato,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.origem
FROM cd_alm.al001_cnt_core t1
WHERE t1.ref_date=${VAR:REFDATE};


CREATE TABLE bu_captools_work.query_for_ct008_refdate AS
SELECT t1.cod_plano,
       t1.cod_contavirt,
       t1.nome_plano_contas,
       t1.conta,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao
FROM bu_captools_work.ct008_refdate t1
WHERE t1.cod_plano = 'BST_IFRS_IFRS';


CREATE TABLE bu_captools_work.filter_for_ct010_dim_valor_0000 AS
SELECT t1.cod_atributo_dim,
       t1.nome_atributo_dim,
       t1.desc_atributo_dim,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao,
       t1.id_dimensao
FROM bu_captools_work.filter_for_ct010_dim_valor t1
WHERE t1.id_dimensao = 44;


CREATE TABLE bu_captools_work.filter_for_ct010_dim_valor_0001 AS
SELECT t1.cod_atributo_dim,
       t1.nome_atributo_dim,
       t1.desc_atributo_dim,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao,
       t1.id_dimensao
FROM bu_captools_work.filter_for_ct010_dim_valor t1
WHERE t1.id_dimensao = 43;


CREATE TABLE bu_captools_work.query_for_filter_for_clientes_in AS
SELECT t1.cmes,
       t1.centidade,
       t1.zcliente,
       t1.nome,
       t1.consolpt,
       t1.consoles,
       t1.pais,
       t1.outros,
       t1.cdata,
       t1.iconspt,
       t1.data_date_part,
       t1.data_timestamp_part,
       t2.st_sgps_portugal_ifrs
FROM
bu_captools_work.filter_for_clientes_intragrupo t1
LEFT JOIN
bu_captools_work.query_for_perimetro t2
ON (t1.consolpt = t2.cod_soc_cpus) AND (t1.consoles = t2.cod_espana)
;


CREATE TABLE bu_captools_work.query_for_filter_for_al001__0000 AS
SELECT DISTINCT t1.cempresa,
                t1.cbalcao,
                t1.cnumecta,
                t1.zdeposit,
                t1.zcliente,
                t1.tx_contrato_pas,
                t1.tx_contrato_act
FROM bu_captools_work.filter_for_al001_cnt_core t1
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct008_pv_co AS
SELECT t1.cod_plano,
       t1.conta,
       t2.cod_contavirt,
       t2.nome_contavirt
FROM bu_captools_work.query_for_ct008_refdate t1,
     bu_captools_work.query_for_ct007_pv_planos t2
WHERE (t1.cod_plano = t2.cod_plano
       AND t1.cod_contavirt = t2.cod_contavirt)
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct081__0000 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.contraparte_i,
       t2.nome_atributo_dim AS contraparte_i_desc,
       t1.produto,
       t1.carteira_contabilistica,
       t1.tipo_conta,
       t1.instrumento_financeiro,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date
FROM
bu_captools_work.filter_for_ct081_finrep t1
LEFT JOIN
bu_captools_work.filter_for_ct010_dim_valor_0001 t2
ON (t1.contraparte_i = t2.cod_atributo_dim)
;



CREATE TABLE bu_captools_work.passivo AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.tx_contrato_pas
FROM bu_captools_work.query_for_filter_for_al001__0000 t1
WHERE t1.tx_contrato_pas IS NOT NULL;



CREATE TABLE bu_captools_work.ativo AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.tx_contrato_act
FROM bu_captools_work.query_for_filter_for_al001__0000 t1
WHERE t1.tx_contrato_act IS NOT NULL;


CREATE TABLE bu_captools_work.query_for_filter_for_ct008__0001 AS
SELECT t1.cod_plano,
       t1.conta,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t2.nivel_3,
       t2.nivel_4,
       t2.nivel_5
FROM bu_captools_work.query_for_filter_for_ct008_pv_co t1
LEFT JOIN
bu_captools_work.filter_for_ct011_dim_hier t2
ON (t1.conta = t2.nivel_12)
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct081 AS
SELECT  		t1.cempresa,
                t1.cbalcao,
                t1.cnumecta,
                t1.zdeposit,
				/* MIN_of_contraparte_i */ (MIN(t1.contraparte_i)) AS MIN_of_contraparte_i,
				/* MIN_of_contraparte_i_desc */ (MIN(t1.contraparte_i_desc)) AS MIN_of_contraparte_i_desc
FROM bu_captools_work.query_for_filter_for_ct081__0000 t1
WHERE t1.contraparte_i <> ''
GROUP BY t1.cempresa,
         t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct010_dim_v AS
SELECT t2.cod_plano,
       t2.conta,
       t2.cod_contavirt,
       t2.nome_contavirt,
       t1.nome_atributo_dim,
       t2.nivel_3,
       t2.nivel_4,
       t2.nivel_5
FROM
bu_captools_work.filter_for_ct010_dim_valor_0000 t1
RIGHT JOIN
bu_captools_work.query_for_filter_for_ct008__0001 t2
ON (t1.cod_atributo_dim = t2.conta)
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct010__0000 AS
SELECT t2.cod_plano,
       t2.conta,
       t2.cod_contavirt,
       t2.nome_contavirt,
       t2.nome_atributo_dim,
       t1.nome_atributo_dim AS nome_atributo_dim3,
       t2.nivel_3,
       t2.nivel_4,
       t2.nivel_5
FROM
bu_captools_work.filter_for_ct010_dim_valor_0000 t1
RIGHT JOIN
bu_captools_work.query_for_filter_for_ct010_dim_v t2
ON (t1.cod_atributo_dim = t2.nivel_3)
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct010__0001 AS
SELECT t2.cod_plano,
       t2.conta,
       t2.cod_contavirt,
       t2.nome_contavirt,
       t2.nome_atributo_dim,
       t2.nome_atributo_dim3,
       t1.nome_atributo_dim AS nome_atributo_dim4,
       t2.nivel_3,
       t2.nivel_4,
       t2.nivel_5
FROM
bu_captools_work.filter_for_ct010_dim_valor_0000 t1
RIGHT JOIN
bu_captools_work.query_for_filter_for_ct010__0000 t2
ON (t1.cod_atributo_dim = t2.nivel_4);


CREATE TABLE bu_captools_work.query_for_filter_for_ct010__0002 AS
SELECT t2.cod_plano,
       t2.conta,
       t2.cod_contavirt,
       t2.nome_contavirt,
       t2.nome_atributo_dim,
       t2.nome_atributo_dim3,
       t2.nome_atributo_dim4,
       t1.nome_atributo_dim AS nome_atributo_dim5
FROM
bu_captools_work.filter_for_ct010_dim_valor_0000 t1
RIGHT JOIN
bu_captools_work.query_for_filter_for_ct010__0001 t2
ON (t1.cod_atributo_dim = t2.nivel_5);


CREATE TABLE bu_captools_work.query_for_balanco_ind_0000 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.msaldo_inicial,
       t1.msaldo_final,
       t1.ccontab_inicial_pcsb,
       t1.ccontab_inicial_ifrs,
       t1.ccontab_inicial_cargabal,
       t1.ccontab_inicial_sgps_cons,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.ccontab_final_cargabal,
       t1.ccontab_final_sgps_cons,
       t1.origem,
       t1.flag_ativo,
       t1.ref_date,
       t2.cod_contavirt,
       t2.nome_contavirt,
       t2.nome_atributo_dim,
       t2.nome_atributo_dim3,
       t2.nome_atributo_dim4,
       t2.nome_atributo_dim5
FROM
bu_captools_work.balanco_ind t1
LEFT JOIN
bu_captools_work.query_for_filter_for_ct010__0002 t2
ON (t1.ccontab_final_ifrs = t2.conta);


CREATE TABLE bu_captools_work.query_for_filter_for_ct001_0005 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.msaldo_inicial,
       t1.msaldo_final,
       t1.ccontab_inicial_pcsb,
       t1.ccontab_inicial_ifrs,
       t1.ccontab_inicial_cargabal,
       t1.ccontab_inicial_sgps_cons,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.ccontab_final_cargabal,
       t1.ccontab_final_sgps_cons,
       t1.origem,
       t1.flag_ativo,
       t1.ref_date,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t2.MIN_of_contraparte_i AS contraparte_i,
       t2.MIN_of_contraparte_i_desc AS contraparte_i_desc
FROM
bu_captools_work.query_for_filter_for_ct081 t2
RIGHT JOIN
bu_captools_work.query_for_balanco_ind_0000 t1
ON (t2.cempresa = t1.cempresa)
AND (t2.cbalcao = t1.cbalcao)
AND (t2.cnumecta = t1.cnumecta)
AND (t2.zdeposit = t1.zdeposit)
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct001_0006 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t2.flag_pme
FROM
bu_captools_work.query_for_filter_for_ct001_0005 t1
LEFT JOIN
bu_captools_work.filter_for_ct063_univ_pme t2
ON (t1.zcliente = t2.zcliente);


CREATE TABLE bu_captools_work.query_for_filter_for_ct001_0008 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t2.ccae,
       t2.csector_inst,
       t2.gcliente,
       t2.clei,
       t2.cpais_residencia,
       t2.ccli_grupo
FROM
bu_captools_work.query_for_filter_for_ct001_0006 t1
LEFT JOIN
bu_captools_work.filter_for_ct003_univ_cli t2
ON (t1.zcliente = t2.zcliente);


CREATE TABLE bu_captools_work.query_for_filter_for_ct001 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.ccli_grupo,
       t1.csector_inst,
       t2.dabertur,
       t2.ddvencim,
       t2.ref_date
FROM
bu_captools_work.query_for_filter_for_ct001_0008 t1
LEFT JOIN
bu_captools_work.filter_for_ct004_univ_cto t2
ON (t1.zcliente = t2.zcliente)
AND (t1.cempresa = t2.cempresa)
AND (t1.cbalcao = t2.cbalcao)
AND (t1.cnumecta = t2.cnumecta)
AND (t1.zdeposit = t2.zdeposit);


CREATE TABLE bu_captools_work.query_for_filter_for_ct001_0007 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.ccli_grupo,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t3.nome AS empresa_intragrupo,
       t3.st_sgps_portugal_ifrs,
       t1.ref_date
FROM
bu_captools_work.query_for_filter_for_clientes_in t3
RIGHT JOIN
bu_captools_work.query_for_filter_for_ct001 t1 ON
(t3.zcliente = t1.zcliente)
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct001_0009 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.ccli_grupo,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t2.tx_contrato_pas,
       t1.ref_date,
       t1.st_sgps_portugal_ifrs
FROM
bu_captools_work.query_for_filter_for_ct001_0007 t1
LEFT JOIN
bu_captools_work.passivo t2
ON (t1.cempresa = t2.cempresa)
AND (t1.cbalcao = t2.cbalcao)
AND (t1.cnumecta = t2.cnumecta)
AND (t1.zdeposit = t2.zdeposit)
AND (t1.zcliente = t2.zcliente)
;


CREATE TABLE bu_captools_work.query_for_filter_for_ct001_000f AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.ccli_grupo,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.tx_contrato_pas,
       t2.tx_contrato_act,
       t1.ref_date,
       t1.st_sgps_portugal_ifrs
FROM
bu_captools_work.query_for_filter_for_ct001_0009 t1
LEFT JOIN
bu_captools_work.ativo t2
ON (t1.cempresa = t2.cempresa)
AND (t1.cempresa = t2.cempresa)
AND (t1.cbalcao = t2.cbalcao)
AND (t1.cnumecta = t2.cnumecta)
AND (t1.zdeposit = t2.zdeposit)
AND (t1.zcliente = t2.zcliente);


CREATE TABLE bu_captools_work.ldrmasterindividual202212 AS
SELECT *
FROM bu_captools_work.query_for_filter_for_ct001_000F t1;



------
------
------
------Começa aqui o segundo documento "LDR parte 2"
------
------
------


CREATE TABLE bu_captools_work.query_for_ldrmaster AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.ccli_grupo,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.tx_contrato_pas,
       t1.tx_contrato_act,
       t1.ref_date,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.ldrmasterindividual202212 t1
WHERE t1.msaldo_final IS NOT NULL;


CREATE TABLE bu_captools_work.query_for_al015_act_fin AS
SELECT t1.cempresa_pas,
       t1.cbalcao_pas,
       t1.cnumecta_pas,
       t1.zdeposit_pas,
       t1.zcliente_pas,
       CAST(SUM(t1.mon_equiv_util_ae) AS DECIMAL(23,6)) AS Calculation,
       CAST(SUM(t1.nom_util_intr_ae) AS DECIMAL(23,6)) AS Calculation1,
       CAST(SUM(t1.mon_equiv_util_lcr) AS DECIMAL(23,6)) AS Calculation2,
       t1.nome_perimetro
FROM cd_alm.al015_act_fin t1
WHERE t1.ref_date=${VAR:REFDATE}
  AND t1.nome_perimetro = 'Individual Local'
GROUP BY t1.cempresa_pas,
         t1.cbalcao_pas,
         t1.cnumecta_pas,
         t1.zdeposit_pas,
         t1.zcliente_pas,
         t1.nome_perimetro ;


CREATE TABLE bu_captools_work.filter_for_ct610_titulos AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.isin,
       t1.cod_sigom,
       t1.cod_idt,
       t1.cod_ida,
       t1.cod_rvbl_rfij,
       t1.descritivo,
       t1.zcliente_emitente,
       t1.zcliente_investidor,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.cmoeda,
       t1.tipo_oferta,
       t1.tipo_titulo,
       t1.tipo_exposicao,
       t1.cproduto,
       t1.csubprod,
       t1.soberano,
       t1.termo_estruturado,
       t1.lei_aplicavel,
       t1.garantia,
       t1.cempresa_gar,
       t1.cbalcao_gar,
       t1.cnumecta_gar,
       t1.zdeposit_gar,
       t1.entidade_garante,
       t1.valor_garantia,
       t1.nom_tot_inic,
       t1.nom_unit_inic,
       t1.prc_inic,
       t1.pool_factor,
       t1.nom_tot_atual,
       t1.nom_unit_atual,
       t1.nom_tot_ini_investe,
       t1.tipo_tx,
       t1.tx_fixa,
       t1.indx_tx_var,
       t1.sprd_tx_var,
       t1.tx_max,
       t1.tx_min,
       t1.indx_tx_max,
       t1.indx_tx_min,
       t1.tx_vigente,
       t1.dt_fim_tx_fixa,
       t1.dt_fim_sprd_tx_var,
       t1.dt_fim_indx_tx_var,
       t1.dt_prim_liq_jur,
       t1.frq_liq_jur,
       t1.dt_prim_refx_tx_var,
       t1.frq_refx_tx_var,
       t1.conv_calc_juros,
       t1.tipo_amrt,
       t1.dt_prim_amrt,
       t1.frq_amrt,
       t1.dt_prim_amrt_ant_emit,
       t1.frq_amrt_ant_emit,
       t1.dt_prim_amrt_ant_inv,
       t1.frq_amrt_ant_inv,
       t1.val_residual,
       t1.agente_pagador,
       t1.depositario,
       t1.central_valores,
       t1.bolsa_valores,
       t1.sist_liquidacao,
       t1.trustee,
       t1.idx_bolsa,
       t1.eleg_fund_prop,
       t1.mon_fund_prop,
       t1.flg_deduc_fund_prop,
       t1.rw_adic_regul,
       t1.trat_capital,
       t1.bail_in,
       t1.rank_insolv,
       t1.mon_financ_emit,
       t1.eleg_eurosistema,
       t1.flag_buffer_liq,
       t1.grau_liquidez,
       t1.flg_alm,
       t1.flg_cons_alm,
       t1.rating_sp_ini,
       t1.dt_rating_sp_ini,
       t1.rating_sp,
       t1.dt_rating_sp,
       t1.rating_moodys_ini,
       t1.dt_rating_moodys_ini,
       t1.rating_moodys,
       t1.dt_rating_moodys,
       t1.rating_fitch_ini,
       t1.dt_rating_fitch_ini,
       t1.rating_fitch,
       t1.dt_rating_fitch,
       t1.rating_dbrs_ini,
       t1.dt_rating_dbrs_ini,
       t1.rating_dbrs,
       t1.dt_rating_dbrs,
       t1.ind_cri_rtint,
       t1.flg_ativo,
       t1.tipo_aval,
       t1.htimestupload,
       t1.ref_date
FROM cd_captools.ct610_titulos t1
WHERE t1.ref_date=${VAR:REFDATE};


CREATE TABLE bu_captools_work.filter_for_ct069_univ_gr_ec_0000 AS
SELECT t1.zgrupo,
       t1.nomegrup,
       t1.zcliente_princ,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao
FROM cd_captools.ct069_univ_gr_ec t1
WHERE t1.ref_date=${VAR:REFDATE} ;


CREATE TABLE bu_captools_work.filter_for_ct070_univ_gr_cl_0000 AS
SELECT t1.zcliente,
       t1.zgrupo,
       t1.tipo_relacao,
       t1.zgrupo_controlo,
       t1.crelcli,
       t1.percpart,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date,
       t1.cod_visao,
       t1.origem
FROM cd_captools.ct070_univ_gr_cli t1
WHERE t1.ref_date=${VAR:REFDATE} ;




CREATE TABLE bu_captools_work.query_for_ldrmaster_0004 AS
SELECT t1.zdeposit,
       t1.zcliente,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS sum_of_msaldo_final,
       t1.cod_contavirt,
       t1.flag_pme,
       t1.contraparte_i_desc,
       t1.cpais_residencia,
       t1.empresa_intragrupo,
       t1.ref_date,
       t1.csector_inst,
       t1.st_sgps_portugal_ifrs,
       t1.cmoeda
FROM bu_captools_work.query_for_ldrmaster t1
WHERE t1.cod_contavirt = 'C_32'
GROUP BY t1.zdeposit,
         t1.zcliente,
         t1.cod_contavirt,
         t1.flag_pme,
         t1.contraparte_i_desc,
         t1.cpais_residencia,
         t1.empresa_intragrupo,
         t1.ref_date,
         t1.csector_inst,
         t1.st_sgps_portugal_ifrs,
         t1.cmoeda;



CREATE TABLE bu_captools_work.QUERY_FOR_LDRMASTER_0005_0000 AS
SELECT t2.zdeposit AS zdeposit1,
       t2.cempresa,
       t2.cbalcao,
       t2.cnumecta,
       t2.zdeposit,
       (substr(t2.ccontab_final_ifrs,1,2)) AS _Calculation,
       t2.gcliente,
       t2.clei,
       t2.zcliente,
       CAST(SUM(t2.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       CAST(SUM(t1.Calculation) AS DECIMAL(23,6)) AS Colateral,
       t2.cpais_residencia,
       t2.st_sgps_portugal_ifrs
FROM
bu_captools_work.query_for_ldrmaster t2
LEFT JOIN
bu_captools_work.query_for_al015_act_fin t1
ON (t2.cempresa = t1.cempresa_pas)
AND (t2.cbalcao = t1.cbalcao_pas)
AND (t2.cnumecta = t1.cnumecta_pas)
AND (t2.zdeposit = t1.zdeposit_pas)
WHERE (t2.cod_contavirt = '' OR t2.cod_contavirt is NULL)
AND t2.empresa_intragrupo <> ''
GROUP BY t2.zdeposit,
         t2.cempresa,
         t2.cbalcao,
         t2.cnumecta,
         _Calculation,
         t2.gcliente,
         t2.clei,
         t2.zcliente,
         t2.cpais_residencia,
         t2.st_sgps_portugal_ifrs ;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0005_00_0002 AS
SELECT t2.cbalcao,
       t2.cnumecta,
       t2.zdeposit,
       (substr(t2.ccontab_final_ifrs,1,2)) AS _Calculation,
       t2.gcliente,
       t2.clei,
       t2.zcliente,
       CAST(SUM(t2.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       CAST(SUM(t1.Calculation) AS DECIMAL(23,6)) AS Colateral,
       t2.cpais_residencia,
       t2.st_sgps_portugal_ifrs
FROM
bu_captools_work.query_for_ldrmaster t2
LEFT JOIN
bu_captools_work.query_for_al015_act_fin t1
ON (t2.cempresa = t1.cempresa_pas)
AND (t2.cbalcao = t1.cbalcao_pas)
AND (t2.cnumecta = t1.cnumecta_pas)
AND (t2.zdeposit = t1.zdeposit_pas)
WHERE t2.cod_contavirt like '%E%'
AND t2.empresa_intragrupo <> ''
GROUP BY t2.cbalcao,
         t2.cnumecta,
         t2.zdeposit,
         _Calculation,
         t2.gcliente,
         t2.clei,
         t2.zcliente,
         t2.cpais_residencia,
         t2.st_sgps_portugal_ifrs ;


CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_000e AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.tx_contrato_pas,
       t1.tx_contrato_act,
       t1.ref_date
FROM bu_captools_work.query_for_ldrmaster t1
WHERE t1.cod_contavirt = 'P_22';


CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_0002 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.query_for_ldrmaster t1
WHERE t1.cod_contavirt = 'P_21' OR t1.cod_contavirt = 'P_20' ;


CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_000c AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.tx_contrato_pas,
       t1.tx_contrato_act,
       t1.ref_date
FROM bu_captools_work.query_for_ldrmaster t1
WHERE t1.cod_contavirt = 'P_20' OR t1.cod_contavirt = 'P_24' OR t1.cod_contavirt = 'P_28.1' OR t1.cod_contavirt = 'P_28.2' ;


CREATE TABLE bu_captools_work.filter_for_query_for_ldrmaster AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia
FROM bu_captools_work.query_for_ldrmaster t1
WHERE t1.cod_contavirt = 'P_17' OR t1.cod_contavirt = 'P_25' ;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0007 AS
SELECT t1.cod_contavirt,
       t1.zcliente,
       t1.contraparte_i_desc,
       t1.descritivo,
       t1.gcliente,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.clei,
       t1.cpais_residencia,
       t1.msaldo_final,
       t2.Calculation
FROM
bu_captools_work.query_for_ldrmaster t1
LEFT JOIN
bu_captools_work.query_for_al015_act_fin t2
ON (t1.cempresa = t2.cempresa_pas)
AND (t1.cbalcao = t2.cbalcao_pas)
AND (t1.zdeposit = t2.zdeposit_pas)
AND (t1.cnumecta = t2.cnumecta_pas)
WHERE t1.cod_contavirt = 'P_20' OR t1.cod_contavirt = 'P_19' ;


CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_0006 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.tx_contrato_pas,
       t1.tx_contrato_act,
       t1.ref_date
FROM bu_captools_work.query_for_ldrmaster t1
WHERE t1.cod_contavirt LIKE '%P_30%' OR t1.cod_contavirt LIKE '%P_27%' OR t1.cod_contavirt = 'P_24' ;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0013 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.msaldo_final,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.gcliente,
       t1.empresa_intragrupo
FROM bu_captools_work.query_for_ldrmaster t1
WHERE t1.cod_contavirt = 'C_31' ;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0014 AS
SELECT t1.cod_contavirt,
       t1.nome_contavirt,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       t1.gcliente,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo
FROM bu_captools_work.query_for_ldrmaster t1
WHERE t1.cod_contavirt = 'C_32'
GROUP BY t1.cod_contavirt,
         t1.nome_contavirt,
         t1.gcliente,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.empresa_intragrupo ;


CREATE TABLE bu_captools_work.query_for_ldrmaster1 AS
SELECT t2.ccontab_final_ifrs,
       t2.cod_contavirt,
       t2.nome_contavirt,
       t2.nome_atributo_dim,
       t2.nome_atributo_dim3,
       t2.nome_atributo_dim4,
       t2.nome_atributo_dim5,
       CAST(SUM(t2.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       (SUBSTR(t2.ccontab_final_ifrs, 1, 2)) AS Calculation,
       t2.contraparte_i_desc,
       t2.gcliente,
       (IF(t2.empresa_intragrupo='' OR t2.empresa_intragrupo IS NULL, '','1')) AS Intragrupo,
       t2.flag_pme,
       (IF(t2.csector_inst LIKE 'S128%' AND t2.csector_inst IS NOT NULL, 'S128','')) AS csector_inst
FROM bu_captools_work.query_for_ldrmaster t2
GROUP BY t2.ccontab_final_ifrs,
         t2.cod_contavirt,
         t2.nome_contavirt,
         t2.nome_atributo_dim,
         t2.nome_atributo_dim3,
         t2.nome_atributo_dim4,
         t2.nome_atributo_dim5,
         Calculation,
         t2.contraparte_i_desc,
         t2.gcliente,
         Intragrupo,
         t2.flag_pme,
         csector_inst ;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0011 AS
SELECT t2.cod_contavirt,
       t2.ccontab_final_ifrs,
       CAST(SUM(t2.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final1,
       t2.nome_atributo_dim,
       t2.nome_atributo_dim3,
       t2.nome_atributo_dim4,
       t2.nome_atributo_dim5
FROM bu_captools_work.query_for_ldrmaster t2
WHERE t2.cod_contavirt = 'P_24'
  OR t2.cod_contavirt = 'P_27.1'
  OR t2.cod_contavirt = 'P_27.2'
  OR t2.cod_contavirt = 'P_30.1'
  OR t2.cod_contavirt = 'P_30.3'
GROUP BY t2.cod_contavirt,
         t2.ccontab_final_ifrs,
         t2.nome_atributo_dim,
         t2.nome_atributo_dim3,
         t2.nome_atributo_dim4,
         t2.nome_atributo_dim5 ;


CREATE TABLE bu_captools_work.FILTER_FOR_FG001_FGD AS
SELECT t1.cempresa,
      t1.cbalcao,
      t1.cnumecta,
      t1.zdeposit,
      t1.ccliente,
      t1.indexc,
      t1.artigo,
      t1.nartigo,
      t1.calinea,
      t1.ndepositantes,
      t1.gcliente,
      t1.ctipdoc,
      t1.ckdocid,
      t1.csetor_inst,
      t1.cconta,
      t1.tpconta,
      t1.msaldo,
      t1.caractcta,
      t1.qtitular,
      t1.pcapjur,
      t1.sldimp,
      t1.mjurimp,
      t1.ccontab,
      t1.ccontab_juro,
      t1.cmoeda_orig,
      t1.cpais_fiscal,
      t1.cnatureza_juri,
      t1.csubproduto,
      t1.caplic,
      t1.flag_ativo,
      t1.mgarantido_eur,
      t1.mgarantido_me,
      t1.mtot_garantido_por_deposito,
      t1.prop_dep_eur,
      t1.prop_dep_me,
      t1.mcoberto_eur,
      t1.mcoberto_me,
      t1.mtot_coberto_por_depositante,
      t1.mtot_nao_coberto_por_depositante,
      t1.classes,
      t1.ctipo_contrato,
      t1.ckutulmo,
      t1.htimest,
      t1.ref_date
FROM CD_ALM.FG001_FGD t1
WHERE t1.ref_date = ${VAR:REFDATE};


CREATE TABLE bu_captools_work.filter_for_fg001_fgd_0000 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.ccliente,
       t1.indexc,
       t1.artigo,
       t1.nartigo,
       t1.calinea,
       t1.ndepositantes,
       t1.gcliente,
       t1.ctipdoc,
       t1.ckdocid,
       t1.csetor_inst,
       t1.cconta,
       t1.tpconta,
       t1.msaldo,
       t1.caractcta,
       t1.qtitular,
       t1.pcapjur,
       t1.sldimp,
       t1.mjurimp,
       t1.ccontab,
       t1.ccontab_juro,
       t1.cmoeda_orig,
       t1.cpais_fiscal,
       t1.cnatureza_juri,
       t1.csubproduto,
       t1.caplic,
       t1.flag_ativo,
       t1.mgarantido_eur,
       t1.mgarantido_me,
       t1.mtot_garantido_por_deposito,
       t1.prop_dep_eur,
       t1.prop_dep_me,
       t1.mcoberto_eur,
       t1.mcoberto_me,
       t1.mtot_coberto_por_depositante,
       t1.mtot_nao_coberto_por_depositante,
       t1.classes,
       t1.ctipo_contrato,
       t1.ckutulmo,
       t1.htimest,
       t1.ref_date
FROM bu_captools_work.filter_for_fg001_fgd t1
WHERE t1.calinea = '#' ;


CREATE TABLE bu_captools_work.FILTER_FOR_CQ_ISDA_0000 AS
SELECT t1.zcliente,
       t1.cod_kgr,
       t1.zcliente_sigom,
       t1.nome,
       t1.cod_ref_cq,
       t1.cod_tip_contrato,
       t1.dt_fim,
       t1.data_timestamp_part,
       t1.data_date_part
 FROM CD_ALM.CQ_ISDA t1
 WHERE t1.data_date_part = ${VAR:DATADATEPART};


CREATE TABLE bu_captools_work.query_for_filter_for_query_0015 AS
SELECT t2.cod_ref_cq,
       t2.cod_tip_contrato,
       t2.dt_fim
FROM bu_captools_work.filter_for_cq_isda_0000 t2 ;


CREATE TABLE bu_captools_work.query_for_filter_for_ct610_titul AS
SELECT t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.isin,
       t1.cod_sigom,
       t1.cod_idt,
       t1.cod_ida,
       t1.cod_rvbl_rfij,
       t1.descritivo,
       t1.zcliente_emitente,
       t1.zcliente_investidor,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.cmoeda,
       t1.tipo_oferta,
       t1.tipo_titulo,
       t1.tipo_exposicao,
       t1.cproduto,
       t1.csubprod,
       t1.soberano,
       t1.termo_estruturado,
       t1.lei_aplicavel,
       t1.garantia,
       t1.cempresa_gar,
       t1.cbalcao_gar,
       t1.cnumecta_gar,
       t1.zdeposit_gar,
       t1.entidade_garante,
       CAST(SUM(t1.valor_garantia) AS DECIMAL(19,2)) AS SUM_of_valor_garantia,
       t1.nom_tot_inic,
       t1.nom_unit_inic,
       t1.prc_inic,
       t1.pool_factor,
       t1.nom_tot_atual,
       t1.nom_unit_atual,
       t1.nom_tot_ini_investe,
       t1.tipo_tx,
       t1.tx_fixa,
       t1.indx_tx_var,
       t1.sprd_tx_var,
       t1.tx_max,
       t1.tx_min,
       t1.indx_tx_max,
       t1.indx_tx_min,
       t1.tx_vigente,
       t1.dt_fim_tx_fixa,
       t1.dt_fim_sprd_tx_var,
       t1.dt_fim_indx_tx_var,
       t1.dt_prim_liq_jur,
       t1.frq_liq_jur,
       t1.dt_prim_refx_tx_var,
       t1.frq_refx_tx_var,
       t1.conv_calc_juros,
       t1.tipo_amrt,
       t1.dt_prim_amrt,
       t1.frq_amrt,
       t1.dt_prim_amrt_ant_emit,
       t1.frq_amrt_ant_emit,
       t1.dt_prim_amrt_ant_inv,
       t1.frq_amrt_ant_inv,
       t1.val_residual,
       t1.agente_pagador,
       t1.depositario,
       t1.central_valores,
       t1.bolsa_valores,
       t1.sist_liquidacao,
       t1.trustee,
       t1.idx_bolsa,
       t1.eleg_fund_prop,
       t1.mon_fund_prop,
       t1.flg_deduc_fund_prop,
       t1.rw_adic_regul,
       t1.trat_capital,
       t1.bail_in,
       t1.rank_insolv,
       t1.mon_financ_emit,
       t1.eleg_eurosistema,
       t1.flag_buffer_liq,
       t1.grau_liquidez,
       t1.flg_alm,
       t1.flg_cons_alm,
       t1.rating_sp_ini,
       t1.dt_rating_sp_ini,
       t1.rating_sp,
       t1.dt_rating_sp,
       t1.rating_moodys_ini,
       t1.dt_rating_moodys_ini,
       t1.rating_moodys,
       t1.dt_rating_moodys,
       t1.rating_fitch_ini,
       t1.dt_rating_fitch_ini,
       t1.rating_fitch,
       t1.dt_rating_fitch,
       t1.rating_dbrs_ini,
       t1.dt_rating_dbrs_ini,
       t1.rating_dbrs,
       t1.dt_rating_dbrs,
       t1.ind_cri_rtint,
       t1.flg_ativo,
       t1.htimestupload,
       t1.ref_date
FROM bu_captools_work.filter_for_ct610_titulos t1
GROUP BY t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit,
         t1.isin,
         t1.cod_sigom,
         t1.cod_idt,
         t1.cod_ida,
         t1.cod_rvbl_rfij,
         t1.descritivo,
         t1.zcliente_emitente,
         t1.zcliente_investidor,
         t1.dt_emissao,
         t1.dt_vencim,
         t1.cmoeda,
         t1.tipo_oferta,
         t1.tipo_titulo,
         t1.tipo_exposicao,
         t1.cproduto,
         t1.csubprod,
         t1.soberano,
         t1.termo_estruturado,
         t1.lei_aplicavel,
         t1.garantia,
         t1.cempresa_gar,
         t1.cbalcao_gar,
         t1.cnumecta_gar,
         t1.zdeposit_gar,
         t1.entidade_garante,
         t1.nom_tot_inic,
         t1.nom_unit_inic,
         t1.prc_inic,
         t1.pool_factor,
         t1.nom_tot_atual,
         t1.nom_unit_atual,
         t1.nom_tot_ini_investe,
         t1.tipo_tx,
         t1.tx_fixa,
         t1.indx_tx_var,
         t1.sprd_tx_var,
         t1.tx_max,
         t1.tx_min,
         t1.indx_tx_max,
         t1.indx_tx_min,
         t1.tx_vigente,
         t1.dt_fim_tx_fixa,
         t1.dt_fim_sprd_tx_var,
         t1.dt_fim_indx_tx_var,
         t1.dt_prim_liq_jur,
         t1.frq_liq_jur,
         t1.dt_prim_refx_tx_var,
         t1.frq_refx_tx_var,
         t1.conv_calc_juros,
         t1.tipo_amrt,
         t1.dt_prim_amrt,
         t1.frq_amrt,
         t1.dt_prim_amrt_ant_emit,
         t1.frq_amrt_ant_emit,
         t1.dt_prim_amrt_ant_inv,
         t1.frq_amrt_ant_inv,
         t1.val_residual,
         t1.agente_pagador,
         t1.depositario,
         t1.central_valores,
         t1.bolsa_valores,
         t1.sist_liquidacao,
         t1.trustee,
         t1.idx_bolsa,
         t1.eleg_fund_prop,
         t1.mon_fund_prop,
         t1.flg_deduc_fund_prop,
         t1.rw_adic_regul,
         t1.trat_capital,
         t1.bail_in,
         t1.rank_insolv,
         t1.mon_financ_emit,
         t1.eleg_eurosistema,
         t1.flag_buffer_liq,
         t1.grau_liquidez,
         t1.flg_alm,
         t1.flg_cons_alm,
         t1.rating_sp_ini,
         t1.dt_rating_sp_ini,
         t1.rating_sp,
         t1.dt_rating_sp,
         t1.rating_moodys_ini,
         t1.dt_rating_moodys_ini,
         t1.rating_moodys,
         t1.dt_rating_moodys,
         t1.rating_fitch_ini,
         t1.dt_rating_fitch_ini,
         t1.rating_fitch,
         t1.dt_rating_fitch,
         t1.rating_dbrs_ini,
         t1.dt_rating_dbrs_ini,
         t1.rating_dbrs,
         t1.dt_rating_dbrs,
         t1.ind_cri_rtint,
         t1.flg_ativo,
         t1.htimestupload,
         t1.ref_date ;


CREATE TABLE bu_captools_work.query_for_filter_for_ct069__0000 AS
SELECT t1.zgrupo,
       t1.nomegrup,
       t2.zcliente,
       t1.zcliente_princ
FROM
bu_captools_work.filter_for_ct069_univ_gr_ec_0000 t1
FULL JOIN
bu_captools_work.filter_for_ct070_univ_gr_cl_0000 t2
ON (t1.zgrupo = t2.zgrupo) ;



CREATE TABLE bu_captools_work.filter_for_t_06_01_zclientes_22 AS
SELECT DISTINCT t1.zcliente,
                t1.classification
FROM bu_captools_work.t_06_01_zclientes_31_12_2021 t1
;



CREATE TABLE bu_captools_work.filter_for_balencete_22 AS
SELECT t1.ccontab_final_ifrs,
       t1.correcao_linhas AS Line,
       t1.insolvency_ranking_0001 AS Insolvency_Ranking,
       t1.type_of_non_financial_liabi_0001 AS Type_of_non_financial_liabilitie
FROM bu_captools_work.balancete_t_09_00 t1 ;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0000 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.tx_contrato_pas,
       t1.tx_contrato_act,
       t1.ref_date,
       t2.eleg_fund_prop,
       t2.mon_fund_prop,
       t2.lei_aplicavel,
       t2.termo_estruturado,
       t2.dt_emissao,
       t2.dt_vencim,
       t1.st_sgps_portugal_ifrs
FROM
bu_captools_work.query_for_ldrmaster t1
LEFT JOIN
bu_captools_work.query_for_filter_for_ct610_titul t2
ON (t1.cbalcao = t2.cbalcao)
AND (t1.cnumecta = t2.cnumecta)
AND (t1.zdeposit = t2.zdeposit)
WHERE t1.cod_contavirt LIKE '%C%' OR t1.cod_contavirt LIKE '%P%' ;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0005 AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.SUM_of_msaldo_final AS SUM_of_saldo,
       t1.cod_contavirt,
       t1.flag_pme,
       t1.contraparte_i_desc,
       t1.cpais_residencia,
       t1.empresa_intragrupo,
       t1.ref_date,
       t1.csector_inst,
       t1.st_sgps_portugal_ifrs,
       t1.cmoeda,
       t2.tayd91c0_gelem30 AS tayd91c0_gelem30
FROM
bu_captools_work.query_for_ldrmaster_0004 t1
LEFT JOIN
cd_captools.tat91_206 t2
ON (t1.cmoeda = t2.tayd91c0_celemtab) ;

CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_000d AS
SELECT t1.zdeposit1,
       t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.gcliente,
       t1.clei,
       t1.zcliente,
       t1.SUM_of_msaldo_final,
       t1.Colateral,
       t1.cpais_residencia,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_ldrmaster_0005_0000 t1
WHERE t1._Calculation = '91' ;

CREATE TABLE bu_captools_work.query_for_ldrmaster_0005_00 AS
SELECT t1.zdeposit AS zdeposit1,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.gcliente,
       t1.clei,
       t1.zcliente,
       t1.SUM_of_msaldo_final,
       t1.Colateral,
       t1.cpais_residencia,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_ldrmaster_0005_00_0002 t1
WHERE t1._Calculation = '90' ;


CREATE TABLE bu_captools_work.query_for_filter_for_query__0034 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.tx_contrato_pas,
       t1.tx_contrato_act,
       t1.ref_date,
       t2.Calculation
FROM
bu_captools_work.filter_for_query_for_ldrmas_000e t1
LEFT JOIN
bu_captools_work.query_for_al015_act_fin t2 ON
(t1.cempresa = t2.cempresa_pas)
AND (t1.cbalcao = t2.cbalcao_pas)
AND (t1.cnumecta = t2.cnumecta_pas)
AND (t1.zdeposit = t2.zdeposit_pas)
AND (t1.zcliente = t2.zcliente_pas) ;



CREATE TABLE bu_captools_work.query_for_filter_for_query__003d AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.filter_for_query_for_ldrmas_0002 t1
WHERE (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL) ;


CREATE TABLE bu_captools_work.validacao_balanco_2 AS
SELECT
t1.cod_contavirt,
CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final1
FROM bu_captools_work.filter_for_query_for_ldrmas_000c t1
WHERE t1.cod_contavirt LIKE '%P_28%'
  OR t1.nome_atributo_dim = 'IMPOSTO DO SELO'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
  OR t1.nome_atributo_dim = 'IMPOSTO SOBRE VALOR ACRES'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
  OR t1.nome_atributo_dim = 'RETENCAO DE IMPOSTOS NA F'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
  OR t1.nome_atributo_dim = 'CONTRIBUICOES PARA A SEGU'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
GROUP BY t1.cod_contavirt ;



CREATE TABLE bu_captools_work.validacao_balanco AS
SELECT
t1.cod_contavirt,
CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final1
FROM bu_captools_work.filter_for_query_for_ldrmas_000c t1
WHERE t1.nome_atributo_dim = 'CREDORES POR OPERA¤åES SO'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
  OR t1.nome_atributo_dim = 'CREDORES POR FORNECIMENTO'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
GROUP BY t1.cod_contavirt;



CREATE TABLE bu_captools_work.query_for_filter_for_query__001f AS
SELECT t1.cmoeda,
       t1.clei,
       CAST(SUM(t1.msaldo_final)AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       CAST(AVG(t1.tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
       t1.ref_date,
       t1.contraparte_i_desc,
       (1) AS Calculation
FROM bu_captools_work.filter_for_query_for_ldrmas_000c t1
WHERE t1.nome_atributo_dim = 'CREDORES POR OPERA¤åES SO'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
  OR t1.nome_atributo_dim = 'CREDORES POR FORNECIMENTO'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
GROUP BY t1.cmoeda,
         t1.clei,
         t1.ref_date,
         t1.contraparte_i_desc,
         Calculation ;



CREATE TABLE bu_captools_work.query_for_filter_for_query__002c AS
SELECT t1.cmoeda,
       t1.clei,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       CAST(SUM(t1.tx_contrato_pas) AS DECIMAL(10,5)) AS SUM_juros,
       t1.ref_date,
       (2) AS Calculation
FROM bu_captools_work.filter_for_query_for_ldrmas_000c t1
WHERE t1.cod_contavirt LIKE '%P_28%'
  OR t1.nome_atributo_dim = 'IMPOSTO DO SELO'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
  OR t1.nome_atributo_dim = 'IMPOSTO SOBRE VALOR ACRES'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
  OR t1.nome_atributo_dim = 'RETENCAO DE IMPOSTOS NA F'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
  OR t1.nome_atributo_dim = 'CONTRIBUICOES PARA A SEGU'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
GROUP BY t1.cmoeda,
         t1.clei,
         t1.ref_date,
         Calculation ;



CREATE TABLE bu_captools_work.query_for_filter_for_query__002e AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.tx_contrato_pas,
       t1.tx_contrato_act,
       t1.ref_date
FROM bu_captools_work.filter_for_query_for_ldrmas_000c t1
WHERE t1.cod_contavirt = 'P_20'
  AND (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL);


CREATE TABLE bu_captools_work.query_for_filter_for_query_for_l AS
SELECT
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia
FROM bu_captools_work.filter_for_query_for_ldrmaster t1
GROUP BY t1.gcliente,
         t1.clei,
         t1.cpais_residencia ;



CREATE TABLE bu_captools_work.query_for_filter_for_query__000f AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t2.cod_ref_cq,
       t1.msaldo_final,
       t2.cod_tip_contrato,
       t1.empresa_intragrupo,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.zcliente AS zcliente1,
       t2.dt_fim
FROM
bu_captools_work.filter_for_query_for_ldrmaster t1
LEFT JOIN
bu_captools_work.filter_for_cq_isda_0000 t2
ON (t1.zcliente = t2.zcliente);


CREATE TABLE bu_captools_work.query_for_filter_for_query_fo AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       (IF(t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL,'','1')) AS Intragrupo
FROM bu_captools_work.filter_for_query_for_ldrmaster t1
GROUP BY t1.cempresa,
         t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit,
         Intragrupo;


CREATE TABLE bu_captools_work.filter_for_query_for_ldrmaster_0 AS
SELECT t1.cod_contavirt,
       t1.zcliente,
       t1.contraparte_i_desc,
       t1.gcliente,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.clei,
       t1.cpais_residencia,
       t1.msaldo_final,
       t1.Calculation
FROM bu_captools_work.query_for_ldrmaster_0007 t1
WHERE t1.nome_atributo_dim4 = 'Vendas com acordo de recompra (REPOS)'
  OR t1.cod_contavirt = 'P_19';


CREATE TABLE bu_captools_work.query_for_filter_for_query__0013 AS
SELECT t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.cmoeda,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       t1.cod_contavirt,
       t1.ccontab_final_ifrs,
       t1.contraparte_i_desc,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.ref_date
FROM bu_captools_work.filter_for_query_for_ldrmas_0006 t1
GROUP BY t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit,
         t1.cmoeda,
         t1.cod_contavirt,
         t1.ccontab_final_ifrs,
         t1.contraparte_i_desc,
         t1.nome_atributo_dim,
         t1.nome_atributo_dim3,
         t1.nome_atributo_dim4,
         t1.nome_atributo_dim5,
         t1.flag_pme,
         t1.empresa_intragrupo,
         t1.ref_date;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0005_00_0001 AS
SELECT t2.ccontab_final_ifrs,
          (substr(t2.ccontab_final_ifrs,1,2)) AS _Calculation,
          t2.ccli_grupo,
          t2.zcliente,
          t1.nomegrup,
          t1.zcliente_princ,
          t2.clei,
          t2.cpais_residencia,
          t2.contraparte_i_desc,
          t2.nome_atributo_dim,
          t2.nome_atributo_dim3,
          t2.nome_atributo_dim4,
          t2.nome_atributo_dim5,
          t2.msaldo_final
FROM
bu_captools_work.query_for_ldrmaster t2
LEFT JOIN
bu_captools_work.query_for_filter_for_ct069__0000 t1 ON (t2.zcliente = t1.zcliente)
WHERE t2.cod_contavirt LIKE '%E%' OR t2.cod_contavirt = '' OR t2.cod_contavirt IS NULL;


CREATE TABLE bu_captools_work.query_for_ldrmaster1_0001 AS
SELECT
CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
t1.contraparte_i_desc,
t1.flag_pme,
t1.Intragrupo,
t1.csector_inst
FROM bu_captools_work.query_for_ldrmaster1 t1
WHERE t1.Calculation = '90'
AND (t1.cod_contavirt <> 'E_3' OR t1.cod_contavirt IS NULL)
OR t1.Calculation = '92'
GROUP BY t1.contraparte_i_desc,
         t1.flag_pme,
         t1.Intragrupo,
         t1.csector_inst ;


CREATE TABLE bu_captools_work.query_for_ldrmaster1_0001_0000 AS
SELECT CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
          t1.contraparte_i_desc,
          t1.flag_pme,
          t1.Intragrupo,
          t1.csector_inst
FROM bu_captools_work.query_for_ldrmaster1 t1
WHERE t1.Calculation = '93'
GROUP BY t1.contraparte_i_desc,
               t1.flag_pme,
               t1.Intragrupo,
               t1.csector_inst ;



CREATE TABLE bu_captools_work.query_for_ldrmaster1_0000 AS
SELECT t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.SUM_of_msaldo_final,
       t1.Calculation,
       t1.contraparte_i_desc,
       t1.gcliente,
       t1.Intragrupo,
       t1.flag_pme,
       t1.csector_inst
FROM bu_captools_work.query_for_ldrmaster1 t1
WHERE t1.SUM_of_msaldo_final <> 0;


CREATE TABLE bu_captools_work.query_for_ldrmaster_000e AS
SELECT t1.cod_contavirt,
       t1.ccontab_final_ifrs,
       t1.SUM_of_msaldo_final1,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5
FROM bu_captools_work.query_for_ldrmaster_0011 t1
WHERE t1.cod_contavirt = 'P_27.2';



CREATE TABLE bu_captools_work.query_for_filter_for_fg001_fgd AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       CAST(SUM(t1.mgarantido_eur) AS DECIMAL(21,8)) AS Sum_of_Montante_Garantido,
       CAST(SUM(t1.mgarantido_me) AS DECIMAL(21,8)) AS SUM_of_mgarantido_me,
       CAST(SUM(t1.mcoberto_eur) AS DECIMAL(21,8)) AS SUM_of_mcoberto_eur,
       CAST(SUM(t1.mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_mcoberto_me
FROM bu_captools_work.filter_for_fg001_fgd_0000 t1
GROUP BY t1.cempresa,
         t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0018 AS
SELECT DISTINCT t1.zdeposit,
                t1.zcliente,
                t1.cmoeda,
                t1.cod_contavirt,
                t1.contraparte_i_desc,
                t1.flag_pme,
                t1.empresa_intragrupo,
                t1.cpais_residencia,
                t1.ref_date,
                t1.eleg_fund_prop,
                t1.lei_aplicavel,
                t1.termo_estruturado,
                t1.dt_emissao,
                t1.dt_vencim,
                t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_ldrmaster_0000 t1;


CREATE TABLE bu_captools_work.query_for_ldrmaster_000a AS
SELECT t1.cempresa,
          t1.cbalcao,
          t1.cnumecta,
          t1.zdeposit,
          t1.zcliente,
          t1.cmoeda,
          CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
          t1.cod_contavirt,
          t1.nome_atributo_dim,
          t1.nome_atributo_dim3,
          t1.nome_atributo_dim4,
          t1.nome_atributo_dim5,
          t1.contraparte_i_desc,
          t1.flag_pme,
          t1.ccae,
          t1.csector_inst,
          t1.empresa_intragrupo,
          t1.cpais_residencia,
          t1.tx_contrato_pas,
          t1.ref_date,
          t1.eleg_fund_prop,
          t1.mon_fund_prop,
          t1.lei_aplicavel,
          t1.termo_estruturado,
          t1.dt_emissao,
          t1.dt_vencim,
          t1.clei,
          t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_ldrmaster_0000 t1
WHERE t1.nome_atributo_dim NOT LIKE '%Juros%' AND t1.nome_atributo_dim NOT LIKE '%Despesa%'
GROUP BY t1.cempresa,
               t1.cbalcao,
               t1.cnumecta,
               t1.zdeposit,
               t1.zcliente,
               t1.cmoeda,
               t1.cod_contavirt,
               t1.nome_atributo_dim,
               t1.nome_atributo_dim3,
               t1.nome_atributo_dim4,
               t1.nome_atributo_dim5,
               t1.contraparte_i_desc,
               t1.flag_pme,
               t1.ccae,
               t1.csector_inst,
               t1.empresa_intragrupo,
               t1.cpais_residencia,
               t1.tx_contrato_pas,
               t1.ref_date,
               t1.eleg_fund_prop,
               t1.mon_fund_prop,
               t1.lei_aplicavel,
               t1.termo_estruturado,
               t1.dt_emissao,
               t1.dt_vencim,
               t1.clei,
               t1.st_sgps_portugal_ifrs;


CREATE TABLE bu_captools_work.query_for_ldrmaster_000a_0000 AS
SELECT t1.cempresa,
          t1.cbalcao,
          t1.cnumecta,
          t1.zdeposit,
          t1.zcliente,
          t1.cmoeda,
          CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
          t1.cod_contavirt,
          t1.nome_atributo_dim,
          t1.nome_atributo_dim3,
          t1.nome_atributo_dim4,
          t1.nome_atributo_dim5,
          t1.contraparte_i_desc,
          t1.flag_pme,
          t1.ccae,
          t1.csector_inst,
          t1.empresa_intragrupo,
          t1.cpais_residencia,
          t1.tx_contrato_pas,
          t1.ref_date,
          t1.eleg_fund_prop,
          t1.mon_fund_prop,
          t1.lei_aplicavel,
          t1.termo_estruturado,
          t1.dt_emissao,
          t1.dt_vencim,
          t1.clei,
          t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_ldrmaster_0000 t1
WHERE t1.nome_atributo_dim LIKE '%Juros%' OR t1.nome_atributo_dim LIKE '%Despesa%'
GROUP BY t1.cempresa,
               t1.cbalcao,
               t1.cnumecta,
               t1.zdeposit,
               t1.zcliente,
               t1.cmoeda,
               t1.cod_contavirt,
               t1.nome_atributo_dim,
               t1.nome_atributo_dim3,
               t1.nome_atributo_dim4,
               t1.nome_atributo_dim5,
               t1.contraparte_i_desc,
               t1.flag_pme,
               t1.ccae,
               t1.csector_inst,
               t1.empresa_intragrupo,
               t1.cpais_residencia,
               t1.tx_contrato_pas,
               t1.ref_date,
               t1.eleg_fund_prop,
               t1.mon_fund_prop,
               t1.lei_aplicavel,
               t1.termo_estruturado,
               t1.dt_emissao,
               t1.dt_vencim,
               t1.clei,
               t1.st_sgps_portugal_ifrs;



CREATE TABLE bu_captools_work.query_for_filter_for_query__0037 AS
SELECT t1.gcliente,
       t1.clei,
       t1.zcliente,
       CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       CAST(SUM(t1.Colateral) AS DECIMAL(23,6)) AS SUM_of_Colateral,
       t2.lei_aplicavel,
       t1.zdeposit1,
       t1.st_sgps_portugal_ifrs
FROM
bu_captools_work.filter_for_query_for_ldrmas_000d t1
LEFT JOIN
bu_captools_work.query_for_filter_for_ct610_titul t2
ON (t1.cbalcao = t2.cbalcao)
AND (t1.cnumecta = t2.cnumecta)
AND (t1.zdeposit = t2.zdeposit)
GROUP BY t1.gcliente,
         t1.clei,
         t1.zcliente,
         t2.lei_aplicavel,
         t1.zdeposit1,
         t1.st_sgps_portugal_ifrs;


CREATE TABLE bu_captools_work.query_for_ldrmaster_0005_00_0007 AS
SELECT t1.gcliente,
       t1.clei,
       t1.zcliente,
       CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       CAST(SUM(t1.Colateral) AS DECIMAL(23,6)) AS SUM_of_Colateral,
       t2.lei_aplicavel,
       t1.zdeposit1,
       t1.st_sgps_portugal_ifrs
FROM
bu_captools_work.query_for_ldrmaster_0005_00 t1
LEFT JOIN
bu_captools_work.query_for_filter_for_ct610_titul t2
ON (t1.cbalcao = t2.cbalcao)
AND (t1.cnumecta = t2.cnumecta)
AND (t1.zdeposit = t2.zdeposit)
GROUP BY t1.gcliente,
         t1.clei,
         t1.zcliente,
         t2.lei_aplicavel,
         t1.zdeposit1,
         t1.st_sgps_portugal_ifrs ;


CREATE TABLE bu_captools_work.query_for_filter_for_query__0031 AS
SELECT t2.cmoeda AS cmoeda,
CAST(SUM(t2.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
t2.descritivo AS descritivo,
t2.nome_atributo_dim5 AS nome_atributo_dim5,
t2.zdeposit AS zdeposit,
t2.contraparte_i_desc AS contraparte_i_desc,
t2.empresa_intragrupo AS empresa_intragrupo,
CAST(SUM(t2.Calculation) AS DECIMAL(23,6)) AS SUM_of_Calculation
FROM bu_captools_work.query_for_filter_for_query__0034 t2
WHERE t2.nome_atributo_dim = 'Capital/ Nocional/ Custo'
  OR t2.nome_atributo_dim = 'Valias e correccoes de Valor por operacoes Microcobertura'
GROUP BY t2.cmoeda,
         t2.descritivo,
         t2.nome_atributo_dim5,
         t2.zdeposit,
         t2.contraparte_i_desc,
         t2.empresa_intragrupo;


CREATE TABLE bu_captools_work.query_for_filter_for_query__0032 AS
SELECT t2.cmoeda AS cmoeda,
          CAST(SUM(t2.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
          t2.descritivo AS descritivo,
          t2.nome_atributo_dim5 AS nome_atributo_dim5,
          t2.contraparte_i_desc AS contraparte_i_desc,
          t2.empresa_intragrupo AS empresa_intragrupo,
          CAST(SUM(t2.Calculation) AS DECIMAL(23,6)) AS SUM_of_Calculation
FROM bu_captools_work.query_for_filter_for_query__0034 t2
WHERE t2.nome_atributo_dim = 'Despesas/Com. diferidas'
OR t2.nome_atributo_dim = 'Juros/encargos a pagar'
GROUP BY t2.cmoeda,
               t2.descritivo,
               t2.nome_atributo_dim5,
               t2.contraparte_i_desc,
               t2.empresa_intragrupo;


CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_0009 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.query_for_filter_for_query__003d t1
WHERE t1.cod_contavirt = 'P_21'
  OR t1.cod_contavirt = 'P_20'
  AND t1.nome_atributo_dim4 = 'depósitos a prazo';


CREATE TABLE bu_captools_work.query_for_filter_for_query__002f AS
SELECT t1.zcliente,
          t1.cmoeda,
          t1.clei,
          CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final1,
          CAST(AVG(t1.tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas1,
          t1.ref_date,
          t1.contraparte_i_desc,
          t1.gcliente,
          t1.ref_date AS ref_date1,
          t1.nome_atributo_dim5
FROM bu_captools_work.query_for_filter_for_query__002e t1
WHERE t1.nome_atributo_dim4 = 'depósitos à ordem, overnights'
GROUP BY t1.zcliente,
               t1.cmoeda,
               t1.clei,
               t1.ref_date,
               t1.contraparte_i_desc,
               t1.gcliente,
               t1.nome_atributo_dim5;



CREATE TABLE bu_captools_work.query_for_al015_act_fin_0000 AS
SELECT t2.gcliente,
       t2.clei,
       t2.cpais_residencia,
       t2.cod_ref_cq,
       t2.cod_tip_contrato,
       CAST(SUM(t2.msaldo_final) AS DECIMAL(23,6)) AS Calculation,
       t2.empresa_intragrupo,
       t2.contraparte_i_desc,
       t2.flag_pme,
       t2.zcliente1,
       t2.dt_fim,
       CAST(COUNT(t2.msaldo_final) AS DECIMAL(23,6)) AS Calculation1,
       CAST(SUM(t1.Calculation) AS DECIMAL(23,6)) AS Calculation2
FROM
bu_captools_work.query_for_al015_act_fin t1
RIGHT JOIN
bu_captools_work.query_for_filter_for_query__000f t2
ON (t1.cempresa_pas = t2.cempresa)
AND (t1.cbalcao_pas = t2.cbalcao)
AND (t1.cnumecta_pas = t2.cnumecta)
AND (t1.zdeposit_pas = t2.zdeposit)
WHERE t2.msaldo_final <> 0
GROUP BY t2.gcliente,
         t2.clei,
         t2.cpais_residencia,
         t2.cod_ref_cq,
         t2.cod_tip_contrato,
         t2.empresa_intragrupo,
         t2.contraparte_i_desc,
         t2.flag_pme,
         t2.zcliente1,
         t2.dt_fim;


CREATE TABLE bu_captools_work.query_for_ldrmaster2_0001 AS
SELECT t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.flag_pme,
       t1.msaldo_final,
       t1.contraparte_i_desc,
       t1.gcliente,
       t1.csector_inst,
       t2.Intragrupo
FROM bu_captools_work.query_for_ldrmaster t1,
     bu_captools_work.query_for_filter_for_query_fo t2
WHERE (t1.cempresa = t2.cempresa
       AND t1.cbalcao = t2.cbalcao
       AND t1.cnumecta = t2.cnumecta
       AND t1.zdeposit = t2.zdeposit)
  AND t1.cod_contavirt LIKE '%E%'
ORDER BY t1.gcliente;



CREATE TABLE bu_captools_work.query_for_filter_for_query__0015 AS
SELECT t1.zcliente,
          t1.contraparte_i_desc,
          t1.gcliente,
          t1.clei,
          t1.cpais_residencia,
          CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
          CAST(SUM(t1.Calculation) AS DECIMAL(23,6)) AS SUM_of_Calculation1,
          t2.cod_ref_cq,
          (COUNT(t1.msaldo_final)) AS COUNT_of_msaldo_final
FROM
bu_captools_work.filter_for_query_for_ldrmaster_0 t1
LEFT JOIN
bu_captools_work.filter_for_cq_isda_0000 t2
ON (t1.zcliente = t2.zcliente)
GROUP BY t1.zcliente,
               t1.contraparte_i_desc,
               t1.gcliente,
               t1.clei,
               t1.cpais_residencia,
               t2.cod_ref_cq;


CREATE TABLE bu_captools_work.query_for_filter_for_query__0025 AS
SELECT CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       t1.cod_contavirt
FROM bu_captools_work.filter_for_query_for_ldrmaster_0 t1
GROUP BY t1.cod_contavirt;


CREATE TABLE bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__003A AS
SELECT t1.cod_contavirt,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final
FROM bu_captools_work.filter_for_query_for_ldrmaster_0 t1
GROUP BY t1.cod_contavirt;


CREATE TABLE bu_captools_work.filter_for_query_for_filter_0007 AS
SELECT t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.cmoeda,
       t1.SUM_of_msaldo_final,
       t1.cod_contavirt,
       t1.ccontab_final_ifrs,
       t1.contraparte_i_desc,
       t1.nome_atributo_dim,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.ref_date
FROM bu_captools_work.query_for_filter_for_query__0013 t1
WHERE t1.nome_atributo_dim <> 'CREDORES POR FORNECIMENTO'
AND t1.nome_atributo_dim <> 'CREDORES POR OPERA¤åES SO'
AND t1.nome_atributo_dim <> 'IMPOSTO SOBRE VALOR ACRES'
AND t1.nome_atributo_dim <> 'IMPOSTO DO SELO'
AND t1.nome_atributo_dim <> 'CONTRIBUICOES PARA A SEGU'
AND t1.nome_atributo_dim <> 'RETENCAO DE IMPOSTOS NA F'
OR t1.nome_atributo_dim IS NULL;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0043 AS
SELECT t1.cod_contavirt,
       t1.ccontab_final_ifrs,
       CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final
FROM bu_captools_work.query_for_filter_for_query__0013 t1
WHERE (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
GROUP BY t1.cod_contavirt,
         t1.ccontab_final_ifrs;


CREATE TABLE bu_captools_work.query_for_filter_for_query_000e AS
SELECT t1.cod_contavirt,
       CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.ccontab_final_ifrs
FROM bu_captools_work.query_for_filter_for_query__0013 t1
GROUP BY t1.cod_contavirt,
         t1.nome_atributo_dim,
         t1.nome_atributo_dim3,
         t1.nome_atributo_dim4,
         t1.nome_atributo_dim5,
         t1.ccontab_final_ifrs ;



CREATE TABLE bu_captools_work.query_for_ldrmaster_0005_00_0003 AS
SELECT t1.nomegrup,
       t1.zcliente,
       t1.zcliente_princ,
       t1.cpais_residencia,
       t1.contraparte_i_desc,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       (substr(t1.ccontab_final_ifrs,1,2)) AS Calculation
FROM bu_captools_work.query_for_ldrmaster_0005_00_0001 t1
WHERE t1._Calculation = '91' OR t1._Calculation = '93'
GROUP BY t1.nomegrup,
         t1.zcliente,
         t1.zcliente_princ,
         t1.cpais_residencia,
         t1.contraparte_i_desc,
         Calculation
ORDER BY SUM_of_msaldo_final;



CREATE TABLE bu_captools_work.query_for_filter_for_fg001_fgd1 AS
SELECT t2.Sum_of_Montante_Garantido,
       t2.SUM_of_mgarantido_me,
       t2.SUM_of_mcoberto_eur,
       t2.SUM_of_mcoberto_me,
       t2.cempresa AS cempresa1,
       t2.cbalcao AS cbalcao1,
       t2.cnumecta AS cnumecta1,
       t2.zdeposit AS zdeposit1
FROM bu_captools_work.query_for_filter_for_fg001_fgd t2;



CREATE TABLE bu_captools_work.query_for_filter_for_query__0020 AS
SELECT t2.Sum_of_Montante_Garantido,
       t2.SUM_of_mgarantido_me,
       t2.SUM_of_mcoberto_eur,
       t2.SUM_of_mcoberto_me,
       t2.cempresa AS cempresa1,
       t2.cbalcao AS cbalcao1,
       t2.cnumecta AS cnumecta1,
       t2.zdeposit AS zdeposit1
FROM bu_captools_work.query_for_filter_for_fg001_fgd t2
ORDER BY t2.Sum_of_Montante_Garantido;



CREATE TABLE bu_captools_work.query_for_ldrmaster_000a_0001 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       t1.cod_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date,
       CAST(SUM(t2.Sum_of_Montante_Garantido) AS DECIMAL(21,8)) AS SUM_of_Sum_of_Montante_Garantido,
       CAST(SUM(t2.SUM_of_mgarantido_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mgarantido_me,
       CAST(SUM(t2.SUM_of_mcoberto_eur) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur,
       CAST(SUM(t2.SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me,
       t1.eleg_fund_prop,
       t1.mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_ldrmaster_000a t1
LEFT JOIN bu_captools_work.query_for_filter_for_fg001_fgd t2
ON (t1.cempresa = t2.cempresa)
AND (t1.cbalcao = t2.cbalcao)
AND (t1.cnumecta = t2.cnumecta)
AND (t1.zdeposit = t2.zdeposit)
GROUP BY t1.cempresa,
         t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit,
         t1.zcliente,
         t1.cmoeda,
         t1.cod_contavirt,
         t1.nome_atributo_dim,
         t1.nome_atributo_dim3,
         t1.nome_atributo_dim4,
         t1.nome_atributo_dim5,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.ccae,
         t1.csector_inst,
         t1.empresa_intragrupo,
         t1.cpais_residencia,
         t1.tx_contrato_pas,
         t1.ref_date,
         t1.eleg_fund_prop,
         t1.mon_fund_prop,
         t1.lei_aplicavel,
         t1.termo_estruturado,
         t1.dt_emissao,
         t1.dt_vencim,
         t1.clei,
         t1.st_sgps_portugal_ifrs;



CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_0008 AS
SELECT t1.cempresa,
      t1.cbalcao,
      t1.cnumecta,
      t1.zdeposit,
      t1.zcliente,
      t1.cmoeda,
      t1.SUM_of_msaldo_final,
      t1.cod_contavirt,
      t1.nome_atributo_dim,
      t1.nome_atributo_dim3,
      t1.nome_atributo_dim4,
      t1.nome_atributo_dim5,
      t1.contraparte_i_desc,
      t1.flag_pme,
      t1.ccae,
      t1.csector_inst,
      t1.empresa_intragrupo,
      t1.cpais_residencia,
      t1.tx_contrato_pas,
      t1.ref_date,
      t1.eleg_fund_prop,
      t1.mon_fund_prop,
      t1.lei_aplicavel,
      t1.termo_estruturado,
      t1.dt_emissao,
      t1.dt_vencim,
      t1.clei,
      t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_ldrmaster_000a_0000 t1
WHERE t1.empresa_intragrupo <> ''
OR t1.cod_contavirt = 'C_31';



CREATE TABLE bu_captools_work.query_for_filter_for_query_0033 AS
SELECT t1.cmoeda,
       CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       t1.descritivo,
       t1.nome_atributo_dim5,
       t1.zdeposit,
       t1.contraparte_i_desc,
       CAST(SUM(t1.SUM_of_Calculation) AS DECIMAL(23,6)) AS SUM_of_SUM_of_Calculation
FROM bu_captools_work.query_for_filter_for_query__0031 t1
WHERE (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
GROUP BY t1.cmoeda,
         t1.descritivo,
         t1.nome_atributo_dim5,
         t1.zdeposit,
         t1.contraparte_i_desc;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0045 AS
SELECT t1.cmoeda,
       t1.SUM_of_msaldo_final,
       (IF(t1.descritivo = 'Hipotecárias XXII',
           'Hipotecária XXII',
           IF(t1.descritivo = 'Hipotecárias XXIII',
              'Hipotecária XXIII',
              t1.descritivo))) AS descritivo,
       t1.nome_atributo_dim5,
       t1.contraparte_i_desc,
       t1.empresa_intragrupo,
       t1.SUM_of_Calculation
  FROM bu_captools_work.query_for_filter_for_query__0032 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query__0039 AS
SELECT t1.cod_contavirt,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final
FROM bu_captools_work.filter_for_query_for_ldrmas_0009 t1
GROUP BY t1.cod_contavirt;



CREATE TABLE bu_captools_work.query_for_filter_for_query__0029 AS
SELECT t2.cempresa AS cempresa1,
       t2.cbalcao AS cbalcao1,
       t2.cnumecta AS cnumecta1,
       t2.zdeposit AS zdeposit1,
       CAST(SUM(t2.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final1
FROM bu_captools_work.filter_for_query_for_ldrmas_0009 t2
GROUP BY t2.cempresa,
         t2.cbalcao,
         t2.cnumecta,
         t2.zdeposit;



CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_000a AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.descritivo,
       t1.caplic,
       t1.cgrupoic,
       t1.cmoeda,
       t1.cnaturic,
       t1.tipo_contrato,
       t1.sociedade_contraparte,
       t1.flag_ativo,
       t1.msaldo_final,
       t1.ccontab_final_pcsb,
       t1.ccontab_final_ifrs,
       t1.cod_contavirt,
       t1.nome_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.dabertur,
       t1.ddvencim,
       t1.empresa_intragrupo,
       t1.gcliente,
       t1.clei,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.filter_for_query_for_ldrmas_0009 t1
WHERE t1.nome_atributo_dim NOT LIKE '%Juros%' AND t1.nome_atributo_dim NOT LIKE '%Despesa%';


CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_000b AS
SELECT t1.cempresa,
    t1.cbalcao,
    t1.cnumecta,
    t1.zdeposit,
    t1.zcliente,
    t1.descritivo,
    t1.caplic,
    t1.cgrupoic,
    t1.cmoeda,
    t1.cnaturic,
    t1.tipo_contrato,
    t1.sociedade_contraparte,
    t1.flag_ativo,
    t1.msaldo_final,
    t1.ccontab_final_pcsb,
    t1.ccontab_final_ifrs,
    t1.cod_contavirt,
    t1.nome_contavirt,
    t1.nome_atributo_dim,
    t1.nome_atributo_dim3,
    t1.nome_atributo_dim4,
    t1.nome_atributo_dim5,
    t1.contraparte_i,
    t1.contraparte_i_desc,
    t1.flag_pme,
    t1.ccae,
    t1.csector_inst,
    t1.dabertur,
    t1.ddvencim,
    t1.empresa_intragrupo,
    t1.gcliente,
    t1.clei,
    t1.cpais_residencia,
    t1.tx_contrato_pas,
    t1.ref_date
FROM bu_captools_work.filter_for_query_for_ldrmas_0009 t1
WHERE t1.nome_atributo_dim LIKE '%Juros%' OR t1.nome_atributo_dim LIKE '%Despesa%';



CREATE TABLE bu_captools_work.query_for_filter_for_query__0024 AS
SELECT t1.zcliente,
       t1.cmoeda,
       t1.clei,
       CAST(SUM(t1.SUM_of_msaldo_final1) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final1,
       CAST(AVG(t1.AVG_of_tx_contrato_pas1) AS DECIMAL(10,5)) AS AVG_of_AVG_of_tx_contrato_pas1,
       t1.contraparte_i_desc,
       t1.gcliente,
       t1.ref_date1
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__002F t1
WHERE t1.nome_atributo_dim5 = 'Capital/ Nocional/ Custo de aquisição'
GROUP BY t1.zcliente,
         t1.cmoeda,
         t1.clei,
         t1.contraparte_i_desc,
         t1.gcliente,
         t1.ref_date1;


CREATE TABLE bu_captools_work.query_for_filter_for_query__0023 AS
SELECT t1.zcliente,
       t1.cmoeda,
       CAST(SUM(t1.SUM_of_msaldo_final1) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final1,
       CAST(AVG(t1.AVG_of_tx_contrato_pas1) AS DECIMAL(10,5)) AS AVG_of_AVG_of_tx_contrato_pas11,
       t1.gcliente,
       t1.nome_atributo_dim5
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__002F t1
WHERE t1.nome_atributo_dim5 = 'Juros/encargos a pagar' OR t1.nome_atributo_dim5 = 'Juros/rendimentos a receber'
GROUP BY t1.zcliente,
         t1.cmoeda,
         t1.gcliente,
         t1.nome_atributo_dim5;



CREATE TABLE bu_captools_work.query_for_al015_act_fin_0001 AS
SELECT t1.gcliente,
       t1.clei,
       t2.tayd91c0_gelem30,
       t1.cod_ref_cq,
       t1.cod_tip_contrato,
       t1.Calculation,
       t1.empresa_intragrupo,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.zcliente1,
       t1.dt_fim,
       t1.Calculation1,
       t1.Calculation2
FROM bu_captools_work.query_for_al015_act_fin_0000 t1
LEFT JOIN cd_captools.TAT91_015 t2 ON (t1.cpais_residencia = t2.tayd91c0_celemtab);



CREATE TABLE bu_captools_work.query_for_ldrmaster2_0002 AS
SELECT CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       t1.contraparte_i_desc,
       t1.flag_pme,
       (IF(t1.csector_inst LIKE 'S128%','S128', '')) AS Calculation,
       t1.Intragrupo
FROM bu_captools_work.query_for_ldrmaster2_0001 t1
WHERE t1.nome_atributo_dim = 'Compra' OR t1.nome_atributo_dim = 'Compradas'
GROUP BY t1.contraparte_i_desc,
         t1.flag_pme,
         Calculation,
         t1.Intragrupo;



CREATE TABLE bu_captools_work.query_for_filter_for_query_003c AS
SELECT t1.zcliente,
       t1.contraparte_i_desc,
       t1.gcliente,
       t1.clei,
       t2.tayd91c0_gelem30,
       t1.SUM_of_msaldo_final,
       t1.SUM_of_Calculation1,
       t1.cod_ref_cq,
       t1.COUNT_of_msaldo_final
FROM bu_captools_work.query_for_filter_for_query__0015 t1
LEFT JOIN cd_captools.TAT91_015 t2 ON (t1.cpais_residencia = t2.tayd91c0_celemtab);



CREATE TABLE bu_captools_work.filter_for_query_for_filter AS
SELECT t1.cmoeda,
       t1.SUM_of_msaldo_final,
       t1.cod_contavirt,
       t1.ccontab_final_ifrs,
       t1.contraparte_i_desc,
       t1.nome_atributo_dim,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.ref_date
FROM bu_captools_work.filter_for_query_for_filter_0007 t1
WHERE (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL);


CREATE TABLE bu_captools_work.filter_for_query_for_filter_0006 AS
SELECT t1.cod_contavirt,
       t1.ccontab_final_ifrs
FROM bu_captools_work.query_for_filter_for_query_0043 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query2 AS
SELECT t1.cempresa1,
       t1.cbalcao1,
       CAST(SUM(t1.Sum_of_Montante_Garantido) AS DECIMAL(21,8)) AS SUM_of_Sum_of_Montante_Garantido,
       CAST(SUM(t1.SUM_of_mgarantido_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mgarantido_me,
       CAST(SUM(t1.SUM_of_mcoberto_eur) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur,
       CAST(SUM(t1.SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me
FROM bu_captools_work.query_for_filter_for_fg001_fgd1 t1
WHERE t1.Sum_of_Montante_Garantido IS NOT NULL OR t1.SUM_of_mgarantido_me IS NOT NULL
GROUP BY t1.cempresa1,
         t1.cbalcao1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_001d AS
SELECT CAST(SUM(t1.Sum_of_Montante_Garantido) AS DECIMAL(21,8)) AS SUM_of_Sum_of_Montante_Garantido,
       CAST(SUM(t1.SUM_of_mgarantido_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mgarantido_me,
       CAST(SUM(t1.SUM_of_mcoberto_eur) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur,
       CAST(SUM(t1.SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me
FROM bu_captools_work.query_for_filter_for_query__0020 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_001e AS
SELECT t1.cbalcao1,
       t1.cnumecta1,
       CAST(SUM(t1.Sum_of_Montante_Garantido) AS DECIMAL(21,8)) AS SUM_of_Sum_of_Montante_Garantido,
       CAST(SUM(t1.SUM_of_mgarantido_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mgarantido_me,
       CAST(SUM(t1.SUM_of_mcoberto_eur) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur,
       CAST(SUM(t1.SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me
FROM bu_captools_work.query_for_filter_for_query__0020 t1
WHERE t1.SUM_of_mgarantido_me <> 0 OR t1.Sum_of_Montante_Garantido <> 0
GROUP BY t1.cbalcao1,
         t1.cnumecta1;



CREATE TABLE bu_captools_work.filter_for_query_for_ldrmas_0007 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       t1.SUM_of_SUM_of_msaldo_final,
       t1.cod_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date,
       t1.SUM_of_Sum_of_Montante_Garantido,
       t1.SUM_of_SUM_of_mgarantido_me,
       t1.SUM_of_SUM_of_mcoberto_eur,
       t1.SUM_of_SUM_of_mcoberto_me,
       t1.eleg_fund_prop,
       t1.lei_aplicavel,
       t1.mon_fund_prop,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_ldrmaster_000a_0001 t1
WHERE t1.empresa_intragrupo <> '' OR t1.cod_contavirt = 'C_31';


CREATE TABLE bu_captools_work.query_for_filter_for_query__0022 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       t1.cod_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       CAST(AVG(t1.tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
       t1.ref_date,
       t1.eleg_fund_prop,
       t1.mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.filter_for_query_for_ldrmas_0008 t1
WHERE t1.cod_contavirt = 'P_20'
OR t1.cod_contavirt = 'P_21'
OR t1.cod_contavirt = 'P_22'
OR t1.cod_contavirt = 'P_23'
OR t1.cod_contavirt = 'C_31'
OR t1.cod_contavirt = 'C_33'
OR t1.cod_contavirt = 'C_36'
OR t1.cod_contavirt = 'P_27.1'
OR t1.cod_contavirt = 'P_27.2'
OR t1.cod_contavirt LIKE '%P_30%'
OR t1.cod_contavirt = 'P_24'
GROUP BY t1.cempresa,
         t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit,
         t1.zcliente,
         t1.cmoeda,
         t1.cod_contavirt,
         t1.nome_atributo_dim,
         t1.nome_atributo_dim3,
         t1.nome_atributo_dim4,
         t1.nome_atributo_dim5,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.ccae,
         t1.csector_inst,
         t1.empresa_intragrupo,
         t1.cpais_residencia,
         t1.ref_date,
         t1.eleg_fund_prop,
         t1.mon_fund_prop,
         t1.lei_aplicavel,
         t1.termo_estruturado,
         t1.dt_emissao,
         t1.dt_vencim,
         t1.clei,
         t1.st_sgps_portugal_ifrs;




CREATE TABLE bu_captools_work.query_for_filter_for_query_0037 AS
SELECT t2.cmoeda,
       CAST(SUM(t2.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       t2.descritivo,
       t2.contraparte_i_desc,
       t2.empresa_intragrupo,
       CAST(SUM(t2.SUM_of_Calculation) AS DECIMAL(23,6)) AS SUM_of_SUM_of_Calculation
FROM bu_captools_work.query_for_filter_for_query_0045 t2
WHERE (t2.empresa_intragrupo = '' OR t2.empresa_intragrupo is NULL)
GROUP BY t2.cmoeda,
         t2.descritivo,
         t2.contraparte_i_desc,
         t2.empresa_intragrupo;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0029 AS
SELECT t1.cempresa1 AS cempresa11,
    t1.cbalcao1 AS cbalcao11,
    t1.cnumecta1 AS cnumecta11,
    t1.zdeposit1 AS zdeposit11,
    t1.SUM_of_msaldo_final1,
    t2.Sum_of_Montante_Garantido,
    t2.SUM_of_mgarantido_me,
    t2.SUM_of_mcoberto_eur,
    t2.SUM_of_mcoberto_me,
    t2.cempresa AS cempresa1,
    t2.cbalcao AS cbalcao1,
    t2.cnumecta AS cnumecta1,
    t2.zdeposit AS zdeposit1
FROM bu_captools_work.query_for_filter_for_fg001_fgd t2
FULL JOIN bu_captools_work.query_for_filter_for_query__0029 t1
ON (t2.cempresa = t1.cempresa1)
AND (t2.cbalcao = t1.cbalcao1)
AND (t2.cnumecta = t1.cnumecta1)
AND (t2.zdeposit = t1.zdeposit1)
WHERE (t1.cempresa1 = '' OR t1.cempresa1 IS NULL);


CREATE TABLE bu_captools_work.query_for_filter_for_query__0011 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.cmoeda,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final1,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.filter_for_query_for_ldrmas_000a t1
GROUP BY t1.cempresa,
         t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit,
         t1.cmoeda,
         t1.nome_atributo_dim3,
         t1.nome_atributo_dim4,
         t1.nome_atributo_dim5,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.ccae,
         t1.csector_inst,
         t1.empresa_intragrupo,
         t1.cpais_residencia,
         t1.tx_contrato_pas,
         t1.ref_date;




CREATE TABLE bu_captools_work.query_for_filter_for_query__0017 AS
SELECT t1.cmoeda,
       CAST(SUM(t1.msaldo_final) AS DECIMAL(23,6)) AS SUM_of_msaldo_final,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.csector_inst,
       CAST(AVG(t1.tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.filter_for_query_for_ldrmas_000b t1
WHERE (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
GROUP BY t1.cmoeda,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.csector_inst,
         t1.ref_date;



CREATE TABLE bu_captools_work.query_for_filter_for_query AS
SELECT t2.zcliente,
       t2.cmoeda,
       t2.clei,
       t2.SUM_of_SUM_of_msaldo_final1 AS SUM_of_msaldo_final,
       t1.SUM_of_SUM_of_msaldo_final1 AS SUM_juros,
       t2.AVG_of_AVG_of_tx_contrato_pas1 AS AVG_of_tx_contrato_pas,
       t2.contraparte_i_desc,
       t2.gcliente,
       t2.ref_date1 AS ref_date
FROM bu_captools_work.query_for_filter_for_query__0024 t2
LEFT JOIN bu_captools_work.query_for_filter_for_query__0023 t1
ON (t2.zcliente = t1.zcliente) AND (t2.cmoeda = t1.cmoeda);


CREATE TABLE bu_captools_work.query_for_filter_for_query__0033 AS
SELECT t2.tayd91c0_gelem30,
    CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
    t1.cod_contavirt,
    t1.ccontab_final_ifrs,
    t1.contraparte_i_desc,
    t1.nome_atributo_dim,
    t1.flag_pme,
    t1.empresa_intragrupo,
    t1.ref_date
FROM bu_captools_work.filter_for_query_for_filter t1
LEFT JOIN cd_captools.tat91_206 t2
ON (t1.cmoeda = t2.tayd91c0_celemtab)
GROUP BY t2.tayd91c0_gelem30,
         t1.cod_contavirt,
         t1.ccontab_final_ifrs,
         t1.contraparte_i_desc,
         t1.nome_atributo_dim,
         t1.flag_pme,
         t1.empresa_intragrupo,
         t1.ref_date;



CREATE TABLE bu_captools_work.query_for_ldrmaster_0005_00_0004 AS
SELECT t3.nomegrup AS nomegrup,
       t3.zcliente_princ AS zcliente_princ,
       t2.tayd91c0_gelem30,
       t3.contraparte_i_desc AS contraparte_i_desc,
       CAST(SUM(t3.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final1,
       t3.Calculation,
       COUNT(*) as Calculation2
FROM bu_captools_work.query_for_ldrmaster_0005_00_0003 t3
LEFT JOIN cd_captools.tat91_015 t2
ON (t3.cpais_residencia = t2.tayd91c0_celemtab)
GROUP BY t3.nomegrup,
         t3.zcliente_princ,
         t2.tayd91c0_gelem30,
         t3.contraparte_i_desc,
         t3.Calculation;



CREATE TABLE bu_captools_work.query_for_filter_for_query__001a AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       CAST(SUM(t1.SUM_of_SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fina,
       t1.cod_contavirt,
       t1.nome_atributo_dim,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date,
       CAST(SUM(t1.SUM_of_Sum_of_Montante_Garantido) AS DECIMAL(21,8)) AS SUM_of_SUM_of_Sum_of_Montante_Ga,
       CAST(SUM(t1.SUM_of_SUM_of_mgarantido_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_mgarantido_,
       CAST(SUM(t1.SUM_of_SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_mcoberto_me,
       CAST(SUM(t1.SUM_of_SUM_of_mcoberto_eur) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_mcoberto_eu,
       t1.eleg_fund_prop,
       t1.mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.filter_for_query_for_ldrmas_0007 t1
WHERE t1.cod_contavirt = 'P_20'
OR t1.cod_contavirt = 'P_21'
OR t1.cod_contavirt = 'P_22'
OR t1.cod_contavirt = 'P_23'
OR t1.cod_contavirt = 'C_31'
OR t1.cod_contavirt = 'C_33'
OR t1.cod_contavirt = 'C_36'
OR t1.cod_contavirt = 'P_27.1'
OR t1.cod_contavirt = 'P_27.2'
OR t1.cod_contavirt LIKE '%P_30%'
OR t1.cod_contavirt = 'P_24'
GROUP BY t1.cempresa,
         t1.cbalcao,
         t1.cnumecta,
         t1.zdeposit,
         t1.zcliente,
         t1.cmoeda,
         t1.cod_contavirt,
         t1.nome_atributo_dim,
         t1.nome_atributo_dim3,
         t1.nome_atributo_dim4,
         t1.nome_atributo_dim5,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.ccae,
         t1.csector_inst,
         t1.empresa_intragrupo,
         t1.cpais_residencia,
         t1.tx_contrato_pas,
         t1.ref_date,
         t1.eleg_fund_prop,
         t1.mon_fund_prop,
         t1.lei_aplicavel,
         t1.termo_estruturado,
         t1.dt_emissao,
         t1.dt_vencim,
         t1.clei,
         t1.st_sgps_portugal_ifrs;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0030 AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       CAST(SUM(t1.SUM_of_SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fina,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       CAST(AVG(t1.AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_AVG_of_tx_contrato_pas,
       t1.ref_date,
       t1.csector_inst AS csector_inst1,
       t1.eleg_fund_prop,
       CAST(SUM(t1.mon_fund_prop) AS DECIMAL(19,2)) AS SUM_of_mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei
FROM bu_captools_work.query_for_filter_for_query__0022 t1
WHERE t1.csector_inst LIKE 'S128%'
GROUP BY t1.zdeposit,
         t1.zcliente,
         t1.cmoeda,
         t1.cod_contavirt,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.empresa_intragrupo,
         t1.cpais_residencia,
         t1.ref_date,
         t1.csector_inst,
         t1.eleg_fund_prop,
         t1.lei_aplicavel,
         t1.termo_estruturado,
         t1.dt_emissao,
         t1.dt_vencim,
         t1.clei;



CREATE TABLE bu_captools_work.query_for_filter_for_query__002d AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       CAST(SUM(t1.SUM_of_SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fina,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       CAST(AVG(t1.AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_AVG_of_tx_contrato_pas,
       t1.ref_date,
       t1.eleg_fund_prop,
       CAST(SUM(t1.mon_fund_prop) AS DECIMAL(19,2)) AS SUM_of_mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei
FROM bu_captools_work.query_for_filter_for_query__0022 t1
WHERE t1.csector_inst NOT LIKE 'S128%' OR t1.csector_inst IS NULL
GROUP BY t1.zdeposit,
         t1.zcliente,
         t1.cmoeda,
         t1.cod_contavirt,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.empresa_intragrupo,
         t1.cpais_residencia,
         t1.ref_date,
         t1.eleg_fund_prop,
         t1.lei_aplicavel,
         t1.termo_estruturado,
         t1.dt_emissao,
         t1.dt_vencim,
         t1.clei;


CREATE TABLE bu_captools_work.query_for_filter_for_query_0038 AS
SELECT t1.cmoeda,
       t1.SUM_of_SUM_of_msaldo_final AS SUM_of_msaldo_final,
       t1.descritivo,
       t1.nome_atributo_dim5,
       t1.zdeposit,
       t1.contraparte_i_desc,
       t2.SUM_of_SUM_of_msaldo_final AS SUM_of_juros,
       t1.SUM_of_SUM_of_Calculation
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY_0033 t1
LEFT JOIN bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY_0037 t2
ON (t1.cmoeda = t2.cmoeda)
AND (t1.descritivo = t2.descritivo);



CREATE TABLE bu_captools_work.query_for_filter_for_query_002a AS
SELECT t1.cempresa1,
       t1.cbalcao1,
       CAST(SUM(t1.Sum_of_Montante_Garantido) AS DECIMAL(21,8)) AS SUM_of_Sum_of_Montante_Garantido,
       CAST(SUM(t1.SUM_of_mgarantido_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mgarantido_me,
       CAST(SUM(t1.SUM_of_mcoberto_eur) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur,
       CAST(SUM(t1.SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY_0029 t1
WHERE t1.Sum_of_Montante_Garantido IS NOT NULL
OR t1.SUM_of_mgarantido_me IS NOT NULL
GROUP BY t1.cempresa1,
         t1.cbalcao1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0022 AS
SELECT t1.cempresa,
       t1.cbalcao,
       t1.cnumecta,
       t1.zdeposit,
       t1.cmoeda,
       t1.SUM_of_msaldo_final1,
       t1.nome_atributo_dim3,
       t1.nome_atributo_dim4,
       t1.nome_atributo_dim5,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.ccae,
       t1.csector_inst,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       t1.tx_contrato_pas,
       t1.ref_date,
       t2.Sum_of_Montante_Garantido,
       t2.SUM_of_mgarantido_me,
       t2.SUM_of_mcoberto_eur,
       t2.SUM_of_mcoberto_me
FROM bu_captools_work.query_for_filter_for_query__0011 t1
LEFT JOIN bu_captools_work.query_for_filter_for_fg001_fgd t2
ON (t1.cempresa = t2.cempresa)
AND (t1.cbalcao = t2.cbalcao)
AND (t1.cnumecta = t2.cnumecta)
AND (t1.zdeposit = t2.zdeposit);



CREATE TABLE bu_captools_work.filter_for_query_for_filter_0004 AS
SELECT t1.csector_inst,
       t1.cmoeda,
       t1.SUM_of_msaldo_final,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.AVG_of_tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.query_for_filter_for_query__0017 t1
WHERE t1.csector_inst NOT LIKE 'S128%';



CREATE TABLE bu_captools_work.filter_for_query_for_filter_0005 AS
SELECT t1.cmoeda,
       t1.SUM_of_msaldo_final,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.AVG_of_tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.query_for_filter_for_query__0017 t1
WHERE t1.csector_inst LIKE 'S128%';



CREATE TABLE bu_captools_work.query_for_filter_for_query_002f AS
SELECT t1.zcliente,
       t1.cmoeda,
       t1.clei,
       t1.SUM_of_msaldo_final,
       t1.SUM_juros,
       t1.AVG_of_tx_contrato_pas,
       t1.contraparte_i_desc,
       t1.gcliente,
       t1.ref_date,
       (0) AS Calculation
FROM bu_captools_work.query_for_filter_for_query t1
UNION ALL
SELECT NULL as zcliente,
       t2.cmoeda,
       t2.clei,
       t2.SUM_of_msaldo_final,
       NULL as SUM_juros,
       t2.AVG_of_tx_contrato_pas,
       t2.contraparte_i_desc,
       NULL as gcliente,
       t2.ref_date,
       (1) AS Calculation
FROM bu_captools_work.query_for_filter_for_query__001f t2
UNION ALL
SELECT NULL as zcliente,
       t3.cmoeda,
       t3.clei,
       t3.SUM_of_msaldo_final,
       t3.SUM_juros,
       NULL as AVG_of_tx_contrato_pas,
       NULL as contraparte_i_desc,
       NULL as gcliente,
       t3.ref_date,
       (2) AS Calculation
FROM bu_captools_work.query_for_filter_for_query__002c t3;



CREATE TABLE bu_captools_work.query_for_filter_for_balencete AS
SELECT t2.tayd91c0_gelem30,
       CAST(SUM(t2.SUM_of_SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fin1,
       t2.contraparte_i_desc,
       t2.flag_pme,
       t2.ref_date,
       t1.Line,
       t1.Insolvency_Ranking,
       t1.Type_of_non_financial_liabilitie
FROM bu_captools_work.query_for_filter_for_query__0033 t2
LEFT JOIN bu_captools_work.filter_for_balencete_22 t1
ON (t2.ccontab_final_ifrs = t1.ccontab_final_ifrs)
WHERE (t2.empresa_intragrupo = '' OR t2.empresa_intragrupo is NULL)
GROUP BY t2.tayd91c0_gelem30,
         t2.contraparte_i_desc,
         t2.flag_pme,
         t2.ref_date,
         t1.Line,
         t1.Insolvency_Ranking,
         t1.type_of_non_financial_liabilitie;



CREATE TABLE bu_captools_work.query_for_filter_for_balenc_0000 AS
SELECT t2.tayd91c0_gelem30,
       CAST(SUM(t2.SUM_of_SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fin1,
       t2.contraparte_i_desc,
       t2.flag_pme,
       t2.ref_date,
       t1.Line,
       t1.Insolvency_Ranking,
       t1.Type_of_non_financial_liabilitie,
       t2.ccontab_final_ifrs
FROM bu_captools_work.query_for_filter_for_query__0033 t2
LEFT JOIN bu_captools_work.filter_for_balencete_22 t1
ON (t2.ccontab_final_ifrs = t1.ccontab_final_ifrs)
WHERE (t2.empresa_intragrupo = '' OR t2.empresa_intragrupo is NULL)
GROUP BY t2.tayd91c0_gelem30,
         t2.contraparte_i_desc,
         t2.flag_pme,
         t2.ref_date,
         t1.Line,
         t1.Insolvency_Ranking,
         t1.type_of_non_financial_liabilitie,
         t2.ccontab_final_ifrs;


CREATE TABLE bu_captools_work.query_for_filter_for_query_004b AS
SELECT t1.cod_contavirt,
       CAST(SUM(t1.SUM_of_SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fina
FROM bu_captools_work.query_for_filter_for_query__0033 t1
GROUP BY t1.cod_contavirt;



CREATE TABLE bu_captools_work.query_for_ldrmaster_0005_00_0005 AS
SELECT t1.nomegrup,
       t1.zcliente_princ,
       t1.tayd91c0_gelem30,
       t1.contraparte_i_desc,
       t1.SUM_of_SUM_of_msaldo_final1,
       t1.Calculation,
       t1.Calculation2 AS Numero_de_entidades
FROM bu_captools_work.query_for_ldrmaster_0005_00_0004 t1
WHERE t1.nomegrup <> ''
ORDER BY t1.SUM_of_SUM_of_msaldo_final1
LIMIT 10;



CREATE TABLE bu_captools_work.query_for_filter_for_query__002a AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       CAST(SUM(t1.SUM_of_SUM_of_SUM_of_msaldo_fina) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_SUM_of_msal,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       CAST(AVG(t1.tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
       t1.ref_date,
       CAST(SUM(t1.SUM_of_SUM_of_SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_SUM_of_mcob,
       CAST(SUM(t1.SUM_of_SUM_of_SUM_of_mcoberto_eu) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_SUM_of_mco1,
       t1.eleg_fund_prop,
       CAST(SUM(t1.mon_fund_prop) AS DECIMAL(19,2)) AS SUM_of_mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_filter_for_query__001a t1
WHERE COALESCE(t1.csector_inst, 'null') NOT LIKE 'S128%'
GROUP BY t1.zdeposit,
         t1.zcliente,
         t1.cmoeda,
         t1.cod_contavirt,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.empresa_intragrupo,
         t1.cpais_residencia,
         t1.ref_date,
         t1.eleg_fund_prop,
         t1.lei_aplicavel,
         t1.termo_estruturado,
         t1.dt_emissao,
         t1.dt_vencim,
         t1.clei,
         t1.st_sgps_portugal_ifrs;



CREATE TABLE bu_captools_work.query_for_filter_for_query__002b AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       CAST(SUM(t1.SUM_of_SUM_of_SUM_of_msaldo_fina) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_SUM_of_msal,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       CAST(AVG(t1.tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
       t1.ref_date,
       CAST(SUM(t1.SUM_of_SUM_of_SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_SUM_of_mcob,
       CAST(SUM(t1.SUM_of_SUM_of_SUM_of_mcoberto_eu) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_SUM_of_mco1,
       t1.csector_inst,
       t1.eleg_fund_prop,
       CAST(SUM(t1.mon_fund_prop) AS DECIMAL(19,2)) AS SUM_of_mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_filter_for_query__001a t1
WHERE t1.csector_inst LIKE 'S128%'
GROUP BY t1.zdeposit,
         t1.zcliente,
         t1.cmoeda,
         t1.cod_contavirt,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.empresa_intragrupo,
         t1.cpais_residencia,
         t1.ref_date,
         t1.csector_inst,
         t1.eleg_fund_prop,
         t1.lei_aplicavel,
         t1.termo_estruturado,
         t1.dt_emissao,
         t1.dt_vencim,
         t1.clei,
         t1.st_sgps_portugal_ifrs;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0036 AS
SELECT t2.cmoeda AS cmoeda,
       t2.SUM_of_msaldo_final AS SUM_of_msaldo_final,
       t2.descritivo AS descritivo,
       t2.nome_atributo_dim5 AS nome_atributo_dim5,
       t2.zdeposit AS zdeposit,
       t2.contraparte_i_desc,
       t2.SUM_of_juros,
       t3.isin AS isin1,
       t3.tipo_titulo AS tipo_titulo1,
       t3.tipo_tx AS tipo_tx1,
       t3.tx_fixa AS tx_fixa1,
       t3.indx_tx_var AS indx_tx_var1,
       t3.sprd_tx_var AS sprd_tx_var1,
       t3.dt_emissao AS dt_emissao1,
       t3.dt_vencim AS dt_vencim1,
       t3.lei_aplicavel AS lei_aplicavel1,
       t3.agente_pagador AS agente_pagador1,
       t3.trustee AS trustee1,
       t3.depositario AS depositario1,
       t3.bolsa_valores AS bolsa_valores1,
       t3.sist_liquidacao AS sist_liquidacao1,
       t3.termo_estruturado AS termo_estruturado1,
       t3.eleg_fund_prop AS eleg_fund_prop1,
       t3.mon_fund_prop AS mon_fund_prop1,
       t3.eleg_eurosistema AS eleg_eurosistema1,
       t3.nom_tot_inic,
       t2.SUM_of_SUM_of_Calculation
FROM bu_captools_work.query_for_filter_for_query_0038 t2
LEFT JOIN bu_captools_work.query_for_filter_for_ct610_titul t3
ON (t2.zdeposit = t3.zdeposit);



CREATE TABLE bu_captools_work.query_for_filter_for_query_0023 AS
SELECT t1.cmoeda,
       CAST(SUM(t1.SUM_of_msaldo_final1) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final11,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.csector_inst,
       CAST(AVG(t1.tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
       t1.ref_date,
       CAST(SUM(t1.SUM_of_mcoberto_eur) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur2,
       CAST(SUM(t1.SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me2
FROM bu_captools_work.query_for_filter_for_query_0022 t1
WHERE (t1.empresa_intragrupo = '' OR t1.empresa_intragrupo is NULL)
GROUP BY t1.cmoeda,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.csector_inst,
         t1.ref_date;


CREATE TABLE bu_captools_work.query_for_filter_for_query__0019 AS
SELECT t1.cmoeda,
       CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       t1.contraparte_i_desc,
       t1.flag_pme,
       CAST(AVG(t1.AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_AVG_of_tx_contrato_pas,
       t1.ref_date
FROM bu_captools_work.filter_for_query_for_filter_0004 t1
WHERE t1.SUM_of_msaldo_final <> 0
GROUP BY t1.cmoeda,
         t1.contraparte_i_desc,
         t1.flag_pme,
         t1.ref_date;


CREATE TABLE bu_captools_work.query_for_filter_for_query__001e AS
SELECT CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final
FROM bu_captools_work.filter_for_query_for_filter_0005 t1;


CREATE TABLE bu_captools_work.query_for_filter_for_query__0028 AS
SELECT t1.zcliente,
       t2.tayd91c0_gelem30,
       t1.clei,
       t1.SUM_of_msaldo_final,
       t1.SUM_juros,
       t1.AVG_of_tx_contrato_pas,
       t1.contraparte_i_desc,
       t1.gcliente,
       t1.ref_date,
       t1.Calculation
FROM bu_captools_work.query_for_filter_for_query_002f t1
LEFT JOIN cd_captools.tat91_206 t2 ON (t1.cmoeda = t2.tayd91c0_celemtab);



CREATE TABLE bu_captools_work.query_for_filter_for_query__003b AS
SELECT t4.zdeposit,
       t4.zcliente,
       t4.cmoeda,
       CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_msal) AS DECIMAL(23,6)) AS SUM_of_saldo,
       CAST(SUM(t4.SUM_of_SUM_of_SUM_of_msaldo_fina) AS DECIMAL(23,6)) AS SUM_of_juros,
       t4.cod_contavirt,
       t4.contraparte_i_desc,
       t4.flag_pme,
       t4.empresa_intragrupo,
       t4.cpais_residencia,
       CAST(AVG(t2.AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
       CAST(AVG(t4.AVG_of_AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_juros,
       t4.ref_date,
       CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_mcob) AS DECIMAL(21,8)) AS SUM_of_mcoberto_eu,
       CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_mco1) AS DECIMAL(21,8)) AS SUM_of_mcoberto_me,
       t4.eleg_fund_prop,
       t2.SUM_of_mon_fund_prop,
       t4.lei_aplicavel,
       t4.termo_estruturado,
       t4.dt_emissao,
       t4.dt_vencim,
       t4.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_filter_for_query__002a t2
FULL JOIN (SELECT t3.*, t1.SUM_of_SUM_of_SUM_of_msaldo_fina, t1.AVG_of_AVG_of_tx_contrato_pas, t1.zdeposit as zdeposit_1, t1.zcliente as zcliente_1, t1.cmoeda as cmoeda_1, t1.cod_contavirt as cod_contavirt_1, t1.contraparte_i_desc as contraparte_i_desc_1 FROM
           bu_captools_work.query_for_filter_for_query__002d t1
           FULL JOIN bu_captools_work.query_for_ldrmaster_0018 t3
           ON (COALESCE(t1.zdeposit,"NULL") = COALESCE(t3.zdeposit,"NULL"))
           AND (COALESCE(t1.zcliente,"NULL") = COALESCE(t3.zcliente,"NULL"))
           AND (COALESCE(t1.cmoeda,"NULL") = COALESCE(t3.cmoeda,"NULL"))
           AND (COALESCE(t1.cod_contavirt,"NULL") = COALESCE(t3.cod_contavirt,"NULL"))
           AND (COALESCE(t1.contraparte_i_desc,"NULL") = COALESCE(t3.contraparte_i_desc,"NULL"))) t4
ON (COALESCE(t2.zdeposit,"NULL") = COALESCE(t4.zdeposit,"NULL"))
AND (COALESCE(t2.zcliente,"NULL") = COALESCE(t4.zcliente,"NULL"))
AND (COALESCE(t2.cmoeda,"NULL") = COALESCE(t4.cmoeda,"NULL"))
AND (COALESCE(t2.cod_contavirt,"NULL") = COALESCE(t4.cod_contavirt,"NULL"))
AND (COALESCE(t2.contraparte_i_desc,"NULL") = COALESCE(t4.contraparte_i_desc,"NULL"))
GROUP BY t4.zdeposit,
         t4.zcliente,
         t4.cmoeda,
         t4.cod_contavirt,
         t4.contraparte_i_desc,
         t4.flag_pme,
         t4.empresa_intragrupo,
         t4.cpais_residencia,
         t4.ref_date,
         t4.eleg_fund_prop,
         t2.SUM_of_mon_fund_prop,
         t4.lei_aplicavel,
         t4.termo_estruturado,
         t4.dt_emissao,
         t4.dt_vencim,
         t4.st_sgps_portugal_ifrs;



CREATE TABLE bu_captools_work.query_for_filter_for_query__0030 AS
SELECT t2.zdeposit AS zdeposit,
    t2.zcliente AS zcliente,
    t2.cmoeda,
    CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_msal) AS DECIMAL(23,6)) AS SUM_of_saldo,
    CAST(SUM(t1.SUM_of_SUM_of_SUM_of_msaldo_fina) AS DECIMAL(23,6)) AS SUM_of_juros,
    t2.cod_contavirt,
    t2.contraparte_i_desc,
    t2.flag_pme,
    t2.empresa_intragrupo,
    t2.cpais_residencia,
    CAST(AVG(t2.AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_tx_contrato_pas,
    CAST(AVG(t1.AVG_of_AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_juros,
    t2.ref_date,
    CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_mcob) AS DECIMAL(21,8)) AS SUM_of_mcoberto_eu,
    CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_mco1) AS DECIMAL(21,8)) AS SUM_of_mcoberto_me,
    t2.eleg_fund_prop,
    t2.SUM_of_mon_fund_prop,
    t2.lei_aplicavel,
    t2.termo_estruturado,
    t2.dt_emissao,
    t2.dt_vencim,
    t2.clei AS clei,
    t2.st_sgps_portugal_ifrs,
    t1.cod_contavirt AS cod_contavirt1
FROM bu_captools_work.query_for_filter_for_query__002a t2
FULL JOIN bu_captools_work.query_for_filter_for_query__002d t1
ON (t2.cmoeda = t1.cmoeda)
AND (t2.contraparte_i_desc = t1.contraparte_i_desc)
AND (t2.flag_pme = t1.flag_pme)
AND (t2.ref_date = t1.ref_date)
AND (t2.empresa_intragrupo = t1.empresa_intragrupo)
AND (t2.cod_contavirt = t1.cod_contavirt)
AND (t2.eleg_fund_prop = t1.eleg_fund_prop)
AND (t2.dt_emissao = t1.dt_emissao)
AND (t2.dt_vencim = t1.dt_vencim)
AND (t2.zdeposit = t1.zdeposit)
AND (t2.clei = t1.clei)
AND (t2.zcliente = t1.zcliente)
GROUP BY t2.zdeposit,
         t2.zcliente,
         t2.cmoeda,
         t2.cod_contavirt,
         t2.contraparte_i_desc,
         t2.flag_pme,
         t2.empresa_intragrupo,
         t2.cpais_residencia,
         t2.ref_date,
         t2.eleg_fund_prop,
         t2.SUM_of_mon_fund_prop,
         t2.lei_aplicavel,
         t2.termo_estruturado,
         t2.dt_emissao,
         t2.dt_vencim,
         t2.clei,
         t2.st_sgps_portugal_ifrs,
         t1.cod_contavirt;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0032 AS
SELECT t2.zdeposit AS zdeposit,
    t2.zcliente AS zcliente,
    t2.cmoeda,
    CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_msal) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_SUM_of_SUM_,
    CAST(SUM(t1.SUM_of_SUM_of_SUM_of_msaldo_fina) AS DECIMAL(23,6)) AS SUM_of_juros,
    t2.cod_contavirt,
    t2.contraparte_i_desc,
    t2.flag_pme,
    t2.empresa_intragrupo,
    t2.cpais_residencia,
    CAST(AVG(t2.AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_AVG_of_tx_contrato_pas,
    CAST(AVG(t1.AVG_of_AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_juros,
    t2.ref_date,
    CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_mcob) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_SUM_of_SUM1,
    CAST(SUM(t2.SUM_of_SUM_of_SUM_of_SUM_of_mco1) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_SUM_of_SUM2,
    t2.csector_inst,
    t2.contraparte_i_desc AS contraparte_i_desc1,
    t2.eleg_fund_prop,
    t2.SUM_of_mon_fund_prop,
    t2.lei_aplicavel,
    t2.termo_estruturado AS termo_estruturado,
    t2.dt_emissao AS dt_emissao,
    t2.dt_vencim AS dt_vencim,
    t2.clei AS clei,
    t2.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_filter_for_query__002b t2
FULL JOIN bu_captools_work.query_for_filter_for_query_0030 t1
ON (COALESCE(t2.cmoeda,"NULL") = COALESCE(t1.cmoeda,"NULL"))
AND (COALESCE(t2.cod_contavirt,"NULL") = COALESCE(t1.cod_contavirt,"NULL"))
AND (COALESCE(t2.contraparte_i_desc,"NULL") = COALESCE(t1.contraparte_i_desc,"NULL"))
AND (COALESCE(t2.flag_pme,"NULL") = COALESCE(t1.flag_pme,"NULL"))
AND (COALESCE(t2.ref_date,"NULL") = COALESCE(t1.ref_date,"NULL"))
AND (COALESCE(t2.empresa_intragrupo,"NULL") = COALESCE(t1.empresa_intragrupo,"NULL"))
AND (COALESCE(t2.eleg_fund_prop,"NULL") = COALESCE(t1.eleg_fund_prop,"NULL"))
AND (COALESCE(t2.dt_emissao,"NULL") = COALESCE(t1.dt_emissao,"NULL"))
AND (COALESCE(t2.dt_vencim,"NULL") = COALESCE(t1.dt_vencim,"NULL"))
AND (COALESCE(t2.zdeposit,"NULL") = COALESCE(t1.zdeposit,"NULL"))
AND (COALESCE(t2.clei,"NULL") = COALESCE(t1.clei,"NULL"))
AND (COALESCE(t2.zcliente,"NULL") = COALESCE(t1.zcliente,"NULL"))
GROUP BY t2.zdeposit,
         t2.zcliente,
         t2.cmoeda,
         t2.cod_contavirt,
         t2.contraparte_i_desc,
         t2.flag_pme,
         t2.empresa_intragrupo,
         t2.cpais_residencia,
         t2.ref_date,
         t2.csector_inst,
         t2.eleg_fund_prop,
         t2.SUM_of_mon_fund_prop,
         t2.lei_aplicavel,
         t2.termo_estruturado,
         t2.dt_emissao,
         t2.dt_vencim,
         t2.clei,
         t2.st_sgps_portugal_ifrs;



CREATE TABLE bu_captools_work.query_for_filter_for_query_003b AS
SELECT t2.tayd91c0_gelem30,
       t1.SUM_of_msaldo_final,
       t1.descritivo,
       t1.nome_atributo_dim5,
       t1.zdeposit,
       t1.contraparte_i_desc,
       t1.SUM_of_juros,
       t1.isin1,
       t1.tipo_titulo1,
       t1.tipo_tx1,
       t1.tx_fixa1,
       t1.indx_tx_var1,
       t1.sprd_tx_var1,
       t1.dt_emissao1,
       t1.dt_vencim1,
       t1.lei_aplicavel1,
       t1.agente_pagador1,
       t1.trustee1,
       t1.depositario1,
       t1.bolsa_valores1,
       t1.sist_liquidacao1,
       t1.termo_estruturado1,
       t1.eleg_fund_prop1,
       t1.mon_fund_prop1,
       t1.eleg_eurosistema1,
       t1.nom_tot_inic,
       t1.SUM_of_SUM_of_Calculation
FROM bu_captools_work.query_for_filter_for_query_0036 t1
LEFT JOIN cd_captools.TAT91_206 t2 ON (t1.cmoeda = t2.tayd91c0_celemtab);



CREATE TABLE bu_captools_work.filter_for_query_for_filter_for_ AS
SELECT t1.csector_inst,
       t1.cmoeda,
       t1.SUM_of_SUM_of_msaldo_final11,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.AVG_of_tx_contrato_pas,
       t1.ref_date,
       t1.SUM_of_SUM_of_mcoberto_eur2,
       t1.SUM_of_SUM_of_mcoberto_me2
FROM bu_captools_work.query_for_filter_for_query_0023 t1
WHERE t1.csector_inst NOT LIKE 'S128%';



CREATE TABLE bu_captools_work.filter_for_query_for_filter_0001 AS
SELECT t1.cmoeda,
       t1.SUM_of_SUM_of_msaldo_final11,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.AVG_of_tx_contrato_pas,
       t1.ref_date,
       t1.SUM_of_SUM_of_mcoberto_eur2,
       t1.SUM_of_SUM_of_mcoberto_me2,
       t1.csector_inst
FROM bu_captools_work.query_for_filter_for_query_0023 t1
WHERE t1.csector_inst LIKE 'S128%';


CREATE TABLE bu_captools_work.query_for_filter_for_query_002b AS
SELECT CAST(SUM(t1.SUM_of_SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fina
FROM bu_captools_work.query_for_filter_for_query__0019 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0046 AS
SELECT t1.zcliente,
       t1.tayd91c0_gelem30,
       t1.clei,
       t1.SUM_of_msaldo_final,
       t1.SUM_juros,
       t1.AVG_of_tx_contrato_pas,
       t1.contraparte_i_desc,
       t1.gcliente,
       t1.ref_date,
       t1.Calculation,
       t2.Classification
FROM bu_captools_work.query_for_filter_for_query__0028 t1
LEFT JOIN bu_captools_work.filter_for_t_06_01_zclientes_22 t2
ON (IF(t1.zcliente IS NULL, '', t1.zcliente) = t2.zcliente);


CREATE TABLE bu_captools_work.query_for_filter_for_query_0040 AS
SELECT t1.zcliente
FROM bu_captools_work.query_for_filter_for_query__0028 t1
WHERE t1.Calculation = 0;


CREATE TABLE bu_captools_work.query_for_filter_for_query_0034 AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.cmoeda,
       t1.SUM_of_SUM_of_SUM_of_SUM_of_SUM_ AS SUM_of_saldo,
       t1.SUM_of_juros,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       t1.AVG_of_AVG_of_tx_contrato_pas AS AVG_of_tx_contrato_pas,
       t1.AVG_of_juros,
       t1.ref_date,
       t1.SUM_of_SUM_of_SUM_of_SUM_of_SUM1 AS SUM_of_mcoberto_eu,
       t1.SUM_of_SUM_of_SUM_of_SUM_of_SUM2 AS SUM_of_mcoberto_me,
       t1.csector_inst,
       t1.eleg_fund_prop,
       t1.SUM_of_mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_filter_for_query_0032 t1
UNION ALL
SELECT t2.zdeposit,
       t2.zcliente,
       t2.cmoeda,
       t2.SUM_of_saldo,
       t2.SUM_of_juros,
       t2.cod_contavirt,
       t2.contraparte_i_desc,
       t2.flag_pme,
       t2.empresa_intragrupo,
       t2.cpais_residencia,
       t2.AVG_of_tx_contrato_pas,
       t2.AVG_of_juros,
       t2.ref_date,
       t2.SUM_of_mcoberto_eu,
       t2.SUM_of_mcoberto_me,
       NULL as csector_inst,
       t2.eleg_fund_prop,
       t2.SUM_of_mon_fund_prop,
       t2.lei_aplicavel,
       t2.termo_estruturado,
       t2.dt_emissao,
       t2.dt_vencim,
       NULL as clei,
       t2.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_filter_for_query__003b t2;



CREATE TABLE bu_captools_work.query_for_filter_for_query__0027 AS
SELECT t2.tayd91c0_gelem30,
       t1.SUM_of_msaldo_final,
       t1.descritivo,
       t1.nome_atributo_dim5,
       t1.zdeposit,
       t1.contraparte_i_desc,
       t1.SUM_of_juros,
       t1.isin1,
       t1.tipo_titulo1,
       t1.tipo_tx1,
       t1.tx_fixa1,
       t1.indx_tx_var1,
       t1.sprd_tx_var1,
       t1.dt_emissao1,
       t1.dt_vencim1,
       t2.tayd91c0_gelemtab AS tayd91c0_gelemtab1,
       t1.agente_pagador1,
       t1.trustee1,
       t1.depositario1,
       t1.bolsa_valores1,
       t1.sist_liquidacao1,
       t1.termo_estruturado1,
       t1.eleg_fund_prop1,
       t1.mon_fund_prop1,
       t1.eleg_eurosistema1,
       t1.nom_tot_inic,
       t1.SUM_of_SUM_of_Calculation
FROM bu_captools_work.query_for_filter_for_query_003b t1
LEFT JOIN cd_captools.TAT91_015 t2
ON (t1.lei_aplicavel1 = t2.tayd91c0_celemtab);



CREATE TABLE bu_captools_work.query_for_filter_for_query__001b AS
SELECT t2.cmoeda,
    CAST(SUM(t2.SUM_of_SUM_of_msaldo_final11) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fina,
    t2.contraparte_i_desc,
    t2.flag_pme,
    CAST(AVG(t2.AVG_of_tx_contrato_pas) AS DECIMAL(10,5)) AS AVG_of_AVG_of_tx_contrato_pas,
    t2.ref_date,
    CAST(SUM(t2.SUM_of_SUM_of_mcoberto_eur2) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_mcoberto_eu,
    CAST(SUM(t2.SUM_of_SUM_of_mcoberto_me2) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_mcoberto_me
FROM bu_captools_work.FILTER_FOR_QUERY_FOR_FILTER_FOR_ t2
WHERE t2.SUM_of_SUM_of_msaldo_final11 <> 0
GROUP BY t2.cmoeda,
         t2.contraparte_i_desc,
         t2.flag_pme,
         t2.ref_date;



CREATE TABLE bu_captools_work.query_for_filter_for_query__001d AS
SELECT CAST(SUM(t1.SUM_of_SUM_of_msaldo_final11) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fina,
       CAST(SUM(t1.SUM_of_SUM_of_mcoberto_eur2) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_mcoberto_eu,
       CAST(SUM(t1.SUM_of_SUM_of_mcoberto_me2) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_mcoberto_me
FROM bu_captools_work.FILTER_FOR_QUERY_FOR_FILTER_0001 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_for_f AS
SELECT t2.cmoeda,
       t2.SUM_of_SUM_of_msaldo_final11,
       t1.SUM_of_msaldo_final AS SUM_of_msaldo_final_juros,
       t2.contraparte_i_desc,
       t2.flag_pme,
       t2.AVG_of_tx_contrato_pas,
       t1.AVG_of_tx_contrato_pas AS AVG_of_tx_contrato_pas_j,
       t2.ref_date,
       t2.SUM_of_SUM_of_mcoberto_eur2,
       t2.SUM_of_SUM_of_mcoberto_me2,
       t2.csector_inst
FROM bu_captools_work.filter_for_query_for_filter_0001 t2
FULL JOIN bu_captools_work.filter_for_query_for_filter_0005 t1
ON (t2.cmoeda = t1.cmoeda)
AND (t2.contraparte_i_desc = t1.contraparte_i_desc)
AND (t2.flag_pme = t1.flag_pme)
AND (t2.ref_date = t1.ref_date);



CREATE TABLE bu_captools_work.query_for_filter_for_query_0049 AS
SELECT CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       CAST(SUM(t1.SUM_juros) AS DECIMAL(23,6)) AS SUM_of_SUM_juros
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY_0046 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_003a AS
SELECT t1.zdeposit,
       t1.zcliente,
       t2.tayd91c0_gelem30,
       t1.SUM_of_saldo,
       t1.SUM_of_juros,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.cpais_residencia,
       t1.AVG_of_tx_contrato_pas,
       t1.AVG_of_juros,
       t1.ref_date,
       t1.SUM_of_mcoberto_eu,
       t1.SUM_of_mcoberto_me,
       t1.csector_inst,
       t1.eleg_fund_prop,
       t1.SUM_of_mon_fund_prop,
       t1.lei_aplicavel,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_filter_for_query_0034 t1
LEFT JOIN cd_captools.TAT91_206 t2
ON (t1.cmoeda = t2.tayd91c0_celemtab);


CREATE TABLE bu_captools_work.query_for_filter_for_query_0048 AS
SELECT CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       CAST(SUM(t1.SUM_of_juros) AS DECIMAL(23,6)) AS SUM_of_SUM_of_juros
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__0027 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query__001c AS
SELECT CAST(SUM(t1.SUM_of_SUM_of_SUM_of_msaldo_fina) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_SUM_of_msal,
       CAST(SUM(t1.SUM_of_SUM_of_SUM_of_mcoberto_eu) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_SUM_of_mcob,
       CAST(SUM(t1.SUM_of_SUM_of_SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_SUM_of_SUM_of_mco1
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__001B t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0028 AS
SELECT t2.cmoeda,
       t2.SUM_of_SUM_of_SUM_of_msaldo_fina,
       t1.SUM_of_SUM_of_msaldo_final AS SUM_of_SUM_of_msaldo_final_juros,
       t2.contraparte_i_desc,
       t2.flag_pme,
       t2.AVG_of_AVG_of_tx_contrato_pas,
       t1.AVG_of_AVG_of_tx_contrato_pas AS AVG_of_AVG_of_tx_contrato_pas_j,
       t2.ref_date,
       t2.SUM_of_SUM_of_SUM_of_mcoberto_eu,
       t2.SUM_of_SUM_of_SUM_of_mcoberto_me
FROM bu_captools_work.query_for_filter_for_query__001b t2
FULL JOIN bu_captools_work.query_for_filter_for_query__0019 t1
ON (t2.cmoeda = t1.cmoeda)
AND (t2.contraparte_i_desc = t1.contraparte_i_desc)
AND (t2.flag_pme = t1.flag_pme)
AND (t2.ref_date = t1.ref_date);



CREATE TABLE bu_captools_work.query_for_filter_for_query__0038 AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.tayd91c0_gelem30 AS tayd91c0_gelem301,
       t1.SUM_of_saldo,
       t1.SUM_of_juros,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t2.tayd91c0_gelem30,
       t1.AVG_of_tx_contrato_pas,
       t1.AVG_of_juros,
       t1.ref_date,
       t1.SUM_of_mcoberto_eu,
       t1.SUM_of_mcoberto_me,
       t1.csector_inst,
       t1.eleg_fund_prop,
       t1.SUM_of_mon_fund_prop,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs
FROM bu_captools_work.query_for_filter_for_query_003a t1
LEFT JOIN cd_captools.tat91_015 t2
ON (t1.lei_aplicavel = t2.tayd91c0_celemtab);



CREATE TABLE bu_captools_work.query_for_filter_for_query_002c AS
SELECT CAST(SUM(t1.SUM_of_SUM_of_SUM_of_msaldo_fina) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_SUM_of_msal,
       CAST(SUM(t1.SUM_of_SUM_of_msaldo_final_juros) AS DECIMAL(23,6)) AS SUM_of_SUM_of_SUM_of_msaldo_fina
FROM bu_captools_work.query_for_filter_for_query_0028 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_002d AS
SELECT t1.cmoeda,
       t1.SUM_of_SUM_of_SUM_of_msaldo_fina AS SUM_of_msaldo_final,
       t1.SUM_of_SUM_of_msaldo_final_juros AS SUM_of_msaldo_final_juros,
       t2.SUM_of_SUM_of_msaldo_final11 AS SUM_of_msaldo_final_s128,
       t2.SUM_of_msaldo_final_juros AS SUM_of_msaldo_final_juros_s128,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.AVG_of_AVG_of_tx_contrato_pas AS AVG_of_tx_contrato_pas,
       t1.AVG_of_AVG_of_tx_contrato_pas_j AS AVG_of_tx_contrato_pas_juros,
       t2.AVG_of_tx_contrato_pas AS AVG_of_tx_contrato_pas_s128,
       t2.AVG_of_tx_contrato_pas_j AS AVG_of_tx_contrato_pas_juro_s128,
       t1.ref_date,
       t2.csector_inst,
       t1.SUM_of_SUM_of_SUM_of_mcoberto_eu AS SUM_of_mcoberto_eu,
       t1.SUM_of_SUM_of_SUM_of_mcoberto_me AS SUM_of_mcoberto_me,
       t2.SUM_of_SUM_of_mcoberto_eur2 AS SUM_of_mcoberto_eur_s128,
       t2.SUM_of_SUM_of_mcoberto_me2 AS SUM_of_mcoberto_me_s128
FROM bu_captools_work.query_for_filter_for_query_for_f t2
FULL JOIN bu_captools_work.query_for_filter_for_query_0028 t1
ON (t2.cmoeda = t1.cmoeda)
AND (t2.contraparte_i_desc = t1.contraparte_i_desc)
AND (t2.flag_pme = t1.flag_pme)
AND (t2.ref_date = t1.ref_date);


-- Foi necessário adicionar campos a NULL para as tabelas terem o mesmo numero de colunas
CREATE TABLE bu_captools_work.append_table_0000 AS
SELECT zdeposit,
       zcliente,
       tayd91c0_gelem301 AS tayd91c0_gelem301,
       SUM_of_saldo,
       SUM_of_juros,
       cod_contavirt,
       contraparte_i_desc,
       flag_pme,
       empresa_intragrupo,
       tayd91c0_gelem30,
       AVG_of_tx_contrato_pas,
       AVG_of_juros,
       ref_date,
       SUM_of_mcoberto_eu,
       SUM_of_mcoberto_me,
       csector_inst,
       eleg_fund_prop,
       SUM_of_mon_fund_prop,
       termo_estruturado,
       dt_emissao,
       dt_vencim,
       clei,
       st_sgps_portugal_ifrs,
       NULL as cpais_residencia,
       NULL as cmoeda
FROM bu_captools_work.query_for_filter_for_query__0038
UNION ALL
SELECT zdeposit,
       zcliente,
       tayd91c0_gelem30 as tayd91c0_gelem301,
       SUM_of_saldo,
       NULL as SUM_of_juros,
       cod_contavirt,
       contraparte_i_desc,
       flag_pme,
       empresa_intragrupo,
       NULL as tayd91c0_gelem30,
       NULL as AVG_of_tx_contrato_pas,
       NULL as AVG_of_juros,
       ref_date,
       NULL as SUM_of_mcoberto_eu,
       NULL as SUM_of_mcoberto_me,
       csector_inst,
       NULL as eleg_fund_prop,
       NULL as SUM_of_mon_fund_prop,
       NULL as termo_estruturado,
       NULL as dt_emissao,
       NULL as dt_vencim,
       NULL as clei,
       st_sgps_portugal_ifrs,
       cpais_residencia,
       cmoeda
FROM bu_captools_work.query_for_ldrmaster_0005;



CREATE TABLE bu_captools_work.query_for_filter_for_query_003d AS
SELECT CAST(SUM(t1.SUM_of_saldo) AS DECIMAL(23,6)) AS SUM_of_SUM_of_saldo,
       CAST(SUM(t1.SUM_of_juros) AS DECIMAL(23,6)) AS SUM_of_SUM_of_juros,
       CAST(SUM(t1.SUM_of_mcoberto_eu) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eu,
       CAST(SUM(t1.SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me,
       CAST(SUM(t1.SUM_of_mon_fund_prop) AS DECIMAL(19,2)) AS SUM_of_SUM_of_mon_fund_prop
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__0038 t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query_0041 AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.tayd91c0_gelem301,
       t1.SUM_of_saldo,
       t1.SUM_of_juros,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.tayd91c0_gelem30,
       t1.AVG_of_tx_contrato_pas,
       t1.AVG_of_juros,
       t1.ref_date,
       t1.SUM_of_mcoberto_eu,
       t1.SUM_of_mcoberto_me,
       t1.csector_inst,
       t1.eleg_fund_prop,
       t1.SUM_of_mon_fund_prop,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei
FROM bu_captools_work.query_for_filter_for_query__0038 t1
WHERE t1.empresa_intragrupo LIKE '%GAMMA%';



CREATE TABLE bu_captools_work.query_for_filter_for_query_0047 AS
SELECT t1.cod_contavirt,
       CAST(SUM(t1.SUM_of_saldo) AS DECIMAL(23,6)) AS SUM_of_SUM_of_saldo,
       CAST(SUM(t1.SUM_of_juros) AS DECIMAL(23,6)) AS SUM_of_SUM_of_juros
FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__0038 t1
GROUP BY t1.cod_contavirt;


-- Troquei o nome da variavel SUM_of_SUM_of_msaldo_final_juros para SUM_of_SUM_of_msaldo_final_juros_s128
CREATE TABLE bu_captools_work.query_for_filter_for_query__0018 AS
SELECT CAST(SUM(t1.SUM_of_msaldo_final) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final,
       CAST(SUM(t1.SUM_of_msaldo_final_juros) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final_juros,
       CAST(SUM(t1.SUM_of_msaldo_final_s128) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final_s128,
       CAST(SUM(t1.SUM_of_msaldo_final_juros_s128) AS DECIMAL(23,6)) AS SUM_of_SUM_of_msaldo_final_juros_s128,
       CAST(SUM(t1.SUM_of_mcoberto_eu) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eu,
       CAST(SUM(t1.SUM_of_mcoberto_me) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me,
       CAST(SUM(t1.SUM_of_mcoberto_eur_s128) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_eur_s128,
       CAST(SUM(t1.SUM_of_mcoberto_me_s128) AS DECIMAL(21,8)) AS SUM_of_SUM_of_mcoberto_me_s128
FROM bu_captools_work.query_for_filter_for_query_002d t1;



CREATE TABLE bu_captools_work.query_for_filter_for_query__0026 AS
SELECT t2.tayd91c0_gelem30,
       t1.SUM_of_msaldo_final,
       t1.SUM_of_msaldo_final_juros,
       t1.SUM_of_msaldo_final_s128,
       t1.SUM_of_msaldo_final_juros_s128,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.AVG_of_tx_contrato_pas,
       t1.AVG_of_tx_contrato_pas_juros,
       t1.AVG_of_tx_contrato_pas_s128,
       t1.AVG_of_tx_contrato_pas_juro_s128,
       t1.ref_date,
       t1.csector_inst,
       t1.SUM_of_mcoberto_eu,
       t1.SUM_of_mcoberto_me,
       t1.SUM_of_mcoberto_eur_s128,
       t1.SUM_of_mcoberto_me_s128
FROM bu_captools_work.query_for_filter_for_query_002d t1
LEFT JOIN cd_captools.TAT91_206 t2
ON (t1.cmoeda = t2.tayd91c0_celemtab);



CREATE TABLE bu_captools_work.query_for_append_table AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.tayd91c0_gelem301,
       t1.SUM_of_saldo,
       t1.SUM_of_juros,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.tayd91c0_gelem30,
       t1.AVG_of_tx_contrato_pas,
       t1.AVG_of_juros,
       t1.ref_date,
       t1.SUM_of_mcoberto_eu,
       t1.SUM_of_mcoberto_me,
       t1.csector_inst,
       t1.eleg_fund_prop,
       t1.SUM_of_mon_fund_prop,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs,
       t1.cpais_residencia,
       t1.cmoeda
FROM bu_captools_work.append_table_0000 t1
WHERE t1.SUM_of_saldo IS NOT NULL
OR t1.SUM_of_juros IS NOT NULL;



CREATE TABLE bu_captools_work.query_for_append_table_0001 AS
SELECT t1.zdeposit,
       t1.zcliente,
       t1.tayd91c0_gelem301,
       t1.SUM_of_saldo,
       t1.SUM_of_juros,
       t1.cod_contavirt,
       t1.contraparte_i_desc,
       t1.flag_pme,
       t1.empresa_intragrupo,
       t1.tayd91c0_gelem30,
       t1.AVG_of_tx_contrato_pas,
       t1.AVG_of_juros,
       t1.ref_date,
       t1.SUM_of_mcoberto_eu,
       t1.SUM_of_mcoberto_me,
       t1.csector_inst,
       t1.eleg_fund_prop,
       t1.SUM_of_mon_fund_prop,
       t1.termo_estruturado,
       t1.dt_emissao,
       t1.dt_vencim,
       t1.clei,
       t1.st_sgps_portugal_ifrs,
       t1.cpais_residencia,
       t1.cmoeda
FROM bu_captools_work.query_for_append_table t1
WHERE t1.cod_contavirt <> 'C_32' OR t1.cod_contavirt IS NULL;



CREATE TABLE bu_captools_work.query_for_append_table_0002 AS
SELECT CAST(SUM(t1.SUM_of_saldo) AS DECIMAL(23,6)) AS SUM_of_SUM_of_saldo,
       CAST(SUM(t1.SUM_of_juros) AS DECIMAL(23,6)) AS SUM_of_SUM_of_juros,
       t1.cod_contavirt
FROM bu_captools_work.QUERY_FOR_APPEND_TABLE_0001 t1
GROUP BY t1.cod_contavirt;


DROP TABLE IF EXISTS bu_captools_work.balanco_ind purge;
DROP TABLE IF EXISTS bu_captools_work.ct008_refdate purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ct007_pv_planos purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct011_dim_hier purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct010_dim_valor purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct063_univ_pme purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct081_finrep purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct004_univ_cto purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct003_univ_cli purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_clientes_intragrupo purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_perimetro purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_al001_cnt_core purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ct008_refdate purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct010_dim_valor_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct010_dim_valor_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_clientes_in purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_al001__0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct008_pv_co purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct081__0000 purge;
DROP TABLE IF EXISTS bu_captools_work.passivo purge;
DROP TABLE IF EXISTS bu_captools_work.ativo purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct008__0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct081 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct010_dim_v purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct010__0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct010__0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct010__0002 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_balanco_ind_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0005 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0006 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0008 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_0009 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct001_000f purge;
DROP TABLE IF EXISTS bu_captools_work.ldrmasterindividual202212 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_al015_act_fin purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct610_titulos purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct069_univ_gr_ec_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_ct070_univ_gr_cl_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0004 purge;
DROP TABLE IF EXISTS bu_captools_work.QUERY_FOR_LDRMASTER_0005_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0002 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000e purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0002 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000c purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmaster purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0006 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0013 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0014 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster1 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0011 purge;
DROP TABLE IF EXISTS bu_captools_work.FILTER_FOR_FG001_FGD purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_fg001_fgd_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.FILTER_FOR_CQ_ISDA_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0015 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct610_titul purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_ct069__0000 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_t_06_01_zclientes_22 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_balencete_22 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0034 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__003d purge;
DROP TABLE IF EXISTS bu_captools_work.validacao_balanco_2 purge;
DROP TABLE IF EXISTS bu_captools_work.validacao_balanco purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002c purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002e purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_for_l purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__000f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_fo purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmaster_0 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0013 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster1_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster1_0001_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster1_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_000e purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_fg001_fgd purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0018 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_000a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_000a_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0031 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0032 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0009 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_al015_act_fin_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster2_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0015 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0025 purge;
DROP TABLE IF EXISTS bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__003A purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0043 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_000e purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0003 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_fg001_fgd1 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0020 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_000a_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0008 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0033 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0045 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0039 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0029 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000a purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_000b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0024 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0023 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster2_0002 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0006 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query2 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_001d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_001e purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_ldrmas_0007 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0022 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0037 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0029 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0011 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0017 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0033 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_ldrmaster_0005_00_0004 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0030 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0038 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0022 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0004 purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0005 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_balencete purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_004b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__002b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0036 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0023 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0019 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001e purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0028 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__003b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0030 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0032 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_003b purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_for_ purge;
DROP TABLE IF EXISTS bu_captools_work.filter_for_query_for_filter_0001 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0049 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0040 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0034 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001b purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_for_f purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_003a purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0048 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__001c purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0028 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0038 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002c purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_002d purge;
DROP TABLE IF EXISTS bu_captools_work.append_table_0000 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_003d purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0041 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query_0047 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_filter_for_query__0018 purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_append_table purge;
DROP TABLE IF EXISTS bu_captools_work.query_for_append_table_0002 purge;
