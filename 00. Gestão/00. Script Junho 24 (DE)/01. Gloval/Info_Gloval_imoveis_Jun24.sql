------------------------------------------------------------------------------------------------
------------------------ Gloval_Imoveis_Sem_Letra ----------------------------------------------
------------------------------------------------------------------------------------------------
-- CORRIDA DEZEMBRO REF_DATE = '2024-06-30' REF_DATE_UTIL = '2024-06-28'

-- JB (01/07/24): 1.485.564 (DADOS DE 28/06/24)

CREATE TABLE bu_esg_work.gpt31_contrato_jun24 AS 
select * from cd_emprestimos.gpt31_contrato;

-- JB (01/07/24): 652.907 (DADOS DE 28/06/24)
CREATE TABLE bu_esg_work.gpt32_bemimove_jun24 AS 
select * from cd_emprestimos.gpt32_bemimove;


--------------------------------------------------------------------------------------------------------------------------------
-- Universo de contratos ativos para a data de referência pretendida, perímetro individual corporativo e código espanha = 411 --
--------------------------------------------------------------------------------------------------------------------------------
/*drop table if exists bu_esg_work.gloval_aux_jun24;
create table  bu_esg_work.gloval_aux_jun24 as    
select CT001.* 
from (
		select distinct 	
						cempresa,
						cbalcao,
						cnumecta, 
						zdeposit,
						zcliente 
        from cd_captools.ct001_univ_saldo 
        where flag_ativo = 1 and ref_date = "${ref_date}"
     ) as ct001
            
inner join (
				select distinct cempresa,
								cbalcao,
								cnumecta, 
								zdeposit, 
								zcliente, 
								nome_perimetro
	            from cd_captools.ct005_univ_perim
	            where nome_perimetro = 'Individual Corporativo' and ref_date = "${ref_date}"
            ) AS ct005
            
inner join (
				select distinct CODIGO_ICS 
	            from cd_captools.ct802_codigo_emp 
				where CODIGO_ESPANHA = '00411' and ref_date = "${ref_date}"
			) AS ct802
on  ct001.cbalcao  = ct005.cbalcao
and ct001.cnumecta = ct005.cnumecta
and ct001.zdeposit = ct005.zdeposit
and ct001.cempresa = ct005.cempresa
and ct001.zcliente = ct005.zcliente
and ct001.cempresa = ct802.CODIGO_ICS; */

--------------------------------------------------------------------------------------------------------------------------------
---------------------------- Cruzamento do universo anterior com a informação de garantias -------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

--784 825
--HF(03/01/24) - DEZ - 761.144 linhas
--JB(01/07/24) - JUN - 366.749 linhas (decréscimo de linhas relacionado c/ uniformização de zdeposits nas ICs)

drop table if exists bu_esg_work.gloval_aux2_jun24;
create table bu_esg_work.gloval_aux2_jun24 as
select *
from 
(
    select  gt008.cempresa, gt008.ckbalcao,gt008.cknumcta,gt008.comp_id_gar,cempbem,ckbalbem,ckctabem,ckrefbem,gt001.origem,cempresp,ckbalres,ckctares,ckrefresp
                    --coalesce(aux.ind_ct,0) as ind_ct --flag para ver se a info nesta tabela de garantias que criaram, existem ou não as chaves na ct000 criada anteriormente, o que não houver mete 0
    from 
    (
        Select * 
        from cd_garantias.gt008_trz_gt_imv 
        where ref_date = "${ref_date}"
    ) as GT008
    left join
    (
        select *
        from cd_garantias.gt001_trz_rsp_gt
        where ref_date = "${ref_date}"
    ) gt001
	on  gt008.cempresa = gt001.cempresa
	and gt008.ckbalcao  = gt001.ckbalcao
	and gt008.cknumcta = gt001.cknumcta
	and gt008.comp_id_gar = gt001.comp_id_gar
/*    left join 
	(
	    select *, 1 as ind_ct 
		from bu_esg_work.gloval_aux_jun24
	) as Aux    
	on  Aux.cempresa = gt001.cempresp
	and Aux.cbalcao  = gt001.ckbalres
	and Aux.cnumecta = gt001.ckctares
	and Aux.zdeposit = gt001.ckrefresp*/
) a
;

----------------------------------------------------------------------------------------------------------------------------------------------
-- Cruzamento da tabela de cima com a GT009 e com a CST08 pela chave do bem para ir buscar alguma informação pretendida pela Gloval no final--
----------------------------------------------------------------------------------------------------------------------------------------------

--Universo alinhado com universo MS (por chave processo e por chave garantia)
--784 825
--HF(03/01/24) - DEZ - 761.144 linhas
--JB(01/07/24) - JUN - 366.749 linhas (descida de registos relacionada com a uniformização das chaves das ICs) 

