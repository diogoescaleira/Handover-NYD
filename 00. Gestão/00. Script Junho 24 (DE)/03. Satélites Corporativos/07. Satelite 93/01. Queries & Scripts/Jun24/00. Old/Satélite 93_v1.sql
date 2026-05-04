-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Pilar 3 ESG Corporativo | Código para geração do satélite 93 (GHGE)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Desenvolvimento: Neyond 2023
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Inputs Manuais necessários garantir para a corrida do processo do satélite 93
-- Ficheiro de Emissões disponibilizado pela corporação CIB: bu_esg_work.pilar3_avg_emission_cib_jun23
-- Ficheiro de Emissões disponibilizado pela corporação Revenues&Assets: bu_esg_work.pilar3_avg_emission_rev_asset_jun23
-- Ficheiro de Emissões disponibilizado pela corporação Real Estate: bu_esg_work.pilar3_avg_emission_realstate_jun23
-- Tabelas de métricas Cliente+Contrato (rf_metricas_pilar3_ctr_cli) e Universo Full (rf_pilar3_universo_full_v3) geradas e corridas corretamente para o rácio em análise 
-- Tabela com os certificados energéticos enviados da Gloval (reparticao_garantias_final_comgloval)
-- Tabela de controlo de Gestão bu_esg_work.rf_pilar3_cdg_tabaux1_jun23 ==> Deverá ser corrido este procedimento 
-- NOTA1: bu_esg_work.gpt32_bemimove_pilar3 tem de ser corrida no final de cada mês uma vez que o histórico da tabela é apagado diariamente
-- NOTA2:Sempre que corrermos este satélite, validar se existem MC10 dentro do MasterLink para inclusão de adjudicados --> A Dez22, Jun23 e Dez23 não tinha

