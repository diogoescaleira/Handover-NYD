drop table bu_captools_work.T_03_01;
select * From bu_captools_work.T_03_01;

CREATE TABLE bu_captools_work.T_03_01 AS
SELECT

CASE
  WHEN (zx.eleg_fund_prop IN ("GF2", "CET1") AND zx.cod_contavirt = "P_23") OR (zx.empresa_intragrupo = "SANTANDER TOTTA, SGPS, SA" AND zx.cod_contavirt = "P_22") THEN "r0531 - o/w (part of) subordinated liabilities recognised as own funds"
  WHEN zx.empresa_intragrupo = "Totta Seguros - Comp. Seg. Vida, SA." AND zx.cod_contavirt = "P_22" THEN "r0350 - Structured notes"
  WHEN (zx.eleg_fund_prop NOT IN ("GF2", "CET1") OR zx.eleg_fund_prop IS NULL) AND zx.cod_contavirt = "P_23" THEN "r0120 - Secured liabilities - collateralized part (BRRD art. 44/2/b)"
  WHEN zx.cod_contavirt IN ("C_31", "C_32", "C_36") THEN "r0511 - o/w capital instruments/share capital"
  WHEN zx.cod_contavirt = "C_33" THEN "r0512 - o/w instruments ranking pari passu with ordinary shares"
  WHEN zx.empresa_intragrupo LIKE "%ATLANTES%" OR zx.empresa_intragrupo LIKE "%AZOR%" OR zx.empresa_intragrupo LIKE "%HIPOTOTTA%" THEN "r0120 - Secured liabilities - collateralized part (BRRD art. 44/2/b)"
  WHEN zx.cod_contavirt IN ("P_27.1","P_27.2","P_24") THEN "r0390 - Non-financial liabilities"
  WHEN zx.cod_contavirt = "P_30.1" THEN "r0170 - Employee liabilities (BRRD art. 44/2/g/i)"
  WHEN zx.cod_contavirt = "P_30.3" THEN "r0390 - Non-financial liabilities"
  WHEN zx.cod_contavirt = "P_20" AND zx.empresa_intragrupo IN ("BANCO SANTANDER TOTTA SA","BANCO SANTANDER TOTTA","CREDITO PREDIAL PORTUGUES") THEN "r0210 - Liabilities towards other entities of the resolution group (BRRD art. 44/2/h)"
  WHEN zx.cod_contavirt = "P_21" AND zx.empresa_intragrupo IN ("POPULAR SEGUROS - COMPANHIA DE SEGUROS, SA","GAMMA SOC TITULARIZACAO CREDITOS, SA","Totta Ireland, PLC","Totta Seguros - Comp. Seg. Vida, SA.","AEGON SANTANDER NAO VIDA PORTUGAL","AEGON SANTANDER VIDA PORTUGAL","GAMMA - SOCIEDADE DE TITULIZACAO DE CREDITOS","SANTANDER TOTTA, SGPS, SA","UNICRE") THEN "r0210 - Liabilities towards other entities of the resolution group (BRRD art. 44/2/h)"
  ELSE "r0320 - Deposits, not covered and not preferential"
END AS Line,

CASE
  WHEN csector_inst LIKE "%S128%" THEN "c006x   - Insurance firms & pension funds"
  WHEN contraparte_i_desc="particulares" THEN "c001x   - Households"
  WHEN contraparte_i_desc="outras empresas nao financeiras" AND flag_pme="1" THEN "c002x   - Micro & SME"
  WHEN contraparte_i_desc="outras empresas nao financeiras" AND (flag_pme IN("0","") OR flag_pme IS NULL) THEN "c003x   - Corporates"
  WHEN contraparte_i_desc="instituicoes de credito" THEN "c004x   - Institutions"
  WHEN contraparte_i_desc="outras instituicoes financeiras" THEN "c005x   - Other financial corporations"
  WHEN contraparte_i_desc="setor publico" THEN "c008x   - Government, central banks & supranationals"
  WHEN (contraparte_i_desc="" OR contraparte_i_desc IS NULL) AND empresa_intragrupo="Taxageste" THEN "c003x   - Corporates"
  WHEN contraparte_i_desc="" OR contraparte_i_desc IS NULL THEN "c005x   - Other financial corporations"
  ELSE ""