drop table if exists bu_esg_work.gloval_aux3_jun24;
create table bu_esg_work.gloval_aux3_jun24 as
Select distinct
		Aux2.cempresp,
		Aux2.ckbalres,
		Aux2.ckctares,
		Aux2.ckrefresp,
		Aux2.cempbem,
		Aux2.ckbalbem,
		Aux2.ckctabem,
		Aux2.ckrefbem,
		Aux2.ckbalcao,
		Aux2.cknumcta,
		Aux2.comp_id_gar,
        concat(Aux2.ckbalbem,Aux2.ckctabem,Aux2.ckrefbem) as codigo_banco, --GT018
        --chave_gloval as chave_gloval,
        coalesce(substring(GT009.cdisconf,1,2),'') as codigo_distrito, --GT009 -> cdisconf
        --coalesce(nome_distrito,'') as nombre_distrito, 
        coalesce(substring(GT009.cdisconf,3,2),'')   as codigo_concejo, --GT009 -> cdisconf
        --coalesce(nome_concelho,'') as nombre_concejo, 
        coalesce(substring(GT009.cdisconf,5,2),'') as codigo_freguesia, --GT009 -> cdisconf
        --coalesce(nome_freguesia,'') as nombre_freguesia,
        coalesce(GT009.glocalid,'') as localidade, --GT009 -> glocalidad
		coalesce(GT009.cmorada,'') as tipo_via, --GT009 -> cmorada
        --'' as nombre_tipo_via,
        coalesce(GT009.gmorada,'') as nombre_via, --GT009 -> gmorada
        coalesce(GT009.gnum,'') as numero_via, --GT009 -> gnum
        coalesce(GT009.glote,'') as lote, --GT009 -> glote
        coalesce(GT009.gurbaniz,'') as urbanizacion, --GT009 -> gurbanização
        --'' as caglurb, 
        --'' as resto_direccion,
        --'' as latitud,
        --'' as longitud,
        coalesce(substring(GT009.cpost,1,4),'') as codigo_postal, --GT009 -> cpost(4 primeiros dígitos)
        case 
		    when substring((coalesce(substring(GT009.cpost,5,3),'')),3,1)= ' ' then ''
		    else coalesce(substring(GT009.cpost,5,3),'')
		end as subcodigo_postal, --GT009 -> cpost (3 últimos dígitos)
                --'' as superficie_util, 
        --'' as anio_construccion,
        case
            when (trim(GT009.cfinbem) in ('01','06','07')) or (trim(GT009.cfinbem) = '08' and trim(GT009.ctipbem) in ('1121','1130')) then 1 --GT018 -> cfinbem, ctipbem
            else 0
        end as tipo_inmueble_habitacao,        
        case
            when ((trim(GT009.cfinbem) in ('01','06','07')) or (trim(GT009.cfinbem) = '08' and trim(GT009.ctipbem) in ('1121','1130'))) and GT009.ctipbem in ('1112','1122','1130') then 1 --GT018 -> cfinbem, ctipbem
            else 0
        end as piso_apartamento,        
        case
            when ((trim(GT009.cfinbem) in ('01','06','07')) or (trim(GT009.cfinbem) = '08' and trim(GT009.ctipbem) in ('1121','1130'))) and GT009.ctipbem in ('1121') then 1 --GT018 -> cfinbem, ctipbem
            else 0
        end as casa_unifamiliar,
        case
            when trim(GT009.cfinbem) in ('02','03','04','05') then 1 
            else 0
        end as tipo_inmueble_comercio_servicos,
        --coalesce(nome_cogloval_aux2nservatoria,'') as nome_conservatoria,
        coalesce(CST08.cconserv,'') as cod_conservatoria,
        --'' as registro_conservatoria,
        coalesce(GT009.cartmatr,'') as art_matriciais, --GT009 -> cartmatr
        --'' as fraccao_autonoma,
        --coalesce(finalidade_bem,'') as finalidade_bem, --GT018 -> necessário descrição
        --''  as class_gpt31
		--coalesce(GT009.cfinbem, '') as cfinbem,
		GT009.gidfracc as resto_direccion,
		GT009.gficha as registro_conservatoria,
		coalesce(GT009.cfinbem, '') as finalidade_bem
		
FROM bu_esg_work.gloval_aux2_jun24 as aux2
left join (Select * from cd_garantias.gt009_bens_imov where ref_date= "${ref_date}") as GT009

on concat(aux2.cempbem, aux2.ckbalbem, aux2.ckctabem, aux2.ckrefbem)=concat(GT009.cempbem, GT009.ckbalbem, GT009.ckctabem, GT009.ckrefbem)


left join
(SELECT distinct a.*  FROM (
                select distinct * from cd_garantias.cst08_caucbem where data_date_part = "${ref_date_util}") a -- JB(01/07/24): Alterado para dia útil
                inner join (select ckbalcao, cknumcta, zbem, zcaucao, max(davalia) as davalia
                            from cd_garantias.cst08_caucbem 
                            where data_date_part in (select max(data_date_part) from cd_garantias.cst08_caucbem where data_date_part <= "${ref_date}")
                            and davalia<>'0001-01-01'
                            group by 1,2,3,4) as b 
                on a.ckbalcao = b.ckbalcao
                and a.cknumcta = b.cknumcta
                and a.zbem = b.zbem
                and a.zcaucao = b.zcaucao
                and a.davalia = b.davalia) as CST08
				
on aux2.ckbalbem = CST08.ckbalcao 
and aux2.ckctabem = CST08.cknumcta
and cast(substr(aux2.ckrefbem,1,10) as int) = CST08.zcaucao
and cast(substr(aux2.ckrefbem,11,5) as int) = CST08.zbem
;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------- Cruzamento da tabela de cima com a TAT91 para obter nome de distrito, concelho, freguesia, finalidade_bem e nome_conservatoria-----------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Universo alinhado com universo MS (por chave processo e por chave garantia)
--784 825
--HF(03/01/24) - DEZ - 761.144 linhas
--JB(01/07/24) - JUN - 366.749 linhas 

