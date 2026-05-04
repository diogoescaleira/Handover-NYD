--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- LEVANTAMENTO DAS MÉTRICAS - Contrato + Cliente ------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Step1: construção de tabela com o mapeamento dos campos ao nível do contrato master (cempresa + cbalcao + cnumecta + zdeposit)
-- e do contrato FINREP (cempresa_fr012 + cbalcao_fr012 + cnumecta_fr012 + zdeposit_fr012) e do cliente (zcliente);
-- 8.983.638 registos Piloto Jun23
-- 8 645 565 registos Dez23
-- 8.645.605 registos -> Nova corrida Dez23
-- 8.643.842 registos Jun24 (Dados de Dez23)
-- 9.734.874 registos Jun24
-- 9 735 414 registos Jun24 (Corrida Final) 
ref_date = "${ref_date}" 
data_date_part = '${ref_date_vias_pt}' --Para jun/24: 2024-06-29 ---> validar

SET mem_limit=30gb;

-- DROP TABLE bu_esg_work.rf_metricas_pilar3_ctr_preaux_jun24;
CREATE TABLE bu_esg_work.rf_metricas_pilar3_ctr_preaux_jun24 AS
SELECT DISTINCT base.*,
                ct001.zcliente
FROM
  (SELECT *
   FROM bu_esg_work.rf_pilar3_universo_full_jun24) base 
-- Cruzamento para obter dados da tabela de universo (ct001)
LEFT JOIN
  (SELECT DISTINCT *
   FROM cd_captools.ct001_univ_saldo
   WHERE ref_date = '${ref_date}') ct001 ON base.cempresa_ct = ct001.cempresa
AND base.cbalcao_ct = ct001.cbalcao
AND base.cnumecta_ct = ct001.cnumecta
AND base.zdeposit_ct = ct001.zdeposit ;

-- Universo de contratos (Master/FinRep) distintos:
-- 1.845.175 registos Piloto Jun23
-- 1.811.865 registos Dez23
-- 1.811.869 -> Nova corrida Dez23
-- 1.809.920 registos Jun24 (Dados de Dez23)
-- 2.067.284 registos Jun24 
-- 2 067 600  registos Jun24 (Corrida Final) 
-- DROP TABLE bu_esg_work.rf_metricas_pilar3_ctr_aux_jun24;

CREATE TABLE bu_esg_work.rf_metricas_pilar3_ctr_aux_jun24 AS WITH a1 AS
  (SELECT clyr7003_cendregi,
          clyr7003_cpostal,
          clyr7003_cp3,
          clyr7003_zcliente,
          "Completo" AS val_univ,
          COUNT(*) AS COUNT
   FROM cd_estruturais.interface_moradas
   WHERE data_date_part IN
       (SELECT MAX(data_date_part)
        FROM cd_estruturais.interface_moradas
        WHERE data_date_part <= '${ref_date}')
     AND clyr7003_imorfisc = 'S'
     AND concat(clyr7003_cpostal, clyr7003_cp3) IN
       (SELECT concat(zona, codcomp)
        FROM cd_estruturais.vias_pt
        WHERE data_date_part = '${ref_date_vias_pt}')
   GROUP BY clyr7003_cendregi,
            clyr7003_cpostal,
            clyr7003_cp3,
            clyr7003_zcliente),
             a2 AS
  (SELECT clyr7003_cendregi,
          clyr7003_cpostal,
          clyr7003_cp3,
          clyr7003_zcliente,
          "Incompleto" AS val_univ,
          COUNT(*) AS COUNT
   FROM cd_estruturais.interface_moradas
   WHERE data_date_part IN
       (SELECT MAX(data_date_part)
        FROM cd_estruturais.interface_moradas
        WHERE data_date_part <= '${ref_date}')
     AND clyr7003_imorfisc = 'S'
     AND concat(clyr7003_cpostal, clyr7003_cp3) NOT IN
       (SELECT concat(zona, codcomp)
        FROM cd_estruturais.vias_pt
        WHERE data_date_part = '${ref_date_vias_pt}')
   GROUP BY clyr7003_cendregi,
            clyr7003_cpostal,
            clyr7003_cp3,
            clyr7003_zcliente),
             a3 AS
  (SELECT *
   FROM
     (SELECT ROW_NUMBER () OVER (PARTITION BY ccligrupo
                                 ORDER BY dano DESC, cgestor DESC, dfim DESC) AS ORDEM,
             CCLIGRUPO,
             DANO,
             CGESTOR,
             DFIM,
             itip_inf,
             cperiodo
      FROM
        (SELECT BL1.*
         FROM
           (SELECT CCLIGRUPO,
                   DANO,
                   CGESTOR,
                   DFIM,
                   cperiodo,
                   itip_inf
            FROM cd_riscos.rsv176sa1_balanco
            WHERE data_date_part <= '${ref_date}'
              AND cperiodo = '212'
              AND ITIP_INF = 'I') BL1
         INNER JOIN
           (SELECT ccli_grupo,
                   dconstituicao
            FROM cd_captools.ct003_univ_cli
            WHERE ref_date = "${ref_date}") CLI ON ccli_grupo = CCLIGRUPO
         WHERE DANO <= substr("${ref_date}",1,4)
           AND DANO >= substr(dconstituicao,1,4) ) BL) FS_2
   WHERE ORDEM = 1 )
