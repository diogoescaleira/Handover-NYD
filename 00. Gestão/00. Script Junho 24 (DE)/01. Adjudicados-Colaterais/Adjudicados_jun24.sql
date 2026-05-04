

--------------------------------------------------------------------
----------------------Código adjudicados to-be----------------------
--------------------------------------------------------------------          

ref_date = '${ref_date}'

--------Importação da tabela vinda do excel (compilação de todos os ficheiros de adjudicados recebidos)
Drop table bu_esg_work.adjudicados_aux_jun24;
create table bu_esg_work.adjudicados_aux_jun24
(
cod_imovel string,
origem string,
valor_cargabal decimal(32,12),
conta_cargabal_capital string,
imparidade_cargabal decimal(32,12),
conta_cargabal_imparidade string,
tipo_imovel string,
nome_distrito string,
nome_concelho string,
nome_freguesia string,
cod_postal string,
subcod_postal string,
data_aquisicao string,
zcliente string,
valor_cargabal_local decimal(32,12),
imparidade_cargabal_local decimal(32,12)

)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE;

---------------------------------------------------------------------------------
---- 1. Preenchimento dos campos cdistrito cconcelho e cfreguesia para DA--------
---------------------------------------------------------------------------------
--Controlo: Validar que tem todos os registos e traz o cdisconf e codigo postal para a ref date mais recente mas menor ou igual à ref date pretendida e para a hora de preenchimento mais recente	
--Dez23:51
--Jun24: 37
Drop table if exists bu_esg_work.adjudicados_aux_jun24_DA;
Create table bu_esg_work.adjudicados_aux_jun24_DA as
Select distinct
		a.cod_imovel,
		a.origem,
		a.zcliente,
		b.data_date_part,
		cdisconf,
		substring(b.cpost,1,4) as cod_postal,
		substring(b.cpost,5,7) as subcod_postal,
		concat(substr(trim(right(concat('000000',trim(b.cdisconf)),6)),1,2),'0000') as cdistrito,
		concat(substr(trim(right(concat('000000',trim(B.cdisconf)),6)),1,4),'00') as cconcelho,
		substr(trim(right(concat('000000',trim(B.cdisconf)),6)),1,6) as cfreguesia
From (select * from bu_esg_work.adjudicados_aux_jun24 where origem = 'Dações+Arrematações') a  

LEFT JOIN
(
	select b.* 
	from 
	    (
	    	Select zcliente, max(data_date_part) as data_date_part_max, max(htimest) as htimest_max 
	    	from cd_riscos.ivt01_imoveis 
	    	where data_date_part <= '${ref_date}'
	    	group by zcliente 
	    )a
    left join 
	    (
	    	Select * 
	    	from cd_riscos.ivt01_imoveis
	     	where data_date_part <= '${ref_date}'
	     ) b
    on  a.zcliente = b.zcliente and 
    	a.data_date_part_max = b.data_date_part and 
    	a.htimest_max = b.htimest
)
b
on a.zcliente = cast(b.zcliente as string)

; 															 
--------------------------------------------------------------------------------
-------2. Preenchimento do cdistrito, cconcelho e cfreguesia para IFIC----------
--------------------------------------------------------------------------------
--Dez23:9
--Jun24: 10
-- 2.1. Trazer o zcliente para IFIC dado que não existe no ficheiro importado
-- Controlo: Verificar que todos os registos ficam preenchidos (em Jun23 existia um cliente que não era preenchido porque não existe na cd_leasing.lgt03_ravalimo - cod_imovel 9000507854)
drop table if exists bu_esg_work.adjudicados_aux_jun24_1;
Create table bu_esg_work.adjudicados_aux_jun24_1 as
select distinct A.*, 
				B.zcliente as zcliente_cdleasing
from bu_esg_work.adjudicados_aux_jun24 as A
left join (select * from cd_leasing.lgt03_ravalimo) as b
on cast(trim(cod_imovel) as bigint) = cast(B.zimovel as bigint)
where origem = 'Stock IFIC';

invalidate metadata bu_esg_work.adjudicados_aux_jun24_1;