drop table if exists bu_esg_work.gloval_aux4_jun24;
create table bu_esg_work.gloval_aux4_jun24 as
Select distinct
		aux3.cempresp,
		aux3.ckbalres,
		aux3.ckctares,
		aux3.ckrefresp,
		aux3.cempbem,
		aux3.ckbalbem,
		aux3.ckctabem,
		aux3.ckrefbem,
		aux3.ckbalcao,
		aux3.cknumcta,
		aux3.comp_id_gar,
        aux3.codigo_banco,
        --chave_gloval as chave_gloval,										--Pendente de criação da tabela depara_chave_imoveis na bu_esg_work
        aux3.codigo_distrito,
        coalesce(TAT91a.tayd91c0_gelemtab,'') as nombre_distrito, 
        aux3.codigo_concejo,
        coalesce(TAT91b.tayd91c0_gelemtab,'') as nombre_concejo, 
        aux3.codigo_freguesia,
        coalesce(TAT91c.tayd91c0_gelemtab,'') as nombre_freguesia,
        aux3.localidade,
		aux3.tipo_via,
        coalesce(TAT91f.tayd91c0_gelemtab, '') as nombre_tipo_via,
        aux3.nombre_via,
        aux3.numero_via,
        aux3.lote,
        aux3.urbanizacion,
        coalesce(TAT91f.tayd91c0_gelemtab, '') as caglurb, 					--Validar com DE se faz sentido este campo estar igual ao campo nombre_tipo_via
        --'' as resto_direccion,
        --'' as latitud,
        --'' as longitud,
        aux3.codigo_postal,
        aux3.subcodigo_postal,
        --'' as superficie_util, 
        --'' as anio_construccion,
        aux3.tipo_inmueble_habitacao,        
        aux3.piso_apartamento,        
        aux3.casa_unifamiliar,
        aux3.tipo_inmueble_comercio_servicos,
        coalesce(TAT91e.tayd91c0_gelemtab,'') as nome_conservatoria,
        aux3.cod_conservatoria,
        --'' as registro_conservatoria,
        aux3.art_matriciais,
        --'' as fraccao_autonoma,
        coalesce(TAT91d.tayd91c0_gelemtab,'') as finalidade_bem,
        --''  as class_gpt31,
        aux3.resto_direccion,
        aux3.registro_conservatoria
		
FROM bu_esg_work.gloval_aux3_jun24 as aux3

Left join (select * from cd_estruturais.tat91_tabelas
where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}")and tayd91c0_ctabela = 'J48') as TAT91a
on concat(aux3.codigo_distrito,'0000')=trim(TAT91a.tayd91c0_celemtab)

Left join (select * from cd_estruturais.tat91_tabelas
where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}")and tayd91c0_ctabela = 'J48') as TAT91b
on concat(aux3.codigo_distrito,aux3.codigo_concejo,'00')=trim(TAT91b.tayd91c0_celemtab)

Left join (select * from cd_estruturais.tat91_tabelas
where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}")and tayd91c0_ctabela = 'J48') as TAT91c
on concat(aux3.codigo_distrito,aux3.codigo_concejo,aux3.codigo_freguesia)=trim(TAT91c.tayd91c0_celemtab)

left join ( SELECT * FROM cd_estruturais.tat91_tabelas
where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}")and tayd91c0_ctabela = '438') as TAT91d
on trim(aux3.finalidade_bem) = trim(TAT91d.tayd91c0_celemtab)

left join ( SELECT * FROM cd_estruturais.tat91_tabelas
where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}")and tayd91c0_ctabela = '190') as TAT91e
on trim(aux3.cod_conservatoria) = trim(TAT91e.tayd91c0_celemtab)

left join (select * from cd_estruturais.tat91_tabelas
where data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}") and tayd91c0_ctabela = '437') as TAT91f
on aux3.tipo_via = TAT91f.tayd91c0_celemtab;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Cruzamento da tabela de cima com a GPT32 para obter nombre_tipo_via, caglurb, ---------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Universo alinhado com universo MS (por chave processo e por chave garantia)
--784 825
--HF(03/01/24) - DEZ - 761.144 linhas
--JB(01/07/24) - JUN - 366.749 linhas 

