--Projecto - Balanço BST individual
SET VAR:REFDATE	= '2021-11-30';
SET VAR:PERIMETRO = 'Individual Local';
SET VAR:DATADATEPART = '2021-11-30';
SET VAR:LEI_CODE_BST = '549300URJH9VSI58CS32';


CREATE TABLE bu_captools_work.CODEMAPPING (
  DD_CODE STRING COMMENT "Code for DL value",
  DD_VALUE STRING COMMENT "Translation value for corresponding code",
  DD_FIELD_ID STRING COMMENT "SRB Field ID value");

INSERT INTO bu_captools_work.CODEMAPPING
  VALUES
  ("S_1.0", "Central governments or central banks (SCENGOV)","3"),
  ("S_2.0",	"Regional governments or local authorities (SREGGOV)","3"),
  ("S_3.0",	"Public sector entities (SPUBSEC)","3"),
  ("S_4.0",	"Multilateral development banks (SDEVBAN)","3"),
  ("S_5.0",	"International organisation (SINTORG)","3"),
  ("S_6.0",	"Institutions (SINSTIT)","3"),
  ("S_7.0",	"Corporates (SCORPOR)","3"),
  ("S_8.0",	"Retail (SRETAIL)","3"),
  ("S_9.0",	"Secured by mortgages and immovable property (SSECMOR)","3"),
  ("S_10.0", "Defaulted (SDEFAUL)","3"),
  ("S_11.0", "High risk (SHIGHRI)","3"),
  ("S_12.0", "Covered bonds (SCOVBON)","3"),
  ("S_17.0", "Items representing securitisation positions","3"),
  ("S_13.0", "Institutions and corporates with a short term credit assessment (SSHOTER)","3"),
  ("S_14.0", "Collective investment undertakings (SCOLINV)","3"),
  ("S_15.0", "Equity (SEQUITY)","3"),
  ("S_16.0", "Other (SOTHERI)","3"),
  ("I_1.0", "Central governments and central banks (ICENGOV)","3"),
  ("I_1.1",	"Central governments and central banks (ICENGOV)","3"),
  ("I_1.2",	"Central governments and central banks (ICENGOV)","3"),
  ("I_2.0",	"Institutions (IINSTIT)","3"),
  ("I_2.1",	"Institutions (IINSTIT)","3"),
  ("I_2.2",	"Institutions (IINSTIT)","3"),
  ("I_3.0",	"Corporates (ICORPOR)","3"),
  ("I_3.1",	"Corporates (ICORPOR)","3"),
  ("I_3.2",	"Corporates (ICORPOR)","3"),
  ("I_4.0",	"Corporates (ICORPOR)","3"),
  ("I_4.1",	"Corporates (ICORPOR)","3"),
  ("I_4.2",	"Corporates (ICORPOR)","3"),
  ("I_5.0",	"Corporates (ICORPOR)","3"),
  ("I_5.1",	"Corporates (ICORPOR)","3"),
  ("I_5.2",	"Corporates (ICORPOR)","3"),
  ("I_6.0",	"Retail (IRETAIL)","3"),
  ("I_6.1",	"Retail (IRETAIL)","3"),
  ("I_6.2",	"Retail (IRETAIL)","3"),
  ("I_6.3",	"Retail (IRETAIL)","3"),
  ("I_6.4",	"Retail (IRETAIL)","3"),
  ("I_6.5",	"Retail (IRETAIL)","3"),
  ("I_7.0",	"Equity (IEQUITY)","3"),
  ("I_8.0",	"Items representing securitisation positions","3"),
  ("I_9.0",	"Other non credit-obligation assets (IOTHERC)","3"),
  ("1.0", "Central banks","4"),
  ("2.0", "Central governments","4"),
  ("3.0", "Credit institutions","4"),
  ("4.0", "Other financial corporations","4"),
  ("5.0", "Non-financial corporations","4"),
  ("6.0", "Non-financial corporations","4"),
  ("7.0", "Households","4"),
  ("13", "Gold","187"),
  ("15", "Currency and deposits","187"),
  ("12", "Securities","187"),
  ("16", "Loans","187"),
  ("18", "Equity and investment fund shares or units","187"),
  ("4", "Credit derivatives","187"),
  ("5", "Financial guarantees other than credit derivatives","187"),
  ("17", "Trade receivables","187"),
  ("2", "Life insurance policies pledged","187"),
  ("8", "Residential real estate collateral","187"),
  ("9", "Offices and commercial premises","187"),
  ("10","Commercial real estate collateral","187"),
  ("3", "Other physical collateral","187"),
  ("7", "Other protection","187"),
  ("20", "Overdraft","35"),
  ("51", "Credit card debt","35"),
  ("80", "Financial lease","35"),
  ("1001", "Revolving credit card other than overdrafts and credit card debt","35"),
  ("1002", "Credit lines other than revolving credit","35"),
  ("1004", "Loan","35"),
  ("1", "French","142"),
  ("2", "German","142"),
  ("3", "Fixed amortisation schedule","142"),
  ("4", "Bullet","142"),
  ("5", "Other","142"),
  ("14", "Not in default","158"),
  ("18", "Default because both unlikely to pay and more than 90/180 days past due","158"),
  ("19", "Default because unlikely to pay (not more than 90/180 days past due)","158"),
  ("20", "Default because more than 90/180 days past due","158"),
  ("disponibilidades em bancos centrais", "Cash balances at central banks and other demand deposits (IFRS)","168"),
  ("ativos financeiros detidos para negociacao", "Financial assets held for trading (IFRS)","168"),
  ("ativos financeiros mandatoriamente ao justo valor atraves de resultados", "Non-trading financial assets mandatorily at fair value through profit or loss (IFRS)","168"),
  ("ativos financeiros ao justo valor atraves de resultados", "Financial assets designated at fair value through profit or loss (IFRS)","168"),
  ("ativos financeiros ao justo valor atraves de outro rendimento integral", "Financial assets at fair value through other comprehensive income (IFRS)","168"),
  ("ativos financeiros ao custo amortizado", "Financial assets at amortised cost (IFRS)","168"),
  ("1", "Stage 1 (IFRS)","172"),
  ("2", "Stage 2 (IFRS)","172"),
  ("3", "Stage 3 (IFRS)","172"),
  ("I", "Individually assessed","173"),
  ("C", "Collectively assessed","173"),
  ("1", "No encumbrance","174"),
  ("5", "Central bank funding","174"),
  ("6", "Exchange traded derivatives","174"),
  ("7", "Over-the-counter derivatives","174"),
  ("8", "Deposits - repurchase agreements other than to central banks","174"),
  ("9", "Deposits other than repurchase agreements","174"),
  ("10", "Debt securities issued - covered bonds securities","174"),
  ("11", "Debt securities issued - asset-backed securities","174"),
  ("12", "Debt securities issued - other than covered bonds and ABSs","174"),
  ("13", "Other sources of encumbrance","174"),
  ("1", "No encumbrance","89"),
  ("5", "Central bank funding","89"),
  ("6", "Exchange traded derivatives","89"),
  ("7", "Over-the-counter derivatives","89"),
  ("8", "Deposits - repurchase agreements other than to central banks","89"),
  ("9", "Deposits other than repurchase agreements","89"),
  ("10", "Debt securities issued - covered bonds securities","89"),
  ("11", "Debt securities issued - asset-backed securities","89"),
  ("12", "Debt securities issued - other than covered bonds and ABSs","89"),
  ("13", "Other sources of encumbrance","89"),
  ("4", "Forborne: instruments with modified interest rate below market conditions","178"),
  ("5", "Forborne: instruments with other modified terms and conditions","178"),
  ("3", "Forborne: totally or partially refinanced debt","178"),
  ("9", "Renegotiated instrument without forbearance measures","178"),
  ("8", "Not forborne or renegotiated","178"),
  ("ativos financeiros detidos para negociacao", "Trading book","182"),
  ("ativos financeiros ao justo valor atraves de resultados", "Trading book","182"),
  ("passivos financeiros detidos para negociacao", "Trading book","182"),
  ("others", "Non-trading book","182"),
  ("ativos financeiros detidos para negociacao", "Trading book","95"),
  ("ativos financeiros ao justo valor atraves de resultados", "Trading book","95"),
  ("passivos financeiros detidos para negociacao", "Trading book","95"),
  ("others", "Non-trading book","95"),
  ("ativos financeiros detidos para negociacao", "Trading book","54"),
  ("ativos financeiros ao justo valor atraves de resultados", "Trading book","54"),
  ("passivos financeiros detidos para negociacao", "Trading book","54"),
  ("others", "Non-trading book","54"),
  ("14", "Not in default","185"),
  ("18", "Default because both unlikely to pay and more than 90/180 days past due","185"),
  ("19", "Default because unlikely to pay (not more than 90/180 days past due","185"),
  ("20", "Default because more than 90/180 days past due","185"),
  ("S11", "Non-financial corporations","207"),
  ("S121", "Central Bank","207"),
  ("S12", "Credit institutions","207"),
  ("S122", "Deposit-taking corporations other than credit institutions","207"),
  ("S123", "Money market funds (MMF)","207"),
  ("S124", "Non-MMF Investment funds","207"),
  ("S125", "Financial vehicle corporations (FVCs) engaged in securitisation transactions, other financial intermediaries, except financial auxiliaries, captive financial institutions and money lenders, insurance corporations, pension funds and financial vehicle corporations engaged in securitisation transactions","207"),
  ("S126", "Financial auxilliaries","207"),
  ("S127", "Captive  financial institutions and money lenders","207"),
  ("S128", "Insurance corporations","207"),
  ("S1311", "Central government","207"),
  ("S1311201", "State government","207"),
  ("S1313", "Local government","207"),
  ("S1314", "Social security funds","207"),
  ("S15", "Non-profit institutions serving households","207"),
  ("1", "No legal actions taken","209"),
  ("2", "Under judicial administration, receivership or similar measures","209"),
  ("3", "Bankruptcy/insolvency","209"),
  ("4", "Other legal measures","209"),
  ("1", "Large enterprise","211"),
  ("2", "Medium enterprise","211"),
  ("3", "Small enterprise","211"),
  ("4", "Microenterprise","211"),
  ("Contrato Quadro", "PT","28"),
  ("ISDA", "GB","28"),
  ("1", "Mark-to Market","70"),
  ("2", "Mark-to-model","70"),
  ("F31", "Short-term debt securities","71"),
  ("F32", "Long-term debt securities","71"),
  ("D", "Debt","72"),
  ("D.1", "	Bond","72"),
  ("D.11", "Straight bond","72"),
  ("D.12", "Securitisation bond","72"),
  ("D.121", "Traditional securitisation","72"),
  ("D.122", "Synthetic securitisation","72"),
  ("D.129", "Other securitisation","72"),
  ("D.13", "Covered bond","72"),
  ("D.131", "Jumbo covered bond","72"),
  ("D.139", "Other covered bond","72"),
  ("D.14", "Medium-term note","72"),
  ("D.141", "Euro medium term notes (EMTN)","72"),
  ("D.149", "Other MTN","72"),
  ("D.15", "Perpetual bond","72"),
  ("D.16", "Linked bond","72"),
  ("D.161", "Inflation-linked bond","72"),
  ("D.162", "Interest rate-linked bond","72"),
  ("D.163", "Asset-linked bond","72"),
  ("D.164", "Currency-linked bond","72"),
  ("D.165", "Credit-linked bond","72"),
  ("D.166", "Exchange traded notes (ETN)","72"),
  ("D.167", "Exchange traded commodities (ETC)","72"),
  ("D.169", "Other linked bond","72"),
  ("D.17", "Strip bond","72"),
  ("D.171", "Coupon strip","72"),
  ("D.172", "Principal strip","72"),
  ("D.18", "Structured debt security (Certificates)","72"),
  ("D.181", "Investment product","72"),
  ("D.1811", "Capital protection product","72"),
  ("D.1812", "Yield enhancement product","72"),
  ("D.1813", "Participation product","72"),
  ("D.1819", "Other investment product","72"),
  ("D.182", "Leverage Product","72"),
  ("D.1821", "Leverage product with knock-out","72"),
  ("D.1822", "Leverage product without knock-out","72"),
  ("D.1823", "Constant leverage product","72"),
  ("D.1829", "Other leverage product","72"),
  ("D.19", "Other bond","72"),
  ("D.2", "Money market instrument","72"),
  ("D.21", "Bankers acceptance","72"),
  ("D.22", "Certificate of deposit","72"),
  ("D.23", "Commercial paper","72"),
  ("D.231", "Euro commercial paper (ECP)","72"),
  ("D.232", "Pagares","72"),
  ("D.239", "Other CP","72"),
  ("D.24", "Treasury bill","72"),
  ("D.29", "Other money market instrument","72"),
  ("D.3", "	Hybrid debt instrument","72"),
  ("D.31", "Convertible bond","72"),
  ("D.311", "Contingent convertible bonds (CoCo’s)","72"),
  ("D.32", "Bonds with warrants attached","72"),
  ("D.33", "Stapled debt instrument","72"),
  ("D.34", "Non-participating (preferred) share","72"),
  ("D.39", "Other hybrid debt Instrument","72"),
  ("D.9", "Other debt","72"),
  ("E", "Equity","72"),
  ("E.1", "Ordinary / Common share","72"),
  ("E.2", "Preference / Preferred share","72"),
  ("E.21", "Cumulative preferred share","72"),
  ("E.22", "Participating preferred share","72"),
  ("E.23", "Cumulative, participating preferred share","72"),
  ("E.24", "Redeemable preferred share","72"),
  ("E.29", "Other preferred share","72"),
  ("E.3", "Depository receipt","72"),
  ("E.31", "American depository receipt (ADR)","72"),
  ("E.32", "Global depository receipt (GDR)","72"),
  ("E.39", "Other depository receipt","72"),
  ("E.4", "Hybrid equity instrument","72"),
  ("E.41", "Participation certificate (Genussschein)","72"),
  ("E.42", "Subscription right","72"),
  ("E.43", "Convertible (preferred) share","72"),
  ("E.49", "Other hybrid equity instrument","72"),
  ("E.9", "Other equity","72"),
  ("F", "Fund","72"),
  ("F.1", "Undertaking for collective investment in transferable securities (UCITS) Fund","72"),
  ("F.2", "Alternative investment fund (AIF)","72"),
  ("F.9", "Other fund","72"),
  ("1000", "Securitisation","73"),
  ("1100", "Asset-backed security (ABS)","73"),
  ("1101", "Auto loans ABS","73"),
  ("1102", "Consumer loans ABS","73"),
  ("1103", "Credit card receivables ABS","73"),
  ("1104", "Equipment leases ABS","73"),
  ("1105", "Home equity loans ABS","73"),
  ("1106", "Manufactured housing leases ABS","73"),
  ("1107", "Small and medium-sized enterprises (SME) loans ABS","73"),
  ("1108", "Student loans ABS","73"),
  ("1109", "Whole Business Securitisation (WBS) ABS","73"),
  ("1110", "Mixed ABS","73"),
  ("1198", "Other Assets ABS","73"),
  ("1199", "ABS - No detailed classification available","73"),
  ("1200", "Mortgage-backed security (MBS)","73"),
  ("1201", "Residential mortgage-backed security (RMBS)","73"),
  ("1202", "Commercial mortgage-backed security (CMBS)","73"),
  ("1203", "Mixed MBS","73"),
  ("1298", "Other MBS","73"),
  ("1299", "MBS - No detailed classification available","73"),
  ("1300", "Collateralised Debt Obligation (CDO)","73"),
  ("1400", "Collateralised Mortgage Obligation (CMO)","73"),
  ("1500", "Mixed securitisation","73"),
  ("1800", "Other securitisation","73"),
  ("1900", "Securitisation - No detailed classification available","73"),
  ("2000", "Covered Bond","73"),
  ("2100", "Public sector Covered bond","73"),
  ("2200", "Mortgage Covered bond","73"),
  ("2300", "Ship Covered bond","73"),
  ("2400", "Aircraft Covered bond","73"),
  ("2500", "Mixed Covered bond","73"),
  ("2800", "Other Covered bond","73"),
  ("2900", "Covered Bond - No detailed classification available","73"),
  ("9999", "Securitisation and Covered Bond - No detailed classification available","73"),
  ("Y", "Yes (1)","88"),
  ("N", "No (2)","88"),
  ("Sim", "Yes (1)","90"),
  ("SIM", "Yes (1)","90"),
  ("Nao", "No (2)","90"),
  ("Sim", "Yes (1)","91"),
  ("SIM", "Yes (1)","91"),
  ("Nao", "No (2)","91"),
  ("ativos financeiros ao justo valor atraves de resultados", "IFRS: Financial assets designated at fair value through profit or loss","93"),
  ("ativos financeiros ao custo amortizado", "IFRS: Financial assets at amortised cost","93"),
  ("ativos financeiros ao justo valor atraves de outro rendimento integral", "IFRS: Financial assets at fair value through other comprehensive income","93"),
  ("ativos financeiros mandatoriamente ao justo valor atraves de resultados","IFRS: Non-trading financial assets mandatorily at fair value through profit or loss","93"),
  ("investimentos em associadas e filiais excluidas da consolidacao", "Investments in subsidiaries, joint ventures and associates","93")
;


--LEGAL PERSONS
CREATE TABLE bu_captools_work.vds_out_legalp_instruments (
  v_1_instrument_id STRING COMMENT "Identification information -Instrument Identifier",
  v_2_counterparty_id STRING COMMENT "Identification information-Counterparty Identifier",
  v_3_crr_expo_class STRING COMMENT "Exposure class-CRR Exposure class", --Dropdown
  v_4_finrep_expo_class STRING COMMENT "Exposure class-FINREP Exposure class", --Dropdown
  v_5_total_risk_expo_amnt DOUBLE COMMENT "Risk parameters-Total Risk Exposure Amount",
  v_6_lgd DOUBLE COMMENT "Risk parameters-CRR Loss given default",
  v_7_ifrs9_lgd DOUBLE COMMENT "Risk parameters-IFRS 9 Loss given default"
);


CREATE TABLE bu_captools_work.vds_out_legalp_counterparties (
  v_2_counterparty_id STRING COMMENT "Identification information-Counterparty Identifier",
  v_8_curr_intrnl_cred_rating STRING COMMENT "Risk parameters-Current Internal Credit Rating/Scoring",
  v_9_ext_cred_rating STRING COMMENT "Risk parameters-External Credit Rating",
	v_10_ifrs9_pd DOUBLE COMMENT "Risk parameters-IFRS 9 Probability of default/impairment",
  v_11_pd DOUBLE COMMENT "Risk parameters-Probability of default (others)"
);


CREATE TABLE bu_captools_work.vds_out_legalp_protections (
  v_12_protection_id STRING COMMENT "Identification information-Protection identifier",
	v_1_instrument_id STRING COMMENT "Identification information -Instrument Identifier",
	v_187_collateral_type STRING COMMENT "Identification information -Type of collateral", --Dropdown
  v_14_building_area STRING COMMENT "Size collateral-Building Area (M2)",
	v_15_landing_area STRING COMMENT "Size collateral-Land Area (M2)",
	v_16_property_postcode STRING COMMENT "Location-Property postcode",
	v_17_lien_position DOUBLE COMMENT "Lien-Lien position",
	v_18_collateral_ship_type STRING COMMENT "Collateral characteristics-Detailed type of Shipping collateral" --Dropdown
);


--NATURAL PERSONS
CREATE TABLE bu_captools_work.vds_out_naturalp_instruments (
  v_1_instrument_id STRING COMMENT "Identification information -Instrument Identifier",
  v_2_counterparty_id STRING COMMENT "Identification information-Counterparty Identifier",
  v_139_report_data_id STRING COMMENT "Identification information-Reporting data identifier",
  v_140_observed_agnt_id STRING COMMENT "Identification information-Observed agent identifier",
  v_141_contract_id STRING COMMENT "Identification information-Contract identifier",
  v_3_crr_expo_class STRING COMMENT "Exposure class-CRR Exposure class", --Dropdown
  v_4_finrep_expo_class STRING COMMENT "Exposure class-FINREP Exposure class", --Dropdown
  v_5_total_risk_expo_amnt DOUBLE COMMENT "Risk parameters-Total Risk Exposure Amount",
  v_6_lgd DOUBLE COMMENT "Risk parameters-CRR Loss given default",
  v_7_ifrs9_lgd DOUBLE COMMENT "Risk parameters-IFRS 9 Loss given default",
  v_35_instrument_type STRING COMMENT "Instrument characteristics-Type of instrument", --Dropdown
  v_142_amortization_type STRING COMMENT "Instrument characteristics-Type of instrument", --Dropdown
	v_143_currency STRING COMMENT "Instrument characteristics-Currency", --Dropdown
  v_144_inception_date STRING COMMENT "Instrument characteristics-Inception date",
	v_145_end_date_interest STRING COMMENT "Interest rate information-End date of interest-only period",
  v_146_interest_rate_cap DOUBLE COMMENT "Interest rate information-Interest rate cap",
  v_147_interest_rate_floor DOUBLE COMMENT "Interest rate information-Interest rate floor",
  v_148_interest_rate_rst_freq STRING COMMENT "Interest rate information-Interest rate reset frequency", --Dropdown
  v_149_interest_rate_spread DOUBLE COMMENT "Interest rate information-Interest rate spread/margin",
  v_150_interest_rate_type STRING COMMENT "Interest rate information-Interest rate type", --Dropdown
	v_151_legal_final_maturity_date STRING COMMENT "Instrument characteristics-Legal final maturity date",
  v_152_commitment_inception_amnt DOUBLE COMMENT "Instrument characteristics-Commitment amount at inception",
	v_153_capital_payment_freq STRING COMMENT "Instrument characteristics-Capital Payment frequency", --Dropdown
  v_153_interest_payment_freq STRING COMMENT "Instrument characteristics-Interest Payment frequency", --Dropdown
  v_154_reference_rate STRING COMMENT "Instrument characteristics-Reference rate", --Dropdown
  v_155_settlement_date STRING COMMENT "Instrument characteristics-Settlement date", --Dropdown
  v_156_interest_rate DOUBLE COMMENT "Interest rate information-Interest rate",
  v_157_next_interest_rst_date STRING COMMENT "Interest rate information-Next interest rate reset date",
  v_158_dflt_status STRING COMMENT "Financial information-Default status of the instrument", --Dropdown
	v_159_dflt_status_date STRING COMMENT "Financial information-Date of the default status of the instrument", --Dropdown
  v_160_transfered_amnt STRING COMMENT "Financial information-Transferred amount",
  v_161_arrears STRING COMMENT "Financial information-Arrears for the instrument",
  v_162_past_due_date STRING COMMENT "Financial information-date of past due for the instrument",
  v_163_securitization_type STRING COMMENT "Financial information/Instrument characteristics-Type of securitization", --Dropdown
	v_164_outstanding_nominal_amnt DOUBLE COMMENT "Instrument characteristics-Outstanding nominal amount",
  v_165_accrued_interest DOUBLE COMMENT "Instrument characteristics-Accrued interest",
  v_166_off_balance_sheet_amnt DOUBLE COMMENT "Financial information-Off-balance-sheet amount",
  v_167_joint_liabilities_amnt DOUBLE COMMENT "Financial information-Joint liabilities amount",
  v_168_accounting_classification STRING COMMENT "Financial information-Accounting classification of instruments", --Dropdown
	v_169_balance_sheet_recognition STRING COMMENT "Financial information-Balance sheet recognition", --Dropdown
  v_170_accumltd_write_offs DOUBLE COMMENT "Financial information-Accumulated write-offs",
	v_171_accumltd_impairment_amnt DOUBLE COMMENT "Financial information-Accumulated impairment amount",
	v_172_impairment_type STRING COMMENT "Financial information-Type of impairment", --Dropdown
  v_173_impairment_assmnt_method STRING COMMENT "Financial information-Impairment assessment method", --Dropdown
	v_174_encumbrance_souces STRING COMMENT "Instrument characteristics-Sources of encumbrance", --Dropdown
  v_175_performing_status STRING COMMENT "Financial information-Performing status of the instrument", --Dropdown
	v_176_performing_status_date STRING COMMENT "Financial information-Date of the performing status of the instrument",
	v_177_provisions_offbal DOUBLE COMMENT "Financial information-Provisions associated with off-balance-sheet exposures",
	v_178_forbearance_status STRING COMMENT "Forbearance information-Status of forbearance and renegotiation", --Dropdown
	v_179_forbearance_status_date STRING COMMENT "Forbearance information- Date of the forbearance and renegotiation status",
  v_180_cumulative_recoveries DOUBLE COMMENT "Default information-Cumulative recoveries since default",
	v_181_carrying_amnt DOUBLE COMMENT "Financial information-Carrying amount",
	v_182_prudential_portofolio STRING COMMENT "Financial information-Prudential portfolio", --Dropdown
	v_183_accumltd_chages DOUBLE COMMENT "Valuation-Accumulated changes in fair value due to credit risk"
);


CREATE TABLE bu_captools_work.vds_out_naturalp_counterparties (
  v_2_counterparty_id STRING COMMENT "Identification information-Counterparty Identifier",
	v_139_pd DOUBLE COMMENT "Risk	parameters-Probability of default",
	v_8_curr_intrnl_cred_rating DOUBLE COMMENT "Risk	parameters-Current Internal	Credit Rating/Scoring",
	v_10_ifrs9_pd DOUBLE COMMENT "Risk parameters-IFRS 9 Probability of default/impairment",
  v_11_pd_others DOUBLE COMMENT "Risk parameters-Probability of default	(others)",
	v_184_counterparty_role STRING COMMENT "Counterparty characteristics-Counterparty	role", --Dropdown
  v_185_dflt_status STRING COMMENT "Financial information-Default status of	the	counterparty", --Dropdown
	v_186_dflt_status_date STRING COMMENT "Financial information-Date of the default status of	the	counterparty"
);


CREATE TABLE bu_captools_work.vds_out_naturalp_protections (
  v_12_protection_id STRING COMMENT "Identification information-Protection	identifier",
  v_219_protection_provider_id STRING COMMENT "Identification information-Protection	provider identifier",
	v_1_instrument_id STRING COMMENT "Identification information - Instrument Identifier",
	v_187_collateral_type STRING COMMENT "Identification information - Type of collateral", --Dropdown
	v_14_building_area DOUBLE COMMENT "Size collateral-Building Area (M2)",
	v_15_landing_area DOUBLE COMMENT "Size collateral-Land Area (M2)",
	v_16_property_postcode STRING COMMENT "Location-Property postcode",
	v_17_lien_position DOUBLE COMMENT "Lien-Lien position",
	v_188_protect_value_date STRING COMMENT "Valuation-Date of protection value",
	v_220_protect_value DOUBLE COMMENT "Valuation-Protection value",
	v_189_protect_maturity_date STRING COMMENT "Protection characteristics-Maturity date	of the	protection",
	v_190_orig_protect_value DOUBLE COMMENT "Valuation-Original protection	value",
	v_191_orig_protect_value_date STRING COMMENT "Valuation-Date of original protection value",
	v_192_protect_value_type STRING COMMENT "Valuation-Type of protection value",	  --Dropdown
  v_221_protect_valuation_apprch STRING COMMENT "Valuation-Protection valuation approach",		--Dropdown
	v_193_protect_alloc_value DOUBLE COMMENT "Valuation-Protection	allocated value",
	v_194_third_party_prrty_claims DOUBLE COMMENT "Lien-Third-party Priority claims against the protection"
);


--OFF BALANCE SHEET EXPOSURES
CREATE TABLE bu_captools_work.vds_out_offbal_instruments (
  v_1_instrument_id STRING COMMENT "Identification information -Instrument Identifier",
	v_2_counterparty_id STRING COMMENT "Identification information-Counterparty Identifier",
	v_139_report_data_id STRING COMMENT "Identification information-Reporting data identifier",
  v_140_observed_agnt_id STRING COMMENT "Identification information-Observed agent identifier",
  v_141_contract_id STRING COMMENT "Identification information-Contract identifier",
  v_222_type STRING COMMENT "Exposure class-Type",
  v_3_crr_expo_class STRING COMMENT "Exposure class-CRR Exposure class", --Dropdown
	v_4_finrep_expo_class STRING COMMENT "Exposure class-FINREP Exposure class", --Dropdown
	v_23_cff DOUBLE COMMENT "Risk parameters-Credit conversion factor",
  v_5_total_risk_expo_amnt DOUBLE COMMENT "Risk parameters-Total Risk Exposure Amount",
	v_6_lgd DOUBLE COMMENT "Risk parameters-CRR Loss given default",
	v_7_ifrs9_lgd DOUBLE COMMENT "Risk parameters-IFRS 9 Loss given default",
	v_223_nominal_amnt DOUBLE COMMENT "Financial information-Nominal amount",
	v_224_maturity_date STRING COMMENT "Financial information-Maturity / expiry date",
	v_225_nominal_interest_rate DOUBLE COMMENT "Financial information-Nominal interest rate or fee",
	v_158_dflt_status STRING COMMENT "Financial information-Default status of the instrument", --Dropdown
	v_159_dflt_status_date STRING COMMENT "Financial information- date of the default status of the instrument", --Dropdown
	v_161_arrears DOUBLE COMMENT "Financial information-Arrears for the instrument",
	v_162_past_due_date STRING COMMENT "Financial information- date of past due for the instrument",
	v_167_joint_liabilities_amnt DOUBLE COMMENT "Financial information-Joint liabilities amount",
  v_171_impairment_accumltd_amnt DOUBLE COMMENT "Financial information-Accumulated impairment amount",
	v_172_impairment_type STRING COMMENT "Financial information-Type of impairment", --Dropdown
	v_173_impairment_assmnt_method STRING COMMENT "Financial information-Impairment assessment method", --Dropdown
  v_175_performing_status STRING COMMENT "Financial information-Performing status of the instrument", --Dropdown
	v_176_performing_status_date STRING COMMENT "Financial information- date of the performing status of the instrument",
	v_178_forbearance_status STRING COMMENT "Forbearance information-Status of forbearance and renegotiation",  --Dropdown
	v_179_forbearance_status_date STRING COMMENT "Forbearance information- date of the forbearance and renegotiation status "
);


CREATE TABLE bu_captools_work.vds_out_offbal_counterparties (
  v_2_counterparty_id STRING COMMENT "Identification information-Counterparty Identifier",
	v_139_pd DOUBLE COMMENT "Risk parameters-Probability of default",
	v_8_curr_intrnl_cred_rating STRING COMMENT "Risk parameters-Current Internal Credit Rating/Scoring",
	v_9_ext_cred_rating STRING COMMENT "Risk parameters-External Credit Rating",
	v_10_ifrs9_pd DOUBLE COMMENT "Risk parameters-IFRS 9 Probability of default/impairment",
  v_11_pd_others DOUBLE COMMENT "Risk parameters-Probability of default (others)",
  v_185_dflt_status STRING COMMENT "Financial information-Default status of the counterparty", --Dropdown
	v_186_dflt_status_date STRING COMMENT "Financial information- date of the default status of the counterparty", --Dropdown
	v_195_lei STRING COMMENT "Identification information-Legal entity identifier (LEI)",
	v_196_national_id STRING COMMENT "Identification information-National identifier",
  v_197_head_office_undrtk_id STRING COMMENT "Identification information-Head office undertaking identifier",
	v_198_immediate_parent_undrtk_id STRING COMMENT "Identification information-Immediate parent undertaking identifier",
  v_199_ultimate_parent_undrtk_id STRING COMMENT "Identification information-Ultimate parent undertaking identifier",
  v_200_name STRING COMMENT "Identification information-Name",
  v_201_addr_street STRING COMMENT "Location information-Address: street",
	v_202_addr_city STRING COMMENT "Location information-Address: city/town/village",
	v_203_addr_postal_code STRING COMMENT "Location information-Address: postal code",
	v_204_addr_county STRING COMMENT "Location information-Address: county/administrative division",
	v_205_addr_country STRING COMMENT "Location information-Address: country", --Dropdown
	v_206_legal_form STRING COMMENT "Counterparty characteristics-Legal form", --Dropdown
  v_207_institutional_sector STRING COMMENT "Counterparty characteristics-Institutional sector", --Dropdown
	v_208_economic_activity STRING COMMENT "Counterparty characteristics-Economic activity", --Dropdown
	v_209_legal_prcdngs_status STRING COMMENT "Default information-Status of legal proceedings", --Dropdown
	v_210_legal_prcdngs_status_date STRING COMMENT "Default information- date of initiation of legal proceedings",
	v_211_enterprise_size STRING COMMENT "Counterparty characteristics-Enterprise size", --Dropdown
	v_212_enterprise_size_date STRING COMMENT "Counterparty characteristics- date of enterprise size",
	v_213_number_employees DOUBLE COMMENT "Counterparty characteristics-Number of employees",
	v_214_balance_sheet_total DOUBLE COMMENT "Financial information-Balance sheet total",
	v_215_annual_turnover DOUBLE COMMENT "Financial information-Annual turnover",
	v_216_accounting_standard STRING COMMENT "Financial information-Accounting standard"
);


CREATE TABLE bu_captools_work.vds_out_offbal_protections (
  v_12_protection_id STRING COMMENT "Identification information-Protection identifier",
	v_1_instrument_id STRING COMMENT "Identification information -Instrument Identifier",
	v_219_protection_provider_id STRING COMMENT "Identification information-Protection provider identifier",
	v_187_collateral_type STRING COMMENT "Identification information -Type of collateral", --Dropdown
	v_14_building_area DOUBLE COMMENT "Size collateral-Building Area (M2)",
	v_15_land_area DOUBLE COMMENT "Size collateral-Land Area (M2)",
	v_16_property_postcode STRING COMMENT "Location-Property postcode",
	v_17_lien_position DOUBLE COMMENT "Lien-Lien position",
	v_188_protect_value_date STRING COMMENT "Valuation-Date of protection value",
	v_220_protect_value DOUBLE COMMENT "Valuation-Protection value",
	v_189_protect_maturity_date STRING COMMENT "Protection characteristics-Maturity date of the protection",
	v_190_orig_protect_value DOUBLE COMMENT "Valuation-Original protection value",
	v_191_orig_protect_value_date STRING COMMENT "Valuation-Date of original protection value",
	v_192_protect_value_type STRING COMMENT "Valuation-Type of protection value", --Dropdown
  v_221_protect_valuation_apprch STRING COMMENT "Valuation-Protection valuation approach", --Dropdown
	v_217_protect_alloc_value DOUBLE COMMENT "Valuation-Protection allocated value",
	v_218_third_party_prrty_claims DOUBLE COMMENT "Lien-Third-party priority claims against the protection"
  );


