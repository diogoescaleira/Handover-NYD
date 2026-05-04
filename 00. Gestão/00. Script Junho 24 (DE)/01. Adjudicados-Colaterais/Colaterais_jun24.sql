
---------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | Código para processamento dos Colaterais                                              --
---------------------------------------------------------------------------------------------------------------------
-- Neyond 2023                                                                                                     --
---------------------------------------------------------------------------------------------------------------------
--ref_date = '${ref_date}' -- dez23: 2023-12-31
--ref_date_vias_pt = '${ref_date_vias_pt}' -- dez23: 2023-12-30

-------------------------------------------------------------------------------------------
------------------------------- Universo --------------------------------------------------
-------------------------------------------------------------------------------------------
-- 401.940
-- Dez23:390.354 
-- HF: Nova Corrida Dez23 390.354 - 390 354 
-- Jun24: 363.803 

-- Drop table IF EXISTS bu_esg_work.Colaterais_aux_jun24;
Create table bu_esg_work.Colaterais_aux_jun24 as

select distinct ANL1.*
from
(
		select distinct    
		
            UNI_F.cempresa_fr012, 
            UNI_F.cbalcao_fr012, 
            UNI_F.cnumecta_fr012, 
            UNI_F.zdeposit_fr012, 
            UNI_F.cempresa_ct, 
            UNI_F.cbalcao_ct, 
            UNI_F.cnumecta_ct, 
            UNI_F.zdeposit_ct,             
			
		-- Rateio Avaliacoes
            GT18.ckbalcao, 
            GT18.cknumcta, 
            GT18.comp_id_gar,
			GT18.cempbem,
            GT18.ckbalbem,
            GT18.ckctabem, 
            GT18.ckrefbem, 
            GT18.origem,
	        --GT182.per_cobert_final as 16_percent_collateral,
            GT18.mavalia as mavalbem,
			GT18.mavaliaa,
			
		-- Marcacao dos colaterais tipo garantia hipotecaria	
			   case
				when COL_TP.subtipo_garantia_NEW not in ('RESIDENCIAL','COMERCIAL') then 'OUTROS'
				when COL_TP.subtipo_garantia_NEW is null then 'OUTROS'
				else COL_TP.subtipo_garantia_NEW end as 32_type_collateral,
          
		-- Marcacao do tipo de imovel
		-- Marcacao xxx TAT
               case	
				when BEM_IM.tipo_imovel is null then 'OUTROS'
				else BEM_IM.tipo_imovel end as tipo_imovel,
			   case
				when length(trim(BEM_IM.cpost))=7 then trim(BEM_IM.cpost)
				else substring(trim(BEM_IM.cpost),1,4) end as 5_collateral_zip_code,
			    BEM_IM.novo_cdisconf as cdisconf
                                           
     	
    FROM
    	-- Universo Full: 394459 (Jun23), 383441 (Dez23), 383455 (nosso teste), 726 262 (JUN24)
		(Select distinct 
		                 cempresa_ct,
                         cbalcao_ct, 
                         cnumecta_ct, 
                         zdeposit_ct, 
                         cempresa_fr012, 
                         cbalcao_fr012, 
                         cnumecta_fr012, 
                         zdeposit_fr012 
        from bu_esg_work.RF_PILAR3_UNIVERSO_FULL_jun24 where csatelite = 80 
        -- and DT_RFRNC = '${ref_date}' and ID_CORRIDA = '2'
        ) UNI_F   
		-- Rateio Avaliacoes
	   inner join 
        (SELECT *
		 FROM cd_garantias.gt018_rateio_aval
            where ref_date = '${ref_date}'and tipologia = 'IMO') GT18  
        on concat(UNI_F.cempresa_ct,UNI_F.cbalcao_ct, UNI_F.cnumecta_ct, UNI_F.zdeposit_ct)
        =concat(GT18.cempresp, GT18.ckbalres, GT18.ckctares, GT18.ckrefresp)
        
		-- Marcacao dos colaterais tipo garantia hipotecaria 
		----- JB(26/06/2024): Alteração de tradutor biyr caução para tradutor bem.
        LEFT JOIN
        (
            SELECT *
            FROM cd_garantias.kt_chaves_intrf_grts_biyr_bem 
            WHERE ref_date = '${ref_date_imov}' and tipologia = 'IMO' 
        
        ) KT_CHAVES
		ON CONCAT(GT18.CEMPRESP,GT18.CKBALRES,GT18.CKCTARES,GT18.CKREFRESP,GT18.CEMPBEM,GT18.CKBALBEM,GT18.CKCTABEM,GT18.CKREFBEM)=
           CONCAT(KT_CHAVES.CEMPRESP_ORIG,KT_CHAVES.CKBALRES_ORIG,KT_CHAVES.CKCTARES_ORIG,KT_CHAVES.CKREFRESP_ORIG,KT_CHAVES.CEMPBEM_ORIG,KT_CHAVES.CKBALBEM_ORIG,KT_CHAVES.CKCTABEM_ORIG,KT_CHAVES.CKREFBEM_ORIG)
        
        LEFT JOIN
        (
            SELECT * 
            FROM cd_captools.kt_chaves_finrep
            WHERE ref_date = '${ref_date}'
        ) KT_CHAVES_FR
        ON  CONCAT(GT18.CEMPRESP,GT18.CKBALRES,GT18.CKCTARES,GT18.CKREFRESP)=
            CONCAT(KT_CHAVES_FR.CEMPRESA,KT_CHAVES_FR.CBALCAO,KT_CHAVES_FR.CNUMECTA,KT_CHAVES_FR.ZDEPOSIT)
        
		--- validar implementação:
        LEFT JOIN
        (
            SELECT  COL.*,
                    CASE WHEN TP_GAR_1.subtipo_garantia IS NOT NULL THEN TP_GAR_1.subtipo_garantia ELSE TP_GAR_2.subtipo_garantia END AS subtipo_garantia_new,
                    CASE WHEN TP_GAR_1.tipo_garantia IS NOT NULL THEN TP_GAR_1.tipo_garantia ELSE TP_GAR_2.tipo_garantia END AS tipo_garantia_new    
            FROM
            	(
                	select *, lpad(zcaucao,15,'0')  as zcaucao_aux 
                	from cd_captools.fr003_colaterais 
                	where ref_date = '${ref_date}' 
                ) COL
            	left join
            	(
            	    select * 
            	    from cd_captools.ct003_univ_cli 
            	    where ref_date = '${ref_date}'
            	)ct003
            	on col.zcliente=ct003.zcliente
            	left join 
            	(
            	    select *  
            	    from cd_captools.fr801_tip_garan 
            	    where ref_date = '${ref_date}' and itip_cli not in ('J','F') 
            	) TP_GAR_1
            	on  COL.cgarant=TP_GAR_1.cgarant 
            	left join 
            	(
            	    select *  
            	    from cd_captools.fr801_tip_garan 
            	    where ref_date = '${ref_date}' and itip_cli in ('J','F') 
            	) TP_GAR_2
            	on  COL.cgarant=TP_GAR_2.cgarant and 
            	    ct003.itip_cli = TP_GAR_2.itip_cli 
            HAVING tipo_garantia_new = 'GAR HIP'		
        ) COL_TP
        ON  CONCAT(COL_TP.CEMPRESA, COL_TP.CBALCAO, COL_TP.CNUMECTA, COL_TP.ZDEPOSIT, COL_TP.CBALCAO_CAUCAO, COL_TP.CNUMECTA_CAUCAO, COL_TP.ZCAUCAO)=
            CONCAT(KT_CHAVES_FR.CEMPRESA_FR,KT_CHAVES_FR.CBALCAO_FR,KT_CHAVES_FR.CNUMECTA_FR,KT_CHAVES_FR.ZDEPOSIT_FR, KT_CHAVES.CKBALBEM_DEST, KT_CHAVES.CKCTABEM_DEST, KT_CHAVES.CKREFBEM_DEST)	
		
		-- Marcacao do tipo de imovel
		-- Marcacao xxx TAT
		left join
        (SELECT GT09.*,coalesce(TAT_1.tayd91c0_celemtab,TAT_2.tayd91c0_nelemc09,TAT_3.tayd91c0_nelemc09,TAT_4.tayd91c0_nelemc09,vias_pt.cdisconf) as novo_cdisconf FROM 
        
            (SELECT DISTINCT *,
		                CASE
							when (trim(cfinbem) in ('01','06','07')) or (trim(cfinbem) = '08' and trim(ctipbem) in ('1121','1130')) then 'RESIDENCIAL'
							when trim(cfinbem) in ('02','03','04','05') then 'COMERCIAL'
							else 'OUTROS'
							end as tipo_imovel
			FROM cd_garantias.gt009_bens_imov WHERE REF_DATE = "${ref_date}")GT09
		    
		  left join 

            (
            SELECT tayd91c0_celemtab
            FROM cd_estruturais.tat91_tabelas
            WHERE data_date_part IN
                (SELECT max(data_date_part)
                 FROM cd_estruturais.tat91_tabelas
                 WHERE data_date_part <= "${ref_date}")
              AND tayd91c0_ctabela = 'J48'
              and (trim(tayd91c0_nelemc08) = 'S' or 
                 (trim(tayd91c0_nelemc08) = 'N' and length(tayd91c0_nelemc09)=0))) TAT_1
            on case when cdisconf like '%99' then replace(cdisconf,'99','00') else lpad(cdisconf,6,'0') end = TAT_1.tayd91c0_celemtab
            
            left join 
            
            (
            SELECT tayd91c0_nelemc09,
            tayd91c0_celemtab
            FROM cd_estruturais.tat91_tabelas
            WHERE data_date_part IN
                (SELECT max(data_date_part)
                 FROM cd_estruturais.tat91_tabelas
                 WHERE data_date_part <= "${ref_date}")
              AND tayd91c0_ctabela = 'J48'
              and trim(tayd91c0_nelemc08) = 'N'
              and length(tayd91c0_nelemc09)= 6) TAT_2
            on case when cdisconf like '%99' then replace(cdisconf,'99','00') else lpad(cdisconf,6,'0') end = TAT_2.tayd91c0_celemtab
            
            left join 
            
            (
            SELECT strleft(tayd91c0_nelemc09,6) as tayd91c0_nelemc09,
            tayd91c0_celemtab
            FROM cd_estruturais.tat91_tabelas
            WHERE data_date_part IN
                (SELECT max(data_date_part)
                 FROM cd_estruturais.tat91_tabelas
                 WHERE data_date_part <= "${ref_date}")
              AND tayd91c0_ctabela = 'J48'
              and trim(tayd91c0_nelemc08) = 'N'
              and length(tayd91c0_nelemc09)= 12) TAT_3
            on case when cdisconf like '%99' then replace(cdisconf,'99','00') else lpad(cdisconf,6,'0') end = TAT_3.tayd91c0_celemtab
            
            left join
            (
            SELECT strright(tayd91c0_nelemc09,6) as tayd91c0_nelemc09,
            tayd91c0_celemtab
            FROM cd_estruturais.tat91_tabelas
            WHERE data_date_part IN
                (SELECT max(data_date_part)
                 FROM cd_estruturais.tat91_tabelas
                 WHERE data_date_part <= "${ref_date}")
              AND tayd91c0_ctabela = 'J48'
              and trim(tayd91c0_nelemc08) = 'N'
              and length(tayd91c0_nelemc09)= 12) TAT_4
            on case when cdisconf like '%99' then replace(cdisconf,'99','00') else lpad(cdisconf,6,'0') end = TAT_4.tayd91c0_celemtab

            LEFT JOIN
            (SELECT concat(zona,codcomp) as cpost,
                    max(concat(coddis,codcon,fregna)) as cdisconf
            FROM cd_estruturais.vias_pt
            WHERE coddis <> ''
              AND data_date_part = '${ref_date_vias_pt}'
              GROUP BY 1
              ) vias_pt
            on vias_pt.cpost = GT09.cpost
            		    		
		) BEM_IM
				on concat(BEM_IM.ckbalbem, BEM_IM.ckctabem, BEM_IM.ckrefbem)=concat(GT18.ckbalbem, GT18.ckctabem, GT18.ckrefbem)
) anl1