drop table if exists bu_esg_work.gloval_aux5_jun24;
create table bu_esg_work.gloval_aux5_jun24 as
Select distinct
		aux4.cempresp,
		aux4.ckbalres,
		aux4.ckctares,
		aux4.ckrefresp,
		aux4.cempbem,
		aux4.ckbalbem,
		aux4.ckctabem,
		aux4.ckrefbem,
		aux4.ckbalcao,
		aux4.cknumcta,
		aux4.comp_id_gar,
        aux4.codigo_banco,
        --chave_gloval as chave_gloval,										--Pendente de criação da tabela depara_chave_imoveis na bu_esg_work
        aux4.codigo_distrito,
        aux4.nombre_distrito, 
        aux4.codigo_concejo,
        aux4.nombre_concejo, 
        aux4.codigo_freguesia,
        aux4.nombre_freguesia,
        aux4.localidade,
		aux4.tipo_via,
        aux4.nombre_tipo_via,
        aux4.nombre_via,
        aux4.numero_via,
        aux4.lote,
        aux4.urbanizacion,
        aux4.caglurb, 
        aux4.resto_direccion,
        aux4.registro_conservatoria,        
        --'' as latitud,
        --'' as longitud,
        aux4.codigo_postal,
        aux4.subcodigo_postal,
        coalesce (cast(GPT32.narutil as string),'') as superficie_util, 
        --'' as anio_construccion,
        aux4.tipo_inmueble_habitacao,        
        aux4.piso_apartamento,        
        aux4.casa_unifamiliar,
        aux4.tipo_inmueble_comercio_servicos,
        aux4.nome_conservatoria,
        aux4.cod_conservatoria,
        --'' as registro_conservatoria,
        aux4.art_matriciais,
        --'' as fraccao_autonoma,
        aux4.finalidade_bem
        --''  as class_gpt31
		
FROM bu_esg_work.gloval_aux4_jun24 as aux4

left join 
(
    select * 
    from bu_esg_work.gpt32_bemimove_jun24
) as GPT32
on  concat(GPT32.ckbalbem, GPT32.ckctabem) = substring(aux4.codigo_banco,1,15)
	
;	

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------ Cruzamento da tabela de cima com a GPT18 e GPT14 para informação adicional no caso dos campos que não cruzaram com a tabela GPT32 ---------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Universo alinhado com universo MS (por chave processo e por chave garantia)
--782 720
--HF(03/01/24) - DEZ - 761.333 linhas
--JB(01/07/24) - JUN - 366.834 linhas 

drop table if exists bu_esg_work.gloval_aux6_jun24;
create table bu_esg_work.gloval_aux6_jun24 as
Select  distinct 
		aux5.cempresp,
		aux5.ckbalres,
		aux5.ckctares,
		aux5.ckrefresp,
		aux5.cempbem,
		aux5.ckbalbem,
		aux5.ckctabem,
		aux5.ckrefbem,
		aux5.ckbalcao,
		aux5.cknumcta,
		aux5.comp_id_gar,
        aux5.codigo_banco,
        --chave_gloval as chave_gloval,										--Pendente de criação da tabela depara_chave_imoveis na bu_esg_work
        aux5.codigo_distrito,
        aux5.nombre_distrito, 
        aux5.codigo_concejo,
        aux5.nombre_concejo, 
        aux5.codigo_freguesia, 
        aux5.nombre_freguesia,
        --if(aux5.localidade is not null,aux5.localidade, GPT18.glocal) as localidade,
		--if(aux5.tipo_via is not null, aux5.tipo_via, GPT18.cmorada) as tipo_via,
        aux5.localidade,
		aux5.tipo_via,		
        aux5.nombre_tipo_via,
        -- if(aux5.nombre_via is not null, aux5.nombre_via, GPT18.gmorada) as nombre_via,
        -- if(aux5.numero_via is not null, aux5.numero_via, GPT18.znum) as numero_via,
        -- if(aux5.lote is not null, aux5.lote, GPT18.zlote) as lote,
        aux5.nombre_via,
        aux5.numero_via,
        aux5.lote,        
        aux5.urbanizacion,
        aux5.caglurb, 
        aux5.resto_direccion,
        '' as latitud,
        '' as longitud,
        aux5.codigo_postal,
        aux5.subcodigo_postal,
        aux5.superficie_util, 
        --coalesce(GPT18.anoconst,'') as anio_construccion,
        aux5.tipo_inmueble_habitacao,        
        aux5.piso_apartamento,        
        aux5.casa_unifamiliar,
        aux5.tipo_inmueble_comercio_servicos,
        aux5.nome_conservatoria,
        coalesce(GPT14b.codconsv,aux5.cod_conservatoria) as cod_conservatoria,
        aux5.registro_conservatoria,
        aux5.art_matriciais,
        coalesce(GPT14a.gfraccao,'') as fraccao_autonoma,
        aux5.finalidade_bem
        --''  as class_gpt31
		
FROM bu_esg_work.gloval_aux5_jun24 as aux5

left join   
        (
			SELECT ckbalbem, ckctabem, gfraccao
			FROM
			  (SELECT ROW_NUMBER () OVER (PARTITION BY cempbem,ckbalbem,ckctabem
			                              ORDER BY gfraccao DESC) AS ORDEM,
			            cempresa,
			            ckbalcao,
			            cknumcta,
			            max_zversao,
			            cempbem,
			            ckbalbem,
			            ckctabem,
			            gfraccao
			   FROM
			        (
				        select cempresa,ckbalcao,cknumcta,max(zversao) as max_zversao,cempbem,ckbalbem,ckctabem,gfraccao
				        from cd_emprestimos.gpt14_registos
				        where data_date_part in (select max(data_date_part) from cd_emprestimos.gpt14_registos where data_date_part <= "${ref_date}")
				                and trim(gfraccao) not like ''
				        group by cempresa,ckbalcao,cknumcta,cempbem,ckbalbem,ckctabem,gfraccao
			        ) BL 
			    ) FS_2
			WHERE ORDEM = 1
        ) as GPT14a
on  aux5.ckbalbem = GPT14a.ckbalbem
and aux5.ckctabem = GPT14a.ckctabem