-- 1º Passo: Criação da tabela de suporte à identificação dos NACE nível 1 (CNAEL) e do que é 'Non-Financial Corporation' e 'Financial Corporation' - Cruzamento do Universo Full com as métricas Cliente + Contrato
-- Registos a Junho2023: 309 223 registos
-- Registos a Dezembro2023:  registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux1_dez23_1;
create table bu_esg_work.pilar3_sat93_tabaux1_dez23_1 as
select 
			'00411' as reporting_soc, 
			b.sociedade_contraparte,
			'BI00411' as cod_ajust,
			b.idcomb_satelite,
			b.setor,
			a.cempresa_ct,
			a.cbalcao_ct,
			a.cnumecta_ct,
			a.zdeposit_ct,
			a.zcliente,
			a.`93_european_union`,
			a.`15_nace_esg`, 		
			a.`33_counterparty_type`,
			a.cpais_residencia,
			b.saldo_ct * -1 as amount,					
			a.client_revenue,
			a.client_debt,
			a.`29_flag_specialised_lending`, 
			a.`51_client_own_funds` ,
			case
				when substr(a.`14_nace`,1,1) = 'A' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL1'		
				when substr(a.`14_nace`,1,1) = 'B' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL2'
				when substr(a.`14_nace`,1,1) = 'C' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL3'
				when substr(a.`14_nace`,1,1) = 'D' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL4'
				when substr(a.`14_nace`,1,1) = 'E' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL5'
				when substr(a.`14_nace`,1,1) = 'F' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL6'
				when substr(a.`14_nace`,1,1) = 'G' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL7'
				when substr(a.`14_nace`,1,1) = 'H' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL8'
				when substr(a.`14_nace`,1,1) = 'I' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL9'
				when substr(a.`14_nace`,1,1) = 'J' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL10'
				when substr(a.`14_nace`,1,1) = 'L' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL11'
				when substr(a.`14_nace`,1,1) = 'M' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL12'
				when substr(a.`14_nace`,1,1) = 'N' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL13'
				when substr(a.`14_nace`,1,1) = 'O' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL14'
				when substr(a.`14_nace`,1,1) = 'P' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL15'
				when substr(a.`14_nace`,1,1) = 'Q' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL16'
				when substr(a.`14_nace`,1,1) = 'R' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL17'
				when substr(a.`14_nace`,1,1) = 'S' and trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'
				when trim(a.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'CNAEL18'										
				else ''                                           
			end as CNAEL
			 
from (																				
				select
							sociedade_contraparte, 
							idcomb_satelite,
							cempresa_ct, 
							cbalcao_ct,
							cnumecta_ct,
							zdeposit_ct,
							'BI00411' as cod_ajust,
							sum(saldo_ct) as saldo_ct, -- Exposição igual à CT001, sem multiplicação por -1
							case 
								when idcomb_satelite like '%SC0302%' then 'FC' 		 
								when idcomb_satelite like '%SC0303%' then 'NFC'
								else ''
							end as setor
						from bu_esg_work.rf_pilar3_universo_full 
							where csatelite = 93 
								group by
									sociedade_contraparte, 
									idcomb_satelite,
									cempresa_ct, 
									cbalcao_ct,
									cnumecta_ct,
									zdeposit_ct,
									'BI00411',
									case when idcomb_satelite like '%SC0302%' then 'FC' 		 
										 when idcomb_satelite like '%SC0303%' then 'NFC' else '' end
	  ) b

	inner join bu_esg_work.rf_metricas_pilar3_ctr_cli_dez23 a	-- Tabela métricas clientes + contrato	
		on  a.cempresa_ct = b.cempresa_ct 
		and a.cbalcao_ct  = b.cbalcao_ct 
		and a.cnumecta_ct = b.cnumecta_ct 
		and a.zdeposit_ct = b.zdeposit_ct;


-- 2º Passo: Identificação do que é NACE ESG com base na parametrização que a corporação enviou. NOTA: Deverá estar igual para todos os satélites 
-- Registos a Junho2023: 309 223 registos
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux1_dez23;
create table bu_esg_work.pilar3_sat93_tabaux1_dez23 as
select t2.*, 
		case
            when trim(t2.`33_counterparty_type`) = 'outras empresas nao financeiras' and nace_esg.nace_level4 is not null then nace_esg.ID
            when trim(t2.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'NACE19010303' --PC: nace default disponibilizado pela corporação
            when trim(t2.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' and nace_esg.nace_level4 is not null then nace_esg.ID	
            when trim(t2.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' then 'NACE19010303' --PC: nace default disponibilizado pela corporação
            else ''									
        end as nace_esg	
from bu_esg_work.pilar3_sat93_tabaux1_dez23_1 as t2
	left join bu_esg_work.nace_esg_pillar3 as nace_esg								
			on concat(split_part(t2.`15_nace_esg`,".",1),split_part(t2.`15_nace_esg`,".",2),split_part(t2.`15_nace_esg`,".",3)) = trim(split_part(nace_esg.nace_level4, "-",1));

-- 3º Passo: Cálculo de emissões para os portfolios de Business Corporate Loans, Motor Vehicle Loans e Project Finance 
-- Registos a Junho23: 309 223 registos
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux2_dez23_1;
create table bu_esg_work.pilar3_sat93_tabaux2_dez23_1 as  
select  distinct 
					a.*,
					b.tayd91c0_gelem30 as country,
					c.nace_new,
					c.nace_code,
					case when `93_european_union` = 'Y' then 'EU1' else 'EU2' end as European_union,
-- Identificação do Calculation Approach  
					case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
						 when `29_flag_specialised_lending` = '1' then 'Project Finance'
					     when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
								or
							  (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
					     --when gar.cnumecta_ct is not null then 'Real Estate'
					     else '' 
					end as calculation_approach_1, 
							
-- Cálculo de Emissões para Business Corporate Loans, Equity & Bonds  ---> Segunda a corporação será tudo o que seja NFC, não tenha colateral associado e não seja Project Finance 
		-- 1º Método de cálculo - Emissões por contraparte 
		     -- A) CIB 
					GLCS_code,
					cib.emissions_scope1 as cib_scope1, -- Montante da Emissão do ficheiro da corporação
					cib.emissions_scope2 as cib_scope2, -- Montante da Emissão do ficheiro da corporação
					cib.emissions_scope3 as cib_scope3, -- Montante da Emissão do ficheiro da corporação
					total_debt, -- Total Debt do ficheiro da corporação
					total_equity, -- Total Equity do ficheiro da corporação 
					-- Emissões CIB Scope 1
					case 
						when setor = 'NFC' and GLCS_code is not null and (coalesce(cast(total_debt as decimal (30,6)),0) + coalesce(cast(total_equity as decimal (30,6)),0)) > 0 and a.amount > 0 and gar.cnumecta_ct is null 
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 				
							then (cast(cib.emissions_scope1 as decimal(30,6)) * (a.amount/1000000)) / ((coalesce(cast(total_debt as decimal (30,6)),0) + coalesce(cast(total_equity as decimal (30,6)),0)))
						else NULL end as emi_cib_scope1,

					-- Emissões CIB Scope 2
					case 
						when setor = 'NFC' and GLCS_code is not null and (coalesce(cast(total_debt as decimal (30,6)),0) + coalesce(cast(total_equity as decimal (30,6)),0)) > 0 and a.amount > 0 and gar.cnumecta_ct is null
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'	
								-- Cálculo de Emissões 												
							then (cast(cib.emissions_scope2 as decimal(30,6)) * (a.amount/1000000)) / ((coalesce(cast(total_debt as decimal (30,6)),0) + coalesce(cast(total_equity as decimal (30,6)),0)))
						else NULL end as emi_cib_scope2,

					-- Emissões CIB Scope 3
					case 
						when setor = 'NFC' and GLCS_code is not null and (coalesce(cast(total_debt as decimal (30,6)),0) + coalesce(cast(total_equity as decimal (30,6)),0)) > 0 and a.amount > 0 and gar.cnumecta_ct is null
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'	
								-- Cálculo de Emissões 														
							then (cast(cib.emissions_scope3 as decimal(30,6)) * (a.amount/1000000)) / ((coalesce(cast(total_debt as decimal (30,6)),0) + coalesce(cast(total_equity as decimal (30,6)),0)))
						else NULL end as emi_cib_scope3,	

			 -- B) Contraparte Não CIB -> Atualmente não temos informação externa nem no Banco para calcular este método (E-mail enviado à Susana Bernardo a dia 07/07/2023)
	
		-- 2º Método de cálculo -- Emissões por atividade física - Atualmente não temos informação no Banco para calcular por este método porque não tem disponível nem a energy source nem production
								-- Avaliar para próximos exercícios 

		-- 3º Método de cálculo - Emissões por atividade económica 
			 -- A) Revenues
					c.scope1 as revenue_scope1, -- Montante da Emissão do ficheiro da corporação	
					c.scope2 as revenue_scope2, -- Montante da Emissão do ficheiro da corporação
					c.scope3 as revenue_scope3, -- Montante da Emissão do ficheiro da corporação
					
					-- Emissões Atividade Económica (Revenues) Scope 1 
					case 
						when ( client_revenue > 0.01 and a.amount > 0 and setor = 'NFC' and `51_client_own_funds`> 0 and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1' and client_debt > 0) 
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then ((client_revenue/1000000) * cast(trim(c.scope1) as decimal(30,6))) * (a.amount/(client_debt + `51_client_own_funds`))  
						else null end as emi_score4_scope1,
					
					-- Emissões Atividade Económica (Revenues) Scope 2 
					case 
						when ( client_revenue > 0.01 and a.amount > 0 and setor = 'NFC' and `51_client_own_funds`> 0 and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1' and client_debt > 0)
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 	
							then ((client_revenue/1000000) * cast(trim(c.scope2) as decimal(30,6))) * (a.amount/(client_debt + `51_client_own_funds`))  
						else null end as emi_score4_scope2,
					
					-- Emissões Atividade Económica (Revenues) Scope 3 					
					case 
						when (client_revenue > 0.01 and a.amount > 0 and setor = 'NFC' and `51_client_own_funds`> 0 and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1' and client_debt > 0) 
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 	
							then ((client_revenue/1000000) * cast(trim(c.scope3) as decimal(30,6))) * (a.amount/(client_debt + `51_client_own_funds`))  
						else null end as emi_score4_scope3,		
						
			 -- B) ASSETS					
					d.scope1 as assets_scope1, -- Montante da Emissão do ficheiro da corporação
					d.scope2 as assets_scope2, -- Montante da Emissão do ficheiro da corporação
					d.scope3 as assets_scope3, -- Montante da Emissão do ficheiro da corporação
					
					-- Emissões Atividade Económica (Assets) Scope 1 
					case 
						when (a.amount > 0 and setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1') 
						         and 
						      (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
						
								-- Excluir casos de Project Finance e Motor Vehicle Loans e Business Loans que calculam Revenues 
							and 
							
							(case when (client_revenue > 0.01 and a.amount > 0 and setor = 'NFC' and `51_client_own_funds`> 0 and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1' and client_debt > 0) 
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'
											then ((client_revenue/1000000) * cast(trim(c.scope1) as decimal(30,6))) * (a.amount/(client_debt + `51_client_own_funds`))  
													else null end) is null 	
								
								then (cast(trim(d.scope1) as decimal(30,6)) * (a.amount/1000000)) else null end as emi_score5_scope1, 
																				
					-- Emissões Atividade Económica (Assets) Scope 2										
					case 
						when (a.amount > 0 and setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1') 
						         and 
						      (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
						
								-- Excluir casos de Project Finance e Motor Vehicle Loans e Business Loans que calculam Revenues 
							and 
							
							(case when (client_revenue > 0.01 and a.amount > 0 and setor = 'NFC' and `51_client_own_funds`> 0 and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1' and client_debt > 0) 
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'	
											then ((client_revenue/1000000) * cast(trim(c.scope2) as decimal(30,6))) * (a.amount/(client_debt + `51_client_own_funds`))  
													else null end) is null 	
													
								then (cast(trim(d.scope2) as decimal(30,6)) * (a.amount/1000000)) else null end as emi_score5_scope2,
					
					-- Emissões Atividade Económica (Assets) Scope 3					
					case 
						when (a.amount > 0 and setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1') 
						         and 
						      (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
						
								-- Excluir casos de Project Finance e Motor Vehicle Loans e Business Loans que calculam Revenues 
							and 
							
							(case when (client_revenue > 0.01 and a.amount > 0 and setor = 'NFC' and `51_client_own_funds`> 0 and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1' and client_debt  > 0) 
								-- Excluir casos de Project Finance e Motor Vehicle Loans - Identificar apenas calculation approach = Business Loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Business Loans'
												and `29_flag_specialised_lending`<>'1'	
											then ((client_revenue/1000000) * cast(trim(c.scope3) as decimal(30,6))) * (a.amount/(client_debt + `51_client_own_funds`))  
													else null end) is null 	
								then (cast(trim(d.scope3) as decimal(30,6)) * (a.amount/1000000)) else null end as emi_score5_scope3,
										
-- Cálculo de Emissões para Project Finance  ---> Não representativo no Banco, não está a ser calculado
-- Cálculo de Emissões para Motor Vehicle Loans  ---> Não representativo no Banco, não está a ser calculado

			-- A) SCORE 2: Estimado quando é possível obter o valor de emissões na sheet "Vehicle Loans - PCAF factor" de marca/modelo para país Portugal
			
					motor.scope1 as motor_vehicle_scope1, -- Montante da Emissão do ficheiro da corporação
					motor.scope2 as motor_vehicle_scope2, -- Montante da Emissão do ficheiro da corporação
					motor.scope3 as motor_vehicle_scope3, -- Montante da Emissão do ficheiro da corporação
  
 					case 
						when setor = 'NFC' and  tipo_viatura = 'Passenger car' and motor.Country is not null
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(motor.scope1) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score2_scope1,
 
  					case 
						when setor = 'NFC' and  tipo_viatura = 'Passenger car' and motor.Country is not null
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(motor.scope2) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score2_scope2,
 
  					case 
						when setor = 'NFC' and  tipo_viatura = 'Passenger car' and motor.Country is not null
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(motor.scope3) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score2_scope3,
 
 
 			-- B) SCORE 3: Estimado quando não é possível obter o valor de emissões na sheet "Vehicle Loans - PCAF factor" de marca/modelo para país Portugal
 
 					motor2.scope1 as motor_vehicle2_scope1, -- Montante da Emissão do ficheiro da corporação
					motor2.scope2 as motor_vehicle2_scope2, -- Montante da Emissão do ficheiro da corporação
					motor2.scope3 as motor_vehicle2_scope3, -- Montante da Emissão do ficheiro da corporação
  
 					case 
						when setor = 'NFC' and  tipo_viatura = 'Passenger car' and motor.Country is null and motor2.data_level_1 is not null
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(motor2.scope1) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score3_scope1,
 
  					case 
						when setor = 'NFC' and  tipo_viatura = 'Passenger car' and motor.Country is not null
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(motor2.scope2) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score3_scope2,
 
  					case 
						when setor = 'NFC' and  tipo_viatura = 'Passenger car' and motor.Country is not null
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(motor2.scope3) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score3_scope3,
 
  			-- C) SCORE 4: Desconhecida marca/modelo é usada uma proxy pelo tipo de veículo e country

 					avg_emiss_veh.amount_scope1 as avg_motor_vehicle_scope1, -- Montante da Emissão do ficheiro da corporação
					avg_emiss_veh.amount_scope2 as avg_motor_vehicle_scope2, -- Montante da Emissão do ficheiro da corporação
  
 					case 
						when setor = 'NFC' and motor.Country is null and motor2.data_level_1 is null and avg_emiss_veh.type is not null
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(avg_emiss_veh.amount_scope1) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score4_scope1,
 
  					case 
						when setor = 'NFC' and motor.Country is null and motor2.data_level_1 is null and avg_emiss_veh.type is not null
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(avg_emiss_veh.amount_scope2) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score4_scope2,
 

  			-- D) SCORE 5: Desconhecida marca/modelo é usada uma proxy apenas para Passenger car e apenas com disinção de elétrico e hibrido

 					avg_emiss_elect_hib.amount_scope1 as avg2_motor_vehicle_scope1, -- Montante da Emissão do ficheiro da corporação
					avg_emiss_elect_hib.amount_scope2 as avg2_motor_vehicle_scope2, -- Montante da Emissão do ficheiro da corporação
  
 					case 
						when setor = 'NFC' and motor.Country is null and motor2.data_level_1 is null and avg_emiss_veh.type is null and avg_emiss_elect_hib is not null and tipo_viatura = 'Passenger car'
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(avg_emiss_elect_hib.amount_scope1) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score4_scope1,
 
  					case 
						when setor = 'NFC' and motor.Country is null and motor2.data_level_1 is null and avg_emiss_veh.type is null and avg_emiss_elect_hib is not null and tipo_viatura = 'Passenger car'
								-- Excluir casos de Project Finance e Business Loans - Identificar apenas calculation approach = Motor vehicle loans 
								and (case when concat(ct004.cproduto,ct004.csubprod) in ('000042','000045','000051','000053','000Y45') then 'Motor vehicle loans' 
										  when `29_flag_specialised_lending` = '1' then 'Project Finance'
										  when ((setor = 'NFC' and GLCS_code is not null and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
													or
											   (setor = 'NFC' and gar.cnumecta_ct is null and `29_flag_specialised_lending`<>'1')) then 'Business Loans'
													else '' end) = 'Motor vehicle loans'
												and `29_flag_specialised_lending`<>'1'
								-- Cálculo de Emissões 																									
							then cast(trim(avg_emiss_elect_hib.amount_scope2) as decimal(30,6)) * cast(trim(avg_km.amount) as decimal(30,6)) else null end as emi_veh_score4_scope2,
 
 			 							
					-- Alocação das Source Emission finais para CIB - direto do  ficheiro da corporação o mapeamento entre o que é estimado e o que é real 
					case
						when cib.Source_scope1='Actual' then 'SOUR1'
						when cib.Source_scope1='Estimated' then 'SOUR2' 
						when cib.Source_scope1='Not Available' then 'SOUR3' end as source_emissions_scope1_cib,
					case
						when cib.Source_scope2='Actual' then 'SOUR1'
						when cib.Source_scope2='Estimated' then 'SOUR2'
						when cib.Source_scope2='Not Available' then 'SOUR3' end as source_emissions_scope2_cib,
					case
						when cib.Source_scope3='Actual' then 'SOUR1'
						when cib.Source_scope3='Estimated' then 'SOUR2'
						when cib.Source_scope3='Not Available' then 'SOUR3' end as source_emissions_scope3_cib,
						
					cib.dqs_scope1 as dqs_scope1_cib, -- Data Quality Score do ficheiro da corporação 
					cib.dqs_scope2 as dqs_scope2_cib, -- Data Quality Score do ficheiro da corporação
					cib.dqs_scope3 as dqs_scope3_cib, -- Data Quality Score do ficheiro da corporação
					c.data_quality_score as dqs_revenues,
					d.data_quality_score as dqs_assets,
					motor.data_quality_score as dqs1_motor_vehicle_loans,
					motor2.data_quality_score as dqs2_motor_vehicle_loans,
					case when motor.data_quality_score is null and motor2.data_quality_score is null and avg_emiss_veh.type is not null then '4' end as dqs3_motor_vehicle_loans,
					case when motor.data_quality_score is null and motor2.data_quality_score is null and avg_emiss_veh.type is null and avg_emiss_elect_hib is not null then '5' end as dqs4_motor_vehicle_loans
	
-- Informação da tabela gerada acima com o mapeamento da tipologia de região de acordo com o ficheiro corporativo (Economia Avançada; Economia Emergente; Membro UE)
from (select *, 
             case when cpais_residencia in ('020','036','124','344','352','376','392','410','446','554','578','630','674','702','756','158','840','826') then 'Advanced economies'
				  when cpais_residencia in ('040','056','100','191','196','203','208','233','246','250','276','300','348','372','380','428','440','442','470','528','616','620','642','703','705','724','752') then 'EU member states'
						else 'Emerging economies' end as regiao
        from bu_esg_work.pilar3_sat93_tabaux1_dez23
      ) a		  
      
-- Cruzamento com o ficheiro enviado pela corporação para definição dos Revenues (Tratamento ao NACE necessário fazer para o cruzamento)
left join (select *,
                  case when substr(nace_code,1,2) in ('01','02','03') then concat('A',substr(nace_code,2,length(nace_code)+2)) 
                       when substr(nace_code,1,1) in ('1','2','3') and substr(nace_code,2,1) ='' then concat('A',substr(nace_code,2,length(nace_code)+1)) 
                       when substr(nace_code,1,1) in ('5','6','7','8','9') and substr(nace_code,2,1) ='' then concat('B',substr(nace_code,2,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('05','06','07','08','09') then concat('B',substr(nace_code,2,length(nace_code)+2))
                       when substr(nace_code,1,2) in ('10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33') then concat('C',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('35') then concat('D',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('36','37','38','39') then concat('E',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('41','42','43') then concat('F',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('45','46','47') then concat('G',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('49','50','51','52','53') then concat('H',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('55','56') then concat('I',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('58','59','60','61','62','63') then concat('J',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('64','65','66') then concat('K',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('68') then concat('L',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('69','70','71','72','73','74','75') then concat('M',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('77','78','79','80','81','82') then concat('N',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('84') then concat('O',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('85') then concat('P',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('86','87','88') then concat('Q',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('90','91','92','93') then concat('R',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('94','95','96') then concat('S',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('97','98') then concat('T',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('99') then concat('U',substr(nace_code,1,length(nace_code)+1))   
                  end as nace_NEW
from bu_esg_work.pilar3_avg_emission_rev_asset_jun23 where functional_unit = 'Revenue') c   
		on a.regiao = c.region 
		and concat(split_part(a.`15_nace_esg`,".",1),split_part(a.`15_nace_esg`,".",2),split_part(a.`15_nace_esg`,".",3)) = concat(split_part(c.nace_NEW,".",1),split_part(c.nace_NEW,".",2))
-- Cruzamento com o ficheiro enviado pela corporação para definição dos Assets (Tratamento ao NACE necessário fazer para o cruzamento)
left join (select *,
                  case when substr(nace_code,1,2) in ('01','02','03') then concat('A',substr(nace_code,2,length(nace_code)+2)) 
                       when substr(nace_code,1,1) in ('1','2','3') and substr(nace_code,2,1) ='' then concat('A',substr(nace_code,2,length(nace_code)+1)) 
                       when substr(nace_code,1,1) in ('5','6','7','8','9') and substr(nace_code,2,1) ='' then concat('B',substr(nace_code,2,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('05','06','07','08','09') then concat('B',substr(nace_code,2,length(nace_code)+2))
                       when substr(nace_code,1,2) in ('10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33') then concat('C',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('35') then concat('D',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('36','37','38','39') then concat('E',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('41','42','43') then concat('F',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('45','46','47') then concat('G',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('49','50','51','52','53') then concat('H',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('55','56') then concat('I',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('58','59','60','61','62','63') then concat('J',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('64','65','66') then concat('K',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('68') then concat('L',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('69','70','71','72','73','74','75') then concat('M',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('77','78','79','80','81','82') then concat('N',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('84') then concat('O',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('85') then concat('P',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('86','87','88') then concat('Q',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('90','91','92','93') then concat('R',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('94','95','96') then concat('S',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('97','98') then concat('T',substr(nace_code,1,length(nace_code)+1))
                       when substr(nace_code,1,2) in ('99') then concat('U',substr(nace_code,1,length(nace_code)+1))         
                  end as nace_NEW
from bu_esg_work.pilar3_avg_emission_rev_asset_jun23 where functional_unit = 'Assets') d   
		on a.regiao = d.region 
		and concat(split_part(a.`15_nace_esg`,".",1),split_part(a.`15_nace_esg`,".",2),split_part(a.`15_nace_esg`,".",3)) = concat(split_part(d.nace_NEW,".",1),split_part(d.nace_NEW,".",2))
-- Cruzamento com o ficheiro enviado pela corporação para definição dos CIB 
left join 
( 
	select *
	from 
	(

	--LEI --1
		(select distinct corp.*, ccliente as zcliente
		from
			(
			select 'Y' as CIB, * from bu_esg_work.pilar3_avg_emission_cib_jun23
			) corp
		inner join 
			(Select distinct ccliente, clei as clei_dwt01, 	gcliente 
			from cd_clientes.dwt001_cliente where data_date_part="${ref_date}"
			and trim(clei) <> '') dwt01 --1
		on corp.lei = dwt01.clei_dwt01 
		)

	union all

	--ISIN --8
		(select distinct corp.*, coalesce(zcliente_emitente,zcliente1,zcliente2) as zcliente--,*
		from
			(
			select 'Y' as CIB, * from bu_esg_work.pilar3_avg_emission_cib_jun23
			) corp
		
		left join 
			(Select distinct zcliente_emitente, isin as isin_ct610 
			from cd_captools.ct610_titulos where ref_date="${ref_date}"
			and trim(isin) <> '')ct610 
		on corp.isin = ct610.isin_ct610
		
		left join 
			(Select distinct lpad(cast(zcliente as string),10,'0') as zcliente1, ctitisin 
			from cd_mercados.ttt35_titlgru where data_date_part="${ref_date}"
			and trim(ctitisin)<>'' and zcliente <> 0) tt35_1 --2
		on corp.isin = tt35_1.ctitisin
		
		left join 
			(Select distinct lpad(cast(zcliente as string),10,'0') as zcliente2, cisinref 
			from cd_mercados.ttt35_titlgru where data_date_part="${ref_date}"
			and trim(ctitisin)<>'' and zcliente <> 0) tt35_2 --0
		on corp.isin = tt35_2.cisinref
		having zcliente is not null
		)
		
	union all

	--KGL --171
		(select corp.*, ccliente as zcliente
		from
			(
			select 'Y' as CIB, * from bu_esg_work.pilar3_avg_emission_cib_jun23
			) corp
		inner join 
			(SELECT ccliente,gcli_kgl,centlegal,gnomelegal,cgrupo 
			from cd_riscos.rstf159_rating_interno where data_date_part = "${ref_date}"
			and trim(ccliente) not in ('','#')) cib --94
		on corp.glcs_code = cib.centlegal or corp.glcs_code = cib.cgrupo
		)
		
	union all

		(select distinct corp.*, zcliente  as zcliente
		from
			(
			select 'Y' as CIB, * from bu_esg_work.pilar3_avg_emission_cib_jun23
			) corp
		
		inner join 
			(Select distinct ct70.zcliente, ct70.zgrupo, ct71.kgl5 from 
				(Select * from cd_captools.ct070_univ_gr_cli where ref_date="${ref_date}" and tipo_relacao = 'CONTROLO') ct70
			inner join 
				(Select * from cd_captools.ct071_rwa_gr_ec where ref_date="${ref_date}" and trim(kgl5)<>'') ct71
				on ct70.zgrupo=ct71.zgrupo
			) ct71 --127
		on corp.glcs_code =  ct71.kgl5 
		)

	union all

		(select distinct corp.*, zcliente  as zcliente
		from
			(
			select 'Y' as CIB, * from bu_esg_work.pilar3_avg_emission_cib_jun23
			) corp
		inner join
			(select zcliente,cptyparent_code, cptylastparent_code from 
				(Select distinct zcliente, trim(ccli_kgl) as ccli_kgl from cd_captools.ct003_univ_cli where ref_date="${ref_date}" 
				and trim(ccli_kgl) <> '')ct03
			inner join 
				(Select * from bu_esg_work.p3_Client_Data_JQUEST ) input
				on trim(input.cpty_code) = trim(ct03.ccli_kgl)
			) kgl_ct03 --42
		on corp.glcs_code =  kgl_ct03.cptyparent_code or  corp.glcs_code =  kgl_ct03.cptylastparent_code
		)
	) union_cib
) cib
on a.zcliente = cib.zcliente
-- Cruzamento com a tabela da repartição de garantias para identificar aquilo que não tem um bem associado e por isso entra como tipologia <> 'Real Estate'
left join 
	(select  	cempresa_ct,
				cbalcao_ct,
				cnumecta_ct,
				zdeposit_ct,
				`32_type_collateral`,
				ckbalbem,
				ckctabem,
				ckrefbem
		from bu_esg_work.reparticao_garantias_final_comgloval_dez23
			where ckctabem is not null
	) gar
on concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct) = concat(gar.cempresa_ct,gar.cbalcao_ct,gar.cnumecta_ct,gar.zdeposit_ct)

left join 
	(select distinct 
                    cempresa_ct, 
                    cbalcao_ct,
                    cnumecta_ct,
                    zdeposit_ct,
                    ckbalbem,
                    ckctabem,
                    ckrefbem,                    
                    sfcs_green_activity_comgloval,
                    sfcs_tag_comgloval,
                    tipo_produto,
                    ckprodmi,
					des_combustivel,
					co2,
					case when des_detalle_lease  = 'VEICULOS PESADOS DE PASSAGEIROS' then 'Bus'
						 when des_detalle_lease in ('COMERCIAIS ATE 1600KG','COMERCIAIS DE 1601KG A 2600KG','COMERCIAIS DE 2601KG A 3500KG') then 'Light Commercial Truck'
						 when des_detalle_lease  = 'VEICULOS PESADOS DE MERCADORIAS' then 'Medium/Heavy Commercial Truck'
						 when des_detalle_lease in ('MOTOCICLOS CILINDRADA SUPERIOR A 50CM3','CICLOMOTOR OU MOTOCICLO ATÉ 50CM3') then 'Motorcycle' 
						 when des_detalle_lease = 'VEICULOS LIGEIROS DE PASSAGEIROS' then 'Passenger car'
						 
						 when des_detalle_lease  = 'REBOQUE/SEMI-REBOQUE C/MATRICULA' then 'Medium/Heavy Commercial Truck'
						 when des_detalle_lease  = 'EMPILHADOR'
						 when des_detalle_lease in ('TT ATE 1600KG','TT DE 1601KG A 2600KG','TT DE 2601KG A 3500KG') then 'Passenger car'
					else ''
					end as tipo_viatura,
					case
						 when des_combustivel in ('HIBRIDO','HIBRIDO/GASOLINA','HIBRIDO/GASOLEO') then 'Hybrid'
						 when des_combustivel = 'ELECTRICO' then 'Electric'
					end as tipo_combustivel
            from bu_esg_work.rf_pilar3_cdg_tabaux1_pilot23	
            where sfcs_tag_comgloval not in ('Sin información','No Elegible')
           ) as cdg
on  gar.cempresa_ct = cdg.cempresa_ct
and gar.cbalcao_ct  = cdg.cbalcao_ct
and gar.cnumecta_ct = cdg.cnumecta_ct
and gar.zdeposit_ct = cdg.zdeposit_ct
and coalesce(gar.ckbalbem,'') = coalesce(cdg.ckbalbem, '')
and coalesce(gar.ckctabem,'') = coalesce(cdg.ckctabem, '')
and coalesce(gar.ckrefbem,'') = coalesce(cdg.ckrefbem, '')		
-- Cruzamento com a tabela de Revenues&Assets enviada pela corporação com a TAT para identificar o país e regiões, para posterior cruzamento com a informação enviada pela Gloval
left join            
         (   select distinct 
							tayd91c0_celemtab,
							tayd91c0_gelem30,
							regiao_tat		
			    from  
        			(   select * 
        			    from bu_esg_work.pilar3_avg_emission_rev_asset_jun23 a 
        			    left join  
        			        (   select *,
										case when tayd91c0_celemtab in ('020','036','124','344','352','376','392','410','446','554','578','630','674','702','756','158','840','826') then 'Advanced economies'
											 when tayd91c0_celemtab in ('040','056','100','191','196','203','208','233','246','250','276','300','348','372','380','428','440','442','470','528','616','620','642','703','705','724','752') then 'EU member states'
												else 'Emerging economies' end as regiao_tat
								from cd_estruturais.tat91_tabelas 
        			            where tayd91c0_ctabela = '015' and data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}")
        			        ) b 
								on a.region = b.regiao_tat
        			)xrf_metricas_pilar3_ctr_cli
        ) b
on a.cpais_residencia = b.tayd91c0_celemtab
-- Cruzamento com a ct004 para apurar os Motor Vehicle Loans 
left join (select * from cd_captools.ct004_univ_cto where ref_date='${ref_date}') ct004
on concat(a.cempresa_ct,a.cbalcao_ct,a.cnumecta_ct,a.zdeposit_ct)=concat(ct004.cempresa,ct004.cbalcao,ct004.cnumecta,ct004.zdeposit)

left join (select * from bu_esg_work.pilar3_avg_emission_mot_veh_dez23 where country='Portugal') motor
on concat() = concat(data_level_3,data_level_4) -- adaptar a marca e modelo

left join (select * from bu_esg_work.pilar3_avg_emission_mot_veh_dez23 where region = 'Global') motor2
on concat() = concat(data_level_3,data_level_4) -- adaptar a marca e modelo

left join (select * from bu_esg_work.avg_km_dez23) avg_km
on cdg.tipo_viatura = avg_km.type 

left join (select * from bu_esg_work.avg_emis_fact_veh_dez23) avg_emiss_veh
on cdg.tipo_viatura = avg_emiss_veh.type 

left join (select * from bu_esg_work.avg_emis_veh_hib_elec_dez23) avg_emiss_elect_hib
on cdg.tipo_combustivel = avg_emiss_elect_hib.type 

;


-- Cálculo de emissões para os 157 casos que não calculam emissões em nenhuma das metodologias (por default caem em Assets BCL)
-- Registos a Junho2023: 157 registos
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux2_dez23_1_aux;
create table bu_esg_work.pilar3_sat93_tabaux2_dez23_1_aux as  
select  
        t1.reporting_soc,
        t1.sociedade_contraparte,
        t1.cod_ajust,
        t1.idcomb_satelite,
        t1.setor,
        t1.cempresa_ct,
        t1.cbalcao_ct,
        t1.cnumecta_ct,
        t1.zdeposit_ct,
        t1.zcliente,
        t1.`93_european_union`,
        t1.`15_nace_esg`,
        t1.`33_counterparty_type`,
        t1.cpais_residencia,
        t1.amount,
        t1.client_revenue,
        t1.client_debt,
        t1.`29_flag_specialised_lending`,
        t1.`51_client_own_funds`,
        t1.cnael,
        t1.nace_esg,
        t1.regiao,
        t1.country,
        t1.nace_new,
        t1.nace_code,
        t1.european_union,
        '157 em BCL' as calculation_approach_1,
        t1.glcs_code,
        t1.cib_scope1,
        t1.cib_scope2,
        t1.cib_scope3,
        t1.total_debt,
        t1.total_equity,
        t1.emi_cib_scope1,
        t1.emi_cib_scope2,
        t1.emi_cib_scope3,
        t1.revenue_scope1,
        t1.revenue_scope2,
        t1.revenue_scope3,
        t1.emi_score4_scope1,
        t1.emi_score4_scope2,
        t1.emi_score4_scope3,
        t1.assets_scope1,
        t1.assets_scope2,
        t1.assets_scope3,
		t1.emi_veh_score2_scope1,
		t1.emi_veh_score2_scope2,
		t1.emi_veh_score2_scope3,
		t1.emi_veh_score3_scope1,
		t1.emi_veh_score3_scope2,
		t1.emi_veh_score3_scope3,
		t1.emi_veh_score4_scope1,
		t1.emi_veh_score4_scope2,
		t1.emi_veh_score5_scope1,
		t1.emi_veh_score5_scope2,
         case 
            when t1.amount > 0 and t1.setor = 'NFC' and t1.`29_flag_specialised_lending`<>'1'    
                    then cast(t1.assets_scope1 as decimal(30,6)) * (t1.amount/1000000) 
            else null end as emi_score5_scope1,
         case 
            when t1.amount > 0 and t1.setor = 'NFC' and t1.`29_flag_specialised_lending`<>'1'    
                    then cast(t1.assets_scope2 as decimal(30,6)) * (t1.amount/1000000)
            else null end as emi_score5_scope2,      
         case 
            when t1.amount > 0 and t1.setor = 'NFC' and t1.`29_flag_specialised_lending`<>'1'    
                    then cast(t1.assets_scope3 as decimal(30,6)) * (t1.amount/1000000)
            else null end as emi_score5_scope3,
        t1.source_emissions_scope1_cib,
        t1.source_emissions_scope2_cib,
        t1.source_emissions_scope3_cib,
        t1.dqs_scope1_cib,
        t1.dqs_scope2_cib,
        t1.dqs_scope3_cib,
        t1.dqs_revenues,
        t1.dqs_assets            
        t1.dqs1_motor_vehicle_loans,
        t1.dqs2_motor_vehicle_loans,
        t1.dqs3_motor_vehicle_loans,
        t1.dqs4_motor_vehicle_loans                
from 
(
    select *
    from bu_esg_work.pilar3_sat93_tabaux2_dez23_1
) t1
left join
(
    select *
    from bu_esg_work.reparticao_garantias_final_comgloval_dez23
    where ckctabem is null
) t2
on concat(t1.cempresa_ct,t1.cbalcao_ct,t1.cnumecta_ct,t1.zdeposit_ct)=concat(t2.cempresa_ct,t2.cbalcao_ct,t2.cnumecta_ct,t2.zdeposit_ct)
left join
(
    select *
    from bu_esg_work.reparticao_garantias_final_comgloval_dez23
    where ckctabem is null and concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct,cempresa_fr012,cbalcao_fr012,cnumecta_fr012,zdeposit_fr012) in
    (
        select concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct,cempresa_fr012,cbalcao_fr012,cnumecta_fr012,zdeposit_fr012)
        from bu_esg_work.reparticao_garantias_final_comgloval_dez23
        where ckctabem is not null
    )
) t3
on concat(t1.cempresa_ct,t1.cbalcao_ct,t1.cnumecta_ct,t1.zdeposit_ct)=concat(t3.cempresa_ct,t3.cbalcao_ct,t3.cnumecta_ct,t3.zdeposit_ct)
where calculation_approach_1 = '' and t2.cnumecta_ct is not null and t3.cnumecta_ct is not null 
;

-- Junção das tabelas que contêm o cálculo de emissões de BCL + 157 (Assets BCL) 
-- Registos a Junho2023: 309 223 registos 
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux2_dez23_1_aux2;
create table bu_esg_work.pilar3_sat93_tabaux2_dez23_1_aux2 as
select t1.* from bu_esg_work.pilar3_sat93_tabaux2_dez23_1 t1
left join
(
    select *
    from bu_esg_work.reparticao_garantias_final_comgloval_dez23
    where ckctabem is null
) t2
on concat(t1.cempresa_ct,t1.cbalcao_ct,t1.cnumecta_ct,t1.zdeposit_ct)=concat(t2.cempresa_ct,t2.cbalcao_ct,t2.cnumecta_ct,t2.zdeposit_ct)
where ((calculation_approach_1 <> '') or (calculation_approach_1 = '' and t2.cnumecta_ct is null)) 
union all select * from bu_esg_work.pilar3_sat93_tabaux2_dez23_1_aux



-- 4º Passo: Assignação das flags para o cálculo de emissões  
-- Registos a Junho23: 309 223 registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux2_dez23_2;
create table bu_esg_work.pilar3_sat93_tabaux2_dez23_2 as  
select *,
------------------------------------------------------------------------------------------------------------------ Tracking de flags de mapeamento -----------------------------------------------------------------------------------------
					-- Emissões por contraparte - CIB SCOPE 1 
					case when emi_cib_scope1 is not null and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans')) then 1 else 0 end as flg_cib_scope1,					
					case when emi_cib_scope2 is not null and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans'))then 1 else 0 end as flg_cib_scope2,										
					case when emi_cib_scope3 is not null and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans'))then 1 else 0 end as flg_cib_scope3,
					-- Emissões por contraparte - NÃO CIB 
					0 as flg_ncib_scope1,
					0 as flg_ncib_scope2,
					0 as flg_ncib_scope3,					
					-- Emissões por atividade física  
					0 as flg_physical_scope1,
					0 as flg_physical_scope2,
					0 as flg_physical_scope3,		
					-- Atividade Económica  - Emissões Revenues
					case when (emi_score4_scope1 is not null) and (emi_cib_scope1 is null) and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans')) 
					    then 1 else 0 end as flg_economic_rev_scope1,
					case when (emi_score4_scope2 is not null) and (emi_cib_scope2 is null) and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans')) 
					    then 1 else 0 end as flg_economic_rev_scope2_prel,
					case when (emi_score4_scope3 is not null) and (emi_cib_scope3 is null) and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans')) 
					    then 1 else 0 end as flg_economic_rev_scope3_prel,
					-- Atividade Económica  - Emissões Assets 
					case when (emi_score5_scope1 is not null) and (emi_score4_scope1 is null and emi_cib_scope1 is null) and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans')) then 1
					else 0 end as flg_economic_asset_scope1,
					case when (emi_score5_scope2 is not null) and (emi_score4_scope2 is null and emi_cib_scope2 is null) and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans')) then 1
					else 0 end as flg_economic_asset_scope2,
					case when (emi_score5_scope3 is not null) and (emi_score4_scope3 is null and emi_cib_scope3 is null) and (calculation_approach_1 not in ('Project Finance', 'Motor vehicle loans')) then 1
					else 0	end as flg_economic_asset_scope3
					-- Atividade Económica  - Motor Vehicle Loan
					case when (emi_veh_score2_scope1 is not null) and (emi_score4_scope1 is null and emi_cib_scope1 is null and emi_score5_scope1 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg1_motor_vehi_scope1,	
					case when (emi_veh_score2_scope2 is not null) and (emi_score4_scope2 is null and emi_cib_scope2 is null and emi_score5_scope2 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg1_motor_vehi_scope2,
					case when (emi_veh_score2_scope3 is not null) and (emi_score4_scope3 is null and emi_cib_scope3 is null and emi_score5_scope3 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg1_motor_vehi_scope3,	
															
					case when (emi_veh_score3_scope1 is not null) and (emi_score4_scope1 is null and emi_cib_scope1 is null and emi_score5_scope1 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg2_motor_vehi_scope1,	
					case when (emi_veh_score3_scope2 is not null) and (emi_score4_scope2 is null and emi_cib_scope2 is null and emi_score5_scope2 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg2_motor_vehi_scope2,	
					case when (emi_veh_score3_scope3 is not null) and (emi_score4_scope3 is null and emi_cib_scope3 is null and emi_score5_scope3 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg2_motor_vehi_scope3,
																
					case when (emi_veh_score4_scope1 is not null) and (emi_score4_scope1 is null and emi_cib_scope1 is null and emi_score5_scope1 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg3_motor_vehi_scope1,														
					case when (emi_veh_score4_scope2 is not null) and (emi_score4_scope2 is null and emi_cib_scope2 is null and emi_score5_scope2 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg3_motor_vehi_scope2,
					
					case when (emi_veh_score5_scope1 is not null) and (emi_score4_scope1 is null and emi_cib_scope1 is null and emi_score5_scope1 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg4_motor_vehi_scope1,														
					case when (emi_veh_score5_scope2 is not null) and (emi_score4_scope2 is null and emi_cib_scope2 is null and emi_score5_scope2 is null) and calculation_approach_1 = 'Motor vehicle loans' then 1
					else 0 end as flg4_motor_vehi_scope2					
					
					
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
from bu_esg_work.pilar3_sat93_tabaux2_dez23_1_aux2;


-- 5º Passo: Existem casos em que no ficheiro da corporação não há informação para alguns Scopes --> forçar as flags NOTA: Validar se no próximo exercício estes casos permanecem   
-- Registos a Junho23: 309 223 registos
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux2_dez23;
create table bu_esg_work.pilar3_sat93_tabaux2_dez23 as 
select *,
       case when (flg_cib_scope1 = 1 and flg_cib_scope2 = 1 and flg_cib_scope3 = 0 and flg_economic_rev_scope3_prel = 1 ) then 0 else flg_economic_rev_scope3_prel end as flg_economic_rev_scope3,
       case when (flg_cib_scope1 = 1 and flg_cib_scope2 = 0 and flg_cib_scope3 = 1 and flg_economic_rev_scope2_prel = 1) then 0 else flg_economic_rev_scope2_prel end as flg_economic_rev_scope2
from bu_esg_work.pilar3_sat93_tabaux2_dez23_2;

	
-- 6º Passo: Tabela com o formato final de campos para Business Loans, Project Finance e Motor Vehicle Loans: Exposição + cálculo de emissões
-- 309 223 registos a Junho 2023
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux_emi_contrato_dez23;
create table bu_esg_work.pilar3_sat93_tabaux_emi_contrato_dez23 as 
select  *,
	    -- Emissões finais scope 1
		case when flg_cib_scope1 = 1 then round(coalesce(emi_cib_scope1,0),6)
-- Adicionar quando existir nCIB
-- Adicionar quando existir physical activity
			 when flg_economic_rev_scope1 =1 then round(coalesce(emi_score4_scope1,0),6)
			 when flg_economic_asset_scope1 = 1 then round(coalesce(emi_score5_scope1,0),6) 
			 when flg1_motor_vehi_scope1 = 1 then round(coalesce(emi_veh_score2_scope1,0),6) 
			 when flg2_motor_vehi_scope1 = 1 then round(coalesce(emi_veh_score3_scope1,0),6)
			 when flg3_motor_vehi_scope1 = 1 then round(coalesce(emi_veh_score4_scope1,0),6)
			 when flg4_motor_vehi_scope1 = 1 then round(coalesce(emi_veh_score5_scope1,0),6) else null end as gesi_aux_ctr,
		-- Emissões finais scope 2 
		case when flg_cib_scope2 = 1 then round(coalesce(emi_cib_scope2,0),6)
-- Adicionar quando existir nCIB
-- Adicionar quando existir physical activity
			 when flg_economic_rev_scope2 =1 then round(coalesce(emi_score4_scope2,0),6)
			 when flg_economic_asset_scope2 = 1 then round(coalesce(emi_score5_scope2,0),6) 
			 when flg1_motor_vehi_scope2 = 1 then round(coalesce(emi_veh_score2_scope2,0),6) 
			 when flg2_motor_vehi_scope2 = 1 then round(coalesce(emi_veh_score3_scope2,0),6)
			 when flg3_motor_vehi_scope2 = 1 then round(coalesce(emi_veh_score4_scope2,0),6)
			 when flg4_motor_vehi_scope2 = 1 then round(coalesce(emi_veh_score5_scope2,0),6) else null end as gesii_aux_ctr,
		-- Emissões finais scope 3 
		case when flg_cib_scope3 = 1 then round(coalesce(emi_cib_scope3,0),2)
-- Adicionar quando existir nCIB
-- Adicionar quando existir physical activity
			 when flg_economic_rev_scope3 =1 then round(coalesce(emi_score4_scope3,0),6)
			 when flg_economic_asset_scope3 = 1 then round(coalesce(emi_score5_scope3,0),6) 
			 when flg1_motor_vehi_scope3 = 1 then round(coalesce(emi_veh_score2_scope3,0),6) 
			 when flg2_motor_vehi_scope3 = 1 then round(coalesce(emi_veh_score3_scope3,0),6) else null end as gesiii_aux_ctr,
	   -- GCA finais scope 1
		case when flg_cib_scope1 = 1 then round(coalesce(amount,0),6)
-- Adicionar quando existir nCIB
-- Adicionar quando existir physical activity
			 when flg_economic_rev_scope1 =1 then round(coalesce(amount,0),6)
			 when flg_economic_asset_scope1 = 1 then round(coalesce(amount,0),6) 
			 when flg1_motor_vehi_scope1 = 1 then round(coalesce(amount,0),6) 
			 when flg2_motor_vehi_scope1 = 1 then round(coalesce(amount,0),6)
			 when flg3_motor_vehi_scope1 = 1 then round(coalesce(amount,0),6) 
			 when flg4_motor_vehi_scope1 = 1 then round(coalesce(amount,0),6) else round(coalesce(amount,0),6) end as asci_aux_ctr,
		-- GCA finais scope 2 
		case when flg_cib_scope2 = 1 then round(coalesce(amount,0),6)
-- Adicionar quando existir nCIB
-- Adicionar quando existir physical activity
			 when flg_economic_rev_scope2 =1 then round(coalesce(amount,0),6)
			 when flg_economic_asset_scope2 = 1 then round(coalesce(amount,0),6) 
			 when flg1_motor_vehi_scope2 = 1 then round(coalesce(amount,0),6) 
			 when flg2_motor_vehi_scope2 = 1 then round(coalesce(amount,0),6)
			 when flg3_motor_vehi_scope2 = 1 then round(coalesce(amount,0),6)
			 when flg4_motor_vehi_scope2 = 1 then round(coalesce(amount,0),6) else round(coalesce(amount,0),6) end as asc2_aux_ctr,
		-- GCA finais scope 3 
		case when flg_cib_scope3 = 1 then round(coalesce(amount,0),6)
-- Adicionar quando existir nCIB
-- Adicionar quando existir physical activity
			 when flg_economic_rev_scope3 =1 then round(coalesce(amount,0),6)
			 when flg_economic_asset_scope3 = 1 then round(coalesce(amount,0),6) 
			 when flg1_motor_vehi_scope3 = 1 then round(coalesce(amount,0),6) 
			 when flg2_motor_vehi_scope3 = 1 then round(coalesce(amount,0),6) else round(coalesce(amount,0),6) end as asciii_aux_ctr,
			 
		-- Data Quality Score
			-- Scope 1
		case when calculation_approach_1 is null then ''
			 when calculation_approach_1 = 'Motor vehicle loans' and flg1_motor_vehi_scope1 = 1 then dqs1_motor_vehicle_loans
			 when calculation_approach_1 = 'Motor vehicle loans' and flg2_motor_vehi_scope1 = 1 then dqs2_motor_vehicle_loans
			 when calculation_approach_1 = 'Motor vehicle loans' and flg3_motor_vehi_scope1 = 1 then dqs3_motor_vehicle_loans
			 when calculation_approach_1 = 'Motor vehicle loans' and flg4_motor_vehi_scope1 = 1 then dqs4_motor_vehicle_loans			 			 			 
			 when calculation_approach_1 = 'Project Finance' then ''	
			 when calculation_approach_1 = 'Business Loans' and flg_cib_scope1=1 then dqs_scope1_cib 
			 when calculation_approach_1 = 'Business Loans' and flg_economic_rev_scope1 =1 then dqs_revenues
			 when calculation_approach_1 = 'Business Loans' and flg_economic_asset_scope1 =1 then dqs_assets
			 when calculation_approach_1 = '157 em BCL' and flg_cib_scope1=1 then dqs_scope1_cib 
			 when calculation_approach_1 = '157 em BCL' and flg_economic_rev_scope1=1 then dqs_revenues 
			 when calculation_approach_1 = '157 em BCL' and flg_economic_asset_scope1=1 then dqs_assets 
				else '' end as dqs_scope1,
			-- Scope 2			
		case when calculation_approach_1 is null then ''
			 when calculation_approach_1 = 'Motor vehicle loans' and flg1_motor_vehi_scope2 = 1 then dqs1_motor_vehicle_loans
			 when calculation_approach_1 = 'Motor vehicle loans' and flg2_motor_vehi_scope2 = 1 then dqs2_motor_vehicle_loans
			 when calculation_approach_1 = 'Motor vehicle loans' and flg3_motor_vehi_scope2 = 1 then dqs3_motor_vehicle_loans
			 when calculation_approach_1 = 'Motor vehicle loans' and flg4_motor_vehi_scope2 = 1 then dqs4_motor_vehicle_loans
			 when calculation_approach_1 = 'Project Finance' then ''	
			 when calculation_approach_1 = 'Business Loans' and flg_cib_scope2 =1 then dqs_scope2_cib 
			 when calculation_approach_1 = 'Business Loans' and flg_economic_rev_scope2 =1 then dqs_revenues
			 when calculation_approach_1 = 'Business Loans' and flg_economic_asset_scope2 =1 then dqs_assets
			 when calculation_approach_1 = '157 em BCL' and flg_cib_scope2=1 then dqs_scope2_cib 
			 when calculation_approach_1 = '157 em BCL' and flg_economic_rev_scope2=1 then dqs_revenues 
			 when calculation_approach_1 = '157 em BCL' and flg_economic_asset_scope2=1 then dqs_assets 
				else '' end as dqs_scope2,
				
			-- Scope 3
		case when calculation_approach_1 is null then ''
			 when calculation_approach_1 = 'Motor vehicle loans' and flg1_motor_vehi_scope3 = 1 then dqs1_motor_vehicle_loans
			 when calculation_approach_1 = 'Motor vehicle loans' and flg2_motor_vehi_scope3 = 1 then dqs2_motor_vehicle_loans
			 when calculation_approach_1 = 'Project Finance' then ''	
			 when calculation_approach_1 = 'Business Loans' and flg_cib_scope3 =1 then dqs_scope3_cib 
			 when calculation_approach_1 = 'Business Loans' and flg_economic_rev_scope3 =1 then dqs_revenues
			 when calculation_approach_1 = 'Business Loans' and flg_economic_asset_scope3 =1 then dqs_assets
			 when calculation_approach_1 = '157 em BCL' and flg_cib_scope3=1 then dqs_scope3_cib 
			 when calculation_approach_1 = '157 em BCL' and flg_economic_rev_scope3=1 then dqs_revenues 
			 when calculation_approach_1 = '157 em BCL' and flg_economic_asset_scope3=1 then dqs_assets 
			 
				else '' end as dqs_scope3					
from bu_esg_work.pilar3_sat93_tabaux2_dez23;


-- REAL ESTATE 

-- 7º Passo: Cálculo de Emissões para os Real Estate: Mapeamento de flags de Real Estate para os vários métodos 
-- Registos a Junho2023: 8 811 registos (devido à desagregação dos vários colaterais por contrato)
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux_1;
create table bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux_1 as
select  distinct 
				t1.*,
				t2.ckbalbem,
				t2.ckctabem,
				t2.ckrefbem, 
				t2.ckbalcao,
				t2.cknumcta,
				t2.comp_id_gar,
				t2.narutil, 
				t2.clase_energetica,        
				pais.cfinbem,
				t3.n_bens,
				peso.peso,
				ROUND(peso.peso*amount,1) as amount_bem,
				real_estate_office.data_lvl2_info as data_lvl2_info_office,
				real_estate_office.scope1_emission_factor as scope1_emission_factor_office,
				AF,
				real_estate_office.scope2_emission_factor as scope2_emission_factor_office,
				`32_type_collateral`,
				real_estate_others.region as region_nbuilding,
				real_estate_others.asset_class as asset_class_nbuilding,
				real_estate_others.data_lvl2_info as data_lvl2_info_nbuilding,
				real_estate_others.scope1_emission_factor as scope1_emission_factor_nbuilding,
				real_estate_others.scope2_emission_factor as scope2_emission_factor_nbuilding,
				real_estate_total_floor.asset_class as asset_class_totalfloor,
				real_estate_total_floor.scope1_emission_factor as scope1_emission_factor_totalfool,
				real_estate_total_floor.scope2_emission_factor as scope2_emission_factor_totalfloor,
				real_estate_total_emitensity.data_lvl2_info as data_lvl2_info_intensity,
				real_estate_total_emitensity.scope1_emission_factor as scope1_emission_factor_intensity,
				real_estate_total_emitensity.scope2_emission_factor as scope2_emission_factor_intensity,
				real_estate_total_emitensity_eu_america_com.region as region_eu_america_com,
				real_estate_total_emitensity_eu_america_com.asset_class as asset_class_eu_america_com,
				real_estate_total_emitensity_eu_america_com.data_lvl2_info as data_lvl2_info_eu_america_com,
				real_estate_total_emitensity_eu_america_com.scope1_emission_factor as scope1_emission_factor_eu_america_com,
				real_estate_total_emitensity_eu_america_com.scope2_emission_factor as scope2_emission_factor_eu_america_com,
				real_estate_total_emitensity_eu_america.asset_class as asset_class_eu_america,
				real_estate_total_emitensity_eu_america.scope1_emission_factor as scope1_emission_factor_eu_america,
				real_estate_total_emitensity_eu_america.scope2_emission_factor as scope2_emission_factor_eu_america,
				real_estate_office_dwelling_inten.data_lvl2_info  as data_lvl2_info_dwelling,
				real_estate_office_dwelling_inten.scope1_emission_factor as scope1_emission_factor_dwelling,
				real_estate_office_dwelling_inten.scope2_emission_factor as scope2_emission_factor_dwelling,
				real_estate_total_emitensity_eu_america_3.region as region_eu_america3,
				real_estate_total_emitensity_eu_america_3.asset_class as asset_class_eu_america_3,
				real_estate_total_emitensity_eu_america_3.data_lvl2_info as data_lvl2_info_eu_america3,
				real_estate_total_emitensity_eu_america_3.scope1_emission_factor as scope1_emission_factor_eu_america3,
				real_estate_total_emitensity_eu_america_3.scope2_emission_factor as scope2_emission_factor_eu_america3,
				real_estate_total_emitensity_dwell_eu_am_res_3.asset_class as asset_class_dwell_eu_am,
				real_estate_total_emitensity_dwell_eu_am_res_3.scope1_emission_factor as scope1_emission_factor_eu_am,
				real_estate_total_emitensity_dwell_eu_am_res_3.scope2_emission_factor as scope2_emission_factor_eu_am,

-- Cálculo de Emissões para Real Estate 
    
    -- 1º Método: Actual building emissions: Não existe informação para distinguir os scopes, só temos informação dos consumos totais enviada pela Gloval ==> Não existe informação de suppliers 
            -- A) Emissions calculated from supplier-specific emission factors and energy consumption
            -- B) Emissions calculated from average emission factors respective to the energy source and energy consumption
                        
    -- 2º Método: Estimated building emissions based on floor area
            -- A) Emissions based on official building energy labels and the floor area 
                    -- Ir buscar tudo o que tenha um colateral, seja ele residencial ou comercial (real estate collaterals) + sabemos o tipo de building
                    -- Scope 1 
                    case when setor = 'NFC' and t2.ckctabem is not null and (t2.narutil is not null and t2.narutil > 0) 
											and `29_flag_specialised_lending`<> '1' 
											and (trim(clase_energetica) <> '' and clase_energetica is not null)
                                            -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities     
                                            and trim(pais.cfinbem) = '03' 
											and real_estate_office.data_lvl2_info is not null
                               then (cast(real_estate_office.scope1_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope1_building,
                    -- Scope 2
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and `29_flag_specialised_lending`<>'1'  and trim(clase_energetica) <>'' and clase_energetica is not null
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities     
                                                        and trim(pais.cfinbem) = '03' and real_estate_office.data_lvl2_info is not null
                                    then (cast(real_estate_office.scope2_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope2_building,
                                                        
                    -- Ir buscar tudo o que tenha um colateral + não sabemos o tipo de building + ser Comercial + Ser na Europa 
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1'  and trim(clase_energetica) <>'' and clase_energetica is not null
                                                        and `32_type_collateral`='COMERCIAL'
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities     
                                                        and real_estate_others.region = 'Europe'
                                                        and real_estate_others.asset_class = 'Commercial real estate'
                                                        and real_estate_others.data_lvl2_info ='Non-Residential Total'      
                                    then (cast(real_estate_others.scope1_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuilding,
                    -- Scope 2
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1'  and trim(clase_energetica) <>'' and clase_energetica is not null
                                                        and `32_type_collateral`='COMERCIAL'
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities     
                                                        and real_estate_others.region = 'Europe'
                                                        and real_estate_others.asset_class = 'Commercial real estate'
                                                        and real_estate_others.data_lvl2_info ='Non-Residential Total'      
                                    then (cast(real_estate_others.scope2_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuilding,

-- For countries outside of Europe, the US and Canada, CRE emissions must be calculated as business loans, using the PCAF factor for NACE L – Real Estate Activities    --> Falta implementar esta componente 

                    -- Ir buscar tuodo o que tenha um colateral + não sabemos o tipo de building + ser Residencial + Conhecer o país
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1'  and trim(clase_energetica) <>'' and clase_energetica is not null
                                                        and `32_type_collateral` = 'RESIDENCIAL'
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities
                                                        and real_estate_total_floor.asset_class = 'Residential Real Estate'
                                    then (cast(real_estate_total_floor.scope1_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope1_totalfloor,
                    -- Scope 2
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1'  and trim(clase_energetica) <>'' and clase_energetica is not null
                                                        and `32_type_collateral` = 'RESIDENCIAL'
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities
                                                        and real_estate_total_floor.asset_class = 'Residential Real Estate'
                                    then (cast(real_estate_total_floor.scope2_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope2_totalfloor,  
            
            -- B) Emissions based on building type and location-specific statistical data, and the floor area 
                    -- Ir buscar tudo o que tenha um colateral (residencial ou comercial) + sabemos o tipo de building + filtro floor area + filtro Emission Intensity per m²
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities                     
                                                        and trim(pais.cfinbem) = '03' and real_estate_total_emitensity.data_lvl2_info is not null
                                -- Restrição caso exista nas restrições acima, então vai levar com o maior nível de data quality score de cima 
                                    then (cast(real_estate_total_emitensity.scope1_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope1_intensity,
                    -- Scope 2               
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities                     
                                                        and trim(pais.cfinbem) = '03' and real_estate_total_emitensity.data_lvl2_info is not null
                                -- Restrição caso exista nas restrições acima, então vai levar com o maior nível de data quality score de cima 
                                    then (cast(real_estate_total_emitensity.scope2_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope2_intensity,  
                                    
                    -- Ir buscar informação de tudo o que tenha colateral + não sabemos o tipo de building + ser comercial + ser Europa 
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_com.region = 'Europe'
                                                        and real_estate_total_emitensity_eu_america_com.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_com.data_lvl2_info ='Non-Residential Total'
                                    then (cast(real_estate_total_emitensity_eu_america_com.scope1_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuilding_eur,
                    -- Scope 2                
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_com.region = 'Europe'
                                                        and real_estate_total_emitensity_eu_america_com.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_com.data_lvl2_info ='Non-Residential Total'
                                    then (cast(real_estate_total_emitensity_eu_america_com.scope2_emission_factor as decimal (30,10)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuilding_eur,   
                                    
                    -- Ir buscar informação de tudo o que tenha colateral + não sabemos o tipo de building + ser comercial + ser América do Norte - Canadá
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_com.region = 'North America' and real_estate_total_emitensity_eu_america_com.country = 'Canada'
                                                        and real_estate_total_emitensity_eu_america_com.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_com.data_lvl2_info ='All buildings'
                                    then (cast(real_estate_total_emitensity_eu_america_com.scope1_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuilding_canada,
                    -- Scope 2               
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_com.region = 'North America' and real_estate_total_emitensity_eu_america_com.country = 'Canada'
                                                        and real_estate_total_emitensity_eu_america_com.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_com.data_lvl2_info ='All buildings'
                                    then (cast(real_estate_total_emitensity_eu_america_com.scope2_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuilding_canada,
                                                        
                    -- Ir buscar informação de tudo o que tenha colateral + não sabemos o tipo de building + ser comercial + ser América do Norte - US
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_com.region = 'North America' and real_estate_total_emitensity_eu_america_com.country = 'United States of America'
                                                        and real_estate_total_emitensity_eu_america_com.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_com.data_lvl2_info ='Other'
                                    then (cast(real_estate_total_emitensity_eu_america_com.scope1_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuilding_us,
                    -- Scope 2                
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_com.region = 'North America' and real_estate_total_emitensity_eu_america_com.country = 'United States of America'
                                                        and real_estate_total_emitensity_eu_america_com.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_com.data_lvl2_info ='Other'
                                    then (cast(real_estate_total_emitensity_eu_america_com.scope2_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuilding_us,                                                            
                    
                    -- Ir buscar tuodo o que tenha um colateral + não sabemos o tipo de building + ser Residencial + Conhecer o país                    
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        and `32_type_collateral` = 'RESIDENCIAL'
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities
                                                        and real_estate_total_emitensity_eu_america.asset_class = 'Residential Real Estate'
                                    then (cast(real_estate_total_emitensity_eu_america.scope1_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuilding_res,
                    -- Scope 2                
                    case when setor = 'NFC' and t2.ckctabem is not null and t2.narutil is not null and t2.narutil > 0 and `29_flag_specialised_lending`<>'1' and (trim(clase_energetica) ='' or clase_energetica is null)
                                                        and `32_type_collateral` = 'RESIDENCIAL'
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities
                                                        and real_estate_total_emitensity_eu_america.asset_class = 'Residential Real Estate'
                                    then (cast(real_estate_total_emitensity_eu_america.scope2_emission_factor as decimal (30,29)) * t2.narutil) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuilding_res,   

                   -- 3º Método: Estimated building emissions based on number of buildings                     

                    -- Ir buscar tudo o que tenha um colateral (residencial ou comercial) + sabemos o tipo de building + filtro dwelling + filtro Emission Intensity per #                  
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities                     
                                                        and trim(pais.cfinbem) = '03' and real_estate_office_dwelling_inten.data_lvl2_info is not null
                                -- Restrição caso exista nas restrições acima, então vai levar com o maior nível de data quality score de cima 
                                    then (cast(real_estate_office_dwelling_inten.scope1_emission_factor as decimal (30,29)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope1_dwelling_intens,
                    -- Scope 2                
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities                     
                                                        and trim(pais.cfinbem) = '03' and real_estate_office_dwelling_inten.data_lvl2_info is not null                    
                                    then (cast(real_estate_office_dwelling_inten.scope2_emission_factor as decimal (30,10)) * (n_bens)) * (cast(AF as decimal(30,6))) end as emi_scope2_dwelling_intens,                   
                    
                    -- Ir buscar informação de tudo o que tenha colateral + não sabemos o tipo de building + ser comercial + ser Europa 
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_3.region = 'Europe'
                                                        and real_estate_total_emitensity_eu_america_3.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_3.data_lvl2_info ='Non-Residential Total'
                                    then (cast(real_estate_total_emitensity_eu_america_3.scope1_emission_factor as decimal (30,10)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuildings_eur,
                    -- Scope 2               
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_3.region = 'Europe'
                                                        and real_estate_total_emitensity_eu_america_3.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_3.data_lvl2_info ='Non-Residential Total'
                                    then (cast(real_estate_total_emitensity_eu_america_3.scope2_emission_factor as decimal (30,10)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuildings_eur,    
                                    
                    -- Ir buscar informação de tudo o que tenha colateral + não sabemos o tipo de building + ser comercial + ser América do Norte - Canadá
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_3.region = 'North America' and real_estate_total_emitensity_eu_america_3.country = 'Canada'
                                                        and real_estate_total_emitensity_eu_america_3.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_3.data_lvl2_info ='All buildings'
                                    then (cast(real_estate_total_emitensity_eu_america_3.scope1_emission_factor as decimal (30,29)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuildings_canada,
                    -- Scope 2
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_3.region = 'North America' and real_estate_total_emitensity_eu_america_3.country = 'Canada'
                                                        and real_estate_total_emitensity_eu_america_3.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_3.data_lvl2_info ='All buildings'
                                    then (cast(real_estate_total_emitensity_eu_america_3.scope2_emission_factor as decimal (30,29)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuildings_canada,
                                    
                    -- Ir buscar informação de tudo o que tenha colateral + não sabemos o tipo de building + ser comercial + ser América do Norte - US
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_3.region = 'North America' and real_estate_total_emitensity_eu_america_3.country = 'United States of America'
                                                        and real_estate_total_emitensity_eu_america_3.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_3.data_lvl2_info ='Other'
                                    then (cast(real_estate_total_emitensity_eu_america_3.scope1_emission_factor as decimal (30,29)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuilding_us_met3,
                    -- Scope 2
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities 
                                                        and `32_type_collateral`='COMERCIAL'
                                                        and real_estate_total_emitensity_eu_america_3.region = 'North America' and real_estate_total_emitensity_eu_america_3.country = 'United States of America'
                                                        and real_estate_total_emitensity_eu_america_3.asset_class = 'Commercial real estate'
                                                        and real_estate_total_emitensity_eu_america_3.data_lvl2_info ='Other'
                                    then (cast(real_estate_total_emitensity_eu_america_3.scope2_emission_factor as decimal (30,29)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuilding_us_met3,                                                          
                    
                    -- Ir buscar tuodo o que tenha um colateral + não sabemos o tipo de building + ser Residencial + Conhecer o país                    
                    -- Scope 1
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        and `32_type_collateral` = 'RESIDENCIAL'
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities
                                                        and real_estate_total_emitensity_dwell_eu_am_res_3.asset_class = 'Residential Real Estate'
                                    then (cast(real_estate_total_emitensity_dwell_eu_am_res_3.scope1_emission_factor as decimal (30,29)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope1_nbuilding_res_met3,
                    -- Scope 2               
                    case when setor = 'NFC' and t2.ckctabem is not null and `29_flag_specialised_lending`<>'1' 
                                                        and `32_type_collateral` = 'RESIDENCIAL'
                                                        -- and cnael = 'CNAEL11' -- NACE de Real Estate Activities
                                                        and real_estate_total_emitensity_dwell_eu_am_res_3.asset_class = 'Residential Real Estate'
                                    then (cast(real_estate_total_emitensity_dwell_eu_am_res_3.scope2_emission_factor as decimal (30,29)) * n_bens) * (cast(AF as decimal(30,6))) end as emi_scope2_nbuilding_res_met3,

-- DATA QUALITY SCORE									
                    
					real_estate_office.pcaf_dqs as dqs_office,
                    real_estate_others.pcaf_dqs as dqs_others,                                   
                    real_estate_total_floor.pcaf_dqs as dqs_totalfloor,
                    real_estate_total_emitensity.pcaf_dqs  as dqs_emintensity,
                    real_estate_total_emitensity_eu_america_com.pcaf_dqs as dqs_eu_america_com,             
                    real_estate_total_emitensity_eu_america.pcaf_dqs  as dqs_eu_america, 
                    real_estate_office_dwelling_inten.pcaf_dqs  as dqs_dwelling_intens,                           
                    real_estate_total_emitensity_eu_america_3.pcaf_dqs as dqs_eu_america3,                             
                    real_estate_total_emitensity_dwell_eu_am_res_3.pcaf_dqs as dqs_dwelling_eu_am_3												
									
-- Buscar informação à tabela construída acima filtrado por o que não tem calculation approach de PF, MVL ou BCL 
from   (
        select * 
        from bu_esg_work.pilar3_sat93_tabaux2_dez23 
        where calculation_approach_1 = '' and concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) not in 
                                            (
                                             select concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) 
                                             from bu_esg_work.pilar3_sat93_tabaux2_dez23_1_aux
                                            )
        ) t1
-- Cruzamento com a tabela da repartição de garantias para ir buscar as classes energéticas e com a GPT32 para aferir a área útil
left join
        (
           
        select  t1.cempresa_ct,
				t1.cbalcao_ct,
				t1.cnumecta_ct,
				t1.zdeposit_ct,
				t1.ckbalcao,
				t1.cknumcta,
				t1.comp_id_gar,
				t1.ckbalbem,
				t1.ckctabem,
				t1.ckrefbem,
				t1.`32_type_collateral`,
				--t2.`13_gross_carrying_amount`,
				t1.consumos,
				t1.clase_energetica,
				t1.emisiones,
				abs(t1.`13_gross_carrying_amount`)/(mavalbem) as AF, -- Rácio: (Building Loans Outstanding/Property Value at Origination)
				b.narutil -- Área Útil 
        from bu_esg_work.reparticao_garantias_final_comgloval_dez23 as t1
left join
            ( 
                select *
                from bu_esg_work.gpt32_bemimove_pilar3 --- IMPORTANTE: CORRER ESTA TABELA NO FINAL DO MÊS DO RÁCIO
            ) b 
                on t1.ckbalbem = b.ckbalbem
                and t1.ckctabem = b.ckctabem
           
        ) t2
            on t1.cempresa_ct = t2.cempresa_ct
            and t1.cbalcao_ct = t2.cbalcao_ct
            and t1.cnumecta_ct = t2.cnumecta_ct
            and t1.zdeposit_ct = t2.zdeposit_ct         

 -- Cruzamento para ir agerir a região pelo cpais (colateral)       
    left join 
        (
            select distinct cempbem,
                            ckbalbem,
                            ckctabem,
                            ckrefbem,
                            cfinbem,
                            cpais,
                            case when cpais in ('276', '040', '056', '100', '196', '191', '208', '703', '705', '724', '233', '246', '250', '300',
                                                '348', '372', '380','428','440','442','470','528','578','620','616','826','203','642','752','756','792','688','292',
                                                '008', '020','031','051','070','398','268','352','438','498','807','499','643','674','688','492','804') then 'Europe' else 'Not Europe' end as Region        
            from cd_garantias.gt009_bens_imov where ref_date = '${ref_date}'
        ) pais
            on concat(t2.ckbalbem,t2.ckctabem,t2.ckrefbem) = concat(pais.ckbalbem,pais.ckctabem,pais.ckrefbem)       
-- Cruzamento com a TAT para aferir o country alfanúmerico        
    left join            

        (   select *
            from cd_estruturais.tat91_tabelas 
            where tayd91c0_ctabela = '015' and data_date_part in (select max(data_date_part) from cd_estruturais.tat91_tabelas where data_date_part <= "${ref_date}")
        ) country 
            on pais.cpais = country.tayd91c0_celemtab
-- Cruzamento para aferir o número de buildings/bens        
    left join
        
        (
            select a.cempresa_ct,
                   a.cbalcao_ct,
                   a.cnumecta_ct,
                   a.zdeposit_ct,
                   count(distinct a.ckbalcao, a.cknumcta, a.comp_id_gar, a.ckbalbem,a.ckctabem,a.ckrefbem) as n_bens 
            from bu_esg_work.reparticao_garantias_final_comgloval_dez23 as a
            group by a.cempresa_ct,
                     a.cbalcao_ct,
                     a.cnumecta_ct,
                     a.zdeposit_ct
        ) t3
            on t1.cempresa_ct = t3.cempresa_ct
            and t1.cbalcao_ct = t3.cbalcao_ct
            and t1.cnumecta_ct = t3.cnumecta_ct
            and t1.zdeposit_ct = t3.zdeposit_ct
-- Cruzamento para quando é sabido o tipo de edificío (apenas office à data)
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23
                    where data_lvl2_info = 'Office' and functional_unit_name in ('Floor area','floor area') and trim(state_) = ''
                  ) real_estate_office
        on  country.tayd91c0_gelem30 = upper(real_estate_office.country) 
        and coalesce(t2.clase_energetica, '') = real_estate_office.epc_rating 
-- Cruzamento para o que é Commercial Real Estate e não sabemos o tipo de edifício e encontra-se dentro da Europa + Floor Area
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23 
                    where data_lvl2_info <> 'Office' and functional_unit_name in ('Floor area','floor area') and trim(state_) = '' and data_lvl2_info ='Non-Residential Total' and asset_class='Commercial real estate' 
                        and Region='Europe'
                  ) real_estate_others
        on  country.tayd91c0_gelem30 = upper(real_estate_others.country) 
        and coalesce(t2.clase_energetica, '') = real_estate_others.epc_rating 
-- Cruzamento para o que é Residencial Real Estate e não sabemos o tipo de edifício e encontra-se dentro da Europa + Floor Area
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23 
                    where functional_unit_name in ('Floor area','floor area') and trim(state_) = '' and asset_class='Residential Real Estate' and Region='Europe'
                  ) real_estate_total_floor
        on country.tayd91c0_gelem30 = upper(real_estate_total_floor.country) 
        and coalesce(t2.clase_energetica, '') = real_estate_total_floor.epc_rating 
-- Cruzamento para o que sabemos o tipo de edifício e o factor name é Emission Intensity per m² + Floor Area
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23 
                    where functional_unit_name in ('Floor area','floor area') and emission_factor_name = 'Emission Intensity per m²' and data_lvl2_info = 'Office' and trim(state_) = ''
                  ) real_estate_total_emitensity
        on country.tayd91c0_gelem30 = upper(real_estate_total_emitensity.country) 
-- Cruzamento para o que não sabemos o tipo de edifício e o factor name é Emission Intensity per m², é Commercial Real Estate e está na Europa ou América do Norte + Floor Area 
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23 
                    where (functional_unit_name in ('Floor area','floor area') and emission_factor_name = 'Emission Intensity per m²' and trim(state_) = '') and asset_class='Commercial real estate' and
                        ((Region='Europe' and data_lvl2_info ='Non-Residential Total') or (Region='North America' and data_lvl2_info ='All buildings'))
                  ) real_estate_total_emitensity_eu_america_com
        on  country.tayd91c0_gelem30 = upper(real_estate_total_emitensity_eu_america_com.country) 
-- Cruzamento para o que não sabemos o tipo de edifício e o factor name é Emission Intensity per m², não é Commercial Real Estate e não está na Europa ou América do Norte + Floor Area
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23 
                    where functional_unit_name in ('Floor area','floor area') and emission_factor_name = 'Emission Intensity per m²' and trim(state_) = '' and asset_class='Residential Real Estate'
                  ) real_estate_total_emitensity_eu_america
        on country.tayd91c0_gelem30 = upper(real_estate_total_emitensity_eu_america.country)        
-- Cruzamento para sabemos o tipo de edifício e o factor name é Emission Intensity per # + Dwelling 
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23 
                    where data_lvl2_info = 'Office' and functional_unit_name = 'Dwelling' and emission_factor_name = 'Emission Intensity per #' and trim(state_) = ''
                  ) real_estate_office_dwelling_inten
        on  country.tayd91c0_gelem30 = upper(real_estate_office_dwelling_inten.country)   
-- Cruzamento para não sabemos o tipo de edifício e o factor name é Emission Intensity per # + Dwelling é Commercial Real Estate na Europa ou América do Norte
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23 
                    where (functional_unit_name = 'Dwelling' and emission_factor_name = 'Emission Intensity per #' and trim(state_) = '') and asset_class='Commercial real estate' and
                        ((Region='Europe' and data_lvl2_info ='Non-Residential Total') or (Region='North America' and data_lvl2_info ='All buildings'))
                  ) real_estate_total_emitensity_eu_america_3
        on  country.tayd91c0_gelem30 = upper(real_estate_total_emitensity_eu_america_3.country) 
-- Cruzamento para não sabemos o tipo de edifício e o factor name é Emission Intensity per # + Dwelling é Residencial Real Estate nem na Europa nem na América do Norte
        left join ( 
                    select *
                    from bu_esg_work.pilar3_avg_emission_realstate_dez23 
                    where functional_unit_name = 'Dwelling' and emission_factor_name = 'Emission Intensity per #' and trim(state_) = '' and asset_class='Residential Real Estate'
                  ) real_estate_total_emitensity_dwell_eu_am_res_3
        on country.tayd91c0_gelem30 = upper(real_estate_total_emitensity_dwell_eu_am_res_3.country)
-- Cruzamento com a tabela de pesos 
left join 
            (select *
                from bu_esg_work.rf_pilar3_pesos_dez23) as peso
             on t2.cempresa_ct = peso.cempresa_ct
            and t2.cbalcao_ct = peso.cbalcao_ct
            and t2.cnumecta_ct = peso.cnumecta_ct
            and t2.zdeposit_ct = peso.zdeposit_ct  
            and coalesce(t2.ckbalcao,'0')    = coalesce(peso.ckbalcao, '0')
            and coalesce(t2.cknumcta,'0')    = coalesce(peso.cknumcta, '0')
            and coalesce(t2.comp_id_gar,'0') = coalesce(peso.comp_id_gar, '0')
            and coalesce(t2.ckbalbem,'0')    = coalesce(peso.ckbalbem, '0')
            and coalesce(t2.ckctabem,'0')    = coalesce(peso.ckctabem, '0')
            and coalesce(t2.ckrefbem,'0')    = coalesce(peso.ckrefbem, '0');			
			
-- 8º Passo: Cálculo das flags de emissões para os vários métodos de Real Estate 
-- Registos a Junho2023: 8 811 registos (devido à desagregação dos vários colaterais por contrato)
-- Registos a Dezembro2023: registos				
drop table if exists bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux_2;
create table bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux_2 as
select *, 
		case when emi_scope1_building is not null then 1 else 0 end as flg_building_scope1,
		case when emi_scope2_building is not null then 1 else 0 end as flg_building_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is not null then 1 else 0 end as flg_nbuilding_scope1,
		case when emi_scope2_building is null and emi_scope2_nbuilding is not null then 1 else 0 end as flg_nbuilding_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is not null then 1 else 0 end as flg_totalfloor_scope1,
		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is not null then 1 else 0 end as flg_totalfloor_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is not null then 1 else 0 end as flg_intensity_scope1,
		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is not null then 1 else 0 end as flg_intensity_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is not null 
					then 1 else 0 end as flg_nbuilding_eur_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is not null 
					then 1 else 0 end as flg_nbuilding_eur_scope2,
					
		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is null 
					and emi_scope1_nbuilding_canada is not null then 1 else 0 end as flg_nbuilding_canada_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is null 
					and emi_scope2_nbuilding_canada is not null then 1 else 0 end as flg_nbuilding_canada_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is null 
					and emi_scope1_nbuilding_canada is null and emi_scope1_nbuilding_us is not null then 1 else 0 end as flg_nbuilding_us_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is null 
					and emi_scope2_nbuilding_canada is null and emi_scope2_nbuilding_us is not null then 1 else 0 end as flg_nbuilding_us_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is null 
					and emi_scope1_nbuilding_canada is null and emi_scope1_nbuilding_us is null and emi_scope1_nbuilding_res is not null then 1 else 0 end as flg_nbuilding_res_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is null 
					and emi_scope2_nbuilding_canada is null and emi_scope2_nbuilding_us is null and emi_scope2_nbuilding_res is not null then 1 else 0 end as flg_nbuilding_res_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is null 
					and emi_scope1_nbuilding_canada is null and emi_scope1_nbuilding_us is null and emi_scope1_nbuilding_res is null 
					and emi_scope1_dwelling_intens is not null then 1 else 0 end as flg_dwelling_intens_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is null 
					and emi_scope2_nbuilding_canada is null and emi_scope2_nbuilding_us is null and  emi_scope2_nbuilding_res is null 
					and emi_scope2_dwelling_intens is not null then 1 else 0 end as flg_dwelling_intens_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is null 
					and emi_scope1_nbuilding_canada is null and emi_scope1_nbuilding_us is null and emi_scope1_nbuilding_res is null 
					and emi_scope1_dwelling_intens is null and emi_scope1_nbuildings_eur is not null then 1 else 0 end as flg_nbuildings_eur_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is null 
					and emi_scope2_nbuilding_canada is null and emi_scope2_nbuilding_us is null and  emi_scope2_nbuilding_res is null 
					and emi_scope2_dwelling_intens is null and emi_scope2_nbuildings_eur is not null then 1 else 0 end as flg_nbuildings_eur_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is null 
					and emi_scope1_nbuilding_canada is null and emi_scope1_nbuilding_us is null and emi_scope1_nbuilding_res is null 
					and emi_scope1_dwelling_intens is null and emi_scope1_nbuildings_eur is null and emi_scope1_nbuildings_canada is not null then 1 else 0 end as flg_nbuildings_canada_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is null 
					and emi_scope2_nbuilding_canada is null and emi_scope2_nbuilding_us is null and  emi_scope2_nbuilding_res is null 
					and emi_scope2_dwelling_intens is null and emi_scope2_nbuildings_eur is null and emi_scope2_nbuildings_canada is not null then 1 else 0 end as flg_nbuildings_canada_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is null 
					and emi_scope1_nbuilding_canada is null and emi_scope1_nbuilding_us is null and emi_scope1_nbuilding_res is null 
					and emi_scope1_dwelling_intens is null and emi_scope1_nbuildings_eur is null and emi_scope1_nbuildings_canada is null 
					and emi_scope1_nbuilding_us_met3 is not null then 1 else 0 end as flg_nbuilding_us_met3_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is null 
					and emi_scope2_nbuilding_canada is null and emi_scope2_nbuilding_us is null and  emi_scope2_nbuilding_res is null 
					and emi_scope2_dwelling_intens is null and emi_scope2_nbuildings_eur is null and emi_scope2_nbuildings_canada is null 
					and emi_scope2_nbuilding_us_met3 is not null then 1 else 0 end as flg_nbuilding_us_met3_scope2,

		case when emi_scope1_building is null and emi_scope1_nbuilding is null and emi_scope1_totalfloor is null and emi_scope1_intensity is null and emi_scope1_nbuilding_eur is null 
					and emi_scope1_nbuilding_canada is null and emi_scope1_nbuilding_us is null and emi_scope1_nbuilding_res is null 
					and emi_scope1_dwelling_intens is null and emi_scope1_nbuildings_eur is null and emi_scope1_nbuildings_canada is null 
					and emi_scope1_nbuilding_us_met3 is null and emi_scope1_nbuilding_res_met3 is not null then 1 else 0 end as flg_nbuilding_res_met3_scope1,

		case when emi_scope2_building is null and emi_scope2_nbuilding is null and emi_scope2_totalfloor is null and emi_scope2_intensity is null and emi_scope2_nbuilding_eur is null 
					and emi_scope2_nbuilding_canada is null and emi_scope2_nbuilding_us is null and  emi_scope2_nbuilding_res is null 
					and emi_scope2_dwelling_intens is null and emi_scope2_nbuildings_eur is null and emi_scope2_nbuildings_canada is null 
					and emi_scope2_nbuilding_us_met3 is null and emi_scope2_nbuilding_res_met3 is not null then 1 else 0 end as flg_nbuilding_res_met3_scope2
from bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux_1;

		
-- 9º Passo: Cálculo de Data Quality Score
-- Registos a Dezembro2023: 8 811 registos (devido à desagregação dos vários colaterais por contrato)		
-- Registos a Dezembro2023: registos		
drop table if exists bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux;
create table bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux as
select *, 
					
		case when (flg_building_scope1 = 1) then dqs_office else '' end as dqs_building_scope1,	
		case when (flg_building_scope2 = 1) then dqs_office else '' end as dqs_building_scope2,	
		
		case when (flg_nbuilding_scope1 = 1) then dqs_others else '' end as dqs_nbuilding_scope1,	
		case when (flg_nbuilding_scope2 = 1) then dqs_others else '' end as dqs_nbuilding_scope2,

		case when (flg_totalfloor_scope1 = 1) then dqs_totalfloor else '' end as dqs_totalfloor_scope1,	
		case when (flg_totalfloor_scope2 = 1) then dqs_totalfloor else '' end as dqs_totalfloor_scope2,	

		case when (flg_intensity_scope1 = 1) then dqs_emintensity else '' end as dqs_emintensity_scope1,	
		case when (flg_intensity_scope2 = 1) then dqs_emintensity else '' end as dqs_emintensity_scope2,			
					
		case when (flg_nbuilding_eur_scope1 = 1) then dqs_eu_america_com else '' end as dqs_nbuilding_eur_scope1,	
		case when (flg_nbuilding_eur_scope2 = 1) then dqs_eu_america_com else '' end as dqs_nbuilding_eur_scope2,	
		
		case when (flg_nbuilding_canada_scope1 = 1) then dqs_eu_america_com else '' end as dqs_nbuilding_canada_scope1,	
		case when (flg_nbuilding_canada_scope2 = 1) then dqs_eu_america_com else '' end as dqs_nbuilding_canada_scope2,	
		
		case when (flg_nbuilding_us_scope1 = 1) then dqs_eu_america_com else '' end as dqs_nbuilding_us_scope1,	
		case when (flg_nbuilding_us_scope2 = 1) then dqs_eu_america_com else '' end as dqs_nbuilding_us_scope2,	
		
		case when (flg_nbuilding_res_scope1 = 1) then dqs_eu_america else '' end as dqs_nbuilding_res_scope1,	
		case when (flg_nbuilding_res_scope2 = 1) then dqs_eu_america else '' end as dqs_nbuilding_res_scope2,

		case when (flg_dwelling_intens_scope1 = 1) then dqs_dwelling_intens else '' end as dqs_dwelling_intens_scope1,	
		case when (flg_dwelling_intens_scope2 = 1) then dqs_dwelling_intens else '' end as dqs_dwelling_intens_scope2,

		case when (flg_nbuildings_eur_scope1 = 1) then dqs_eu_america3 else '' end as dqs_nbuildings_eur_scope1,	
		case when (flg_nbuildings_eur_scope2 = 1) then dqs_eu_america3 else '' end as dqs_nbuildings_eur_scope2,			

		case when (flg_nbuildings_canada_scope1 = 1) then dqs_eu_america3 else '' end as dqs_nbuildings_canada_scope1,	
		case when (flg_nbuildings_canada_scope2 = 1) then dqs_eu_america3 else '' end as dqs_nbuildings_canda_scope2,

		case when (flg_nbuilding_us_met3_scope1 = 1) then dqs_eu_america3 else '' end as dqs_nbuildings_us_scope1,	
		case when (flg_nbuilding_us_met3_scope2 = 1) then dqs_eu_america3 else '' end as dqs_nbuildings_us_scope2,		

		case when (flg_nbuilding_res_met3_scope1 = 1) then dqs_dwelling_eu_am_3 else '' end as dqs_res_met3_scope1,	
		case when (flg_nbuilding_res_met3_scope2 = 1) then dqs_dwelling_eu_am_3 else '' end as dqs_res_met3_us_scope2
	
from  bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux_2;


-- 10º Passo e meio: Marcação da flag calculation approach 2
-- Registos a Dezembro2023: 8 811 registos (devido à desagregação dos vários colaterais por contrato)	
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23;
create table bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23 as
select *,
		-- Flag de Calculation Approach
        case when ckctabem is not null then  1 else 0 end as flg_calculation_approach_2
from bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23_aux;


-- 11º Passo e meio: Cálculo das emissões formato final e do data quality score 
-- Registos a Dezembro2023: 8 811 registos (devido à desagregação dos vários colaterais por contrato)	
-- Registos a Dezembro2023: registos
drop table bu_esg_work.pilar3_sat93_tabaux_emi_colat_aux_dez23;
create table bu_esg_work.pilar3_sat93_tabaux_emi_colat_aux_dez23 as 
select  *,
        -- emissões finais scope 1
        case 
             when flg_building_scope1 = 1 then round(coalesce(emi_scope1_building,0),2)
             when flg_nbuilding_scope1 = 1 then round(coalesce(emi_scope1_nbuilding,0),2)
             when flg_totalfloor_scope1 = 1 then round(coalesce(emi_scope1_totalfloor,0),2)
             when flg_intensity_scope1 = 1 then round(coalesce(emi_scope1_intensity,0),2)
             when flg_nbuilding_eur_scope1 = 1 then round(coalesce(emi_scope1_nbuilding_eur,0),2)
             when flg_nbuilding_canada_scope1 = 1 then round(coalesce(emi_scope1_nbuilding_canada,0),2)
             when flg_nbuilding_us_scope1 = 1 then round(coalesce(emi_scope1_nbuilding_us,0),2)
             when flg_nbuilding_res_scope1 = 1 then round(coalesce(emi_scope1_nbuilding_res,0),2)
             when flg_dwelling_intens_scope1 = 1 then round(coalesce(emi_scope1_dwelling_intens,0),2)
             when flg_nbuildings_eur_scope1 = 1 then round(coalesce(emi_scope1_nbuildings_eur,0),2)
             when flg_nbuildings_canada_scope1 = 1 then round(coalesce(emi_scope1_nbuildings_canada,0),2)
             when flg_nbuilding_us_met3_scope1 = 1 then round(coalesce(emi_scope1_nbuilding_us_met3,0),2)
             when flg_nbuilding_res_met3_scope1 =1 then round(coalesce(emi_scope1_nbuilding_res_met3,0),2) else null end as gesi_aux,
        
		-- emissões finais scope 2
        case when flg_building_scope2 = 1 then round(coalesce(emi_scope2_building,0),2)
             when flg_nbuilding_scope2 = 1 then round(coalesce(emi_scope2_nbuilding,0),2)
             when flg_totalfloor_scope2 = 1 then round(coalesce(emi_scope2_totalfloor,0),2)
             when flg_intensity_scope2 = 1 then round(coalesce(emi_scope2_intensity,0),2)
             when flg_nbuilding_eur_scope2 = 1 then round(coalesce(emi_scope2_nbuilding_eur,0),2)
             when flg_nbuilding_canada_scope2 = 1 then round(coalesce(emi_scope2_nbuilding_canada,0),2)
             when flg_nbuilding_us_scope2 = 1 then round(coalesce(emi_scope2_nbuilding_us,0),2)
             when flg_nbuilding_res_scope2 = 1 then round(coalesce(emi_scope2_nbuilding_res,0),2)
             when flg_dwelling_intens_scope2 = 1 then round(coalesce(emi_scope2_dwelling_intens,0),2)
             when flg_nbuildings_eur_scope2 = 1 then round(coalesce(emi_scope2_nbuildings_eur,0),2)
             when flg_nbuildings_canada_scope2 = 1 then round(coalesce(emi_scope2_nbuildings_canada,0),2)
             when flg_nbuilding_us_met3_scope2 = 1 then round(coalesce(emi_scope2_nbuilding_us_met3,0),2)
             when flg_nbuilding_res_met3_scope2 =1 then round(coalesce(emi_scope2_nbuilding_res_met3,0),2) else null end as gesii_aux,
        -- GCA scope 1
        case 
             when flg_building_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_totalfloor_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_intensity_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_eur_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_canada_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_us_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_res_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_dwelling_intens_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuildings_eur_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuildings_canada_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_us_met3_scope1 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_res_met3_scope1 =1 then round(coalesce(amount_bem,0),2) else round(coalesce(amount_bem,0),2) end as asci_aux,
        -- GCA scope 2
        case     
             when flg_building_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_scope2 = 1 then  round(coalesce(amount_bem,0),2)
             when flg_totalfloor_scope2 = 1 then  round(coalesce(amount_bem,0),2)
             when flg_intensity_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_eur_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_canada_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_us_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_res_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_dwelling_intens_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuildings_eur_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuildings_canada_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_us_met3_scope2 = 1 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_res_met3_scope2 =1 then round(coalesce(amount_bem,0),2) else round(coalesce(amount_bem,0),2) end as ascii_aux,           


		-- GCA scope 3
        case     
             when flg_building_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_scope2 = 0 then  round(coalesce(amount_bem,0),2)
             when flg_totalfloor_scope2 = 0 then  round(coalesce(amount_bem,0),2)
             when flg_intensity_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_eur_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_canada_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_us_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_res_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_dwelling_intens_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuildings_eur_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuildings_canada_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_us_met3_scope2 = 0 then round(coalesce(amount_bem,0),2)
             when flg_nbuilding_res_met3_scope2 =0 then round(coalesce(amount_bem,0),2) else round(coalesce(amount_bem,0),2) end as asciii_aux,    

		case 
		     when dqs_building_scope1 in ('3','4','5') then dqs_building_scope1
		     when dqs_nbuilding_scope1 in ('3','4','5') then dqs_nbuilding_scope1
		     when dqs_totalfloor_scope1 in ('3','4','5') then dqs_totalfloor_scope1
		     when dqs_emintensity_scope1 in ('3','4','5') then dqs_emintensity_scope1
		     when dqs_nbuilding_eur_scope1 in ('3','4','5') then dqs_nbuilding_eur_scope1
		     when dqs_nbuilding_canada_scope1 in ('3','4','5') then dqs_nbuilding_canada_scope1
		     when dqs_nbuilding_us_scope1 in ('3','4','5') then dqs_nbuilding_us_scope1
		     when dqs_nbuilding_res_scope1 in ('3','4','5') then dqs_nbuilding_res_scope1
		     when dqs_dwelling_intens_scope1 in ('3','4','5') then dqs_dwelling_intens_scope1
		     when dqs_nbuildings_eur_scope1 in ('3','4','5') then dqs_nbuildings_eur_scope1 
		     when dqs_nbuildings_canada_scope1 in ('3','4','5') then dqs_nbuildings_canada_scope1
		     when dqs_nbuildings_us_scope1 in ('3','4','5') then dqs_nbuildings_us_scope1
		     when dqs_res_met3_scope1 in ('3','4','5') then dqs_res_met3_scope1
        else '' end as dqs_scope1_gar,
        
		case 
		    when dqs_building_scope2 in ('3','4','5') then dqs_building_scope2
            when dqs_totalfloor_scope2 in ('3','4','5') then dqs_totalfloor_scope2
            when dqs_nbuilding_scope2 in ('3','4','5') then dqs_nbuilding_scope2
            when dqs_emintensity_scope2 in ('3','4','5') then dqs_emintensity_scope2
            when dqs_nbuilding_eur_scope2 in ('3','4','5') then dqs_nbuilding_eur_scope2
            when dqs_nbuilding_canada_scope2 in ('3','4','5') then dqs_nbuilding_canada_scope2
            when dqs_nbuilding_us_scope2 in ('3','4','5') then dqs_nbuilding_us_scope2
            when dqs_nbuilding_res_scope2 in ('3','4','5') then dqs_nbuilding_res_scope2
            when dqs_dwelling_intens_scope2 in ('3','4','5') then dqs_dwelling_intens_scope2
            when dqs_nbuildings_eur_scope2 in ('3','4','5') then dqs_nbuildings_eur_scope2
            when dqs_nbuildings_canda_scope2 in ('3','4','5') then dqs_nbuildings_canda_scope2
            when dqs_nbuildings_us_scope2 in ('3','4','5') then dqs_nbuildings_us_scope2
            when dqs_res_met3_us_scope2 in ('3','4','5') then dqs_res_met3_us_scope2
        else '' end as dqs_scope2_gar,
		
		'' as dqs_scope3_gar
from bu_esg_work.pilar3_sat93_tabaux3_AUX_dez23;

-- 12º Passo e meio: Criação da tabela preliminar de colaterais com o somatorio das emissões por contrato
-- Registos a Dezembro2023: 8 811 registos (devido à desagregação dos vários colaterais por contrato)
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux_emi_colat_dez23;
create table bu_esg_work.pilar3_sat93_tabaux_emi_colat_dez23 as 
select  reporting_soc,
        sociedade_contraparte,
        cod_ajust,
        idcomb_satelite,
        setor,
        cempresa_ct,
        cbalcao_ct,
        cnumecta_ct,
        zdeposit_ct,	
		ckbalcao,
        cknumcta,
        comp_id_gar,
        ckbalbem,
        ckctabem,
        ckrefbem,
        zcliente,
        93_european_union,
        15_nace_esg,
        33_counterparty_type,
        cnael,
        cpais_residencia,
        amount,
        client_revenue,
        client_debt,
        29_flag_specialised_lending,
        51_client_own_funds,
        regiao,
        country,
        nace_new,
        nace_code,
        glcs_code,
        cib_scope1,
        cib_scope2,
        cib_scope3,
        total_debt,
        total_equity,
        calculation_approach_1,
        case when flg_calculation_approach_2 = 1 then 'Real Estate' else '' end as calculation_approach_2,
        emi_cib_scope1,
        emi_cib_scope2,
        emi_cib_scope3,
        revenue_scope1,
        revenue_scope2,
        revenue_scope3,
        emi_score4_scope1,
        emi_score4_scope2,
        emi_score4_scope3,
        assets_scope1,
        assets_scope2,
        assets_scope3,
        emi_score5_scope1,
        emi_score5_scope2,
        emi_score5_scope3,
        european_union,
        source_emissions_scope1_cib,
        source_emissions_scope2_cib,
        source_emissions_scope3_cib,
        flg_cib_scope1,
        flg_cib_scope2,
        flg_cib_scope3,
        flg_ncib_scope1,
        flg_ncib_scope2,
        flg_ncib_scope3,
        flg_physical_scope1,
        flg_physical_scope2,
        flg_physical_scope3,
        flg_economic_rev_scope1,
        flg_economic_rev_scope2,
        flg_economic_rev_scope3,
        flg_economic_asset_scope1,
        flg_economic_asset_scope2,
        flg_economic_asset_scope3,		
		flg_building_scope1,
		flg_building_scope2,
		flg_nbuilding_scope1,
		flg_nbuilding_scope2,
		flg_totalfloor_scope1,
		flg_totalfloor_scope2,
		flg_intensity_scope1,
		flg_intensity_scope2,
		flg_nbuilding_eur_scope1,
		flg_nbuilding_eur_scope2,
		flg_nbuilding_canada_scope1,
		flg_nbuilding_canada_scope2,
		flg_nbuilding_us_scope1,
		flg_nbuilding_us_scope2,
		flg_nbuilding_res_scope1,
		flg_nbuilding_res_scope2,
		flg_dwelling_intens_scope1,
		flg_dwelling_intens_scope2,
		flg_nbuildings_eur_scope1,
		flg_nbuildings_eur_scope2,
		flg_nbuildings_canada_scope1,
		flg_nbuildings_canada_scope2,
		flg_nbuilding_us_met3_scope1,
		flg_nbuilding_us_met3_scope2,
		flg_nbuilding_res_met3_scope1,
		flg_nbuilding_res_met3_scope2,
		emi_scope1_building,
		emi_scope2_building,
		emi_scope1_nbuilding,
		emi_scope2_nbuilding,
		emi_scope1_totalfloor,
		emi_scope2_totalfloor,
		emi_scope1_intensity,
		emi_scope2_intensity,
		emi_scope1_nbuilding_eur,
		emi_scope2_nbuilding_eur,
		emi_scope1_nbuilding_canada,
		emi_scope2_nbuilding_canada,
		emi_scope1_nbuilding_us,
		emi_scope2_nbuilding_us,
		emi_scope1_nbuilding_res,
		emi_scope2_nbuilding_res,
		emi_scope1_dwelling_intens,
		emi_scope2_dwelling_intens,
		emi_scope1_nbuildings_eur,
		emi_scope2_nbuildings_eur,
		emi_scope1_nbuildings_canada,
		emi_scope2_nbuildings_canada,
		emi_scope1_nbuilding_us_met3,
		emi_scope2_nbuilding_us_met3,
		emi_scope1_nbuilding_res_met3,
		emi_scope2_nbuilding_res_met3,
        dqs_scope1_cib,
        dqs_scope2_cib,
        dqs_scope3_cib,
        dqs_revenues,
        dqs_assets,
		dqs_scope1_gar,
		dqs_scope2_gar,
		dqs_scope3_gar,
        sum(gesi_aux) as gesi_aux_2,
        sum(gesii_aux) as gesii_aux_2,
        sum(asci_aux) as asci_aux_2,
        sum(ascii_aux) as ascii_aux_2,
		sum(asciii_aux) as asciii_aux2
from bu_esg_work.pilar3_sat93_tabaux_emi_colat_aux_dez23
group by reporting_soc,
        sociedade_contraparte,
        cod_ajust,
        idcomb_satelite,
        setor,
        cempresa_ct,
        cbalcao_ct,
        cnumecta_ct,
        zdeposit_ct,	
		ckbalcao,
        cknumcta,
        comp_id_gar,
        ckbalbem,
        ckctabem,
        ckrefbem,
        zcliente,
        93_european_union,
        15_nace_esg,
        33_counterparty_type,
        cnael,
        cpais_residencia,
        amount,
        client_revenue,
        client_debt,
        29_flag_specialised_lending,
        51_client_own_funds,
        regiao,
        country,
        nace_new,
        nace_code,
        glcs_code,
        cib_scope1,
        cib_scope2,
        cib_scope3,
        total_debt,
        total_equity,
        calculation_approach_1,
        case when flg_calculation_approach_2 = 1 then 'Real Estate' else '' end,
        emi_cib_scope1,
        emi_cib_scope2,
        emi_cib_scope3,
        revenue_scope1,
        revenue_scope2,
        revenue_scope3,
        emi_score4_scope1,
        emi_score4_scope2,
        emi_score4_scope3,
        assets_scope1,
        assets_scope2,
        assets_scope3,
        emi_score5_scope1,
        emi_score5_scope2,
        emi_score5_scope3,
        european_union,
        source_emissions_scope1_cib,
        source_emissions_scope2_cib,
        source_emissions_scope3_cib,
        flg_cib_scope1,
        flg_cib_scope2,
        flg_cib_scope3,
        flg_ncib_scope1,
        flg_ncib_scope2,
        flg_ncib_scope3,
        flg_physical_scope1,
        flg_physical_scope2,
        flg_physical_scope3,
        flg_economic_rev_scope1,
        flg_economic_rev_scope2,
        flg_economic_rev_scope3,
        flg_economic_asset_scope1,
        flg_economic_asset_scope2,
        flg_economic_asset_scope3,		
		flg_building_scope1,
		flg_building_scope2,
		flg_nbuilding_scope1,
		flg_nbuilding_scope2,
		flg_totalfloor_scope1,
		flg_totalfloor_scope2,
		flg_intensity_scope1,
		flg_intensity_scope2,
		flg_nbuilding_eur_scope1,
		flg_nbuilding_eur_scope2,
		flg_nbuilding_canada_scope1,
		flg_nbuilding_canada_scope2,
		flg_nbuilding_us_scope1,
		flg_nbuilding_us_scope2,
		flg_nbuilding_res_scope1,
		flg_nbuilding_res_scope2,
		flg_dwelling_intens_scope1,
		flg_dwelling_intens_scope2,
		flg_nbuildings_eur_scope1,
		flg_nbuildings_eur_scope2,
		flg_nbuildings_canada_scope1,
		flg_nbuildings_canada_scope2,
		flg_nbuilding_us_met3_scope1,
		flg_nbuilding_us_met3_scope2,
		flg_nbuilding_res_met3_scope1,
		flg_nbuilding_res_met3_scope2,
		emi_scope1_building,
		emi_scope2_building,
		emi_scope1_nbuilding,
		emi_scope2_nbuilding,
		emi_scope1_totalfloor,
		emi_scope2_totalfloor,
		emi_scope1_intensity,
		emi_scope2_intensity,
		emi_scope1_nbuilding_eur,
		emi_scope2_nbuilding_eur,
		emi_scope1_nbuilding_canada,
		emi_scope2_nbuilding_canada,
		emi_scope1_nbuilding_us,
		emi_scope2_nbuilding_us,
		emi_scope1_nbuilding_res,
		emi_scope2_nbuilding_res,
		emi_scope1_dwelling_intens,
		emi_scope2_dwelling_intens,
		emi_scope1_nbuildings_eur,
		emi_scope2_nbuildings_eur,
		emi_scope1_nbuildings_canada,
		emi_scope2_nbuildings_canada,
		emi_scope1_nbuilding_us_met3,
		emi_scope2_nbuilding_us_met3,
		emi_scope1_nbuilding_res_met3,
		emi_scope2_nbuilding_res_met3,
        dqs_scope1_cib,
        dqs_scope2_cib,
        dqs_scope3_cib,
        dqs_revenues,
        dqs_assets,
		dqs_scope1_gar,
		dqs_scope2_gar,
		dqs_scope3_gar
;
		
-- 13º A Passo e meio: Criação da tabela com os NACES ESG para Real Estate
-- Registos a Dezembro2023: 8 811 registos (devido à desagregação dos vários colaterais por contrato)
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux3_dez23;
create table bu_esg_work.pilar3_sat93_tabaux3_dez23 as
select 
        t2.*,
		case when sociedade_contraparte = '' then '00000' else sociedade_contraparte end as counterparty_soc,
		case
            when trim(t2.`33_counterparty_type`) = 'outras empresas nao financeiras' and nace_esg.nace_level4 is not null then nace_esg.ID
            when trim(t2.`33_counterparty_type`) = 'outras empresas nao financeiras' then 'NACE19010303' --PC: nace default disponibilizado pela corporação
            when trim(t2.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' and nace_esg.nace_level4 is not null then nace_esg.ID	
            when trim(t2.`33_counterparty_type`) in ('', 'resto setores / clientes') and idcomb_satelite like '%SC0303%' then 'NACE19010303' --PC: nace default disponibilizado pela corporação
            else ''									
        end as nace_esg		
from bu_esg_work.pilar3_sat93_tabaux_emi_colat_dez23 as t2
	left join bu_esg_work.nace_esg_pillar3 as nace_esg								
			on concat(split_part(t2.`15_nace_esg`,".",1),split_part(t2.`15_nace_esg`,".",2),split_part(t2.`15_nace_esg`,".",3)) = trim(split_part(nace_esg.nace_level4, "-",1));

-- 13º B Passo: Criação do cálculo de emissoes para Real Estate que nao cumprem as condições (calculam em BCL)
-- Registos a Dezembro2023: 8 174 registos
-- Registos a Dezembro2023: registos
drop table bu_esg_work.sat93_agregacao_dez23_aux;
create table bu_esg_work.sat93_agregacao_dez23_aux as
select 
		reporting_soc,
		sociedade_contraparte,
		case when sociedade_contraparte = '' then '00000' else sociedade_contraparte end as counterparty_soc,
		cod_ajust,
		idcomb_satelite,
		setor,
		cempresa_ct,
		cbalcao_ct,
		cnumecta_ct,
		zdeposit_ct,
		zcliente,
		93_european_union,
		15_nace_esg,
		33_counterparty_type,
		cnael,
		cpais_residencia,
		amount,
		client_revenue,
		client_debt,
		29_flag_specialised_lending,
		51_client_own_funds,
		regiao,
		country,
		nace_new,
		nace_code,
		glcs_code,
		cib_scope1,
		cib_scope2,
		cib_scope3,
		total_debt,
		total_equity,
		calculation_approach_1,
		'Gar em BCL' as calculation_approach_2,
		emi_cib_scope1,
		emi_cib_scope2,
		emi_cib_scope3,
		revenue_scope1,
		revenue_scope2,
		revenue_scope3,
		emi_score4_scope1,
		emi_score4_scope2,
		emi_score4_scope3,
		assets_scope1,
		assets_scope2,
		assets_scope3,
         case 
            when amount > 0 and setor = 'NFC' and `29_flag_specialised_lending`<>'1'    
                    then cast(assets_scope1 as decimal(30,6)) * (amount/1000000) 
            else null end as emi_score5_scope1,
         case 
            when amount > 0 and setor = 'NFC' and `29_flag_specialised_lending`<>'1'    
                    then cast(assets_scope2 as decimal(30,6)) * (amount/1000000)
            else null end as emi_score5_scope2,      
         case 
            when amount > 0 and setor = 'NFC' and `29_flag_specialised_lending`<>'1'    
                    then cast(assets_scope3 as decimal(30,6)) * (amount/1000000)
            else null end as emi_score5_scope3,
		european_union,
		source_emissions_scope1_cib,
		source_emissions_scope2_cib,
		source_emissions_scope3_cib,
		flg_cib_scope1,
		flg_cib_scope2,
		flg_cib_scope3,
		flg_ncib_scope1,
		flg_ncib_scope2,
		flg_ncib_scope3,
		flg_physical_scope1,
		flg_physical_scope2,
		flg_physical_scope3,
		flg_economic_rev_scope1,
		flg_economic_rev_scope2,
		flg_economic_rev_scope3,
		case when ((case 
            when amount > 0 and setor = 'NFC' and `29_flag_specialised_lending`<>'1'    
                    then cast(assets_scope1 as decimal(30,6)) * (amount/1000000) 
            else null end) is not null) 
        then 1 else 0	end as flg_economic_asset_scope1,
		case when ((case 
            when amount > 0 and setor = 'NFC' and `29_flag_specialised_lending`<>'1'    
                    then cast(assets_scope2 as decimal(30,6)) * (amount/1000000) 
            else null end) is not null) 
        then 1 else 0	end as flg_economic_asset_scope2,
		case when ((case 
            when amount > 0 and setor = 'NFC' and `29_flag_specialised_lending`<>'1'    
                    then cast(assets_scope3 as decimal(30,6)) * (amount/1000000) 
            else null end) is not null) 
        then 1 else 0	end as flg_economic_asset_scope3,        
		dqs_scope1_cib,
		dqs_scope2_cib,
		dqs_scope3_cib,
		dqs_revenues,
		dqs_assets,
		nace_esg
from bu_esg_work.pilar3_sat93_tabaux_emi_colat_aux_dez23 
where   flg_building_scope1 = 0 and
        flg_building_scope2 = 0 and
        flg_nbuilding_scope1 = 0 and
        flg_nbuilding_scope2 = 0 and
        flg_totalfloor_scope1 = 0 and
        flg_totalfloor_scope2 = 0 and
        flg_intensity_scope1 = 0 and
        flg_intensity_scope2 = 0 and
        flg_nbuilding_eur_scope1 = 0 and
        flg_nbuilding_eur_scope2 = 0 and
        flg_nbuilding_canada_scope1 = 0 and
        flg_nbuilding_canada_scope2 = 0 and
        flg_nbuilding_us_scope1 = 0 and
        flg_nbuilding_us_scope2 = 0 and
        flg_nbuilding_res_scope1 = 0 and
        flg_nbuilding_res_scope2 = 0 and
        flg_dwelling_intens_scope1 = 0 and
        flg_dwelling_intens_scope2 = 0 and
        flg_nbuildings_eur_scope1 = 0 and
        flg_nbuildings_eur_scope2 = 0 and
        flg_nbuildings_canada_scope1 = 0 and
        flg_nbuildings_canada_scope2 = 0 and
        flg_nbuilding_us_met3_scope1 = 0 and
        flg_nbuilding_us_met3_scope2 = 0 and
        flg_nbuilding_res_met3_scope1 = 0 and
        flg_nbuilding_res_met3_scope2 = 0 
;
-- Criação de distinct por campo de contrato porque estes apenas calculam emissões ao nível do contrato
-- 5 853 contratos com garantia em Jun23 que passam a calcular BCL
-- Registos a Dezembro2023: registos
drop table bu_esg_work.sat93_agregacao_dez23_aux2;
create table bu_esg_work.sat93_agregacao_dez23_aux2 as
select distinct 
        t1.reporting_soc,
        t1.sociedade_contraparte,
        t1.cod_ajust,
        t1.idcomb_satelite,
        t1.setor,
        t1.cempresa_ct,
        t1.cbalcao_ct,
        t1.cnumecta_ct,
        t1.zdeposit_ct,
        t1.zcliente,
        t1.`93_european_union`,
        t1.`15_nace_esg`,
        t1.`33_counterparty_type`,
        t1.cpais_residencia,
        t1.amount,
        t1.client_revenue,
        t1.client_debt,
        t1.`29_flag_specialised_lending`,
        t1.`51_client_own_funds`,
        t1.cnael,
        t1.nace_esg,
        t1.regiao,
        t1.country,
        t1.nace_new,
        t1.nace_code,
        t1.european_union,
        'Gar em BCL' as calculation_approach_1,
        t1.glcs_code,
        t1.cib_scope1,
        t1.cib_scope2,
        t1.cib_scope3,
        t1.total_debt,
        t1.total_equity,
        t1.emi_cib_scope1,
        t1.emi_cib_scope2,
        t1.emi_cib_scope3,
        t1.revenue_scope1,
        t1.revenue_scope2,
        t1.revenue_scope3,
        t1.emi_score4_scope1,
        t1.emi_score4_scope2,
        t1.emi_score4_scope3,
        t1.assets_scope1,
        t1.assets_scope2,
        t1.assets_scope3,
         case 
            when t1.amount > 0 and t1.setor = 'NFC' and t1.`29_flag_specialised_lending`<>'1'    
                    then cast(t1.assets_scope1 as decimal(30,6)) * (t1.amount/1000000) 
            else null end as emi_score5_scope1,
         case 
            when t1.amount > 0 and t1.setor = 'NFC' and t1.`29_flag_specialised_lending`<>'1'    
                    then cast(t1.assets_scope2 as decimal(30,6)) * (t1.amount/1000000)
            else null end as emi_score5_scope2,      
         case 
            when t1.amount > 0 and t1.setor = 'NFC' and t1.`29_flag_specialised_lending`<>'1'    
                    then cast(t1.assets_scope3 as decimal(30,6)) * (t1.amount/1000000)
            else null end as emi_score5_scope3,
        t1.source_emissions_scope1_cib,
        t1.source_emissions_scope2_cib,
        t1.source_emissions_scope3_cib,
        t1.dqs_scope1_cib,
        t1.dqs_scope2_cib,
        t1.dqs_scope3_cib,
        t1.dqs_revenues,
        t1.dqs_assets  
from bu_esg_work.sat93_agregacao_dez23_aux t1
;

-- Marcação de flag de cálculo para os casos anteriores
-- Registos a Junho2023: 5 853 registos 
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.sat93_agregacao_dez23_aux3;
create table bu_esg_work.sat93_agregacao_dez23_aux3 as  
select *,
------------------------------------------------------------------------------------------------------------------ Tracking de flags de mapeamento -----------------------------------------------------------------------------------------
	-- Emissões por contraparte - CIB SCOPE 1 
	0 as flg_cib_scope1,					
	0 as flg_cib_scope2,										
	0 as flg_cib_scope3,
	-- Emissões por contraparte - NÃO CIB 
	0 as flg_ncib_scope1,
	0 as flg_ncib_scope2,
	0 as flg_ncib_scope3,					
	-- Emissões por atividade física  
	0 as flg_physical_scope1,
	0 as flg_physical_scope2,
	0 as flg_physical_scope3,		
	-- Atividade Económica  - Emissões Revenues
	0 as flg_economic_rev_scope1,
	0 as flg_economic_rev_scope2_prel,
	0 as flg_economic_rev_scope3_prel,
	-- Atividade Económica  - Emissões Assets 
	case when emi_score5_scope1 is not null then 1 else 0 end as flg_economic_asset_scope1,
	case when emi_score5_scope2 is not null then 1 else 0 end as flg_economic_asset_scope2,
	case when emi_score5_scope3 is not null then 1 else 0 end as flg_economic_asset_scope3
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
from bu_esg_work.sat93_agregacao_dez23_aux2;

-- Registos a Junho2023: 5 853 registos 
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.sat93_agregacao_dez23_aux4;
create table bu_esg_work.sat93_agregacao_dez23_aux4 as 
select *,
       0 as flg_economic_rev_scope3,
       0 as flg_economic_rev_scope2
from bu_esg_work.sat93_agregacao_dez23_aux3;

-- Registos a Junho2023: 5 853 registos 
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.sat93_agregacao_dez23_aux5;
create table bu_esg_work.sat93_agregacao_dez23_aux5 as 
select  *,
	    -- Emissões finais scope 1
		case when flg_economic_asset_scope1 = 1 then round(coalesce(emi_score5_scope1,0),6) else null end as gesi_aux_ctr,
		-- Emissões finais scope 2 
		case when flg_economic_asset_scope2 = 1 then round(coalesce(emi_score5_scope2,0),6) else null end as gesii_aux_ctr,
		-- Emissões finais scope 3 
		case when flg_economic_asset_scope3 = 1 then round(coalesce(emi_score5_scope3,0),6) else null end as gesiii_aux_ctr,
	   -- GCA finais scope 1
		case when flg_economic_asset_scope1 = 1 then round(coalesce(amount,0),6) else round(coalesce(amount,0),6) end as asci_aux_ctr,
		-- GCA finais scope 2 
		case when flg_economic_asset_scope2 = 1 then round(coalesce(amount,0),6) else round(coalesce(amount,0),6) end as asc2_aux_ctr,
		-- GCA finais scope 3 
		case when flg_economic_asset_scope3 = 1 then round(coalesce(amount,0),6) else round(coalesce(amount,0),6) end as asciii_aux_ctr,
			 
		-- Data Quality Score
			-- Scope 1
		case when calculation_approach_1 is null then ''
			 when calculation_approach_1 = 'Gar em BCL' and flg_economic_asset_scope1 =1 then dqs_assets
				else '' end as dqs_scope1,
			-- Scope 2			
		case when calculation_approach_1 is null then ''
			 when calculation_approach_1 = 'Gar em BCL' and flg_economic_asset_scope2 =1 then dqs_assets
				else '' end as dqs_scope2,
			-- Scope 3
		case when calculation_approach_1 is null then ''
			 when calculation_approach_1 = 'Gar em BCL' and flg_economic_asset_scope3 =1 then dqs_assets
				else '' end as dqs_scope3					
from bu_esg_work.sat93_agregacao_dez23_aux4;

-- 14º Passo e meio: Agregação dos portfolios
-- Registos a Junho2023: 309 331 registos (devido à desagregação dos vários colaterais por contrato - 309 233 distinct por contrato, porém existem contratos que estavam desgregados por bem e deixaramde estar porque passam a calcular em BCL) 
-- Registos a Dezembro2023: registos
drop table bu_esg_work.sat93_agregacao_dez23;
create table bu_esg_work.sat93_agregacao_dez23 as
select
		reporting_soc,
		sociedade_contraparte,
		case when sociedade_contraparte = '' then '00000' else sociedade_contraparte end as counterparty_soc,
		cod_ajust,
		idcomb_satelite,
		setor,
		cempresa_ct,
		cbalcao_ct,
		cnumecta_ct,
		zdeposit_ct,
		zcliente,
		93_european_union,
		15_nace_esg,
		33_counterparty_type,
		cnael,
		cpais_residencia,
		amount,
		client_revenue,
		client_debt,
		29_flag_specialised_lending,
		51_client_own_funds,
		regiao,
		country,
		nace_new,
		nace_code,
		glcs_code,
		cib_scope1,
		cib_scope2,
		cib_scope3,
		total_debt,
		total_equity,
		calculation_approach_1,
		NULL as calculation_approach_2,
		emi_cib_scope1,
		emi_cib_scope2,
		emi_cib_scope3,
		revenue_scope1,
		revenue_scope2,
		revenue_scope3,
		emi_score4_scope1,
		emi_score4_scope2,
		emi_score4_scope3,
		assets_scope1,
		assets_scope2,
		assets_scope3,
		emi_score5_scope1,
		emi_score5_scope2,
		emi_score5_scope3,
		european_union,
		source_emissions_scope1_cib,
		source_emissions_scope2_cib,
		source_emissions_scope3_cib,
		flg_cib_scope1,
		flg_cib_scope2,
		flg_cib_scope3,
		flg_ncib_scope1,
		flg_ncib_scope2,
		flg_ncib_scope3,
		flg_physical_scope1,
		flg_physical_scope2,
		flg_physical_scope3,
		flg_economic_rev_scope1,
		flg_economic_rev_scope2,
		flg_economic_rev_scope3,
		flg_economic_asset_scope1,
		flg_economic_asset_scope2,
		flg_economic_asset_scope3,
		flg1_motor_vehi_scope1,
		flg1_motor_vehi_scope2,
		flg1_motor_vehi_scope3,
		flg2_motor_vehi_scope1,
		flg2_motor_vehi_scope2,
		flg2_motor_vehi_scope3,
		flg3_motor_vehi_scope1,
		flg3_motor_vehi_scope2,
		flg4_motor_vehi_scope1,
		flg4_motor_vehi_scope2,		
		dqs_scope1_cib,
		dqs_scope2_cib,
		dqs_scope3_cib,
		dqs_revenues,
		dqs_assets,
		nace_esg,
		gesi_aux_ctr,
		gesii_aux_ctr,
		gesiii_aux_ctr,
		asci_aux_ctr,
		asc2_aux_ctr,
		asciii_aux_ctr,
		dqs_scope1,
		dqs_scope2,
		dqs_scope3,
		NULL as flg_building_scope1,
		NULL as flg_building_scope2,
		NULL as flg_nbuilding_scope1,
		NULL as flg_nbuilding_scope2,
		NULL as flg_totalfloor_scope1,
		NULL as flg_totalfloor_scope2,
		NULL as flg_intensity_scope1,
		NULL as flg_intensity_scope2,
		NULL as flg_nbuilding_eur_scope1,
		NULL as flg_nbuilding_eur_scope2,
		NULL as flg_nbuilding_canada_scope1,
		NULL as flg_nbuilding_canada_scope2,
		NULL as flg_nbuilding_us_scope1,
		NULL as flg_nbuilding_us_scope2,
		NULL as flg_nbuilding_res_scope1,
		NULL as flg_nbuilding_res_scope2,
		NULL as flg_dwelling_intens_scope1,
		NULL as flg_dwelling_intens_scope2,
		NULL as flg_nbuildings_eur_scope1,
		NULL as flg_nbuildings_eur_scope2,
		NULL as flg_nbuildings_canada_scope1,
		NULL as flg_nbuildings_canada_scope2,
		NULL as flg_nbuilding_us_met3_scope1,
		NULL as flg_nbuilding_us_met3_scope2,
		NULL as flg_nbuilding_res_met3_scope1,
		NULL as flg_nbuilding_res_met3_scope2,
		NULL as emi_scope1_building,
		NULL as emi_scope2_building,
		NULL as emi_scope1_nbuilding,
		NULL as emi_scope2_nbuilding,
		NULL as emi_scope1_totalfloor,
		NULL as emi_scope2_totalfloor,
		NULL as emi_scope1_intensity,
		NULL as emi_scope2_intensity,
		NULL as emi_scope1_nbuilding_eur,
		NULL as emi_scope2_nbuilding_eur,
		NULL as emi_scope1_nbuilding_canada,
		NULL as emi_scope2_nbuilding_canada,
		NULL as emi_scope1_nbuilding_us,
		NULL as emi_scope2_nbuilding_us,
		NULL as emi_scope1_nbuilding_res,
		NULL as emi_scope2_nbuilding_res,
		NULL as emi_scope1_dwelling_intens,
		NULL as emi_scope2_dwelling_intens,
		NULL as emi_scope1_nbuildings_eur,
		NULL as emi_scope2_nbuildings_eur,
		NULL as emi_scope1_nbuildings_canada,
		NULL as emi_scope2_nbuildings_canada,
		NULL as emi_scope1_nbuilding_us_met3,
		NULL as emi_scope2_nbuilding_us_met3,
		NULL as emi_scope1_nbuilding_res_met3,
		NULL as emi_scope2_nbuilding_res_met3,
		NULL as gesi_aux_2,
		NULL as gesii_aux_2,
		NULL as asci_aux_2,
		NULL as ascii_aux_2,
		NULL as asciii_aux2,
		NULL as dqs_scope1_gar,
		NULL as dqs_scope2_gar,
		NULL as dqs_scope3_gar
		from bu_esg_work.pilar3_sat93_tabaux_emi_contrato_dez23
		where calculation_approach_1 <> '' 
union all
select 
		reporting_soc,
		sociedade_contraparte,
		case when sociedade_contraparte = '' then '00000' else sociedade_contraparte end as counterparty_soc,
		cod_ajust,
		idcomb_satelite,
		setor,
		cempresa_ct,
		cbalcao_ct,
		cnumecta_ct,
		zdeposit_ct,
		zcliente,
		93_european_union,
		15_nace_esg,
		33_counterparty_type,
		cnael,
		cpais_residencia,
		amount,
		client_revenue,
		client_debt,
		29_flag_specialised_lending,
		51_client_own_funds,
		regiao,
		country,
		nace_new,
		nace_code,
		glcs_code,
		cib_scope1,
		cib_scope2,
		cib_scope3,
		total_debt,
		total_equity,
		'Gar em BCL' as calculation_approach_1,
		NULL as calculation_approach_2,
		emi_cib_scope1,
		emi_cib_scope2,
		emi_cib_scope3,
		revenue_scope1,
		revenue_scope2,
		revenue_scope3,
		emi_score4_scope1,
		emi_score4_scope2,
		emi_score4_scope3,
		assets_scope1,
		assets_scope2,
		assets_scope3,
		emi_score5_scope1,
		emi_score5_scope2,
		emi_score5_scope3,
		european_union,
		source_emissions_scope1_cib,
		source_emissions_scope2_cib,
		source_emissions_scope3_cib,
		flg_cib_scope1,
		flg_cib_scope2,
		flg_cib_scope3,
		flg_ncib_scope1,
		flg_ncib_scope2,
		flg_ncib_scope3,
		flg_physical_scope1,
		flg_physical_scope2,
		flg_physical_scope3,
		flg_economic_rev_scope1,
		flg_economic_rev_scope2,
		flg_economic_rev_scope3,
		flg_economic_asset_scope1,
		flg_economic_asset_scope2,
		flg_economic_asset_scope3,
		flg1_motor_vehi_scope1,
		flg1_motor_vehi_scope2,
		flg1_motor_vehi_scope3,
		flg2_motor_vehi_scope1,
		flg2_motor_vehi_scope2,
		flg2_motor_vehi_scope3,
		flg3_motor_vehi_scope1,
		flg3_motor_vehi_scope2,
		flg4_motor_vehi_scope1,
		flg4_motor_vehi_scope2,			
		dqs_scope1_cib,
		dqs_scope2_cib,
		dqs_scope3_cib,
		dqs_revenues,
		dqs_assets,
		nace_esg,
		gesi_aux_ctr,
		gesii_aux_ctr,
		gesiii_aux_ctr,
		asci_aux_ctr,
		asc2_aux_ctr,
		asciii_aux_ctr,
		dqs_scope1,
		dqs_scope2,
		dqs_scope3,
		NULL as flg_building_scope1,
		NULL as flg_building_scope2,
		NULL as flg_nbuilding_scope1,
		NULL as flg_nbuilding_scope2,
		NULL as flg_totalfloor_scope1,
		NULL as flg_totalfloor_scope2,
		NULL as flg_intensity_scope1,
		NULL as flg_intensity_scope2,
		NULL as flg_nbuilding_eur_scope1,
		NULL as flg_nbuilding_eur_scope2,
		NULL as flg_nbuilding_canada_scope1,
		NULL as flg_nbuilding_canada_scope2,
		NULL as flg_nbuilding_us_scope1,
		NULL as flg_nbuilding_us_scope2,
		NULL as flg_nbuilding_res_scope1,
		NULL as flg_nbuilding_res_scope2,
		NULL as flg_dwelling_intens_scope1,
		NULL as flg_dwelling_intens_scope2,
		NULL as flg_nbuildings_eur_scope1,
		NULL as flg_nbuildings_eur_scope2,
		NULL as flg_nbuildings_canada_scope1,
		NULL as flg_nbuildings_canada_scope2,
		NULL as flg_nbuilding_us_met3_scope1,
		NULL as flg_nbuilding_us_met3_scope2,
		NULL as flg_nbuilding_res_met3_scope1,
		NULL as flg_nbuilding_res_met3_scope2,
		NULL as emi_scope1_building,
		NULL as emi_scope2_building,
		NULL as emi_scope1_nbuilding,
		NULL as emi_scope2_nbuilding,
		NULL as emi_scope1_totalfloor,
		NULL as emi_scope2_totalfloor,
		NULL as emi_scope1_intensity,
		NULL as emi_scope2_intensity,
		NULL as emi_scope1_nbuilding_eur,
		NULL as emi_scope2_nbuilding_eur,
		NULL as emi_scope1_nbuilding_canada,
		NULL as emi_scope2_nbuilding_canada,
		NULL as emi_scope1_nbuilding_us,
		NULL as emi_scope2_nbuilding_us,
		NULL as emi_scope1_nbuilding_res,
		NULL as emi_scope2_nbuilding_res,
		NULL as emi_scope1_dwelling_intens,
		NULL as emi_scope2_dwelling_intens,
		NULL as emi_scope1_nbuildings_eur,
		NULL as emi_scope2_nbuildings_eur,
		NULL as emi_scope1_nbuildings_canada,
		NULL as emi_scope2_nbuildings_canada,
		NULL as emi_scope1_nbuilding_us_met3,
		NULL as emi_scope2_nbuilding_us_met3,
		NULL as emi_scope1_nbuilding_res_met3,
		NULL as emi_scope2_nbuilding_res_met3,
		NULL as gesi_aux_2,
		NULL as gesii_aux_2,
		NULL as asci_aux_2,
		NULL as ascii_aux_2,
		NULL as asciii_aux2,
		NULL as dqs_scope1_gar,
		NULL as dqs_scope2_gar,
		NULL as dqs_scope3_gar
		from bu_esg_work.sat93_agregacao_dez23_aux5
union all
select 
		reporting_soc,
		sociedade_contraparte,
		case when sociedade_contraparte = '' then '00000' else sociedade_contraparte end as counterparty_soc,
		cod_ajust,
		idcomb_satelite,
		setor,
		cempresa_ct,
		cbalcao_ct,
		cnumecta_ct,
		zdeposit_ct,
		zcliente,
		93_european_union,
		15_nace_esg,
		33_counterparty_type,
		cnael,
		cpais_residencia,
		amount,
		client_revenue,
		client_debt,
		29_flag_specialised_lending,
		51_client_own_funds,
		regiao,
		country,
		nace_new,
		nace_code,
		glcs_code,
		cib_scope1,
		cib_scope2,
		cib_scope3,
		total_debt,
		total_equity,
		calculation_approach_1,
		calculation_approach_2,
		emi_cib_scope1,
		emi_cib_scope2,
		emi_cib_scope3,
		revenue_scope1,
		revenue_scope2,
		revenue_scope3,
		emi_score4_scope1,
		emi_score4_scope2,
		emi_score4_scope3,
		assets_scope1,
		assets_scope2,
		assets_scope3,
		emi_score5_scope1,
		emi_score5_scope2,
		emi_score5_scope3,
		european_union,
		source_emissions_scope1_cib,
		source_emissions_scope2_cib,
		source_emissions_scope3_cib,
		flg_cib_scope1,
		flg_cib_scope2,
		flg_cib_scope3,
		flg_ncib_scope1,
		flg_ncib_scope2,
		flg_ncib_scope3,
		flg_physical_scope1,
		flg_physical_scope2,
		flg_physical_scope3,
		flg_economic_rev_scope1,
		flg_economic_rev_scope2,
		flg_economic_rev_scope3,
		flg_economic_asset_scope1,
		flg_economic_asset_scope2,
		flg_economic_asset_scope3,
		flg1_motor_vehi_scope1,
		flg1_motor_vehi_scope2,
		flg1_motor_vehi_scope3,
		flg2_motor_vehi_scope1,
		flg2_motor_vehi_scope2,
		flg2_motor_vehi_scope3,
		flg3_motor_vehi_scope1,
		flg3_motor_vehi_scope2,
		flg4_motor_vehi_scope1,
		flg4_motor_vehi_scope2,					
		dqs_scope1_cib,
		dqs_scope2_cib,
		dqs_scope3_cib,
		dqs_revenues,
		dqs_assets,
		nace_esg,	
		NULL AS gesi_aux_ctr,
		NULL AS gesii_aux_ctr,
		NULL AS gesiii_aux_ctr,
		NULL AS asci_aux_ctr,
		NULL AS asc2_aux_ctr,
		NULL AS asciii_aux_ctr,
		NULL as dqs_scope1,
		NULL as dqs_scope2,
		NULL as dqs_scope3,		
		flg_building_scope1,
		flg_building_scope2,
		flg_nbuilding_scope1,
		flg_nbuilding_scope2,
		flg_totalfloor_scope1,
		flg_totalfloor_scope2,
		flg_intensity_scope1,
		flg_intensity_scope2,
		flg_nbuilding_eur_scope1,
		flg_nbuilding_eur_scope2,
		flg_nbuilding_canada_scope1,
		flg_nbuilding_canada_scope2,
		flg_nbuilding_us_scope1,
		flg_nbuilding_us_scope2,
		flg_nbuilding_res_scope1,
		flg_nbuilding_res_scope2,
		flg_dwelling_intens_scope1,
		flg_dwelling_intens_scope2,
		flg_nbuildings_eur_scope1,
		flg_nbuildings_eur_scope2,
		flg_nbuildings_canada_scope1,
		flg_nbuildings_canada_scope2,
		flg_nbuilding_us_met3_scope1,
		flg_nbuilding_us_met3_scope2,
		flg_nbuilding_res_met3_scope1,
		flg_nbuilding_res_met3_scope2,		
		emi_scope1_building,
		emi_scope2_building,
		emi_scope1_nbuilding,
		emi_scope2_nbuilding,
		emi_scope1_totalfloor,
		emi_scope2_totalfloor,
		emi_scope1_intensity,
		emi_scope2_intensity,
		emi_scope1_nbuilding_eur,
		emi_scope2_nbuilding_eur,
		emi_scope1_nbuilding_canada,
		emi_scope2_nbuilding_canada,
		emi_scope1_nbuilding_us,
		emi_scope2_nbuilding_us,
		emi_scope1_nbuilding_res,
		emi_scope2_nbuilding_res,
		emi_scope1_dwelling_intens,
		emi_scope2_dwelling_intens,
		emi_scope1_nbuildings_eur,
		emi_scope2_nbuildings_eur,
		emi_scope1_nbuildings_canada,
		emi_scope2_nbuildings_canada,
		emi_scope1_nbuilding_us_met3,
		emi_scope2_nbuilding_us_met3,
		emi_scope1_nbuilding_res_met3,
		emi_scope2_nbuilding_res_met3,
		gesi_aux_2,
		gesii_aux_2,
		asci_aux_2,
		ascii_aux_2,
		asciii_aux2,
		dqs_scope1_gar,
		dqs_scope2_gar,
		dqs_scope3_gar
		from bu_esg_work.pilar3_sat93_tabaux3_dez23
		where calculation_approach_1 = '' and
             concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) not in (select concat(cempresa_ct,cbalcao_ct,cnumecta_ct,zdeposit_ct) from bu_esg_work.sat93_agregacao_dez23_aux5)


-- 15º Passo e meio: Assignar o calculation approach final + emission area + source emission 
-- Registos a Junho2023: 309 331 registos (devido à desagregação dos vários colaterais por contrato - 309 233 distinct por contrato, porém existem contratos que estavam desgregados por bem e deixaramde estar porque passam a calcular em BCL) 
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.sat93_agregacao2_dez23_1;
create table bu_esg_work.sat93_agregacao2_dez23_1 as
select 
        t1.*,			 
 	-- Assignar o Emission Area	 
		case
			when (emi_cib_scope1 is not null) or (emi_cib_scope2 is not null) or (emi_cib_scope3 is not null) then 'CLIEA1' -- CIB client emissions
			else 'CLIEA2' -- Emissions rest
		end as client_emission_area,
		-- Assignar o Source Emission
		case when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_cib_scope1 = 1) then source_emissions_scope1_cib
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_cib_scope2 = 1 ) then source_emissions_scope2_cib
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_cib_scope3 = 1 ) then source_emissions_scope3_cib
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_economic_rev_scope1 = 1) then 'SOUR2'
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_economic_rev_scope2 = 1) then 'SOUR2'
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_economic_rev_scope3 = 1) then 'SOUR2'			 
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_economic_asset_scope1 = 1) then 'SOUR2'
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_economic_asset_scope2 = 1) then 'SOUR2'
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_economic_asset_scope3 = 1) then 'SOUR2'	
			 when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') and (flg_cib_scope1 = 0) and (flg_cib_scope2 = 0) and (flg_cib_scope3 = 0)
															and (flg_economic_rev_scope1 = 0) and (flg_economic_rev_scope2 = 0) and (flg_economic_rev_scope3 = 0)
															and (flg_economic_asset_scope1 = 0) and (flg_economic_asset_scope2 = 0) and (flg_economic_asset_scope3 = 0)
																then 'SOUR3'
			 when calculation_approach_1 = 'Project Finance' then 'SOUR3'
			 when calculation_approach_1 = 'Motor vehicle loans' then 'SOUR3'
			 when calculation_approach_1 = '' and flg_building_scope1 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuilding_scope1 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_totalfloor_scope1 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_intensity_scope1 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuilding_eur_scope2 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuilding_canada_scope2 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuilding_us_scope2 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuilding_res_scope2 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_dwelling_intens_scope2 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuildings_eur_scope2 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuildings_canada_scope2 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuilding_us_met3_scope2 = 1 then 'SOUR2'
             when calculation_approach_1 = '' and flg_nbuilding_res_met3_scope2 = 1 then 'SOUR2'				
				else '' end as source_emission,
		-- Assignar o Calculation Approach  
		case when calculation_approach_1 in ('Business Loans','Gar em BCL','157 em BCL') then 'CAAP1'
			 when calculation_approach_1 = 'Project Finance' then 'CAAP2'
			 when calculation_approach_1 = '' then 'CAAP3'
			 when calculation_approach_1 = 'Motor vehicle loans' then 'CAAP4' else '' end as calculation_approach
from bu_esg_work.sat93_agregacao_dez23 as t1;


drop table if exists bu_esg_work.sat93_agregacao2_dez23;
create table bu_esg_work.sat93_agregacao2_dez23 as
select *, 
		case when (dqs_scope1 = '1' or dqs_scope2 = '1' or dqs_scope3 = '1' or dqs_scope1_gar='1' or dqs_scope2_gar='1' or dqs_scope3_gar='1') then 'DQS1'
			 when (dqs_scope1 = '2' or dqs_scope2 = '2' or dqs_scope3 = '2' or dqs_scope1_gar='2' or dqs_scope2_gar='2' or dqs_scope3_gar='2') then 'DQS2'
			 when (dqs_scope1 = '3' or dqs_scope2 = '3' or dqs_scope3 = '3' or dqs_scope1_gar='3' or dqs_scope2_gar='3' or dqs_scope3_gar='3') then 'DQS3'
			 when (dqs_scope1 = '4' or dqs_scope2 = '4' or dqs_scope3 = '4' or dqs_scope1_gar='4' or dqs_scope2_gar='4' or dqs_scope3_gar='4') then 'DQS4'
			 when (dqs_scope1 = '5' or dqs_scope2 = '5' or dqs_scope3 = '5' or dqs_scope1_gar='5' or dqs_scope2_gar='5' or dqs_scope3_gar='5') then 'DQS5' else '' end as data_quality_score
from bu_esg_work.sat93_agregacao2_dez23_1;	



-- Número de registos a Dezembro de 2022: 1 968 registos 
-- Registos a Junho2023: 2 028 registos
-- Registos a Dezembro2023: registos
drop table if exists bu_esg_work.pilar3_sat93_tabaux4_dez23;
create table bu_esg_work.pilar3_sat93_tabaux4_dez23 as
select 
        a.reporting_soc,
        a.counterparty_soc,
		a.cod_ajust as adjustment_code,
        a.idcomb_satelite,
		a.European_union as EU,
		a.cnael, 	
        a.nace_esg as nace,		
		a.client_emission_area,
		a.calculation_approach,
		a.source_emission,
		a.data_quality_score,
		round(sum(coalesce(gesi_aux_ctr,0)+coalesce(gesi_aux_2,0)),2) as gesi,
		round(sum(coalesce(gesii_aux_ctr,0)+coalesce(gesii_aux_2,0)),2) as gesii,
		round(sum(coalesce(gesiii_aux_ctr,0)),2) as gesiii,
		round(sum(coalesce(asci_aux_ctr,0)+coalesce(asci_aux_2,0)),2) as asci,
		round(sum(coalesce(asc2_aux_ctr,0)+coalesce(ascii_aux_2,0)),2) as asc2,
		round(sum(coalesce(asciii_aux_ctr,0)+coalesce(asciii_aux2,0)),2) as asciii

from bu_esg_work.sat93_agregacao2_dez23 as a 
group by 		
		a.reporting_soc,
        a.counterparty_soc,
		a.cod_ajust,
        a.idcomb_satelite,
		a.European_union,
		a.cnael, 	
        a.nace_esg,		
		a.client_emission_area,
		a.calculation_approach,
		a.source_emission,
		a.data_quality_score;
			 
			 
			

-- Formatação final do satélite de acordo com as guidelines 
-- Registos a Junho2023: 2 028 registos
-- Registos a Dezembro2023: registos
drop table bu_esg_work.pilar3_sat93_tabaux5_dez23;
create table bu_esg_work.pilar3_sat93_tabaux5_dez23 as 
select 
        reporting_soc,
        counterparty_soc,
        adjustment_code,
		concat(idcomb_satelite,';',client_emission_area,';',calculation_approach,';',source_emission,';',data_quality_score) as id_comb,
		EU,
        cnael,
        nace,
        case when asci is null then 0 else asci end as asci,        
		case 
            when gesi is null and source_emission = 'SOUR3' then NULL
            when gesi is null and source_emission <> 'SOUR3' then 0.00
            when asci < 0 then 0.00 
            else gesi 
        end as gesi,
		case when asc2 is null then 0 else asc2 end as asc2,
		case 
            when gesii is null and source_emission = 'SOUR3' then NULL
            when gesii is null and source_emission <> 'SOUR3' then 0.00
            when asc2 < 0 or gesii < 0 then 0.00
            else gesii 
        end as gesii,
		case when asciii is null then 0 else asciii end as asciii, 
		case 
            when gesiii is null and source_emission = 'SOUR3' then NULL
            when gesiii is null and source_emission <> 'SOUR3' then 0.00
            when asciii < 0 then 0.00
            else gesiii 
        end as gesiii
from bu_esg_work.pilar3_sat93_tabaux4_dez23;



select 
reporting_soc,
counterparty_soc,
adjustment_code,
id_comb,
eu,
cnael,
nace,
round(asci,0) as asci,
round(gesi,0) as gesi,
round(asc2,0) as asc2,
round(gesii,0) as gesii,
round(asciii,0) as asciii,
round(gesiii,0) as gesiii
from bu_esg_work.pilar3_sat93_tabaux5_dez23


---------------------------------------------------------------------------------------------------------------------
-- Testes e Validações
---------------------------------------------------------------------------------------------------------------------


--Validação:
select sum(asci),sum(asc2),sum(asciii),sum(gesi),sum(gesii),sum(gesiii) from bu_esg_work.pilar3_sat93_tabaux7;
--13 626 295 149

select sum(amount) from bu_esg_work.pilar3_tabaux_sat93_t1;
--13 626 295 145

--Validação:
select sum(asci),sum(asc2),sum(asciii),sum(gesi),sum(gesii),sum(gesiii) from bu_esg_work.pilar3_tabaux_sat93_t6v2;
--16 592 918 565

select sum(amount) from bu_esg_work.pilar3_tabaux_sat93_t1v2;
--16 592 918 560

--Validação: preparação de dados granulares para disponibilização à Corporação e ao owner local

select  b.reporting_soc,b.sociedade_contraparte,b.cempresa_fr012,b.cbalcao_fr012,b.cnumecta_fr012,b.zdeposit_fr012,b.zcliente,b.amount, b.nace_esg,A.nace_esg as nace_esg_pillar3,
b.cpais_residencia,b.pais_parametrizacao,client_revenue,client_debt,51_client_own_funds as client_equity,revenue_scope1,revenue_scope2,revenue_scope3,assets_scope1,
assets_scope2,assets_scope3,fator_financed_em,emi_score4_scope1,emi_score4_scope2,
emi_score4_scope3,emi_score5_scope1,emi_score5_scope2,emi_score5_scope3,last_parent,cib_scope1,cib_scope2,
cib_scope3,audited_scope1,audited_scope2,audited_scope3,debt_fy20,debt_fy21,equity_fy20,equity_fy21,emi_cib_scope1_corp_loans,emi_cib_scope2_corp_loans,emi_cib_scope3_corp_loans,
ghg_emi_scope1,ghg_emi_scope2,ghg_emi_scope3,score_scope1,score_scope2,score_scope3

from  bu_captools_work.pilar3_tabaux_sat93_t3 a inner join
bu_captools_work.pilar3_tabaux_sat93_t2 b on 
a.cempresa_fr012 = b.cempresa_fr012 and a.cbalcao_fr012 = b.cbalcao_fr012 and a.cnumecta_fr012 = b.cnumecta_fr012 and a.zdeposit_fr012 = b.zdeposit_fr012
and a.zcliente = b.zcliente
where a.nace_esg in ('NACE137010','NACE074711','NACE033312');


-- [DE]: Testes a implementar a posteriori 
-- 	select *,
-- 		   case when 
-- 					(
-- 					   (flg_cib_scope1 =1) or
-- 					   (flg_cib_scope2 =1) or
-- 					   (flg_cib_scope3 =1) or
-- 					   (flg_ncib_scope1 =1) or
-- 					   (flg_ncib_scope2 =1) or
-- 					   (flg_ncib_scope3 =1) or
-- 					   (flg_physical_scope1 =1) or
-- 					   (flg_physical_scope2 =1) or
-- 					   (flg_physical_scope3 =1) or
-- 					   (flg_economic_rev_scope1 =1) or
-- 					   (flg_economic_rev_scope2 =1) or
-- 					   (flg_economic_rev_scope3 =1) or
-- 					   (flg_economic_asset_scope1 =1) or
-- 					   (flg_economic_asset_scope2 =1) or
-- 					   (flg_economic_asset_scope3 =1) or
-- 					   (client_debt > 0 and client_revenue > 0.01 and amount > 0 and setor = 'NFC' and cnumecta_ct is null and `29_flag_specialised_lending`<>'1')
-- 					) then 'Business Corporate Loans'
-- 				when 
-- 					(
-- 						(flg_building =1) or
-- 						(flg_nbuilding =1) or
-- 						(flg_totalfloor =1) or
-- 						(flg_intensity =1) or
-- 						(flg_nbuilding_eur =1) or
-- 						(flg_nbuilding_canada =1) or
-- 						(flg_nbuilding_us =1) or
-- 						(flg_nbuilding_res =1) or
-- 						(flg_dwelling_intens =1) or
-- 						(flg_nbuildings_eur =1) or
-- 						(flg_nbuildings_canada =1) or
-- 						(flg_nbuilding_us_met3 =1) or
-- 						(flg_nbuilding_res_met3 =1) or
-- 						(client_debt > 0 and client_revenue > 0.01 and amount > 0 and setor = 'NFC' and ckctabem is not null) --and narutil is not null)
-- 					) then 'Real Estate' else 'Outros Produtos' end as `Tipologia de Produto`,
-- 			(flg_cib_scope1 + flg_ncib_scope1 + flg_physical_scope1 + flg_economic_rev_scope1 + flg_economic_asset_scope1) sum_business_loans_scope1,
-- 			(flg_cib_scope2 + flg_ncib_scope2 + flg_physical_scope2 + flg_economic_rev_scope2 + flg_economic_asset_scope2) sum_business_loans_scope2,
-- 			(flg_cib_scope3 + flg_ncib_scope3 + flg_physical_scope3 + flg_economic_rev_scope3 + flg_economic_asset_scope3) sum_business_loans_scope3,

-- 			(flg_building + flg_nbuilding + flg_totalfloor + flg_intensity + flg_nbuilding_eur + flg_nbuilding_canada + flg_nbuilding_us + flg_nbuilding_res + flg_dwelling_intens + flg_nbuildings_eur + flg_nbuildings_canada + flg_nbuilding_us_met3 + flg_nbuilding_res_met3) as sum_real_estate,
			 
-- 			(flg_cib_scope1 + flg_ncib_scope1 + flg_physical_scope1 + flg_economic_rev_scope1 + flg_economic_asset_scope1) + (flg_building + flg_nbuilding + flg_totalfloor + flg_intensity + flg_nbuilding_eur + flg_nbuilding_canada + flg_nbuilding_us + flg_nbuilding_res + flg_dwelling_intens + flg_nbuildings_eur + flg_nbuildings_canada + flg_nbuilding_us_met3 + flg_nbuilding_res_met3) as sum_total_scope1,
-- 			(flg_cib_scope2 + flg_ncib_scope2 + flg_physical_scope2 + flg_economic_rev_scope2 + flg_economic_asset_scope2) + (flg_building + flg_nbuilding + flg_totalfloor + flg_intensity + flg_nbuilding_eur + flg_nbuilding_canada + flg_nbuilding_us + flg_nbuilding_res + flg_dwelling_intens + flg_nbuildings_eur + flg_nbuildings_canada + flg_nbuilding_us_met3 + flg_nbuilding_res_met3) as sum_total_scope2, 
-- 			(flg_cib_scope3 + flg_ncib_scope3 + flg_physical_scope3 + flg_economic_rev_scope3 + flg_economic_asset_scope3) + (flg_building + flg_nbuilding + flg_totalfloor + flg_intensity + flg_nbuilding_eur + flg_nbuilding_canada + flg_nbuilding_us + flg_nbuilding_res + flg_dwelling_intens + flg_nbuildings_eur + flg_nbuildings_canada + flg_nbuilding_us_met3 + flg_nbuilding_res_met3) as sum_total_scope3

-- from bu_esg_work.pilar3_sat93_tabaux3_AUX_testedez22)a

-- where sum_total_scope3 > 1 ;