-- 2.2. Preenchimento da informação de distrito, concelho e freguesia
--Dez23:9
Drop table if exists bu_esg_work.adjudicados_aux_jun24_IFIC;
create table bu_esg_work.adjudicados_aux_jun24_IFIC as
select * 
from 
(
	Select 
			a.cod_imovel,
			a.origem,
			a.zcliente_cdleasing,
			a.valor_cargabal,
			b.data_date_part,
			b.cdisconf,
			b.htimest,
			substring(b.cpost,1,4) as cod_postal,
			substring(b.cpost,5,7) as subcod_postal,
			concat(substr(trim(right(concat('000000',trim(b.cdisconf)),6)),1,2),'0000') as cdistrito,
			concat(substr(trim(right(concat('000000',trim(b.cdisconf)),6)),1,4),'00') as cconcelho,
			substr(trim(right(concat('000000',trim(b.cdisconf)),6)),1,6) as cfreguesia,
			cast(b.mvalcontat as string),
			rank () over  (partition by cod_imovel order by b.htimest desc) ordem

	From (select * from bu_esg_work.adjudicados_aux_jun24_1 ) a 

	LEFT JOIN

	(
		select b.* from 
		    (
		    	Select zcliente, max(data_date_part) as data_date_part_max 
		    	from cd_riscos.ivt01_imoveis 
		    	where data_date_part <= '${ref_date}'
		    	group by zcliente 
		    ) a
	    left join 
		    (
		    	Select * 
		    	from cd_riscos.ivt01_imoveis
		     	where data_date_part <= '${ref_date}'
		     ) b
	    on a.zcliente = b.zcliente and a.data_date_part_max = b.data_date_part
	) b
	on cast(A.zcliente_cdleasing as string) = cast(B.zcliente as string)  
) xx 
where ordem = 1
;
------------------------------------------------------------------------------------------------------
------- 3. Preenchimento de cdistrito, cconcelho e cfreguesia para TOTTAURBE E Stock Adjudicados------
------------------------------------------------------------------------------------------------------
--3.1. Preenchimento via codigos postais
--Dez23:618 
--Jun24: 580
Drop table if exists bu_esg_work.adjudicados_aux_jun24_Totta_SA;
Create table bu_esg_work.adjudicados_aux_jun24_Totta_SA as  

Select 
    adj.*, 
    dd as cdistrito,
    cc as cconcelho,
    ff as cfreguesia,
    concat(dd,cc,ff) as cdisconf   
from 
(
	select * 
	from bu_esg_work.adjudicados_aux_jun24
	where origem in ('Totta URBE','Stock Adjudicados')
) adj

LEFT JOIN
(select * from
(select row_number() OVER(PARTITION BY zona,codcomp ORDER BY dd desc, cc desc, ff desc) as rnumber,*
from
(
	Select DISTINCT 
	     coddis as dd,
	     codcon as cc,
	     fregna as ff,
	     zona,
	     codcomp
	From cd_estruturais.vias_pt
	Where coddis <> ''
	and data_date_part = '${ref_date_vias_pt}'
	)viaspt)x
	where rnumber=1
	) cod_p 
on adj.cod_postal = cod_p.zona and lpad(adj.subcod_postal,3,'0')=lpad(cod_p.codcomp,3,'0') 
;             
-------------------------------------------------------------------------------
------- 4. Preenchimento de nome distrito,concelho e freguesia para DA --------
-------------------------------------------------------------------------------
--Jun24: 37
--Vamos buscar as TAT os nomes através dos codigos
-- Controlos:
--	A. Ver se temos coisas a Null por causa de zclientes que terminem em a/b  
--  B. Avaliar se cod_imovel 9000507854 tem NULLS pois o zcliente n existe na tabela cd_riscos.ivt01_imoveis 
--Dez23:51 
Drop table if exists bu_esg_work.adjudicados_aux_jun24_DA_v2;
Create table bu_esg_work.adjudicados_aux_jun24_DA_v2 as 
Select                                         
	a.cod_imovel ,                                    
	a.origem,                                        
	a.cdistrito,
	a.cconcelho,
	a.cfreguesia,
	b.tayd91c0_gelemtab as nome_distrito,
	c.tayd91c0_gelemtab as nome_concelho,
	d.tayd91c0_gelemtab as nome_freguesia

from bu_esg_work.adjudicados_aux_jun24_DA as a