left join   
        (
			SELECT ckbalbem,ckctabem,codconsv
			FROM
			  (SELECT ROW_NUMBER () OVER (PARTITION BY ckbalbem,ckctabem
			                              ORDER BY ckbalcao,zversao DESC) AS ORDEM,
			            ckbalbem,
			            ckctabem,
			            codconsv
			   FROM
			        (
			            SELECT A.ckbalcao,A.zversao,A.cknumcta,A.ckbalbem,A.ckctabem,A.codconsv
			            FROM 
			            (
			                select ckbalcao,cknumcta,zversao,ckbalbem,ckctabem,codconsv
			                from cd_emprestimos.gpt14_registos
			                where data_date_part in (select max(data_date_part) from cd_emprestimos.gpt14_registos where data_date_part <= "${ref_date}") and
			                        trim(codconsv) not like '' AND trim(codconsv) <> '999' 
			            ) A
			            LEFT JOIN
			            (
			                select cempresa,ckbalcao,cknumcta,zseqver
			                from cd_emprestimos.gpt21_processos
			                where data_date_part in (select max(data_date_part) from cd_emprestimos.gpt14_registos where data_date_part <= "${ref_date}")
			            ) B
			            ON CONCAT(A.ckbalcao,A.cknumcta,cast(A.zversao as string))=CONCAT(B.ckbalcao,B.cknumcta,cast(B.zseqver as string))
			        ) BL 
			    ) FS_2
			WHERE ORDEM = 1
        ) as GPT14b
on  aux5.ckbalbem = GPT14b.ckbalbem
and aux5.ckctabem = GPT14b.ckctabem
;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Popular campo gpt31 --> Averiguar pertinência de fazê-lo com DE--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Universo alinhado com universo MS (por chave processo e por chave garantia)
--782 720
--HF(03/01/24) - DEZ - 761.333 linhas
--JB(01/07/24) - JUN - 366.834 linhas

drop table if exists bu_esg_work.gloval_aux7_jun24;
create table bu_esg_work.gloval_aux7_jun24 as
Select  distinct
		aux6.cempresp,
		aux6.ckbalres,
		aux6.ckctares,
		aux6.ckrefresp,
		aux6.cempbem,
		aux6.ckbalbem,
		aux6.ckctabem,
		aux6.ckrefbem,
		aux6.ckbalcao,
		aux6.cknumcta,
		aux6.comp_id_gar,
		aux6.codigo_banco,
        --chave_gloval as chave_gloval,										--Pendente de criação da tabela depara_chave_imoveis na bu_esg_work
        aux6.codigo_distrito,
        aux6.nombre_distrito, 
        aux6.codigo_concejo,
        aux6.nombre_concejo, 
        aux6.codigo_freguesia, 
        aux6.nombre_freguesia,
        aux6.localidade,
		aux6.tipo_via,
        aux6.nombre_tipo_via,
        aux6.nombre_via,
        aux6.numero_via,
        aux6.lote,
        aux6.urbanizacion,
        aux6.caglurb, 
        aux6.resto_direccion,
        '' as latitud,
        '' as longitud,
        aux6.codigo_postal,
        aux6.subcodigo_postal,
        aux6.superficie_util, 
        --aux6.anio_construccion,
        aux6.tipo_inmueble_habitacao,        
        aux6.piso_apartamento,        
        aux6.casa_unifamiliar,
        aux6.tipo_inmueble_comercio_servicos,
        aux6.nome_conservatoria,
        aux6.cod_conservatoria,
        aux6.registro_conservatoria,
        aux6.art_matriciais,
        aux6.fraccao_autonoma,
        aux6.finalidade_bem,
		coalesce(GPT31.class_gpt31,'') as class_gpt31

from bu_esg_work.gloval_aux6_jun24 as aux6