SELECT DISTINCT 
-- Algumas métricas vão ser ao nível do contrato FinRep e outras ao nível do contrato CT, i.e, contratos distintos pela chave (cempresa+cbalcao+cnumecta+zdeposit)
 base.cempresa_ct,
 base.cbalcao_ct,
 base.cnumecta_ct,
 base.zdeposit_ct,
 base.cempresa_fr012,
 base.cbalcao_fr012,
 base.cnumecta_fr012,
 base.zdeposit_fr012,
 base.zcliente,
 CASE
     WHEN trim(fr004.stage_atual) IN ('1',
                                      '2') THEN 'performing'
     WHEN trim(fr004.stage_atual) = '3' THEN 'non-performing'
     ELSE 'no_stage'
 END AS 12_non_performing, --Ir buscar aquilo que é stage 3 e <> de stage 3
 fr004.valor_bruto_on_a AS 13_gross_carrying_amount, -- exposição
 ct003.nace_code AS 14_NACE, -- NACE nível 4
 fr004.provisao_on AS 17_accumulated_impairment, -- provisões/imparidade ao nível do contrato FinRep
 NUTS3.nuts3_final 22_counterparty_NUTS, -- NUTS3
 NUTS3.cp4 AS 23_counterparty_ZIPcode, -- Informação código postal
 NUTS3.cp3 AS cp3, -- Subcódigo postal
 ct003.cpais_residencia, -- país de residência
 fr004.data_vencimento AS 28_dt_maturity, -- data de maturidade
 fr004.flag_project_finance AS 29_flag_specialised_lending,
 fr004.stage_atual AS 30_stage_IFRS9, -- stage (só irá interessar o stage 2)
 fr004.contraparte AS 33_counterparty_type, -- tipo de contraparte
 fr004.ref_date AS 83_dt_reference, -- data de referência
 ct063.fatr_indv AS 47_client_turnover, -- receitas da empresa de acordo com as suas demosntrações financeiras
 ct063.fatr_grup AS 48_group_turnover, -- receitas da empresa-mãe de acordo com as receitas de todas as empresas filiais
 rsv17.vcpim AS 51_client_own_funds, -- capital prórpio contabilistico
 ct063.num_empg_indv AS 53_client_nr_employees,
 ct063.num_empg_grup AS 54_group_nr_employees,
 bdr_juri.g5508_orig_fac AS 70_flag_audited_financial_sttmnts,
 ct063.data_dados_indv AS 71_dt_financial_statements,
 ct063.ativo_indv AS 73_client_total_assets,
 ct063.ativo_grup AS 74_group_total_assets,
 CASE
     WHEN ct610.isin IS NOT NULL THEN ct610.isin
     ELSE alm.ctitulo
 END AS 75_ISIN,
 fr004.data_abertura AS 84_dt_origination,
 CASE
     WHEN ct003.cpais_residencia IN ('276',
                                     '040',
                                     '056',
                                     '100',
                                     '196',
                                     '191',
                                     '208',
                                     '705',
                                     '724',
                                     '233',
                                     '246',
                                     '250',
                                     '300',
                                     '348',
                                     '372',
                                     '380',
                                     '440',
                                     '442',
                                     '470',
                                     '616',
                                     '620',
                                     '203',
                                     '703',
                                     '642',
                                     '752',
                                     '528',
                                     '428') THEN 'Y'
     ELSE 'N'
 END AS 93_european_union,
 (rsv17.vpnicsfin + rsv17.vpnpaslf + rsv17.vpnopfin + rsv17.vpcicsfin + rsv17.vpcopfin + rsv17.vpcpaslf) AS client_debt, -- informação do debt da área de riscos (Luís Bastos)
 ct063.fatr_indv AS client_revenue