END AS Coluna,

CASE
  WHEN (zx.eleg_fund_prop NOT IN ("GF2", "CET1") OR zx.eleg_fund_prop IS NULL) AND zx.cod_contavirt = "P_23" THEN "Rank 20 - Ranking in insolvency (master scale)"
  WHEN zx.empresa_intragrupo LIKE "%ATLANTES%" OR zx.empresa_intragrupo LIKE "%AZOR%" OR zx.empresa_intragrupo LIKE "%HIPOTOTTA%" THEN "Rank 20 - Ranking in insolvency (master scale)"
  WHEN zx.cod_contavirt IN ("C_31", "C_32", "C_36", "C_33") THEN "Rank 1 - Ranking in insolvency (master scale)"
  WHEN (zx.eleg_fund_prop IN ("GF2", "CET1") AND zx.cod_contavirt = "P_23") OR (zx.empresa_intragrupo = "SANTANDER TOTTA, SGPS, SA" AND zx.cod_contavirt = "P_22") THEN "Rank 3 - Ranking in insolvency (master scale)"
  WHEN zx.cod_contavirt IN ("P_27.1","P_27.2","P_24", "P_30.3") OR (zx.empresa_intragrupo = "Totta Seguros - Comp. Seg. Vida, SA." AND zx.cod_contavirt = "P_22") THEN "Rank 9 - Ranking in insolvency (master scale)"
  WHEN zx.cod_contavirt = "P_20" AND zx.empresa_intragrupo IN ("BANCO SANTANDER TOTTA SA","BANCO SANTANDER TOTTA","CREDITO PREDIAL PORTUGUES") THEN ""
  WHEN zx.cod_contavirt = "P_21" AND zx.empresa_intragrupo IN ("POPULAR SEGUROS - COMPANHIA DE SEGUROS, SA","GAMMA SOC TITULARIZACAO CREDITOS, SA","Totta Ireland, PLC","Totta Seguros - Comp. Seg. Vida, SA.","AEGON SANTANDER NAO VIDA PORTUGAL","AEGON SANTANDER VIDA PORTUGAL","GAMMA - SOCIEDADE DE TITULIZACAO DE CREDITOS","SANTANDER TOTTA, SGPS, SA","UNICRE") THEN ""
  ELSE "Rank 12 - Ranking in insolvency (master scale)"
END AS Insolvency_ranking,

--zx.zdeposit as Contract_identifier,
zx.contract_id as Contract_identifier,

zx.empresa_intragrupo as Lending_entity,

zx.Identifier_of_Lending_Entity,

IF(zx.Type_of_Identifier = 'LEI code', 'LEI code', IF(zx.Type_of_Identifier IN ('zcliente', 'NIF'), 'Type of identifier, other than LEI or MFI code','')) as Type_of_Identifier,

CASE
  WHEN zx.empresa_intragrupo IN("SANTANDER TOTTA, SGPS, SA", "BANCO SANTANDER TOTTA SA") THEN "Parent"
  ELSE "Sister"
END AS Relationship_of_lending_entity_with_issuing_entity,

CASE
  WHEN zx.st_sgps_portugal_ifrs IN ("x", "E") THEN "True"
  ELSE "False"
END AS lending_included,

"Portugal" as Governing_law, -- Devia ser zx.tayd91c0_gelem30 as Governing_law,

"Not applicable (Contractual recognition of bail-in powers)" AS Contractual_recognition, --igual

zx.sum_of_saldo - nvl(zx.sum_of_mcoberto_eu,0) - nvl(zx.sum_of_mcoberto_me,0) as Outstanding_principal_amount,

