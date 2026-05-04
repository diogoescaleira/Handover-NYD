-------------------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | MdD_109                                                      --
-------------------------------------------------------------------------------------------------------------------------------
-- Neyond 2023                                                                                                               --
-------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------
--   R01 Juros & Comissões Financeiras  
-------------------------------------------------------------------------------------------------------------------------------


--validações
SELECT SUM(amount) FROM bu_esg_work.ste_sat109_metricas_r01_final_Jun24;

--Definição de data de reporte
-- O satélite reporta os dados de juos acumulados do ano. Assim, e a título de exemplo, no exercício de dezembro de 2022 foram utilizados as datas: 
-- '2021-12-31' (ref_date),'2021-12-31'(date_inicio) e '2023-01-01' (date_fim). 

ref_date = "${ref_date_inicio}"
ref_date = "${ref_date}"
ref_date = "${ref_date_fim}"

-- Os contratos na contabilidade associados aos IDCOMBS de Interest income (R01) são todos manuais (CMAH), não existindo tradução para os mesmos no tradutor do MIS, o que complica a reconciliação.
--JUN23:  221 935 064.05
--DEZ23: 512 090 963.150000
SELECT sum(saldo_ct)
FROM bu_esg_work.RF_PILAR3_UNIVERSO_FULL
WHERE dt_rfrnc= '${ref_date}'
and csatelite = 109
and idcomb_satelite like '%R01%'
;
-------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- Processo de Apuramento de Juros  ------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
	
-- 1. Criação da tabela Aux_1 com o Processo de Apuramento de Juros:
-- Jun23: 1 560 018 registos (distinct chave MIS: 1.364.674)
-- Dez23: 2 035 456 | 2 006 985
-- drop table if exists bu_esg_work.ste_sat109_univ_juros_aux1_Jun24;

create table bu_esg_work.ste_sat109_univ_juros_aux1_Jun24 as	
SELECT ct209_rent_kpm.*,
       ct001_univ_saldo.*,
       fr802_pl_contas.instrumento_financeiro,
       fr802_pl_contas.carteira_contabilistica 
FROM

	-- 1º Cruzamento: Ct209_Rent_Kpm 
	--> 1.514.874 chaves MIS | € 914 591 359.47 a Jun/2023
	--> 1.876.394 chaves MIS | € 2 023 834 082.9061 a Dez/23
  (SELECT cempcta,
          ckbalcao,
          cknumcta,
          zdeposit AS zdeposit_mis,
          zcliente AS zcliente_mis,
          sum(c298) AS c298 -- Campo que corresponde aos Juros Acumulados 
   FROM cd_captools.ct209_rent_kpm
   WHERE ref_date = "${ref_date}" 
     AND abs(c298) > 0       --  Esta condição exclui da análise 11.336.621 (jun23) contratos que têm o saldo a zero. No local também existe este filtro
   GROUP BY 1,2,3,4,5 ) AS ct209_rent_kpm

INNER JOIN
	
	-- 2º Cruzamento: Kt_Chaves_MIS filtrado por contratos ativos no ano
	--> 1.819.200 registos a Jun/2023  (DISTINCT DE CHAVE MIS 1.514.833 registos | € 917 164 941.21 a Jun/2023 (existem valores positivos e negarivos))
	--> 2.343.756 registos a Dez/23(registos e valores duplicam)
		--> Nota: Existe mais do que um zdeposit para o mesmo zdeposit_mis, por isso, ter em conta na análise do saldo dos Juros Acumulados duplica
		-->Nota2: Existem contratos que não cruzam para o tradutor a soma do montante que não cruza é negativo, daí o valor aumentar
	
  (SELECT DISTINCT cempcta,
                   ckbalcao,
                   cknumcta,
                   zdeposit_mis,
                   cempresa,
                   cbalcao,
                   cnumecta,
                   zdeposit
   FROM cd_captools.kt_chaves_mis
   WHERE ref_date = "${ref_date}") AS kt_chaves_mis 
   ON ct209_rent_kpm.cempcta = kt_chaves_mis.cempcta
AND ct209_rent_kpm.ckbalcao = kt_chaves_mis.ckbalcao
AND ct209_rent_kpm.cknumcta = kt_chaves_mis.cknumcta
AND ct209_rent_kpm.zdeposit_mis = kt_chaves_mis.zdeposit_mis

INNER JOIN

	-- 3º Cruzamento: Obter a última ref date em que cada contrato da CT foi reportado 
	--> 1.768.044 registos a Jun/2023
	
	
  (SELECT cempresa,
          cbalcao,
          cnumecta,
          zdeposit,
          max(ref_date) AS ref_date
   FROM cd_captools.ct001_univ_saldo
   WHERE (ref_date >= "${ref_date_inicio}" AND ref_date < '${ref_date_fim}')  
   GROUP BY 1,2,3,4 ) AS ct001_univ_saldo_max_ref_date 
            ON kt_chaves_mis.cempresa = ct001_univ_saldo_max_ref_date.cempresa
AND kt_chaves_mis.cbalcao = ct001_univ_saldo_max_ref_date.cbalcao
AND kt_chaves_mis.cnumecta = ct001_univ_saldo_max_ref_date.cnumecta
AND kt_chaves_mis.zdeposit = ct001_univ_saldo_max_ref_date.zdeposit

INNER JOIN 

	-- 4º Cruzamento: Obter o último saldo do contrato (CT - valor bruto) para a última ref date da query acima 
	-->  registos | €  a Jun/2023

	
  (SELECT cempresa,
          cbalcao,
          cnumecta,
          zdeposit,
          zcliente,
          ccontab_final_cargabal, -- No local é puxado o campo ccontab_final_st_sgps ao invés deste
          ref_date,
          sociedade_contraparte,
          cod_ajust,
          sum(msaldo_final) AS msaldo_final
   FROM cd_captools.ct001_univ_saldo 
   WHERE flag_ativo = 1 
     AND cempresa IN ('31',
                      '89',
                      '00100') 
     AND ccontab_final_idcomb NOT LIKE '%TYVA02%' -- No local não existe este filtro, no entanto têm este: ccontab_final_st_sgps <> ''
     AND origem <> 'IMPARIDADE' 
   GROUP BY 1,2,3,4,5,6,7,8,9) AS ct001_univ_saldo ON ct001_univ_saldo_max_ref_date.cempresa = ct001_univ_saldo.cempresa
AND ct001_univ_saldo_max_ref_date.cbalcao = ct001_univ_saldo.cbalcao
AND ct001_univ_saldo_max_ref_date.cnumecta = ct001_univ_saldo.cnumecta
AND ct001_univ_saldo_max_ref_date.zdeposit = ct001_univ_saldo.zdeposit
AND ct001_univ_saldo_max_ref_date.ref_date = ct001_univ_saldo.ref_date 