FROM
  (SELECT *
   FROM bu_esg_work.rf_metricas_pilar3_ctr_preaux_jun24) base 
-- Cruzamento para obter dados da tabela do FINREP (fr004)
LEFT JOIN
  (SELECT DISTINCT *
   FROM cd_captools.fr004_cto
   WHERE ref_date = "${ref_date}") fr004 ON base.cempresa_fr012 = fr004.cempresa
AND base.cbalcao_fr012 = fr004.cbalcao
AND base.cnumecta_fr012 = fr004.cnumecta
AND base.zdeposit_fr012 = fr004.zdeposit
LEFT JOIN
  (SELECT DISTINCT zcliente,
                   nace_code,
                   ccli_grupo,
                   cpais_residencia
   FROM cd_captools.ct003_univ_cli
   WHERE ref_date = "${ref_date}") ct003 ON base.zcliente = ct003.zcliente 
-- Cruzamento com a tabela de PMEs e retalho para mapeamento de clientes através do zcliente
LEFT JOIN
  (SELECT DISTINCT *
   FROM cd_captools.ct063_univ_pme
   WHERE ref_date = "${ref_date}") AS ct063 ON base.zcliente = ct063.zcliente
-- Cruzamento com a tabela de balanço para obter informação dos capitais próprios, sendo para tal necessário
LEFT JOIN
  (SELECT *
   FROM
     (SELECT ROW_NUMBER () OVER (PARTITION BY BL.ccligrupo
                                 ORDER BY BL.CGESTOR DESC, `timestamp` DESC) AS ORDEM,
             BL.*
      FROM
        (SELECT CCLIGRUPO,
                DANO,
                CGESTOR,
                `timestamp`,
                DFIM,
                cperiodo,
                itip_inf,
                data_date_part,
                CAST(VCPIM AS DECIMAL(38,6)) AS VCPIM,
                CAST(VPNICSFIN AS DECIMAL(38,6)) AS VPNICSFIN,
                CAST(VPNPASLF AS DECIMAL(38,6)) AS VPNPASLF,
                CAST(VPNOPFIN AS DECIMAL(38,6)) AS VPNOPFIN,
                CAST(VPCICSFIN AS DECIMAL(38,6)) AS VPCICSFIN,
                CAST(VPCOPFIN AS DECIMAL(38,6)) AS VPCOPFIN,
                CAST(VPCPASLF AS DECIMAL(38,6)) AS VPCPASLF
         FROM cd_riscos.rsv176sa1_balanco
         WHERE data_date_part <= "${ref_date}") BL
      INNER JOIN
        (SELECT *
         FROM a3) FS ON (FS.CCLIGRUPO = BL.CCLIGRUPO
                         AND FS.DANO = BL.DANO
                         AND FS.cperiodo = BL.cperiodo
                         AND FS.ITIP_INF = BL.ITIP_INF))BL_1
   WHERE ORDEM = 1 ) rsv17 ON rsv17.CCLIGRUPO = ct003.ccli_grupo 
-- Cruzamento com a tabela de títulos para obter informação do código ISIN
LEFT JOIN
  (SELECT cempresa,
          cbalcao,
          cnumecta,
          zdeposit,
          isin
   FROM cd_captools.ct610_titulos
   WHERE ref_date = "${ref_date}") ct610 ON base.cbalcao_ct = ct610.cbalcao