left join
(select  a.*, Coalesce(b.flag_ienerg,'') AS CLASS_GPT31
        from (select * from bu_esg_work.gloval_aux6_jun24) as a
        inner join (select distinct ckbalcao, cknumcta, zversao,
                            case
                                when trim(ienerg) in ('A','+') then 'A'
                                when trim(ienerg) in ('B','-') then 'B'
                                when trim(ienerg) in ('C') then 'C'
                                when trim(ienerg) in ('D') then 'D'
                                when trim(ienerg) in ('E') then 'E'
                                when trim(ienerg) in ('F') then 'F'
                                when trim(ienerg) in ('G') then 'G'
                                else ''
                            end as flag_ienerg
                   from 
                       (
                         select *
                         from bu_esg_work.gpt31_contrato_jun24
                        ) GPT31
                   ) as b
        on  a.ckbalcao = b.ckbalcao
        and a.cknumcta = b.cknumcta
        and cast(a.comp_id_gar as int) = b.zversao
        where flag_ienerg <> ''
) as GPT31
on aux6.cempresp = GPT31.cempresp
and aux6.ckbalres = GPT31.ckbalres
and aux6.ckctares = GPT31.ckctares
and aux6.ckrefresp = GPT31.ckrefresp
and aux6.ckbalcao = GPT31.ckbalcao
and aux6.cknumcta = GPT31.cknumcta
and aux6.comp_id_gar = GPT31.comp_id_gar
and aux6.cempbem = GPT31.cempbem
and aux6.ckbalbem = GPT31.ckbalbem
and aux6.ckctabem = GPT31.ckctabem
and aux6.ckrefbem = GPT31.ckrefbem
;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Popular campo anio_construccion e chave_gloval --> Averiguar pertinência de fazê-lo com DE-----------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert overwrite table  bu_esg_work.p3_gloval partition (ref_date/*,perimetro)*/)
--drop table if exists bu_esg_work.gloval_aux8_jun24;
--create table bu_esg_work.gloval_aux8_jun24 as
Select
		aux7.codigo_banco,
        --chave_gloval as chave_gloval,										--Pendente de criação da tabela depara_chave_imoveis na bu_esg_work
		concat(aux7.codigo_distrito,'0000') as codigo_distrito, 
        aux7.nombre_distrito, 
        concat(aux7.codigo_distrito,aux7.codigo_concejo,'00') as codigo_concejo,
        aux7.nombre_concejo,		
        concat(aux7.codigo_distrito,aux7.codigo_concejo,aux7.codigo_freguesia) as codigo_freguesia, 
        aux7.nombre_freguesia,
        aux7.localidade,
		aux7.tipo_via,
        aux7.nombre_tipo_via,
        aux7.nombre_via,
        aux7.numero_via,
        aux7.lote,
        aux7.urbanizacion,
        aux7.caglurb, 
        aux7.resto_direccion,
        '' as latitud,
        '' as longitud,
        aux7.codigo_postal,
        aux7.subcodigo_postal,
        aux7.superficie_util as assuperficie_util, 
        coalesce(min(GPT18.anoconst),'') as anio_construccion,
        aux7.tipo_inmueble_habitacao,        
        aux7.piso_apartamento,        
        aux7.casa_unifamiliar,
        aux7.tipo_inmueble_comercio_servicos,
        aux7.nome_conservatoria,
        aux7.cod_conservatoria,
        aux7.registro_conservatoria,
        aux7.art_matriciais,
        aux7.fraccao_autonoma,
        aux7.finalidade_bem,
		case when xx.class_gpt31 = '99999' then '' else xx.class_gpt31 end as class_gpt31,
		'' as class_stclim,
		'' as conf_stclim,
		from_unixtime(unix_timestamp()) as htimest,
      --partition
      '${date}' as ref_date/*, '${perimetro}' as nome_perimetro*/

from bu_esg_work.gloval_aux7_jun24 as aux7
left join 
(
    select distinct *
    from cd_emprestimos.gpt18_bens
    where data_date_part = '${ref_date_util}' and trim(anoconst) <> ''
) as GPT18
on  aux7.ckbalcao    = GPT18.ckbalcao
and aux7.cknumcta    = GPT18.cknumcta
and cast(aux7.comp_id_gar as int) = GPT18.zversao
and aux7.ckbalbem    = GPT18.ckbalbem
and aux7.ckctabem    = GPT18.ckctabem 
left join
(
    select ckbalbem,ckctabem,ckrefbem,class_gpt31 from
    (
        select row_number() OVER(PARTITION BY ckbalbem,ckctabem,ckrefbem ORDER BY class_gpt31 desc) as rnumber,*
        from
        (
        	SELECT DISTINCT 
        	     ckbalbem, 
        	     ckctabem, 
        	     ckrefbem, 
        	     case 
        	        when trim(class_gpt31) = '' then '99999' 
        	     else trim(class_gpt31) 
        	     end as class_gpt31
        	FROM bu_esg_work.gloval_aux7_jun24 
        )GPT31
    )x
    where rnumber = 1
) xx
on concat(aux7.ckbalbem,aux7.ckctabem,aux7.ckrefbem) = concat(xx.ckbalbem,xx.ckctabem,xx.ckrefbem)
group by aux7.codigo_banco,
        --chave_gloval as chave_gloval,										--Pendente de criação da tabela depara_chave_imoveis na bu_esg_work
        aux7.codigo_distrito,
        aux7.nombre_distrito, 
        aux7.codigo_concejo,
        aux7.nombre_concejo, 
        aux7.codigo_freguesia, 
        aux7.nombre_freguesia,
        aux7.localidade,
		aux7.tipo_via,
        aux7.nombre_tipo_via,
        aux7.nombre_via,
        aux7.numero_via,
        aux7.lote,
        aux7.urbanizacion,
        aux7.caglurb, 
        aux7.resto_direccion,
        aux7.codigo_postal,
        aux7.subcodigo_postal,
        aux7.superficie_util,
        aux7.tipo_inmueble_habitacao,        
        aux7.piso_apartamento,        
        aux7.casa_unifamiliar,
        aux7.tipo_inmueble_comercio_servicos,
        aux7.nome_conservatoria,
        aux7.cod_conservatoria,
        aux7.registro_conservatoria,
        aux7.art_matriciais,
        aux7.fraccao_autonoma,
        aux7.finalidade_bem,
        case when xx.class_gpt31 = '99999' then '' else xx.class_gpt31 end
	
	
;

------------------------------------------------------------------------------------------------------------------
-- TABELA HISTORICO ENVIADA À GLOVAL A DEZ23                                                                    --
-- fiabilidad not in ('1-REAL','2-MUY ALTA','3-ALTA','SANTANDER')                                               --
------------------------------------------------------------------------------------------------------------------
--160.459 
--drop table bu_esg_work.extracao_gloval1;
--create table bu_esg_work.extracao_gloval1 as