--DERIVATIVES
CREATE TABLE bu_captools_work.vds_out_derivatives (
    v_140_unique_trade_id STRING COMMENT "Parties to the financial contract-Unique trade identifier",
  	v_2_counterparty_id STRING COMMENT "Parties to the financial contract-Counterparty ID",
  	v_24_type_counterparty_id STRING COMMENT "Parties to the financial contract-Type of ID of the counterparty of the reporting entity",  --DROPDOWN
  	v_25_counterparty_country STRING COMMENT "Parties to the financial contract-Country of the counterparty", --DROPDOWN
  	v_26_base_product STRING COMMENT "Exposure class-Base product", --DROPDOWN
  	v_27_product_id STRING COMMENT "Specific information-Product ID",
    v_28_gorverning_law STRING COMMENT "Specific information-Governing law", --DROPDOWN
  	v_29_writedown_consersion  STRING COMMENT "Specific information-Contractual recognition: Write down and conversion powers (only for contracts governed by third-country laws subject to the requirement of the contractual terms under the first subparagraph of Article 55(1) of BRRD)",
  	v_30_suspension_treatment STRING COMMENT "Specific information-Contractual recognition: Suspension of termination rights (only for contracts governed by third-country laws) under Article 7 BRRD",
  	v_31_resolution_powers STRING COMMENT "Specific information-Contractual recognition: Resolution powers (only for contracts governed by third-country laws)",
  	v_32_collateral_portfolio STRING COMMENT "Collateral information-Collateral portfolio",
  	v_33_collateral_posted DECIMAL(18,2) COMMENT"Collateral information-Collateral posted",
    v_34_currency_col_posted STRING COMMENT "Collateral information-Currency of the collateral posted", --DROPDOWN
    v_37_collateral_received DECIMAL(18,2) COMMENT "Collateral information-Collateral received",
  	v_38_currency_col_received STRING COMMENT "Collateral information-Currency of the collateral received", --DROPDOWN
  	v_41_leg1_cashflow STRING COMMENT "Specific information derivatives-Leg 1 cash flow",
    v_42_leg2_cashflow STRING COMMENT "Specific information derivatives-Leg 2 cash flow",
  	v_43_leg1_ref_rate STRING COMMENT "Specific information: interest rate derivatives-Leg 1 reference rate", --DROPDOWN
  	v_44_leg2_ref_rate STRING COMMENT "Specific information: interest rate derivatives-Leg 2 reference rate", --DROPDOWN
  	v_45_leg1_ref_period STRING COMMENT "Specific information: interest rate derivatives-Leg 1 reference period", --DROPDOWN
    v_46_leg2_ref_period STRING COMMENT "Specific information: interest rate derivatives-Leg 2 reference period", --DROPDOWN
  	v_49_premium DOUBLE COMMENT "Specific information: credit derivatives-Premium",
  	v_51_netting_agreement STRING COMMENT "Details on the transaction-Netting agreement",
  	v_52_carrying_amnt DOUBLE COMMENT "Accounting information-Carrying amount",
  	v_53_accounting_standards STRING COMMENT "Accounting information-Accounting standards",
    v_54_accounting_classification STRING COMMENT "Accounting information-Accounting classification",
    v_55_hierarchy STRING COMMENT "Accounting information-Hierarchy",
  	v_56_hedge_id STRING COMMENT "Risk parameters-Hedge ID",
  	v_5_total_risk_expo_amnt DOUBLE COMMENT "Risk parameters-Total Risk Exposure Amount"
);


--DEBT SECURITIES
CREATE TABLE bu_captools_work.vds_out_debt_securities (
  v_58_financial_contract_id STRING COMMENT "Financial contract type -Financial contract ID",
	v_59_isin STRING COMMENT "Issuer identification-ISIN",
	v_60_issuer_id STRING COMMENT "Issuer identification-ID of the issuer",
	v_61_type_issuer_id STRING COMMENT "Issuer identification-Type of ID of the issuer", --DROPDOWN
	v_62_country_issuer STRING COMMENT "Issuer identification-Country of the issuer", --DROPDOWN
	v_63_issuer_esa STRING COMMENT "Issuer identification-Issuer ESA 2010", --DROPDOWN
  v_64_issuer_nace STRING COMMENT "Issuer identification-Issuer NACE sector", --DROPDOWN
	v_65_issuer_rating STRING COMMENT "Issuer data-Issuer Rating(s)",
	v_66_issuer_rating_source STRING COMMENT "Issuer data-Issuer Rating(s) Source(s)",
	v_67_issuer_type STRING COMMENT "Parties to the financial contract-Type of Issuer",
  v_68_currency STRING COMMENT "Valuation-Currency of the value", --DROPDOWN
	v_69_valuation_timestamp STRING COMMENT "Valuation-Valuation timestamp",
	v_70_valuation_type STRING COMMENT "Valuation-Valuation type",
	v_71_inst_class STRING COMMENT "Security characteristics-Instrument class", --DROPDOWN
	v_72_primary_asset_class STRING COMMENT "Security characteristics-Primary asset classification", --DROPDOWN
	v_73_asset_securit_class STRING COMMENT "Security characteristics-Asset securitisation class", --DROPDOWN
	v_74_placement_type STRING COMMENT "Security characteristics-Type of placement",
	v_75_issuance_date STRING COMMENT "Security characteristics-Issuance date",
	v_76_maturity_date STRING COMMENT "Security characteristics-Maturity date",
	v_77_guarantor_id STRING COMMENT "Security characteristics-Guarantor ID",
	v_78_type_guarantor_id STRING COMMENT "Security characteristics-Guarantor ID type", --DROPDOWN
	v_79_security_rating STRING COMMENT "Security characteristics-Rating of the security",
	v_80_type_inst_seniority STRING COMMENT "Security characteristics-Instrument seniority type", --DROPDOWN
	v_81_coupon_type STRING COMMENT "Security characteristics-Coupon type",
	v_82_coupon_freq STRING COMMENT "Security characteristics-Coupon frequency",
	v_83_coupon_currency STRING COMMENT "Security characteristics-Coupon currency",
	v_84_coupon_rate STRING COMMENT "Security characteristics-Coupon rate",
	v_85_reference_rate DOUBLE COMMENT "Security characteristics-Reference rate",
	v_86_spread STRING COMMENT "Security characteristics-Spread",
	v_87_currency_nominal_amnt STRING COMMENT "Security characteristics-Currency of the nominal amount", --DROPDOWN
	v_88_purchase_under_resale STRING COMMENT "Use of security-Purchased under resale agreement",
	v_89_encumbrance_sources STRING COMMENT "Use of security-Sources of encumbrance", --DROPDOWN
	v_90_eligibility_ecb_ops STRING COMMENT "Use of security-Eligibility for standard central bank (ECB) operations",
	v_91_lcr_buffer STRING COMMENT "Use of security-Part of LCR buffer",
	v_92_lcr_buffer_category STRING COMMENT "Use of security-Category of LCR buffer",
	v_93_accounting_classification STRING COMMENT "Accounting information-Accounting classification of the instrument", --DROPDOWN
	v_94_performing_status STRING COMMENT "Accounting information-Performing status of the instrument", --DROPDOWN
	v_95_prudential_portfolio STRING COMMENT "Accounting information-Prudential portfolio of the instrument", --DROPDOWN
	v_96_hedge_id STRING COMMENT "Risk parameters-Hedge ID",
	v_5_total_risk_expo_amnt DOUBLE COMMENT "Risk parameters-Total Risk Exposure Amount"
);


--EQUITY INSTRUMENTS
CREATE TABLE bu_captools_work.vds_out_equity_instruments (
  v_58_financial_contract_id STRING COMMENT "Security characteristics-Financial contract ID",
	v_59_isin STRING COMMENT "Issuer identification-ISIN",
	v_60_issuer_id STRING COMMENT "Issuer identification-ID of the issuer",
	v_61_type_issuer_id STRING COMMENT "Issuer identification-Type of ID of the issuer", --DROPDOWN
	v_62_country_issuer STRING COMMENT "Issuer identification-Country of the issuer", --DROPDOWN
	v_63_issuer_esa STRING COMMENT "Issuer identification-Issuer ESA 2010", --DROPDOWN
	v_64_issuer_nace STRING COMMENT "Issuer identification-Issuer NACE sector", --DROPDOWN
	v_65_issuer_rating STRING COMMENT "Issuer characteristics -Issuer Rating(s)",
	v_66_issuer_rating_source STRING COMMENT "Issuer characteristics-Issuer Rating(s) Source(s)",
	v_67_issuer_type STRING COMMENT "Parties to the financial contract-Type of Issuer",
	v_68_currency STRING COMMENT "Valuation-Currency of the value", --DROPDOWN
	v_69_valuation_timestamp STRING COMMENT "Valuation-Valuation timestamp",
	v_70_valuation_type STRING COMMENT "Valuation-Valuation type",
	v_97_dividend_yield DOUBLE COMMENT "Valuation-Dividend yield",
	v_91_lcr_buffer STRING COMMENT "Use of security-Part of LCR buffer",
	v_93_accounting_classification STRING COMMENT "Accounting information-Accounting classification of the instrument", --DROPDOWN
	v_95_prudential_portfolio STRING COMMENT "Accounting information-Prudential portfolio of the instrument", --DROPDOWN
	v_5_total_risk_expo_amnt DOUBLE COMMENT "Risk parameters-Total Risk Exposure Amount"
);


--DTAS
CREATE TABLE bu_captools_work.vds_out_dtas (
  v_98_tax_group STRING COMMENT "DTA-Tax group",
	v_99_jurisdiction STRING COMMENT "DTA-Jurisdiction",
	v_100_tax_rate DOUBLE COMMENT "DTA-Tax rate",
	v_101_tax_group_profit DOUBLE COMMENT "DTA-Profit of relevant tax group",
	v_102_cap_existence STRING COMMENT "DTA-Existence of a cap on DTA/DTC recognition",
	v_103_losses DOUBLE COMMENT "Origin-DTA/DTC due to losses",
	v_104_temp_diff DOUBLE COMMENT "Origin-DTA/DTC due to temporary differences",
	v_105_cond_future_profit DOUBLE COMMENT "Conditions-DTA/DTC conditional on future profitability",
	v_106_notcond_future_profit DOUBLE COMMENT "Conditions-DTA/DTC not conditional on future profitability",
	v_107_other_coditions DOUBLE COMMENT "Conditions-DTA/DTC subject to other conditions",
	v_108_without_expiry_date DOUBLE COMMENT "Expiry date of DTA-DTA/DTC without an expiry date",
	v_109_expiring_lt1y DOUBLE COMMENT "Expiry date of DTA-DTA/DTC expiring within a year",
	v_110_expiring_1to2y DOUBLE COMMENT"Expiry date of DTA-DTA/DTC expiring within one to two years",
	v_111_expiring_2to3y DOUBLE COMMENT "Expiry date of DTA-DTA/DTC expiring within two to three years",
	v_112_expiring_3to4y DOUBLE COMMENT "Expiry date of DTA-DTA/DTC expiring within three to four years",
	v_113_expiring_4to5y DOUBLE COMMENT "Expiry date of DTA-DTA/DTC expiring within four to five years",
	v_114_expiring_gt5y DOUBLE COMMENT "Expiry date of DTA-DTA/DTC expiring in more than five years"
);


--INTANGIBLE ASSETS
CREATE TABLE bu_captools_work.vds_out_intangible_assets (
  v_115_asset_id DOUBLE COMMENT "Identification information-Asset identifier ID",
	v_116_asset_class STRING COMMENT "Asset characteristics-Intangible asset class",
	v_117_acquisition_date STRING COMMENT "Asset characteristics-Acquisition/capitalisation date",
	v_118_init_fair_value DOUBLE COMMENT "Asset characteristics-Initial fair value",
	v_119_cumulative_amortisation DOUBLE COMMENT "Asset characteristics-Cumulative amortisation",
	v_120_impairment_amnt DOUBLE COMMENT "Asset characteristics-Impairment amount",
	v_121_carrying_amnt DOUBLE COMMENT "Asset characteristics-Current carrying amount",
	v_122_currency STRING COMMENT "Asset characteristics-Currency", --DROPDOWN
	v_123_orig_accounting_life STRING COMMENT "Asset characteristics-Original accounting life",
	v_125_remaining_econ_life STRING COMMENT "Asset characteristics-Remaining economic life",
	v_126_carrying_amnt_apprch STRING COMMENT "Asset characteristics-Approach to determining carrying amount",
	v_69_valuation_timestamp STRING COMMENT "Valuation information-Valuation timestamp",
	v_127_latest_valuation STRING COMMENT "Valuation information-Internal/External Latest Valuation"
);


--GOODWILL
CREATE TABLE bu_captools_work.vds_out_goodwill (
  v_128_asset_id STRING COMMENT "Intangibles: goodwill-Asset ID",
	v_129_source STRING COMMENT "Intangibles: goodwill-Source of goodwill",
	v_130_lei STRING COMMENT "Intangibles: goodwill-Legal entity ID",
	v_131_lei_type STRING COMMENT "Intangibles: goodwill-Type of ID of the legal entity", --DROPDOWN
	v_132_year_created DOUBLE COMMENT "Intangibles: goodwill-Year created",
	v_133_carrying_amount DOUBLE COMMENT "Intangibles: goodwill-Carrying amount",
	v_134_audit_opinion STRING COMMENT "Intangibles: goodwill -Opinion of audit", --TEXTO GRANDE?
	v_137_impairment_test_result DOUBLE COMMENT "Intangibles: goodwill-Result impairment test",
	v_138_impairment_test_date STRING COMMENT "Intangibles: goodwill- date of latest impairment test"
);


--Univ Saldo
    --Esta query usa um versão mensal(CD_CAPTOOLS.CT001_UNIV_SALDO) e diária (CD_CAPTOOLS.CT083_UNIV_SAL_D)

CREATE TABLE bu_captools_work.vds_inp_ct_univ_saldo AS
SELECT	CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id,
        ccontab_final_st_sgps,
        msaldo_final,
        ccontab_final_pcsb,
        ccontab_final_ifrs
FROM cd_captools.ct001_univ_saldo --Esta query usa um versão mensal(CD_CAPTOOLS.CT001_UNIV_SALDO) e diária (CD_CAPTOOLS.CT083_UNIV_SAL_D)
WHERE	ref_date = ${VAR:REFDATE};


--Univ Contratos
    --Esta query usa um versão mensal(CD_CAPTOOLS.ct004_univ_cto) e diária (CD_CAPTOOLS.ct085_univ_cto_d)

CREATE TABLE bu_captools_work.vds_inp_ct_univ_cto AS
SELECT	CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id,
        zcliente,
        dincump,  --rever formatação da data
        tipo_analise,
        stage,
        ref_date   --rever formatação da data
FROM CD_CAPTOOLS.ct004_univ_cto
WHERE	ref_date = ${VAR:REFDATE};


--Univ Clientes
    --Esta query usa um versão mensal(CD_CAPTOOLS.ct003_univ_cli) e diária (CD_CAPTOOLS.ct084_univ_cli_d)
CREATE TABLE bu_captools_work.vds_inp_ct_univ_cli AS
SELECT  zcliente,
        ctipo_doc_identif1,
        cnum_doc_identif1,
        clei,
        cpais_residencia,
        csector_inst,
        itip_cli,
        cnif_resid,
        gcliente,
        ccae,
        nace_code
FROM cd_captools.ct003_univ_cli --Esta query usa um versão mensal(CD_CAPTOOLS.ct003_univ_cli) e diária (CD_CAPTOOLS.ct084_univ_cli_d)
WHERE	ref_date = ${VAR:REFDATE};


--Univ Titulos
CREATE TABLE bu_captools_work.vds_inp_ct_univ_titulos AS
SELECT  CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id,
        isin,
        tipo_oferta,
        dt_emissao, --rever formatação da data
        dt_vencim,  --rever formatação da data
        rating_sp,
        rating_moodys,
        rating_fitch,
        rating_dbrs,
        tipo_tx,
        tx_fixa,  --INPUT(TX_FIXA, 8.) AS TX_FIXA, // rever
        /*,TX_FIXA LENGTH = 8*/
        tx_vigente,
        SPLIT_PART(SPRD_TX_VAR,";",1) AS SPRD_TX_VAR,  --  INPUT(SPLIT_PART(SPRD_TX_VAR,";",1), 8.) AS SPRD_TX_VAR, // rever
        frq_liq_jur,
        eleg_eurosistema,
        grau_liquidez,
        zcliente_emitente,
        cmoeda,
        entidade_garante,
        tipo_titulo
FROM cd_captools.ct610_titulos
WHERE	ref_date = ${VAR:REFDATE};



CREATE TABLE bu_captools_work.vds_inp_ct_univ_tat91_206 AS
SELECT	tayd91c0_celemtab,
				tayd91c0_nelemc01
FROM cd_captools.tat91_206;



CREATE TABLE bu_captools_work.vds_inp_ct_univ_tat91_015 AS
SELECT  tayd91c0_nelemc09,
        tayd91c0_celemtab
FROM cd_captools.tat91_015;


CREATE TABLE bu_captools_work.vds_inp_ct_univ_finrep AS
SELECT  CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id,
        contraparte_i,
        carteira_contabilistica
FROM	cd_captools.ct081_finrep
WHERE	ref_date = ${VAR:REFDATE};


--Perimetros
CREATE TABLE bu_captools_work.vds_inp_ct_univ_perimetros AS
SELECT  cod_soc_cpus,
        st_sgps_portugal_regulatorio
FROM cd_captools.perimetro
WHERE	data_date_part = ${VAR:DATADATEPART};


--DIM VALOR
  CREATE TABLE bu_captools_work.vds_inp_ct_dim_valor AS
SELECT  cod_atributo_dim,
        nome_atributo_dim,
        id_dimensao
FROM 	cd_captools.ct010_dim_valor
WHERE	ref_date = ${VAR:REFDATE};


--Univ Contratos - get max ref date
CREATE TABLE bu_captools_work.vds_inp_ct_univ_cto_v176 AS
SELECT  CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id,
        stage,
        ref_date    --rever formatação da data
FROM	cd_captools.ct004_univ_cto
WHERE	STAGE IN('1','2','3')
AND REF_DATE < ${VAR:REFDATE};


--Univ GR Cli
    --Esta query usa um versão mensal(CD_CAPTOOLS.ct070_univ_gr_cli) e diária (CD_CAPTOOLS.ct088_univ_gr_cli_d)
CREATE TABLE bu_captools_work.vds_inp_ct_univ_gr_cli AS
SELECT 	zcliente,
        zgrupo
FROM cd_captools.ct070_univ_gr_cli  --Esta query usa um versão mensal(CD_CAPTOOLS.ct070_univ_gr_cli) e diária (CD_CAPTOOLS.ct088_univ_gr_cli_d)
WHERE ref_date = ${VAR:REFDATE};



--Core
    --Esta query usa um versão mensal(cd_alm.al029_cnt_core_m) e diária (cd_alm.al001_cnt_core)
CREATE TABLE bu_captools_work.vds_inp_al_cnt_core AS
SELECT    CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_al,
          CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta)) AS instrument_id_al_x,
          zcliente,
          dfim_care,  --rever formatação da data,
          dinicio,    --rever formatação da data,
          dfim,       --rever formatação da data,
          cmoeda_pas,
          cmoeda_act,
          dt_prox_renov_taxa_pas,
          dt_prox_renov_taxa_act,
          cod_tipo_taxa_ref_pas,
          cod_tipo_taxa_ref_act,
          tx_spread_pas_1,
          tx_spread_act_1,
          cmetamis,
          cod_freq_amort_capital_act,
          cod_freq_amort_capital_pas,
          cod_tipo_amortizacao,
          cod_freq_liq_jur_pas,
          cod_freq_liq_jur_act,
          cod_freq_taxa_pas,
          cod_freq_taxa_act,
          tx_contrato_pas,
          tx_contrato_act,
          cproduto_mis
FROM cd_alm.al029_cnt_core_m    --Esta query usa um versão mensal(cd_alm.al029_cnt_core_m) e diária (cd_alm.al001_cnt_core)
WHERE	ref_date = ${VAR:REFDATE};


--Saldos
    --Esta query usa um versão mensal(cd_alm.al030_sld_core_m) e diária (cd_alm.al002_sld_core)
CREATE TABLE bu_captools_work.vds_inp_al_sld_core AS
SELECT    CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_al,
          zcliente,
          SUM(mon_cap_st1_vivo + mon_cap_st1_c0 + mon_cap_st1_c1+ mon_cap_st1_co + mon_cap_st2_vivo + mon_cap_st2_c0 + mon_cap_st2_c1 + mon_cap_st2_co + mon_cap_st3_vivo + mon_cap_st3_c0 + mon_cap_st3_c1 + mon_cap_st3_co) AS mon_cap_total,
          SUM(mon_jur_st1 + mon_jur_st1_c0 + mon_jur_st1_c1 + mon_jur_st1_co + mon_jur_st2 + mon_jur_st2_c0 + mon_jur_st2_c1 + mon_jur_st2_co + mon_jur_st3 + mon_jur_st3_c0 + mon_jur_st3_c1 + mon_jur_st3_co) AS mon_jur_total,
          SUM(mon_extrapatri) AS mon_extrapatri,
          SUM(mon_imparid_patri) AS mon_imparid_patri,
          SUM(mon_imparidade_extra) AS mon_imparidade_extra,
          SUM(mon_comissoes) AS mon_comissoes,
          SUM(mon_despesas) AS mon_despesas
FROM cd_alm.al030_sld_core_m    --Esta query usa um versão mensal(cd_alm.al030_sld_core_m) e diária (cd_alm.al002_sld_core)
WHERE	ref_date = ${VAR:REFDATE}
GROUP BY
			instrument_id_al,
			zcliente;


--Tradutor de Chaves
    --Esta query usa um versão mensal(cd_alm.kt_chaves_alm_m) e diária (cd_alm.kt_chaves_alm)
CREATE TABLE bu_captools_work.vds_inp_kt_chaves_alm AS
SELECT	CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_al,
        CONCAT(TRIM(cempresa_master), '_', TRIM(cbalcao_master), '_', TRIM(cnumecta_master), '_', TRIM(zdeposit_master)) AS instrument_id
FROM cd_alm.kt_chaves_alm_m   --Esta query usa um versão mensal(cd_alm.kt_chaves_alm_m) e diária (cd_alm.kt_chaves_alm)
WHERE	ref_date = ${VAR:REFDATE};


--SAQ PPC
CREATE TABLE bu_captools_work.vds_inp_al_saq_ppc AS
SELECT	CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_al,
        cprograma
FROM cd_alm.AL006_SAQ_PPC   --Esta query usa uma versão mensal e diária
WHERE	ref_date = ${VAR:REFDATE};


--Programa PPC
CREATE TABLE bu_captools_work.vds_inp_al_prog_ppc AS
SELECT  cprograma,
        dbreak_clause    --rever formatação da data
FROM	cd_alm.al007_prog_ppc    --Esta query usa uma versão mensal e diária
WHERE	ref_date = ${VAR:REFDATE};


--Perímetros
    --Esta query usa um versão mensal(cd_alm.al031_peri_alm_m) e diária (cd_alm.al008_peri_alm)
CREATE TABLE bu_captools_work.vds_inp_al_peri_alm AS
SELECT DISTINCT CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_al,
                zcliente
FROM cd_alm.al031_peri_alm_m    --Esta query usa um versão mensal(cd_alm.al031_peri_alm_m) e diária (cd_alm.al008_peri_alm)
WHERE	ref_date = ${VAR:REFDATE}
  AND nome_perimetro = 'Individual Local'
  AND entidade = '00100';


--DET SWAPC
CREATE TABLE bu_captools_work.vds_inp_al_det_swapc AS
SELECT	CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_al,
        code_pcd,
        mon_premio
FROM	cd_alm.al005_det_swapc   --Esta query usa uma versão mensal e diária
WHERE	ref_date = ${VAR:REFDATE};


--DERIVADOS
CREATE TABLE bu_captools_work.vds_inp_al_derivados AS
SELECT DISTINCT CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_al,
                mon_strike
FROM	cd_alm.al011_derivados   --Esta query usa uma versão mensal e diária
WHERE	ref_date = ${VAR:REFDATE};


--REVER CHAVE E LIGAÇÃO
CREATE TABLE bu_captools_work. vds_inp_ept AS
SELECT 	CONCAT(TRIM(epyr5040_cempresa),'_', TRIM(epyr5040_ckbalcao),'_', TRIM(epyr5040_cknumcta)) AS instrument_id_al_x,
        epyr5040_ept03_tkjuro
FROM 	cd_alm.ept03    --Esta query usa uma versão mensal e diária
WHERE	epyr5040_ept03_ccondliq = 'CAP' AND data_date_part = ${VAR:DATADATEPART};


--Plano de contas
CREATE TABLE bu_captools_work.vds_inp_fr_pl_contas AS
SELECT	conta,
				carteira_contabilistica,
				produto,
				cod_plano,
				composicao_valor,
				tipo_conta
FROM	cd_captools.fr802_pl_contas    --Esta query usa uma versão mensal e diária
WHERE	ref_date = ${VAR:REFDATE}
  AND cod_plano = 'BST_IND';


--Colaterais
CREATE TABLE bu_captools_work.vds_inp_fr_colaterais AS
SELECT	CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_fr,
        CONCAT(TRIM(cempresa), '_', TRIM(cbalcao_caucao), '_',TRIM(cnumecta_caucao), '_', TRIM(zcaucao)) AS protection_id,
        zcliente,
        dabertur,   --rever formatação da data,
        dvencime,   --rever formatação da data,
        mavaliaa,
        mavaliai,
        dultmod,   --rever formatação da data,
        cprodut_caucao,
        csubpro_caucao,
        garante
FROM	cd_captools.fr003_colaterais   --Esta query usa uma versão mensal e diária
WHERE	ref_date = ${VAR:REFDATE};


--Tradutor de Chaves
CREATE TABLE bu_captools_work.vds_inp_kt_chaves_fr AS
SELECT	CONCAT(TRIM(cempresa_fr), '_', TRIM(cbalcao_fr), '_',TRIM(cnumecta_fr), '_', TRIM(zdeposit_fr)) AS instrument_id_fr,
        CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id
FROM cd_captools.kt_chaves_finrep   --Esta query usa uma versão mensal e diária
WHERE	ref_date = ${VAR:REFDATE};


--Recup
CREATE TABLE bu_captools_work.vds_inp_fr_recup AS
SELECT  CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_',TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id_fr,
        valor
FROM cd_captools.fr009_recup    --Esta query usa uma versão mensal e diária
WHERE ref_date = ${VAR:REFDATE};


--Princ
CREATE TABLE bu_captools_work.vds_inp_ct_rwa_princ AS
SELECT  id_capital_perimetros,
        biengar1,
        indhipga,
        tip_mit,
        catprem_inicial,
        tipoajus,
        cod_spv,
        exercicio,
        s1emp,
        contra1,
        idnumcli,
        segmento_corep_final,
        ead_final_liquida,
        k2,
        rwa_final,
        ead_final_bruta
FROM cd_captools.ct013_rwa_princ
WHERE	ref_date = ${VAR:REFDATE}
  AND flag_cons_cap = 1
  AND exercicio = 'REAL';


--IRB
CREATE TABLE bu_captools_work.vds_inp_ct_rwa_irb AS
SELECT	biengar1,
        catprem_inicial,
        tipoajus,
        cod_spv,
        s1emp,
        contra1,
        lgdfinal,
        in_pdfin,
        in_pdini
FROM	cd_captools.ct014_rwa_irb
WHERE	ref_date = ${VAR:REFDATE};


--Cliente
CREATE TABLE bu_captools_work.vds_inp_ct_rwa_cli AS
SELECT	s1emp,
        idnumcli,
        num_empl,
        impfactm_cli,
        idpunsco,
        tot_acti
FROM cd_captools.ct021_rwa_cli
WHERE	ref_date = ${VAR:REFDATE};


--Tradutor de Chaves
CREATE TABLE bu_captools_work.vds_inp_kt_chaves_bdr AS
SELECT	s1emp,
        contra1,
        CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_', TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id
FROM	cd_captools.kt_chaves_bdr
WHERE	ref_date = ${VAR:REFDATE}
  AND UPPER(flag_scope) = 'PRIMARIO';


--Expected Loss
CREATE TABLE bu_captools_work.vds_inp_ct_ifrs_expected_loss AS
SELECT
a.contract_id, a.lgd_ifrs9, a.pd12m_ifrs9, a.pd_lt_ifrs9, a.ead
FROM
(
    SELECT contract_id, lgd_ifrs9, pd12m_ifrs9, pd_lt_ifrs9, ead, exec_id_part
    FROM cd_captools.ifrs9_out_expected_loss_8_7
) as a
INNER JOIN
(
    SELECT exec_id_part
    FROM cd_captools.imcatf046_flag_fecho
    WHERE cmes = CONCAT(SPLIT_PART(${VAR:REFDATE}, "-", 1), SPLIT_PART(${VAR:REFDATE}, "-", 2))
) as b
ON a.exec_id_part = b.exec_id_part;


--Staging
CREATE TABLE bu_captools_work.vds_inp_ct_ifrs_out_staging AS
SELECT
a.contract_id, a.final_stage
FROM
(
    SELECT contract_id, final_stage, exec_id_part
    FROM cd_captools.ifrs9_out_staging_8_7
) as a
INNER JOIN
(
    SELECT exec_id_part
    FROM cd_captools.imcatf046_flag_fecho
    WHERE cmes = CONCAT(SPLIT_PART(${VAR:REFDATE}, "-", 1), SPLIT_PART(${VAR:REFDATE}, "-", 2))
) as b
ON a.exec_id_part = b.exec_id_part;


--Tradutor de Chaves
CREATE TABLE bu_captools_work.vds_inp_kt_chaves_ifrs AS
SELECT	contract_id,
        CONCAT(TRIM(cempresa), '_', TRIM(cbalcao), '_',TRIM(cnumecta), '_', TRIM(zdeposit)) AS instrument_id
FROM	cd_captools.kt_chaves_ifrs9
WHERE	ref_date = ${VAR:REFDATE};


--Instrument
CREATE TABLE bu_captools_work.vds_inp_lt_instrument AS
SELECT	instrmnt_id AS instrument_id_lt,
        typ_instrmnt,
			  typ_amrtstn,
			  cmmtmnt_incptn_instrmnt,
			  dflt_stts_instrmnt,
			  dt_dflt_stts_instrmnt,
			  srcs_encmbrnc,
			  frbrnc_stts_instrmnt,
			  dt_frbrnc_stts,
			  hedge_id,
			  dt_vltn,
			  vltn_typ,
			  instrmnt_clss,
			  prmry_asst_clssf,
			  asst_scrt_clss,
			  prch_undr_rsl_agr,
			  instr_snrty_clss,
			  issr_typ,
			  arrrs_instrmnt,
			  otstndng_nmnl_amnt_instrmnt,
			  accmltd_chngs_fv_cr_instrmnt,
			  issr_rtng_src,
			  grntr_id_typ,
			  issr_id,
			  issr_id_typ,
			  issr_cntry,
			  issr_esa_2010
FROM	cd_loan_tapes_bce.lt002_instrument
WHERE	ref_date = ${VAR:REFDATE}; --"&MCR_REFDT_YMD10_LT."


--ENTITY
CREATE TABLE bu_captools_work.vds_inp_lt_entity AS
SELECT	entty_id,
			  intrnl_rtng,
			  extrnl_rtng,
			  lgl_prcdng_stts_le,
			  dt_inttn_lgl_prcdngs_le AS dt_inttn_lgl_prcdngs_le,
			  entrprs_sz_le,
			  annl_trnvr_le,
			  gcc_prnt_id,
			  ecnmc_actvty
FROM	cd_loan_tapes_bce.lt003_entity
WHERE	ref_date = ${VAR:REFDATE};  --"&MCR_REFDT_YMD10_LT."


--PROTECTION
CREATE TABLE bu_captools_work.vds_inp_lt_protection AS
SELECT	prtctn_id,
			  typ_prtctn,
			  rl_estt_pst_cd
FROM	cd_loan_tapes_bce.lt004_protection
WHERE	ref_date = ${VAR:REFDATE};  --"&MCR_REFDT_YMD10_LT."


--Instrument Entity
CREATE TABLE bu_captools_work.vds_inp_lt_instr_entity AS
SELECT	instrmnt_id,
			  entty_id,
			  jnt_lblty_amnt
FROM cd_loan_tapes_bce.lt005_instr_ent
WHERE	ref_date = ${VAR:REFDATE};  --"&MCR_REFDT_YMD10_LT."


--Instrument Protections
CREATE TABLE bu_captools_work.vds_inp_lt_instr_prot AS
SELECT	instrmnt_id AS instrument_id_lt,                                        -- Inicialmente chamava-se instrmnt_id, trocamos pois na query vds_tmp_loantapes_prtect_master usavam o campo instrument_id_lt o qual não existia e parecia crer dizer este campo
			  prtctn_id,
			  prtctn_allctd_vl,
			  thrd_prty_prrty_clms
FROM cd_loan_tapes_bce.lt006_instr_prot
WHERE	ref_date = ${VAR:REFDATE};  --"&MCR_REFDT_YMD10_LT."


--trocamos a tabela por bu_captools_work.vds_inp_cli_clt18 pela cd_estruturais.interface_moradas
-- Para analise futura: a tabela cd_estruturais.interface_moradas tem varias moradas para a mesma pessoa ao contrario da bu_captools_work.vds_inp_cli_clt18, existe um cmapo chamado zmorada que indica se a morada é a primeira, segunda ou terceira morada. Assumimos que queremos sempre trazer a preimeira morada. É necessário confirmar este entendimento.
CREATE TABLE bu_captools_work.vds_inp_cli_clt18 AS
SELECT  clyr7003_zcliente,   --PUT(CLYD18C1_ZCLIENTE, 32.) AS CLYD18C1_ZCLIENTE
		    clyr7003_nmorada,
        clyr7003_nlocalid,
        clyr7003_cpostal
FROM
(
    SELECT *
    FROM cd_estruturais.interface_moradas
    WHERE clyr7003_zmorada = 1
) AS a
INNER JOIN
(
    SELECT	MAX(data_date_part) AS data_date_part
    FROM cd_estruturais.interface_moradas
    WHERE data_date_part <= '2023-12-31'
) AS b
ON a.data_date_part = b.data_date_part
GROUP BY clyr7003_zcliente,
         clyr7003_nmorada,
         clyr7003_nlocalid,
         clyr7003_cpostal;

-- Alguma condição tem de estar mal feita uma vez que a variável produto_offbal vem sempre a NULL, algo que afeta as querys posteriosres principalmente a query bu_captools_work.vds_tmp_offbal_instruments (que acaba por vir sem valores)
--UNIV Data
CREATE TABLE bu_captools_work.vds_tmp_univ_master AS
SELECT	ctunivcto.*,
        ctunivcli.ctipo_doc_identif1,
        ctunivcli.cnum_doc_identif1,
        ctunivcli.clei,
        ctunivcli.cpais_residencia,
        ctunivcli.csector_inst,
        ctunivcli.itip_cli,
        ctunivcli.cnif_resid,
        ctunivcli.gcliente,
        ctunivcli.ccae,
        ctunivcli.nace_code,
        offbals.produto_offbal,
        ctunivtitulos.isin,
        ctunivtitulos.tipo_oferta,
        ctunivtitulos.dt_emissao,
        ctunivtitulos.dt_vencim,
        ctunivtitulos.rating_sp,
        ctunivtitulos.rating_moodys,
        CTUNIVTITULOS.RATING_FITCH,
        ctunivtitulos.rating_dbrs,
        ctunivtitulos.tipo_tx,
        ctunivtitulos.tx_fixa,
        ctunivtitulos.tx_vigente,
        ctunivtitulos.sprd_tx_var,
        ctunivtitulos.frq_liq_jur,
        ctunivtitulos.eleg_eurosistema,
        ctunivtitulos.grau_liquidez,
        ctunivtitulos.zcliente_emitente,
        ctunivtitulos.cmoeda,
        ctunivtitulos.entidade_garante,
         			/*,CTUNIVSALDO.MSALDO_FINAL
         			,CTUNIVSALDO.CCONTAB_FINAL_PCSB
         			,CTUNIVSALDO.CCONTAB_FINAL_IFRS*/
        ctunivfinrep.contraparte_i,
        ctunivfinrep.carteira_contabilistica,
        ctunivcountry.tayd91c0_nelemc09,
        ctunivcurrency.tayd91c0_nelemc01,
        financialassets.cod_atributo_dim,
         			/*,OFFBALS.CONTA*/
        grcli.zgrupo