IF(zx.sum_of_juros="" OR zx.sum_of_juros IS NULL,0,zx.sum_of_juros) as Accrued_interest,

CASE
  WHEN zx.tayd91c0_gelem301 ="EURO" THEN "Euro"
  When zx.tayd91c0_gelem301 ="LIBRA INGLESA" THEN "Us Dollar"
  ELSE ""
END AS Currency,


IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd')) as Issuance_date,

CASE
  WHEN (zx.eleg_fund_prop IN ("GF2", "CET1") AND zx.cod_contavirt = "P_23") OR (zx.empresa_intragrupo = "SANTANDER TOTTA, SGPS, SA" AND zx.cod_contavirt = "P_22") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.empresa_intragrupo = "Totta Seguros - Comp. Seg. Vida, SA." AND zx.cod_contavirt = "P_22" THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt IN ("C_31", "C_32", "C_36") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "C_33" THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt IN ("P_27.1","P_27.2","P_24") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "P_30.1" THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "P_30.3" THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "P_20" AND zx.empresa_intragrupo IN ("BANCO SANTANDER TOTTA SA","BANCO SANTANDER TOTTA","CREDITO PREDIAL PORTUGUES") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "P_21" AND zx.empresa_intragrupo IN ("POPULAR SEGUROS - COMPANHIA DE SEGUROS, SA","GAMMA SOC TITULARIZACAO CREDITOS, SA","Totta Ireland, PLC","Totta Seguros - Comp. Seg. Vida, SA.","AEGON SANTANDER NAO VIDA PORTUGAL","AEGON SANTANDER VIDA PORTUGAL","GAMMA - SOCIEDADE DE TITULIZACAO DE CREDITOS","SANTANDER TOTTA, SGPS, SA","UNICRE") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.empresa_intragrupo LIKE '%ATLANTES%' OR zx.empresa_intragrupo LIKE '%AZOR%' OR zx.empresa_intragrupo LIKE '%HIPOTOTTA%' THEN IF(zx.cod_contavirt IN("P_20","P_21"), IF(from_unixtime(unix_timestamp(zx.ref_date ,'yyyy-MM-dd'),'u')=5, date_add(zx.ref_date,3), IF(from_unixtime(unix_timestamp(zx.ref_date,'yyyy-MM-dd'),'u')=6, date_add(zx.ref_date,2), date_add(zx.ref_date,1))), IF(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'u')=5, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),3), IF(from_unixtime(unix_timestamp(zx.dt_emissao,'yyyy-MM-dd'),'u')=6, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),2), date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),1))))
  WHEN (zx.eleg_fund_prop NOT IN ("GF2", "CET1") OR zx.eleg_fund_prop IS NULL) AND zx.cod_contavirt = "P_23" THEN IF(zx.cod_contavirt IN("P_20","P_21"), IF(from_unixtime(unix_timestamp(zx.ref_date ,'yyyy-MM-dd'),'u')=5, date_add(zx.ref_date,3), IF(from_unixtime(unix_timestamp(zx.ref_date,'yyyy-MM-dd'),'u')=6, date_add(zx.ref_date,2), date_add(zx.ref_date,1))), IF(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'u')=5, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),3), IF(from_unixtime(unix_timestamp(zx.dt_emissao,'yyyy-MM-dd'),'u')=6, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),2), date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),1))))
  --WHEN "r0110" THEN "WORKDAY(zx.termo_estruturado,1,"1/1/2021")"
  ELSE IF(zx.cod_contavirt IN("P_20","P_21"), IF(from_unixtime(unix_timestamp(zx.ref_date ,'yyyy-MM-dd'),'u')=5, date_add(zx.ref_date,3), IF(from_unixtime(unix_timestamp(zx.ref_date,'yyyy-MM-dd'),'u')=6, date_add(zx.ref_date,2), date_add(zx.ref_date,1))), IF(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'u')=5, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),3), IF(from_unixtime(unix_timestamp(zx.dt_emissao,'yyyy-MM-dd'),'u')=6, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),2), date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),1))))