AND base.cnumecta_ct = ct610.cnumecta
AND base.zdeposit_ct = ct610.zdeposit
AND base.cempresa_ct = ct610.cempresa
LEFT JOIN
  (SELECT cempresa_master,
          cbalcao_master,
          cnumecta_master,
          zdeposit_master,
          ctitulo
   FROM
     (SELECT DISTINCT cempresa,
                      cbalcao,
                      cnumecta,
                      zdeposit,
                      cempresa_master,
                      cnumecta_master,
                      cbalcao_master,
                      zdeposit_master
      FROM cd_alm.kt_chaves_alm_m
      WHERE ref_date = "${ref_date}") kt
   INNER JOIN
     (SELECT DISTINCT cempresa,
                      cbalcao,
                      cnumecta,
                      zdeposit,
                      ctitulo
      FROM cd_alm.al006_saq_ppc
      WHERE ref_date = "${ref_date}") al006 ON kt.cempresa = al006.cempresa
   AND kt.cbalcao = al006.cbalcao
   AND kt.cnumecta = al006.cnumecta
   AND kt.zdeposit = al006.zdeposit) alm ON base.cbalcao_ct = alm.cbalcao_master
AND base.cnumecta_ct = alm.cnumecta_master
AND base.zdeposit_ct = alm.zdeposit_master
AND base.cempresa_ct = alm.cempresa_master 
-- Cruzamento com tabela da BDR com informação da faturação, por forma a marcar se a faturação é resultante ou não de um balanço auditado
LEFT JOIN
  (SELECT DISTINCT a.g5508_s1emp,
                   a.g5508_idnumcli,
                   b.zcligrupo,
                   c.zcliente,
                   d.codigo_ics,
                   a.g5508_orig_fac
   FROM
     (SELECT *
      FROM cd_captools.bdr_jm_clien_juri
      WHERE data_date_part = "${ref_date}") AS a
   INNER JOIN
     (SELECT DISTINCT *
      FROM cd_captools.ct021_rwa_cli
      WHERE ref_date = "${ref_date}") AS b ON cast(a.g5508_s1emp AS string) = b.s1emp
   AND a.g5508_idnumcli = b.idnumcli
   INNER JOIN
     (SELECT DISTINCT *
      FROM cd_captools.ct003_univ_cli
      WHERE ref_date = "${ref_date}") AS c ON b.zcligrupo = c.ccli_grupo
   INNER JOIN
     (SELECT DISTINCT *
      FROM cd_captools.ct802_codigo_emp
      WHERE ref_date = "${ref_date}") AS d ON cast(a.g5508_s1emp AS string) = d.codigo_bdr) bdr_juri ON base.zcliente = bdr_juri.zcliente