INNER JOIN

	-- 5º Cruzamento: Ct001 filtrada por dimensões contabilisticas  da fr802
	--> 1.364.674 registos | € 772 664 088.10 a Jun/2023

  (SELECT DISTINCT conta,
                   instrumento_financeiro,
                   carteira_contabilistica,
                   ref_date
   FROM cd_captools.fr802_pl_contas
   WHERE detalhe_conta = 'I'
     AND tipo_conta = 'A' -- Ativo
     AND cod_plano = 'CARGABAL' -- Comentário HF: No código do local é filtrado por: cod_plano = 'ST_SGPS_CONS' // idcomb
     AND conta <> ''
     AND bruto_imparidade <> 'imparidade'
     AND instrumento_financeiro IN ('credito concedido e outros ativos financeiros','instrumentos de divida') -- Comentário Local: Lista enviada pela Luísa.

     AND carteira_contabilistica IN ('ativos financeiros mandatoriamente ao justo valor atraves de resultados',
			 'Ativos financeiros mandatoriamente ao justo valor através de resultados',
			 'ativos financeiros ao custo amortizado',
			 'Ativos Financeiros ao custo amortizado',
			 'ativos financeiros ao justo valor atraves de outro rendimento integral',
			 'Ativos financeiros ao justo valor através de outro rendimento integral',
			 'ativos financeiros ao justo valor atraves de resultados') ) as fr802_pl_contas -- Comentário Local: Lista enviada pela Luísa.
ON ct001_univ_saldo.ccontab_final_cargabal = fr802_pl_contas.conta
AND ct001_univ_saldo_max_ref_date.ref_date = fr802_pl_contas.ref_date
;

-------------------------------------------------------
-- Distribuição do peso do Msaldo_Final por contrato -- 
-------------------------------------------------------

-- 1. Criação da tabela Aux_2 com o processo da distribuição do saldo dos juros (MIS) pelos contratos CT 
--> Jun23:1 560 018 registos (distinct chave MIS: 1.364.674)
--> Dez23:2 035 456 | 2 006 985 
-- drop table bu_esg_work.ste_sat109_univ_juros_aux2_Jun24;
create table bu_esg_work.ste_sat109_univ_juros_aux2_Jun24 as
select 
        a.*,
        b.sum_saldo_final_mis,
        case 
            when sum_saldo_final_mis <> 0 then cast(a.msaldo_final as decimal(24,12)) / cast(b.sum_saldo_final_mis as decimal(24,12)) 
            else 1
        end as peso_msaldo_final

from bu_esg_work.ste_sat109_univ_juros_aux1_Jun24 as a 

inner join (
                select cempcta,ckbalcao,cknumcta,zdeposit_mis, sum(sum_saldo_final_ct) as sum_saldo_final_mis
                from (
                        select
						cempcta,ckbalcao,cknumcta,zdeposit_mis, cempresa,cbalcao,cnumecta,zdeposit, 
                        sum(msaldo_final) as sum_saldo_final_ct
                        from bu_esg_work.ste_sat109_univ_juros_aux1_Jun24 group by 1,2,3,4,5,6,7,8  ) as aux1 
                group by 1,2,3,4
            ) as b
on  a.cempcta = b.cempcta 
and a.ckbalcao = b.ckbalcao 
and a.cknumcta = b.cknumcta 
and a.zdeposit_mis = b.zdeposit_mis 

;

-- 2. Criação da tabela Aux_3 com o Cálculo do Saldo dos Juros através da ponderação do peso do valor bruto
--> Jun23:1 560 018 registos (distinct chave MIS: 1.364.674)
--> Dez23:2 035 456 | 2 006 985 
-- drop table bu_esg_work.ste_sat109_univ_juros_aux3_Jun24;
create table bu_esg_work.ste_sat109_univ_juros_aux3_Jun24 as
select *, peso_msaldo_final * c298 as saldo_juros from bu_esg_work.ste_sat109_univ_juros_aux2_Jun24
;

-- 3. Criação da tabela final do Universo de Juros para o satélite, através do filtro de Empresas Não Financeiras (ct003 - cnatureza_juri) 
 --- uma vez que nem todos os contratos existem na ct001 à data de reporte, é necesssário obter a última data em que o zlciente existe na ct003
--> Jun23: 457 709 registos | € 197 172 985.60 (distinct chave MIS: 317.003)
--> Dez23: 723 718 | 705 494 
-- drop table bu_esg_work.ste_sat109_univ_juros_final_Jun24;
create table bu_esg_work.ste_sat109_univ_juros_final_Jun24 as
select a.*,
      c.cnatureza_juri,
      c.nace_code,
      c.cpais_residencia,
      c.contraparte,
      b.ref_date as ref_date_cli
from bu_esg_work.ste_sat109_univ_juros_aux3_Jun24  as a

inner join (select zcliente, max(ref_date) as ref_date
            from cd_captools.ct003_univ_cli 
            where ref_date < '${ref_date_fim}' 
            group by 1) as b 
on a.zcliente = b.zcliente

inner join ( select distinct zcliente,cnatureza_juri, nace_code, cpais_residencia, contraparte,ref_date
                from cd_captools.ct003_univ_cli
                where ref_date < '${ref_date_fim}' 
                and (cnatureza_juri like '131%' or cnatureza_juri like '231%') -- Naturezas jurídicas de Empresas não Financeiras
                ) c
on b.zcliente = c.zcliente
and b.ref_date = c.ref_date
;

-------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- Processo de Apuramento de Comissões  ------------------------------------------
---------------------------------------- processo equivalente ao do apuramento dos juros --------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- 1. Criação da tabela Aux com o Processo de Apuramento de Comissões Financeiras:
--> Jun23: 997 252 registos 
--> Dez23: 1 415 083 | 1 370 717 
-- drop table bu_esg_work.ste_sat109_univ_comis_aux_Jun24;
create table bu_esg_work.ste_sat109_univ_comis_aux_Jun24 as
select a.*, d.*

	-- 1º Cruzamento: Ct211 filtrada por cmetacom assinalados a amarelo 
	--> 772.510 registros | 54 603 107.89€ para Jun/23
	
from (  select cempcta,ckbalcao,cknumcta,zdeposit as zdeposit_mis,
				sum(c457-c458) as saldo_coms -- c457 tem comissões e o c458 não tem comissões --> Comissões acumuladas à semelhança de juros
        from cd_captools.ct211_rent_kpmco
        where ref_date = "${ref_date}"
        and origem = 'MIS'
        and cmetacom in ('EE1000','EE1100','EE1210','EE1220','EE2010','EE2011','EE2020','EE2021','EE2110','EE2120','EE2300',
		'EE5111','EE5112','EE5210','EE5220','EE7100','EE7210','EE7223','EE7224','EE7241','EE7251','EE7253','EE7254','EE7255',
		'EE725A','EE726B','EE726C','EE726X','EE726Y','EE727B','EE727C','EE727E','EE727F','GH1010','GH1020','GH1110','GH1120',
		'GH2221','GH2222','GH2231','GH2232','GH2310','GH2320','GH2410','GH2420','GH2600','GH3010','GH3020','GH3410','GH3420',
		'GH3510','GH3520','GH410A','GH410B','GH411A','GH411B','GH412A','GH412B','GH4210','GH4220','GH5990','JJ3110','JJ3120',
		'JJ3150','TT3200','GH2000','EE1500','EE4000','EE7258') -- Lista enviada pela ana clara (GH2000 e EE4000 estão em financeiras e não financeiras) 
        group by 1,2,3,4
) as a

	-- 2º Cruzamento: Kt mis filtrado por contratos ativos
	--> 753.413 registos | € 50 152 328.90 para Jun/23

