
---------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | Código para geração do satélite 80 (ENPC)
---------------------------------------------------------------------------------------------------------------------
-- Desenvolvedor: Neyond
---------------------------------------------------------------------------------------------------------------------

-- 393 205 
-- 25.406.239.798 --> Nova corrida Dez23 
-- loans and advances
drop table bu_esg_work.rf_pilar3_tabaux_sat80_dez23;
create table bu_esg_work.rf_pilar3_tabaux_sat80_dez23 as
select distinct
        '00411' as reporting_soc,
        a.*,
        b.`13_gross_carrying_amount`,
        b.`32_type_collateral`,
        b.`16_percent_collateral`,
        b.ckbalbem,	
        b.ckctabem,
        b.ckrefbem,	
        b.`4_collateral_nuts`,
        b.`19_type_of_asset`,
        b.flag_colateral,
        b.clase_energetica,	
        b.fiabilidad,
        b.consumos,
        case
            
            when trim(b.clase_energetica) like 'A%' then 'EPCL1'
            when trim(b.clase_energetica) like 'B%' then 'EPCL2'
            when trim(b.clase_energetica) like 'C%' then 'EPCL3'
            when trim(b.clase_energetica) like 'D%' then 'EPCL4'
            when trim(b.clase_energetica) like 'E%' then 'EPCL5'
            when trim(b.clase_energetica) like 'F%' then 'EPCL6'
            when trim(b.clase_energetica) like 'G%' then 'EPCL7'
            else 'EPCL8'
        end as epc_label, 
        case
            when b.fiabilidad in ('', '1-REAL','SANTANDER') then 'EPCD1'
            when trim(b.fiabilidad) in ('2-MUY ALTA', '3-ALTA', '4-MEDIA', '5-MEDIA BAJA', '6-BAJA') then 'EPCD2'
            else 'EPCD3'
        end as epc_label_data,
        case 
            when b.consumos <= 100 then 'EPSC1'
            when b.consumos <= 200 then 'EPSC2'
            when b.consumos <= 300 then 'EPSC3'
            when b.consumos <= 400 then 'EPSC4'
            when b.consumos <= 500 then 'EPSC5'
            when b.consumos >  500 then 'EPSC6'
            else 'EPSC7'
        end as ep_score,
        'EPSD2' as ep_score_data,
        'EU1' as EU 
        
from (  select distinct 
            sociedade_contraparte, 
            cod_ajust, 
            idcomb_satelite, 
            cempresa_ct, 
            cbalcao_ct,
            cnumecta_ct,
            zdeposit_ct
		from bu_esg_work.RF_PILAR3_UNIVERSO_FULL where csatelite = 80 and idcomb_satelite not like '%MC10%' and DT_RFRNC = '${ref_date}' and ID_CORRIDA = '2') as a 
		

left join  
(
	SELECT DISTINCT 
	    GAR.cempresa_ct,
	    GAR.cbalcao_ct,
	    GAR.cnumecta_ct,
	    GAR.zdeposit_ct,
	    GAR.`13_gross_carrying_amount`,
	    GAR.`32_type_collateral`,
	    GAR.`16_percent_collateral`,
	    GAR.ckbalbem,	
	    GAR.ckctabem,
	    GAR.ckrefbem,	
	    GAR.`4_collateral_nuts`,
	    GAR.`19_type_of_asset`,
	    GAR.flag_colateral,
	    CERT_ENERG.clase_energetica,	
	    CERT_ENERG.fiabilidad,
	    CERT_ENERG.consumos
	FROM
	(
	    SELECT * 
	    FROM bu_esg_work.reparticao_garantias_final_dez23
	) GAR
	LEFT JOIN
	(
	    SELECT *
	    FROM bu_esg_work.gloval_clase_energetica_dez23
	) CERT_ENERG
	ON CONCAT(GAR.ckbalbem,GAR.ckctabem,GAR.ckrefbem) = chave_banco_atual
) as b
on  a.zdeposit_ct = b.zdeposit_ct
and a.cbalcao_ct  = b.cbalcao_ct
and a.cnumecta_ct = b.cnumecta_ct
and a.zdeposit_ct = b.zdeposit_ct