AND base.cempresa_ct = bdr_juri.codigo_ics 
-- Cruzamento com tabela de moradas para obtenção do código postal da contraparte, e mapeamento da NUTS em conformidade
LEFT JOIN
  (SELECT DISTINCT clyr7003_zcliente,
                   NUTS3_FINAL,
                   clyr7003_cpostal AS cp4,
                   clyr7003_cp3 AS cp3
   FROM
     (SELECT clyr7003_cpostal,
             clyr7003_cp3,
             val_univ,
             clyr7003_zcliente,
             max(tayd91c0_nelemc05) AS NUTS3_FINAL
      FROM
        (SELECT X.*,
                coalesce(TAT_1.tayd91c0_celemtab,tayd91c0_nelemc09,vias_pt.cdisconf) AS novo_cdisconf
         FROM
           (SELECT A.*,
                   concat(b.coddis,b.codcon,b.fregna) AS cdisconf
            FROM
              (SELECT *
               FROM A1) A
            LEFT JOIN
              (SELECT coddis,
                      codcon,
                      fregna,
                      zona,
                      codcomp,
                      count(*) AS count_2
               FROM cd_estruturais.vias_pt
               WHERE coddis <> ''
                 AND data_date_part = '${ref_date_vias_pt}'
               GROUP BY coddis,
                        codcon,
                        fregna,
                        zona,
                        codcomp) b ON concat(a.clyr7003_cpostal, a.clyr7003_cp3) = concat(b.zona, b.codcomp)) X
         LEFT JOIN
           (SELECT tayd91c0_celemtab
            FROM cd_estruturais.tat91_tabelas
            WHERE data_date_part IN
                (SELECT max(data_date_part)
                 FROM cd_estruturais.tat91_tabelas
                 WHERE data_date_part <= "${ref_date}")
              AND tayd91c0_ctabela = 'J48'
              AND trim(tayd91c0_nelemc08) = 'S' ) TAT_1 ON CASE
                                                               WHEN x.cdisconf LIKE '%99' THEN replace(x.cdisconf,'99','00')
                                                               ELSE lpad(x.cdisconf,6,'0')
                                                           END = TAT_1.tayd91c0_celemtab
         LEFT JOIN
           (SELECT tayd91c0_nelemc09,
                   tayd91c0_celemtab
            FROM cd_estruturais.tat91_tabelas
            WHERE data_date_part IN
                (SELECT max(data_date_part)
                 FROM cd_estruturais.tat91_tabelas
                 WHERE data_date_part <= "${ref_date}")
              AND tayd91c0_ctabela = 'J48'
              AND trim(tayd91c0_nelemc08) = 'N'
              AND length(tayd91c0_nelemc09)= 6 ) TAT_2 ON CASE
                                                              WHEN x.cdisconf LIKE '%99' THEN replace(x.cdisconf,'99','00')
                                                              ELSE lpad(x.cdisconf,6,'0')
                                                          END = TAT_2.tayd91c0_celemtab
         LEFT JOIN
           (SELECT DISTINCT concat(coddis,codcon,fregna) AS cdisconf,
                            concat(zona,codcomp) AS cpost
            FROM cd_estruturais.vias_pt
            WHERE coddis <> ''
              AND data_date_part = '${ref_date_vias_pt}' ) vias_pt ON vias_pt.cpost = concat(clyr7003_cpostal, clyr7003_cp3)) XX
      LEFT JOIN
        (SELECT tayd91c0_nelemc05,
                data_date_part,
                tayd91c0_ctabela,
                tayd91c0_celemtab
         FROM cd_estruturais.tat91_tabelas
         WHERE data_date_part IN
             (SELECT max(data_date_part)
              FROM cd_estruturais.tat91_tabelas
              WHERE data_date_part <= "${ref_date}")
           AND tayd91c0_ctabela = 'J48' ) TAT_3 ON novo_cdisconf = TAT_3.tayd91c0_celemtab
      GROUP BY 1,
               2,
               3,
               4
      UNION ALL SELECT clyr7003_cpostal,
                       clyr7003_cp3,
                       val_univ,
                       clyr7003_zcliente,
                       max(tayd91c0_nelemc05) AS NUTS3_FINAL
      FROM
        (SELECT X.*,
                coalesce(TAT_1.tayd91c0_celemtab_AUX,tayd91c0_nelemc09_aux,substr(vias_pt.cdisconf,1,4)) AS novo_cdisconf
         FROM
           (SELECT D.*,
                   concat(F.coddis,F.codcon) AS cdisconf
            FROM
              (SELECT *
               FROM A2) d
            LEFT JOIN
              (SELECT coddis,
                      codcon,
                      fregna,
                      zona,
                      codcomp,
                      count(*) AS count_2
               FROM cd_estruturais.vias_pt
               WHERE coddis <> ''
                 AND data_date_part = '${ref_date_vias_pt}'
               GROUP BY coddis,
                        codcon,
                        fregna,
                        zona,
                        codcomp) f ON concat(d.clyr7003_cpostal) = concat(f.zona)) X
         LEFT JOIN
           (SELECT substr(tayd91c0_celemtab,1,4) AS tayd91c0_celemtab_AUX
            FROM cd_estruturais.tat91_tabelas
            WHERE data_date_part IN
                (SELECT max(data_date_part)
                 FROM cd_estruturais.tat91_tabelas
                 WHERE data_date_part <= "${ref_date}")
              AND tayd91c0_ctabela = 'J48'
              AND trim(tayd91c0_nelemc08) = 'S'
            GROUP BY 1) TAT_1 ON X.cdisconf = TAT_1.tayd91c0_celemtab_AUX
         LEFT JOIN
           (SELECT substr(tayd91c0_nelemc09,1,4) AS tayd91c0_nelemc09_aux,
                   substr(tayd91c0_celemtab,1,4) AS tayd91c0_celemtab_AUX
            FROM cd_estruturais.tat91_tabelas
            WHERE data_date_part IN
                (SELECT max(data_date_part)
                 FROM cd_estruturais.tat91_tabelas
                 WHERE data_date_part <= "${ref_date}")
              AND tayd91c0_ctabela = 'J48'
              AND trim(tayd91c0_nelemc08) = 'N'
              AND length(tayd91c0_nelemc09)= 6
            GROUP BY 1,
                     2) TAT_2 ON x.cdisconf = TAT_2.tayd91c0_celemtab_AUX
         LEFT JOIN
           (SELECT concat(coddis,codcon) AS cdisconf,
                   zona AS cpost
            FROM cd_estruturais.vias_pt
            WHERE coddis <> ''
              AND data_date_part = '${ref_date_vias_pt}'
            GROUP BY 1,
                     2) vias_pt ON vias_pt.cpost = clyr7003_cpostal) XX
      LEFT JOIN
        (SELECT tayd91c0_nelemc05,
                data_date_part,
                tayd91c0_ctabela,
                tayd91c0_celemtab
         FROM cd_estruturais.tat91_tabelas
         WHERE data_date_part IN
             (SELECT max(data_date_part)
              FROM cd_estruturais.tat91_tabelas
              WHERE data_date_part <= "${ref_date}")
           AND tayd91c0_ctabela = 'J48'
         GROUP BY 1,
                  2,
                  3,
                  4) TAT_3 ON novo_cdisconf = substr(TAT_3.tayd91c0_celemtab,1,4)
      GROUP BY 1,
               2,
               3,
               4)x) NUTS3 ON NUTS3.clyr7003_zcliente = cast(base.zcliente AS bigint) ;