FROM	bu_captools_work.vds_inp_ct_univ_cto AS ctunivcto
        LEFT JOIN bu_captools_work.vds_inp_ct_univ_cli AS ctunivcli
        ON ctunivcto.zcliente = ctunivcli.zcliente
        LEFT JOIN
        (
         	SELECT	ctunivsaldo.instrument_id,
                  MAX(produto) AS produto_offbal /*,
         					CONTA*/
         	FROM	bu_captools_work.vds_inp_ct_univ_saldo AS ctunivsaldo
          -- Neste select apenas trazemos porduto = 'outras responsabilidades perante terceiros', mas reparamos que para a data de 2023-12-31
          --e para carteira_contabilistica = 'garantias e compromissos concedidos' existem também os produtos "garatantias prestadas" e "compromissos perante terceiros"
          --Estes casos não deveriam de ser contemplados também?
         	INNER JOIN
         			(
     					SELECT	*
     					FROM	bu_captools_work.vds_inp_fr_pl_contas
     					WHERE	carteira_contabilistica = 'garantias e compromissos concedidos'
                            AND produto IN ('compromissos de credito concedidos', 'garantias financeiras prestadas', 'outras responsabilidades perante terceiros')
     			    ) AS frplcontas
         			ON ctunivsaldo.ccontab_final_ifrs = frplcontas.conta
            GROUP BY ctunivsaldo.instrument_id
        ) AS offbals
        ON ctunivcto.instrument_id = offbals.instrument_id
        LEFT JOIN bu_captools_work.vds_inp_ct_univ_titulos AS ctunivtitulos
        ON ctunivcto.instrument_id = ctunivtitulos.instrument_id
         			--LEFT JOIN VDSINP.VDS_INP_CT_UNIV_SALDO AS CTUNIVSALDO
         			--ON CTUNIVCTO.INSTRUMENT_ID = CTUNIVSALDO.INSTRUMENT_ID*/
        LEFT JOIN
        (
            SELECT	instrument_id,
                    MAX(contraparte_i) AS contraparte_i,
         			MAX(carteira_contabilistica) AS carteira_contabilistica
            FROM	bu_captools_work.vds_inp_ct_univ_finrep
         	GROUP BY instrument_id
        ) AS ctunivfinrep
        ON ctunivcto.instrument_id = ctunivfinrep.instrument_id
        LEFT JOIN bu_captools_work.vds_inp_ct_univ_cli AS ctunivcli2
        ON ctunivcli2.zcliente = ctunivtitulos.zcliente_emitente
        LEFT JOIN bu_captools_work.vds_inp_ct_univ_tat91_015 AS ctunivcountry
        ON ctunivcountry.tayd91c0_celemtab = ctunivcli2.cpais_residencia
        LEFT JOIN bu_captools_work.vds_inp_ct_univ_tat91_206 AS ctunivcurrency
        ON ctunivtitulos.cmoeda = CTUNIVCURRENCY.TAYD91C0_CELEMTAB
        LEFT JOIN
        (
         	SELECT cod_atributo_dim,
                    nome_atributo_dim
         	FROM bu_captools_work.vds_inp_ct_dim_valor
         	WHERE id_dimensao = 76
        ) AS financialassets
        ON financialassets.nome_atributo_dim = ctunivtitulos.tipo_titulo
        LEFT JOIN bu_captools_work.vds_inp_ct_univ_gr_cli AS grcli
        ON ctunivcto.zcliente = grcli.zcliente;

--ALM Data
CREATE TABLE bu_captools_work.vds_tmp_alm_master AS
SELECT	alcntcore.*,
        alsldcore.mon_cap_total,
        alsldcore.mon_jur_total,
        alsldcore.mon_extrapatri,
        alsldcore.mon_imparid_patri,
        alsldcore.mon_imparidade_extra,
        alsldcore.mon_comissoes,
        alsldcore.mon_despesas,
        alprogppc.dbreak_clause,
        aldetswapc.code_pcd,
        aldetswapc.mon_premio,
        alderivados.mon_strike,
        clientes.clyd18c1_nmorada,
        clientes.clyd18c1_nlocalid,
        clientes.clyd18c1_cpostal,
        CASE
		    WHEN alderivados.instrument_id_al IS NOT NULL THEN "DERIVATIVE"
		    ELSE ''
		END AS is_derivative,
        ept.EPYR5040_EPT03_TKJURO
FROM bu_captools_work.vds_inp_al_cnt_core AS alcntcore
			  INNER JOIN bu_captools_work.vds_inp_al_peri_alm AS alperialm
			  ON alcntcore.instrument_id_al = alperialm.instrument_id_al AND alcntcore.zcliente = alperialm.zcliente
			  LEFT JOIN bu_captools_work.vds_inp_al_sld_core AS alsldcore
			  ON alcntcore.instrument_id_al = alsldcore.instrument_id_al AND alcntcore.zcliente = alsldcore.zcliente
			  LEFT JOIN  bu_captools_work.vds_inp_al_saq_ppc AS alsaqppc
			  ON alcntcore.instrument_id_al = alsaqppc.instrument_id_al
			  LEFT JOIN bu_captools_work.vds_inp_al_prog_ppc AS alprogppc
			  ON alsaqppc.cprograma = alprogppc.cprograma
			  LEFT JOIN  bu_captools_work.vds_inp_al_det_swapc AS aldetswapc
			  ON alcntcore.instrument_id_al = aldetswapc.instrument_id_al
			  LEFT JOIN  bu_captools_work.vds_inp_al_derivados AS alderivados
			  ON alcntcore.instrument_id_al = alderivados.instrument_id_al
			  LEFT JOIN bu_captools_work.vds_inp_cli_clt18 AS clientes
		  	ON alcntcore.zcliente = CAST(clientes.clyd18c1_zcliente as STRING)
			  LEFT JOIN bu_captools_work.vds_inp_ept AS ept
			  ON alcntcore.instrument_id_al_x = ept.instrument_id_al_x;

--RWA Data
--No ficheiro deles o group by apenas é composto por cod_spv e por s1emp,é necessário rever esta tabela princiaplmente a parte do coalesce
CREATE TABLE bu_captools_work.vds_tmp_rwa_master AS
SELECT tab_orig.cod_spv
			,tab_orig.s1emp
			,tab_orig.contra1
			,tab_orig.idnumcli
			,tab_orig.segmento_corep_final
			,tab_orig.ead_final_liquida as ead_final_liquida_rec
			,tab_sum.sum_ead_final_liquida as ead_final_liquida
			,COALESCE
			(
				tab_sum.sum_ead_final_bruta_k2/tab_sum.sum_ead_final_bruta,
				tab_orig.k2
			) as k2
			,tab_sum.sum_rwa_final as rwa_final
			,COALESCE
			(
				tab_sum.sum_ead_final_bruta_lgdfinal/tab_sum.sum_ead_final_bruta,
				tab_orig.lgdfinal
			) as lgdfinal
			,tab_sum.sum_ead_final_bruta as ead_final_bruta
			,COALESCE
			(
				tab_sum.sum_ead_final_bruta_in_pdfin/tab_sum.sum_ead_final_bruta,
				tab_orig.in_pdfin
			) as in_pdfin
			,COALESCE
			(
				tab_sum.sum_ead_final_bruta_in_pdini/tab_sum.sum_ead_final_bruta,
				tab_orig.in_pdini
			) as in_pdini
			,tab_orig.num_empl
			,tab_orig.impfactm_cli
			,tab_orig.idpunsco
			,tab_orig.tot_acti
FROM
(
	SELECT ctrwaprinc.cod_spv
				,ctrwaprinc.s1emp
				,ctrwaprinc.contra1
				,ctrwaprinc.idnumcli
				,ctrwaprinc.segmento_corep_final
				,ctrwaprinc.ead_final_liquida
				,ctrwaprinc.k2
				,ctrwairb.lgdfinal
				,ctrwairb.in_pdfin
				,ctrwairb.in_pdini
				,ctrwacli.num_empl
				,ctrwacli.impfactm_cli
				,ctrwacli.idpunsco
				,ctrwacli.tot_acti
	from	bu_captools_work.vds_inp_ct_rwa_princ as ctrwaprinc
	left join bu_captools_work.vds_inp_ct_rwa_irb as ctrwairb
	on ctrwaprinc.biengar1 = ctrwairb.biengar1 and
		 ctrwaprinc.catprem_inicial = ctrwairb.catprem_inicial and
		 ctrwaprinc.tipoajus = ctrwairb.tipoajus and
		 ctrwaprinc.cod_spv = ctrwairb.cod_spv and
		 ctrwaprinc.s1emp = ctrwairb.s1emp and
		 ctrwaprinc.contra1 = ctrwairb.contra1
	left join bu_captools_work.vds_inp_ct_rwa_cli as ctrwacli
	on ctrwaprinc.s1emp = ctrwacli.s1emp and
		 ctrwaprinc.idnumcli = ctrwacli.idnumcli
) as tab_orig
LEFT JOIN
(
	SELECT
		ctrwaprinc.s1emp,
		ctrwaprinc.contra1,
		SUM(ctrwaprinc.ead_final_liquida) as sum_ead_final_liquida,
		SUM(ctrwaprinc.ead_final_bruta * ctrwaprinc.k2) as sum_ead_final_bruta_k2,
		SUM(ctrwaprinc.ead_final_bruta) as sum_ead_final_bruta,
		SUM(ctrwaprinc.rwa_final) as sum_rwa_final,
		SUM(ctrwaprinc.ead_final_bruta * ctrwairb.lgdfinal) as sum_ead_final_bruta_lgdfinal,
		SUM(ctrwaprinc.ead_final_bruta * ctrwairb.in_pdfin) as sum_ead_final_bruta_in_pdfin,
		SUM(ctrwaprinc.ead_final_bruta * ctrwairb.in_pdini) as sum_ead_final_bruta_in_pdini
	from	bu_captools_work.vds_inp_ct_rwa_princ as ctrwaprinc
	left join bu_captools_work.vds_inp_ct_rwa_irb as ctrwairb
	on ctrwaprinc.biengar1 = ctrwairb.biengar1 and
		 ctrwaprinc.catprem_inicial = ctrwairb.catprem_inicial and
		 ctrwaprinc.tipoajus = ctrwairb.tipoajus and
		 ctrwaprinc.cod_spv = ctrwairb.cod_spv and
		 ctrwaprinc.s1emp = ctrwairb.s1emp and
		 ctrwaprinc.contra1 = ctrwairb.contra1
	group by
			ctrwaprinc.s1emp, ctrwaprinc.contra1
) as tab_sum
ON  tab_sum.s1emp = tab_orig.s1emp
AND tab_sum.contra1 = tab_orig.contra1
GROUP BY tab_orig.cod_spv,
				 tab_orig.s1emp,
			   tab_orig.contra1,
			   tab_orig.idnumcli,
			   tab_orig.segmento_corep_final,
			   ead_final_liquida_rec,
			   ead_final_liquida,
			   k2,
			   rwa_final,
			   lgdfinal,
			   ead_final_bruta,
			   in_pdfin,
			   in_pdini,
			   tab_orig.num_empl,
			   tab_orig.impfactm_cli,
			   tab_orig.idpunsco,
			   tab_orig.tot_acti;



--IFRS Data
CREATE TABLE bu_captools_work.vds_tmp_ifrs_master AS
SELECT 	ifrsexpectedloss.*,
        ifrsoutstaging.final_stage
FROM	bu_captools_work.vds_inp_ct_ifrs_expected_loss AS ifrsexpectedloss
			  LEFT JOIN bu_captools_work.vds_inp_ct_ifrs_out_staging AS ifrsoutstaging
			  ON ifrsexpectedloss.contract_id = ifrsoutstaging.contract_id;


--o Miguel vai ver esta query pois está mal feita
--LOAN TAPES Instrument and Entity Data
CREATE TABLE bu_captools_work.vds_tmp_loantapes_instr_master AS
SELECT 	ltinstrument.*,
        ltentity.intrnl_rtng,
        ltentity.extrnl_rtng,
        ltentity.lgl_prcdng_stts_le,
        ltentity.dt_inttn_lgl_prcdngs_le,
        ltentity.entrprs_sz_le,
        ltentity.annl_trnvr_le,
        ltentity.gcc_prnt_id,
        ltentity.ecnmc_actvty,
        ltinstrentity.jnt_lblty_amnt
FROM	bu_captools_work.vds_inp_lt_instrument AS ltinstrument
			  LEFT JOIN bu_captools_work.vds_inp_lt_instr_entity AS ltinstrentity
			  ON ltinstrument.instrument_id_lt = ltinstrentity.instrmnt_id
			  LEFT JOIN bu_captools_work.vds_inp_lt_entity AS ltentity
			  ON ltinstrentity.entty_id = ltentity.entty_id;


--LOAN TAPES Protection Data
CREATE TABLE bu_captools_work.vds_tmp_loantapes_prtect_master AS
SELECT  ltprotect.*,
        instrument_id_lt,
        ltinstrprotect.prtctn_allctd_vl,
        ltinstrprotect.thrd_prty_prrty_clms
FROM	bu_captools_work.vds_inp_lt_protection AS ltprotect
			  LEFT JOIN bu_captools_work.vds_inp_lt_instr_prot AS ltinstrprotect
			  ON ltprotect.prtctn_id = ltinstrprotect.prtctn_id;


--KT ALM VS FR
CREATE TABLE bu_captools_work.vds_tmp_kt_chaves_alm_vs_fr AS
SELECT DISTINCT
			     ktchavesalm.instrument_id_al,
           ktchavesfr.instrument_id_fr
FROM	bu_captools_work.vds_inp_kt_chaves_alm AS ktchavesalm
			     INNER JOIN bu_captools_work.vds_inp_kt_chaves_fr AS ktchavesfr
			     ON ktchavesalm.instrument_id = ktchavesfr.instrument_id;


--KT ALM VS RWA
CREATE TABLE bu_captools_work.vds_tmp_kt_chaves_alm_vs_rwa AS
SELECT DISTINCT
			     ktchavesalm.instrument_id_al,
           ktchavesbdr.s1emp,
           ktchavesbdr.contra1
FROM	bu_captools_work.vds_inp_kt_chaves_alm AS ktchavesalm
			     INNER JOIN bu_captools_work.vds_inp_kt_chaves_bdr AS ktchavesbdr
			     ON ktchavesalm.instrument_id = ktchavesbdr.instrument_id;


--KT ALM VS IFRS
CREATE TABLE bu_captools_work.vds_tmp_kt_chaves_alm_vs_ifrs AS
SELECT DISTINCT
			     ktchavesalm.instrument_id_al,
			     ktchavesifrs.contract_id
FROM	bu_captools_work.vds_inp_kt_chaves_alm AS ktchavesalm
			     INNER JOIN bu_captools_work.vds_inp_kt_chaves_ifrs AS ktchavesifrs
			     ON ktchavesalm.instrument_id = ktchavesifrs.instrument_id;


--Get UNIV data
CREATE TABLE bu_captools_work.vds_tmp_univ_master_t AS
SELECT	ktchavesalm.instrument_id_al,
        univmaster.dincump,
        univmaster.tipo_analise,
        univmaster.stage,
        univmaster.ref_date,
        univmaster.ctipo_doc_identif1,
        univmaster.cnum_doc_identif1,
        univmaster.clei,
        univmaster.cpais_residencia,
        univmaster.csector_inst,
        univmaster.itip_cli,
        univmaster.cnif_resid,
        univmaster.gcliente,
        univmaster.ccae,
        univmaster.nace_code,
        univmaster.produto_offbal,
        univmaster.isin,
        univmaster.tipo_oferta,
        univmaster.dt_emissao,
        univmaster.dt_vencim,
        univmaster.rating_sp,
        univmaster.rating_moodys,
        univmaster.rating_fitch,
        univmaster.rating_dbrs,
        univmaster.tipo_tx,
        univmaster.tx_fixa,
        univmaster.tx_vigente,
        univmaster.sprd_tx_var,
        univmaster.frq_liq_jur,
        univmaster.eleg_eurosistema,
        univmaster.grau_liquidez,
        univmaster.zcliente_emitente,
  			--,UNIVMASTER.MSALDO_FINAL
  			--,UNIVMASTER.CCONTAB_FINAL_PCSB
  			--,UNIVMASTER.CCONTAB_FINAL_IFRS
			  univmaster.contraparte_i,
        univmaster.carteira_contabilistica,
        univmaster.tayd91c0_nelemc09,
        univmaster.tayd91c0_nelemc01,
        univmaster.zcliente,
        univmaster.entidade_garante,
        univmaster.cmoeda,
        univmaster.cod_atributo_dim,
        --UNIVMASTER.CONTA*/
			  univmaster.zgrupo
FROM	bu_captools_work.vds_inp_kt_chaves_alm AS ktchavesalm
			  INNER JOIN bu_captools_work.vds_tmp_univ_master AS univmaster
			  ON ktchavesalm.instrument_id = univmaster.instrument_id;
GROUP BY  ktchavesalm.instrument_id_al,    --adicionamos um group by pois tinhamos o seguinte PROC SORT DATA = VDSTMP.VDS_TMP_UNIV_MASTER_T NODUPKEY; BY INSTRUMENT_ID_AL;
          univmaster.dincump,
          univmaster.tipo_analise,
          univmaster.stage,
          univmaster.ref_date,
          univmaster.ctipo_doc_identif1,
          univmaster.cnum_doc_identif1,
          univmaster.clei,
          univmaster.cpais_residencia,
          univmaster.csector_inst,
          univmaster.itip_cli,
          univmaster.cnif_resid,
          univmaster.gcliente,
          univmaster.ccae,
          univmaster.nace_code,
          univmaster.produto_offbal,
          univmaster.isin,
          univmaster.tipo_oferta,
          univmaster.dt_emissao,
          univmaster.dt_vencim,
          univmaster.rating_sp,
          univmaster.rating_moodys,
          univmaster.rating_fitch,
          univmaster.rating_dbrs,
          univmaster.tipo_tx,
          univmaster.tx_fixa,
          univmaster.tx_vigente,
          univmaster.sprd_tx_var,
          univmaster.frq_liq_jur,
          univmaster.eleg_eurosistema,
          univmaster.grau_liquidez,
          univmaster.zcliente_emitente,
  			  univmaster.contraparte_i,
          univmaster.carteira_contabilistica,
          univmaster.tayd91c0_nelemc09,
          univmaster.tayd91c0_nelemc01,
          univmaster.zcliente,
          univmaster.entidade_garante,
          univmaster.cmoeda,
          univmaster.cod_atributo_dim,
  			  univmaster.zgrupo;


CREATE TABLE bu_captools_work.vds_tmp_univ_sld_master_t AS
SELECT	ktchavesalm.instrument_id_al,
        univsld.msaldo_final,
        univsld.ccontab_final_st_sgps,
        univsld.ccontab_final_pcsb,
        univsld.ccontab_final_ifrs
FROM	bu_captools_work.vds_inp_kt_chaves_alm AS ktchavesalm
			  INNER JOIN bu_captools_work.vds_inp_ct_univ_saldo AS univsld
			  ON ktchavesalm.instrument_id = univsld.instrument_id;


--Get RWA data
CREATE TABLE bu_captools_work.vds_tmp_rwa_master_t_p1 AS
SELECT	ktchavesalmrwa.instrument_id_al,
        rwamaster.cod_spv,
        rwamaster.segmento_corep_final,
        rwamaster.ead_final_liquida/tab_count.cnt AS ead_final_liquida,
        rwamaster.k2,
        rwamaster.rwa_final/tab_count.cnt AS rwa_final,
        rwamaster.lgdfinal,
        rwamaster.num_empl,
        rwamaster.impfactm_cli,
        rwamaster.idpunsco,
        rwamaster.in_pdfin,
        rwamaster.tot_acti,
        rwamaster.ead_final_bruta/tab_count.cnt AS ead_final_bruta,
        rwamaster.in_pdini
FROM	bu_captools_work.vds_tmp_kt_chaves_alm_vs_rwa AS ktchavesalmrwa
INNER JOIN bu_captools_work.vds_tmp_rwa_master AS rwamaster
ON ktchavesalmrwa.s1emp = rwamaster.s1emp
AND ktchavesalmrwa.contra1 = rwamaster.contra1
LEFT JOIN
(
  SELECT  s1emp,
          contra1,
          COUNT(*) AS cnt
  FROM bu_captools_work.vds_tmp_rwa_master
  GROUP BY
  		s1emp,
        contra1
) AS tab_count
ON tab_count.s1emp = rwamaster.s1emp
AND tab_count.contra1 = rwamaster.contra1;


CREATE TABLE bu_captools_work.vds_tmp_rwa_master_t_p2 AS
SELECT	rwamastert.instrument_id_al,
        rwamastert.cod_spv,
        rwamastert.segmento_corep_final,
        rwamastert.ead_final_liquida AS ead_final_liquida_rec,
        tabela_sum.ead_final_liquida_sum AS ead_final_liquida,
        COALESCE(tabela_sum.ead_final_bruta_k2_sum/tabela_sum.ead_final_bruta_sum, k2) AS k2,
        tabela_sum.rwa_final_sum AS rwa_final,
        COALESCE(tabela_sum.ead_final_bruta_lgdfinal_sum/tabela_sum.ead_final_bruta_sum, lgdfinal) AS lgdfinal,
        rwamastert.num_empl,
        rwamastert.impfactm_cli,
        rwamastert.idpunsco,
        COALESCE(tabela_sum.ead_final_bruta_in_pdfin_sum/tabela_sum.ead_final_bruta_sum, in_pdfin) AS in_pdfin,
        rwamastert.tot_acti,
			  tabela_sum.ead_final_bruta_sum AS ead_final_bruta,
        COALESCE(tabela_sum.ead_final_bruta_in_pdini_sum/tabela_sum.ead_final_bruta_sum, in_pdini) AS in_pdini
FROM	bu_captools_work.vds_tmp_rwa_master_t_p1 AS rwamastert
LEFT JOIN
(
  SELECT  instrument_id_al,
          SUM(ead_final_liquida) AS ead_final_liquida_sum,
          SUM(k2 * ead_final_bruta) AS ead_final_bruta_k2_sum,
          SUM(ead_final_bruta) AS ead_final_bruta_sum,
          SUM(rwa_final) AS rwa_final_sum,
          SUM(lgdfinal * ead_final_bruta) AS ead_final_bruta_lgdfinal_sum,
          SUM(in_pdfin * ead_final_bruta) AS ead_final_bruta_in_pdfin_sum,
          SUM(in_pdini * ead_final_bruta) AS ead_final_bruta_in_pdini_sum
  FROM	bu_captools_work.vds_tmp_rwa_master_t_p1
  GROUP BY instrument_id_al
) AS tabela_sum
ON tabela_sum.instrument_id_al = rwamastert.instrument_id_al;



--Get IFRS data
CREATE TABLE bu_captools_work.vds_tmp_ifrs_master_t_p1 AS
SELECT	ktchavesalmifrs.instrument_id_al,
        ifrsmaster.lgd_ifrs9,
        ifrsmaster.pd12m_ifrs9,
        ifrsmaster.pd_lt_ifrs9,
        CAST(ifrsmaster.ead AS DECIMAL(32,6))/tabela_count.ead_count AS ead,    -- Antes estvaa isso: INPUT(IFRSMASTER.EAD, 32.) / COUNT(*) AS EAD, supostamente teriamos de fazer um CAST mas achamos que neste caso não é necessário
        ifrsmaster.final_stage
FROM	bu_captools_work.vds_tmp_kt_chaves_alm_vs_ifrs AS ktchavesalmifrs
INNER JOIN bu_captools_work.vds_tmp_ifrs_master AS ifrsmaster
ON ktchavesalmifrs.contract_id = ifrsmaster.contract_id
LEFT JOIN
(
  SELECT contract_id,
         COUNT(*) AS ead_count
  FROM bu_captools_work.vds_tmp_ifrs_master
  GROUP BY contract_id
) AS tabela_count
ON tabela_count.contract_id = ifrsmaster.contract_id;


CREATE TABLE bu_captools_work.vds_tmp_ifrs_master_t_p2 AS
SELECT	mastertp1.instrument_id_al,
        mastertp1.ead AS ead_rec,
        COALESCE(tabel_sum.ead_lgd_ifrs9_sum/tabel_sum.ead_sum, lgd_ifrs9) AS lgd_ifrs9,
        COALESCE(tabel_sum.ead_pd12m_ifrs9/tabel_sum.ead_sum, pd12m_ifrs9) AS pd12m_ifrs9,
        COALESCE(tabel_sum.ead_pd_lt_ifrs9/tabel_sum.ead_sum, pd_lt_ifrs9) AS pd_lt_ifrs9,
			  tabel_sum.ead_sum AS ead,
			  tabel_sum.final_stage_max AS final_stage
FROM	bu_captools_work.vds_tmp_ifrs_master_t_p1 AS mastertp1
LEFT JOIN
(
  SELECT  instrument_id_al,
          SUM(ead * lgd_ifrs9) AS ead_lgd_ifrs9_sum,
          SUM(ead) AS ead_sum,
          SUM(ead * pd12m_ifrs9) AS ead_pd12m_ifrs9,
          SUM(ead * pd_lt_ifrs9) AS ead_pd_lt_ifrs9,
          MAX(final_stage) AS final_stage_max
  FROM	bu_captools_work.vds_tmp_ifrs_master_t_p1
  GROUP BY instrument_id_al
) AS tabel_sum
ON tabel_sum.instrument_id_al = mastertp1.instrument_id_al;



--Get FR data
CREATE TABLE bu_captools_work.vds_tmp_fr_master_t AS
SELECT	ktchavesalmfr.instrument_id_al,
        frcolaterais.protection_id,
        frcolaterais.zcliente,
        frcolaterais.dabertur,
        frcolaterais.dvencime,
        frcolaterais.mavaliaa,
        frcolaterais.mavaliai,
			  frcolaterais.dultmod,
			  frcolaterais.cprodut_caucao,
			  frcolaterais.csubpro_caucao,
			  frcolaterais.garante
FROM	bu_captools_work.vds_tmp_kt_chaves_alm_vs_fr AS ktchavesalmfr
			  INNER JOIN bu_captools_work.vds_inp_fr_colaterais AS frcolaterais
			  ON	ktchavesalmfr.instrument_id_fr = frcolaterais.instrument_id_fr
GROUP BY ktchavesalmfr.instrument_id_al,    --adicionamos um group by pois tinhamos o seguinte PROC SORT DATA = WORK.VDS_TMP_FR_MASTER_T OUT = VDSTMP.VDS_TMP_FR_MASTER_T NODUPKEY; BY INSTRUMENT_ID_AL PROTECTION_ID; QUIT;
         frcolaterais.protection_id,
         frcolaterais.zcliente,
         frcolaterais.dabertur,
         frcolaterais.dvencime,
         frcolaterais.mavaliaa,
         frcolaterais.mavaliai,
			   frcolaterais.dultmod,
			   frcolaterais.cprodut_caucao,
			   frcolaterais.csubpro_caucao,
			   frcolaterais.garante;

--Esta tabela estava errada pois não atacava o tradutor de chaves do loan tapes, foi subestituida pelas três tabelas seguintes

--Loan Tapes MASTER
-- CREATE TABLE bu_captools_work.vds_tmp_lt_instr_master_t AS
-- SELECT	ktchavesalmfr.instrument_id_al,
--         ltmaster_instr.*
-- FROM	bu_captools_work.vds_tmp_kt_chaves_alm_vs_fr AS ktchavesalmfr
-- 			  INNER JOIN bu_captools_work.vds_tmp_loantapes_instr_master AS ltmaster_instr
-- 			  ON ktchavesalmfr.instrument_id_fr = ltmaster_instr.instrument_id_lt;
-- GROUP BY ktchavesalmfr.instrument_id_al,    --adicionamos um group by pois tinhamos o seguinte PROC SORT DATA = WORK.VDS_TMP_LT_INSTR_MASTER_T OUT = VDSTMP.VDS_TMP_LT_INSTR_MASTER_T NODUPKEY; BY INSTRUMENT_ID_AL; QUIT;
--          ltmaster_instr.*;

CREATE TABLE bu_captools_work.vds_tmp_lt_instr_master_t AS
SELECT ktchavesalmlt.instrument_id_al,
       ltmaster_instr.instrument_id_lt,
       ltmaster_instr.typ_instrmnt,
       ltmaster_instr.typ_amrtstn,
       ltmaster_instr.cmmtmnt_incptn_instrmnt,
       ltmaster_instr.dflt_stts_instrmnt,
       ltmaster_instr.dt_dflt_stts_instrmnt,
       ltmaster_instr.srcs_encmbrnc,
       ltmaster_instr.frbrnc_stts_instrmnt,
       ltmaster_instr.dt_frbrnc_stts,
       ltmaster_instr.hedge_id,
       ltmaster_instr.dt_vltn,
       ltmaster_instr.vltn_typ,
       ltmaster_instr.instrmnt_clss,
       ltmaster_instr.prmry_asst_clssf,
       ltmaster_instr.asst_scrt_clss,
       ltmaster_instr.prch_undr_rsl_agr,
       ltmaster_instr.instr_snrty_clss,
       ltmaster_instr.issr_typ,
       ltmaster_instr.arrrs_instrmnt,
       ltmaster_instr.otstndng_nmnl_amnt_instrmnt,
       ltmaster_instr.accmltd_chngs_fv_cr_instrmnt,
       ltmaster_instr.issr_rtng_src,
       ltmaster_instr.grntr_id_typ,
       ltmaster_instr.issr_id,
       ltmaster_instr.issr_id_typ,
       ltmaster_instr.issr_cntry,
       ltmaster_instr.issr_esa_2010,
       ltmaster_instr.intrnl_rtng,
       ltmaster_instr.extrnl_rtng,
       ltmaster_instr.lgl_prcdng_stts_le,
       ltmaster_instr.dt_inttn_lgl_prcdngs_le,
       ltmaster_instr.entrprs_sz_le,
       ltmaster_instr.annl_trnvr_le,
       ltmaster_instr.gcc_prnt_id,
       ltmaster_instr.ecnmc_actvty,
       ltmaster_instr.jnt_lblty_amnt
FROM bu_captools_work.vds_tmp_kt_chaves_alm_vs_lt AS ktchavesalmlt
INNER JOIN bu_captools_work.vds_tmp_loantapes_instr_master AS ltmaster_instr
ON ktchavesalmlt.instrument_id_lt = ltmaster_instr.instrument_id_lt
GROUP BY instrument_id_al,
         instrument_id_lt,
         typ_instrmnt,
         typ_amrtstn,
         cmmtmnt_incptn_instrmnt,
         dflt_stts_instrmnt,
         dt_dflt_stts_instrmnt,
         srcs_encmbrnc,
         frbrnc_stts_instrmnt,
         dt_frbrnc_stts,
         hedge_id,
         dt_vltn,
         vltn_typ,
         instrmnt_clss,
         prmry_asst_clssf,
         asst_scrt_clss,
         prch_undr_rsl_agr,
         instr_snrty_clss,
         issr_typ,
         arrrs_instrmnt,
         otstndng_nmnl_amnt_instrmnt,
         accmltd_chngs_fv_cr_instrmnt,
         issr_rtng_src,
         grntr_id_typ,
         issr_id,
         issr_id_typ,
         issr_cntry,
         issr_esa_2010,
         intrnl_rtng,
         extrnl_rtng,
         lgl_prcdng_stts_le,
         dt_inttn_lgl_prcdngs_le,
         entrprs_sz_le,
         annl_trnvr_le,
         gcc_prnt_id,
         ecnmc_actvty,
         jnt_lblty_amnt;


--Tabela de chaves CAPTOOLS -> Loan Tapes:

CREATE TABLE bu_captools_work.vds_inp_kt_chaves_lt AS
SELECT instrmnt_id AS instrument_id_lt,
	  CONCAT(cempresa, '_', cbalcao, '_',cnumecta, '_', zdeposit) AS instrument_id
FROM cd_loan_tapes_bce.kt_chaves_lt
WHERE ref_date = '2023-12-31'



--Tabela de chaves ALM ->Loan Tapes:

CREATE TABLE bu_captools_work.vds_tmp_kt_chaves_alm_vs_lt AS
SELECT DISTINCT
		ktchavesalm.instrument_id_al,
		ktchaveslt.instrument_id_lt
FROM bu_captools_work.vds_inp_kt_chaves_alm AS ktchavesalm
INNER JOIN bu_captools_work.vds_inp_kt_chaves_lt AS ktchaveslt
ON ktchavesalm.instrument_id = ktchaveslt.instrument_id;



--Esta tabela estava errada pois não atacava o tradutor de chaves do loan tapes
CREATE TABLE bu_captools_work.vds_tmp_lt_prtect_master_t AS
SELECT	ktchavesalmlt.instrument_id_al,
        ltmaster_protect.prtctn_id,
        ltmaster_protect.typ_prtctn,
        ltmaster_protect.rl_estt_pst_cd,
        ltmaster_protect.instrument_id_lt,
        ltmaster_protect.prtctn_allctd_vl,
        ltmaster_protect.thrd_prty_prrty_clms
FROM bu_captools_work.vds_tmp_kt_chaves_alm_vs_lt AS ktchavesalmlt
INNER JOIN bu_captools_work.vds_tmp_loantapes_prtect_master AS ltmaster_protect
ON ktchavesalmlt.instrument_id_lt = ltmaster_protect.instrument_id_lt
GROUP BY instrument_id_al,
         prtctn_id,
         typ_prtctn,
         rl_estt_pst_cd,
         instrument_id_lt,
         prtctn_allctd_vl,
         thrd_prty_prrty_clms;


--CREATE TABLE bu_captools_work.vds_tmp_lt_prtect_master_t AS
--SELECT	ktchavesalmfr.instrument_id_al,
--        ltmaster_protect.*
--FROM	bu_captools_work.vds_tmp_kt_chaves_alm_vs_fr AS ktchavesalmfr
--			  INNER JOIN bu_captools_work.vds_tmp_loantapes_prtect_master AS ltmaster_protect
--			  ON ktchavesalmfr.instrument_id_fr = ltmaster_protect.instrument_id_lt;
--GROUP BY ktchavesalmfr.instrument_id_al,    --adicionamos um group by pois tinhamos o seguinte PROC SORT DATA = WORK.VDS_TMP_LT_PRTECT_MASTER_T OUT = VDSTMP.VDS_TMP_LT_PRTECT_MASTER_T NODUPKEY; BY INSTRUMENT_ID_AL PRTCTN_ID; QUIT;
--         ltmaster_protect.*;

--adicionamos esta query pois é necessário para a query seguinte
CREATE TABLE bu_captools_work.vds_inp_fr_recup_t AS
SELECT	ktchavesalmfr.instrument_id_al,
        fr_recup.instrument_id_fr,
        fr_recup.valor
FROM bu_captools_work.vds_tmp_kt_chaves_alm_vs_fr AS ktchavesalmfr
INNER JOIN bu_captools_work.vds_inp_fr_recup AS fr_recup
ON ktchavesalmfr.instrument_id_fr = fr_recup.instrument_id_fr
GROUP BY instrument_id_al,
         instrument_id_fr,
         valor;


