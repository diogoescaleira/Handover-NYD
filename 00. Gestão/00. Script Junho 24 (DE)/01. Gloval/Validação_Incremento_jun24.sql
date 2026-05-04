
---------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | Validação de Incrementos e outros controlos                                                             --
---------------------------------------------------------------------------------------------------------------------
-- Neyond 2023                                                                                                     --
---------------------------------------------------------------------------------------------------------------------

-- Incremento em JUN24 na P3GLOVAL
select count(distinct codigo_banco_jun) from 
(select *,
case when A.codigo_banco_jun is null then "Exclusívo de Dezembro"
when b.codigo_banco_dez is null then "Exclusívo de Junho"
else "Comum" end as validação
from 
(select codigo_banco as codigo_banco_jun from bu_esg_work.p3_gloval where ref_date in ('2024-06-30'))A
FULL JOIN 
(select codigo_banco as codigo_banco_dez from bu_esg_work.p3_gloval where ref_date in ('2023-12-31'))B
ON A.codigo_banco_jun=b.codigo_banco_dez
having validação="Exclusívo de Junho")xx
;

-- Incremento em JUN24 na GT008
select count(distinct chave_bem_jun24) from 
(select *,
case when a.chave_bem_dez23 is null and b.chave_bem_jun24 is not null  then "Exclusívo de Junho 24"
when b.chave_bem_jun24 is null and a.chave_bem_dez23 is not null then "Exclusívo de Dezembro 23"
when a.chave_bem_dez23 is not null and b.chave_bem_jun24 is not null then "Comum"
else "Analisar" 
end as validação
from 
(select distinct concat(ckbalbem,ckctabem,ckrefbem) as chave_bem_jun24  from CD_GARANTIAS.GT008_TRZ_GT_IMV where ref_date in ('2024-06-30'))b
FULL JOIN 
(select distinct concat(ckbalbem,ckctabem,ckrefbem) as chave_bem_dez23  from CD_GARANTIAS.GT008_TRZ_GT_IMV where ref_date in ('2023-12-31'))a
--ON concat(a.ckbalbem,a.ckctabem,a.ckrefbem)=concat(b.ckbalbem,b.ckctabem,b.ckrefbem)
on a.chave_bem_jun24=b.chave_bem_dez23
having validação="Exclusívo de Junho 24"
)xx
;

-- Incremento em DEZ23 na GT008
select count(distinct chave_bem_dez23) from 
(select *,
case when A.chave_bem_jun23 is null then "Exclusívo de Dezembro 23"
when b.chave_bem_dez23 is null then "Exclusívo de Junho 23"
else "Comum" end as validação
from 
(select distinct concat(ckbalbem,ckctabem,ckrefbem) as chave_bem_dez23  from CD_GARANTIAS.GT008_TRZ_GT_IMV where ref_date in ('2023-12-31'))B
FULL JOIN 
(select distinct concat(ckbalbem,ckctabem,ckrefbem) as chave_bem_jun23  from CD_GARANTIAS.GT008_TRZ_GT_IMV where ref_date in ('2023-06-30'))A
--ON concat(a.ckbalbem,a.ckctabem,a.ckrefbem)=concat(b.ckbalbem,b.ckctabem,b.ckrefbem)
on a.chave_bem_jun23=b.chave_bem_dez23
having validação="Exclusívo de Dezembro 23")xx

---> CONTROLOS

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