inner join (select  distinct cempcta,ckbalcao,cknumcta,zdeposit_mis,cempresa,cbalcao,cnumecta,zdeposit
            from cd_captools.kt_chaves_mis where ref_date = "${ref_date}") as b
on  a.cempcta = b.cempcta
and a.ckbalcao = b.ckbalcao
and a.cknumcta = b.cknumcta
and a.zdeposit_mis = b.zdeposit_mis

	-- 3º Cruzamento: Ct001 filtrada pelo max da ref_date
	--> 729 246 registos| € 48 254 456.42 para Jun/23
	
inner join (select cempresa,cbalcao,cnumecta,zdeposit,max(ref_date) as ref_date
            from cd_captools.ct001_univ_saldo
            where  (ref_date >= "${ref_date_inicio}" AND ref_date < '${ref_date_fim}') 
            group by 1,2,3,4
            ) as c
on b.cempresa = c.cempresa
and b.cbalcao = c.cbalcao
and b.cnumecta = c.cnumecta
and b.zdeposit = c.zdeposit

	-- 4º Cruzamento: Ct001 filtrada por flag_ativo = 1 e valor bruto 
	-->  registos| €  para Jun/23
	
inner join (select cempresa,cbalcao,cnumecta,zdeposit,
                    zcliente,
                    ccontab_final_cargabal, 
                    ref_date, 
                    sociedade_contraparte,
                    cod_ajust,
                    sum(msaldo_final) as msaldo_final
            from cd_captools.ct001_univ_saldo 
            where flag_ativo = 1 
            and cempresa in ('31','89','00100') 
            and ccontab_final_idcomb not like '%TYVA02%' 
            and origem <> 'IMPARIDADE'
            group by 1,2,3,4,5,6,7,8,9) as d 
on c.cempresa = d.cempresa
and c.cbalcao = d.cbalcao
and c.cnumecta = d.cnumecta
and c.zdeposit = d.zdeposit
and c.ref_date = d.ref_date
;

-- 2. Criação da tabela Aux_1 do Universo de comissões onde a Ct001 é filtrada por dimensões contabilisticas da Fr802
--> Jun23: 846 424 registos 
--> Dez23: 1 130 239 | 1 096 014 
-- drop table bu_esg_work.ste_sat109_univ_comis_aux1_Jun24;
create table bu_esg_work.ste_sat109_univ_comis_aux1_Jun24 as
select a.*,b.instrumento_financeiro, b.carteira_contabilistica
from (
select * from bu_esg_work.ste_sat109_univ_comis_aux_Jun24) as a

inner join  (SELECT distinct conta,instrumento_financeiro, carteira_contabilistica,ref_date FROM cd_captools.fr802_pl_contas
                                        where detalhe_conta = 'I'
                                        and tipo_conta = 'A' --Ativo
                                        and cod_plano = 'CARGABAL' 
                                        and conta <> ''
                                        and bruto_imparidade <> 'imparidade' 
                                        and instrumento_financeiro in ('credito concedido e outros ativos financeiros','instrumentos de divida') -- Comentário Local: Lista enviada pela Luísa.
                                        and carteira_contabilistica in (  'ativos financeiros mandatoriamente ao justo valor atraves de resultados',
                                                                                'Ativos financeiros mandatoriamente ao justo valor através de resultados',
                                                                                'ativos financeiros ao custo amortizado',
                                                                                'Ativos Financeiros ao custo amortizado',
                                                                                'ativos financeiros ao justo valor atraves de outro rendimento integral',
                                                                                'Ativos financeiros ao justo valor através de outro rendimento integral',
                                                                                'ativos financeiros ao justo valor atraves de resultados'
                                                                            ) -- Comentário Local: Lista enviada pela Luísa.
            ) b
on a.ccontab_final_cargabal = b.conta 
and a.ref_date = b.ref_date 
;

-------------------------------------------------------
-- Distribuição do peso do Msaldo_Final por contrato -- 
-------------------------------------------------------
-- 1. Criação da tabela Aux_2 com o processo da distribuição do saldo das comissões pelos contratos ct
--> Jun23: 846 424 registos 
--> Dez23: 1 130 239 | 1 096 014 
-- drop table bu_esg_work.ste_sat109_univ_comis_aux2_Jun24;
create table bu_esg_work.ste_sat109_univ_comis_aux2_Jun24 as
select 
        a.*,
        b.sum_saldo_final_mis,
		case 
            when sum_saldo_final_mis <> 0 THEN cast(a.msaldo_final as decimal(24,12)) / cast(b.sum_saldo_final_mis as decimal(24,12)) 
            else 1
        END AS peso_msaldo_final
from bu_esg_work.ste_sat109_univ_comis_aux1_Jun24 as a 

inner join (
                select 
				cempcta,ckbalcao,cknumcta,zdeposit_mis, sum(sum_saldo_final_ct) as sum_saldo_final_mis
                from (
                        select  cempcta,ckbalcao,cknumcta,zdeposit_mis, cempresa,cbalcao,cnumecta,zdeposit, 
                        sum(msaldo_final) as sum_saldo_final_ct
                        from bu_esg_work.ste_sat109_univ_comis_aux1_Jun24 group by 1,2,3,4,5,6,7,8  ) as aux1 
                group by 1,2,3,4
            ) as b
on  a.cempcta = b.cempcta    
and a.ckbalcao = b.ckbalcao  
and a.cknumcta = b.cknumcta  
and a.zdeposit_mis = b.zdeposit_mis 
;

-- 2. Criação da tabela Aux_3 com o Cálculo do Saldo das Comissões
--> Jun23: 846 424 registos 
--> Dez23: 1 130 239 | 1 096 014 
-- drop table bu_esg_work.ste_sat109_univ_comis_aux3_Jun24;
create table bu_esg_work.ste_sat109_univ_comis_aux3_Jun24 as
select *, peso_msaldo_final * saldo_coms as saldo_comissoes from bu_esg_work.ste_sat109_univ_comis_aux2_Jun24
;