select 
kt.chave_gloval_enviada,
replace(jun24.codigo_distrito,";"," ") as codigo_distrito,
replace(jun24.nombre_distrito,";"," ") as nombre_distrito,
replace(jun24.codigo_concejo,";"," ") as codigo_concejo,
replace(jun24.nombre_concejo,";"," ") as nombre_concejo,
replace(jun24.codigo_freguesia,";"," ") as codigo_freguesia,
replace(jun24.nombre_freguesia,";"," ") as nombre_freguesia,
replace(jun24.localidade,";"," ") as localidade,
replace(jun24.tipo_via,";"," ") as tipo_via,
replace(jun24.nombre_tipo_via,";"," ") as nombre_tipo_via,
replace(jun24.nombre_via,";"," ") as nombre_via,
replace(jun24.numero_via,";"," ") as numero_via,
replace(jun24.lote,";"," ") as lote,
replace(jun24.urbanizacion,";"," ") as urbanizacion,
replace(jun24.caglurb,";"," ") as caglurb,
replace(jun24.resto_direccion,";"," ") as resto_direccion,
replace(jun24.latitud,";"," ") as latitud,
replace(jun24.longitud,";"," ") as longitud,
replace(jun24.codigo_postal,";"," ") as codigo_postal,
replace(jun24.subcodigo_postal,";"," ") as subcodigo_postal,
replace(jun24.assuperficie_util,";"," ") as assuperficie_util,
replace(jun24.anio_construccion,";"," ") as anio_construccion,
jun24.tipo_inmueble_habitacao,
jun24.piso_apartamento,
jun24.casa_unifamiliar,
jun24.tipo_inmueble_comercio_servicos,
replace(jun24.nome_conservatoria,";"," ") as nome_conservatoria,
replace(jun24.cod_conservatoria,";"," ") as cod_conservatoria,
replace(jun24.registro_conservatoria,";"," ") as registro_conservatoria,
replace(jun24.art_matriciais,";"," ") as art_matriciais,
replace(jun24.fraccao_autonoma,";"," ") as fraccao_autonoma,
replace(jun24.finalidade_bem,";"," ") as finalidade_bem,
replace(jun24.class_gpt31,";"," ") as class_gpt31,
replace(jun24.class_stclim,";"," ") as class_stclim,
replace(jun24.conf_stclim,";"," ") as conf_stclim

from 

--UNIVERSO DE JUNHO
(select * from bu_esg_work.p3_gloval where ref_date = '${ref_date}') jun24

left join 

--TRADUTOR CHAVES GLOVAL PARA CHAVE BANCO
(SELECT distinct chave_gloval_enviada, chave_banco_atual
FROM bu_esg_work.kt_chave_gloval) kt


on jun24.codigo_banco = kt.chave_banco_atual

left join

--TABELA RECEBIDA DA GLOVAL A JUN23 COM: 1) INCREMENTO DE JUN23 2) ATUALIZAÇÕES DA CARTEIRA DE DEZ22
(select * from 
(SELECT row_number() over( PARTITION BY chave_gloval
ORDER BY strright(cartera,4) DESC) as rnumb,*
FROM bu_esg_work.informacao_gloval_agrupada
)a
where rnumb = 1
and fiabilidad not in ('1-REAL','2-MUY ALTA','3-ALTA','SANTANDER') 
) rev_glov

on rev_glov.chave_gloval = kt.chave_gloval_enviada

left join 

--UNIVERSO DE DEZEMBRO 22 COM FIABILIDADES BAIXAS
(SELECT distinct concat(ckbalbem, ckctabem,ckrefbem) as chave_bem
FROM bu_captools_work.rf_metricas_pilar3_ctr_v7
WHERE fiabilidad NOT IN ('1-REAL',
                         '2-MUY ALTA',
                         '3-ALTA',
                         'SANTANDER')
                         ) dez22

on jun24.codigo_banco = dez22.chave_bem

where (rev_glov.chave_gloval is not null or dez22.chave_bem is not null)
AND KT.chave_gloval_enviada IS NOT NULL



;


-------------------------------------------------------------------
--------------------------- Validações-----------------------------
-------------------------------------------------------------------