;
-- 162
-- tabela final
drop table bu_esg_work.rf_pilar3_satelite80_dez23;
create table bu_esg_work.rf_pilar3_satelite80_dez23 as
select 
    reporting_soc,
    case 
        when sociedade_contraparte = '' then '00000'
        else sociedade_contraparte
    end as counterparty_soc,
    'BI00411' as adjustment_code,
    case 
        when ep_score =  'EPSC7' and epc_label =  'EPCL8' then concat(idcomb_satelite,';','EPSD3',';',ep_score,';','EPCD3',';',epc_label)  
        when ep_score =  'EPSC7' and epc_label <> 'EPCL8' then concat(idcomb_satelite,';',ep_score,';',epc_label_data,';',epc_label)
        when ep_score <> 'EPSC7' and epc_label =  'EPCL8' then concat(idcomb_satelite,';',ep_score_data,';',ep_score,';',epc_label)
        when ep_score <> 'EPSC7' and epc_label <> 'EPCL8' then concat(idcomb_satelite,';',ep_score_data,';',ep_score,';',epc_label_data,';',epc_label)
    end as id_comb,
    -round(sum(`13_gross_carrying_amount`),0) as amount,
    EU

from bu_esg_work.rf_pilar3_tabaux_sat80_dez23
group by 1,2,3,4,6
;

-- 505
-- tangible assets
drop table bu_esg_work.rf_pilar3_tabaux80adj_dez23;
create table bu_esg_work.rf_pilar3_tabaux80adj_dez23 as
select 
        a.idcomb_satelite, 
        a.sociedade_contraparte,
        a.cod_ajust,
        a.cargabal_ct,
        a.saldo_ct,
        b.cod_imovel,
        b.tipo_adjudicado,
        --b.cargabal_vc,
        b.valor_cargabal_vc,
        b.fin_imovel,
        b.`4_collateral_nuts`,
        b.`5_collateral_zip_code`,
        b.tipo_imovel,
        b.fiabilidad,
        b.clase_energetica,
        b.emisiones,
        b.consumos,
        case
            when trim(b.clase_energetica) like 'A%' then 'EPCL1'
            when trim(b.clase_energetica) like 'B%' then 'EPCL2'
            when trim(b.clase_energetica) like 'C%' then 'EPCL3'
            when trim(b.clase_energetica) like 'D%' then 'EPCL4'
            when trim(b.clase_energetica) like 'E%' then 'EPCL5'
            when trim(b.clase_energetica) like 'F%' then 'EPCL6'
            when trim(b.clase_energetica) like 'G%' then 'EPCL7'
            else 'EPCL8'
        end as epc_label, 
        case
            when b.fiabilidad in ('', '1-REAL','SANTANDER') then 'EPCD1'
            when trim(b.fiabilidad) in ('2-MUY ALTA', '3-ALTA', '4-MEDIA', '5-MEDIA BAJA', '6-BAJA') then 'EPCD2'
            else 'EPCD3'
        end as epc_label_data,
        case 
            when b.consumos <= 100 then 'EPSC1'
            when b.consumos <= 200 then 'EPSC2'
            when b.consumos <= 300 then 'EPSC3'
            when b.consumos <= 400 then 'EPSC4'
            when b.consumos <= 500 then 'EPSC5'
            when b.consumos >  500 then 'EPSC6'
            else 'EPSC7'
        end as ep_score,
        'EPSD2' as ep_score_data, 
        'EU1' as EU,
        case 
            when cargabal_ct = '' then -saldo_ct
            else valor_cargabal_vc
        end as amount
        
from (  select csatelite, idcomb_satelite, sociedade_contraparte, cod_ajust, cargabal_ct, sum(saldo_ct) as saldo_ct 
		from bu_esg_work.RF_PILAR3_UNIVERSO_FULL where csatelite = 80 and idcomb_satelite like '%MC10%' and DT_RFRNC = '${ref_date}' and id_corrida='2'
		
        group by 1,2,3,4,5) as a
        
left join (
			    SELECT *
			    FROM
			    (
			        select * 
			        from bu_esg_work.adjudicados_dez23_final
			        where tipo_adjudicado <> 'Totta URBE' and cargabal_vc in ('1605000','1605010')
			    ) x
			    LEFT JOIN
			    (
			        SELECT *
			        FROM bu_esg_work.gloval_clase_energetica_dez23
			    ) CERT_ENERG
			    ON cod_imovel = chave_banco_atual
			) as b
on a.cargabal_ct = b.cargabal_vc
;