END AS Earliest_redemption_date,


IF(zx.cod_contavirt IN("P_20", "P_21"),
CASE
  WHEN (zx.eleg_fund_prop IN ("GF2", "CET1") AND zx.cod_contavirt = "P_23") OR (zx.empresa_intragrupo = "SANTANDER TOTTA, SGPS, SA" AND zx.cod_contavirt = "P_22") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.empresa_intragrupo = "Totta Seguros - Comp. Seg. Vida, SA." AND zx.cod_contavirt = "P_22" THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt IN ("C_31", "C_32", "C_36") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "C_33" THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt IN ("P_27.1","P_27.2","P_24") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "P_30.1" THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "P_30.3" THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "P_20" AND zx.empresa_intragrupo IN ("BANCO SANTANDER TOTTA SA","BANCO SANTANDER TOTTA","CREDITO PREDIAL PORTUGUES") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.cod_contavirt = "P_21" AND zx.empresa_intragrupo IN ("POPULAR SEGUROS - COMPANHIA DE SEGUROS, SA","GAMMA SOC TITULARIZACAO CREDITOS, SA","Totta Ireland, PLC","Totta Seguros - Comp. Seg. Vida, SA.","AEGON SANTANDER NAO VIDA PORTUGAL","AEGON SANTANDER VIDA PORTUGAL","GAMMA - SOCIEDADE DE TITULIZACAO DE CREDITOS","SANTANDER TOTTA, SGPS, SA","UNICRE") THEN IF(zx.cod_contavirt IN("P_20","P_21"), zx.ref_date, from_unixtime(unix_timestamp(dt_emissao ,'dd-MM-yyyy'), 'yyyy-MM-dd'))
  WHEN zx.empresa_intragrupo LIKE '%ATLANTES%' OR zx.empresa_intragrupo LIKE '%AZOR%' OR zx.empresa_intragrupo LIKE '%HIPOTOTTA%' THEN IF(zx.cod_contavirt IN("P_20","P_21"), IF(from_unixtime(unix_timestamp(zx.ref_date ,'yyyy-MM-dd'),'u')=5, date_add(zx.ref_date,3), IF(from_unixtime(unix_timestamp(zx.ref_date,'yyyy-MM-dd'),'u')=6, date_add(zx.ref_date,2), date_add(zx.ref_date,1))), IF(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'u')=5, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),3), IF(from_unixtime(unix_timestamp(zx.dt_emissao,'yyyy-MM-dd'),'u')=6, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),2), date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),1))))
  WHEN (zx.eleg_fund_prop NOT IN ("GF2", "CET1") OR zx.eleg_fund_prop IS NULL) AND zx.cod_contavirt = "P_23" THEN IF(zx.cod_contavirt IN("P_20","P_21"), IF(from_unixtime(unix_timestamp(zx.ref_date ,'yyyy-MM-dd'),'u')=5, date_add(zx.ref_date,3), IF(from_unixtime(unix_timestamp(zx.ref_date,'yyyy-MM-dd'),'u')=6, date_add(zx.ref_date,2), date_add(zx.ref_date,1))), IF(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'u')=5, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),3), IF(from_unixtime(unix_timestamp(zx.dt_emissao,'yyyy-MM-dd'),'u')=6, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),2), date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),1))))
  --WHEN "r0110" THEN "WORKDAY(zx.termo_estruturado,1,"1/1/2021")"
  ELSE IF(zx.cod_contavirt IN("P_20","P_21"), IF(from_unixtime(unix_timestamp(zx.ref_date ,'yyyy-MM-dd'),'u')=5, date_add(zx.ref_date,3), IF(from_unixtime(unix_timestamp(zx.ref_date,'yyyy-MM-dd'),'u')=6, date_add(zx.ref_date,2), date_add(zx.ref_date,1))), IF(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'u')=5, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),3), IF(from_unixtime(unix_timestamp(zx.dt_emissao,'yyyy-MM-dd'),'u')=6, date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),2), date_add(from_unixtime(unix_timestamp(zx.dt_emissao ,'dd-MM-yyyy'),'yyyy-MM-dd'),1))))
  END,