left join
(	
	select * 
	from cd_estruturais.tat91_tabelas 
	where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= '${ref_date}') and 
		  tayd91c0_ctabela = 'J48'
) as b
on  a.cdistrito = b.tayd91c0_celemtab
left join
(
	select * 
	from cd_estruturais.tat91_tabelas 
	where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= '${ref_date}') and 
		  tayd91c0_ctabela = 'J48'
) as c
on  a.cconcelho = c.tayd91c0_celemtab
left join
(
	select * 
	from cd_estruturais.tat91_tabelas 
	where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= '${ref_date}') and 
		  tayd91c0_ctabela = 'J48'
) as d
on  a.cfreguesia = d.tayd91c0_celemtab;
;
----------------------------------------------------------------------------------
-------- 5. Preenchimento de nome distrito,concelho e freguesia para IFIC --------
----------------------------------------------------------------------------------
--Dez23: 9
--Jun24: 10
Drop table if exists bu_esg_work.adjudicados_aux_jun24_IFIC_2;                 
Create table bu_esg_work.adjudicados_aux_jun24_IFIC_2 as
Select 
	a.cod_imovel ,
	a.origem,
	a.cdistrito,
	a.cconcelho,
	a.cfreguesia,
	b.tayd91c0_gelemtab as nome_distrito,
	c.tayd91c0_gelemtab as nome_concelho,
	d.tayd91c0_gelemtab as nome_freguesia

from bu_esg_work.adjudicados_aux_jun24_IFIC as a

left join
(	
	select * 
	from cd_estruturais.tat91_tabelas 
	where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= '${ref_date}') and 
		  tayd91c0_ctabela = 'J48'
) as b
on  a.cdistrito = b.tayd91c0_celemtab

left join
(
	select * 
	from cd_estruturais.tat91_tabelas 
	where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= '${ref_date}') and 
		  tayd91c0_ctabela = 'J48'
) as c
on  a.cconcelho = c.tayd91c0_celemtab

left join
(
	select * 
	from cd_estruturais.tat91_tabelas 
	where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= '${ref_date}') and 
		  tayd91c0_ctabela = 'J48'
) as d
on  a.cfreguesia = d.tayd91c0_celemtab;
;
------------------------------------------------------------------------------------------
------------- 6. Preenchimento do tipo de imóvel para DA e IFIC---------------------------
------------------------------------------------------------------------------------------
--Dez23: 60 
--Jun24: 47
Drop table if exists bu_esg_work.adjudicados_aux_jun24_DA_IFIC;
Create table bu_esg_work.adjudicados_aux_jun24_DA_IFIC as 
SELECT DISTINCT * 
FROM 
(
	select a.*,
	 		rank () over (partition BY a.cod_imovel ORDER BY a.htimest DESC) ordem

	from
	(	
		select distinct
				ADJ.cod_imovel,
				ADJ.origem,
				ADJ.zcliente,
				IMO.ctipbem,
				IMO.ckbalbem,
				IMO.ckctabem,
				IMO.htimest
		from (select * from bu_esg_work.adjudicados_aux_jun24
		where origem not in ('Totta URBE','Stock Adjudicados')
	) ADJ

	left join
	(
		select distinct *
		from cd_riscos.ivt01_imoveis
		where data_date_part IN (SELECT max(data_date_part) FROM cd_riscos.ivt01_imoveis WHERE data_date_part <= '${ref_date}')
	) as IMO
	on cast(ADJ.zcliente as string) = cast(IMO.zcliente as string)
) a
left join
(
	select distinct
		IFIC.cod_imovel,
		IFIC.origem,
		IFIC.zcliente_cdleasing,
		IMO2.ctipbem,
		IMO2.ckbalbem,
		IMO2.ckctabem
	from bu_esg_work.adjudicados_aux_jun24_1 IFIC
	left join
		(
			select distinct * 
			from cd_riscos.ivt01_imoveis
			where data_date_part IN (SELECT max(data_date_part) FROM cd_riscos.ivt01_imoveis WHERE data_date_part <= '${ref_date}')
		 ) IMO2
		on cast(IFIC.zcliente_cdleasing as string) = cast(IMO2.zcliente as string)
) b
on a.cod_imovel = b.cod_imovel )xx
where ORDEM = 1;
;
--Dez23:60 
--Jun24:47
drop table if exists bu_esg_work.adjudicados_aux_jun24_DA_IFIC_2;
Create table bu_esg_work.adjudicados_aux_jun24_DA_IFIC_2 as 
select 
	a.*,
	b.cfinbem 
from bu_esg_work.adjudicados_aux_jun24_DA_IFIC as a
left join  
(
	select *
    from cd_garantias.gt009_bens_imov
    where ref_date='${ref_date}'
) B
on a.ckbalbem = b.ckbalbem and a.ckctabem = b.ckctabem