--INSTRUMENT MASTER - Join Univ, ALM, RWA , IFRS and LT data
CREATE TABLE bu_captools_work.vds_tmp_instrument_master AS    --rever pois vai ser alterada. Aqui eles não passam pelo tradutor de chaves
SELECT	almmaster.*,
        univmaster.ctipo_doc_identif1,
        univmaster.cnum_doc_identif1,
        univmaster.clei,
        univmaster.cpais_residencia,
        univmaster.csector_inst,
        univmaster.itip_cli,
        univmaster.produto_offbal,
        univmaster.carteira_contabilistica,
  			/*,UNIVMASTER.MSALDO_FINAL
  			,UNIVMASTER.CCONTAB_FINAL_PCSB
  			,UNIVMASTER.CCONTAB_FINAL_IFRS*/
			  univmaster.dincump,
        univmaster.stage,
        univmaster.tipo_analise,
        univmaster.ref_date,
        univmaster.contraparte_i,
        univmaster.isin,
        univmaster.nace_code,
        univmaster.zcliente_emitente,
        univmaster.tayd91c0_nelemc09,
        univmaster.tayd91c0_nelemc01,
        univmaster.tipo_oferta,
        univmaster.dt_emissao,
        univmaster.dt_vencim,
        univmaster.rating_sp,
        univmaster.rating_moodys,
        univmaster.rating_fitch,
        univmaster.rating_dbrs,
        univmaster.tipo_tx,
        univmaster.tx_fixa,
        univmaster.tx_vigente,
        univmaster.sprd_tx_var,
        univmaster.eleg_eurosistema,
        univmaster.grau_liquidez,
  			univmaster.frq_liq_jur,
  			/*,UNIVMASTER.ZCLIENTE*/
			  univmaster.entidade_garante,
        univmaster.cmoeda,
        univmaster.cod_atributo_dim,
			  /*,UNIVMASTER.CONTA*/
        rwamaster.cod_spv,
        rwamaster.segmento_corep_final,
        rwamaster.ead_final_liquida,
        rwamaster.k2,
        rwamaster.rwa_final,
        rwamaster.lgdfinal,
        rwamaster.num_empl,
        rwamaster.impfactm_cli,
        rwamaster.idpunsco,
        ifrsmaster.lgd_ifrs9,
        ifrsmaster.pd12m_ifrs9,
        ifrsmaster.pd_lt_ifrs9,
        ifrsmaster.ead,
        ifrsmaster.final_stage,
        frrecup.valor,
        ltmaster_instr.dflt_stts_instrmnt,
        ltmaster_instr.dt_dflt_stts_instrmnt,
        ltmaster_instr.dt_frbrnc_stts,
        ltmaster_instr.frbrnc_stts_instrmnt,
        ltmaster_instr.jnt_lblty_amnt,
        ltmaster_instr.cmmtmnt_incptn_instrmnt,
        ltmaster_instr.srcs_encmbrnc,
        ltmaster_instr.typ_instrmnt,
        ltmaster_instr.typ_amrtstn,
        ltmaster_instr.extrnl_rtng,
        ltmaster_instr.dt_vltn,
        ltmaster_instr.vltn_typ,
        ltmaster_instr.instrmnt_clss,
        ltmaster_instr.prmry_asst_clssf,
        ltmaster_instr.asst_scrt_clss,
        ltmaster_instr.instr_snrty_clss,
        ltmaster_instr.prch_undr_rsl_agr,
        ltmaster_instr.hedge_id,
        ltmaster_instr.issr_typ,
        ltmaster_instr.arrrs_instrmnt,
        ltmaster_instr.otstndng_nmnl_amnt_instrmnt,
        ltmaster_instr.accmltd_chngs_fv_cr_instrmnt,
        ltmaster_instr.issr_rtng_src,
        ltmaster_instr.grntr_id_typ,
        ltmaster_instr.issr_id,
        ltmaster_instr.issr_id_typ,
        ltmaster_instr.issr_cntry,
        ltmaster_instr.issr_esa_2010,
        ltmaster_instr.ecnmc_actvty,
        CASE	WHEN is_derivative = 'DERIVATIVE' THEN 'DERIVATIVE'
					    WHEN cod_atributo_dim LIKE 'Inst_Div%' THEN 'DEBT'
					    WHEN cod_atributo_dim LIKE 'Inst_Cap%' THEN 'EQTY'
					    WHEN produto_offbal <> '' THEN 'OFFBAL'                            --NUNCA ACONTECE POIS O produto_offbal está sempre a NULL
					    WHEN itip_cli = 'J' THEN 'LEGALP'
			        ELSE 'NATURALP'
        END AS vds_type
FROM	bu_captools_work.vds_tmp_alm_master AS almmaster
LEFT JOIN bu_captools_work.vds_tmp_univ_master_t AS univmaster
ON almmaster.instrument_id_al = univmaster.instrument_id_al
LEFT JOIN bu_captools_work.vds_tmp_rwa_master_t_p2 AS rwamaster                 -- substituimos a tabela vds_tmp_rwa_master_t  pois não existia, eles usaram-na para fazer o proc sort dest tabela VDS_TMP_RWA_MASTER_T_P2 mas como usamos logo o group by não foi necessáriocriar outra
ON almmaster.instrument_id_al = rwamaster.instrument_id_al
LEFT JOIN bu_captools_work.vds_tmp_ifrs_master_t_p2 AS ifrsmaster               -- substituimos a tabela vds_tmp_ifrs_master_t pois não existia, eles usaram-na para fazer o proc sort dest tabela vds_tmp_ifrs_master_t_p2 mas como usamos logo o group by não foi necessáriocriar outra
ON almmaster.instrument_id_al = ifrsmaster.instrument_id_al
--Esta ligação estava mal feita
--LEFT JOIN bu_captools_work.vds_inp_fr_recup AS frrecup
--ON almmaster.instrument_id_al = frrecup.instrument_id_fr
LEFT JOIN bu_captools_work.vds_inp_fr_recup_t AS frrecup
ON almmaster.instrument_id_al = frrecup.instrument_id_al
LEFT JOIN bu_captools_work.vds_tmp_lt_instr_master_t AS ltmaster_instr
ON almmaster.instrument_id_al = ltmaster_instr.instrument_id_al;



--COUNTERPARTIES MASTER - Join Univ, RWA and IFRS data
CREATE TABLE bu_captools_work.vds_tmp_counterparties_master AS
SELECT  almmaster.zcliente,
        almmaster.instrument_id_al,
        almmaster.clyd18c1_nmorada,
        almmaster.clyd18c1_nlocalid,
        almmaster.clyd18c1_cpostal,
        univmaster.ctipo_doc_identif1,
        univmaster.cnum_doc_identif1,
        univmaster.clei,
        univmaster.cpais_residencia,
        univmaster.csector_inst,
        univmaster.itip_cli,
        univmaster.cnif_resid,
        univmaster.gcliente,
        univmaster.ccae,
        univmaster.nace_code,
        univmaster.produto_offbal,
        univmaster.ref_date,
	       /*,UNIVMASTER.CCONTAB_FINAL_IFRS*/
        univmaster.tayd91c0_nelemc09,
        univmaster.zgrupo,
        rwamaster.cod_spv,
        rwamaster.segmento_corep_final,
        rwamaster.ead_final_liquida,
        rwamaster.k2,
        rwamaster.rwa_final,
        rwamaster.lgdfinal,
        rwamaster.num_empl,
        rwamaster.impfactm_cli,
        rwamaster.idpunsco,
        rwamaster.tot_acti,
        rwamaster.in_pdfin,
        rwamaster.ead_final_bruta,
        rwamaster.in_pdini,
        ifrsmaster.lgd_ifrs9,
        ifrsmaster.pd12m_ifrs9,
        ifrsmaster.pd_lt_ifrs9,
        ifrsmaster.ead,
        ifrsmaster.final_stage,
        ltmaster_instr.intrnl_rtng,
        ltmaster_instr.extrnl_rtng,
        ltmaster_instr.dflt_stts_instrmnt,
        ltmaster_instr.dt_dflt_stts_instrmnt,
        ltmaster_instr.annl_trnvr_le,
        ltmaster_instr.dt_inttn_lgl_prcdngs_le,
        ltmaster_instr.entrprs_sz_le,
        ltmaster_instr.lgl_prcdng_stts_le,
        ltmaster_instr.gcc_prnt_id
FROM	bu_captools_work.vds_tmp_alm_master AS almmaster
	      LEFT JOIN bu_captools_work.vds_tmp_univ_master_t AS univmaster
	      ON almmaster.instrument_id_al = univmaster.instrument_id_al
	      LEFT JOIN bu_captools_work.vds_tmp_rwa_master_t_p2 AS rwamaster         -- substituimos a tabela vds_tmp_rwa_master_t  pois não existia, eles usaram-na para fazer o proc sort dest tabela VDS_TMP_RWA_MASTER_T_P2 mas como usamos logo o group by não foi necessáriocriar outra
	      ON almmaster.instrument_id_al = rwamaster.instrument_id_al
	      LEFT JOIN bu_captools_work.vds_tmp_ifrs_master_t_p2 AS ifrsmaster       -- substituimos a tabela vds_tmp_ifrs_master_t pois não existia, eles usaram-na para fazer o proc sort dest tabela vds_tmp_ifrs_master_t_p2 mas como usamos logo o group by não foi necessáriocriar outra
	      ON almmaster.instrument_id_al = ifrsmaster.instrument_id_al
	      LEFT JOIN bu_captools_work.vds_tmp_lt_instr_master_t AS ltmaster_instr
	      ON almmaster.instrument_id_al = ltmaster_instr.instrument_id_al;


--PROTECTIONS MASTER - Join UNIV , FR and LT data*/
CREATE TABLE bu_captools_work.vds_tmp_protections_master AS
SELECT	frmaster.instrument_id_al,
        frmaster.protection_id,
        frmaster.zcliente,
        frmaster.dabertur,
        frmaster.dvencime,
        frmaster.mavaliaa,
        frmaster.mavaliai,
        frmaster.dultmod,
        frmaster.cprodut_caucao,
        frmaster.csubpro_caucao,
        frmaster.garante,
        univmaster.contraparte_i,
        univmaster.cod_atributo_dim,
        ltmaster_protect.rl_estt_pst_cd,
        ltmaster_protect.prtctn_allctd_vl,
        ltmaster_protect.thrd_prty_prrty_clms,
        ltmaster_protect.typ_prtctn,
        ltmaster_instr.annl_trnvr_le,
        ltmaster_instr.dt_inttn_lgl_prcdngs_le,
        ltmaster_instr.entrprs_sz_le,
        ltmaster_instr.lgl_prcdng_stts_le
FROM	bu_captools_work.vds_tmp_fr_master_t AS frmaster
			  LEFT JOIN bu_captools_work.vds_tmp_univ_master_t AS univmaster
			  ON frmaster.instrument_id_al = univmaster.instrument_id_al
			  LEFT JOIN bu_captools_work.vds_tmp_lt_prtect_master_t AS ltmaster_protect
			  ON	frmaster.instrument_id_al = ltmaster_protect.instrument_id_al AND frmaster.protection_id = ltmaster_protect.prtctn_id
			  LEFT JOIN bu_captools_work.vds_tmp_lt_instr_master_t AS ltmaster_instr
			  ON	frmaster.instrument_id_al = ltmaster_instr.instrument_id_al;


--Instruments
CREATE TABLE bu_captools_work.vds_tmp_legalp_instruments AS
SELECT  intrsmaster.instrument_id_al AS v_1_instrument_id,
        intrsmaster.zcliente AS v_2_counterparty_id,
        dd_value_3.dd_value AS v_3_crr_expo_class,
        dd_value_4.dd_value AS v_4_finrep_expo_class,
        intrsmaster.rwa_final AS v_5_total_risk_expo_amnt,
        intrsmaster.lgdfinal AS v_6_lgd,
        intrsmaster.lgd_ifrs9 AS v_7_ifrs9_lgd
FROM
(
    SELECT instrument_id_al, zcliente, rwa_final, lgdfinal, lgd_ifrs9, segmento_corep_final, contraparte_i
    FROM bu_captools_work.vds_tmp_instrument_master
    WHERE	vds_type = 'LEGALP'
) AS intrsmaster
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "3"
) AS dd_value_3
ON dd_value_3.dd_code = intrsmaster.segmento_corep_final
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "4"
) AS dd_value_4
ON dd_value_4.dd_code = intrsmaster.contraparte_i;



--Counterparties
CREATE TABLE bu_captools_work.vds_tmp_legalp_counterparties AS
SELECT 	a.zcliente AS v_2_counterparty_id,
        MAX(intrnl_rtng) AS v_8_curr_intrnl_cred_rating,
        MAX(extrnl_rtng) AS v_9_ext_cred_rating,
        SUM(
                ead_final_liquida *
                (CASE WHEN final_stage = '1' THEN pd12m_ifrs9
					      ELSE pd_lt_ifrs9 END)
			  ) / SUM(ead_final_liquida) AS v_10_ifrs9_pd
FROM	bu_captools_work.vds_tmp_counterparties_master AS a
			  INNER JOIN
			  (
				      SELECT DISTINCT zcliente
				      FROM	bu_captools_work.vds_tmp_instrument_master
				      WHERE	vds_type = 'LEGALP' AND zcliente IS NOT NULL
			  ) AS b ON a.zcliente = b.zcliente
GROUP BY
			  a.ZCLIENTE;



--Protections
CREATE TABLE bu_captools_work.vds_tmp_legalp_protections AS
SELECT  protecmaster.protection_id AS v_12_protection_id,
        protecmaster.instrument_id_al AS v_1_instrument_id,
        dd_value1.dd_value AS v_187_collateral_type,
        CAST(NULL AS DOUBLE) AS v_14_building_area,    -- cd_emprestimos.gpt32_bemimove.NARIMPL --campo comentado no script deles, nós forçamos a NULL
		    CAST(NULL AS DOUBLE) AS v_15_landing_area,    --cd_emprestimos.gpt32_bemimove.NARTERR   --campo comentado no script deles, nós forçamos a NULL
		    protecmaster.rl_estt_pst_cd AS v_16_property_postcode,
        protecmaster.thrd_prty_prrty_clms AS v_17_lien_position
FROM bu_captools_work.vds_tmp_protections_master AS protecmaster
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "187"
) AS dd_value1
ON dd_value1.dd_code = protecmaster.typ_prtctn
INNER JOIN
(
      SELECT DISTINCT instrument_id_al
      FROM	bu_captools_work.vds_tmp_instrument_master
      WHERE	vds_type = 'LEGALP'
) AS instrument_id_al_1
ON protecmaster.instrument_id_al = instrument_id_al_1.instrument_id_al;




--Natural Persons
CREATE TABLE bu_captools_work.vds_tmp_naturalp_instruments AS
SELECT  instrumaster.instrument_id_al AS v_1_instrument_id,
        instrumaster.zcliente AS v_2_counterparty_id,
        ${VAR:LEI_CODE_BST} AS v_139_report_data_id,
        ${VAR:LEI_CODE_BST} AS v_140_observed_agnt_id,
        instrumaster.instrument_id_al AS v_141_contract_id,
        dd_value_test1.dd_value AS v_3_crr_expo_class,
        dd_value_test2.dd_value AS v_4_finrep_expo_class,
        instrumaster.rwa_final AS v_5_total_risk_expo_amnt,
        instrumaster.lgdfinal AS v_6_lgd,
        instrumaster.lgd_ifrs9 AS v_7_ifrs9_lgd,
        dd_value_test3.dd_value AS v_35_instrument_type,
        dd_value_test4.dd_value AS v_142_amortization_type,
        COALESCE(instrumaster.cmoeda_act, instrumaster.cmoeda_pas) AS v_143_currency,
        instrumaster.dinicio AS v_144_inception_date,
        instrumaster.dfim_care AS v_145_end_date_interest,
        CASE
          					WHEN COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) = '0' THEN 'OVERNIGHT'

          					WHEN COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '1' THEN 'MONTHLY'

          					WHEN COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '3' OR (COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) = 'R'
                            AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '1') THEN 'QUARTERLY'

          					WHEN (COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '6') OR (COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) = 'R'
                            AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '2') OR (COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) = 'E' AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '1') THEN 'SEMI-ANNUAL'

          					WHEN COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '12' OR (COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) = 'R'
                            AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '4') OR (COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) = 'E' AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '2')
                            OR (COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas) IN ('3', 'N') AND SUBSTRING(COALESCE(instrumaster.cod_freq_taxa_act, instrumaster.cod_freq_taxa_pas), 2, 8) = '1') THEN 'ANNUAL'

          					ELSE 'OTHER FREQUENCY'
         END AS v_148_interest_rate_rst_freq,
        COALESCE(instrumaster.tx_spread_act_1, instrumaster.tx_spread_pas_1) AS v_149_interest_rate_spread,
        (
				      CASE
  					    WHEN COALESCE(instrumaster.cod_tipo_taxa_ref_act, instrumaster.cod_tipo_taxa_ref_pas) LIKE 'V' THEN 'Variable'
  					    WHEN COALESCE(instrumaster.cod_tipo_taxa_ref_act, instrumaster.cod_tipo_taxa_ref_pas) LIKE 'F' THEN 'Fixed'
					      ELSE 'Mixed'
		          END
        ) AS v_150_interest_rate_type,
        instrumaster.dfim AS v_151_legal_final_maturity_date,
        instrumaster.cmmtmnt_incptn_instrmnt AS v_152_commitment_inception_amnt,
        (
        				CASE
        					WHEN COALESCE(instrumaster.tx_contrato_act, instrumaster.tx_contrato_pas) = 0 THEN 'Zero Coupon'
        					WHEN COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '1' THEN 'Monthly'
        					WHEN (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '3') OR (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) = 'R'
                  AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '1') THEN 'Quarterly'
        					WHEN (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '6') OR (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) = 'R'
                  AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '2') OR (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) = 'E' AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '1') THEN 'Semi-annual'
        					WHEN (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '12') OR (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) = 'R'
                  AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '4') OR (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) = 'E' AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '2')
                  OR (COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas) IN ('3', 'N') AND SUBSTRING(COALESCE(instrumaster.cod_freq_liq_jur_act, instrumaster.cod_freq_liq_jur_pas), 2, 8) = '1') THEN 'Annual'
        					ELSE 'Other frequency'
        				END
  			) AS v_153_interest_payment_freq,
        (
        				CASE
        					WHEN instrumaster.cod_tipo_amortizacao IN ('A', 'U') THEN 'Bullet'
        					WHEN COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '1' THEN 'Monthly'
        					WHEN (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '3') OR (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) = 'R'
                  AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '1') THEN 'Quarterly'
        					WHEN (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '6') OR (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) = 'R'
                  AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '2') OR (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) = 'E' AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '1') THEN 'Semi-annual'
        					WHEN (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) IN ('2', 'M') AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '12') OR (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) = 'R'
                  AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '4') OR (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) = 'E' AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '2')
                  OR (COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas) IN ('3', 'N') AND SUBSTRING(COALESCE(instrumaster.cod_freq_amort_capital_act, instrumaster.cod_freq_amort_capital_pas), 2, 8) = '1') THEN 'Annual'
        					ELSE 'Other frequency'
        				END
  			) AS v_153_capital_payment_freq,
        COALESCE(instrumaster.cod_tipo_taxa_ref_act, instrumaster.cod_tipo_taxa_ref_pas) AS v_154_reference_rate,
        instrumaster.dbreak_clause AS v_155_settlement_date,
        COALESCE(instrumaster.tx_contrato_act, instrumaster.tx_contrato_pas) AS v_156_interest_rate,
        COALESCE(instrumaster.dt_prox_renov_taxa_act, instrumaster.dt_prox_renov_taxa_pas) AS v_157_next_interest_rst_date,
        dd_value_test5.dd_value AS v_158_dflt_status,
        instrumaster.dt_dflt_stts_instrmnt AS v_159_dflt_status_date,
        instrumaster.arrrs_instrmnt AS v_161_arrears,
        instrumaster.dincump AS v_162_past_due_date,
        (
          				CASE
          					WHEN instrumaster.cod_spv LIKE "SYN%" THEN "SYNTHETIC SECURITISATION"
          					WHEN instrumaster.cod_spv <> "" THEN "TRADITIONAL SECURITISATION"
          					ELSE "NOT SECURITISED"
          				END
  			) AS v_163_securitization_type,
        instrumaster.otstndng_nmnl_amnt_instrmnt AS v_164_outstanding_nominal_amnt,
        CAST(NULL AS DOUBLE) AS v_165_accrued_interest,                         --campo comentado no script deles, nós forçamos a NULL
        instrumaster.mon_extrapatri AS v_166_off_balance_sheet_amnt,
        instrumaster.jnt_lblty_amnt AS v_167_joint_liabilities_amnt,
        dd_value_test6.dd_value AS v_168_accounting_classification,
        CAST(NULL AS STRING) AS v_169_balance_sheet_recognition,
        CAST(NULL AS DOUBLE) AS v_170_accumltd_write_offs,                      ----campo comentado no script deles, nós forçamos a NULL
        (instrumaster.mon_imparid_patri + instrumaster.mon_imparidade_extra) AS v_171_accumltd_impairment_amnt,
        dd_value_test7.dd_value AS v_172_impairment_type,
        dd_value_test8.dd_value AS v_173_impairment_assmnt_method,
        dd_value_test9.dd_value AS v_174_encumbrance_souces,
        (
          				CASE
          					WHEN instrumaster.final_stage = '3' THEN "Non-performing"
          					ELSE "Performing"
          				END
  			) AS v_175_performing_status,
        CAST(NULL AS STRING) AS v_176_performing_status_date,                   --campo comentado no script deles, nós forçamos a NULL
        instrumaster.mon_imparidade_extra AS v_177_provisions_offbal,
        dd_value_test10.dd_value AS v_178_forbearance_status,
        instrumaster.dt_frbrnc_stts AS v_179_forbearance_status_date,
        instrumaster.valor AS v_180_cumulative_recoveries,
        (instrumaster.mon_jur_total + instrumaster.mon_cap_total + instrumaster.mon_comissoes + instrumaster.mon_despesas + instrumaster.mon_imparid_patri) AS v_181_carrying_amnt,
        dd_value_test11.dd_value AS v_182_prudential_portofolio,
        instrumaster.accmltd_chngs_fv_cr_instrmnt AS v_183_accumltd_chages
FROM
(
    SELECT instrument_id_al, zcliente, rwa_final, lgdfinal, lgd_ifrs9, cmoeda_act, cmoeda_pas, dinicio, dfim_care, cod_freq_taxa_act, cod_freq_taxa_pas, tx_spread_act_1, tx_spread_pas_1, cod_tipo_taxa_ref_act, cod_tipo_taxa_ref_pas, dfim, cmmtmnt_incptn_instrmnt, tx_contrato_act, tx_contrato_pas, cod_freq_liq_jur_act, cod_freq_liq_jur_pas, cod_tipo_amortizacao, cod_freq_amort_capital_act, cod_freq_amort_capital_pas, dbreak_clause, dt_prox_renov_taxa_act, dt_prox_renov_taxa_pas, dt_dflt_stts_instrmnt, arrrs_instrmnt, dincump, cod_spv, otstndng_nmnl_amnt_instrmnt, mon_extrapatri, jnt_lblty_amnt, mon_imparid_patri, mon_imparidade_extra, final_stage, dt_frbrnc_stts, mon_jur_total, mon_cap_total, mon_comissoes, mon_despesas, accmltd_chngs_fv_cr_instrmnt, segmento_corep_final, contraparte_i, typ_instrmnt, typ_amrtstn, dflt_stts_instrmnt, carteira_contabilistica, stage, tipo_analise, srcs_encmbrnc, frbrnc_stts_instrmnt, valor
    FROM bu_captools_work.vds_tmp_instrument_master
    WHERE	vds_type = 'NATURALP'
) AS instrumaster
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "3"
) AS dd_value_test1
ON dd_value_test1.dd_code = instrumaster.segmento_corep_final
LEFT JOIN
(
      SELECT dd_code, dd_value
      FROM bu_captools_work.codemapping
      WHERE dd_field_id = "4"
) AS dd_value_test2
ON dd_value_test2.dd_code = instrumaster.contraparte_i
LEFT JOIN
(
      SELECT dd_code, dd_value
      FROM bu_captools_work.codemapping
      WHERE dd_field_id = "35"
) AS dd_value_test3
ON dd_value_test3.dd_code = instrumaster.typ_instrmnt
LEFT JOIN
(
      SELECT dd_code, dd_value
      FROM bu_captools_work.codemapping
      WHERE dd_field_id = "142"
) AS dd_value_test4
ON dd_value_test4.dd_code = instrumaster.typ_amrtstn
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "158"
) AS dd_value_test5
ON dd_value_test5.dd_code = instrumaster.dflt_stts_instrmnt
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "168"
) AS dd_value_test6
ON dd_value_test6.dd_code = instrumaster.carteira_contabilistica
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "172"
) AS dd_value_test7
ON dd_value_test7.dd_code = instrumaster.stage
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "173"
) AS dd_value_test8
ON dd_value_test8.dd_code = instrumaster.tipo_analise
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "174"
) AS dd_value_test9
ON dd_value_test9.dd_code = COALESCE(instrumaster.srcs_encmbrnc,"")
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "178"
) AS dd_value_test10
ON dd_value_test10.dd_code = instrumaster.frbrnc_stts_instrmnt
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "182"
) AS dd_value_test11
ON dd_value_test11.dd_code = instrumaster.carteira_contabilistica;



--nao deu para correr pois usar tabelas anteriores
CREATE TABLE bu_captools_work.vds_tmp_naturalp_counterparties AS
SELECT countermaster.zcliente AS v_2_counterparty_id,
       countermaster.ead_in_pdini_sum/countermaster.ead_final_bruta_soma AS v_139_pd,
       countermaster.intrnl_rtng_max AS v_8_curr_intrnl_cred_rating,
       countermaster.ead_final_bruta_case/countermaster.ead_final_bruta_soma AS v_10_ifrs9_pd,
       primeiro_dd_value.dd_value AS v_185_dflt_status,
       countermaster.dt_dflt_stts_instrmnt_min AS v_186_dflt_status_date
FROM (
  SELECT zcliente,
         SUM(CAST(ead_final_bruta AS DECIMAL(30,8)) * CAST(in_pdini AS DECIMAL(30,8))) AS ead_in_pdini_sum,
         SUM(CAST(ead_final_bruta AS DECIMAL(30,8))) AS ead_final_bruta_soma,
         MAX(CAST(intrnl_rtng AS DECIMAL(30,8))) AS intrnl_rtng_max,
         SUM(CAST(ead_final_bruta AS DECIMAL(30,8)) * IF(final_stage = '1', CAST(pd12m_ifrs9 AS DECIMAL(30,8)), CAST(pd_lt_ifrs9 AS DECIMAL(30,8)))) AS ead_final_bruta_case,
         MIN(dt_dflt_stts_instrmnt) AS dt_dflt_stts_instrmnt_min
  FROM	bu_captools_work.vds_tmp_counterparties_master
  GROUP BY zcliente
) AS countermaster
INNER JOIN
(
         SELECT DISTINCT zcliente
         FROM	bu_captools_work.vds_tmp_instrument_master
         WHERE	vds_type = 'NATURALP'
         AND zcliente IS NOT NULL
) AS vdstmpmaster
ON vdstmpmaster.zcliente = countermaster.zcliente
LEFT JOIN
(
         SELECT	zcliente,
                MAX(dflt_stts_instrmnt) AS max_dflt_stts_instrmnt
         FROM	bu_captools_work.vds_tmp_instrument_master
         GROUP BY zcliente
) AS vdstmpmasterc
ON countermaster.zcliente = vdstmpmasterc.zcliente
LEFT JOIN
(
  SELECT	dd_code, dd_value
  FROM	bu_captools_work.codemapping
  WHERE	dd_field_id = "185"
)  AS primeiro_dd_value
ON primeiro_dd_value.dd_code = vdstmpmasterc.max_dflt_stts_instrmnt;



--Algumas colunas estão com todos os campos todos a NULL
CREATE TABLE bu_captools_work.vds_tmp_naturalp_protections AS
SELECT 	vtpmaster.protection_id AS v_12_protection_id,
        vtpmaster.garante AS v_219_protection_provider_id,
        vtpmaster.instrument_id_al AS v_1_instrument_id,
        dd_187.dd_value AS v_187_collateral_type,
        vtpmaster.rl_estt_pst_cd AS v_16_property_postcode,   --INPUT(RL_ESTT_PST_CD,8.) AS V_16_PROPERTY_POSTCODE
			  vtpmaster.thrd_prty_prrty_clms AS v_17_lien_position,
        vtpmaster.dultmod AS v_188_protect_value_date,
        vtpmaster.mavaliaa AS v_220_protect_value,
        vtpmaster.dvencime AS v_189_protect_maturity_date,
        vtpmaster.mavaliai AS v_190_orig_protect_value,
        vtpmaster.dabertur AS v_191_orig_protect_value_date,
        'Fair value' AS v_192_protect_value_type,
        'Mark-to-to-market valuation' AS v_221_protect_valuation_apprch,
        vtpmaster.prtctn_allctd_vl AS v_193_protect_alloc_value,
        vtpmaster.thrd_prty_prrty_clms AS v_194_third_party_prrty_claims
FROM 	bu_captools_work.vds_tmp_protections_master AS vtpmaster
INNER JOIN
(
  SELECT DISTINCT instrument_id_al
  FROM	bu_captools_work.vds_tmp_instrument_master
  WHERE	vds_type = 'NATURALP'
) AS vtimaster
ON vtpmaster.instrument_id_al = vtimaster.instrument_id_al
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "187"
) AS dd_187
ON dd_187.dd_code = vtpmaster.typ_prtctn;




-- Vem sempre sem valores devido à condição do where
--Off-Balance Sheet Exposures
CREATE TABLE bu_captools_work.vds_tmp_offbal_instruments AS
SELECT  vdstimaster.instrument_id_al AS v_1_instrument_id,
        vdstimaster.zcliente AS v_2_counterparty_id,
        ${VAR:LEI_CODE_BST} AS v_139_report_data_id,
        ${VAR:LEI_CODE_BST} AS v_140_observed_agnt_id,
        vdstimaster.instrument_id_al AS v_141_contract_id,
        dd_3.dd_value AS v_3_crr_expo_class,
        dd_4.dd_value AS v_4_finrep_expo_class,
        vdstimaster.k2 AS v_23_cff,
        vdstimaster.rwa_final AS v_5_total_risk_expo_amnt,
        vdstimaster.lgdfinal AS v_6_lgd,
        vdstimaster.lgd_ifrs9 AS v_7_ifrs9_lgd,
        vdstimaster.mon_extrapatri AS v_223_nominal_amnt,
        vdstimaster.dfim AS v_224_maturity_date,
        COALESCE(vdstimaster.tx_contrato_act, vdstimaster.tx_contrato_pas) AS v_225_nominal_interest_rate,
        dd_158.dd_value AS v_158_dflt_status,
        vdstimaster.dt_dflt_stts_instrmnt AS v_159_dflt_status_date,
        vdstimaster.arrrs_instrmnt AS v_161_arrears,
        vdstimaster.dincump AS v_162_past_due_date,
        vdstimaster.jnt_lblty_amnt AS v_167_joint_liabilities_amnt,
        SUM(vdstimaster.mon_imparid_patri + vdstimaster.mon_imparidade_extra) AS v_171_impairment_accumltd_amnt,
        dd_172.dd_value AS v_172_impairment_type,
        dd_173.dd_value AS v_173_impairment_assmnt_method,
        (
  				CASE
  					WHEN vdstimaster.final_stage = "3" THEN "Non-performing"
  					ELSE "Performing"
  				END
			  ) AS v_175_performing_status,
        CAST(NULL AS STRING) AS v_176_performing_status_date,                   --campo comentado no script deles, nós forçamos a NULL
        dd_178.dd_value AS v_178_forbearance_status,
        vdstimaster.dt_frbrnc_stts AS v_179_forbearance_status_date
FROM
(
    SELECT instrument_id_al, zcliente, k2, rwa_final, lgdfinal, lgd_ifrs9, mon_extrapatri, dfim, tx_contrato_act, tx_contrato_pas, dt_dflt_stts_instrmnt, arrrs_instrmnt, dincump, jnt_lblty_amnt, mon_imparid_patri, mon_imparidade_extra, final_stage, dt_frbrnc_stts, segmento_corep_final, contraparte_i, dflt_stts_instrmnt, stage, tipo_analise, frbrnc_stts_instrmnt
    FROM bu_captools_work.vds_tmp_instrument_master
    WHERE	vds_type = 'OFFBAL'
) AS vdstimaster
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "3"
) AS dd_3
ON dd_3.dd_code = vdstimaster.segmento_corep_final
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "4"
) AS dd_4
ON dd_4.dd_code = vdstimaster.contraparte_i
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "158"
) AS dd_158
ON dd_158.dd_code = vdstimaster.dflt_stts_instrmnt
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "172"
) AS dd_172
ON dd_172.dd_code = vdstimaster.stage
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "173"
) AS dd_173
ON dd_173.dd_code = vdstimaster.tipo_analise
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "178"
) AS dd_178
ON dd_178.dd_code = vdstimaster.frbrnc_stts_instrmnt
GROUP BY vdstimaster.instrument_id_al,
        vdstimaster.zcliente,
        '549300URJH9VSI58CS32',
        vdstimaster.instrument_id_al,
        dd_3.dd_value,
        dd_4.dd_value,
        vdstimaster.k2,
        vdstimaster.rwa_final,
        vdstimaster.lgdfinal,
        vdstimaster.lgd_ifrs9,
        vdstimaster.mon_extrapatri,
        vdstimaster.dfim,
        COALESCE(vdstimaster.tx_contrato_act, vdstimaster.tx_contrato_pas),
        dd_158.dd_value,
        vdstimaster.dt_dflt_stts_instrmnt,
        vdstimaster.arrrs_instrmnt,
        vdstimaster.dincump,
        vdstimaster.jnt_lblty_amnt,
        dd_172.dd_value,
        dd_173.dd_value,
        (
  		CASE
  			WHEN vdstimaster.final_stage = "3" THEN "Non-performing"
  			ELSE "Performing"
  		END
	    ),
        dd_178.dd_value,
        vdstimaster.dt_frbrnc_stts




--Os campos v_209_legal_prcdngs_status e v_211_enterprise_size vêm sempre a vazio, pois na ligação com a tabela vds_tmp_counterparties_master tem sempre
--as colunas entrprs_sz_le e lgl_prcdng_stts_le a NULL, confirmar após uma nova execução se isto se mantem.
CREATE TABLE bu_captools_work.vds_tmp_offbal_counterparties AS
SELECT  vtcountermaster.zcliente AS v_2_counterparty_id,
        vtcountermaster.max_intrnl AS v_8_curr_intrnl_cred_rating,
        vtcountermaster.max_extrnl AS v_9_ext_cred_rating,
        vtcountermaster.sum_case/vtcountermaster.sum_efl AS v_10_ifrs9_pd,
        vtcountermaster.sum_efb_ip/vtcountermaster.sum_efb AS v_139_pd,
        dd_185.dd_value AS v_185_dflt_status,
        vtcountermaster.min_ddsi AS v_186_dflt_status_date,
        vtcountermaster.max_clei AS v_195_lei,
        vtcountermaster.max_cnif_resid AS v_196_national_id,
        vtcountermaster.max_zgrupo AS v_197_head_office_undrtk_id,
        vtcountermaster.max_zgrupo AS v_198_immediate_parent_undrtk_id,
        vtcountermaster.max_zgrupo AS v_199_ultimate_parent_undrtk_id,
        vtcountermaster.max_gcliente AS v_200_name,
        vtcountermaster.max_clyd18c1_nmorada AS v_201_addr_street,
        vtcountermaster.max_clyd18c1_nlocalid AS v_202_addr_city,
        vtcountermaster.max_clyd18c1_cpostal AS v_203_addr_postal_code,
        vtcountermaster.max_tayd91c0_nelemc09 AS v_205_addr_country,
        vtcountermaster.max_ccae AS v_206_legal_form,
        dd_207.v_207_institutional_sector,
        vtcountermaster.max_nace_code AS v_208_economic_activity,
        dd_209.v_209_legal_prcdngs_status,
        vtcountermaster.max_dt_inttn_lgl_prcdngs_le AS v_210_legal_prcdngs_status_date,
        dd_211.v_211_enterprise_size,
        CAST(NULL AS STRING) AS v_212_enterprise_size_date,                     --campo comentado no script deles, nós forçamos a NULL
        vtcountermaster.max_num_empl AS v_213_number_employees,
        vtcountermaster.max_tot_acti AS v_214_balance_sheet_total,
        vtcountermaster.max_annl_trnvr_le AS v_215_annual_turnover,
        "IFRS" AS v_216_accounting_standard
FROM
(
  SELECT  zcliente,
          MAX(intrnl_rtng) AS  max_intrnl,
          MAX(extrnl_rtng) AS max_extrnl,
          SUM(ead_final_liquida * (CASE WHEN final_stage = '1' THEN pd12m_ifrs9 ELSE pd_lt_ifrs9 END)) AS sum_case,
          sum(ead_final_liquida) AS sum_efl,
          SUM( ead_final_bruta * in_pdini) AS sum_efb_ip,
          SUM(ead_final_bruta) AS sum_efb,
          MIN(dt_dflt_stts_instrmnt) AS min_ddsi,
          MAX(clei) AS max_clei,
          MAX(cnif_resid) AS max_cnif_resid,
          MAX(zgrupo) AS max_zgrupo,
          MAX(gcliente) AS max_gcliente,
          MAX(clyd18c1_nmorada) AS max_clyd18c1_nmorada,
          MAX(clyd18c1_nlocalid) AS max_clyd18c1_nlocalid,
          MAX(clyd18c1_cpostal) AS max_clyd18c1_cpostal,
          MAX(tayd91c0_nelemc09) AS max_tayd91c0_nelemc09,
          MAX(ccae) AS max_ccae,
          MAX(nace_code) AS max_nace_code,
          MAX(dt_inttn_lgl_prcdngs_le) AS max_dt_inttn_lgl_prcdngs_le,
          MAX(num_empl) AS max_num_empl,
          MAX(tot_acti) AS max_tot_acti,
          MAX(annl_trnvr_le) AS max_annl_trnvr_le
  FROM bu_captools_work.vds_tmp_counterparties_master
  GROUP BY zcliente
) AS vtcountermaster
INNER JOIN
(
  SELECT zcliente
  FROM	bu_captools_work.vds_tmp_instrument_master
  WHERE	vds_type = 'OFFBAL' AND zcliente IS NOT NULL
  GROUP BY zcliente
) AS vtinstrmaster
ON vtcountermaster.zcliente = vtinstrmaster.zcliente
LEFT JOIN
(
  SELECT  zcliente,
          MAX(dflt_stts_instrmnt) AS max_dflt_stts_instrmnt
  FROM	bu_captools_work.vds_tmp_instrument_master
  GROUP BY zcliente
) AS vdstimaster
ON vtcountermaster.zcliente = vdstimaster.zcliente
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "185"
) AS dd_185
ON dd_185.dd_code = vdstimaster.max_dflt_stts_instrmnt