--Número de registos a Blank
select
SUM(IF(trim(codigo_distrito) in ("") or codigo_distrito is null,1,0)) as codigo_distrito
,SUM(IF(trim(nombre_distrito) in ("") or nombre_distrito is null,1,0)) as nombre_distrito
,SUM(IF(trim(codigo_concejo) in ("") or codigo_concejo is null,1,0)) as codigo_concejo
,SUM(IF(trim(nombre_concejo) in ("") or nombre_concejo is null,1,0)) as nombre_concejo
,SUM(IF(trim(codigo_freguesia) in ("") or codigo_freguesia is null,1,0)) as codigo_freguesia
,SUM(IF(trim(nombre_freguesia) in ("") or nombre_freguesia is null,1,0)) as nombre_freguesia
,SUM(IF(trim(localidade) in ("") or localidade is null,1,0)) as localidade
,SUM(IF(trim(tipo_via) in ("") or tipo_via is null,1,0)) as tipo_via
,SUM(IF(trim(nombre_tipo_via) in ("") or nombre_tipo_via is null,1,0)) as nombre_tipo_via
,SUM(IF(trim(nombre_via) in ("") or nombre_via is null,1,0)) as nombre_via
,SUM(IF(trim(numero_via) in ("") or numero_via is null,1,0)) as numero_via
,SUM(IF(trim(lote) in ("") or lote is null,1,0)) as lote
,SUM(IF(trim(urbanizacion) in ("") or urbanizacion is null,1,0)) as urbanizacion
,SUM(IF(trim(caglurb) in ("") or caglurb is null,1,0)) as caglurb
,SUM(IF(trim(resto_direccion) in ("") or resto_direccion is null,1,0)) as resto_direccion
,SUM(IF(trim(latitud) in ("") or latitud is null,1,0)) as latitud
,SUM(IF(trim(longitud) in ("") or longitud is null,1,0)) as longitud
,SUM(IF(trim(codigo_postal) in ("") or codigo_postal is null,1,0)) as codigo_postal
,SUM(IF(trim(subcodigo_postal) in ("") or subcodigo_postal is null,1,0)) as subcodigo_postal
,SUM(IF(trim(assuperficie_util) in ("") or assuperficie_util is null,1,0)) as assuperficie_util
,SUM(IF(trim(anio_construccion) in ("") or anio_construccion is null,1,0)) as anio_construccion
--,SUM(IF(tipo_inmueble_habitacao is null,1,0)) as tipo_inmueble_habitacao
--,SUM(IF(piso_apartamento is null,1,0)) as piso_apartamento
--,SUM(IF(casa_unifamiliar is null,1,0)) as casa_unifamiliar
--,SUM(IF(tipo_inmueble_comercio_servicos is null,1,0)) as tipo_inmueble_comercio_servicos
,SUM(IF(trim(nome_conservatoria) in ("") or nome_conservatoria is null,1,0)) as nome_conservatoria
,SUM(IF(trim(cod_conservatoria) in ("") or cod_conservatoria is null,1,0)) as cod_conservatoria
,SUM(IF(trim(registro_conservatoria) in ("") or registro_conservatoria is null,1,0)) as registro_conservatoria
,SUM(IF(trim(art_matriciais) in ("") or art_matriciais is null,1,0)) as art_matriciais
,SUM(IF(trim(fraccao_autonoma) in ("") or fraccao_autonoma is null,1,0)) as fraccao_autonoma
,SUM(IF(trim(finalidade_bem) in ("") or finalidade_bem is null,1,0)) as finalidade_bem
,SUM(IF(trim(class_gpt31) in ("") or class_gpt31 is null,1,0)) as class_gpt31
,SUM(IF(trim(class_stclim) in ("") or class_stclim is null,1,0)) as class_stclim
,SUM(IF(trim(conf_stclim) in ("") or conf_stclim is null,1,0)) as conf_stclim
,count(*) as Número_registos
from bu_esg_work.p3_gloval where ref_date="${ref_date}"

--Tamanho: Fazer o min e o max
select
max(length(codigo_distrito)) as codigo_distrito
,max(length(nombre_distrito)) as nombre_distrito
,max(length(codigo_concejo)) as codigo_concejo
,max(length(nombre_concejo)) as nombre_concejo
,max(length(codigo_freguesia)) as codigo_freguesia
,max(length(nombre_freguesia)) as nombre_freguesia
,max(length(localidade)) as localidade
,max(length(tipo_via)) as tipo_via
,max(length(nombre_tipo_via)) as nombre_tipo_via
,max(length(nombre_via)) as nombre_via
,max(length(numero_via)) as numero_via
,max(length(lote)) as lote
,max(length(urbanizacion)) as urbanizacion
,max(length(caglurb)) as caglurb
,max(length(resto_direccion)) as resto_direccion
,max(length(latitud)) as latitud
,max(length(longitud)) as longitud
,max(length(codigo_postal)) as codigo_postal
,max(length(subcodigo_postal)) as subcodigo_postal
,max(length(assuperficie_util)) as assuperficie_util
,max(length(anio_construccion)) as anio_construccion
--,length(tipo_inmueble_habitacao) as tipo_inmueble_habitacao
--,length(piso_apartamento) as piso_apartamento
--,length(casa_unifamiliar) as casa_unifamiliar
--,length(tipo_inmueble_comercio_servicos) as tipo_inmueble_comercio_servicos
,max(length(nome_conservatoria)) as nome_conservatoria
,max(length(cod_conservatoria))as cod_conservatoria
,max(length(registro_conservatoria)) as registro_conservatoria
,max(length(art_matriciais)) as art_matriciais
,max(length(fraccao_autonoma)) as fraccao_autonoma
,max(length(finalidade_bem)) as finalidade_bem
,max(length(class_gpt31)) as class_gpt31
,max(length(class_stclim)) as class_stclim
,max(length(conf_stclim)) as conf_stclim
--,count(*) as Número_registos
from bu_esg_work.p3_gloval where ref_date="${ref_date}"
--group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
--order by Número_registos desc

--duplicados
select * from bu_esg_work.p3_gloval
where ref_date="${ref_date}"
and codigo_banco in (select codigo_banco from (
select codigo_banco,count(codigo_banco)
from bu_esg_work.p3_gloval
where ref_date="${ref_date}"
group by 1
having count(codigo_banco)>1)xx)
order by 1