;
--Dez23:60
--Jun24:47
Drop table if exists bu_esg_work.adjudicados_aux_jun24_DA_IFIC_3;
Create table bu_esg_work.adjudicados_aux_jun24_DA_IFIC_3 as
Select 
	cod_imovel,
	origem,
	case 
		when (trim(cfinbem) in ('01','06','07')) or (trim(cfinbem) = '08' and trim(ctipbem) in ('12','13','14')) then 'RESIDENCIAL'
	 	when trim(cfinbem) in ('02','03','04','05') then 'COMERCIAL'
	 	else 'OUTROS'
	end as tipo_imovel,
	ctipbem,
	ckbalbem,
	ckctabem,
	cfinbem,
	case
		when (trim(cfinbem) in ('01','06','07')) or (trim(cfinbem) = '08' and trim(ctipbem) in ('12','13','14')) then 1
	    else 0
	end as tipo_inmueble_habitacao,
	case
	 	when trim(cfinbem) in ('02','03','04','05') then 1
	    else 0
	end as tipo_inmueble_comercio_servicos	
from bu_esg_work.adjudicados_aux_jun24_DA_IFIC_2; 
-----------------------------------------------------------------------


-----------------------------------------------------------------------
-------------Criação tabela final--------------------------------------
-----------------------------------------------------------------------
--Dez23:678 
--Jun24:627
Drop table if exists bu_esg_work.adjudicados_aux_jun24_pre_final;
Create table bu_esg_work.adjudicados_aux_jun24_pre_final as 

Select distinct
	a.cod_imovel,
	a.origem as tipo_adjudicado,
	a.conta_cargabal_capital,
	a.valor_cargabal,
	a.valor_cargabal_local,
	a.conta_cargabal_imparidade,
	a.imparidade_cargabal,
	a.imparidade_cargabal_local,
	a.Data_aquisicao,
	coalesce (b.cdistrito,c.cdistrito,d.cdistrito) as cdistrito,
	coalesce (b.cconcelho,c.cconcelho,d.cconcelho) as cconcelho,
	coalesce (b.cfreguesia,c.cfreguesia,d.cfreguesia) as cfreguesia,
	concat(coalesce (substr(b.cdistrito,1,2),substr(c.cdistrito,1,2),d.cdistrito),coalesce (substr(b.cconcelho,3,2),substr(c.cconcelho,3,2),d.cconcelho),coalesce (substr(b.cfreguesia,5,2),substr(c.cfreguesia,5,2),d.cfreguesia) ) as cdisconf,
	coalesce (i.tipo_imovel,g.tipo_imovel) as fin_imovel,
	case 
		when coalesce (i.tipo_imovel,g.tipo_imovel) like '%Residencial%' then 'Residencial' 
		when coalesce (i.tipo_imovel,g.tipo_imovel) like '%Comercial%' then 'Comercial'
		else 'Outros'
	end as id19_type_asset,
	coalesce (j.nome_distrito,h.nome_distrito,e.nome_distrito) as nome_distrito ,
	coalesce (k.nome_concelho,h.nome_concelho,e.nome_concelho) as nome_concelho,
	coalesce (l.nome_freguesia,h.nome_freguesia,e.nome_freguesia) as nome_freguesia,
	COALESCE(m.cod_postal,b.cod_postal,c.cod_postal) as cod_postal,
	coalesce(n.subcod_postal,b.subcod_postal,c.subcod_postal) as subcod_postal,
	concat(COALESCE(m.cod_postal,b.cod_postal,c.cod_postal),coalesce (n.subcod_postal,b.subcod_postal,c.subcod_postal)) as id4_zip_code
from bu_esg_work.adjudicados_aux_jun24 as a 
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24_DA) as b
on a.cod_imovel = b.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24_IFIC)  as c 
on a.cod_imovel = c.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24_Totta_SA) as d
on a.cod_imovel = d.cod_imovel
left join
(select distinct * from bu_esg_work.adjudicados_aux_jun24_DA_v2) as e 
on a.cod_imovel = e.cod_imovel
left join
(select distinct * from bu_esg_work.adjudicados_aux_jun24_DA_IFIC_2) as f 
on a.cod_imovel = f.cod_imovel
left join
(select distinct * from bu_esg_work.adjudicados_aux_jun24_DA_IFIC_3) as g
on a.cod_imovel = g.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24_IFIC_2) as h
on a.cod_imovel = h.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24 where tipo_imovel <> '') as i
on a.cod_imovel = i.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24 where nome_distrito <> '') as j
on a.cod_imovel = j.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24 where nome_concelho <> '') as k
on a.cod_imovel = k.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24 where nome_freguesia <> '') as l
on a.cod_imovel = l.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24 where cod_postal <> '') as m
on a.cod_imovel = m.cod_imovel
left join 
(select distinct * from bu_esg_work.adjudicados_aux_jun24 where subcod_postal <> '') as n
on a.cod_imovel = n.cod_imovel;
--------------------