-- 3. Criação da tabela final do Universo de Juros, ou seja, por fim é aplicado o filtro nas Empresas Não Financeiras
--> Jun23: 316 289 registos | € 20 835 732.13 (distinct chave MIS: 209.156)
--> Dez23: 526 571 | 500 869 
-- drop table bu_esg_work.ste_sat109_univ_comis_final_Jun24;
create table bu_esg_work.ste_sat109_univ_comis_final_Jun24 as
select a.*,
      c.cnatureza_juri,
      c.nace_code,
      c.cpais_residencia,
      c.contraparte,
      b.ref_date as ref_date_cli 
from bu_esg_work.ste_sat109_univ_comis_aux3_Jun24  as a

--(select zcliente, cnatureza_juri, nace_code, cpais_residencia, ref_date
inner join (select zcliente, max(ref_date) as ref_date
            from cd_captools.ct003_univ_cli 
            where  ref_date < '${ref_date_fim}' 
            group by 1) as b 
on a.zcliente = b.zcliente

inner join ( select distinct zcliente,cnatureza_juri, nace_code, cpais_residencia, contraparte,ref_date
                from cd_captools.ct003_univ_cli
                where  ref_date < '${ref_date_fim}'
                and (cnatureza_juri like '131%' or cnatureza_juri like '231%') 
                ) c				
on b.zcliente = c.zcliente
and b.ref_date = c.ref_date
;

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Agregação dos Universos de Juros e Comissões  ------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- 1. Criação da tabela final do Universo de Juros e Universo de Comissões
--> Nota 1: É efetuada uma flag de juros e comissões para distinguir as métricas
--> Jun23: 769 302 registos | € 218 008 717.74
--> Dez23: 1 238 795 | 1 197 533 (500 277 644.31€)
-- drop table bu_esg_work.ste_sat109_univ_final_Jun24;
create table bu_esg_work.ste_sat109_univ_final_Jun24 as
select 
        sociedade_contraparte,
        cod_ajust,
        cempresa,
        cbalcao,
        cnumecta,
        zdeposit,
        zcliente,
        cnatureza_juri, 
        nace_code, 
        cpais_residencia,
        ccontab_final_cargabal,  
        instrumento_financeiro, 
        carteira_contabilistica,
        'Interest income' as interest_commisions,
        ref_date_cli,
        sum(saldo_juros) as  saldo
        from bu_esg_work.ste_sat109_univ_juros_final_Jun24
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
union all 
select 
        sociedade_contraparte,
        cod_ajust,
        cempresa,
        cbalcao,
        cnumecta,
        zdeposit,
        zcliente,
        cnatureza_juri, 
        nace_code, 
        cpais_residencia,
        ccontab_final_cargabal, 
        instrumento_financeiro, 
        carteira_contabilistica,
        'Fees and commisions income' as interest_commisions,
        ref_date_cli,
        sum(saldo_comissoes) as  saldo
        from bu_esg_work.ste_sat109_univ_comis_final_Jun24
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
;

-------------------------------------------------------------------------------------------------------------------------------
------------------------------------- Construção do Satélite 109 e Respetivos Tratamentos  ------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- 1. Criação da tabela com todas as dimensões a considerar no satélite 
--> Jun23: 769 302  registos | € 218 008 717.74
--> Dez23: 1 238 795 | 1 197 533 
DROP TABLE bu_esg_work.ste_sat109_metricas_r01_Jun24;
CREATE TABLE bu_esg_work.ste_sat109_metricas_r01_Jun24 AS
SELECT a.*,
       'CONT1' AS continuing_operations, 
       'R01' AS base,
       CASE
           WHEN instrumento_financeiro = 'credito concedido e outros ativos financeiros' THEN 'MC02'
           WHEN instrumento_financeiro = 'instrumentos de divida' THEN 'MC04'
       END AS main_category,
       CASE
           WHEN (carteira_contabilistica = 'ativos financeiros mandatoriamente ao justo valor atraves de resultados'
                 OR carteira_contabilistica = 'Ativos financeiros mandatoriamente ao justo valor através de resultados') THEN 'ACPF3'
           WHEN (carteira_contabilistica = 'ativos financeiros ao justo valor atraves de resultados') THEN 'ACPF4'
           WHEN (carteira_contabilistica = 'ativos financeiros ao justo valor atraves de outro rendimento integral'
                 OR carteira_contabilistica = 'Ativos financeiros ao justo valor através de outro rendimento integral') THEN 'ACPF5'
           WHEN (carteira_contabilistica = 'ativos financeiros ao custo amortizado'
                 OR carteira_contabilistica = 'Ativos Financeiros ao custo amortizado') THEN 'ACPF6'
       END AS accounting_portfolio,
       'SC0303' AS sector,
       CASE
           WHEN interest_commisions = 'Interest income' THEN 'INC1'
           WHEN interest_commisions = 'Fees and commisions income' THEN 'INC2'
           ELSE ''
       END AS int_commis,

	   case		
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (620) then 'GEO3'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (724) then 'GEO1'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (826) then 'GEO2'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (840) then 'GEO4'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (616) then 'GEO5'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (276) then 'GEO6'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (250) then 'GEO7'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (578) then 'GEO8'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (484) then 'GEO9'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (152) then 'GEO10'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (076) then 'GEO11'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (032) then 'GEO12'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (604) then 'GEO13'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (170) then 'GEO14'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (858) then 'GEO15'
			-- Geografias que existiam à data: ver alterações em exercicios futuros
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (600,068,218,862,238,531) then 'GEO16' --Rest of Latam 
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (044,060,092,124,136,192,214,222,312,320,533,591,630,666,780) then 'GEO17' --Rest of North America
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (020,040,056,100,191,196,203,208,246,292,300,336,348,352,372,380,428,438,440,442,470,492,498,528,642,643,674,688,703,705,752,756,792,804,807,831,832,833) then 'GEO18' --Rest of Europe
            when B.idcomb_satelite IS NULL then 'GEO19' --Rest of World
            else 'GEO3'
        end as geo,
		
	   	case 
			when cpais_residencia in ('276','040','056','100','203','196','191','208','703','705','724','233','246','250','300','348','372','380','428','440','442','470','528','616','620','642','752') then 'EU1'
			else 'EU2'
        end as european_union, 
	   
	   -- não é necessário utilizar o tipo de contraparte uma vez que o universo é só empresas não financeiras
	   case
            when substr(nc.nace_code,1,1) = 'A' then 'CNAEL1'
            when substr(nc.nace_code,1,1) = 'B' then 'CNAEL2'
            when substr(nc.nace_code,1,1) = 'C' then 'CNAEL3'
            when substr(nc.nace_code,1,1) = 'D' then 'CNAEL4'
            when substr(nc.nace_code,1,1) = 'E' then 'CNAEL5'
            when substr(nc.nace_code,1,1) = 'F' then 'CNAEL6'
            when substr(nc.nace_code,1,1) = 'G' then 'CNAEL7'
            when substr(nc.nace_code,1,1) = 'H' then 'CNAEL8'
            when substr(nc.nace_code,1,1) = 'I' then 'CNAEL9'
            when substr(nc.nace_code,1,1) = 'J' then 'CNAEL10'
            when substr(nc.nace_code,1,1) = 'L' then 'CNAEL11'
            when substr(nc.nace_code,1,1) = 'M' then 'CNAEL12'
            when substr(nc.nace_code,1,1) = 'N' then 'CNAEL13'
            when substr(nc.nace_code,1,1) = 'O' then 'CNAEL14'
            when substr(nc.nace_code,1,1) = 'P' then 'CNAEL15'
            when substr(nc.nace_code,1,1) = 'Q' then 'CNAEL16'
            when substr(nc.nace_code,1,1) = 'R' then 'CNAEL17'
            when substr(nc.nace_code,1,1) = 'S' then 'CNAEL18'
            else 'CNAEL18'		
        end as CNAEL,
		
    --
	    case
            when nace_esg.nace_level4 is not null then nace_esg.ID
            else 'NACE19010303' --Nace default disponibilizado pela corporação
        end as nace_code_esg 	
	
FROM bu_esg_work.ste_sat109_univ_final_Jun24 AS a

	-- 2º Cruzamento: Tabela Universo Full do satelite 80 para obter todos os contratos com colaterais
	--> 769302 registos| € 218 008 717.74 

LEFT JOIN	
	(select distinct idcomb_satelite,
					 cempresa_ct,
					 cbalcao_ct,
					 cnumecta_ct,
					 zdeposit_ct 
	from bu_esg_work.RF_PILAR3_UNIVERSO_FULL where csatelite = 80 and DT_RFRNC = '${ref_date}') B 
ON a.cempresa= b.cempresa_ct
and a.cbalcao = b.cbalcao_ct
and a.cnumecta = b.cnumecta_ct
and a.zdeposit = b.zdeposit_ct 

   -- 3º Cruzamento: Tabela métricas contratos cliente para obter o nace 

LEFT JOIN  
	(
	 SELECT base.zcliente,
		   CASE WHEN `15_nace_esg` IS NOT NULL THEN `15_nace_esg`
              ELSE nace_code
		   END AS nace_code
	 FROM
	 
	(SELECT distinct zcliente, nace_code 
	 FROM bu_esg_work.ste_sat109_univ_final_Jun24) base
	
	LEFT JOIN
	(SELECT DISTINCT zcliente,
                       `15_nace_esg`
        FROM bu_esg_work.p3_ctr_cli
        WHERE ref_date ="${ref_date}") ctr_cli
	   ON base.zcliente = ctr_cli.zcliente
	)nc
ON a.zcliente = nc.zcliente

	-- 4º Cruzamento: Tabela NACE para o cálculo da métrixa NACE_CODE_ESG
	--> 769302 registos| € 218 008 717.74 

LEFT JOIN 
	(SELECT * FROM bu_esg_work.nace_esg_pillar3) as nace_esg		--Criar tabela de excel a importar com base na nova marcação do excel caso mudem os NACE que a corporação envia
on concat(split_part(nc.nace_code,".",1),split_part(nc.nace_code,".",2),split_part(nc.nace_code,".",3)) = trim(split_part(nace_esg.nace_level4, "-",1))	

;

-- 2. CRIAÇÃO DA TABELA FINAL DO SATÉLITE 109 (Formato satélite para extração)
--> Jun23: 1221 registos | € -218 008 715
--> Dez23: 1507          | € -500 277 664
-- drop table bu_esg_work.ste_sat109_metricas_r01_final_Jun24;
create table bu_esg_work.ste_sat109_metricas_r01_final_Jun24 as
select 

    '00411' as reporting_soc, 
    case 
        when sociedade_contraparte = '' then  '00000'
        else sociedade_contraparte
    end as counterparty_soc, 
    case 
        when cod_ajust = '' then  'BI00411'
        else cod_ajust
    end as adjustment_code, 
    concat(continuing_operations,';',base,';',main_category,';',accounting_portfolio,';',sector,';',int_commis) as id_comb, 
    round(- sum(saldo)) as amount, 
    european_union,
    geo, 
    CNAEL, 
    nace_code_esg as nace 
from bu_esg_work.ste_sat109_metricas_r01_Jun24 as a
group by 1,2,3,4,6,7,8,9
;



------------------------------------- 
--1) CONTRATOS mis QUE NÃO CRUZAM PARA O TRADUTOR
select * from 

  (SELECT cempcta,
          ckbalcao,
          cknumcta,
          zdeposit AS zdeposit_mis,
          zcliente AS zcliente_mis,
          sum(c298) AS c298 -- Campo que corresponde aos Juros Acumulados 
   FROM cd_captools.ct209_rent_kpm
   WHERE ref_date = "${ref_date}" 
   --and ckmetamis like 'A%' -- Comentário HF: Este filtro estava comentando, é suposto? No local não consta este filtro.
     AND abs(c298) > 0       -- Comentário HF: Esta condição exclui da análise 11.336.621 contratos que têm o saldo a zero. No local também têm este filtro
   GROUP BY 1,2,3,4,5 ) AS ct209_rent_kpm