from_unixtime(unix_timestamp(zx.dt_vencim ,'dd-MM-yyyy'), 'yyyy-MM-dd')) AS Legal_Maturity,


CASE
  WHEN ((zx.eleg_fund_prop NOT IN ("GF2", "CET1") OR zx.eleg_fund_prop IS NULL) AND zx.cod_contavirt = "P_23") OR (zx.empresa_intragrupo LIKE "%ATLANTES%" OR zx.empresa_intragrupo LIKE "%AZOR%" OR zx.empresa_intragrupo LIKE "%HIPOTOTTA%") THEN "Secured"
  ELSE "Unsecured"
END AS Secured_unsecured,


"0" AS Amount_of_pledge,

"N/A" AS Gurantoor,

CASE
  WHEN (zx.eleg_fund_prop IN ("GF2", "CET1") AND zx.cod_contavirt = "P_23") OR (zx.empresa_intragrupo = "SANTANDER TOTTA, SGPS, SA" AND zx.cod_contavirt = "P_22") THEN "Structured"
  WHEN zx.empresa_intragrupo = "Totta Seguros - Comp. Seg. Vida, SA." AND zx.cod_contavirt = "P_22" THEN "Structured"
  WHEN zx.cod_contavirt IN ("C_31", "C_32", "C_36") THEN "Structured"
  WHEN zx.cod_contavirt = "C_33" THEN "Structured"
  WHEN zx.cod_contavirt IN ("P_27.1","P_27.2","P_24") THEN "Structured"
  WHEN zx.cod_contavirt = "P_30.1" THEN "Structured"
  WHEN zx.cod_contavirt = "P_30.3" THEN "Structured"
  WHEN zx.cod_contavirt = "P_20" AND zx.empresa_intragrupo IN ("BANCO SANTANDER TOTTA SA","BANCO SANTANDER TOTTA","CREDITO PREDIAL PORTUGUES") THEN "Structured"
  WHEN zx.cod_contavirt = "P_21" AND zx.empresa_intragrupo IN ("POPULAR SEGUROS - COMPANHIA DE SEGUROS, SA","GAMMA SOC TITULARIZACAO CREDITOS, SA","Totta Ireland, PLC","Totta Seguros - Comp. Seg. Vida, SA.","AEGON SANTANDER NAO VIDA PORTUGAL","AEGON SANTANDER VIDA PORTUGAL","GAMMA - SOCIEDADE DE TITULIZACAO DE CREDITOS","SANTANDER TOTTA, SGPS, SA","UNICRE") THEN "Structured"
  WHEN (zx.eleg_fund_prop NOT IN ("GF2", "CET1") OR zx.eleg_fund_prop IS NULL) AND zx.cod_contavirt = "P_23" THEN "Non-structured/Vanilla"
  WHEN zx.empresa_intragrupo LIKE '%ATLANTES%' OR zx.empresa_intragrupo LIKE '%AZOR%' OR zx.empresa_intragrupo LIKE '%HIPOTOTTA%' THEN "Non-structured/Vanilla"
  ELSE "Non-structured/Vanilla"
END AS Structured_or_Non,

"" as Amount_Internal_MREL_eligibility,

IF(zx.eleg_fund_prop="GF2","Grandgathered T2",IF(zx.eleg_fund_prop="CET1","CET1","No")) as Qualifying_own_funds,

IF(zx.SUM_of_mon_fund_prop="" OR zx.SUM_of_mon_fund_prop IS NULL,"0",zx.SUM_of_mon_fund_prop) as Amount_Included_own_funds

FROM bu_captools_work.QUERY_FOR_APPEND_TABLE_0001 as zx;