--Dez23:678 
--Jun24:627
Drop table if exists bu_esg_work.adjudicados_aux_jun24_final;
Create table bu_esg_work.adjudicados_aux_jun24_final as 
select a.*,tayd91c0_nelemc05 
from bu_esg_work.adjudicados_aux_jun24_pre_final as a
left join 
		( 
			select 
				tayd91c0_nelemc05,
		        tayd91c0_celemtab
			from cd_estruturais.tat91_tabelas
			where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= '${ref_date}') and 
				  tayd91c0_ctabela = 'J48'
		)  TAT
on a.cdisconf= TAT.tayd91c0_celemtab;


-- TABELA A ENVIAR PARA GLOVAL
--Dez23:678 
--Jun24:627
Drop table if exists bu_esg_work.adjudicados_jun24_final;
create table bu_esg_work.adjudicados_jun24_final as
select 
	cod_imovel,
	tipo_adjudicado,
	conta_cargabal_capital as cargabal_vc,
    valor_cargabal as valor_cargabal_vc,
	conta_cargabal_imparidade as cargabal_prov,
	imparidade_cargabal as valor_cargabal_prov,
	data_aquisicao,
	cdistrito,
	cconcelho,
	cfreguesia,
	cdisconf,
	fin_imovel,
	id19_type_asset as tipo_imovel,
	nome_distrito,
	nome_concelho,
	nome_freguesia,
	id4_zip_code as `5_collateral_zip_code`,
	tayd91c0_nelemc05 as `4_collateral_nuts`,
	valor_cargabal_local as valor_cargabal_local_vc,
	imparidade_cargabal as valor_cargabal_local_prov
from bu_esg_work.adjudicados_aux_jun24_final;
;


--INCORPORAR TABELA QUE GLOVAL ENVIA COM CERTIFICADOS - Tabela final adjudicados com os certificados energéticos 
--751 registos 
insert overwrite table  bu_esg_work.adjudicados_final partition (ref_date/*,perimetro)*/)
--drop table bu_esg_work.adjudicados_final_jun24; 
--create table bu_esg_work.adjudicados_final_jun24 as

select distinct a.*,
		b.chave,
		case
            when b.fiabilidad is not null then b.fiabilidad
			else c.fiabilidad
        end as fiabilidad,
        case
            when b.clase_energetica is not null then b.clase_energetica
			else c.clase_energetica
        end as clase_energetica,
        case
            when b.emisiones is not null then b.emisiones
            else c.emisiones
        end as emisiones,
        case
            when b.consumos is not null then b.consumos
            else c.consumos
        end as consumos,
		
        from_unixtime(unix_timestamp()) as htimest,
     -- partition
        '${date}' as ref_date/*, '${perimetro}' as nome_perimetro*/
from bu_esg_work.adjudicados_jun24_final a 

left join 
    (
        select * from bu_esg_work.informacao_gloval_agrupada_final -- tabela a ser importada
    ) b
on a.chave_imv_cons = b.chave

left join
(
select cod_imovel,fiabilidad,clase_energetica,emisiones,consumos from bu_captools_work.rf_metricas_adjudicad_final_v2 -- tabela usada pela MS em Dez22 (MUDAR PARA JUN24)
)c
on a.cod_imovel = c.cod_imovel  
;

Drop table if exists bu_esg_work.adjudicados_aux_jun24_DA;
Drop table if exists bu_esg_work.adjudicados_aux_jun24_IFIC;
Drop table if exists bu_esg_work.adjudicados_aux_jun24_Totta_SA;
Drop table if exists bu_esg_work.adjudicados_aux_jun24_DA_v2;
Drop table if exists bu_esg_work.adjudicados_aux_jun24_DA_IFIC_2;
Drop table if exists bu_esg_work.adjudicados_aux_jun24_DA_IFIC_3;
Drop table if exists bu_esg_work.adjudicados_aux_jun24_IFIC_2;
Drop table if exists bu_esg_work.adjudicados_aux_jun24_pre_final;

    