LEFT JOIN
(
  SELECT master.zcliente, MAX(codemap.dd_value) as v_207_institutional_sector
  FROM
  (
      SELECT zcliente, csector_inst
      FROM bu_captools_work.vds_tmp_counterparties_master
  ) AS master
  LEFT JOIN
  (
      SELECT dd_code, dd_value
      FROM bu_captools_work.codemapping
      WHERE dd_field_id = "207"
  ) AS codemap
  ON TRIM(master.csector_inst) = TRIM(codemap.dd_code)
  GROUP BY master.zcliente
) AS dd_207
ON dd_207.zcliente = vtcountermaster.zcliente

LEFT JOIN
(
  SELECT master.zcliente, MAX(codemap.dd_value) as v_209_legal_prcdngs_status
  FROM
  (
      SELECT zcliente, lgl_prcdng_stts_le
      FROM bu_captools_work.vds_tmp_counterparties_master
  ) AS master
  LEFT JOIN
  (
      SELECT dd_code, dd_value
      FROM bu_captools_work.codemapping
      WHERE dd_field_id = "209"
  ) AS codemap
  ON TRIM(master.lgl_prcdng_stts_le) = TRIM(codemap.dd_code)
  GROUP BY master.zcliente
) AS dd_209
ON dd_209.zcliente = vtcountermaster.zcliente

LEFT JOIN
(
  SELECT master.zcliente, MAX(codemap.dd_value) as v_211_enterprise_size
  FROM
  (
      SELECT zcliente, entrprs_sz_le
      FROM bu_captools_work.vds_tmp_counterparties_master
  ) AS master
  LEFT JOIN
  (
      SELECT dd_code, dd_value
      FROM bu_captools_work.codemapping
      WHERE dd_field_id = "211"
  ) AS codemap
  ON TRIM(master.entrprs_sz_le) = TRIM(codemap.dd_code)
  GROUP BY master.zcliente
) AS dd_211
ON dd_211.zcliente = vtcountermaster.zcliente



-- Não é possivel correr a query devido à condição WHERE vds_type = 'OFFBAL' já que nao existem esse campo na tabela à qual supostament eo vai buscar
--PROTECTION_RECEIVED
--v_187, v_16, v_193 e v_194 pertencem a Loan Tapes
CREATE TABLE bu_captools_work.vds_tmp_offbal_protections AS
SELECT  vtpmaster.protection_id AS v_12_protection_id,
        vtpmaster.garante AS v_219_protection_provider_id,
        dd_187_.dd_value AS v_187_collateral_type,
        vtpmaster.instrument_id_al AS v_1_instrument_id,
        vtpmaster.rl_estt_pst_cd AS v_16_property_postcode,   --INPUT(RL_ESTT_PST_CD,8.) AS V_16_PROPERTY_POSTCODE
		vtpmaster.thrd_prty_prrty_clms AS v_17_lien_position,
        vtpmaster.dultmod AS v_188_protect_value_date,
        vtpmaster.mavaliaa AS v_220_protect_value,
        vtpmaster.dvencime AS v_189_protect_maturity_date,
        vtpmaster.mavaliai AS v_190_orig_protect_value,
        vtpmaster.dabertur AS v_191_orig_protect_value_date,
        "Fair value" AS v_192_protect_value_type,
        "Mark-to-to-market valuation" AS v_221_protect_valuation_apprch,
        vtpmaster.prtctn_allctd_vl AS v_217_protect_alloc_value,
        vtpmaster.thrd_prty_prrty_clms AS v_218_third_party_prrty_claims
FROM
( SELECT  instrument_id_al, protection_id, garante, rl_estt_pst_cd, thrd_prty_prrty_clms, dultmod, mavaliaa,   dvencime, mavaliai, dabertur, prtctn_allctd_vl, typ_prtctn
  FROM bu_captools_work.vds_tmp_protections_master                                                   --a unica tabela que tem este campo é VDS_TMP_INSTRUMENT_MASTER  mas nesse caso os campos necessários para criar esta tabela não existem
) AS vtpmaster
INNER JOIN
(
	SELECT DISTINCT instrument_id_al
	FROM	bu_captools_work.vds_tmp_instrument_master
	WHERE	vds_type = 'OFFBAL'
) AS orig
ON vtpmaster.instrument_id_al = orig.instrument_id_al
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "187"
) AS dd_187_
ON dd_187_.dd_code = vtpmaster.typ_prtctn;



--DERIVATIVES
--V_24 acho que carece de mapeamento
CREATE TABLE bu_captools_work.vds_tmp_derivatives AS
SELECT vdstimaster.instrument_id_al AS v_140_unique_trade_id,
       COALESCE(vdstimaster.clei, vdstimaster.cnum_doc_identif1) AS v_2_counterparty_id,
       vdstimaster.issr_id_typ AS v_24_type_counterparty_id,
       vdstimaster.tayd91c0_nelemc09 AS v_25_counterparty_country,
       vdstimaster.cproduto_mis AS v_27_product_id,
       vdstimaster.cod_tipo_taxa_ref_act AS v_43_leg1_ref_rate,
       vdstimaster.cod_tipo_taxa_ref_pas AS v_44_leg2_ref_rate,
       dd_45.dd_value AS v_45_leg1_ref_period,
       dd_46.dd_value  AS v_46_leg2_ref_period,
       vdstimaster.code_pcd AS v_51_netting_agreement,
       (vdstimaster.mon_jur_total + vdstimaster.mon_cap_total + vdstimaster.mon_comissoes + vdstimaster.mon_despesas + vdstimaster.mon_imparid_patri) AS v_52_carrying_amnt,
       "IFRS" AS v_53_accounting_standards,
       dd_54.dd_value AS v_54_accounting_classification,
       vdstimaster.hedge_id AS v_56_hedge_id,
       vdstimaster.rwa_final AS v_5_total_risk_expo_amnt
FROM
(
  SELECT instrument_id_al, clei, cnum_doc_identif1, issr_id_typ, tayd91c0_nelemc09, cproduto_mis, cod_tipo_taxa_ref_act, cod_tipo_taxa_ref_pas, code_pcd, mon_jur_total, mon_cap_total, mon_comissoes, mon_despesas, mon_imparid_patri, hedge_id, rwa_final, cod_freq_taxa_act, cod_freq_taxa_pas, carteira_contabilistica
  FROM 	bu_captools_work.vds_tmp_instrument_master
  WHERE vds_type = 'DERIVATIVE'
) AS vdstimaster
LEFT JOIN
(
   SELECT dd_code, dd_value
   FROM bu_captools_work.codemapping
   WHERE dd_field_id = "45"
) AS dd_45
ON dd_45.dd_code = vdstimaster.cod_freq_taxa_act
LEFT JOIN
(
   SELECT dd_code, dd_value
   FROM bu_captools_work.codemapping
   WHERE dd_field_id = "46"
) AS dd_46
ON dd_46.dd_code = vdstimaster.cod_freq_taxa_pas
LEFT JOIN
(
   SELECT dd_code, dd_value
   FROM bu_captools_work.codemapping
   WHERE dd_field_id = "54"
) AS dd_54
ON dd_54.dd_code = vdstimaster.carteira_contabilistica



--FINANCIAL ASSETS
--v65,v67, 69, 70,71,72,73,80 88 e 89 vazio porque sao das loan tapes
--v95 falta de dados na fonte
CREATE TABLE bu_captools_work.vds_tmp_debt_securities AS
SELECT  tabdtim.instrument_id_al AS v_58_financial_contract_id,
        tabdtim.isin AS v_59_isin,
        tabdtim.issr_id AS v_60_issuer_id,
        tabdtim.issr_id_typ AS v_61_type_issuer_id,
        tabdtim.tayd91c0_nelemc09 AS v_62_country_issuer,
        tabdtim.issr_esa_2010 AS v_63_issuer_esa,
        tabdtim.ecnmc_actvty AS v_64_issuer_nace,
        tabdtim.extrnl_rtng AS v_65_issuer_rating,
        tabdtim.issr_rtng_src AS v_66_issuer_rating_source,
        tabdtim.issr_typ AS v_67_issuer_type,
        tabdtim.tayd91c0_nelemc01 AS v_68_currency,
        tabdtim.dt_vltn AS v_69_valuation_timestamp,
        dd_70.dd_value AS v_70_valuation_type,
        dd_71.dd_value AS v_71_inst_class,
        dd_72.dd_value AS v_72_primary_asset_class,
        dd_73.dd_value AS v_73_asset_securit_class,
        (
  				CASE
  					WHEN tabdtim.tipo_oferta = "Particular" THEN "Private (2)"
  					ELSE "Public (1)"
  				END
        ) AS v_74_placement_type,
        tabdtim.dt_emissao AS v_75_issuance_date,
        tabdtim.dt_vencim AS v_76_maturity_date,
        dd_77.id_lei_nif AS v_77_guarantor_id,
        tabdtim.grntr_id_typ AS v_78_type_guarantor_id,
        dd_80.dd_value AS v_80_type_inst_seniority,
        (
  				CASE
  					WHEN tabdtim.tipo_tx = "FIXA" THEN "Fixed"
  					WHEN tabdtim.tipo_tx = "VARIAVEL" THEN "Floating"
  					WHEN TRIM(tabdtim.tx_fixa) = "0" AND TRIM(tabdtim.sprd_tx_var) = "0" THEN "Zero coupon"
  					ELSE "Other"
  				END
        ) AS v_81_coupon_type,
        (
  				CASE
  					WHEN LEFT(tabdtim.frq_liq_jur, 1) = "M" THEN "Monthly"
  					WHEN LEFT(tabdtim.frq_liq_jur, 1) = "A" THEN "Annual"
  					WHEN tabdtim.frq_liq_jur = "M06" THEN "Semi-annual"
  					ELSE "Other"
  				END
        ) AS v_82_coupon_freq,
        dd_83.dd_value AS v_83_coupon_currency,
        tabdtim.tx_fixa AS v_84_coupon_rate,
        tabdtim.tx_vigente AS v_85_reference_rate,
        tabdtim.sprd_tx_var AS v_86_spread,
        dd_87.dd_value AS v_87_currency_nominal_amnt,
        dd_88.dd_value AS v_88_purchase_under_resale,
        dd_89.dd_value AS v_89_encumbrance_sources,
        dd_90.dd_value AS v_90_eligibility_ecb_ops,
        dd_91.dd_value AS v_91_lcr_buffer,
        (
  				CASE
  					WHEN tabdtim.grau_liquidez IN ('L1', 'L2A', 'L2B') THEN grau_liquidez
  					ELSE ""
  				END
        ) AS v_92_lcr_buffer_category,
        dd_93.dd_value AS v_93_accounting_classification,
        (
  				CASE
  					WHEN tabdtim.stage = '3' THEN "NON-PERFORMING"
  					ELSE "PERFORMING"
  				END
        ) AS v_94_performing_status,
        dd_95.dd_value AS v_95_prudential_portfolio,
        tabdtim.hedge_id AS v_96_hedge_id,
        tabdtim.rwa_final AS v_5_total_risk_expo_amnt
FROM
( SELECT instrument_id_al, isin, issr_id, issr_id_typ, tayd91c0_nelemc09, issr_esa_2010, ecnmc_actvty, extrnl_rtng, issr_rtng_src, issr_typ, dt_vltn, tipo_oferta, dt_emissao, dt_vencim, clei, cnum_doc_identif1, entidade_garante, zcliente, grntr_id_typ, tipo_tx, frq_liq_jur, tx_fixa, tx_vigente, sprd_tx_var, grau_liquidez, stage, hedge_id, rwa_final, vltn_typ, instrmnt_clss, prmry_asst_clssf, asst_scrt_clss, instr_snrty_clss, tayd91c0_nelemc01, prch_undr_rsl_agr, srcs_encmbrnc, eleg_eurosistema, carteira_contabilistica
  FROM bu_captools_work.vds_tmp_instrument_master
  WHERE vds_type = 'DEBT'
) AS tabdtim
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "70"
) AS dd_70
ON dd_70.dd_code = tabdtim.vltn_typ
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "71"
) AS dd_71
ON dd_71.dd_code = tabdtim.instrmnt_clss
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "72"
) AS dd_72
ON dd_72.dd_code = tabdtim.prmry_asst_clssf
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "73"
) AS dd_73
ON dd_73.dd_code = tabdtim.asst_scrt_clss
LEFT JOIN
(
  SELECT entidade_garante, COALESCE(clei, cnum_doc_identif1) AS id_lei_nif
  FROM bu_captools_work.vds_tmp_instrument_master
  WHERE  zcliente IS NOT NULL
) AS dd_77
ON dd_77.entidade_garante = tabdtim.zcliente
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "80"
) AS dd_80
ON dd_80.dd_code = tabdtim.instr_snrty_clss
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "83"
) AS dd_83
ON dd_83.dd_code = tabdtim.tayd91c0_nelemc01
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "87"
) AS dd_87
ON dd_87.dd_code = tabdtim.tayd91c0_nelemc01
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "88"
) AS dd_88
ON dd_88.dd_code = tabdtim.prch_undr_rsl_agr
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "89"
) AS dd_89
 ON dd_89.dd_code = tabdtim.srcs_encmbrnc
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "90"
) AS dd_90
ON dd_90.dd_code = tabdtim.eleg_eurosistema
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "91"
) AS dd_91
ON dd_91.dd_code = tabdtim.eleg_eurosistema
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "93"
) AS dd_93
ON dd_93.dd_code = tabdtim.carteira_contabilistica
LEFT JOIN
(
  SELECT dd_code, dd_value
  FROM bu_captools_work.codemapping
  WHERE dd_field_id = "95"
) AS dd_95
ON dd_95.dd_code = tabdtim.carteira_contabilistica;



--LET MCR_SOURCE_DATA_NM = %m_vds_define_source_nm(&MCR_IS_EOM., &MCR_CD_CAPTOOLS..CT003_UNIV_CLI, &MCR_CD_CAPTOOLS..CT084_UNIV_CLI_D);
/*v65,v67, 69, 70 vazio porque sao das loan tapes*/
/*v95 falta de dados na fonte*/
CREATE TABLE bu_captools_work.vds_tmp_equity_instruments AS
SELECT  tabelavtim.instrument_id_al AS v_58_financial_contract_id,
        tabelavtim.isin AS v_59_isin,
        tabelavtim.issr_id AS v_60_issuer_id,
        tabelavtim.issr_id_typ AS v_61_type_issuer_id,
        tabelavtim.tayd91c0_nelemc09 AS v_62_country_issuer,
        tabelavtim.issr_esa_2010 AS v_63_issuer_esa,
        tabelavtim.ecnmc_actvty AS v_64_issuer_nace,
        tabelavtim.extrnl_rtng AS v_65_issuer_rating,
        tabelavtim.issr_rtng_src AS v_66_issuer_rating_source,
        tabelavtim.issr_typ AS v_67_issuer_type,
        tabelavtim.tayd91c0_nelemc01 AS v_68_currency,
        tabelavtim.dt_vltn AS v_69_valuation_timestamp,
        dd_field_70.dd_value AS v_70_valuation_type,
        dd_field_91.dd_value AS v_91_lcr_buffer,
        dd_field_93.dd_value AS v_93_accounting_classification,
        dd_field_95.dd_value AS v_95_prudential_portfolio,
        tabelavtim.rwa_final AS v_5_total_risk_expo_amnt
FROM(
    SELECT instrument_id_al, isin, issr_id, issr_id_typ, tayd91c0_nelemc09, issr_esa_2010, ecnmc_actvty, extrnl_rtng, issr_rtng_src, issr_typ, tayd91c0_nelemc01, dt_vltn, rwa_final, vltn_typ, eleg_eurosistema, carteira_contabilistica
    FROM bu_captools_work.vds_tmp_instrument_master
    WHERE vds_type = 'EQTY'
) AS tabelavtim
LEFT JOIN
(
    SELECT dd_code, dd_value
    FROM bu_captools_work.codemapping
    WHERE dd_field_id = "70"
) AS dd_field_70
ON dd_field_70.dd_code = tabelavtim.vltn_typ
LEFT JOIN
(
    SELECT dd_code, dd_value
    FROM bu_captools_work.codemapping
    WHERE dd_field_id = "91"
) AS dd_field_91
ON dd_field_91.dd_code = tabelavtim.eleg_eurosistema
LEFT JOIN
(
    SELECT dd_code, dd_value
    FROM bu_captools_work.codemapping
    WHERE dd_field_id = "93"
) AS dd_field_93
ON dd_field_93.dd_code = tabelavtim.carteira_contabilistica
LEFT JOIN
(
    SELECT dd_code, dd_value
    FROM bu_captools_work.codemapping
    WHERE dd_field_id = "95"
) AS dd_field_95
ON dd_field_95.dd_code = tabelavtim.carteira_contabilistica




--Legal Persons
INSERT INTO bu_captools_work.vds_out_legalp_instruments
	(
		v_1_instrument_id,
		v_2_counterparty_id,
	 	v_3_crr_expo_class,
		v_4_finrep_expo_class,
		v_5_total_risk_expo_amnt,
		v_6_lgd,
		v_7_ifrs9_lgd
	)
SELECT	v_1_instrument_id,
        v_2_counterparty_id,
		    v_3_crr_expo_class,
        v_4_finrep_expo_class,
        v_5_total_risk_expo_amnt,
        v_6_lgd,
        v_7_ifrs9_lgd
FROM	bu_captools_work.vds_tmp_legalp_instruments;


INSERT INTO bu_captools_work.vds_out_legalp_counterparties
	(
		v_2_counterparty_id,
		v_8_curr_intrnl_cred_rating,
		v_9_ext_cred_rating,
		v_10_ifrs9_pd
		/*V_11_PD*/
	)
SELECT 	v_2_counterparty_id,
        v_8_curr_intrnl_cred_rating,
        v_9_ext_cred_rating,
        v_10_ifrs9_pd
FROM 	bu_captools_work.vds_tmp_legalp_counterparties;


INSERT INTO bu_captools_work.vds_out_legalp_protections
	(
		v_12_protection_id,
		v_1_instrument_id,
		v_187_collateral_type,
		v_14_building_area,
		v_15_landing_area,
		v_16_property_postcode,
		v_17_lien_position
		/*V_18_COLLATERAL_SHIP_TYPE*/
	)
SELECT	v_12_protection_id,
        v_1_instrument_id,
		    v_187_collateral_type,
		    v_14_building_area,
		    v_15_landing_area,
		    v_16_property_postcode,
		    v_17_lien_position
FROM	bu_captools_work.vds_tmp_legalp_protections;


--Natural Persons
/* EM CURSO */
INSERT INTO bu_captools_work.vds_out_naturalp_instruments
  (
  	v_1_instrument_id,
  	v_2_counterparty_id,
  	v_139_report_data_id,
  	v_140_observed_agnt_id,
  	v_141_contract_id,
  	v_3_crr_expo_class,
  	v_4_finrep_expo_class,
  	v_5_total_risk_expo_amnt,
  	v_6_lgd,
  	v_7_ifrs9_lgd,
  	v_35_instrument_type,
  	v_142_amortization_type,
  	v_143_currency,
  	v_144_inception_date,
  	v_145_end_date_interest,
  	v_148_interest_rate_rst_freq,
  	v_149_interest_rate_spread,
  	v_150_interest_rate_type,
  	v_151_legal_final_maturity_date,
  	v_152_commitment_inception_amnt,
  	v_153_capital_payment_freq,
  	v_153_interest_payment_freq,
  	v_154_reference_rate,
  	v_155_settlement_date,
  	v_156_interest_rate,
  	v_157_next_interest_rst_date,
  	v_158_dflt_status,
  	v_159_dflt_status_date,
  	v_162_past_due_date,
  	v_163_securitization_type,
  	v_164_outstanding_nominal_amnt,
  	v_165_accrued_interest,
  	v_166_off_balance_sheet_amnt,
  	v_167_joint_liabilities_amnt,
  	v_168_accounting_classification,
  	v_169_balance_sheet_recognition,
  	v_170_accumltd_write_offs,
  	v_171_accumltd_impairment_amnt,
  	v_172_impairment_type,
  	v_173_impairment_assmnt_method,
  	v_174_encumbrance_souces,
  	v_175_performing_status,
  	v_176_performing_status_date,
  	v_177_provisions_offbal,
  	v_178_forbearance_status,
  	v_179_forbearance_status_date,
  	v_180_cumulative_recoveries,
  	v_181_carrying_amnt,
  	v_182_prudential_portofolio
  )
SELECT		v_1_instrument_id,
        	v_2_counterparty_id,
        	v_139_report_data_id,
        	v_140_observed_agnt_id,
        	v_141_contract_id,
        	v_3_crr_expo_class,
        	v_4_finrep_expo_class,
        	v_5_total_risk_expo_amnt,
        	v_6_lgd,
        	v_7_ifrs9_lgd,
        	v_35_instrument_type,
        	v_142_amortization_type,
        	v_143_currency,
        	v_144_inception_date,
        	v_145_end_date_interest,
        	v_148_interest_rate_rst_freq,
        	v_149_interest_rate_spread,
        	v_150_interest_rate_type,
        	v_151_legal_final_maturity_date,
        	v_152_commitment_inception_amnt,
        	v_153_capital_payment_freq,
        	v_153_interest_payment_freq,
        	v_154_reference_rate,
        	v_155_settlement_date,
        	v_156_interest_rate,
        	v_157_next_interest_rst_date,
        	v_158_dflt_status,
        	v_159_dflt_status_date,
        	v_162_past_due_date,
        	v_163_securitization_type,
        	v_164_outstanding_nominal_amnt,
        	v_165_accrued_interest,
        	v_166_off_balance_sheet_amnt,
        	v_167_joint_liabilities_amnt,
        	v_168_accounting_classification,
        	v_169_balance_sheet_recognition,
        	v_170_accumltd_write_offs,
        	v_171_accumltd_impairment_amnt,
        	v_172_impairment_type,
        	v_173_impairment_assmnt_method,
        	v_174_encumbrance_souces,
        	v_175_performing_status,
        	v_176_performing_status_date,
        	v_177_provisions_offbal,
        	v_178_forbearance_status,
        	v_179_forbearance_status_date,
        	v_180_cumulative_recoveries,
        	v_181_carrying_amnt,
        	v_182_prudential_portofolio
FROM	bu_captools_work.vds_tmp_naturalp_instruments;


INSERT INTO bu_captools_work.vds_out_naturalp_counterparties
	(
		v_2_counterparty_id,
		v_139_pd,
		v_8_curr_intrnl_cred_rating,
		v_10_ifrs9_pd,
		--V_11_PD_OTHERS,
		v_185_dflt_status,
		v_186_dflt_status_date
	)
SELECT 	v_2_counterparty_id,
        v_139_pd,
        v_8_curr_intrnl_cred_rating,
        v_10_ifrs9_pd,
        v_185_dflt_status,
        v_186_dflt_status_date
FROM 	bu_captools_work.vds_tmp_naturalp_counterparties;



INSERT INTO bu_captools_work.vds_out_naturalp_protections
(
	v_12_protection_id,
	v_219_protection_provider_id,
	v_187_collateral_type,
	v_1_instrument_id,
	v_16_property_postcode,
	v_188_protect_value_date,
	v_220_protect_value,
	v_189_protect_maturity_date,
	v_190_orig_protect_value,
	v_191_orig_protect_value_date,
	v_192_protect_value_type,
	v_221_protect_valuation_apprch,
	v_193_protect_alloc_value,
	v_194_third_party_prrty_claims
)
SELECT	v_12_protection_id,
        v_219_protection_provider_id,
        v_187_collateral_type,
        v_1_instrument_id,
        v_16_property_postcode,
        v_188_protect_value_date,
        v_220_protect_value,
        v_189_protect_maturity_date,
        v_190_orig_protect_value,
        v_191_orig_protect_value_date,
        v_192_protect_value_type,
        v_221_protect_valuation_apprch,
        v_193_protect_alloc_value,
        v_194_third_party_prrty_claims
FROM	bu_captools_work.vds_tmp_naturalp_protections;



--OFF BALANCE SHEET EXPOSURES
INSERT INTO bu_captools_work.vds_out_offbal_instruments
(
	v_1_instrument_id,
	v_2_counterparty_id,
	v_139_report_data_id,
	v_140_observed_agnt_id,
	v_3_crr_expo_class,
	v_4_finrep_expo_class,
	v_141_contract_id,
	v_23_cff,
	v_5_total_risk_expo_amnt,
	v_6_lgd,
	v_7_ifrs9_lgd,
	v_223_nominal_amnt,
	v_224_maturity_date,
	v_225_nominal_interest_rate,
	v_158_dflt_status,
	v_159_dflt_status_date,
	v_162_past_due_date,
	v_167_joint_liabilities_amnt,
	v_171_impairment_accumltd_amnt,
	v_172_impairment_type,
	v_173_impairment_assmnt_method,
	v_175_performing_status,
	v_176_performing_status_date,
	v_178_forbearance_status,
	v_179_forbearance_status_date
)
SELECT	v_1_instrument_id,
        v_2_counterparty_id,
        v_139_report_data_id,
        v_140_observed_agnt_id,
        v_3_crr_expo_class,
        v_4_finrep_expo_class,
        v_141_contract_id,
        v_23_cff,
        v_5_total_risk_expo_amnt,
        v_6_lgd,
        v_7_ifrs9_lgd,
        v_223_nominal_amnt,
        v_224_maturity_date,
        v_225_nominal_interest_rate,
        v_158_dflt_status,
        v_159_dflt_status_date,
        v_162_past_due_date,
        v_167_joint_liabilities_amnt,
        v_171_impairment_accumltd_amnt,
        v_172_impairment_type,
        v_173_impairment_assmnt_method,
        v_175_performing_status,
        v_176_performing_status_date,
        v_178_forbearance_status,
        v_179_forbearance_status_date
FROM	bu_captools_work.vds_tmp_offbal_instruments;



INSERT INTO bu_captools_work.vds_out_offbal_counterparties
(
	v_2_counterparty_id,
	v_8_curr_intrnl_cred_rating,
	v_9_ext_cred_rating,
	v_10_ifrs9_pd,
	--V_11_PD_OTHERS,
	v_185_dflt_status,
	v_195_lei,
	v_186_dflt_status_date,
	v_196_national_id,
	v_200_name,
	v_206_legal_form,
	v_207_institutional_sector,
	v_208_economic_activity,
	v_209_legal_prcdngs_status,
	v_210_legal_prcdngs_status_date,
	v_211_enterprise_size,
	v_212_enterprise_size_date,
	v_213_number_employees,
	v_214_balance_sheet_total,
	v_215_annual_turnover,
	v_216_accounting_standard
)
SELECT 	v_2_counterparty_id,
        v_8_curr_intrnl_cred_rating,
        v_9_ext_cred_rating,
        v_10_ifrs9_pd,
        --V_11_PD_OTHERS,
        v_185_dflt_status,
        v_195_lei,
        v_186_dflt_status_date,
        v_196_national_id,
        v_200_name,
        v_206_legal_form,
        v_207_institutional_sector,
        v_208_economic_activity,
        v_209_legal_prcdngs_status,
        v_210_legal_prcdngs_status_date,
        v_211_enterprise_size,
        v_212_enterprise_size_date,
        v_213_number_employees,
        v_214_balance_sheet_total,
        v_215_annual_turnover,
        v_216_accounting_standard
FROM 	bu_captools_work.vds_tmp_offbal_counterparties;


INSERT INTO bu_captools_work.vds_out_offbal_protections
(
	v_12_protection_id,
	v_1_instrument_id,
	v_219_protection_provider_id,
	v_187_collateral_type,
	v_16_property_postcode,
	v_188_protect_value_date,
	v_220_protect_value,
	v_189_protect_maturity_date,
	v_190_orig_protect_value,
	v_191_orig_protect_value_date,
	v_192_protect_value_type,
	v_221_protect_valuation_apprch,
	v_217_protect_alloc_value,
	v_218_third_party_prrty_claims
)
SELECT	v_12_protection_id,
        v_1_instrument_id,
        v_219_protection_provider_id,
        v_187_collateral_type,
        v_16_property_postcode,
        v_188_protect_value_date,
        v_220_protect_value,
        v_189_protect_maturity_date,
        v_190_orig_protect_value,
        v_191_orig_protect_value_date,
        v_192_protect_value_type,
        v_221_protect_valuation_apprch,
        v_217_protect_alloc_value,
        v_218_third_party_prrty_claims
FROM	bu_captools_work.vds_tmp_offbal_protections;



INSERT INTO bu_captools_work.vds_out_derivatives
(
	v_140_unique_trade_id,
	v_2_counterparty_id,
	v_27_product_id,
	--V_28_GOVERNING_LAW,
	v_43_leg1_ref_rate,
	v_44_leg2_ref_rate,
	v_45_leg1_ref_period,
	v_46_leg2_ref_period,
	--V_49_PREMIUM,
	v_51_netting_agreement,
	v_52_carrying_amnt,
	v_53_accounting_standards,
	v_54_accounting_classification,
	--V_55_HIERARCHY, SEM FONTE
	v_56_hedge_id,
	v_5_total_risk_expo_amnt
)
SELECT	v_140_unique_trade_id,
        v_2_counterparty_id,
        v_27_product_id,
        --V_28_GOVERNING_LAW,
        v_43_leg1_ref_rate,
        v_44_leg2_ref_rate,
        v_45_leg1_ref_period,
        v_46_leg2_ref_period,
        --V_49_PREMIUM,
        v_51_netting_agreement,
        v_52_carrying_amnt,
        v_53_accounting_standards,
        v_54_accounting_classification,
        --V_55_HIERARCHY, SEM FONTE
        v_56_hedge_id,
        v_5_total_risk_expo_amnt
FROM	bu_captools_work.vds_tmp_derivatives;



INSERT INTO bu_captools_work.vds_out_debt_securities
(
	v_58_financial_contract_id,
	v_59_isin,
	v_60_issuer_id,
	v_62_country_issuer,
	v_63_issuer_esa,
	v_64_issuer_nace,
	v_65_issuer_rating,
	v_67_issuer_type,
	v_68_currency,
	v_69_valuation_timestamp,
	v_70_valuation_type,
	v_71_inst_class,
	v_72_primary_asset_class,
	v_73_asset_securit_class,
	v_74_placement_type,
	v_75_issuance_date,
	v_76_maturity_date,
	v_77_guarantor_id,
	v_80_type_inst_seniority,
	v_81_coupon_type,
	v_82_coupon_freq,
	v_83_coupon_currency,
	v_84_coupon_rate,
	v_85_reference_rate,
	v_86_spread,
	v_87_currency_nominal_amnt,
	v_88_purchase_under_resale,
	v_89_encumbrance_sources,
	v_90_eligibility_ecb_ops,
	v_91_lcr_buffer,
	v_92_lcr_buffer_category,
	v_93_accounting_classification,
	v_94_performing_status,
	v_95_prudential_portfolio,
	v_96_hedge_id,
	v_5_total_risk_expo_amnt
)
SELECT	v_58_financial_contract_id,
        v_59_isin,
        v_60_issuer_id,
        v_62_country_issuer,
        v_63_issuer_esa,
        v_64_issuer_nace,
        v_65_issuer_rating,
        v_67_issuer_type,
        v_68_currency,
        v_69_valuation_timestamp,
        v_70_valuation_type,
        v_71_inst_class,
        v_72_primary_asset_class,
        v_73_asset_securit_class,
        v_74_placement_type,
        v_75_issuance_date,
        v_76_maturity_date,
        v_77_guarantor_id,
        v_80_type_inst_seniority,
        v_81_coupon_type,
        v_82_coupon_freq,
        v_83_coupon_currency,
        v_84_coupon_rate,
        v_85_reference_rate,
        v_86_spread,
        v_87_currency_nominal_amnt,
        v_88_purchase_under_resale,
        v_89_encumbrance_sources,
        v_90_eligibility_ecb_ops,
        v_91_lcr_buffer,
        v_92_lcr_buffer_category,
        v_93_accounting_classification,
        v_94_performing_status,
        v_95_prudential_portfolio,
        v_96_hedge_id,
        v_5_total_risk_expo_amnt
FROM	bu_captools_work.vds_tmp_debt_securities;



INSERT INTO bu_captools_work.vds_out_equity_instruments
(
	v_58_financial_contract_id,
	v_59_isin,
	v_60_issuer_id,
	v_62_country_issuer,
	v_63_issuer_esa,
	v_64_issuer_nace,
	v_65_issuer_rating,
	v_67_issuer_type,
	v_68_currency,
	v_69_valuation_timestamp,
	v_70_valuation_type,
	v_91_lcr_buffer,
	v_93_accounting_classification,
	v_95_prudential_portfolio,
	v_5_total_risk_expo_amnt
)
SELECT	v_58_financial_contract_id,
        v_59_isin,
        v_60_issuer_id,
        v_62_country_issuer,
        v_63_issuer_esa,
        v_64_issuer_nace,
        v_65_issuer_rating,
        v_67_issuer_type,
        v_68_currency,
        v_69_valuation_timestamp,
        v_70_valuation_type,
        v_91_lcr_buffer,
        v_93_accounting_classification,
        v_95_prudential_portfolio,
        v_5_total_risk_expo_amnt
FROM	bu_captools_work.vds_tmp_equity_instruments;


create table bu_captools_work.config_pk
		(
  		libname STRING COMMENT "libname",
  		memname  STRING COMMENT "memname",
  		name 	VSTRING COMMENT "name",
  		idxusage STRING COMMENT "IDXUSAGE"
		);



create table bu_captools_work.data_quality_check_foreign_key
	(
  	parent_library_name STRING COMMENT "Parent Library Name",
  	parent_entity_name STRING COMMENT "Parent Entity Name",
  	parent_attribute_name	STRING COMMENT "Parent Attribute Name",
  	child_library_name	STRING COMMENT "Child Library Name",
  	child_entity_name STRING COMMENT "Child Entity Name",
  	child_attribute_name	STRING COMMENT "Child Attribute Name"
	);
s


create table bu_captools_work.data_quality_check
	(
  	library_nm STRING,
  	table_nm STRING,
  	column_nm STRING,
  	failure_check_txt STRING,
  	error_message_txt STRING,
  	group_id STRING
	);