left join 
(SELECT DISTINCT cempcta,
                   ckbalcao,
                   cknumcta,
                   zdeposit_mis,
                   cempresa,
                   cbalcao,
                   cnumecta,
                   zdeposit
   FROM cd_captools.kt_chaves_mis
   WHERE ref_date = "${ref_date}") AS kt_chaves_mis 
   ON ct209_rent_kpm.cempcta = kt_chaves_mis.cempcta
AND ct209_rent_kpm.ckbalcao = kt_chaves_mis.ckbalcao
AND ct209_rent_kpm.cknumcta = kt_chaves_mis.cknumcta
AND ct209_rent_kpm.zdeposit_mis = kt_chaves_mis.zdeposit_mis

where kt_chaves_mis.cempcta is null;


--2) CONTRATOS DO UNIVESO DO 109 COM IDCOMB SC0302 OU SC0304 (SÓ DEVE TER SC0303)
SELECT *
FROM bu_esg_work.rf_pilar3_universo_full
WHERE dt_rfrnc = '2023-06-30'
  AND csatelite = 79
  AND concat(cempresa_ct, cbalcao_ct, cnumecta_ct, zdeposit_ct) IN (
  SELECT concat(cempresa, cbalcao, cnumecta, zdeposit)
  FROM bu_esg_work.ste_sat109_univ_final_hf_jun23)
  and (idcomb_satelite like '%SC0302%' or idcomb_satelite like '%SC0304%' or idcomb_satelite like '%SC0301%')


--3) COMPARAR METRICAS DE CONTRATOS ENTRE 109 E 79

SELECT 
--concat(cempresa, cbalcao, cnumecta, zdeposit) as chave_ct, 
sum(if(sat109.nace_code_esg =sat79.nace_esg,0,1)) as nace_dif,
sum(if(sat109.geo           =sat79.geo,0,1)) as geo_dif,
sum(if(sat109.european_union=sat79.european_union,0,1)) as eu_dif,
sum(if(sat109.cnael         =sat79.cnael,0,1)) as cnael_dif