;

-- Criação de nova tabela para inclusão do campo NACE ESG, com alterações nas Holdings e SPV (PF)
-- Quando temos `31_counterparty_type` = 'outras instituicoes financeiras' com `13_nace` diferente de K, o `13_nace` vai mudar para K66.2.9
-- Será adicionada a flag_SPV que estará ativa quando a flag_project_finance está ativa e o `13_nace` é K
-- 1.845.175 jun23
-- 1.811.869 dez23
-- 1.809.920 jun24 (Dados de Dez23)
-- 2.067.284 jun24 
-- 2.067.600  jun24 (Corrida Final)
-- drop table if exists bu_esg_work.rf_metricas_pilar3_ctr_cli_jun24;
INSERT overwrite TABLE  bu_esg_work.p3_ctr_cli PARTITION (id_corrida,dt_rfrnc)

-- CREATE TABLE bu_esg_work.rf_metricas_pilar3_ctr_cli_jun24 AS
SELECT aux.cempresa_ct,
       aux.cbalcao_ct,
       aux.cnumecta_ct,
       aux.zdeposit_ct,
       aux.cempresa_fr012,
       aux.cbalcao_fr012,
       aux.cnumecta_fr012,
       aux.zdeposit_fr012,
       aux.zcliente,
       aux.`12_non_performing`,
       aux.`13_gross_carrying_amount`,
       aux.`14_nace`,
       CASE
           WHEN holding.`14_nace` IS NOT NULL THEN holding.`14_nace`
           WHEN aux.`33_counterparty_type` = 'outras instituicoes financeiras'
                AND aux.`14_nace` NOT LIKE 'K%' THEN 'K66.2.9'
           ELSE aux.`14_nace`
       END AS `15_nace_esg`,
       holding.`14_nace` AS nace_hold,
       CASE
           WHEN aux.`14_nace` LIKE 'K%'
                AND pf.flag_project_finance = '1' THEN '1'
           WHEN aux.`33_counterparty_type` = 'outras instituicoes financeiras'
                AND aux.`14_nace` NOT LIKE 'K%'
                AND pf.flag_project_finance = '1' THEN '1'
           ELSE '0'
       END AS flag_SPV,
       aux.`17_accumulated_impairment`,
       aux.`22_counterparty_nuts`,
       aux.`23_counterparty_zipcode`, --aux.cod_freguesia,
 aux.cp3,
 aux.cpais_residencia,
 aux.`28_dt_maturity`,
 aux.`29_flag_specialised_lending`,
 aux.`30_stage_ifrs9`,
 aux.`33_counterparty_type`,
 aux.`83_dt_reference`,
 aux.`47_client_turnover`,
 aux.`48_group_turnover`,
 aux.`51_client_own_funds`,
 aux.`client_debt`,
 aux.`client_revenue`,
 aux.`53_client_nr_employees`,
 aux.`54_group_nr_employees`,
 aux.`70_flag_audited_financial_sttmnts`,
 aux.`71_dt_financial_statements`,
 aux.`73_client_total_assets`,
 aux.`74_group_total_assets`,
 aux.`75_isin`,
 aux.`93_european_union`,
 aux.`84_dt_origination`,
 from_unixtime(unix_timestamp()) AS htimest,
 --partition
 CAST(NEW_ID_CORRIDA AS STRING) AS ID_CORRIDA, --- Alterar para '1'
 '${ref_date}' AS dt_rfrnc