delete * from bu_captools_work.config_pk;
insert into bu_captools_work.config_pk
		values ("bu_captools_work","vds_out_legalp_instruments","v_1_instrument_id","composite")
		values ("bu_captools_work","vds_out_legalp_instruments","v_2_counterparty_id","composite")
		values ("bu_captools_work","vds_out_legalp_counterparties","v_2_counterparty_id","simple")
		values ("bu_captools_work","vds_out_legalp_protections","v_12_protection_id","composite")
		values ("bu_captools_work","vds_out_legalp_protections","v_1_instrument_id","composite")
		values ("bu_captools_work","vds_out_naturalp_instruments","v_1_instrument_id","composite")
		values ("bu_captools_work","vds_out_naturalp_instruments","v_2_counterparty_id","composite")
		values ("bu_captools_work","vds_out_naturalp_instruments","v_139_report_data_id","composite")
		values ("bu_captools_work","vds_out_naturalp_instruments","v_140_observed_agnt_id","composite")
		values ("bu_captools_work","vds_out_naturalp_instruments","v_141_contract_id","composite")
		values ("bu_captools_work","vds_out_naturalp_counterparties","v_2_counterparty_id","simple")
		values ("bu_captools_work","vds_out_naturalp_protections","v_12_protection_id","composite")
		values ("bu_captools_work","vds_out_naturalp_protections","v_219_protection_provider_id","composite")
		values ("bu_captools_work","vds_out_naturalp_protections","v_1_instrument_id","composite")
		values ("bu_captools_work","vds_out_offbal_instruments","v_1_instrument_id","composite")
		values ("bu_captools_work","vds_out_offbal_instruments","v_2_counterparty_id","composite")
		values ("bu_captools_work","vds_out_offbal_instruments","v_141_contract_id","composite")
		values ("bu_captools_work","vds_out_offbal_instruments","v_139_report_data_id","composite")
		values ("bu_captools_work","vds_out_offbal_instruments","v_140_observed_agnt_id","composite")
		values ("bu_captools_work","vds_out_offbal_counterparties","v_2_counterparty_id","simple")
		values ("bu_captools_work","vds_out_offbal_protections","v_12_protection_id","composite")
		values ("bu_captools_work","vds_out_offbal_protections","v_219_protection_provider_id","composite")
		values ("bu_captools_work","vds_out_offbal_protections","v_1_instrument_id","composite")
		values ("bu_captools_work","vds_out_derivatives","v_2_counterparty_id","composite")
		values ("bu_captools_work","vds_out_derivatives","v_140_unique_trade_id","composite")
		values ("bu_captools_work","vds_out_debt_securities","v_58_financial_contract_id","simple")
		values ("bu_captools_work","vds_out_equity_instruments","v_58_financial_contract_id","simple")
		values ("bu_captools_work","vds_out_dtas","v_115_asset_id","simple")
		values ("bu_captools_work","vds_out_intangible_assets","v_115_asset_id","simple")
		values ("bu_captools_work","vds_out_goodwill","v_128_asset_id","simple");


--- child é a estrangeira ?
--- ligar legalp instruments À naturalp e offbal? (o mesmo pras restantes tabelas?)

delete * from bu_captools_work.data_quality_check_foreign_key;
insert into bu_captools_work.data_quality_check_foreign_key     --Alterei VDSOUT por bu_captools_work e eleiminei um trouço de código que estava comentado
	values ("bu_captools_work","vds_out_legalp_instruments","v_2_counterparty_id","bu_captools_work","vds_out_legalp_counterparties","v_2_counterparty_id")
	values ("bu_captools_work","vds_out_legalp_instruments","v_12_protection_id","bu_captools_work","vds_out_legalp_protections","v_12_protection_id")
	--acrescentar v2 e v12 para as naturalp/offbal counterparties/protections
	values ("bu_captools_work","vds_out_legalp_protections","v_1_instrument_id","bu_captools_work","vds_out_legalp_instruments","v_1_instrument_id")
	values ("bu_captools_work","vds_out_naturalp_instruments","v_2_counterparty_id","bu_captools_work","vds_out_naturalp_counterparties","v_2_counterparty_id")
	values ("bu_captools_work","vds_out_naturalp_instruments","v_12_protection_id","bu_captools_work","vds_out_naturalp_protections","v_12_protection_id")
	values ("bu_captools_work","vds_out_naturalp_protections","v_1_instrument_id","bu_captools_work","vds_out_naturalp_instruments","v_1_instrument_id")
	values ("bu_captools_work","vds_out_offbal_instruments","v_2_counterparty_id","bu_captools_work","vds_out_offbal_counterparties","v_2_counterparty_id")
	values ("bu_captools_work","vds_out_offbal_instruments","v_12_protection_id","bu_captools_work","vds_out_offbal_protections","v_12_protection_id")
	values ("bu_captools_work","vds_out_offbal_protections","v_1_instrument_id","bu_captools_work","vds_out_offbal_instruments","v_1_instrument_id");

		  --derivatives(V_140_UNIQUE_TRADE_ID,  v_2_counterparty_id)
		  --debt securities (V_58_FINANCIAL_CONTRACT_ID)
		  --equity (V_58_FINANCIAL_CONTRACT_ID)