FROM
  (SELECT DISTINCT cempresa,
                   cbalcao,
                   cnumecta,
                   zdeposit,
                   nace_code_esg,	
                   geo,
                   european_union,
                   cnael
   FROM bu_esg_work.ste_sat109_metricas_v3_hf_jun23) sat109
INNER JOIN
  (SELECT DISTINCT cempresa_ct,
                   cbalcao_ct,
                   cnumecta_ct,
                   zdeposit_ct,
                   nace_esg,
                   geo,
                   european_union,
                   cnael
   FROM bu_esg_work.rf_sat79_piloto_aux4) sat79 
   
   ON concat(cempresa, cbalcao, cnumecta, zdeposit) = concat(cempresa_ct, cbalcao_ct, cnumecta_ct, zdeposit_ct)
 
 
 
 
 --COMPARAÇÃO ENTRE DEZ22 E DEZ23:
SELECT AMOUNT_SAT_22,
       AMOUNT_22_IDCOMB,
       (AMOUNT_SAT_22-AMOUNT_22_IDCOMB) AS DIFF_22,
       AMOUNT_SAT_23,
       AMOUNT_23_IDCOMB,
       (AMOUNT_SAT_23-AMOUNT_23_IDCOMB) AS DIFF_23
FROM
  (SELECT sum(amount)AS AMOUNT_SAT_22
   FROM bu_captools_work.ste_sat109_metricas_final)A
LEFT JOIN
  (SELECT count(*),-sum(msaldo_final) AS AMOUNT_22_IDCOMB
   FROM cd_captools.ct001_univ_saldo
   WHERE ref_date = '2022-12-31'
     AND cempresa IN ('31',
                      '89',
                      '00100')
     AND (ccontab_final_idcomb LIKE '%HFS2%R01%MC02%SC0303%'
          OR ccontab_final_idcomb LIKE '%HFS2%R01%MC04%SC0303%')
     AND (ccontab_final_idcomb LIKE '%ACPF3%'
          OR ccontab_final_idcomb LIKE '%ACPF4%'
          OR ccontab_final_idcomb LIKE '%ACPF5%'
          OR ccontab_final_idcomb LIKE '%ACPF6%'))B 
ON 1=1
LEFT JOIN
  (SELECT sum(amount) AS AMOUNT_SAT_23
   FROM bu_esg_work.ste_sat109_metricas_final_Jun24) C 
ON 1=1
LEFT JOIN
  (SELECT count(*),-sum(msaldo_final) AS AMOUNT_23_IDCOMB
   FROM cd_captools.ct001_univ_saldo
   WHERE ref_date = '2023-12-31'
     AND cempresa IN ('31',
                      '89',
                      '00100')
     AND (ccontab_final_idcomb LIKE '%HFS2%R01%MC02%SC0303%'
          OR ccontab_final_idcomb LIKE '%HFS2%R01%MC04%SC0303%')
     AND (ccontab_final_idcomb LIKE '%ACPF3%'
          OR ccontab_final_idcomb LIKE '%ACPF4%'
          OR ccontab_final_idcomb LIKE '%ACPF5%'
          OR ccontab_final_idcomb LIKE '%ACPF6%')) D 
ON 1=1
 ;
 
-------------------------------------------------------------------------------------------------------------------------------
--   R04 Comissões Não Financeiras    
-------------------------------------------------------------------------------------------------------------------------------


--validações

--1) Tabelas MIS: 549 023 139.5300
--2) AUX1: 529 924 845.5300
--3) AUX2: 529 924 845.5300
--4) fINAL-529 924 900
SELECT sum(AMOUNT), count(*) FROM bu_esg_work.ste_sat109_metricas_r04_final_Jun24 ;

	--Definição de data de reporte
	
ref_date = "${ref_date}"
ref_date_fim = '${ref_date_fim}'

-------------------------------------------------------------------------------------------------------------------------------
------------------ Definição do Universo de comissões não financeiras provenientes da tabela ct211 do mis ---------------------
-------------------------------------------------------------------------------------------------------------------------------

-- 1. Criação da tabela Aux_1 
-- Dez23: 1 417 172  | -500 277 664€
 -- Dez23_1: 15 778 370    | 529 924 845.5300
-- drop table bu_esg_work.ste_sat109_univ_r04_aux1_Jun24;
create table bu_esg_work.ste_sat109_univ_r04_aux1_Jun24 as
select 
         a.*,
        c.cnatureza_juri, 
        c.nace_code, 
        c.cpais_residencia, 
        case 
            when (c.cnatureza_juri  like '131%' or c.cnatureza_juri like '231%')
            and contraparte in ('outras empresas nao financeiras', '') then 'outras empresas nao financeiras'
            else 'outros setores'
        end as contraparte,
        b.ref_date as ref_date_cli
	
		
	-- 1º Cruzamento: ct211_rent_kpmco 
	--> Após o cruzamento: 16.076.094 registos (que corresponde a distintos 6.862.710 contratos) | € 589 607 721.92
	