-- 24
-- tabela final
drop table bu_esg_work.rf_pilar3_satelite80adj_dez23;
create table bu_esg_work.rf_pilar3_satelite80adj_dez23 as
select 
    '00411' as reporting_soc,
    case 
        when sociedade_contraparte = '' then '00000'
        else sociedade_contraparte
    end as counterparty_soc,
    'BI00411' as adjustment_code,
    case 
        when ep_score =  'EPSC7' and epc_label =  'EPCL8' then concat(idcomb_satelite,';','EPSD3',';',ep_score,';','EPCD3',';',epc_label) 
        when ep_score =  'EPSC7' and epc_label <> 'EPCL8' then concat(idcomb_satelite,';',ep_score,';',epc_label_data,';',epc_label)
        when ep_score <> 'EPSC7' and epc_label =  'EPCL8' then concat(idcomb_satelite,';',ep_score_data,';',ep_score,';',epc_label)
        when ep_score <> 'EPSC7' and epc_label <> 'EPCL8' then concat(idcomb_satelite,';',ep_score_data,';',ep_score,';',epc_label_data,';',epc_label)
    end as id_comb,
    round(sum(amount),0) as amount,
    EU

from bu_esg_work.rf_pilar3_tabaux80adj_dez23
group by 1,2,3,4,6
;

-- 186
-- tabela final - consolidação
drop table bu_esg_work.rf_pilar3_satelite80v0_dez23;
create table bu_esg_work.rf_pilar3_satelite80v0_dez23 as
select * from bu_esg_work.rf_pilar3_satelite80_dez23
union
select * from bu_esg_work.rf_pilar3_satelite80adj_dez23
;

-- Desconsideração de operações SC02 --> Por indicação da corporação (Cargabal Masterizado sem visibilidade de SC02+COLL3)
-- 179 registos

drop table bu_esg_work.rf_pilar3_satelite80_final_dez23;
create table bu_esg_work.rf_pilar3_satelite80_final_dez23 as
Select * from bu_esg_work.rf_pilar3_satelite80v0_dez23
where id_comb not like '%SC02%'
;

insert overwrite table  bu_esg_work.RT_PILAR3_SATELITE80 partition (DT_RFRNC, PROC_ID)
Select 
    sat.reporting_soc,
    sat.counterparty_soc,
    sat.adjustment_code,
    sat.id_comb, 
    sat.amount, --em caso de dar erro no insert fazer cast para DECIMAL(36,0)
    sat.eu,
	strleft( cast(current_timestamp() as STRING), 10) as PROC_DATE,
	-- Particao
    '${ref_date}' as DT_RFRNC,
    rt.NEW_PROC_ID
	
from (

Select * 
from bu_esg_work.rf_pilar3_satelite80v0_dez23
where id_comb not like '%SC02%'


) SAT
left join
(Select nvl(max(PROC_ID),0)+1 as NEW_PROC_ID from bu_esg_work.RT_PILAR3_SATELITE80) RT
on 1=1
;




---------------------------------------------------------------------------------------------------------------------
-- Testes e Validações
---------------------------------------------------------------------------------------------------------------------

-- Diferença de -85 971 629,84 entre input e output devido à exclusão dos CMAHFRN da tabela de garantias
-- CMAH31IFRN100I199100200P27900SC0
-- CMAH31IFRN00I19910000P2740901SC0
-- CMAH31IFRN100I1910000P2740904SC0
-- CMAH89IFRN100I199100240P27490SC0
-- CMAH31IFRN100I199100210P27901SC0
-- CMAH31IFRN100I1910000P2740900SC0


-- Comparação de saldos (input x output)
-- input
-- 26 436 715 109
select sum(saldo_ct)
from bu_esg_work.rf_pilar3_universo_full where csatelite = 80 and idcomb_satelite not like '%MC10%'
--from bu_esg_work.RF_PILAR3_UNIVERSO_FULL where csatelite = 80 and idcomb_satelite not like '%MC10%' and DT_RFRNC = '${ref_date}' -- descomentar em junho

		
;

-- output
-- 26 436 715 108
select sum(amount)
from bu_esg_work.rf_pilar3_satelite80  
;

-- Validação de IDcomb
select 
    a.*,
    case when b.idcomb_pilar3 is null then 0 else 1 end as flag_idcomb_valido
from bu_captools_work.rf_pilar3_satelite80v0 as a
left join (select distinct idcomb_pilar3 from bu_captools_work.pilar3_idcomb_completo where csatelite = 80) as b
on a.id_comb = b.idcomb_pilar3 
order by flag_idcomb_valido
;





