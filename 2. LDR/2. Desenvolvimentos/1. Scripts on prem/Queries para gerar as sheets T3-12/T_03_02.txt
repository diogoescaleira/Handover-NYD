CREATE TABLE bu_captools_work.T_03_02 AS
SELECT

cast(row_number() over (order by zx.zdeposit1) as string) as Number,

"Rank 9 - Ranking in insolvency (master scale)" as Insolvency_ranking, -- Confirmar que este campo é estático, na T03.01 este campo tem uma fórmula associada

zx.zdeposit1 as Contract_identifier,

zx.gcliente as Entity_name_of_guaranteeing_entity,

IF(zx.clei IN ("","#"), zx.zcliente, zx.clei) as Identifier_of_Guaranteeing_Entity,

IF(zx.clei IN ("","#"), "Type of identifier, other than LEI or MFI code", "LEI code") as Type_of_identifier,

IF(zx.st_sgps_portugal_ifrs = "x" OR zx.st_sgps_portugal_ifrs = "E", "TRUE", "FALSE") as Is_guaranteeing_entity,

"PORTUGAL" as Governing_law, -- Confirmar que este campo é estático

"Counterparty" as Guarantee_Type, -- Confirmar que este campo é estático

CAST(ABS(zx.sum_of_sum_of_msaldo_final) AS DECIMAL(16,2)) as Potential_maximum_guaranteed_amount,

"No" as Collateralised, -- Ver o que deve vir neste campo, vem sempre a No pois tem a formula "IF(O8<0, "Yes", "No")" associada mas o campo O está sempre a vazio

"" as Amount_of_collateral_received, -- Confirmar se é suposto vir sempre a vazio, não me parece e vai influenciar o campo anterior

"Default" as Guarantee_trigger -- Confirmar se é suposto vir sempre a "Default"

FROM bu_captools_work.QUERY_FOR_FILTER_FOR_QUERY__0037 as zx;