from (
        select * --cempcta,ckbalcao,cknumcta,zdeposit as zdeposit_mis, zcliente,cmetacom, sum(c457-c458) as saldo_comis
        from cd_captools.ct211_rent_kpmco
        where ref_date = "${ref_date}"
        and cempcta = '31' --Comentário HF: No local é filtrado pelos ('31', '80')
        and origem = 'MIS'
        and TRIM(cmetacom) in ('AA1000','AA1100','AA1150','AA1190','AA1300','AA1410','AA1420','AA1431','AA1432','AA1433','AA1480','AA1490','AA2000','AA2100',
					     'AA2200','AA2290','AA2300','AA3000','AA3001','AA3002','AA310','AA3101','CC1010','CC1019','CC1020','CC1021','CC1022','CC1111',
						 'CC1200','CC1201','CC1210','CC1212','CC1220','CC1310','CC1311','CC1312','CC1320','CC1330','CC1351','CC1361','CC1362','CC1410',
						 'CC1420','CC1430','CC1440','CC1510','CC1520','CC1525','CC1540','CC1546','CC1547','CC155A','CC155B','CC1560','CC1565','CC1568',
						 'CC1570','CC1580','CC1600','CC1700','CC1800','CC1810','CC1950','CC2000','CC2200','CC2300','CC3000','CC3001','CC3002','CC3003',
						 'CC3051','CC3052','CC3053','CC3071','CC3072','CC3073','CC3100','CCC000','CCC001','EE200C','EE200D','EE200E','EE2190','EE2200',
						 'EE2201','EE3000','EE3090','EE5120','EE5130','EE6110','EE6120','EE6200','EE7221','EE7222','EE7231','EE7232','EE7242','EE7243',
						 'EE7252','EE7256','EE7261','EE7262','EE7265','EE7266','EE7267','EE7268','EE726D','EE726G','EE726H','EE726I','EE7272','EE72AA',
						 'EE72AB','EE72AC','EE72AD','EE72B3','EE72B4','EE72ZA','EE72ZB','EE72ZC','EE72ZD','EE72ZE','EE8000','GH1200','GH2210','GH2500',
						 'GH2650','GH3100','GH3200','GH3300','GH3610','GH3620','GH3900','GH4001','GH4002','GH5000','GH5100','GH5996','GH5997','JJ1000',
						 'JJ1100','JJ2000','JJ2100','JJ3000','JJ4000','JJ4100','JJ4200','JJ5000','JJ500B','JJ5100','JJ6000','JJ7000','JJ8000','MM1000',
						 'MM1050','MM1100','MM1200','MM1310','MM1320','MM1350','MM1403','MM1404','MM1405','MM1411','MM1412','MM1415','MM1416','MM1431',
						 'MM1432','MM1440','MM1510','MM1520','MM1525','MM1526','MM1530','MM1531','MM1532','MM1533','MM1534','MM1536','MM1537','MM1538',
						 'MM2000','MM2111','MM2112','MM2120','MM2130','MM3010','MM3021','MM3022','MM3023','MM3032','MM3033','MM3034','MM3037','MM3038',
						 'MM3100','MM4000','MM5201','MM5209','MM6000','MM7000','MM7110','MM7120','MM7131','MM7132','MM7200','MM7300','MM7301','MM7500',
						 'MM7710','MM7720','MM7800','MM7850','MM7950','MM7961','MM7962','MM7963','MM7964','PP1000','PP2000','PP3000','PP4000','QQ0110',
						 'QQ0120','QQ1000','SS0100','SS0111','SS0112','SS0121','SS0122','SS1000','SS1002','SS1003','SS1005','SS2100','SS2101','SS2102',
						 'SS2210','SS2220','SS2231','SS2232','SS2241','SS2242','SS2243','SS2250','SS2300','SS2301','SS2400','SS2510','SS2520','SS2530',
						 'SS2540','SS2550','SS2555','SS2560','SS2570','SS2580','SS2590','SS2591','SS2600','SS2700','SS280A','SS280B','SS280C','SS280D',
						 'SS2810','SS2910','SS2911','SS2930','SS2950','SS2951','SS2999','SX1100','SX1200','TT1100','TT2000','TT2100','TT3100','TT4000',
						 'TT4100','TT4210','TT5000','TT5100','TT5110','TT5200','UMC000','UMCGI0','UMCGP0','UMCGR0','EE7257','EE7259','AA1434','AA1435',
						 'AA3100','GH2000','EE4000','EE1500')
        --RETIRAR 'CC3072'
         group by 1,2,3,4,5,6
     ) as a


inner join (select zcliente, max(ref_date) as ref_date
            from cd_captools.ct003_univ_cli 
            where ref_date < '${ref_date_fim}' 
            group by 1) as b 
on a.zcliente = b.zcliente

inner join ( select distinct zcliente,cnatureza_juri, nace_code, cpais_residencia, contraparte,ref_date
                from cd_captools.ct003_univ_cli
                where  ref_date <  '${ref_date_fim}'
                ) c
on b.zcliente = c.zcliente
and b.ref_date = c.ref_date

;


-------------------------------------------------------------------------------------------------------------------------------
-------------------------------- Construção do Satélite 109 e Respetivos Tratamentos (Parte 2) --------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- 1. Criação da tabela com todas as dimensões a considerar no satélite 
--DEZ23: 15 778 370 
-- drop table bu_esg_work.ste_sat109_metricas_r04_Jun24; 
create table bu_esg_work.ste_sat109_metricas_r04_Jun24 as
select DISTINCT a.*,
		'CONT1' as continuing_operations,
		'R04' as base,
		case when cmetacom in ('AA3000','AA3001','AA2290') then 'MC54' 
             when cmetacom in ('AA3002','MM1440','EE2200','EE2201') then 'MC42'
	         when cmetacom in ('MM2000','MM4000','MM7300','MM7301','MM7500','JJ7000','EE3000') then 'MC54'
             when cmetacom in('PP1000','MM1000','MM1050','MM1537') then 'MC45'
             when cmetacom = 'PP2000' then 'MC53'
	         when cmetacom in ('JJ5100','EE6120','EE6200') then 'MC41' 
	         when cmetacom in ('JJ4000','JJ4100','JJ4200') then 'MC43' 
	         when (cmetacom like 'MM1%' ) then  'MC53'
	         when (cmetacom like 'QQ%' or cmetacom like 'SS%' or cmetacom like 'SX%') then  'MC45'
	         when (cmetacom like 'MM%' ) then  'MC52'
	         when cmetacom like 'AA%' then 'MC52'
             when cmetacom like 'CC%' then 'MC52'
             when cmetacom like 'GH%' then 'MC54'
	         when cmetacom like 'JJ%' then 'MC52'
	         when cmetacom like 'EE%' then 'MC52'
	         when cmetacom like 'TT%' then 'MC52'
end as main_category,

		case 
			when A.contraparte = 'outras empresas nao financeiras' then 'COSE1'
			else 'COSE2'
		end as comission_sector,
	   case		
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (620) then 'GEO3'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (724) then 'GEO1'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (826) then 'GEO2'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (840) then 'GEO4'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (616) then 'GEO5'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (276) then 'GEO6'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (250) then 'GEO7'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (578) then 'GEO8'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (484) then 'GEO9'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (152) then 'GEO10'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (076) then 'GEO11'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (032) then 'GEO12'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (604) then 'GEO13'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (170) then 'GEO14'
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (858) then 'GEO15'
			-- Geografias que existiam à data: ver alterações em exercicios futuros
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (600,068,218,862,238,531) then 'GEO16' --Rest of Latam 
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (044,060,092,124,136,192,214,222,312,320,533,591,630,666,780) then 'GEO17' --Rest of North America
            when B.idcomb_satelite IS NULL and cast(a.cpais_residencia as int) in (020,040,056,100,191,196,203,208,246,292,300,336,348,352,372,380,428,438,440,442,470,492,498,528,642,643,674,688,703,705,752,756,792,804,807,831,832,833) then 'GEO18' --Rest of Europe
            when B.idcomb_satelite IS NULL then 'GEO19' --Rest of World
            else 'GEO3'
        end as geo,
		
	   case 
			when cpais_residencia in ('276','040','056','100','203','196','191','208','703','705','724','233','246','250','300','348','372','380','428','440','442','470','528','616','620','642','752') then 'EU1'
			else 'EU2'
        end as european_union, 
	   
	   case
            when substr(nc.nace_code,1,1) = 'A' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL1'
            when substr(nc.nace_code,1,1) = 'D' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL4'
            when substr(nc.nace_code,1,1) = 'C' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL3'
            when substr(nc.nace_code,1,1) = 'E' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL5'
            when substr(nc.nace_code,1,1) = 'F' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL6'
            when substr(nc.nace_code,1,1) = 'G' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL7'
            when substr(nc.nace_code,1,1) = 'B' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL2'
            when substr(nc.nace_code,1,1) = 'H' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL8'
            when substr(nc.nace_code,1,1) = 'I' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL9'
            when substr(nc.nace_code,1,1) = 'J' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL10'
            when substr(nc.nace_code,1,1) = 'L' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL11'
            when substr(nc.nace_code,1,1) = 'M' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL12'
            when substr(nc.nace_code,1,1) = 'N' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL13'
            when substr(nc.nace_code,1,1) = 'O' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL14'
            when substr(nc.nace_code,1,1) = 'P' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL15'
            when substr(nc.nace_code,1,1) = 'Q' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL16'
            when substr(nc.nace_code,1,1) = 'R' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL17'
            when substr(nc.nace_code,1,1) = 'S' and trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL18'
            when trim(a.contraparte) = 'outras empresas nao financeiras' then 'CNAEL18'
			when trim(a.contraparte) = '' and idcomb_satelite like '%SC0303%' then 'CNAEL18'		--Adicionada nova linha de código. Validado com Luísa
            else ''
        end as CNAEL,
	   
	       case
            when nace_esg.nace_level4 is not null then nace_esg.ID
            else 'NACE19010303' --Nace default disponibilizado pela corporação
        end as nace_code_esg
		


	