;

		
-------------------------------------------------------------------------------------------
------------------------ Popular informação de NUTS ---------------------------------------
-------------------------------------------------------------------------------------------		
	
-- 401.940
-- 390.347 ( -6 imóveis que são adjudicados, -1 que tem 2 processos )
-- HF: Nova Corrida Dez23 390.347 
-- 363.794 Jun24 

-- DROP TABLE if exists bu_esg_work.p3_colaterais_jun24;
CREATE TABLE bu_esg_work.p3_Colaterais_jun24 AS

--insert overwrite table  bu_esg_work.p3_colaterais partition (id_corrida, dt_rfrnc)

Select distinct		
		
-- Universo Full
    COL_AUX.cempresa_fr012, 
    COL_AUX.cbalcao_fr012, 
    COL_AUX.cnumecta_fr012, 
    COL_AUX.zdeposit_fr012, 
    COL_AUX.cempresa_ct, 
    COL_AUX.cbalcao_ct, 
    COL_AUX.cnumecta_ct, 
    COL_AUX.zdeposit_ct,     
	
-- Rateio Avaliacoes

    NULL AS  ckbalcao,    -- assumir apenas a chave do bem e não a do processo
    NULL AS  cknumcta,    -- assumir apenas a chave do bem e não a do processo
    NULL AS  comp_id_gar, -- assumir apenas a chave do bem e não a do processo
    COL_AUX.cempbem,
    COL_AUX.ckbalbem,
    COL_AUX.ckctabem, 
    COL_AUX.ckrefbem, 
    COL_AUX.origem,
	 0 as `16_percent_collateral`, -- campo já não é necessário
    COL_AUX.mavalbem,
	COL_AUX.mavaliaa,
	