delete * from bu_captools_work.data_quality_check;
insert into bu_captools_work.data_quality_check
  values ("bu_captools_work","VDS_OUT_LEGALP_INSTRUMENTS","V_3_CRR_EXPO_CLASS",'V_3_CRR_EXPO_CLASS not in ("Central governments or central banks (SCENGOV)", "Regional governments or local authorities (SREGGOV)","Public sector entities (SPUBSEC)","Multilateral development banks (SDEVBAN)","International organisation (SINTORG)","Institutions (SINSTIT)","Corporates (SCORPOR)","Retail (SRETAIL)","Secured by mortgages and immovable property (SSECMOR)","Defaulted (SDEFAUL)","High risk (SHIGHRI)","Covered bonds (SCOVBON)","Items representing securitisation positions","Institutions and corporates with a short term credit assessment (SSHOTER)","Collective investment undertakings (SCOLINV)","Equity (SEQUITY)","Other (SOTHERI)","Central governments and central banks (ICENGOV)","Institutions (IINSTIT)","Corporates (ICORPOR)", "Retail (IRETAIL)", "Equity (IEQUITY)", "Items representing securitisation positions", "Other non credit-obligation assets (IOTHERC)")',"V_3_CRR_EXPO_CLASS must be one of (Central governments or central banks (SCENGOV), Regional governments or local authorities (SREGGOV),Public sector entities (SPUBSEC),Multilateral development banks (SDEVBAN),International organisation (SINTORG),Institutions (SINSTIT),Corporates (SCORPOR),Retail (SRETAIL),Secured by mortgages and immovable property (SSECMOR),Defaulted (SDEFAUL),High risk (SHIGHRI),Covered bonds (SCOVBON),Items representing securitisation positions,Institutions and corporates with a short term credit assessment (SSHOTER),Collective investment undertakings (SCOLINV),Equity (SEQUITY),Other (SOTHERI),Central governments and central banks (ICENGOV),Institutions (IINSTIT),Corporates (ICORPOR), Retail (IRETAIL), Equity (IEQUITY), Items representing securitisation positions, Other non credit-obligation assets (IOTHERC))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_3_CRR_EXPO_CLASS",'V_3_CRR_EXPO_CLASS not in ("Central governments or central banks (SCENGOV)", "Regional governments or local authorities (SREGGOV)","Public sector entities (SPUBSEC)","Multilateral development banks (SDEVBAN)","International organisation (SINTORG)","Institutions (SINSTIT)","Corporates (SCORPOR)","Retail (SRETAIL)","Secured by mortgages and immovable property (SSECMOR)","Defaulted (SDEFAUL)","High risk (SHIGHRI)","Covered bonds (SCOVBON)","Items representing securitisation positions","Institutions and corporates with a short term credit assessment (SSHOTER)","Collective investment undertakings (SCOLINV)","Equity (SEQUITY)","Other (SOTHERI)","Central governments and central banks (ICENGOV)","Institutions (IINSTIT)","Corporates (ICORPOR)", "Retail (IRETAIL)", "Equity (IEQUITY)", "Items representing securitisation positions", "Other non credit-obligation assets (IOTHERC)")',"V_3_CRR_EXPO_CLASS must be one of (Central governments or central banks (SCENGOV), Regional governments or local authorities (SREGGOV),Public sector entities (SPUBSEC),Multilateral development banks (SDEVBAN),International organisation (SINTORG),Institutions (SINSTIT),Corporates (SCORPOR),Retail (SRETAIL),Secured by mortgages and immovable property (SSECMOR),Defaulted (SDEFAUL),High risk (SHIGHRI),Covered bonds (SCOVBON),Items representing securitisation positions,Institutions and corporates with a short term credit assessment (SSHOTER),Collective investment undertakings (SCOLINV),Equity (SEQUITY),Other (SOTHERI),Central governments and central banks (ICENGOV),Institutions (IINSTIT),Corporates (ICORPOR), Retail (IRETAIL), Equity (IEQUITY), Items representing securitisation positions, Other non credit-obligation assets (IOTHERC))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_3_CRR_EXPO_CLASS",'V_3_CRR_EXPO_CLASS not in ("Central governments or central banks (SCENGOV)", "Regional governments or local authorities (SREGGOV)","Public sector entities (SPUBSEC)","Multilateral development banks (SDEVBAN)","International organisation (SINTORG)","Institutions (SINSTIT)","Corporates (SCORPOR)","Retail (SRETAIL)","Secured by mortgages and immovable property (SSECMOR)","Defaulted (SDEFAUL)","High risk (SHIGHRI)","Covered bonds (SCOVBON)","Items representing securitisation positions","Institutions and corporates with a short term credit assessment (SSHOTER)","Collective investment undertakings (SCOLINV)","Equity (SEQUITY)","Other (SOTHERI)","Central governments and central banks (ICENGOV)","Institutions (IINSTIT)","Corporates (ICORPOR)", "Retail (IRETAIL)", "Equity (IEQUITY)", "Items representing securitisation positions", "Other non credit-obligation assets (IOTHERC)")',"V_3_CRR_EXPO_CLASS must be one of (Central governments or central banks (SCENGOV), Regional governments or local authorities (SREGGOV),Public sector entities (SPUBSEC),Multilateral development banks (SDEVBAN),International organisation (SINTORG),Institutions (SINSTIT),Corporates (SCORPOR),Retail (SRETAIL),Secured by mortgages and immovable property (SSECMOR),Defaulted (SDEFAUL),High risk (SHIGHRI),Covered bonds (SCOVBON),Items representing securitisation positions,Institutions and corporates with a short term credit assessment (SSHOTER),Collective investment undertakings (SCOLINV),Equity (SEQUITY),Other (SOTHERI),Central governments and central banks (ICENGOV),Institutions (IINSTIT),Corporates (ICORPOR), Retail (IRETAIL), Equity (IEQUITY), Items representing securitisation positions, Other non credit-obligation assets (IOTHERC))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_LEGALP_INSTRUMENTS","V_4_FINREP_EXPO_CLASS ",'V_4_FINREP_EXPO_CLASS not in ("Central banks","Central governments","Credit institutions","Other financial corporations","Non-financial corporations","Households")',"V_4_FINREP_EXPO_CLASS must be on  (Central banks,Central governments,Credit institutions,Other financial corporations,Non-financial corporations,Households)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_4_FINREP_EXPO_CLASS ",'V_4_FINREP_EXPO_CLASS not in ("Central banks","Central governments","Credit institutions","Other financial corporations","Non-financial corporations","Households")',"V_4_FINREP_EXPO_CLASS must be on  (Central banks,Central governments,Credit institutions,Other financial corporations,Non-financial corporations,Households)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_4_FINREP_EXPO_CLASS ",'V_4_FINREP_EXPO_CLASS not in ("Central banks","Central governments","Credit institutions","Other financial corporations","Non-financial corporations","Households")',"V_4_FINREP_EXPO_CLASS must be on  (Central banks,Central governments,Credit institutions,Other financial corporations,Non-financial corporations,Households)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_LEGALP_INSTRUMENTS","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT lt 0',"V_5_TOTAL_RISK_EXPO_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT lt 0',"V_5_TOTAL_RISK_EXPO_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT lt 0',"V_5_TOTAL_RISK_EXPO_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT lt 0',"V_5_TOTAL_RISK_EXPO_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT lt 0',"V_5_TOTAL_RISK_EXPO_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT lt 0',"V_5_TOTAL_RISK_EXPO_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT lt 0',"V_5_TOTAL_RISK_EXPO_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_152_COMMITMENT_INCEPTION_AMNT",'V_152_COMMITMENT_INCEPTION_AMNT lt 0',"V_152_COMMITMENT_INCEPTION_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_LEGALP_INSTRUMENTS","V_6_LGD",'V_6_LGD lt 0 or V_6_LGD gt 1',"V_6_LGD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_6_LGD",'V_6_LGD lt 0 or V_6_LGD gt 1',"V_6_LGD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_6_LGD",'V_6_LGD lt 0 or V_6_LGD gt 1',"V_6_LGD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_LEGALP_INSTRUMENTS","V_7_IFRS9_LGD",'V_7_IFRS9_LGD lt 0 or V_7_IFRS9_LGD gt 1',"V_7_IFRS9_LGD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_7_IFRS9_LGD",'V_7_IFRS9_LGD lt 0 or V_7_IFRS9_LGD gt 1',"V_7_IFRS9_LGD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_7_IFRS9_LGD",'V_7_IFRS9_LGD lt 0 or V_7_IFRS9_LGD gt 1',"V_7_IFRS9_LGD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_LEGALP_COUNTERPARTIES","V_10_IFRS9_PD",'V_10_IFRS9_PD lt 0 or V_10_IFRS9_PD gt 1',"V_10_IFRS9_PD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_COUNTERPARTIES","V_10_IFRS9_PD",'V_10_IFRS9_PD lt 0 or V_10_IFRS9_PD gt 1',"V_10_IFRS9_PD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_10_IFRS9_PD",'V_10_IFRS9_PD lt 0 or V_10_IFRS9_PD gt 1',"V_10_IFRS9_PD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_LEGALP_COUNTERPARTIES","V_11_PD",'V_11_PD lt 0 or V_11_PD gt 1',"V_11_PD should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_COUNTERPARTIES","V_11_PD_OTHERS ",'V_11_PD_OTHERS  lt 0 or V_11_PD_OTHERS gt 1',"V_11_PD_OTHERS  should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_11_PD_OTHERS ",'V_11_PD_OTHERS  lt 0 or V_11_PD_OTHERS gt 1',"V_11_PD_OTHERS  should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_159_DFLT_STATUS_DATE",'missing(V_159_DFLT_STATUS_DATE) or missing("&MCR_REF_DATE") or (not missing(&MCR_REF_DATE) and V_159_DFLT_STATUS_DATE > "&MCR_REF_DATE") or V_159_DFLT_STATUS_DATE < "01JAN1900"d',"V_159_DFLT_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_159_DFLT_STATUS_DATE",'missing(V_159_DFLT_STATUS_DATE) or missing("&MCR_REF_DATE") or (not missing(&MCR_REF_DATE) and V_159_DFLT_STATUS_DATE > "&MCR_REF_DATE") or V_159_DFLT_STATUS_DATE < "01JAN1900"d',"V_159_DFLT_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_162_PAST_DUE_DATE",'missing(V_162_PAST_DUE_DATE) or missing(&MCR_REF_DATE) or (not missing(&MCR_REF_DATE) and V_162_PAST_DUE_DATE > &MCR_REF_DATE) or V_162_PAST_DUE_DATE < "01JAN1900"d',"V_162_PAST_DUE_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_162_PAST_DUE_DATE",'missing(V_162_PAST_DUE_DATE) or missing(&MCR_REF_DATE) or (not missing(&MCR_REF_DATE) and V_162_PAST_DUE_DATE > &MCR_REF_DATE) or V_162_PAST_DUE_DATE < "01JAN1900"d',"V_162_PAST_DUE_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_161_ARREARS",'V_161_ARREARS lt 0',"V_161_ARREARS should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_161_ARREARS",'V_161_ARREARS lt 0',"V_161_ARREARS should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_164_OUTSTANDING_NOMINAL_AMNT",'V_164_OUTSTANDING_NOMINAL_AMNT lt 0',"V_164_OUTSTANDING_NOMINAL_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_165_ACCRUED_INTEREST",'V_165_ACCRUED_INTEREST lt 0',"V_165_ACCRUED_INTEREST should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_166_OFF_BALANCE_SHEET_AMNT",'V_166_OFF_BALANCE_SHEET_AMNT lt 0',"V_166_OFF_BALANCE_SHEET_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_167_JOINT_LIABILITIES_AMNT",'V_167_JOINT_LIABILITIES_AMNT lt 0',"V_167_JOINT_LIABILITIES_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_167_JOINT_LIABILITIES_AMNT",'V_167_JOINT_LIABILITIES_AMNT lt 0',"V_167_JOINT_LIABILITIES_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_170_ACCUMLTD_WRITE_OFFS",'V_170_ACCUMLTD_WRITE_OFFS lt 0',"V_170_ACCUMLTD_WRITE_OFFS should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_171_IMPAIRMENT_ACCUMLTD_AMNT",'V_171_IMPAIRMENT_ACCUMLTD_AMNT lt 0',"V_171_IMPAIRMENT_ACCUMLTD_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_171_IMPAIRMENT_ACCUMLTD_AMNT",'V_171_IMPAIRMENT_ACCUMLTD_AMNT lt 0',"V_171_IMPAIRMENT_ACCUMLTD_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_177_PROVISIONS_OFFBAL",'V_177_PROVISIONS_OFFBAL lt 0',"V_177_PROVISIONS_OFFBAL should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_176_PERFORMING_STATUS_DATE",'missing(V_176_PERFORMING_STATUS_DATE) or missing(&MCR_REF_DATE) or (not missing(&MCR_REF_DATE) and V_176_PERFORMING_STATUS_DATE > &MCR_REF_DATE) or V_176_PERFORMING_STATUS_DATE < "01JAN1900"d',"V_176_PERFORMING_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_176_PERFORMING_STATUS_DATE",'missing(V_176_PERFORMING_STATUS_DATE) or missing(&MCR_REF_DATE) or (not missing(&MCR_REF_DATE) and V_176_PERFORMING_STATUS_DATE > &MCR_REF_DATE) or V_176_PERFORMING_STATUS_DATE < "01JAN1900"d',"V_176_PERFORMING_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_179_FORBEARANCE_STATUS_DATE",'missing(V_179_FORBEARANCE_STATUS_DATE) or missing(&MCR_REF_DATE) or (not missing(&MCR_REF_DATE) and V_179_FORBEARANCE_STATUS_DATE > &MCR_REF_DATE) or V_179_FORBEARANCE_STATUS_DATE < "01JAN1900"d',"V_179_FORBEARANCE_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_179_FORBEARANCE_STATUS_DATE",'missing(V_179_FORBEARANCE_STATUS_DATE) or missing(&MCR_REF_DATE) or (not missing(&MCR_REF_DATE) and V_179_FORBEARANCE_STATUS_DATE > &MCR_REF_DATE) or V_179_FORBEARANCE_STATUS_DATE < "01JAN1900"d',"V_179_FORBEARANCE_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_163_SECURITIZATION_TYPE",'V_163_SECURITIZATION_TYPE not in ("Traditional securitisation", "Synthetic securitisation", "Not securitised")',"V_163_SECURITIZATION_TYPE must be one of (Traditional securitisation, Synthetic securitisation, Not securitised)", "STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_217_PROTECT_ALLOC_VALUE",'V_217_PROTECT_ALLOC_VALUE lt 0',"V_217_PROTECT_ALLOC_VALUE should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_218_THIRD_PARTY_PRRTY_CLAIMS",'V_218_THIRD_PARTY_PRRTY_CLAIMS lt 0',"V_218_THIRD_PARTY_PRRTY_CLAIMS should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_33_COLLATERAL_POSTED",'V_33_COLLATERAL_POSTED lt 0',"V_33_COLLATERAL_POSTED should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_37_COLLATERAL_RECEIVED",'V_37_COLLATERAL_RECEIVED lt 0',"V_37_COLLATERAL_RECEIVED should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_41_LEG1_CASHFLOW",'V_41_LEG1_CASHFLOW lt 0',"V_41_LEG1_CASHFLOW should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_42_LEG2_CASHFLOW",'V_42_LEG2_CASHFLOW lt 0',"V_42_LEG2_CASHFLOW should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_43_LEG1_REF_RATE",'V_43_LEG1_REF_RATE lt 0 or V_43_LEG1_REF_RATE gt 1',"V_43_LEG1_REF_RATE should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_44_LEG2_REF_RATE",'V_44_LEG2_REF_RATE lt 0 or V_43_LEG1_REF_RATE gt 1',"V_44_LEG2_REF_RATE should be between 0 and 1","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_49_PREMIUM",'V_49_PREMIUM lt 0',"V_49_PREMIUM should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_52_CARRYING_AMNT",'V_52_CARRYING_AMNT lt 0',"V_52_CARRYING_AMNT should be >= 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_29_WRITEDOWN_CONVERSION",'V_29_WRITEDOWN_CONVERSION not in ("YES","NO")',"V_29_WRITEDOWN_CONVERSION must be on YES or NO","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_45_LEG1_REF_PERIOD",'V_45_LEG1_REF_PERIOD not in ("1d", "1w", "1M", "3M", "6M", "12M", "2Y", "3Y")',"V_45_LEG1_REF_PERIOD must be one of (1d, 1w, 1M, 3M, 6M, 12M, 2Y, 3Y)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_46_LEG2_REF_PERIOD",'V_46_LEG2_REF_PERIOD not in ("1d", "1w", "1M", "3M", "6M", "12M", "2Y", "3Y")',"V_46_LEG2_REF_PERIOD must be one of (1d, 1w, 1M, 3M, 6M, 12M, 2Y, 3Y)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_53_ACCOUNTING_STANDARDS",'V_53_ACCOUNTING_STANDARDS not in ("IFRS","National GAAP")',"V_53_ACCOUNTING_STANDARDS must be on (IFRS,National GAAP)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_163_SECURITIZATION_TYPE",'V_163_SECURITIZATION_TYPE not in ("Traditional securitisation", "Synthetic securitisation", "Not securitised")',"V_163_SECURITIZATION_TYPE must be on (Traditional securitisation, Synthetic securitisation, Not securitised)","STRING LIMITED CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_168_ACCOUNTING_CLASSIFICATION",'V_168_ACCOUNTING_CLASSIFICATION not in ("Cash balances at central banks and other demand deposits (IFRS)","Financial assets held for trading (IFRS)","Non-trading financial assets mandatorily at fair value through profit or loss (IFRS)","Financial assets designated at fair value through profit or loss (IFRS)","Financial assets at fair value through other comprehensive income (IFRS)","Financial assets at amortised cost (IFRS)","Cash balances at central banks and other demand deposits (GAAP)","Trading Financial assets (GAAP)","Non-trading non-derivative financial assets measured at fair value through profit or loss (GAAP)","Non-trading non-derivative financial assets measured at fair value to equity (GAAP)","Non-trading debt instruments measured at a cost-based method (GAAP)","Other non-trading non-derivative financial assets (GAAP)","Cash balances at central banks and other demand deposits (GAAP)","Financial assets held for trading (GAAP)","Financial assets designated at fair value through profit or loss (GAAP)","Available-for-sale financial assets (GAAP)","Loans and receivables (GAAP)","Held-to-maturity investments (GAAP)")',"V_168_ACCOUNTING_CLASSIFICATION must be on (Cash balances at central banks and other demand deposits (IFRS),Financial assets held for trading (IFRS),Non-trading financial assets mandatorily at fair value through profit or loss (IFRS),Financial assets designated at fair value through profit or loss (IFRS),Financial assets at fair value through other comprehensive income (IFRS),Financial assets at amortised cost (IFRS),Cash balances at central banks and other demand deposits (GAAP),Trading Financial assets (GAAP),Non-trading non-derivative financial assets measured at fair value through profit or loss (GAAP),Non-trading non-derivative financial assets measured at fair value to equity (GAAP),Non-trading debt instruments measured at a cost-based method (GAAP),Other non-trading non-derivative financial assets (GAAP),Cash balances at central banks and other demand deposits (GAAP),Financial assets held for trading (GAAP),Financial assets designated at fair value through profit or loss (GAAP),Available-for-sale financial assets (GAAP),Loans and receivables (GAAP),Held-to-maturity investments (GAAP))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_169_BALANCE_SHEET_RECOGNITION",'V_169_BALANCE_SHEET_RECOGNITION not in ("Entirely recognised", "Recognised to the extent of the institution’s continuing involvement", "Entirely derecognised")',"V_169_BALANCE_SHEET_RECOGNITION must be on (Entirely recognised, Recognised to the extent of the institution’s continuing involvement, Entirely derecognised)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_172_IMPAIRMENT_TYPE",'V_172_IMPAIRMENT_TYPE not in ("Stage 1 (IFRS)","Stage 2 (IFRS)","Stage 3 (IFRS)","General allowances (GAAP)","Specific allowances (GAAP)")',"V_172_IMPAIRMENT_TYPE must be on (Stage 1 (IFRS),Stage 2 (IFRS),Stage 3 (IFRS),General allowances (GAAP),Specific allowances (GAAP))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_172_IMPAIRMENT_TYPE",'V_172_IMPAIRMENT_TYPE not in ("Stage 1 (IFRS)","Stage 2 (IFRS)","Stage 3 (IFRS)","General allowances (GAAP)","Specific allowances (GAAP)")',"V_172_IMPAIRMENT_TYPE must be on (Stage 1 (IFRS),Stage 2 (IFRS),Stage 3 (IFRS),General allowances (GAAP),Specific allowances (GAAP))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_173_IMPAIRMENT_ASSMNT_METHOD",'V_173_IMPAIRMENT_ASSMNT_METHOD not in ("Individually assessed","Collectively assessed")',"V_173_IMPAIRMENT_ASSMNT_METHOD must be on (Individually assessed,Collectively assessed)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_173_IMPAIRMENT_ASSMNT_METHOD",'V_173_IMPAIRMENT_ASSMNT_METHOD not in ("Individually assessed","Collectively assessed")',"V_173_IMPAIRMENT_ASSMNT_METHOD must be on (Individually assessed,Collectively assessed)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_174_ENCUMBRANCE_SOURCES",'V_174_ENCUMBRANCE_SOURCES not in ("Central bank funding","Exchange traded derivatives","Over-the-counter derivatives","Deposits – repurchase agreements other than to central banks","Deposits other than repurchase agreements","Debt securities issued – covered bonds securities","Debt securities issued – asset-backed securities" ,"Debt securities issued – other than covered bonds and ABSs","Other sources of encumbrance","No encumbrance")',"V_174_ENCUMBRANCE_SOURCES must be on (Central bank funding,Exchange traded derivatives,Over-the-counter derivatives,Deposits – repurchase agreements other than to central banks,Deposits other than repurchase agreements,Debt securities issued – covered bonds securities,Debt securities issued – asset-backed securities ,Debt securities issued – other than covered bonds and ABSs,Other sources of encumbrance,No encumbrance)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_175_PERFORMING_STATUS",'V_175_PERFORMING_STATUS not in ("Non-performing","Performing")',"V_175_PERFORMING_STATUS must be on (Non-performing,Performing)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_178_FORBEARANCE_STATUS",'V_178_FORBEARANCE_STATUS not in ("Forborne: instruments with modified interest rate below market conditions","Forborne: instruments with other modified terms and conditions","Forborne: totally or partially refinanced debt","Renegotiated instrument without forbearance measures","Not forborne or renegotiated")',"V_178_FORBEARANCE_STATUS must be on (Forborne: instruments with modified interest rate below market conditions,Forborne: instruments with other modified terms and conditions,Forborne: totally or partially refinanced debt,Renegotiated instrument without forbearance measures,Not forborne or renegotiated)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_178_FORBEARANCE_STATUS",'V_178_FORBEARANCE_STATUS not in ("Forborne: instruments with modified interest rate below market conditions","Forborne: instruments with other modified terms and conditions","Forborne: totally or partially refinanced debt","Renegotiated instrument without forbearance measures","Not forborne or renegotiated")',"V_178_FORBEARANCE_STATUS must be on (Forborne: instruments with modified interest rate below market conditions,Forborne: instruments with other modified terms and conditions,Forborne: totally or partially refinanced debt,Renegotiated instrument without forbearance measures,Not forborne or renegotiated)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_54_ACCOUNTING_CLASSIFICATION",'V_54_ACCOUNTING_CLASSIFICATION not in ("Trading book","Non-trading book")',"V_54_ACCOUNTING_CLASSIFICATION must be on (Trading book,Non-trading book)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_55_HIERARCHY",'V_55_HIERARCHY not in ("Level 1","Level 2","Level 3")',"V_55_HIERARCHY must be on (Level 1,Level 2,Level 3)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_61_TYPE_ISSUER_ID",'V_61_TYPE_ISSUER_ID not in ("Other group entity","Third party")',"V_61_TYPE_ISSUER_ID must be on (Other group entity,Third Party)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_61_TYPE_ISSUER_ID",'V_61_TYPE_ISSUER_ID not in ("Other group entity","Third party")',"V_61_TYPE_ISSUER_ID must be on (Other group entity,Third party)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_LEGALP_PROTECTIONS","V_187_COLLATERAL_TYPE",'V_187_COLLATERAL_TYPE not in("Gold", "Currency and deposits", "Securities", "Loans", "Equity and investment fund shares or units", "Credit derivatives", "Financial guarantees other than credit derivatives", "Trade receivables", "Life insurance policies pledged", "Residential real estate collateral", "Offices and commercial premises", "Commercial real estate collateral", "Other physical collateral", "Other protection", "Hotels & Entertainment", "Infrastructure projects", "Factories-warehouses", "Equipment & machinery", "Automotive", "Aircraft", "Shipping")',"V_187_COLLATERAL_TYPE must be one of (Gold, Currency and deposits, Securities, Loans, Equity and investment fund shares or units, Credit derivatives, Financial guarantees other than credit derivatives, Trade receivables, Life insurance policies pledged, Residential real estate collateral, Offices and commercial premises, Commercial real estate collateral, Other physical collateral, Other protection, Hotels & Entertainment, Infrastructure projects, Factories-warehouses, Equipment & machinery, Automotive, Aircraft, Shipping)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_187_COLLATERAL_TYPE",'V_187_COLLATERAL_TYPE not in("Gold", "Currency and deposits", "Securities", "Loans", "Equity and investment fund shares or units", "Credit derivatives", "Financial guarantees other than credit derivatives", "Trade receivables", "Life insurance policies pledged", "Residential real estate collateral", "Offices and commercial premises", "Commercial real estate collateral", "Other physical collateral", "Other protection", "Hotels & Entertainment", "Infrastructure projects", "Factories-warehouses", "Equipment & machinery", "Automotive", "Aircraft", "Shipping")',"V_187_COLLATERAL_TYPE must be one of (Gold, Currency and deposits, Securities, Loans, Equity and investment fund shares or units, Credit derivatives, Financial guarantees other than credit derivatives, Trade receivables, Life insurance policies pledged, Residential real estate collateral, Offices and commercial premises, Commercial real estate collateral, Other physical collateral, Other protection, Hotels & Entertainment, Infrastructure projects, Factories-warehouses, Equipment & machinery, Automotive, Aircraft, Shipping)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_187_COLLATERAL_TYPE",'V_187_COLLATERAL_TYPE not in("Gold", "Currency and deposits", "Securities", "Loans", "Equity and investment fund shares or units", "Credit derivatives", "Financial guarantees other than credit derivatives", "Trade receivables", "Life insurance policies pledged", "Residential real estate collateral", "Offices and commercial premises", "Commercial real estate collateral", "Other physical collateral", "Other protection", "Hotels & Entertainment", "Infrastructure projects", "Factories-warehouses", "Equipment & machinery", "Automotive", "Aircraft", "Shipping")',"V_187_COLLATERAL_TYPE must be one of (Gold, Currency and deposits, Securities, Loans, Equity and investment fund shares or units, Credit derivatives, Financial guarantees other than credit derivatives, Trade receivables, Life insurance policies pledged, Residential real estate collateral, Offices and commercial premises, Commercial real estate collateral, Other physical collateral, Other protection, Hotels & Entertainment, Infrastructure projects, Factories-warehouses, Equipment & machinery, Automotive, Aircraft, Shipping)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_LEGALP_PROTECTIONS","V_14_BUILDING_AREA",'V_14_BUILDING_AREA LT 0',"V_14_BUILDING_AREA must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_14_BUILDING_AREA",'V_14_BUILDING_AREA LT 0',"V_14_BUILDING_AREA must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_LEGALP_PROTECTIONS","V_15_LANDING_AREA",'V_15_LANDING_AREA LT 0',"V_15_LANDING_AREA must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_15_LANDING_AREA",'V_15_LANDING_AREA LT 0',"V_15_LANDING_AREA must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_35_INSTRUMENT_TYPE",'V_35_INSTRUMENT_TYPE not in("Overdraft", "Credit card debt", "Revolving credit card debt other than overdrafts and credit card debts", "Credit lines other than revolving credit", "Financial lease", "Loan", "Other")',"V_35_INSTRUMENT_TYPE must be one of (Overdraft, Credit card debt, Revolving credit card debt other than overdrafts and credit card debts, Credit lines other than revolving credit, Financial lease, Loan, Other)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_142_AMORTIZATION_TYPE",'V_142_AMORTIZATION_TYPE not in("French", "German", "Fixed amortisation schedule", "Bullet", "Other")',"V_142_AMORTIZATION_TYPE must be one of (French, German, Fixed amortisation schedule, Bullet, Other)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_143_CURRENCY", 'V_143_CURRENCY not in("AFN", "EUR", "ALL", "DZD", "USD", "EUR", "AOA", "XCD", "XCD", "ARS", "AMD", "AWG", "AUD", "EUR", "AZN", "BSD", "BHD", "BDT", "BBD", "BYR", "EUR", "BZD", "XOF", "BMD", "BTN", "INR", "BOB", "BOV", "USD", "BAM", "BWP", "NOK", "BRL", "USD", "BND", "BGN", "XOF", "BIF", "KHR", "XAF", "CAD", "CVE", "KYD", "XAF", "XAF", "CLF", "CLP", "CNY", "AUD", "AUD", "COP", "COU", "KMF", "XAF", "CDF", "NZD", "CRC", "XOF", "HRK", "CUC", "CUP", "ANG", "EUR", "CZK", "DKK", "DJF", "XCD", "DOP", "USD", "EGP", "SVC", "USD", "XAF", "ERN", "EUR", "ETB", "EUR", "FKP", "DKK", "FJD", "EUR", "EUR", "EUR", "XPF", "EUR", "XAF", "GMD", "GEL", "EUR", "GHS", "GIP", "EUR", "DKK", "XCD", "EUR", "USD", "GTQ", "GBP", "GNF", "XOF", "GYD", "HTG", "USD", "AUD", "EUR", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "XDR", "IRR", "IQD", "EUR", "GBP", "ILS", "EUR", "JMD", "JPY", "GBP", "JOD", "KZT", "KES", "AUD", "KPW", "KRW", "KWD", "KGS", "LAK", "EUR", "LBP", "LSL", "ZAR", "LRD", "LYD", "CHF", "EUR", "EUR", "MOP", "MKD", "MGA", "MWK", "MYR", "MVR", "XOF", "EUR", "USD", "EUR", "MRO", "MUR", "EUR", "XUA", "MXN", "MXV", "USD", "MDL", "EUR", "MNT", "EUR", "XCD", "MAD", "MZN", "MMK", "NAD", "ZAR", "AUD", "NPR", "EUR", "XPF", "NZD", "NIO", "XOF", "NGN", "NZD", "AUD", "USD", "NOK", "OMR", "PKR", "USD", "PAB", "USD", "PGK", "PYG", "PEN", "PHP", "NZD", "PLN", "EUR", "USD", "QAR", "EUR", "RON", "RUB", "RWF", "EUR", "SHP", "XCD", "XCD", "EUR", "EUR", "XCD", "WST", "EUR", "STD", "SAR", "XOF", "RSD", "SCR", "SLL", "SGD", "ANG", "XSU", "EUR", "EUR", "SBD", "SOS", "ZAR", "SSP", "EUR", "LKR", "SDG", "SRD", "NOK", "SZL", "SEK", "CHE", "CHF", "CHW", "SYP", "TWD", "TJS", "TZS", "THB", "USD", "XOF", "NZD", "TOP", "TTD", "TND", "TRY", "TMT", "USD", "AUD", "UGX", "UAH", "AED", "GBP", "USD", "USN", "USD", "UYI", "UYU", "UZS", "VUV", "VEF", "VND", "USD", "USD", "XPF", "MAD", "YER", "ZMW", "ZWL", "XBA", "XBB", "XBC", "XBD", "XTS", "XXX", "XAU", "XPD", "XPT", "XAG")',"V_143_CURRENCY must be in ISO 4217 code", "STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_34_CURRENCY_COL_POSTED", 'V_34_CURRENCY_COL_POSTED not in("AFN", "EUR", "ALL", "DZD", "USD", "EUR", "AOA", "XCD", "XCD", "ARS", "AMD", "AWG", "AUD", "EUR", "AZN", "BSD", "BHD", "BDT", "BBD", "BYR", "EUR", "BZD", "XOF", "BMD", "BTN", "INR", "BOB", "BOV", "USD", "BAM", "BWP", "NOK", "BRL", "USD", "BND", "BGN", "XOF", "BIF", "KHR", "XAF", "CAD", "CVE", "KYD", "XAF", "XAF", "CLF", "CLP", "CNY", "AUD", "AUD", "COP", "COU", "KMF", "XAF", "CDF", "NZD", "CRC", "XOF", "HRK", "CUC", "CUP", "ANG", "EUR", "CZK", "DKK", "DJF", "XCD", "DOP", "USD", "EGP", "SVC", "USD", "XAF", "ERN", "EUR", "ETB", "EUR", "FKP", "DKK", "FJD", "EUR", "EUR", "EUR", "XPF", "EUR", "XAF", "GMD", "GEL", "EUR", "GHS", "GIP", "EUR", "DKK", "XCD", "EUR", "USD", "GTQ", "GBP", "GNF", "XOF", "GYD", "HTG", "USD", "AUD", "EUR", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "XDR", "IRR", "IQD", "EUR", "GBP", "ILS", "EUR", "JMD", "JPY", "GBP", "JOD", "KZT", "KES", "AUD", "KPW", "KRW", "KWD", "KGS", "LAK", "EUR", "LBP", "LSL", "ZAR", "LRD", "LYD", "CHF", "EUR", "EUR", "MOP", "MKD", "MGA", "MWK", "MYR", "MVR", "XOF", "EUR", "USD", "EUR", "MRO", "MUR", "EUR", "XUA", "MXN", "MXV", "USD", "MDL", "EUR", "MNT", "EUR", "XCD", "MAD", "MZN", "MMK", "NAD", "ZAR", "AUD", "NPR", "EUR", "XPF", "NZD", "NIO", "XOF", "NGN", "NZD", "AUD", "USD", "NOK", "OMR", "PKR", "USD", "PAB", "USD", "PGK", "PYG", "PEN", "PHP", "NZD", "PLN", "EUR", "USD", "QAR", "EUR", "RON", "RUB", "RWF", "EUR", "SHP", "XCD", "XCD", "EUR", "EUR", "XCD", "WST", "EUR", "STD", "SAR", "XOF", "RSD", "SCR", "SLL", "SGD", "ANG", "XSU", "EUR", "EUR", "SBD", "SOS", "ZAR", "SSP", "EUR", "LKR", "SDG", "SRD", "NOK", "SZL", "SEK", "CHE", "CHF", "CHW", "SYP", "TWD", "TJS", "TZS", "THB", "USD", "XOF", "NZD", "TOP", "TTD", "TND", "TRY", "TMT", "USD", "AUD", "UGX", "UAH", "AED", "GBP", "USD", "USN", "USD", "UYI", "UYU", "UZS", "VUV", "VEF", "VND", "USD", "USD", "XPF", "MAD", "YER", "ZMW", "ZWL", "XBA", "XBB", "XBC", "XBD", "XTS", "XXX", "XAU", "XPD", "XPT", "XAG")',"V_34_CURRENCY_COL_POSTED must be in ISO 4217 code", "STRING_LIMITED_CHOICES")
  	values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_38_CURRENCY_COL_RECEIVED", 'V_38_CURRENCY_COL_RECEIVED not in("AFN", "EUR", "ALL", "DZD", "USD", "EUR", "AOA", "XCD", "XCD", "ARS", "AMD", "AWG", "AUD", "EUR", "AZN", "BSD", "BHD", "BDT", "BBD", "BYR", "EUR", "BZD", "XOF", "BMD", "BTN", "INR", "BOB", "BOV", "USD", "BAM", "BWP", "NOK", "BRL", "USD", "BND", "BGN", "XOF", "BIF", "KHR", "XAF", "CAD", "CVE", "KYD", "XAF", "XAF", "CLF", "CLP", "CNY", "AUD", "AUD", "COP", "COU", "KMF", "XAF", "CDF", "NZD", "CRC", "XOF", "HRK", "CUC", "CUP", "ANG", "EUR", "CZK", "DKK", "DJF", "XCD", "DOP", "USD", "EGP", "SVC", "USD", "XAF", "ERN", "EUR", "ETB", "EUR", "FKP", "DKK", "FJD", "EUR", "EUR", "EUR", "XPF", "EUR", "XAF", "GMD", "GEL", "EUR", "GHS", "GIP", "EUR", "DKK", "XCD", "EUR", "USD", "GTQ", "GBP", "GNF", "XOF", "GYD", "HTG", "USD", "AUD", "EUR", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "XDR", "IRR", "IQD", "EUR", "GBP", "ILS", "EUR", "JMD", "JPY", "GBP", "JOD", "KZT", "KES", "AUD", "KPW", "KRW", "KWD", "KGS", "LAK", "EUR", "LBP", "LSL", "ZAR", "LRD", "LYD", "CHF", "EUR", "EUR", "MOP", "MKD", "MGA", "MWK", "MYR", "MVR", "XOF", "EUR", "USD", "EUR", "MRO", "MUR", "EUR", "XUA", "MXN", "MXV", "USD", "MDL", "EUR", "MNT", "EUR", "XCD", "MAD", "MZN", "MMK", "NAD", "ZAR", "AUD", "NPR", "EUR", "XPF", "NZD", "NIO", "XOF", "NGN", "NZD", "AUD", "USD", "NOK", "OMR", "PKR", "USD", "PAB", "USD", "PGK", "PYG", "PEN", "PHP", "NZD", "PLN", "EUR", "USD", "QAR", "EUR", "RON", "RUB", "RWF", "EUR", "SHP", "XCD", "XCD", "EUR", "EUR", "XCD", "WST", "EUR", "STD", "SAR", "XOF", "RSD", "SCR", "SLL", "SGD", "ANG", "XSU", "EUR", "EUR", "SBD", "SOS", "ZAR", "SSP", "EUR", "LKR", "SDG", "SRD", "NOK", "SZL", "SEK", "CHE", "CHF", "CHW", "SYP", "TWD", "TJS", "TZS", "THB", "USD", "XOF", "NZD", "TOP", "TTD", "TND", "TRY", "TMT", "USD", "AUD", "UGX", "UAH", "AED", "GBP", "USD", "USN", "USD", "UYI", "UYU", "UZS", "VUV", "VEF", "VND", "USD", "USD", "XPF", "MAD", "YER", "ZMW", "ZWL", "XBA", "XBB", "XBC", "XBD", "XTS", "XXX", "XAU", "XPD", "XPT", "XAG")',"V_38_CURRENCY_COL_RECEIVED must be in ISO 4217 code", "STRING_LIMITED_CHOICES")
  	values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_68_CURRENCY", 'V_68_CURRENCY not in("AFN", "EUR", "ALL", "DZD", "USD", "EUR", "AOA", "XCD", "XCD", "ARS", "AMD", "AWG", "AUD", "EUR", "AZN", "BSD", "BHD", "BDT", "BBD", "BYR", "EUR", "BZD", "XOF", "BMD", "BTN", "INR", "BOB", "BOV", "USD", "BAM", "BWP", "NOK", "BRL", "USD", "BND", "BGN", "XOF", "BIF", "KHR", "XAF", "CAD", "CVE", "KYD", "XAF", "XAF", "CLF", "CLP", "CNY", "AUD", "AUD", "COP", "COU", "KMF", "XAF", "CDF", "NZD", "CRC", "XOF", "HRK", "CUC", "CUP", "ANG", "EUR", "CZK", "DKK", "DJF", "XCD", "DOP", "USD", "EGP", "SVC", "USD", "XAF", "ERN", "EUR", "ETB", "EUR", "FKP", "DKK", "FJD", "EUR", "EUR", "EUR", "XPF", "EUR", "XAF", "GMD", "GEL", "EUR", "GHS", "GIP", "EUR", "DKK", "XCD", "EUR", "USD", "GTQ", "GBP", "GNF", "XOF", "GYD", "HTG", "USD", "AUD", "EUR", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "XDR", "IRR", "IQD", "EUR", "GBP", "ILS", "EUR", "JMD", "JPY", "GBP", "JOD", "KZT", "KES", "AUD", "KPW", "KRW", "KWD", "KGS", "LAK", "EUR", "LBP", "LSL", "ZAR", "LRD", "LYD", "CHF", "EUR", "EUR", "MOP", "MKD", "MGA", "MWK", "MYR", "MVR", "XOF", "EUR", "USD", "EUR", "MRO", "MUR", "EUR", "XUA", "MXN", "MXV", "USD", "MDL", "EUR", "MNT", "EUR", "XCD", "MAD", "MZN", "MMK", "NAD", "ZAR", "AUD", "NPR", "EUR", "XPF", "NZD", "NIO", "XOF", "NGN", "NZD", "AUD", "USD", "NOK", "OMR", "PKR", "USD", "PAB", "USD", "PGK", "PYG", "PEN", "PHP", "NZD", "PLN", "EUR", "USD", "QAR", "EUR", "RON", "RUB", "RWF", "EUR", "SHP", "XCD", "XCD", "EUR", "EUR", "XCD", "WST", "EUR", "STD", "SAR", "XOF", "RSD", "SCR", "SLL", "SGD", "ANG", "XSU", "EUR", "EUR", "SBD", "SOS", "ZAR", "SSP", "EUR", "LKR", "SDG", "SRD", "NOK", "SZL", "SEK", "CHE", "CHF", "CHW", "SYP", "TWD", "TJS", "TZS", "THB", "USD", "XOF", "NZD", "TOP", "TTD", "TND", "TRY", "TMT", "USD", "AUD", "UGX", "UAH", "AED", "GBP", "USD", "USN", "USD", "UYI", "UYU", "UZS", "VUV", "VEF", "VND", "USD", "USD", "XPF", "MAD", "YER", "ZMW", "ZWL", "XBA", "XBB", "XBC", "XBD", "XTS", "XXX", "XAU", "XPD", "XPT", "XAG")',"V_68_CURRENCY must be in ISO 4217 code", "STRING_LIMITED_CHOICES")
  	values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_83_COUPON_CURRENCY", 'V_83_COUPON_CURRENCY not in("AFN", "EUR", "ALL", "DZD", "USD", "EUR", "AOA", "XCD", "XCD", "ARS", "AMD", "AWG", "AUD", "EUR", "AZN", "BSD", "BHD", "BDT", "BBD", "BYR", "EUR", "BZD", "XOF", "BMD", "BTN", "INR", "BOB", "BOV", "USD", "BAM", "BWP", "NOK", "BRL", "USD", "BND", "BGN", "XOF", "BIF", "KHR", "XAF", "CAD", "CVE", "KYD", "XAF", "XAF", "CLF", "CLP", "CNY", "AUD", "AUD", "COP", "COU", "KMF", "XAF", "CDF", "NZD", "CRC", "XOF", "HRK", "CUC", "CUP", "ANG", "EUR", "CZK", "DKK", "DJF", "XCD", "DOP", "USD", "EGP", "SVC", "USD", "XAF", "ERN", "EUR", "ETB", "EUR", "FKP", "DKK", "FJD", "EUR", "EUR", "EUR", "XPF", "EUR", "XAF", "GMD", "GEL", "EUR", "GHS", "GIP", "EUR", "DKK", "XCD", "EUR", "USD", "GTQ", "GBP", "GNF", "XOF", "GYD", "HTG", "USD", "AUD", "EUR", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "XDR", "IRR", "IQD", "EUR", "GBP", "ILS", "EUR", "JMD", "JPY", "GBP", "JOD", "KZT", "KES", "AUD", "KPW", "KRW", "KWD", "KGS", "LAK", "EUR", "LBP", "LSL", "ZAR", "LRD", "LYD", "CHF", "EUR", "EUR", "MOP", "MKD", "MGA", "MWK", "MYR", "MVR", "XOF", "EUR", "USD", "EUR", "MRO", "MUR", "EUR", "XUA", "MXN", "MXV", "USD", "MDL", "EUR", "MNT", "EUR", "XCD", "MAD", "MZN", "MMK", "NAD", "ZAR", "AUD", "NPR", "EUR", "XPF", "NZD", "NIO", "XOF", "NGN", "NZD", "AUD", "USD", "NOK", "OMR", "PKR", "USD", "PAB", "USD", "PGK", "PYG", "PEN", "PHP", "NZD", "PLN", "EUR", "USD", "QAR", "EUR", "RON", "RUB", "RWF", "EUR", "SHP", "XCD", "XCD", "EUR", "EUR", "XCD", "WST", "EUR", "STD", "SAR", "XOF", "RSD", "SCR", "SLL", "SGD", "ANG", "XSU", "EUR", "EUR", "SBD", "SOS", "ZAR", "SSP", "EUR", "LKR", "SDG", "SRD", "NOK", "SZL", "SEK", "CHE", "CHF", "CHW", "SYP", "TWD", "TJS", "TZS", "THB", "USD", "XOF", "NZD", "TOP", "TTD", "TND", "TRY", "TMT", "USD", "AUD", "UGX", "UAH", "AED", "GBP", "USD", "USN", "USD", "UYI", "UYU", "UZS", "VUV", "VEF", "VND", "USD", "USD", "XPF", "MAD", "YER", "ZMW", "ZWL", "XBA", "XBB", "XBC", "XBD", "XTS", "XXX", "XAU", "XPD", "XPT", "XAG")',"V_83_COUPON_CURRENCY must be in ISO 4217 code", "STRING_LIMITED_CHOICES")
  	values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_87_CURRENCY_NOMINAL_AMNT", 'V_87_CURRENCY_NOMINAL_AMNT not in("AFN", "EUR", "ALL", "DZD", "USD", "EUR", "AOA", "XCD", "XCD", "ARS", "AMD", "AWG", "AUD", "EUR", "AZN", "BSD", "BHD", "BDT", "BBD", "BYR", "EUR", "BZD", "XOF", "BMD", "BTN", "INR", "BOB", "BOV", "USD", "BAM", "BWP", "NOK", "BRL", "USD", "BND", "BGN", "XOF", "BIF", "KHR", "XAF", "CAD", "CVE", "KYD", "XAF", "XAF", "CLF", "CLP", "CNY", "AUD", "AUD", "COP", "COU", "KMF", "XAF", "CDF", "NZD", "CRC", "XOF", "HRK", "CUC", "CUP", "ANG", "EUR", "CZK", "DKK", "DJF", "XCD", "DOP", "USD", "EGP", "SVC", "USD", "XAF", "ERN", "EUR", "ETB", "EUR", "FKP", "DKK", "FJD", "EUR", "EUR", "EUR", "XPF", "EUR", "XAF", "GMD", "GEL", "EUR", "GHS", "GIP", "EUR", "DKK", "XCD", "EUR", "USD", "GTQ", "GBP", "GNF", "XOF", "GYD", "HTG", "USD", "AUD", "EUR", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "XDR", "IRR", "IQD", "EUR", "GBP", "ILS", "EUR", "JMD", "JPY", "GBP", "JOD", "KZT", "KES", "AUD", "KPW", "KRW", "KWD", "KGS", "LAK", "EUR", "LBP", "LSL", "ZAR", "LRD", "LYD", "CHF", "EUR", "EUR", "MOP", "MKD", "MGA", "MWK", "MYR", "MVR", "XOF", "EUR", "USD", "EUR", "MRO", "MUR", "EUR", "XUA", "MXN", "MXV", "USD", "MDL", "EUR", "MNT", "EUR", "XCD", "MAD", "MZN", "MMK", "NAD", "ZAR", "AUD", "NPR", "EUR", "XPF", "NZD", "NIO", "XOF", "NGN", "NZD", "AUD", "USD", "NOK", "OMR", "PKR", "USD", "PAB", "USD", "PGK", "PYG", "PEN", "PHP", "NZD", "PLN", "EUR", "USD", "QAR", "EUR", "RON", "RUB", "RWF", "EUR", "SHP", "XCD", "XCD", "EUR", "EUR", "XCD", "WST", "EUR", "STD", "SAR", "XOF", "RSD", "SCR", "SLL", "SGD", "ANG", "XSU", "EUR", "EUR", "SBD", "SOS", "ZAR", "SSP", "EUR", "LKR", "SDG", "SRD", "NOK", "SZL", "SEK", "CHE", "CHF", "CHW", "SYP", "TWD", "TJS", "TZS", "THB", "USD", "XOF", "NZD", "TOP", "TTD", "TND", "TRY", "TMT", "USD", "AUD", "UGX", "UAH", "AED", "GBP", "USD", "USN", "USD", "UYI", "UYU", "UZS", "VUV", "VEF", "VND", "USD", "USD", "XPF", "MAD", "YER", "ZMW", "ZWL", "XBA", "XBB", "XBC", "XBD", "XTS", "XXX", "XAU", "XPD", "XPT", "XAG")',"V_87_CURRENCY_NOMINAL_AMNT must be in ISO 4217 code", "STRING_LIMITED_CHOICES")
  	values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_68_CURRENCY", 'V_68_CURRENCY not in("AFN", "EUR", "ALL", "DZD", "USD", "EUR", "AOA", "XCD", "XCD", "ARS", "AMD", "AWG", "AUD", "EUR", "AZN", "BSD", "BHD", "BDT", "BBD", "BYR", "EUR", "BZD", "XOF", "BMD", "BTN", "INR", "BOB", "BOV", "USD", "BAM", "BWP", "NOK", "BRL", "USD", "BND", "BGN", "XOF", "BIF", "KHR", "XAF", "CAD", "CVE", "KYD", "XAF", "XAF", "CLF", "CLP", "CNY", "AUD", "AUD", "COP", "COU", "KMF", "XAF", "CDF", "NZD", "CRC", "XOF", "HRK", "CUC", "CUP", "ANG", "EUR", "CZK", "DKK", "DJF", "XCD", "DOP", "USD", "EGP", "SVC", "USD", "XAF", "ERN", "EUR", "ETB", "EUR", "FKP", "DKK", "FJD", "EUR", "EUR", "EUR", "XPF", "EUR", "XAF", "GMD", "GEL", "EUR", "GHS", "GIP", "EUR", "DKK", "XCD", "EUR", "USD", "GTQ", "GBP", "GNF", "XOF", "GYD", "HTG", "USD", "AUD", "EUR", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "XDR", "IRR", "IQD", "EUR", "GBP", "ILS", "EUR", "JMD", "JPY", "GBP", "JOD", "KZT", "KES", "AUD", "KPW", "KRW", "KWD", "KGS", "LAK", "EUR", "LBP", "LSL", "ZAR", "LRD", "LYD", "CHF", "EUR", "EUR", "MOP", "MKD", "MGA", "MWK", "MYR", "MVR", "XOF", "EUR", "USD", "EUR", "MRO", "MUR", "EUR", "XUA", "MXN", "MXV", "USD", "MDL", "EUR", "MNT", "EUR", "XCD", "MAD", "MZN", "MMK", "NAD", "ZAR", "AUD", "NPR", "EUR", "XPF", "NZD", "NIO", "XOF", "NGN", "NZD", "AUD", "USD", "NOK", "OMR", "PKR", "USD", "PAB", "USD", "PGK", "PYG", "PEN", "PHP", "NZD", "PLN", "EUR", "USD", "QAR", "EUR", "RON", "RUB", "RWF", "EUR", "SHP", "XCD", "XCD", "EUR", "EUR", "XCD", "WST", "EUR", "STD", "SAR", "XOF", "RSD", "SCR", "SLL", "SGD", "ANG", "XSU", "EUR", "EUR", "SBD", "SOS", "ZAR", "SSP", "EUR", "LKR", "SDG", "SRD", "NOK", "SZL", "SEK", "CHE", "CHF", "CHW", "SYP", "TWD", "TJS", "TZS", "THB", "USD", "XOF", "NZD", "TOP", "TTD", "TND", "TRY", "TMT", "USD", "AUD", "UGX", "UAH", "AED", "GBP", "USD", "USN", "USD", "UYI", "UYU", "UZS", "VUV", "VEF", "VND", "USD", "USD", "XPF", "MAD", "YER", "ZMW", "ZWL", "XBA", "XBB", "XBC", "XBD", "XTS", "XXX", "XAU", "XPD", "XPT", "XAG")',"V_68_CURRENCY must be in ISO 4217 code", "STRING_LIMITED_CHOICES")
  	values ("bu_captools_work","VDS_OUT_INTANGIBLE_ASSETS","V_122_CURRENCY", 'V_122_CURRENCY not in("AFN", "EUR", "ALL", "DZD", "USD", "EUR", "AOA", "XCD", "XCD", "ARS", "AMD", "AWG", "AUD", "EUR", "AZN", "BSD", "BHD", "BDT", "BBD", "BYR", "EUR", "BZD", "XOF", "BMD", "BTN", "INR", "BOB", "BOV", "USD", "BAM", "BWP", "NOK", "BRL", "USD", "BND", "BGN", "XOF", "BIF", "KHR", "XAF", "CAD", "CVE", "KYD", "XAF", "XAF", "CLF", "CLP", "CNY", "AUD", "AUD", "COP", "COU", "KMF", "XAF", "CDF", "NZD", "CRC", "XOF", "HRK", "CUC", "CUP", "ANG", "EUR", "CZK", "DKK", "DJF", "XCD", "DOP", "USD", "EGP", "SVC", "USD", "XAF", "ERN", "EUR", "ETB", "EUR", "FKP", "DKK", "FJD", "EUR", "EUR", "EUR", "XPF", "EUR", "XAF", "GMD", "GEL", "EUR", "GHS", "GIP", "EUR", "DKK", "XCD", "EUR", "USD", "GTQ", "GBP", "GNF", "XOF", "GYD", "HTG", "USD", "AUD", "EUR", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "XDR", "IRR", "IQD", "EUR", "GBP", "ILS", "EUR", "JMD", "JPY", "GBP", "JOD", "KZT", "KES", "AUD", "KPW", "KRW", "KWD", "KGS", "LAK", "EUR", "LBP", "LSL", "ZAR", "LRD", "LYD", "CHF", "EUR", "EUR", "MOP", "MKD", "MGA", "MWK", "MYR", "MVR", "XOF", "EUR", "USD", "EUR", "MRO", "MUR", "EUR", "XUA", "MXN", "MXV", "USD", "MDL", "EUR", "MNT", "EUR", "XCD", "MAD", "MZN", "MMK", "NAD", "ZAR", "AUD", "NPR", "EUR", "XPF", "NZD", "NIO", "XOF", "NGN", "NZD", "AUD", "USD", "NOK", "OMR", "PKR", "USD", "PAB", "USD", "PGK", "PYG", "PEN", "PHP", "NZD", "PLN", "EUR", "USD", "QAR", "EUR", "RON", "RUB", "RWF", "EUR", "SHP", "XCD", "XCD", "EUR", "EUR", "XCD", "WST", "EUR", "STD", "SAR", "XOF", "RSD", "SCR", "SLL", "SGD", "ANG", "XSU", "EUR", "EUR", "SBD", "SOS", "ZAR", "SSP", "EUR", "LKR", "SDG", "SRD", "NOK", "SZL", "SEK", "CHE", "CHF", "CHW", "SYP", "TWD", "TJS", "TZS", "THB", "USD", "XOF", "NZD", "TOP", "TTD", "TND", "TRY", "TMT", "USD", "AUD", "UGX", "UAH", "AED", "GBP", "USD", "USN", "USD", "UYI", "UYU", "UZS", "VUV", "VEF", "VND", "USD", "USD", "XPF", "MAD", "YER", "ZMW", "ZWL", "XBA", "XBB", "XBC", "XBD", "XTS", "XXX", "XAU", "XPD", "XPT", "XAG")',"V_122_CURRENCY must be in ISO 4217 code", "STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_144_INCEPTION_DATE",'V_144_INCEPTION_DATE > &MCR_REF_DATE OR V_144_INCEPTION_DATE < "01JAN1900"d',"V_144_INCEPTION_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_145_END_DATE_INTEREST",'V_145_END_DATE_INTEREST < &MCR_REF_DATE OR V_145_END_DATE_INTEREST > "31DEC2199"d',"V_145_END_DATE_INTEREST must be after the reference date", "DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_146_INTEREST_RATE_CAP",'V_146_INTEREST_RATE_CAP < 0 OR V_146_INTEREST_RATE_CAP > 1',"V_146_INTEREST_RATE_CAP not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_147_INTEREST_RATE_FLOOR",'V_147_INTEREST_RATE_CAP < 0 OR V_147_INTEREST_RATE_FLOOR > 1',"V_147_INTEREST_RATE_FLOOR not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_148_INTEREST_RATE_RST_FREQ",'V_148_INTEREST_RATE_RST_FREQ not in("Overnight", "Monthly/quarterly/semi-annual/annual", "At creditor discretion", "Other frequency")',"V_148_INTEREST_RATE_RST_FREQ must be one of (Overnight, Monthly/quarterly/semi-annual/annual, At creditor discretion, Other frequency)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_149_INTEREST_RATE_SPREAD",'V_149_INTEREST_RATE_SPREAD < 0 OR V_149_INTEREST_RATE_SPREAD > 1',"V_149_INTEREST_RATE_SPREAD not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_150_INTEREST_RATE_TYPE",'V_150_INTEREST_RATE_TYPE not in("Fixed", "Variable", "Mixed")',"V_150_INTEREST_RATE_TYPE must be one of (Fixed, Variable, Mixed)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_151_LEGAL_FINAL_MATURITY_DATE",'V_151_LEGAL_FINAL_MATURITY_DATE < &MCR_REF_DATE OR V_151_LEGAL_FINAL_MATURITY_DATE > "31DEC2199"d',"V_151_LEGAL_FINAL_MATURITY_DATE must be after the reference date", "DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_153_CAPITAL_PAYMENT_FREQ",'V_153_CAPITAL_PAYMENT_FREQ not in("Monthly/quarterly/semi-annual/annual", "Bullet", "Zero coupon", "Other")',"V_153_CAPITAL_PAYMENT_FREQ must be one of (Monthly/quarterly/semi-annual/annual, Bullet, Zero coupon, Other)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_153_INTEREST_PAYMENT_FREQ",'V_153_INTEREST_PAYMENT_FREQ not in("Monthly/quarterly/semi-annual/annual", "Bullet", "Zero coupon", "Other")',"V_153_INTEREST_PAYMENT_FREQ must be one of (Monthly/quarterly/semi-annual/annual, Bullet, Zero coupon, Other)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_154_REFERENCE_RATE",'V_154_REFERENCE_RATE not in("EURIBOR", "USD LIBOR", "GBP LIBOR", "EUR LIBOR", "JPY LIBOR", "CHF LIBOR", "MIBOR", "OTHER SINGLE REFERENCE RATES", "other multiple reference rates")',"V_154_REFERENCE_RATE must be one of (EURIBOR, USD LIBOR, GBP LIBOR, EUR LIBOR, JPY LIBOR, CHF LIBOR, MIBOR, OTHER SINGLE REFERENCE RATES, other multiple reference rates)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_157_NEXT_INTEREST_RST_DATE",'V_157_NEXT_INTEREST_RST_DATE < &MCR_REF_DATE OR V_157_NEXT_INTEREST_RST_DATE > "31DEC2199"d',"V_157_NEXT_INTEREST_RST_DATE must be after the reference date", "DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_158_DFLT_STATUS",'V_158_DFLT_STATUS not in ("Not in default", "Default because unlikely to pay (not more than 90/180 days past due)", "Default because more than 90/180 days past due", "Default because both unlikely to pay and more than 90/180 days past due")',"V_158_DFLT_STATUS must be one of (Not in default, Default because unlikely to pay (not more than 90/180 days past due) , Default because more than 90/180 days past due, Default because both unlikely to pay and more than 90/180 days past due)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_158_DFLT_STATUS",'V_158_DFLT_STATUS not in ("Not in default", "Default because unlikely to pay (not more than 90/180 days past due)", "Default because more than 90/180 days past due", "Default because both unlikely to pay and more than 90/180 days past due")',"V_158_DFLT_STATUS must be one of (Not in default, Default because unlikely to pay (not more than 90/180 days past due) , Default because more than 90/180 days past due, Default because both unlikely to pay and more than 90/180 days past due)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_180_CUMULATIVE_RECOVERIES",'V_180_CUMULATIVE_RECOVERIES LT 0',"V_180_CUMULATIVE_RECOVERIES must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_181_CARRYING_AMNT",'V_181_CARRYING_AMNT LT 0',"V_181_CARRYING_AMNT must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_182_PRUDENTIAL_PORTFOLIO",'V_182_PRUDENTIAL_PORTFOLIO not in("Trading book", "Non-trading book")',"V_182_PRUDENTIAL_PORTFOLIO must be one of (Trading book, Non-trading book)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_INSTRUMENTS","V_183_ACCUMLTD_CHANGES",'V_183_ACCUMLTD_CHANGES LT 0',"V_183_ACCUMLTD_CHANGES must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_COUNTERPARTIES","V_139_PD",'V_139_PD < 0 OR V_139_PD > 1',"V_139_PD not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_139_PD",'V_139_PD < 0 OR V_139_PD > 1',"V_139_PD not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_COUNTERPARTIES","V_184_COUNTERPARTY_ROLE",'V_184_COUNTERPARTY_ROLE not in("Creditor", "Debtor", "Servicer", "Originator")',"V_184_COUNTERPARTY_ROLE must be one of (Creditor, Debtor, Servicer, Originator)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_COUNTERPARTIES","V_185_DFLT_STATUS",'V_185_DFLT_STATUS not in("Not in default", "Default because unlikely to pay (not more than 90/180 days past due)", "Default because more than 90/180 days past due", "Default because both unlikely to pay and more than 90/180 days past due")',"V_185_DFLT_STATUS must be one of (Not in default, Default because unlikely to pay (not more than 90/180 days past due) , Default because more than 90/180 days past due, Default because both unlikely to pay and more than 90/180 days past due)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_185_DFLT_STATUS",'V_185_DFLT_STATUS not in("Not in default", "Default because unlikely to pay (not more than 90/180 days past due)", "Default because more than 90/180 days past due", "Default because both unlikely to pay and more than 90/180 days past due")',"V_185_DFLT_STATUS must be one of (Not in default, Default because unlikely to pay (not more than 90/180 days past due) , Default because more than 90/180 days past due, Default because both unlikely to pay and more than 90/180 days past due)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_COUNTERPARTIES","V_186_DFLT_STATUS_DATE",'V_186_DFLT_STATUS_DATE > &MCR_REF_DATE OR V_186_DFLT_STATUS_DATE < "01JAN1900"d',"V_186_DFLT_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_186_DFLT_STATUS_DATE",'V_186_DFLT_STATUS_DATE > &MCR_REF_DATE OR V_186_DFLT_STATUS_DATE < "01JAN1900"d',"V_186_DFLT_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_188_PROTECT_VALUE_DATE",'V_188_PROTECT_VALUE_DATE > &MCR_REF_DATE OR V_188_PROTECT_VALUE_DATE < "01JAN1900"d',"V_188_PROTECT_VALUE_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_188_PROTECT_VALUE_DATE",'V_188_PROTECT_VALUE_DATE > &MCR_REF_DATE OR V_188_PROTECT_VALUE_DATE < "01JAN1900"d',"V_188_PROTECT_VALUE_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_220_PROTECT_VALUE",'V_220_PROTECT_VALUE LT 0',"V_220_PROTECT_VALUE must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_220_PROTECT_VALUE",'V_220_PROTECT_VALUE LT 0',"V_220_PROTECT_VALUE must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_189_PROTECT_MATURITY_DATE",'V_189_PROTECT_MATURITY_DATE < &MCR_REF_DATE OR V_189_PROTECT_MATURITY_DATE > "31DEC2199"d',"V_189_PROTECT_MATURITY_DATE must be after the reference date", "DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_189_PROTECT_MATURITY_DATE",'V_189_PROTECT_MATURITY_DATE < &MCR_REF_DATE OR V_189_PROTECT_MATURITY_DATE > "31DEC2199"d',"V_189_PROTECT_MATURITY_DATE must be after the reference date", "DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_190_ORIG_PROTECT_VALUE",'V_190_ORIG_PROTECT_VALUE LT 0',"V_190_ORIG_PROTECT_VALUE must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_190_ORIG_PROTECT_VALUE",'V_190_ORIG_PROTECT_VALUE LT 0',"V_190_ORIG_PROTECT_VALUE must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_191_ORIG_PROTECT_VALUE_DATE",'V_191_ORIG_PROTECT_VALUE_DATE > &MCR_REF_DATE OR V_191_ORIG_PROTECT_VALUE_DATE < "01JAN1900"d',"V_191_ORIG_PROTECT_VALUE_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_191_ORIG_PROTECT_VALUE_DATE",'V_191_ORIG_PROTECT_VALUE_DATE > &MCR_REF_DATE OR V_191_ORIG_PROTECT_VALUE_DATE < "01JAN1900"d',"V_191_ORIG_PROTECT_VALUE_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_192_PROTECT_VALUE_TYPE",'V_192_PROTECT_VALUE_TYPE NE ("Fair Value")',"V_192_PROTECT_VALUE_TYPE must be Fair Value)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_192_PROTECT_VALUE_TYPE",'V_192_PROTECT_VALUE_TYPE NE ("Fair Value")',"V_192_PROTECT_VALUE_TYPE must be Fair Value)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_221_PROTECT_VALUATION_APPRCH",'V_221_PROTECT_VALUATION_APPRCH not in("Mark-to-market valuation")',"V_221_PROTECT_VALUATION_APPRCH must be Mark-to-market valuation","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_PROTECTIONS","V_221_PROTECT_VALUATION_APPRCH",'V_221_PROTECT_VALUATION_APPRCH not in("Mark-to-market valuation")',"V_221_PROTECT_VALUATION_APPRCH must be Mark-to-market valuation","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_193_PROTECT_ALLOC_VALUE",'V_193_PROTECT_ALLOC_VALUE LT 0',"V_193_PROTECT_ALLOC_VALUE must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_NATURALP_PROTECTIONS","V_194_THIRD_PARTY_PRRTY_CLAIMS",'V_194_THIRD_PARTY_PRRTY_CLAIMS LT 0',"V_194_THIRD_PARTY_PRRTY_CLAIMS must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_222_TYPE",'V_222_TYPE not in ("Loan commitments given", "Financial guarantees given", "Other commitments given")',"V_222_TYPE must be (Loan commitments given, Financial guarantees given, Other commitments given)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_23_CCF",'V_23_CCF < 0 OR V_23_CCF > 1',"V_23_CCF not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_223_NOMINAL_AMNT",'V_223_NOMINAL_AMNT LT 0',"V_223_NOMINAL_AMNT must be greater than or equal to 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUEMNTS","V_224_MATURITY_DATE",'V_224_MATURITY_DATE < &MCR_REF_DATE OR V_224_MATURITY_DATE > "31DEC2199"d',"V_189_PROTECT_MATURITY_DATE must be after the reference date", "DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_INSTRUMENTS","V_225_NOMINAL_INTEREST_RATE",'V_225_NOMINAL_INTEREST_RATE < 0 OR V_225_NOMINAL_INTEREST_RATE > 1',"V_225_NOMINAL_INTEREST_RATE not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_204_ADDR_COUNTY",'V_204_ADDR_COUNTY not in("Alto Minho", "Cávado", "Ave", "Área Metropolitana do Porto", "Alto Tâmega", "Tâmega e Sousa", "Douro", "Terras de Trás-os-Montes", "Algarve", "Oeste", "Região de Aveiro", "Região de Coimbra", "Região de Leiria", "Viseu Dão-Lafões", "Beira Baixa", "Médio Tejo", "Beiras e Serra da Estrela", "Área Metropolitana de Lisboa", "Alentejo Litoral", "Baixo Alentejo", "Lezíria do Tejo", "Alto Alentejo", "Alentejo Central", "Região Autónoma dos Açores", "Região Autónoma da Madeira")',"V_204_ADDR_COUNTY must be one of (Alto Minho, Cávado, Ave, Área Metropolitana do Porto, Alto Tâmega, Tâmega e Sousa, Douro, Terras de Trás-os-Montes, Algarve, Oeste, Região de Aveiro, Região de Coimbra, Região de Leiria, Viseu Dão-Lafões, Beira Baixa, Médio Tejo, Beiras e Serra da Estrela, Área Metropolitana de Lisboa, Alentejo Litoral, Baixo Alentejo, Lezíria do Tejo, Alto Alentejo, Alentejo Central, Região Autónoma dos Açores, Região Autónoma da Madeira)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_205_ADDR_COUNTRY",'V_205_ADDR_COUNTRY not in("AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW")',"V_205_ADDR_COUNTRY must be according to ISO 3166-1 alpha-2","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_25_COUNTERPARTY_COUNTRY",'V_25_COUNTERPARTY_COUNTRY not in("AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW")',"V_25_COUNTERPARTY_COUNTRY must be according to ISO 3166-1 alpha-2","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DERIVATIVES","V_28_GOVERNING_LAW",'V_28_GOVERNING_LAW not in("AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW")',"V_28_GOVERNING_LAW must be according to ISO 3166-1 alpha-2","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_62_COUNTRY_ISSUER",'V_62_COUNTRY_ISSUER not in("AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW")',"V_62_COUNTRY_ISSUER must be according to ISO 3166-1 alpha-2","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_62_COUNTRY_ISSUER",'V_62_COUNTRY_ISSUER not in("AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW")',"V_62_COUNTRY_ISSUER must be according to ISO 3166-1 alpha-2","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_207_INSTITUTIONAL_SECTOR",'V_207_INSTITUTIONAL_SECTOR not in("Non-financial corporations", "Central Bank", "Credit institutions", "Deposit-taking corporations other than credit institutions", "Money market funds (MMF)", "Non-MMF Investment funds", "Financial vehicle corporations (FVCs) engaged in securitisation transactions, other financial intermediaries, except financial auxiliaries, captive financial institutions and money lenders, insurance corporations, pension funds and financial vehicle corporations engaged in securitisation transactions", "Financial auxilliaries", "Captive financial institutions and money lenders,", "Insurance corporations", "Pension funds", "Central government", "State government", "Local government", "Social security funds", "Non-profit institutions serving households")',"V_207_INSTITUTIONAL_SECTOR must be one of (Non-financial corporations, Central Bank, Credit institutions, Deposit-taking corporations other than credit institutions, Money market funds (MMF), Non-MMF Investment funds, Financial vehicle corporations (FVCs) engaged in securitisation transactions, other financial intermediaries, except financial auxiliaries, captive financial institutions and money lenders, insurance corporations, pension funds and financial vehicle corporations engaged in securitisation transactions, Financial auxilliaries, Captive  financial institutions and money lenders,, Insurance corporations, Pension funds, Central government, State government, Local government, Social security funds, Non-profit institutions serving households)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_209_LEGAL_PRCDNGS_STATUS",'V_209_LEGAL_PRCDNGS_STATUS not in("No legal actions taken", "Under judicial administration, receivership or similar measures", "Bankruptcy/insolvency", "Other legal measures")',"V_209_LEGAL_PRCDNGS_STATUS must be one of (No legal actions taken, Under judicial administration, receivership or similar measures, Bankruptcy/insolvency, Other legal measures)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_210_LEGAL_PRCDNGS_STATUS_DATE",'V_210_LEGAL_PRCDNGS_STATUS_DATE > &MCR_REF_DATE OR V_210_LEGAL_PRCDNGS_STATUS_DATE < "01JAN1900"d',"V_210_LEGAL_PRCDNGS_STATUS_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_211_ENTERPRISE_SIZE",'V_211_ENTERPRISE_SIZE not in("Large enterprise", "Medium enterprise", "Small enterprise", "Microenterprise")',"V_211_ENTERPRISE_SIZE must be one of (Large enterprise, Medium enterprise, Small enterprise, Microenterprise)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_212_ENTERPRISE_SIZE_DATE",'V_212_ENTERPRISE_SIZE_DATE > &MCR_REF_DATE OR V_212_ENTERPRISE_SIZE_DATE < "01JAN1900"d',"V_212_ENTERPRISE_SIZE_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_213_NUMBER_EMPLOYEES",'V_213_NUMBER_EMPLOYEES LE 0',"V_213_NUMBER_EMPLOYEES must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_214_BALANCE_SHEET_TOTAL",'V_214_BALANCE_SHEET_TOTAL LE 0',"V_214_BALANCE_SHEET_TOTAL must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTERPARTIES","V_215_ANNUAL_TURNOVER",'V_215_ANNUAL_TURNOVER LE 0',"V_215_ANNUAL_TURNOVER must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_OFFBAL_COUNTEROARTIES","V_216_ACCOUNTING_STANDARD",'V_216_ACCOUNTING_STANDARD NE ("Fair Value")',"V_216_ACCOUNTING_STANDARD must be Fair Value","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_67_ISSUER_TYPE",'V_67_ISSUER_TYPE not in("Other group entity (1)", "Third party (2)")',"V_67_ISSUER_TYPE must be one of (Other group entity (1), Third party (2))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_67_ISSUER_TYPE",'V_67_ISSUER_TYPE not in("Other group entity (1)", "Third party (2)")',"V_67_ISSUER_TYPE must be one of (Other group entity (1), Third party (2))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_69_VALUATION_TIMESTAMP",'V_69_VALUATION_TIMESTAMP > &MCR_REF_DATE OR V_69_VALUATION_TIMESTAMP < "01JAN1900"d',"V_69_VALUATION_TIMESTAMP must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_69_VALUATION_TIMESTAMP",'V_69_VALUATION_TIMESTAMP > &MCR_REF_DATE OR V_69_VALUATION_TIMESTAMP < "01JAN1900"d',"V_69_VALUATION_TIMESTAMP must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_70_VALUATION_TYPE",'V_70_VALUATION_TYPE not in("Mark-to-market (1)", "Mark-to-model (2)")',"V_70_VALUATION_TYPE must be one of (Mark-to-market (1), Mark-to-model (2))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_70_VALUATION_TYPE",'V_70_VALUATION_TYPE not in("Mark-to-market (1)", "Mark-to-model (2)")',"V_70_VALUATION_TYPE must be one of (Mark-to-market (1), Mark-to-model (2))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_71_INST_CLASS",'V_71_INST_CLASS not in("Short-term debt securities", "Long-term debt securities", "Listed shares", "Money market funds (MMF) shares/units", "Non-MMF investment fund shares/units")',"V_71_INST_CLASS must be one of (Short-term debt securities, Long-term debt securities, Listed shares, Money market funds (MMF) shares/units, Non-MMF investment fund shares/units)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_72_PRIMARY_ASSET_CLASS",'V_72_PRIMARY_ASSET_CLASS not in("Debt", "Bond", "Straight bond", "Securitisation bond", "Traditional securitisation", "Synthetic securitisation", "Other securitisation", "Covered bond", "Jumbo covered bond", "Other covered bond", "Medium-term note", "Euro medium term notes (EMTN) ", "Other MTN", "Perpetual bond", "Linked bond", "Inflation-linked bond", "Interest rate-linked bond", "Asset-linked bond", "Currency-linked bond", "Credit-linked bond", "Exchange traded notes (ETN)", "Exchange traded commodities (ETC)", "Other linked bond", "Strip bond", "Coupon strip", "Principal strip", "Structured debt security (Certificates)", "Investment product", "Capital protection product", "Yield enhancement product", "Participation product", "Other investment product", "Leverage Product", "Leverage product with knock-out", "Leverage product without knock-out", "Constant leverage product", "Other leverage product", "Other bond", "Money market instrument", "Bankers acceptance", "Certificate of deposit", "Commercial paper", "Euro commercial paper (ECP)", "Pagares", "Other CP", "Treasury bill", "Other money market instrument", "Hybrid debt instrument", "Convertible bond", "Contingent convertible bonds (CoCo’s)", "Bonds with warrants attached", "Stapled debt instrument", "Non-participating (preferred) share", "Other hybrid debt Instrument", "Other debt", "Equity", "Ordinary / Common share", "Preference / Preferred share", "Cumulative preferred share", "Participating preferred share", "Cumulative, participating preferred share", "Redeemable preferred share", "Other preferred share", "Depository receipt", "American depository receipt (ADR)", "Global depository receipt (GDR)", "Other depository receipt", "Hybrid equity instrument", "Participation certificate (Genussschein)", "Subscription right", "Convertible (preferred) share", "Other hybrid equity instrument", "Other equity", "Fund", "Undertaking for collective investment in transferable securities (UCITS) Fund", "Alternative investment fund (AIF)", "Other fund")',"V_72_PRIMARY_ASSET_CLASS must be one of (Debt, Bond, Straight bond, Securitisation bond, Traditional securitisation, Synthetic securitisation, Other securitisation, Covered bond, Jumbo covered bond, Other covered bond, Medium-term note, Euro medium term notes (EMTN) , Other MTN, Perpetual bond, Linked bond, Inflation-linked bond, Interest rate-linked bond, Asset-linked bond, Currency-linked bond, Credit-linked bond, Exchange traded notes (ETN), Exchange traded commodities (ETC), Other linked bond, Strip bond, Coupon strip, Principal strip, Structured debt security (Certificates), Investment product, Capital protection product, Yield enhancement product, Participation product, Other investment product, Leverage Product, Leverage product with knock-out, Leverage product without knock-out, Constant leverage product, Other leverage product, Other bond, Money market instrument, Bankers acceptance, Certificate of deposit, Commercial paper, Euro commercial paper (ECP) , Pagares, Other CP, Treasury bill, Other money market instrument, Hybrid debt instrument, Convertible bond, Contingent convertible bonds (CoCo’s), Bonds with warrants attached, Stapled debt instrument, Non-participating (preferred) share, Other hybrid debt Instrument, Other debt, Equity, Ordinary / Common share, Preference / Preferred share, Cumulative preferred share, Participating preferred share, Cumulative, participating preferred share, Redeemable preferred share, Other preferred share, Depository receipt, American depository receipt (ADR), Global depository receipt (GDR), Other depository receipt, Hybrid equity instrument, Participation certificate (Genussschein), Subscription right, Convertible (preferred) share, Other hybrid equity instrument, Other equity, Fund, Undertaking for collective investment in transferable securities (UCITS) Fund, Alternative investment fund (AIF), Other fund)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_73_ASSET_SECURIT_CLASS",'V_73_ASSET_SECURIT_CLASS not in("Aircraft Covered bond", "Mixed Covered bond", "Other Covered bond", "Covered Bond - No detailed classification available", "Securitisation and Covered Bond - No detailed classification available")',"V_73_ASSET_SECURIT_CLASS must be one of (Aircraft Covered bond, Mixed Covered bond, Other Covered bond, Covered Bond - No detailed classification available, Securitisation and Covered Bond - No detailed classification available)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_75_ISSUANCE_DATE",'V_75_ISSUANCE_DATE > &MCR_REF_DATE OR V_75_ISSUANCE_DATE < "01JAN1900"d',"V_75_ISSUANCE_DATE must be before the reference date","DATE")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_76_MATURITY_DATE",'V_76_MATURITY_DATE < &MCR_REF_DATE OR V_76_MATURITY_DATE > "31DEC2199"d',"V_189_PROTECT_MATURITY_DATE must be after the reference date", "DATE")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_80_TYPE_INST_SENIORITY",'V_80_TYPE_INST_SENIORITY not in("Guarantee level", "Unguaranteed ", "Government / Treasury guarantee", "Other guarantee", "Guarantee level - No detailed information available", "Rank level", "Subordinated - Junior level", "Subordinated - Senior level", "Subordinated - No further breakdown available", "Senior", "ABS Class - Junior", "ABS Class - Mezzanine", "ABS Class - Senior", "Rank level - No detailed information available", "Security level", "Unsecured", "Secured", "Security level - No detailed information available")',"V_80_TYPE_INST_SENIORITY must be one of (Guarantee level, Unguaranteed , Government / Treasury guarantee, Other guarantee, Guarantee level - No detailed information available, Rank level, Subordinated - Junior level, Subordinated - Senior level, Subordinated - No further breakdown available, Senior, ABS Class - Junior, ABS Class - Mezzanine, ABS Class - Senior, Rank level - No detailed information available, Security level, Unsecured, Secured, Security level - No detailed information available)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_81_COUPON_TYPE",'V_81_COUPON_TYPE not in("Fixed (1)", "Floating (2)", "Zero coupon (3)", "Other (4)")',"V_81_COUPON_TYPE must be one of (Fixed (1), Floating (2), Zero coupon (3), Other (4))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_82_COUPON_FREQ",'V_82_COUPON_FREQ not in("Monthly (1)", "Semi-annual (2)", "Annual (3)", "Other (4)")',"V_82_COUPON_FREQ must be one of (Monthly (1), Semi-annual (2), Annual (3), Other (4))","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_85_REFERENCE_RATE",'V_85_REFERENCE_RATE < 0 OR V_85_REFERENCE_RATE > 1',"V_85_REFERENCE_RATE not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_86_SPREAD",'V_86_SPREAD < 0 OR V_86_SPREAD > 1',"V_86_SPREAD not in the expected range [0-1]","NUMERIC")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_88_PURCHASE_UNDER_RESALE",'V_88_PURCHASE_UNDER_RESALE not in("Yes", "No")',"V_88_PURCHASE_UNDER_RESALE must be Yes or No","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_90_ELIGIBILITY_ECB_OPS",'V_90_ELIGIBILITY_ECB_OPS not in("Yes", "No")',"V_90_ELIGIBILITY_ECB_OPS must be Yes or No","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_91_LCR_BUFFER",'V_91_LCR_BUFFER not in("Yes", "No")',"V_91_LCR_BUFFER must be Yes or No","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_91_LCR_BUFFER",'V_91_LCR_BUFFER not in("Yes", "No")',"V_91_LCR_BUFFER must be Yes or No","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_89_ENCUMBRANCE_SOURCES",'V_89_ENCUMBRANCE_SOURCES not in("Unencumbered/No encumbrance", "Central bank funding", "Exchange traded derivatives", "Over-the-counter derivatives", "Deposits - repurchase agreements other than to central banks", "Deposits other than repurchase agreements", "Debt securities issued - covered bonds securities", "Debt securities issued - asset-backed securities ", "Debt securities issued - other than covered bonds and ABSs", "Other sources of encumbrance")',"V_89_ENCUMBRANCE_SOURCES must be one of (Unencumbered/No encumbrance, Central bank funding , Exchange traded derivatives, Over-the-counter derivatives, Deposits - repurchase agreements other than to central banks, Deposits other than repurchase agreements, Debt securities issued - covered bonds securities , Debt securities issued - asset-backed securities , Debt securities issued - other than covered bonds and ABSs, Other sources of encumbrance)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_92_LCR_BUFFER_CATEGORY",'V_92_LCR_BUFFER_CATEGORY not in("L1A", "L2A", "L2B")',"V_92_LCR_BUFFER_CATEGORY must be one of (L1A, L2A, L2B)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_93_ACCOUNTING_CLASSIFICATION",'V_93_ACCOUNTING_CLASSIFICATION not in("IFRS: Financial assets designated at fair value through profit or loss", "IFRS: Financial assets at amortised cost", "IFRS: Financial assets at fair value through other comprehensive income", "IFRS: Non-trading financial assets mandatorily at fair value through profit or loss", "Investments in subsidiaries, joint ventures and associates")',"V_93_ACCOUNTING_CLASSIFICATION must be one of (IFRS: Financial assets designated at fair value through profit or loss, IFRS: Financial assets at amortised cost, IFRS: Financial assets at fair value through other comprehensive income, IFRS: Non-trading financial assets mandatorily at fair value through profit or loss, Investments in subsidiaries, joint ventures and associates)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_93_ACCOUNTING_CLASSIFICATION",'V_93_ACCOUNTING_CLASSIFICATION not in("IFRS: Financial assets designated at fair value through profit or loss", "IFRS: Financial assets at amortised cost", "IFRS: Financial assets at fair value through other comprehensive income", "IFRS: Non-trading financial assets mandatorily at fair value through profit or loss", "Investments in subsidiaries, joint ventures and associates")',"V_93_ACCOUNTING_CLASSIFICATION must be one of (IFRS: Financial assets designated at fair value through profit or loss, IFRS: Financial assets at amortised cost, IFRS: Financial assets at fair value through other comprehensive income, IFRS: Non-trading financial assets mandatorily at fair value through profit or loss, Investments in subsidiaries, joint ventures and associates)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_94_PERFORMING_STATUS",'V_94_PERFORMING_STATUS not in("Performing", "Non-performing")',"V_94_PERFORMING_STATUS must be one of (Performing, Non-performing)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_95_PRUDENTIAL_PORTFOLIO",'V_95_PRUDENTIAL_PORTFOLIO not in("Trading book", "Non-trading book")',"V_95_PRUDENTIAL_PORTFOLIO must be one of (Performing, Non-performing)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_95_PRUDENTIAL_PORTFOLIO",'V_95_PRUDENTIAL_PORTFOLIO not in("Trading book", "Non-trading book")',"V_95_PRUDENTIAL_PORTFOLIO must be one of (Performing, Non-performing)","STRING_LIMITED_CHOICES")
  values ("bu_captools_work","VDS_OUT_DEBT_SECURITIES","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT LE 0',"V_5_TOTAL_RISK_EXPO_AMNT must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_5_TOTAL_RISK_EXPO_AMNT",'V_5_TOTAL_RISK_EXPO_AMNT LE 0',"V_5_TOTAL_RISK_EXPO_AMNT must be greater than 0","NUMERIC")
  values ("bu_captools_work","VDS_OUT_EQUITY_INSTRUMENTS","V_97_DIVIDEND_YIELD",'V_97_DIVIDEND_YIELD < 0 OR V_97_DIVIDEND_YIELD > 1',"V_97_DIVIDEND_YIELD not in the expected range [0-1]","NUMERIC")
;


--REVER COM O MIGUEL, NAO SABEMOS O QUE ISTO É
--Runs data quality process.

-- @param OUT_DS_ERRORS     Output dataset
-- @param IN_DQ_CFG_PATH    DQ Config location path
-- @param IN_SAS_MODEL_PATH SAS Model Path

%macro dq(                                                                      --criação de variável dq que tem out_ds_errors (VDSCTL.VDS_CTL_DATA_QUALITY) e *in_dq_cfg_path
                OUT_DS_ERRORS=,
                IN_DQ_CFG_PATH=
);

   libname dqcfg "&IN_DQ_CFG_PATH.";                                            --define variáveis e queries que vão ser utilizadas posteriormente (é uma biblioteca onde os dados são todos do mesmo tipo e estão todos armanezados na mesma pasta)

   %let IN_DATA_CONS=dqcfg.data_quality_check;
   %let IN_FOREIGN_KEYS=dqcfg.data_quality_check_foreign_key;
   %let IN_CONFIG_PK=dqcfg.CONFIG_PK;
   %let IN_GROUP_ID_LIST=;
   %let IN_TABLE_NM_LIST=;
   %let IN_ONE_ERROR_PER_ROW_FLG=N;
   %let IN_IGNORE_CASE_FLG=Y;
   %let IN_CHECK_FOREIGN_KEYS_FLG=Y;

   /* Initialize the errors dataset */                                          --cria função que valida os erros do data SET
   %if (%superq(OUT_DS_ERRORS) ne ) %then %do;                                  --superq traz a string literal // nesta linha verifica-se se a variavel existe. verifica se out_ds_errors não vem a vazio ("") então
     data error_temp;                                                           -- cria a tabela error_temp tem duas colunas mais as colunas da de baixo (in_data_cons=dqcfg.data_quality_check)
         length PRIMARY_KEY COLUMN_VALUE $1024;
         if 0 then set &IN_DATA_CONS;
         stop;
      run;
   %end;
-- REVER ATÉ AQUI COM O MIGUEL, PASSAMOS ESSA PARTE À FRENTE!


-- Query sashelp.vcolumn to find out which columns are indices and what data type they are          --validacação da qualidade dos dados
create table all_columns as                                                     --criação de nova tabela
  select t1.libname, t1.memname, t1.name, t2.idxusage, t1.type                  --pretendemos essas variasveis da t1 e da t2
  from sashelp.vcolumn as t1                                                    -- Essa função apresenta informações sobre todas as variáveis do data set, se o data set estiver a vazio a função nao irá retornar nada.
     left join dqcfg.config_pk as t2   -- left join &IN_CONFIG_PK. t2           --A tabela config_pk é uma tabela com várias tabelas lá dentro e foi criada ao longo deste script
     on  t1.libname = t2.libname                                                -- Assim vai comparar as os dados da tabela 1 com a tabela2
     and t1.memname = t2.memname                                                --
     and t1.name  = t2.name
  where TRIM(UPPER(t1.libname)) in (select distinct TRIM(UPPER(library_nm)) from dqcfg.data_quality_check)      -- trim vai retirando os espaços da variável libname presente em library_nm da tabela data_quality_check
  order by libname, memname;


create table data_quality_check_with_datatype as                                -- Cria a tabela de validação dos dados
select t1.*, t2.type as data_type                                               -- seleciona as variaveis todas da tabela t1 e da tabela 2 apenas a variável type
from dqcfg.data_quality_check as t1, all_columns as t2
where TRIM(UPPER(t1.library_nm)) = TRIM(UPPER(t2.libname))                      --Compara o valores da tabela 1 com a tabela 2 realizando uma concatenação ao usar o trim
      and TRIM(UPPER(t1.table_nm)) = TRIM(UPPER(t2.memname))
      and TRIM(UPPER(t1.column_nm)) = TRIM(UPPER(t2.name))
      and not missing(failure_check_txt) --a função de missing nao vai funcionar no hive        --Alterar a função do missing por NULLVALUE('a')
      %if (%superq(IN_GROUP_ID_LIST) ne ) %then %do;                            --Se a variável VEM prenchida então realiza a função
         %local quoted_group_id_list;
         %let quoted_group_id_list=%rsk_quote_list(list=%str(&IN_GROUP_ID_LIST.));      -- Cria um filtro através do qual procura se existem os group_idque procura, nesse caso se existirem
         and GROUP_ID in (&quoted_group_id_list.)
      %end;
      %if (%superq(IN_TABLE_NM_LIST) ne ) %then %do;
         %local quoted_table_nm_list;
         %let quoted_table_nm_list=%rsk_quote_list(list=%str(&IN_TABLE_NM_LIST.));      -- Cria um filtor de procura dos valores de table_nm que se pretende, nesse caso se existirem valores
         and TABLE_NM in (&quoted_table_nm_list.)
      %end;;                                                                    --podem criar-se ambos os filtros, apenas um ou então nenhum se nao existirem

------

-- Create a string to put the indices for the error messages
data index_put_string;                                                          -- criação de tabela
  set all_columns (where = (not missing(idxusage)));                            --filtro pelas variáveis que existem (sem querer saber dos valores a vazios)
  by libname memname;                                                           -- tal filtro a partir do libnamee do memname
  length index_put_string PRIMARY_KEY $1024;                                    --o tamanho irá ser de 1024
  retain index_put_string PRIMARY_KEY;
  key_count = sum(key_count, 1);                                                --achamos que poderá ser a criação da coluna key_count da tabela index_put_string na qual os valores são: 1, 2, 3, 4, ...

  length put_key_value $64;                                                     --cria a coluna put_key_value com tamanho irá ser de 64 caracteres
  if lowcase(type) eq 'num' then do;                                            --se o valor do type for correspondente a "num" então...
     put_key_value = 'trim(left(put(' || trim(name) || ', best.)))';            --(...) define a condição usando a chave da tabela para ser utilizada mais a frente (nesta caso en concreto usa a variável name da tabela config_pk)
  end;
  else put_key_value = 'trim(' || trim(name) || ')';                            -- se não será esta outra mensagem de erro

  if first.memname then do;                                                     --vai buscar o primeiro elemento da coluna memname se existir
     index_put_string = '''%str(' || trim(name)  || '='' || ' || trim(put_key_value);
     PRIMARY_KEY = "'" || trim(name)  || "=' || " || trim(put_key_value);
  end;
  else do;
     index_put_string = trim(index_put_string) || '|| '', ' || trim(name)  || '='' || ' || trim(put_key_value);
     PRIMARY_KEY = trim(PRIMARY_KEY) || "|| ', " || trim(name)  || "=' || " || trim(put_key_value);
  end;

  if last.memname then do;
     index_put_string = trim(index_put_string) || ' || '')''';
     output;
  end;
run;

/* Join this string back with the data quality checks */
proc sql noprint;
create table data_quality_check_with_all_info as                                --criação de nova tabela de modo a verificar toda e informação
select t1.*,                                                                    --seleciona tudo da tabela t1 data_quality_check_with_datatype
           coalesce(t2.index_put_string, 'N/A') as index_put_string,            -- coalesce vai retornar o primeiro valor da lista diferente de NULL da coluna index_put_string
           coalesce(t2.PRIMARY_KEY, 'N/A') as PRIMARY_KEY                       --vai retornar o primeiro valor que não seja NULL da coluna PRIMARY_KEY
from data_quality_check_with_datatype as t1                                     --
 left join index_put_string as t2                                               --cola À esquerda a tabela criada previamente (com as mensagems dos erros)
  on trim(upcase(t1.LIBRARY_NM)) eq trim(upcase(t2.libname))                    --dessa tabela vai filtrar pelo library_nm da t1 ser igual ao libname da t2
  and trim(upcase(t1.TABLE_NM)) eq trim(upcase(t2.memname))
order by LIBRARY_NM, TABLE_NM;
quit;

   /* Run all the rules */
   filename tempf temp;
   data _null_;
      set data_quality_check_with_all_info;
      by LIBRARY_NM TABLE_NM;
      file tempf;
      /* If we're to ignore case, then replace all instances of the variable name
         with upcase(variable_name) in FAILURE_CHECK_TXT and upcase FAILURE_CHECK_TXT in general */
      %if %superq(IN_IGNORE_CASE_FLG) eq Y %then %do;
         if lowcase(data_type) eq 'char' then do;
            FAILURE_CHECK_TXT = upcase(FAILURE_CHECK_TXT);
            COLUMN_NM = upcase(COLUMN_NM);
            FAILURE_CHECK_TXT = tranwrd(FAILURE_CHECK_TXT, trim(COLUMN_NM), 'upcase(' || trim(COLUMN_NM) || ')');
         end;
      %end;

/* Start the dataset that will hold new violators */
/* If we are just outputting errors and not storing violators in a dataset, then use data _null_ */
if first.TABLE_NM then do;
   %if (%superq(OUT_DS_ERRORS) ne ) %then %do;
      put 'data append_errors (keep=PRIMARY_KEY COLUMN_VALUE LIBRARY_NM TABLE_NM COLUMN_NM ERROR_MESSAGE_TXT FAILURE_CHECK_TXT GROUP_ID);';
      put '   length PRIMARY_KEY COLUMN_VALUE $1024;';
   %end;
   %else %do;
      put 'data _null_;';
   %end;
   put '   set ' LIBRARY_NM '.' TABLE_NM ';';
   put '   if 0 then set ' "&IN_DATA_CONS;";
   %if (%superq(OUT_DS_ERRORS) ne ) %then %do;
      put '   PRIMARY_KEY = ' PRIMARY_KEY ';';
   %end;
   put "   LIBRARY_NM = '" LIBRARY_NM "';";
   put "   TABLE_NM = '" TABLE_NM "';";
   put '   error_found_flg = 0;';
end;

/* Run each rule for each column separately */
/* If we are only outputting one error per position, then only run
   each check if an error has not yet been found */
      %if %superq(IN_ONE_ERROR_PER_ROW_FLG) eq Y %then %do;
         put '   if ' FAILURE_CHECK_TXT ' and error_found_flg eq 0 then do;';
      %end;
      %else %do;
         put '   if ' FAILURE_CHECK_TXT ' then do;';
      %end;
      put '      error_found_flg = 1;';
      put "      COLUMN_NM = '" COLUMN_NM "';";
      put "      ERROR_MESSAGE_TXT = '" ERROR_MESSAGE_TXT "';";
      put "      FAILURE_CHECK_TXT = '" FAILURE_CHECK_TXT "';";
      put "      GROUP_ID = '" GROUP_ID "';";
      length put_column_value $64;
      if lowcase(data_type) eq 'num' then do;
         put_column_value = 'trim(left(put(' || trim(COLUMN_NM) || ', best.)))';
      end;
      else put_column_value = 'trim(' || trim(COLUMN_NM) || ')';
      %if (%superq(OUT_DS_ERRORS) ne ) %then %do;
         length put_column_value2 $1024;
         put_column_value2 = '      COLUMN_VALUE = "' || trim(COLUMN_NM) || '=" || ' || trim(put_column_value) || ';';
         put put_column_value2;
      %end;
      /*put '      call execute(''%rsk_print_msg(rsk_data_check_failure_warning, %str('' || trim(ERROR_MESSAGE_TXT) || ''), ' LIBRARY_NM ', ' TABLE_NM ', %str(%trim(' COLUMN_NM ')='' || ' put_column_value ' || ''), '' || ' index_put_string ' || '')'');';*/
      put '      output;';
      put '   end;';

      /* End the data step */
      /* If we are outputting the results, then append the new set of violators to the existing one */
      if last.TABLE_NM then do;
         put ' run;';
         %if (%superq(OUT_DS_ERRORS) ne ) %then %do;
            put "proc append base=error_temp data=append_errors force; run;";
         %end;
      end;
   run;
   %inc tempf;
   filename tempf clear;

   /* Check the foreign keys, if requested */
   %if %superq(IN_CHECK_FOREIGN_KEYS_FLG) eq Y %then %do;

      %local dsid error_message rc fk_violation_values;
      %let dsid = %sysfunc(open(&IN_FOREIGN_KEYS));
      %syscall set(dsid);

      /* Loop through rmbabcnf.data_quality_check_foreign_key, checking each foreign key relationship */
      %let rc = %sysfunc(fetch(&dsid));
      %do %while(&rc eq 0);

         /* If a table list is provided, then only check foreign keys for the tables listed */
         %let Child_Entity_Name=%trim(&Child_Entity_Name);
         %if (%superq(IN_TABLE_NM_LIST) eq ) or %index(%str(&IN_TABLE_NM_LIST),&Child_Entity_Name.) ne 0 %then %do;
            %let Child_Library_Name=%trim(&Child_Library_Name);
            %let Parent_Library_Name=%trim(&Parent_Library_Name);

            /* Get a list of violations for the current foreign key and insert them into the error table */
            proc sql noprint;
                     insert     into error_temp
               select     distinct
                                cats("&Child_Attribute_Name.", "=", &Child_Attribute_Name.),
                                cats(&Child_Attribute_Name.),
                                "&Child_Entity_Name.",
                                "&Child_Library_Name.",
                                "&Child_Attribute_Name.",
                                cat('not missing(', strip("&Child_Attribute_Name."), ') and ', strip("&Child_Attribute_Name"), ' not in (select distinct ', strip("&Parent_Attribute_Name."), ' from ', strip("&Parent_Library_Name..&Parent_Entity_Name)")),
                                'Foreign Key Error',
                                'FOREIGN_KEY'
                from &Child_Library_Name..&Child_Entity_Name
                where not missing(&Child_Attribute_Name) and &Child_Attribute_Name not in (select distinct &Parent_Attribute_Name from &Parent_Library_Name..&Parent_Entity_Name);
            quit;
         %end;

         /* Advance to next row in rmbabcnf.data_quality_check_foreign_key */
         %let rc = %sysfunc(fetch(&dsid));
      %end;
      %let rc = %sysfunc(close(&dsid));

   %end;

     data &OUT_DS_ERRORS;
      set error_temp;
   run;

     /* Check for duplicates */
     proc sort data=&IN_CONFIG_PK out=work.CONFIG_PK_AUX;
          by libname memname;
     run;

     data work.CONFIG_PK_AUX (drop=IDXUSAGE);
           length key $256.;
           length named_key $1024.;

           set work.CONFIG_PK_AUX;
           by libname memname;

           retain key;
           retain named_key;

           if first.memname then do;
                key = '';
                named_key = '';
           end;

           key = catx(",", key, name);
           named_key = catx(", ", named_key, "'" || strip(name) || "='," || strip(name)) || ",','";

           if last.memname then output;
     RUN;

     data WORK.CONFIG_PK_AUX;
           set WORK.CONFIG_PK_AUX;
           length sql_query $1024;
           sql_query = cat("proc sql; insert into &OUT_DS_ERRORS. select cats(", strip(named_key), "), '', '",strip(memname), "','",  strip(libname), "', '', '', 'Record is duplicated.', 'DUPLICATE_TEST' from ", strip(libname), ".",  strip(memname), " group by ", strip(key), " having count(*) > 1; quit;");
           call execute(sql_query);
     run;

   /* Delete temporary datasets */
   proc datasets lib=work nolist nodetails;
      delete
        all_columns
         append_errors
         data_quality_check_with_all_info
         data_quality_check_with_datatype
         index_put_string
         error_temp
      ;
   quit;

%mend;
_________________
/*%include "/user/work/alm/srbvaluation/_users/peiras/dq.sas";

%let output_dataset = work.dq_output_v1;
%let dq_config_folder = /user/work/alm/srbvaluation/_users/peiras;

/* declare all libnames required and present in the dataquality config files
libname CDCAPTLS "cdcaptls";
libname CD_ALM "cd_alm";
libname OUTPUTS "/user/work/alm/srbvaluation/20211031/50_Outputs/";*/


/* Creates auxiliary function */
%macro rsk_quote_list(LIST  =,
                      QUOTE =%str(%'),
                      DLM   =%str(,),
                      CASE  =UP);

   %local i TLIST QLIST;

   %let TLIST=%bquote(&LIST);

   %if %upcase(&CASE) = UP %then
      %let TLIST = %qupcase(&TLIST);
   %else %if %upcase(&CASE) = LOW %then
      %let TLIST = %qlowcase(&TLIST);

   %let i=1;

   %do %while(%length(%qscan(&TLIST, &i, %str( ))) GT 0);
      %if %length(&QLIST) EQ 0 %then %do;
         %let QLIST=&QUOTE.%qscan(&TLIST, &i, %str( ))&QUOTE;
      %end;
      %else %do;
         %let QLIST=&QLIST.&QUOTE.%qscan(&TLIST, &i, %str( ))&QUOTE;
      %end;

      %let i=%eval(&i + 1);

      %if %length(%qscan(&TLIST, &i, %str( ))) GT 0 %then %do;
         %let QLIST=&QLIST.&DLM;
      %end;

   %end;

   %unquote(&QLIST)

%mend rsk_quote_list;

/* Execute DQ */
%dq(
    OUT_DS_ERRORS=VDSCTL.VDS_CTL_DATA_QUALITY,
    IN_DQ_CFG_PATH=&MCR_VDS_RUN_CTL_PATH.
);
_________________
PROC EXPORT
	DATA = VDSOUT.VDS_OUT_LEGALP_INSTRUMENTS
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./LEGALP_INSTRUMENTS.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_LEGALP_COUNTERPARTIES
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./LEGALP_COUNTERPARTIES.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_LEGALP_PROTECTIONS
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./LEGALP_PROTECTIONS.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_NATURALP_INSTRUMENTS
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./NATURALP_INSTRUMENTS.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_NATURALP_COUNTERPARTIES
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./NATURALP_COUNTERPARTIES.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_NATURALP_PROTECTIONS
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./NATURALP_PROTECTIONS.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_OFFBAL_INSTRUMENTS
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./OFFBAL_INSTRUMENTS.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_OFFBAL_COUNTERPARTIES
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./OFFBAL_COUNTERPARTIES.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_OFFBAL_PROTECTIONS
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./OFFBAL_PROTECTIONS.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_DERIVATIVES
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./DERIVATIVES.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_DEBT_SECURITIES
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./DEBT_SECURITIES.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSOUT.VDS_OUT_EQUITY_INSTRUMENTS
	OUTFILE = "&MCR_VDS_RUN_OUT_PATH./EQUITY_INSTRUMENTS.CSV"
	DBMS = CSV
	REPLACE;
RUN;

PROC EXPORT
	DATA = VDSCTL.VDS_CTL_DATA_QUALITY
	OUTFILE = "&MCR_VDS_RUN_CTL_PATH./DATA_QUALITY_RESULTS.CSV"
	DBMS = CSV
	REPLACE;
/*	SHEET = "Data Quality Results";*/
RUN;