from bu_esg_work.ste_sat109_univ_r04_aux1_Jun24 as a





LEFT JOIN

(SELECT DISTINCT cempcta,
                   ckbalcao,
                   cknumcta,
                   zdeposit_mis,
                   cempresa,
                   cbalcao,
                   cnumecta,
                   zdeposit
   FROM cd_captools.kt_chaves_mis
   WHERE ref_date = "${ref_date}") AS kt_chaves_mis 
 ON a.cempcta = kt_chaves_mis.cempcta
AND a.ckbalcao = kt_chaves_mis.ckbalcao
AND a.cknumcta = kt_chaves_mis.cknumcta
AND a.zdeposit_mis = kt_chaves_mis.zdeposit_mis



LEFT JOIN

	(select * from bu_esg_work.RF_PILAR3_UNIVERSO_FULL where csatelite = 80 and DT_RFRNC = '${ref_date}') B 
ON kt_chaves_mis.cempresa= b.cempresa_ct
and kt_chaves_mis.cbalcao = b.cbalcao_ct
and kt_chaves_mis.cnumecta = b.cnumecta_ct
and kt_chaves_mis.zdeposit = b.zdeposit_ct 


LEFT JOIN  
	(
	 SELECT base.zcliente,
		   CASE WHEN `15_nace_esg` IS NOT NULL THEN `15_nace_esg`
              ELSE nace_code
		   END AS nace_code
	 FROM
	 
	(SELECT distinct zcliente, nace_code 
	 FROM bu_esg_work.ste_sat109_univ_r04_aux4_Jun24) base
	
	LEFT JOIN
	(SELECT DISTINCT zcliente,
                       `15_nace_esg`
        FROM bu_esg_work.p3_ctr_cli
        WHERE ref_date ="${ref_date}") ctr_cli
	   ON base.zcliente = ctr_cli.zcliente
	)nc
ON a.zcliente = nc.zcliente


LEFT JOIN 
	(SELECT * FROM bu_esg_work.nace_esg_pillar3) as nace_esg		--Criar tabela de excel a importar com base na nova marcação do excel caso mudem os NACE que a corporação envia
on concat(split_part(nc.nace_code,".",1),split_part(nc.nace_code,".",2),split_part(nc.nace_code,".",3)) = trim(split_part(nace_esg.nace_level4, "-",1))	
;

-- 2. CRIAÇÃO DA TABELA FINAL DO SATÉLITE 109 (Formato satélite para extração)
--Dez23: 5341
 
-- drop table bu_esg_work.ste_sat109_metricas_r04_final_Jun24;
create table bu_esg_work.ste_sat109_metricas_r04_final_Jun24 as
select 
    '00411' as reporting_soc,
    '00000'as counterparty_soc,
    'BI00411' as adjustment_code,
    case 
        when contraparte = 'outras empresas nao financeiras' then concat(continuing_operations,';',base,';',main_category,';',comission_sector) 
        else concat(continuing_operations,';',base,';',main_category,';',comission_sector)
    end as id_comb,
    round(- sum(saldo_comis)) as amount,
    european_union,
    geo,
    CNAEL,
    nace_code_esg as nace 
from bu_esg_work.ste_sat109_metricas_r04_Jun24 as a
where cmetacom <> 'CC3072'
group by 1,2,3,4,6,7,8,9

;

-------------------------------------------------------------------------------------------------------------------------------
--TABELA FINAL SATELITE 109 (R01 E R04)  
-------------------------------------------------------------------------------------------------------------------------------



-- drop table if exists bu_esg_work.ste_sat109_metricas_final_Jun24; 
create table bu_esg_work.ste_sat109_metricas_final_Jun24 as 
select *
from bu_esg_work.ste_sat109_metricas_r04_final_Jun24  -- comissões não financeiras
union all 
select * 
from bu_esg_work.ste_sat109_metricas_r01_final_Jun24 -- comissões financeiras 
;



insert overwrite table  bu_esg_work.RT_PILAR3_SATELITE109_Jun24 partition (DT_RFRNC,PROC_ID)

select 
reporting_soc,
counterparty_soc,
adjustment_code,
id_comb,
amount,
european_union,
geo,
cnael,
nace,
strleft(cast(current_timestamp() as STRING), 10) as PROC_DATE,
'${ref_date}' as DT_RFRNC,
cast(RT.NEW_PROC_ID  as int) PROC_ID
from  bu_esg_work.ste_sat109_metricas_final_Jun24

left join
(Select nvl(max(PROC_ID),0)+1 as NEW_PROC_ID from bu_esg_work.RT_PILAR3_SATELITE109) RT
on 1=1
;


-------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- Testes  -----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------



SELECT count(*),
       sum(msaldo_final) -- select *

FROM cd_captools.ct001_univ_saldo
WHERE ref_date = '2023-12-31'
  AND cempresa IN ('31',
                   '89',
                   '00100')
  AND (ccontab_final_idcomb LIKE '%CONT1%R04%')
  AND (ccontab_final_idcomb LIKE '%MC41%'
       OR ccontab_final_idcomb LIKE '%MC42%'
       OR ccontab_final_idcomb LIKE '%MC43%'
       OR ccontab_final_idcomb LIKE '%MC45%'
       OR ccontab_final_idcomb LIKE '%MC52%'
       OR ccontab_final_idcomb LIKE '%MC53%'
       OR ccontab_final_idcomb LIKE '%MC54%' ) --523 954 025.140000;
       
       ;
       SELECT SUM(AMOUNT) FROM bu_esg_work.ste_sat109_metricas_r04_Jun24 WHERE CMETACOM = 'CC3072'
       
       
;

 