-- Bens Imoveis

-- Marcacao dos colaterais tipo garantia hipotecaria	
	COL_AUX.`32_type_collateral`,
  
-- Marcacao do tipo de imovel
-- Marcacao xxx TAT
	COL_AUX.tipo_imovel,
	COL_AUX.`5_collateral_zip_code`,
	COL_AUX.cdisconf,
		
	TAT.tayd91c0_nelemc05 as 4_collateral_nuts,
	
--Flags de marcação de adjudicados	
   0 as Flag_DA, -- campo já não é necessário
   0 as Flag_IFIC, -- campo já não é necessário
    
-- Campos auxiliares
	from_unixtime(unix_timestamp()) as htimest,
-- Particao
    CAST(NEW_ID_CORRIDA AS STRING) as ID_CORRIDA, -- alterar para '1'
	"${ref_date}" as ref_date 


FROM	
---------------- Tabela base ----------------
(SELECT 
cempresa_fr012,
cbalcao_fr012,
cnumecta_fr012,
zdeposit_fr012,
cempresa_ct,
cbalcao_ct,
cnumecta_ct,
zdeposit_ct,
cempbem,
ckbalbem,
ckctabem,
ckrefbem,
mavalbem,
tipo_imovel,
`5_collateral_zip_code`,
cdisconf,
group_concat(`32_type_collateral`) as `32_type_collateral`, -- o cgarant é atualmente ao nível do processo, dado que existem casos em que 1 imóvel tem 2 processos, a informação por bem pode duplicar
group_concat(origem) as origem,
CAST(sum(mavaliaa) AS DECIMAL(17,2)) as mavaliaa

FROM bu_esg_work.Colaterais_aux_jun24
WHERE concat(ckbalbem,ckctabem) NOT IN
    (SELECT concat(ckbalbem,ckctabem)
     FROM bu_esg_work.adjudicados_aux_jun24_DA_IFIC
     where concat(ckbalbem,ckctabem) is not null) --Remocao de adjudicados para evitar duplicações após union all com universo de adjudicados 
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
     ) COL_AUX
	
	
---------------- Adicionar informacao das TAT ----------------			
left join 
( select 
	tayd91c0_nelemc05,
	data_date_part,
	tayd91c0_ctabela,
	tayd91c0_celemtab

from cd_estruturais.tat91_tabelas
where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}") and tayd91c0_ctabela = 'J48') TAT
on COL_AUX.cdisconf= TAT.tayd91c0_celemtab

left join
(Select nvl(max(ID_CORRIDA),0)+1 as NEW_ID_CORRIDA from bu_esg_work.p3_colaterais) ID_COR
on 1=1
;

;