FROM bu_esg_work.rf_metricas_pilar3_ctr_aux_jun24 AS aux
LEFT JOIN
  (SELECT DISTINCT *
   FROM
     (SELECT zcliente,
             `14_nace`
      FROM
        (SELECT zcliente,
                `14_nace`,
                RANK() OVER (PARTITION BY zcliente
                             ORDER BY gross_carrying_amount) AS rank_number
         FROM
           (SELECT DISTINCT a.zcliente,
                            gr_cli_1.zgrupo,
                            b.`14_nace`,
                            gross_carrying_amount
            FROM
              (SELECT *
               FROM bu_esg_work.rf_metricas_pilar3_ctr_aux_jun24
               WHERE `14_nace` = 'K64.2.0') AS A
            LEFT JOIN
              (SELECT DISTINCT zcliente,
                               zgrupo
               FROM cd_captools.ct070_univ_gr_cli
               WHERE ref_date = "${ref_date}") AS gr_cli_1 ON A.zcliente = gr_cli_1.zcliente
            LEFT JOIN
              (SELECT DISTINCT zcliente,
                               zgrupo
               FROM cd_captools.ct070_univ_gr_cli
               WHERE ref_date = "${ref_date}") AS gr_cli_2 ON gr_cli_1.zgrupo = gr_cli_2.zgrupo
            INNER JOIN
              (SELECT zcliente,
                      `14_nace`,
                      SUM(`13_gross_carrying_amount`) AS gross_carrying_amount
               FROM
                 (SELECT DISTINCT cempresa_fr012,
                                  cbalcao_fr012,
                                  cnumecta_fr012,
                                  zdeposit_fr012,
                                  zcliente,
                                  `14_nace`,
                                  `13_gross_carrying_amount`
                  FROM bu_esg_work.rf_metricas_pilar3_ctr_aux_jun24) A
               INNER JOIN
                 (SELECT *
                  FROM bu_esg_work.rf_pilar3_universo_full
                  WHERE DT_RFRNC = '${ref_date}'
                    AND ID_CORRIDA = '2'
                    AND IDCOMB_SATELITE LIKE '%TYVA01%') B ON CONCAT(A.CEMPRESA_FR012,A.CBALCAO_FR012,A.CNUMECTA_FR012,A.ZDEPOSIT_FR012) = CONCAT(B.CEMPRESA_FR012,B.CBALCAO_FR012,B.CNUMECTA_FR012,B.ZDEPOSIT_FR012)
               GROUP BY 1,
                        2) AS B ON gr_cli_2.zcliente = B.zcliente) AS a
         WHERE `14_nace` NOT IN ('K64.2.0',
                                 '')) AS a
      WHERE rank_number = 1) AS a) AS holding ON aux.zcliente = holding.zcliente
LEFT JOIN
  (SELECT DISTINCT a.zcliente,
                   b.flag_project_finance
   FROM bu_esg_work.rf_metricas_pilar3_ctr_aux_jun24 AS a,

     (SELECT *
      FROM cd_captools.fr004_cto
      WHERE ref_date = "${ref_date}"
        AND flag_project_finance = '1') AS b
   WHERE a.cempresa_fr012 = b.cempresa
     AND a.cbalcao_fr012 = b.cbalcao
     AND a.cnumecta_fr012 = b.cnumecta
     AND a.zdeposit_fr012 = b.zdeposit) AS pf ON aux.zcliente = pf.zcliente
LEFT JOIN
  (SELECT nvl(max(ID_CORRIDA),0)+1 AS NEW_ID_CORRIDA
   FROM bu_esg_work.p3_ctr_cli) ID_COR ON 1=1 ;