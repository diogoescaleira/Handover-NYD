/*******************************************************************************************************************************************
****   Projeto: Certificação Bail-In                                                                          						    ****
****   Autor: Neyond                                                                                                                    ****
****   Data: 05/11/2025                                                                                                                 ****
****   SQL Script Descrição: Simulação da Tabela B0200       																		    ****
********************************************************************************************************************************************/

/*=========================================================================================================================================*/
/*  1. XXX                                                                       			                                               */
/*=========================================================================================================================================*/



/*********************************************************************************************************/

/*AUX PDS*/
/*B0200_MAIN_LIABILITIES*/
SELECT 
SUM(v_1_0001) AS B0200_LVL1_H_0010_row_nmbr,
SUM(v_1_0002) AS B0200_LVL1_H_0030_uniq_id_knwn_cntrprty,
SUM(v_1_0003) AS B0200_LVL1_H_0040_typ_uniq_id_knwn_cntrprty,
SUM(v_1_0004) AS B0200_LVL1_H_0070_cntrct_crrncy,
SUM(v_1_0005) AS B0200_LVL1_H_0080_otstndng_prncpl_amnt,
SUM(v_1_0006) AS B0200_LVL1_W_0080_otstndng_prncpl_amnt,
SUM(v_1_0007) AS B0200_LVL1_H_0090_prtn_amnt_rprtng_entty,
SUM(v_1_0008) AS B0200_LVL1_H_0100_accrd_intrst_instrmnt,
SUM(v_1_0009) AS B0200_LVL1_W_0100_accrd_intrst_instrmnt,
SUM(v_1_0010) AS B0200_LVL1_H_0120_otstndng_amnt,
SUM(v_1_0011) AS B0200_LVL1_W_0120_otstndng_amnt,
SUM(v_1_0012) AS B0200_LVL1_H_0130_rlvnt_amnt_wdc,
SUM(v_1_0013) AS B0200_LVL1_H_0140_ntr_lblty,
SUM(v_1_0014) AS B0200_LVL1_H_0141_ntr_lblty_othr,
SUM(v_1_0015) AS B0200_LVL1_H_0160_rank_insolv,
SUM(v_1_0016) AS B0200_LVL1_H_0162_bail_in_cascade,
SUM(v_1_0017) AS B0200_LVL1_H_0180_dt_nxt_intrst_pymnt,
SUM(v_1_0018) AS B0200_LVL1_W_0180_dt_nxt_intrst_pymnt,
SUM(v_1_0019) AS B0200_LVL1_W_0200_dt_erlst_rdmptn,
SUM(v_1_0020) AS B0200_LVL1_H_0210_dt_lgl_fnl_mtrty,
SUM(v_1_0021) AS B0200_LVL1_H_0220_governing_law,
SUM(v_1_0022) AS B0200_LVL1_H_0250_strctrd_prdct,
SUM(v_1_0023) AS B0200_LVL1_W_0260_grntd_min_amnt_strctrd_prdct,
SUM(v_1_0024) AS B0200_LVL1_H_0270_fv_amnt_strctrd_prdct,
SUM(v_1_0025) AS B0200_LVL1_H_0300_amnt_cvrd_elgbl_dpsts,
SUM(v_1_0026) AS B0200_LVL1_H_0310_flg_clltrl_agrmnts,
SUM(v_1_0027) AS B0200_LVL1_H_0320_amnt_clltrl,
SUM(v_1_0028) AS B0200_LVL1_H_0330_amnt_unclltrlzd,
SUM(v_1_0029) AS B0200_LVL1_H_0350_typ_clltrl,
SUM(v_1_0030) AS B0200_LVL1_H_0351_typ_clltrl_othr,
SUM(v_1_0031) AS B0200_LVL1_H_0370_amnt_scrty_eur,
SUM(v_1_0032) AS B0200_LVL1_W_0370_amnt_scrty_eur,
SUM(v_1_0033) AS B0200_LVL1_H_0390_nmbr_scrts_not_rprtng_entty,
SUM(v_1_0034) AS B0200_LVL1_H_0391_nmbr_scrts_rprtng_entty,
SUM(v_1_0035) AS B0200_LVL1_H_0400_accrd_intrst_scrty,
SUM(v_1_0036) AS B0200_LVL1_W_0400_accrd_intrst_scrty,
SUM(v_1_0037) AS B0200_LVL1_W_0610_crryng_amnt_ifrs,
--SUM(v_1_0038)  
-9999 AS B0200_LVL1_H_5000_flg_shrhldr_not_rsltn_grp, /*depend on B99*/
--SUM(v_1_0039)  
-9999 AS B0200_LVL1_H_5010_flg_art21_7a_srmr, /*depend on B99*/
SUM(v_2_0001) AS B0200_LVL2_H_0030_uniq_id_knwn_cntrprty,
SUM(v_2_0003) AS B0200_LVL2_H_0070_cntrct_crrncy,
SUM(v_2_0004) AS B0200_LVL2_W_0080_otstndng_prncpl_amnt,
SUM(v_2_0005) AS B0200_LVL2_H_0090_prtn_amnt_rprtng_entty,
SUM(v_2_0006) AS B0200_LVL2_W_0100_accrd_intrst_instrmnt,
SUM(v_2_0007) AS B0200_LVL2_W_0110_applcbl_fees_charges,
SUM(v_2_0008) AS B0200_LVL2_H_0120_otstndng_amnt_1,
SUM(v_2_0009) AS B0200_LVL2_H_0120_otstndng_amnt_2,
SUM(v_2_0011) AS B0200_LVL2_H_0130_rlvnt_amnt_wdc_1,
SUM(v_2_0012) AS B0200_LVL2_H_0130_rlvnt_amnt_wdc_2,
SUM(v_2_0013) AS B0200_LVL2_H_0140_ntr_lblty,
SUM(v_2_0014) AS B0200_LVL2_H_0160_rank_insolv,
SUM(v_2_0015) AS B0200_LVL2_H_0170_dt_incptn_1,
SUM(v_2_0016) AS B0200_LVL2_H_0170_dt_incptn_2,
SUM(v_2_0017) AS B0200_LVL2_H_0180_dt_nxt_intrst_pymnt_1,
--SUM(v_2_0018)  
-9999 AS B0200_LVL2_H_0180_dt_nxt_intrst_pymnt_2, /*depend on B99*/
SUM(v_2_0019) AS B0200_LVL2_H_0200_dt_erlst_rdmptn_1,
--SUM(v_2_0020) 
-9999 AS B0200_LVL2_H_0200_dt_erlst_rdmptn_2, /*depend on B99*/	
SUM(v_2_0021) AS B0200_LVL2_H_0210_dt_lgl_fnl_mtrty_1,
--SUM(v_2_0022)  
-9999 AS B0200_LVL2_H_0210_dt_lgl_fnl_mtrty_2, /*depend on B99*/
SUM(v_2_0023) AS B0200_LVL2_H_0220_governing_law,
SUM(v_2_0024) AS B0200_LVL2_H_0230_bail_in_rcgntn_cls,
SUM(v_2_0025) AS B0200_LVL2_H_0250_strctrd_prdct,
SUM(v_2_0026) AS B0200_LVL2_H_0310_flg_clltrl_agrmnts,
SUM(v_2_0027) AS B0200_LVL2_H_0330_amnt_unclltrlzd_1,
SUM(v_2_0028) AS B0200_LVL2_H_0330_amnt_unclltrlzd_2,
SUM(v_2_0029) AS B0200_LVL2_H_0350_typ_clltrl_1,
SUM(v_2_0030) AS B0200_LVL2_H_0350_typ_clltrl_2,
SUM(v_2_0031) AS B0200_LVL2_H_0440_ntr_glbl_nt,
SUM(v_2_0032) AS B0200_LVL2_H_0530_typ_own_fnds_ind_lvl,
SUM(v_2_0033) AS B0200_LVL2_H_0540_elgbl_amnt_own_fnds_ind_lvl,
SUM(v_2_0034) AS B0200_LVL2_H_0550_typ_own_fnds_cnsldtd_lvl,
SUM(v_2_0035) AS B0200_LVL2_H_0560_elgbl_amnt_own_fnds_cnsldtd_lvl,
SUM(v_2_0036) AS B0200_LVL2_H_0590_typ_scrty_intrst_prvdd,
SUM(v_2_0037) AS B0200_LVL2_H_0610_crryng_amnt_ifrs,
SUM(v_2_0038) AS B0200_LVL2_H_0620_blnc_sht_ifrs,
SUM(FRMT_0010_row_nmbr) AS `B0200_FRMT_0010_row_nmbr`,
SUM(FRMT_0020_uniq_id) AS `B0200_FRMT_0020_uniq_id`,
SUM(FRMT_0030_uniq_id_knwn_cntrprty) AS `B0200_FRMT_0030_uniq_id_knwn_cntrprty`,
SUM(FRMT_0040_typ_uniq_id_knwn_cntrprty) AS `B0200_FRMT_0040_typ_uniq_id_knwn_cntrprty`,
SUM(FRMT_0050_orgnl_amnt_eur) AS `B0200_FRMT_0050_orgnl_amnt_eur`,
SUM(FRMT_0060_orgnl_amnt_fx) AS `B0200_FRMT_0060_orgnl_amnt_fx`,
SUM(FRMT_0070_cntrct_crrncy) AS `B0200_FRMT_0070_cntrct_crrncy`,
SUM(FRMT_0080_otstndng_prncpl_amnt) AS `B0200_FRMT_0080_otstndng_prncpl_amnt`,
SUM(FRMT_0090_prtn_amnt_rprtng_entty) AS `B0200_FRMT_0090_prtn_amnt_rprtng_entty`,
SUM(FRMT_0100_accrd_intrst_instrmnt) AS `B0200_FRMT_0100_accrd_intrst_instrmnt`,
SUM(FRMT_0110_applcbl_fees_charges) AS `B0200_FRMT_0110_applcbl_fees_charges`,
SUM(FRMT_0120_otstndng_amnt) AS `B0200_FRMT_0120_otstndng_amnt`,
SUM(FRMT_0130_rlvnt_amnt_wdc) AS `B0200_FRMT_0130_rlvnt_amnt_wdc`,
SUM(FRMT_0140_ntr_lblty) AS `B0200_FRMT_0140_ntr_lblty`,
SUM(FRMT_0141_ntr_lblty_othr) AS `B0200_FRMT_0141_ntr_lblty_othr`,
SUM(FRMT_0150_flg_strctrlly_sbrdntd) AS `B0200_FRMT_0150_flg_strctrlly_sbrdntd`,
SUM(FRMT_0160_rank_insolv) AS `B0200_FRMT_0160_rank_insolv`,
SUM(FRMT_0161_cntrctl_sbrdntn) AS `B0200_FRMT_0161_cntrctl_sbrdntn`,
SUM(FRMT_0162_bail_in_cascade) AS `B0200_FRMT_0162_bail_in_cascade`,
SUM(FRMT_0170_dt_incptn) AS `B0200_FRMT_0170_dt_incptn`,
SUM(FRMT_0180_dt_nxt_intrst_pymnt) AS `B0200_FRMT_0180_dt_nxt_intrst_pymnt`,
SUM(FRMT_0190_dt_nxt_rdmptn_pymnt) AS `B0200_FRMT_0190_dt_nxt_rdmptn_pymnt`,
SUM(FRMT_0200_dt_erlst_rdmptn) AS `B0200_FRMT_0200_dt_erlst_rdmptn`,
SUM(FRMT_0210_dt_lgl_fnl_mtrty) AS `B0200_FRMT_0210_dt_lgl_fnl_mtrty`,
SUM(FRMT_0220_governing_law) AS `B0200_FRMT_0220_governing_law`,
SUM(FRMT_0230_bail_in_rcgntn_cls) AS `B0200_FRMT_0230_bail_in_rcgntn_cls`,
SUM(FRMT_0240_zero_coupon) AS `B0200_FRMT_0240_zero_coupon`,
SUM(FRMT_0250_strctrd_prdct) AS `B0200_FRMT_0250_strctrd_prdct`,
SUM(FRMT_0260_grntd_min_amnt_strctrd_prdct) AS `B0200_FRMT_0260_grntd_min_amnt_strctrd_prdct`,
SUM(FRMT_0270_fv_amnt_strctrd_prdct) AS `B0200_FRMT_0270_fv_amnt_strctrd_prdct`,
SUM(FRMT_0280_flg_ncnp_dpsts) AS `B0200_FRMT_0280_flg_ncnp_dpsts`,
SUM(FRMT_0290_flg_ncbp_dpsts) AS `B0200_FRMT_0290_flg_ncbp_dpsts`,
SUM(FRMT_0300_amnt_cvrd_elgbl_dpsts) AS `B0200_FRMT_0300_amnt_cvrd_elgbl_dpsts`,
SUM(FRMT_0310_flg_clltrl_agrmnts) AS `B0200_FRMT_0310_flg_clltrl_agrmnts`,
SUM(FRMT_0320_amnt_clltrl) AS `B0200_FRMT_0320_amnt_clltrl`,
SUM(FRMT_0330_amnt_unclltrlzd) AS `B0200_FRMT_0330_amnt_unclltrlzd`,
SUM(FRMT_0340_id_clltrl) AS `B0200_FRMT_0340_id_clltrl`,
SUM(FRMT_0350_typ_clltrl) AS `B0200_FRMT_0350_typ_clltrl`,
SUM(FRMT_0351_typ_clltrl_othr) AS `B0200_FRMT_0351_typ_clltrl_othr`,
SUM(FRMT_0360_trdng_mthd) AS `B0200_FRMT_0360_trdng_mthd`,
SUM(FRMT_0370_amnt_scrty_eur) AS `B0200_FRMT_0370_amnt_scrty_eur`,
SUM(FRMT_0380_amnt_scrty_fx) AS `B0200_FRMT_0380_amnt_scrty_fx`,
SUM(FRMT_0390_nmbr_scrts_not_rprtng_entty) AS `B0200_FRMT_0390_nmbr_scrts_not_rprtng_entty`,
SUM(FRMT_0391_nmbr_scrts_rprtng_entty) AS `B0200_FRMT_0391_nmbr_scrts_rprtng_entty`,
SUM(FRMT_0400_accrd_intrst_scrty) AS `B0200_FRMT_0400_accrd_intrst_scrty`,
SUM(FRMT_0410_fees_charges_scrty) AS `B0200_FRMT_0410_fees_charges_scrty`,
SUM(FRMT_0420_fv_amnt_scrty) AS `B0200_FRMT_0420_fv_amnt_scrty`,
SUM(FRMT_0430_prncpl_amnt_glbl_nt_eur) AS `B0200_FRMT_0430_prncpl_amnt_glbl_nt_eur`,
SUM(FRMT_0431_prncpl_amnt_glbl_nt_fx) AS `B0200_FRMT_0431_prncpl_amnt_glbl_nt_fx`,
SUM(FRMT_0440_ntr_glbl_nt) AS `B0200_FRMT_0440_ntr_glbl_nt`,
SUM(FRMT_0450_crrnt_pool_fctr) AS `B0200_FRMT_0450_crrnt_pool_fctr`,
SUM(FRMT_0460_csd) AS `B0200_FRMT_0460_csd`,
SUM(FRMT_0461_csd_lei) AS `B0200_FRMT_0461_csd_lei`,
SUM(FRMT_0462_csd_othr) AS `B0200_FRMT_0462_csd_othr`,
SUM(FRMT_0470_pyng_agnt) AS `B0200_FRMT_0470_pyng_agnt`,
SUM(FRMT_0471_pyng_agnt_lei) AS `B0200_FRMT_0471_pyng_agnt_lei`,
SUM(FRMT_0480_trdng_vn) AS `B0200_FRMT_0480_trdng_vn`,
SUM(FRMT_0481_trdng_vn_lei) AS `B0200_FRMT_0481_trdng_vn_lei`,
SUM(FRMT_0490_rgstrr) AS `B0200_FRMT_0490_rgstrr`,
SUM(FRMT_0491_rgstrr_lei) AS `B0200_FRMT_0491_rgstrr_lei`,
SUM(FRMT_0500_nna) AS `B0200_FRMT_0500_nna`,
SUM(FRMT_0501_nna_lei) AS `B0200_FRMT_0501_nna_lei`,
SUM(FRMT_0510_cmmn_dpstry) AS `B0200_FRMT_0510_cmmn_dpstry`,
SUM(FRMT_0511_cmmn_dpstry_lei) AS `B0200_FRMT_0511_cmmn_dpstry_lei`,
SUM(FRMT_0520_cmmn_srvc_prvdr) AS `B0200_FRMT_0520_cmmn_srvc_prvdr`,
SUM(FRMT_0521_cmmn_srvc_prvdr_lei) AS `B0200_FRMT_0521_cmmn_srvc_prvdr_lei`,
SUM(FRMT_0530_typ_own_fnds_ind_lvl) AS `B0200_FRMT_0530_typ_own_fnds_ind_lvl`,
SUM(FRMT_0540_elgbl_amnt_own_fnds_ind_lvl) AS `B0200_FRMT_0540_elgbl_amnt_own_fnds_ind_lvl`,
SUM(FRMT_0550_typ_own_fnds_cnsldtd_lvl) AS `B0200_FRMT_0550_typ_own_fnds_cnsldtd_lvl`,
SUM(FRMT_0560_elgbl_amnt_own_fnds_cnsldtd_lvl) AS `B0200_FRMT_0560_elgbl_amnt_own_fnds_cnsldtd_lvl`,
SUM(FRMT_0570_amnt_scrty_intrst_prvdd) AS `B0200_FRMT_0570_amnt_scrty_intrst_prvdd`,
SUM(FRMT_0580_scrty_intrst_prvdr) AS `B0200_FRMT_0580_scrty_intrst_prvdr`,
SUM(FRMT_0581_scrty_intrst_prvdr_lei) AS `B0200_FRMT_0581_scrty_intrst_prvdr_lei`,
SUM(FRMT_0590_typ_scrty_intrst_prvdd) AS `B0200_FRMT_0590_typ_scrty_intrst_prvdd`,
SUM(FRMT_0600_flg_clltrl_asst_pstn) AS `B0200_FRMT_0600_flg_clltrl_asst_pstn`,
SUM(FRMT_0610_crryng_amnt_ifrs) AS `B0200_FRMT_0610_crryng_amnt_ifrs`,
SUM(FRMT_0620_blnc_sht_ifrs) AS `B0200_FRMT_0620_blnc_sht_ifrs`,
SUM(FRMT_0630_crrying_amnt_ngaap) AS `B0200_FRMT_0630_crrying_amnt_ngaap`,
SUM(FRMT_0640_blnc_sht_ngaap) AS `B0200_FRMT_0640_blnc_sht_ngaap`,
SUM(FRMT_5000_flg_shrhldr_not_rsltn_grp) AS `B0200_FRMT_5000_flg_shrhldr_not_rsltn_grp`,
SUM(FRMT_5010_flg_art21_7a_srmr) AS `B0200_FRMT_5010_flg_art21_7a_srmr`

FROM (SELECT *
    ,CASE WHEN `0010_row_nmbr` IS NULL or cast(`0010_row_nmbr` as string)='' THEN 1 ELSE 0 END AS v_1_0001
    ,CASE WHEN `0030_uniq_id_knwn_cntrprty` = '' THEN 1 ELSE 0 END AS v_1_0002
    ,CASE WHEN `0040_typ_uniq_id_knwn_cntrprty` = '' THEN 1 ELSE 0 END AS v_1_0003
    ,CASE WHEN `0070_cntrct_crrncy` = '' THEN 1 ELSE 0 END AS v_1_0004
    ,CASE WHEN (`0080_otstndng_prncpl_amnt` IS NULL OR CAST(`0080_otstndng_prncpl_amnt` AS STRING) = '') AND `0250_strctrd_prdct` IN ('Non-Structured/Vanilla', 'Other non-standard terms') THEN 1 ELSE 0 END AS v_1_0005
    ,CASE WHEN (`0080_otstndng_prncpl_amnt` IS NULL OR CAST(`0080_otstndng_prncpl_amnt` AS STRING) = '') AND `0250_strctrd_prdct` IN ('Structured', 'Only structured coupon') THEN 1 ELSE 0 END AS v_1_0006
    ,CASE WHEN (`0090_prtn_amnt_rprtng_entty` IS NULL OR CAST(`0090_prtn_amnt_rprtng_entty` AS STRING) = '') AND `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' THEN 1 ELSE 0 END AS v_1_0007
    ,CASE WHEN (`0100_accrd_intrst_instrmnt` IS NULL OR CAST(`0100_accrd_intrst_instrmnt` AS STRING) = '') AND `0250_strctrd_prdct` IN ('Non-Structured', 'Other non-standard terms') AND `0240_zero_coupon` != 'ZCB issued at discount' THEN 1 ELSE 0 END AS v_1_0008
    ,CASE WHEN (`0100_accrd_intrst_instrmnt` IS NULL OR CAST(`0100_accrd_intrst_instrmnt` AS STRING) = '') AND `0250_strctrd_prdct` IN ('Structured', 'Only structured coupon') THEN 1 ELSE 0 END AS v_1_0009
    ,CASE WHEN (`0120_otstndng_amnt` IS NULL OR CAST(`0120_otstndng_amnt` AS STRING) = '') AND `0250_strctrd_prdct` IN ('Non-Structured/Vanilla', 'Other non-standard terms') THEN 1 ELSE 0 END AS v_1_0010
    ,CASE WHEN (`0120_otstndng_amnt` IS NULL OR CAST(`0120_otstndng_amnt` AS STRING) = '') AND `0250_strctrd_prdct` NOT IN ('Structured', 'Only structured coupon') THEN 1 ELSE 0 END AS v_1_0011
    ,CASE WHEN `0130_rlvnt_amnt_wdc` IS NULL OR CAST(`0130_rlvnt_amnt_wdc` AS STRING) = '' THEN 1 ELSE 0 END AS v_1_0012
    ,CASE WHEN `0140_ntr_lblty` is null or `0140_ntr_lblty` = '' THEN 1 ELSE 0 END AS v_1_0013
    ,CASE WHEN (`0141_ntr_lblty_othr` is null or `0141_ntr_lblty_othr` = '') AND `0140_ntr_lblty` = 'Other' THEN 1 ELSE 0 END AS v_1_0014
    ,CASE WHEN `0160_rank_insolv` IS NULL OR CAST(`0160_rank_insolv` AS STRING)='' THEN 1 ELSE 0 END AS v_1_0015
    ,CASE WHEN `0162_bail_in_cascade` IS NULL OR CAST(`0162_bail_in_cascade` AS STRING) = '' THEN 1 ELSE 0 END AS v_1_0016
    ,CASE WHEN (`0180_dt_nxt_intrst_pymnt` is null or `0180_dt_nxt_intrst_pymnt` = '') AND `0250_strctrd_prdct` IN ('Non-Structured/Vanilla', 'Other non-standard terms') AND `0240_zero_coupon` != 'ZCB issued at discount' THEN 1 ELSE 0 END AS v_1_0017
    ,CASE WHEN (`0180_dt_nxt_intrst_pymnt` = '' or `0180_dt_nxt_intrst_pymnt` is null) AND `0250_strctrd_prdct` NOT IN ('Structured', 'Only structured coupon') THEN 1 ELSE 0 END AS v_1_0018
    ,CASE WHEN `0200_dt_erlst_rdmptn` = '' or `0200_dt_erlst_rdmptn` is null THEN 1 ELSE 0 END AS v_1_0019
    ,CASE WHEN (`0210_dt_lgl_fnl_mtrty` = '' or `0210_dt_lgl_fnl_mtrty` is null) AND `0140_ntr_lblty` != 'Cash account/saving account' THEN 1 ELSE 0 END AS v_1_0020
    ,CASE WHEN `0220_governing_law` = '' or `0220_governing_law` is null THEN 1 ELSE 0 END AS v_1_0021
    ,CASE WHEN `0250_strctrd_prdct` = '' or `0250_strctrd_prdct` is null THEN 1 ELSE 0 END AS v_1_0022
    ,CASE WHEN (`0260_grntd_min_amnt_strctrd_prdct` IS NULL or cast(`0260_grntd_min_amnt_strctrd_prdct` as string) ='') AND `0250_strctrd_prdct` IN ('Structured', 'Only structured coupon') THEN 1 ELSE 0 END AS v_1_0023
    ,CASE WHEN (`0270_fv_amnt_strctrd_prdct` IS NULL or cast(`0270_fv_amnt_strctrd_prdct` as string) = '') AND `0250_strctrd_prdct` IN ('Structured', 'Only structured coupon') THEN 1 ELSE 0 END AS v_1_0024
    ,CASE WHEN (`0300_amnt_cvrd_elgbl_dpsts` IS NULL or cast(`0300_amnt_cvrd_elgbl_dpsts` as string) = '') AND (`0280_flg_ncnp_dpsts` = 'TRUE' or `0290_flg_ncbp_dpsts` = 'TRUE') THEN 1 ELSE 0 END AS v_1_0025
    ,CASE WHEN (`0310_flg_clltrl_agrmnts` = '' or cast(`0310_flg_clltrl_agrmnts` as string) = '')THEN 1 ELSE 0 END AS v_1_0026
    ,CASE WHEN (`0320_amnt_clltrl` IS NULL or cast(`0320_amnt_clltrl` as string) ='') AND `0310_flg_clltrl_agrmnts` = 'Secured' THEN 1 ELSE 0 END AS v_1_0027
    ,CASE WHEN (`0330_amnt_unclltrlzd` IS NULL or cast(`0330_amnt_unclltrlzd` as string)='') AND `0310_flg_clltrl_agrmnts` = 'Secured' THEN 1 ELSE 0 END AS v_1_0028
    ,CASE WHEN (`0350_typ_clltrl` = '' or cast(`0350_typ_clltrl` as string)='') AND `0310_flg_clltrl_agrmnts` = 'Secured' THEN 1 ELSE 0 END AS v_1_0029
    ,CASE WHEN (`0351_typ_clltrl_othr` = '' or cast(`0351_typ_clltrl_othr` as string)='') AND `0350_typ_clltrl` = 'Other' THEN 1 ELSE 0 END AS v_1_0030
    ,CASE WHEN (`0370_amnt_scrty_eur` IS NULL or cast(`0370_amnt_scrty_eur` as string) ='') AND `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' AND `0360_trdng_mthd` = 'Nominal' THEN 1 ELSE 0 END AS v_1_0031
    ,CASE WHEN (`0370_amnt_scrty_eur` IS NULL or cast(`0370_amnt_scrty_eur` as string) ='') AND `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' AND `0360_trdng_mthd` = 'Unit' THEN 1 ELSE 0 END AS v_1_0032
    ,CASE WHEN (`0390_nmbr_scrts_not_rprtng_entty` IS NULL or cast(`0390_nmbr_scrts_not_rprtng_entty` as string) = '') AND `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' THEN 1 ELSE 0 END AS v_1_0033
    ,CASE WHEN (`0391_nmbr_scrts_rprtng_entty` IS NULL or cast(`0391_nmbr_scrts_rprtng_entty` as string)='') AND `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' THEN 1 ELSE 0 END AS v_1_0034
    ,CASE WHEN (`0400_accrd_intrst_scrty` IS NULL or cast(`0400_accrd_intrst_scrty` as string)='') AND `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' AND `0250_strctrd_prdct` IN ('Non-Structured/Vanilla', 'Other non-standard terms') AND `0240_zero_coupon` != 'ZCB issued at discount' THEN 1 ELSE 0 END AS v_1_0035
    ,CASE WHEN (`0400_accrd_intrst_scrty` IS NULL or cast(`0400_accrd_intrst_scrty` as string)='') AND `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' AND `0250_strctrd_prdct` NOT IN ('Structured', 'Only structured coupon') THEN 1 ELSE 0 END AS v_1_0036
    ,CASE WHEN (`0610_crryng_amnt_ifrs` IS NULL or cast(`0610_crryng_amnt_ifrs` as string)='') THEN 1 ELSE 0 END AS v_1_0037
--	,CASE WHEN (`5000_flg_shrhldr_not_rsltn_grp` IS MISSING or cast(`5000_flg_shrhldr_not_rsltn_grp` as string) = '') AND B99.`0060_orgnl_amnt_fx` = 'Non-Resolution Entity' THEN 1 ELSE 0 END AS v_1_0038
--	,CASE WHEN (`5000_flg_shrhldr_not_rsltn_grp` IS MISSING or cast(`5000_flg_shrhldr_not_rsltn_grp` as string) = '') AND B99.`0060_orgnl_amnt_fx` = 'Non-Resolution Entity' THEN 1 ELSE 0 END AS v_1_0039
    
    ,CASE WHEN `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' AND LENGTH(`0030_uniq_id_knwn_cntrprty`) <= 12 AND SUBSTR(`0030_uniq_id_knwn_cntrprty`, 1, 2) RLIKE '[A-Za-z]$' THEN 0 ELSE 1 END AS v_2_0001
    ,CASE WHEN `0020_uniq_id` NOT IN ('NCNP', 'NCBP') AND `0070_cntrct_crrncy` NOT IN ('AFN', 'EUR', 'ALL', 'DZD', 'USD', 'EUR', 'AOA', 'XCD', 'XCD', 'XAD', 'ARS', 'AMD', 'AWG', 'AUD', 'EUR', 'AZN', 'BSD', 'BHD', 'BDT', 'BBD', 'BYN', 'EUR', 'BZD', 'XOF', 'BMD', 'INR', 'BTN', 'BOB', 'BOV', 'USD', 'BAM', 'BWP', 'NOK', 'BRL', 'USD', 'BND', 'BGN', 'XOF', 'BIF', 'CVE', 'KHR', 'XAF', 'CAD', 'KYD', 'XAF', 'XAF', 'CLP', 'CLF', 'CNY', 'CNH', 'AUD', 'AUD', 'COP', 'COU', 'KMF', 'CDF', 'XAF', 'NZD', 'CRC', 'XOF', 'EUR', 'CUP', 'XCG', 'EUR', 'CZK', 'DKK', 'DJF', 'XCD', 'DOP', 'USD', 'EGP', 'SVC', 'USD', 'XAF', 'ERN', 'EUR', 'SZL', 'ETB', 'EUR', 'FKP', 'DKK', 'FJD', 'EUR', 'EUR', 'EUR', 'XPF', 'EUR', 'XAF', 'GMD', 'GEL', 'EUR', 'GHS', 'GIP', 'EUR', 'DKK', 'XCD', 'EUR', 'USD', 'GTQ', 'GBP', 'GNF', 'XOF', 'GYD', 'HTG', 'USD', 'AUD', 'EUR', 'HNL', 'HKD', 'HUF', 'ISK', 'INR', 'IDR', 'XDR', 'IRR', 'IQD', 'EUR', 'GBP', 'ILS', 'EUR', 'JMD', 'JPY', 'GBP', 'JOD', 'KZT', 'KES', 'AUD', 'KPW', 'KRW', 'KWD', 'KGS', 'LAK', 'EUR', 'LBP', 'LSL', 'ZAR', 'LRD', 'LYD', 'CHF', 'EUR', 'EUR', 'MOP', 'MGA', 'MWK', 'MYR', 'MVR', 'XOF', 'EUR', 'USD', 'EUR', 'MRU', 'MUR', 'EUR', 'XUA', 'MXN', 'MXV', 'USD', 'MDL', 'EUR', 'MNT', 'EUR', 'XCD', 'MAD', 'MZN', 'MMK', 'NAD', 'ZAR', 'AUD', 'NPR', 'EUR', 'XPF', 'NZD', 'NIO', 'XOF', 'NGN', 'NZD', 'AUD', 'MKD', 'USD', 'NOK', 'OMR', 'PKR', 'USD', 'PAB', 'USD', 'PGK', 'PYG', 'PEN', 'PHP', 'NZD', 'PLN', 'EUR', 'USD', 'QAR', 'EUR', 'RON', 'RUB', 'RWF', 'EUR', 'SHP', 'XCD', 'XCD', 'EUR', 'EUR', 'XCD', 'WST', 'EUR', 'STN', 'SAR', 'XOF', 'RSD', 'SCR', 'SLE', 'SGD', 'XCG', 'XSU', 'EUR', 'EUR', 'SBD', 'SOS', 'ZAR', 'SSP', 'EUR', 'LKR', 'SDG', 'SRD', 'NOK', 'SEK', 'CHF', 'CHE', 'CHW', 'SYP', 'TWD', 'TJS', 'TZS', 'THB', 'USD', 'XOF', 'NZD', 'TOP', 'TTD', 'TND', 'TRY', 'TMT', 'USD', 'AUD', 'UGX', 'UAH', 'AED', 'GBP', 'USD', 'USD', 'USN', 'UYU', 'UYI', 'UYW', 'UZS', 'VUV', 'VES', 'VED', 'VND', 'USD', 'USD', 'XPF', 'MAD', 'YER', 'ZMW', 'ZWG', 'XBA', 'XBB', 'XBC', 'XBD', 'XTS', 'XXX', 'XAU', 'XPD', 'XPT', 'XAG') THEN 1 ELSE 0 END AS v_2_0003
    ,CASE WHEN `0080_otstndng_prncpl_amnt` <= 0 THEN 1 ELSE 0 END AS v_2_0004
    ,CASE WHEN `0090_prtn_amnt_rprtng_entty` <0 AND `0040_typ_uniq_id_knwn_cntrprty` = 'ISIN' THEN 1 ELSE 0 END AS v_2_0005
    ,CASE WHEN `0100_accrd_intrst_instrmnt` <0 THEN 1 ELSE 0 END AS v_2_0006
    ,CASE WHEN `0110_applcbl_fees_charges` < 0 THEN 1 ELSE 0 END AS v_2_0007
    ,CASE WHEN `0120_otstndng_amnt` >=0 THEN 0 ELSE 1 END AS v_2_0008
    ,CASE WHEN `0120_otstndng_amnt` != (`0080_otstndng_prncpl_amnt`+`0100_accrd_intrst_instrmnt`+`0110_applcbl_fees_charges`) THEN 1 ELSE 0 END AS v_2_0009
    ,CASE WHEN `0130_rlvnt_amnt_wdc` != GREATEST(0, `0120_otstndng_amnt`-`0300_amnt_cvrd_elgbl_dpsts`-`0320_amnt_clltrl`) AND `0250_strctrd_prdct` IN ('Non-structured/Vanilla', 'Other non-standard terms') AND `0240_zero_coupon` != 'ZCB issued at discount' THEN 1 ELSE 0 END AS v_2_0011
    ,CASE WHEN `0130_rlvnt_amnt_wdc` != GREATEST(0, `0270_fv_amnt_strctrd_prdct`-`0300_amnt_cvrd_elgbl_dpsts`-`0320_amnt_clltrl`) AND `0130_rlvnt_amnt_wdc` != GREATEST(0, `0120_otstndng_amnt`-`0300_amnt_cvrd_elgbl_dpsts`-`0320_amnt_clltrl`) AND `0250_strctrd_prdct` IN ('Structured', 'Structured coupon only') THEN 1 ELSE 0 END AS v_2_0012
    ,CASE WHEN `0140_ntr_lblty` NOT IN ('Registered Bond', 'Bearer Bond', 'Borrower Note Loan', 'Certificate of Deposit / Commercial paper', 'Title of ownership', 'Cash account/saving account', 'Term deposit', 'Loan', 'Bill of exchange ', 'Other') THEN 1 ELSE 0 END AS v_2_0013
    ,CASE WHEN CAST(`0160_rank_insolv` AS STRING) NOT REGEXP '^-?[0-9]+$' THEN 1 ELSE 0 END AS v_2_0014
    ,CASE WHEN `0170_dt_incptn` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP') THEN 1 ELSE 0 END AS v_2_0015
    ,CASE WHEN `0170_dt_incptn` >= `0190_dt_nxt_rdmptn_pymnt` AND `0170_dt_incptn` >= `0200_dt_erlst_rdmptn` AND `0170_dt_incptn` != '0001-01-01' AND (`0190_dt_nxt_rdmptn_pymnt` != '0001-01-01' AND `0200_dt_erlst_rdmptn` != '0001-01-01') AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP') THEN 1 ELSE 0 END AS v_2_0016
    ,CASE WHEN `0180_dt_nxt_intrst_pymnt` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP') THEN 1 ELSE 0 END AS v_2_0017
--    ,CASE WHEN (`0180_dt_nxt_intrst_pymnt` > `0070_cntrct_crrncy` AND `0070_cntrct_crrncy` != '' AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP')) OR `0180_dt_nxt_intrst_pymnt` IN ('0001-01-01', '') THEN 0 ELSE 1 END AS v_2_0018
    ,CASE WHEN `0200_dt_erlst_rdmptn` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP') THEN 1 ELSE 0 END AS v_2_0019
--    ,CASE WHEN (`0200_dt_erlst_rdmptn` > `0070_cntrct_crrncy` AND `0070_cntrct_crrncy` != '' AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP')) OR `0200_dt_erlst_rdmptn` IN ('0001-01-01') THEN 0 ELSE 1 END AS v_2_0020
    ,CASE WHEN `0210_dt_lgl_fnl_mtrty` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP') THEN 1 ELSE 0 END AS v_2_0021
--    ,CASE WHEN `0210_dt_lgl_fnl_mtrty` > `0070_cntrct_crrncy` AND `0070_cntrct_crrncy` != '' AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP') THEN 0 ELSE 1 END AS v_2_0022
    ,CASE WHEN `0020_uniq_id` NOT IN ('NCNP', 'NCBP') AND `0220_governing_law` NOT IN ('AF','AX','AL','DZ','AS','AD','AO','AI','AQ','AG','AR','AM','AW','AU','AT','AZ','BS','BH','BD','BB','BY','BE','BZ','BJ','BM','BT','BO','BQ','BA','BW','BV','BR','IO','BN','BG','BF','BI','CV','KH','CM','CA','KY','CF','TD','CL','CN','CX','CC','CO','KM','CG','CD','CK','CR','CI','HR','CU','CW','CY','CZ','DK','DJ','DM','DO','EC','EG','SV','GQ','ER','EE','SZ','ET','FK','FO','FJ','FI','FR','GF','PF','TF','GA','GM','GE','DE','GH','GI','GR','GL','GD','GP','GU','GT','GG','GN','GW','GY','HT','HM','VA','HN','HK','HU','IS','IN','ID','IR','IQ','IE','IM','IL','IT','JM','JP','JE','JO','KZ','KE','KI','KP','KR','KW','KG','LA','LV','LB','LS','LR','LY','LI','LT','LU','MO','MG','MW','MY','MV','ML','MT','MH','MQ','MR','MU','YT','MX','FM','MD','MC','MN','ME','MS','MA','MZ','MM','NA','NR','NP','NL','NC','NZ','NI','NE','NG','NU','NF','MK','MP','NO','OM','PK','PW','PS','PA','PG','PY','PE','PH','PN','PL','PT','PR','QA','RE','RO','RU','RW','BL','SH','KN','LC','MF','PM','VC','WS','SM','ST','SA','SN','RS','SC','SL','SG','SX','SK','SI','SB','SO','ZA','GS','SS','ES','LK','SD','SR','SJ','SE','CH','SY','TW','TJ','TZ','TH','TL','TG','TK','TO','TT','TN','TR','TM','TC','TV','UG','UA','AE','GB','US','UM','UY','UZ','VU','VE','VN','VG','VI','WF','EH','YE','ZM','ZW') THEN 1 ELSE 0 END AS v_2_0023
    ,CASE WHEN `0230_bail_in_rcgntn_cls` NOT IN ('Yes, supported by Legal Opinion', 'Yes, not supported by Legal Opinion', 'No', 'Not applicable', 'Aggregated') AND `0020_uniq_id` NOT IN ('NCNP', 'NCBP') THEN 1 ELSE 0 END AS v_2_0024
    ,CASE WHEN `0250_strctrd_prdct` NOT IN ('Non-structured/Vanilla', 'Structured', 'Other non-standard terms', 'Only structured coupon', 'Aggregated') THEN 1 ELSE 0 END AS v_2_0025
    ,CASE WHEN `0310_flg_clltrl_agrmnts` NOT IN ('Secured', 'Unsecured') THEN 1 ELSE 0 END AS v_2_0026
    ,CASE WHEN `0330_amnt_unclltrlzd` != GREATEST(0, `0120_otstndng_amnt`-`0320_amnt_clltrl`) AND `0310_flg_clltrl_agrmnts` = 'Secured' AND `0250_strctrd_prdct` IN ('Non-structured/Vanilla', 'Other non-standard terms') AND `0240_zero_coupon` != 'ZCB issued at discount'  THEN 1 ELSE 0 END AS v_2_0027
    ,CASE WHEN (`0330_amnt_unclltrlzd` != GREATEST(0, `0270_fv_amnt_strctrd_prdct`-`0320_amnt_clltrl`) AND `0330_amnt_unclltrlzd` != GREATEST(0, `0120_otstndng_amnt`-`0320_amnt_clltrl`)) AND `0310_flg_clltrl_agrmnts` = 'Secured' AND `0250_strctrd_prdct` IN ('Structured', 'Only structured coupon') AND `0240_zero_coupon` != 'ZCB issued at discount'  THEN 1 ELSE 0 END AS v_2_0028
    ,CASE WHEN `0350_typ_clltrl` NOT IN ('Real estate', 'Ships', 'Aircraft', 'Financial', 'Other', 'Not applicable') THEN 1 ELSE 0 END AS v_2_0029
    ,CASE WHEN `0350_typ_clltrl` != 'Not applicable' AND `0310_flg_clltrl_agrmnts` = 'Unsecured' THEN 1 ELSE 0 END AS v_2_0030
    ,CASE WHEN `0440_ntr_glbl_nt` NOT IN ('NGN', 'CGN', 'Not applicable') THEN 1 ELSE 0 END AS v_2_0031
    ,CASE WHEN `0530_typ_own_fnds_ind_lvl` NOT IN ('T2 in phase-out', 'Grandfathered T2', 'Fully Compliant T2', 'Partially (A)T1 and T2', 'Grandfathered AT1', 'Fully Compliant AT1', 'CET1', 'No') THEN 1 ELSE 0 END AS v_2_0032
    ,CASE WHEN `0540_elgbl_amnt_own_fnds_ind_lvl` < 0 THEN 1 ELSE 0 END AS v_2_0033
    ,CASE WHEN `0550_typ_own_fnds_cnsldtd_lvl` NOT IN ('T2 in phase-out', 'Grandfathered T2', 'Fully Compliant T2', 'Partially (A)T1 and T2', 'Grandfathered AT1', 'Fully Compliant AT1', 'CET1', 'No') THEN 1 ELSE 0 END AS v_2_0034
    ,CASE WHEN `0560_elgbl_amnt_own_fnds_cnsldtd_lvl` < 0 THEN 1 ELSE 0 END AS v_2_0035
    ,CASE WHEN `0590_typ_scrty_intrst_prvdd` NOT IN ('T2 in phase-out', 'Grandfathered T2', 'Fully Compliant T2', 'Partially (A)T1 and T2', 'Grandfathered AT1', 'Fully Compliant AT1', 'CET1', 'No', 'Not applicable') THEN 1 ELSE 0 END AS v_2_0036
    ,CASE WHEN `0610_crryng_amnt_ifrs` < 0 THEN 1 ELSE 0 END AS v_2_0037
    ,CASE WHEN `0620_blnc_sht_ifrs` NOT IN ('010 Financial liabilities held for trading', '070 Financial liabilities at fair value through profit or loss', '110 Financial liabilities at amortized cost', '280 Other liabilities', '300 Total equity') THEN 1 ELSE 0 END AS v_2_0038

    ,CASE WHEN cast(`0010_row_nmbr` as string) RLIKE '^[0-9]+$' AND CAST(`0010_row_nmbr` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0010_row_nmbr
    ,CASE WHEN `0020_uniq_id` RLIKE '[A-Za-z]' and `0020_uniq_id` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0020_uniq_id
    ,CASE WHEN `0030_uniq_id_knwn_cntrprty` RLIKE '[A-Za-z]' and `0030_uniq_id_knwn_cntrprty` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0030_uniq_id_knwn_cntrprty
    ,CASE WHEN `0040_typ_uniq_id_knwn_cntrprty` RLIKE '[A-Za-z]' AND `0040_typ_uniq_id_knwn_cntrprty` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0040_typ_uniq_id_knwn_cntrprty
    ,CASE WHEN (CAST(ROUND(`0050_orgnl_amnt_eur`, 2) AS STRING) = CAST(`0050_orgnl_amnt_eur` AS STRING) AND CAST(`0050_orgnl_amnt_eur` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0050_orgnl_amnt_eur`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0050_orgnl_amnt_eur
    ,CASE WHEN (CAST(ROUND(`0060_orgnl_amnt_fx`, 2) AS STRING) = CAST(`0060_orgnl_amnt_fx` AS STRING) AND CAST(`0060_orgnl_amnt_fx` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0060_orgnl_amnt_fx`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0060_orgnl_amnt_fx
    ,CASE WHEN (LENGTH(`0070_cntrct_crrncy`) = 3 AND `0070_cntrct_crrncy` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable')) OR `0070_cntrct_crrncy`='XXX' THEN 0 ELSE 1 END AS FRMT_0070_cntrct_crrncy
    ,CASE WHEN CAST(ROUND(`0080_otstndng_prncpl_amnt`, 2) AS STRING) = CAST(`0080_otstndng_prncpl_amnt` AS STRING) AND CAST(`0080_otstndng_prncpl_amnt` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0080_otstndng_prncpl_amnt
    ,CASE WHEN (CAST(ROUND(`0090_prtn_amnt_rprtng_entty`, 2) AS STRING) = CAST(`0090_prtn_amnt_rprtng_entty` AS STRING) AND CAST(`0090_prtn_amnt_rprtng_entty` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0090_prtn_amnt_rprtng_entty`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0090_prtn_amnt_rprtng_entty
    ,CASE WHEN (CAST(ROUND(`0100_accrd_intrst_instrmnt`, 2) AS STRING) = CAST(`0100_accrd_intrst_instrmnt` AS STRING) AND CAST(`0100_accrd_intrst_instrmnt` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','Not applicable','XXX')) OR `0100_accrd_intrst_instrmnt` = 999999999999999 OR CAST(`0100_accrd_intrst_instrmnt` AS STRING) = '' THEN 0 ELSE 1 END AS FRMT_0100_accrd_intrst_instrmnt
    ,CASE WHEN (CAST(ROUND(`0110_applcbl_fees_charges`, 2) AS STRING) = CAST(`0110_applcbl_fees_charges` AS STRING) AND CAST(`0110_applcbl_fees_charges` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','Not applicable','XXX')) OR `0110_applcbl_fees_charges` = 999999999999999 OR CAST(`0110_applcbl_fees_charges` AS STRING) = '' THEN 0 ELSE 1 END AS FRMT_0110_applcbl_fees_charges
    ,CASE WHEN (CAST(ROUND(`0120_otstndng_amnt`, 2) AS STRING) = CAST(`0120_otstndng_amnt` AS STRING) AND CAST(`0120_otstndng_amnt` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0120_otstndng_amnt`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0120_otstndng_amnt
    ,CASE WHEN CAST(ROUND(`0130_rlvnt_amnt_wdc`, 2) AS STRING) = CAST(`0130_rlvnt_amnt_wdc` AS STRING) AND CAST(`0130_rlvnt_amnt_wdc` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0130_rlvnt_amnt_wdc
    ,CASE WHEN `0140_ntr_lblty` IN ('Registered Bond', 'Bearer Bond', 'Borrower Note Loan', 'Certificate of Deposit / Commercial paper', 'Title of ownership', 'Cash account/saving account', 'Term deposit', 'Loan', 'Bill of exchange ', 'Other') THEN 0 ELSE 1 END AS FRMT_0140_ntr_lblty
    ,CASE WHEN `0141_ntr_lblty_othr` RLIKE '[A-Za-z]' AND `0141_ntr_lblty_othr` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0141_ntr_lblty_othr
    ,CASE WHEN `0150_flg_strctrlly_sbrdntd` IN ('TRUE', 'FALSE') THEN 0 ELSE 1 END AS FRMT_0150_flg_strctrlly_sbrdntd
    ,CASE WHEN CAST(`0160_rank_insolv` AS STRING) RLIKE '^[0-9]+$' AND CAST(`0160_rank_insolv` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0160_rank_insolv
    ,CASE WHEN (CAST(ROUND(`0161_cntrctl_sbrdntn`, 2) AS STRING) = CAST(`0161_cntrctl_sbrdntn` AS STRING) AND CAST(`0161_cntrctl_sbrdntn` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0161_cntrctl_sbrdntn`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0161_cntrctl_sbrdntn
    ,CASE WHEN `0162_bail_in_cascade` in ('1','2','3','4','5','6','7','8','9','10','11','12','13','14','14','15','16','17','18','19','20') THEN 0 ELSE 1 END AS FRMT_0162_bail_in_cascade
    ,CASE WHEN `0170_dt_incptn` REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' and `0170_dt_incptn` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0170_dt_incptn
    ,CASE WHEN (`0180_dt_nxt_intrst_pymnt` REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' and `0180_dt_nxt_intrst_pymnt` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','Not applicable','XXX')) OR `0180_dt_nxt_intrst_pymnt` IN ('0001-01-01', '') THEN 0 ELSE 1 END AS FRMT_0180_dt_nxt_intrst_pymnt
    ,CASE WHEN (`0190_dt_nxt_rdmptn_pymnt` REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' AND `0190_dt_nxt_rdmptn_pymnt` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0190_dt_nxt_rdmptn_pymnt` = `0210_dt_lgl_fnl_mtrty` THEN 0 ELSE 1 END AS FRMT_0190_dt_nxt_rdmptn_pymnt
    ,CASE WHEN (`0200_dt_erlst_rdmptn` REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' and `0200_dt_erlst_rdmptn` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','Not applicable','XXX')) OR `0200_dt_erlst_rdmptn` IN ('0001-01-01', '')  THEN 0 ELSE 1 END AS FRMT_0200_dt_erlst_rdmptn
    ,CASE WHEN (`0210_dt_lgl_fnl_mtrty` REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' and `0210_dt_lgl_fnl_mtrty` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','Not applicable','XXX')) OR `0210_dt_lgl_fnl_mtrty` IN ('0001-01-01', '')  THEN 0 ELSE 1 END AS FRMT_0210_dt_lgl_fnl_mtrty
    ,CASE WHEN LENGTH(`0220_governing_law`) = 2 OR `0220_governing_law` = 'XX' THEN 0 ELSE 1 END AS FRMT_0220_governing_law
    ,CASE WHEN `0230_bail_in_rcgntn_cls` IN ('Yes, supported by Legal Opinion', 'Yes, not supported by Legal Opinion', 'No', 'Not applicable', 'Aggregated', 'Not applicable') THEN 0 ELSE 1 END AS FRMT_0230_bail_in_rcgntn_cls
    ,CASE WHEN `0240_zero_coupon` IN ('ZCB issued at discount', 'ZCB not issued at discount', 'No ZCB', 'Aggregated') THEN 0 ELSE 1 END AS FRMT_0240_zero_coupon
    ,CASE WHEN `0250_strctrd_prdct` IN ('Non-structured/Vanilla', 'Structured', 'Other non-standard terms', 'Only structured coupon', 'Aggregated') THEN 0 ELSE 1 END AS FRMT_0250_strctrd_prdct
    ,CASE WHEN CAST(ROUND(`0260_grntd_min_amnt_strctrd_prdct`, 2) AS STRING) = CAST(`0260_grntd_min_amnt_strctrd_prdct` AS STRING) AND CAST(`0260_grntd_min_amnt_strctrd_prdct` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0260_grntd_min_amnt_strctrd_prdct
    ,CASE WHEN CAST(ROUND(`0270_fv_amnt_strctrd_prdct`, 2) AS STRING) = CAST(`0270_fv_amnt_strctrd_prdct` AS STRING) AND CAST(`0270_fv_amnt_strctrd_prdct` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0270_fv_amnt_strctrd_prdct
    ,CASE WHEN `0280_flg_ncnp_dpsts` IN ('TRUE', 'FALSE')  THEN 0 ELSE 1 END AS FRMT_0280_flg_ncnp_dpsts
    ,CASE WHEN `0290_flg_ncbp_dpsts` IN ('TRUE', 'FALSE')  THEN 0 ELSE 1 END AS FRMT_0290_flg_ncbp_dpsts
    ,CASE WHEN CAST(ROUND(`0300_amnt_cvrd_elgbl_dpsts`, 2) AS STRING) = CAST(`0300_amnt_cvrd_elgbl_dpsts` AS STRING) AND CAST(`0300_amnt_cvrd_elgbl_dpsts` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0300_amnt_cvrd_elgbl_dpsts
    ,CASE WHEN `0310_flg_clltrl_agrmnts` IN ('Secured', 'Unsecured') THEN 0 ELSE 1 END AS FRMT_0310_flg_clltrl_agrmnts
    ,CASE WHEN CAST(ROUND(`0320_amnt_clltrl`, 2) AS STRING) = CAST(`0320_amnt_clltrl` AS STRING) AND CAST(`0320_amnt_clltrl` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0320_amnt_clltrl
    ,CASE WHEN (CAST(ROUND(`0330_amnt_unclltrlzd`, 2) AS STRING) = CAST(`0330_amnt_unclltrlzd` AS STRING) and cast(`0170_dt_incptn` as string) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','Not applicable','XXX')) or CAST(`0330_amnt_unclltrlzd` AS STRING) = '' THEN 0 ELSE 1 END AS FRMT_0330_amnt_unclltrlzd
    ,CASE WHEN `0340_id_clltrl` RLIKE '[A-Za-z]' AND `0340_id_clltrl` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0340_id_clltrl
    ,CASE WHEN `0350_typ_clltrl` IN ('Real estate', 'Ships', 'Aircraft', 'Financial', 'Other', 'Not applicable', '') THEN 0 ELSE 1 END AS FRMT_0350_typ_clltrl
    ,CASE WHEN `0351_typ_clltrl_othr` RLIKE '[A-Za-z]' AND `0351_typ_clltrl_othr` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0351_typ_clltrl_othr
    ,CASE WHEN `0360_trdng_mthd` IN ('Nominal', 'Unit', 'Not applicable') THEN 0 ELSE 1 END AS FRMT_0360_trdng_mthd
    ,CASE WHEN CAST(ROUND(`0370_amnt_scrty_eur`, 2) AS STRING) = CAST(`0370_amnt_scrty_eur` AS STRING) AND CAST(`0370_amnt_scrty_eur` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0370_amnt_scrty_eur
    ,CASE WHEN CAST(ROUND(`0380_amnt_scrty_fx`, 2) AS STRING) = CAST(`0380_amnt_scrty_fx` AS STRING) AND CAST(`0380_amnt_scrty_fx` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0380_amnt_scrty_fx
    ,CASE WHEN CAST(`0390_nmbr_scrts_not_rprtng_entty` AS STRING) RLIKE '^[0-9]+$' AND CAST(`0390_nmbr_scrts_not_rprtng_entty` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0390_nmbr_scrts_not_rprtng_entty
    ,CASE WHEN CAST(`0391_nmbr_scrts_rprtng_entty` AS STRING) RLIKE '^[0-9]+$' AND CAST(`0391_nmbr_scrts_rprtng_entty` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0391_nmbr_scrts_rprtng_entty
    ,CASE WHEN CAST(ROUND(`0400_accrd_intrst_scrty`, 4) AS STRING) = CAST(`0400_accrd_intrst_scrty` AS STRING) and cast(`0400_accrd_intrst_scrty` as string) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0400_accrd_intrst_scrty
    ,CASE WHEN CAST(ROUND(`0410_fees_charges_scrty`, 4) AS STRING) = CAST(`0410_fees_charges_scrty` AS STRING) and cast(`0410_fees_charges_scrty` as string) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0410_fees_charges_scrty
    ,CASE WHEN CAST(ROUND(`0420_fv_amnt_scrty`, 4) AS STRING) = CAST(`0420_fv_amnt_scrty` AS STRING) and cast(`0420_fv_amnt_scrty` as string) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0420_fv_amnt_scrty
    ,CASE WHEN (CAST(ROUND(`0430_prncpl_amnt_glbl_nt_eur`, 2) AS STRING) = CAST(`0430_prncpl_amnt_glbl_nt_eur` AS STRING) AND CAST(`0430_prncpl_amnt_glbl_nt_eur` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0430_prncpl_amnt_glbl_nt_eur`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0430_prncpl_amnt_glbl_nt_eur
    ,CASE WHEN (CAST(ROUND(`0431_prncpl_amnt_glbl_nt_fx`, 2) AS STRING) = CAST(`0431_prncpl_amnt_glbl_nt_fx` AS STRING) AND CAST(`0431_prncpl_amnt_glbl_nt_fx` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0431_prncpl_amnt_glbl_nt_fx`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0431_prncpl_amnt_glbl_nt_fx
    ,CASE WHEN `0440_ntr_glbl_nt` IN ('NGN', 'CGN', 'Not applicable') THEN 0 ELSE 1 END AS FRMT_0440_ntr_glbl_nt
    ,CASE WHEN (CAST(`0450_crrnt_pool_fctr` AS STRING) RLIKE '^0\\.[0-9]{1,9}$' AND (`0450_crrnt_pool_fctr` >=0 AND `0450_crrnt_pool_fctr`<=1) and cast(`0450_crrnt_pool_fctr` as string) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0450_crrnt_pool_fctr`=-9999.999999999 THEN 0 ELSE 1 END AS FRMT_0450_crrnt_pool_fctr
    ,CASE WHEN `0460_csd` = 'INTERBOLSA_PT' THEN 0 ELSE 1 END AS FRMT_0460_csd
    ,CASE WHEN `0461_csd_lei` RLIKE '[A-Za-z]' and `0461_csd_lei` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0461_csd_lei
    ,CASE WHEN `0462_csd_othr` RLIKE '[A-Za-z]' and `0462_csd_othr` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0462_csd_othr
    ,CASE WHEN (`0470_pyng_agnt` RLIKE '[A-Za-z]' and `0470_pyng_agnt` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0470_pyng_agnt` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0470_pyng_agnt
    ,CASE WHEN (`0471_pyng_agnt_lei` RLIKE '[A-Za-z]' and `0471_pyng_agnt_lei` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0471_pyng_agnt_lei` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0471_pyng_agnt_lei
    ,CASE WHEN (`0480_trdng_vn` RLIKE '[A-Za-z]' and `0480_trdng_vn` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0480_trdng_vn` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0480_trdng_vn
    ,CASE WHEN (`0481_trdng_vn_lei` RLIKE '[A-Za-z]' and `0481_trdng_vn_lei` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0481_trdng_vn_lei` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0481_trdng_vn_lei
    ,CASE WHEN (`0490_rgstrr` RLIKE '[A-Za-z]' and `0490_rgstrr` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0490_rgstrr` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0490_rgstrr
    ,CASE WHEN (`0491_rgstrr_lei` RLIKE '[A-Za-z]' and `0491_rgstrr_lei` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0491_rgstrr_lei` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0491_rgstrr_lei
    ,CASE WHEN (`0500_nna` RLIKE '[A-Za-z]' and `0500_nna` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0500_nna` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0500_nna
    ,CASE WHEN (`0501_nna_lei` RLIKE '[A-Za-z]' and `0501_nna_lei` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0501_nna_lei` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0501_nna_lei
    ,CASE WHEN (`0510_cmmn_dpstry` RLIKE '[A-Za-z]' and `0510_cmmn_dpstry` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0510_cmmn_dpstry` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0510_cmmn_dpstry
    ,CASE WHEN (`0511_cmmn_dpstry_lei` RLIKE '[A-Za-z]' and `0511_cmmn_dpstry_lei` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0511_cmmn_dpstry_lei` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0511_cmmn_dpstry_lei
    ,CASE WHEN (`0520_cmmn_srvc_prvdr` RLIKE '[A-Za-z]' and `0520_cmmn_srvc_prvdr` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0520_cmmn_srvc_prvdr` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0520_cmmn_srvc_prvdr
    ,CASE WHEN (`0521_cmmn_srvc_prvdr_lei` RLIKE '[A-Za-z]' and `0521_cmmn_srvc_prvdr_lei` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0521_cmmn_srvc_prvdr_lei` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0521_cmmn_srvc_prvdr_lei
    ,CASE WHEN `0530_typ_own_fnds_ind_lvl` IN ('T2 in phase-out', 'Grandfathered T2', 'Fully Compliant T2', 'Partially (A)T1 and T2', 'Grandfathered AT1', 'Fully Compliant AT1', 'CET1', 'No', 'Not applicable') THEN 0 ELSE 1 END AS FRMT_0530_typ_own_fnds_ind_lvl
    ,CASE WHEN (CAST(ROUND(`0540_elgbl_amnt_own_fnds_ind_lvl`, 2) AS STRING) = CAST(`0540_elgbl_amnt_own_fnds_ind_lvl` AS STRING) AND CAST(`0540_elgbl_amnt_own_fnds_ind_lvl` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0540_elgbl_amnt_own_fnds_ind_lvl`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0540_elgbl_amnt_own_fnds_ind_lvl
    ,CASE WHEN `0550_typ_own_fnds_cnsldtd_lvl` IN ('T2 in phase-out', 'Grandfathered T2', 'Fully Compliant T2', 'Partially (A)T1 and T2', 'Grandfathered AT1', 'Fully Compliant AT1', 'CET1', 'No', 'Not applicable') THEN 0 ELSE 1 END AS FRMT_0550_typ_own_fnds_cnsldtd_lvl
    ,CASE WHEN (CAST(ROUND(`0560_elgbl_amnt_own_fnds_cnsldtd_lvl`, 2) AS STRING) = CAST(`0560_elgbl_amnt_own_fnds_cnsldtd_lvl` AS STRING) AND CAST(`0560_elgbl_amnt_own_fnds_cnsldtd_lvl` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX')) OR `0560_elgbl_amnt_own_fnds_cnsldtd_lvl`= 999999999999999.00 THEN 0 ELSE 1 END AS FRMT_0560_elgbl_amnt_own_fnds_cnsldtd_lvl
    ,CASE WHEN CAST(ROUND(`0570_amnt_scrty_intrst_prvdd`, 2) AS STRING) = CAST(`0570_amnt_scrty_intrst_prvdd` AS STRING) AND CAST(`0570_amnt_scrty_intrst_prvdd` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0570_amnt_scrty_intrst_prvdd
    ,CASE WHEN (`0580_scrty_intrst_prvdr` RLIKE '[A-Za-z]' and `0580_scrty_intrst_prvdr` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0580_scrty_intrst_prvdr` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0580_scrty_intrst_prvdr
    ,CASE WHEN (`0581_scrty_intrst_prvdr_lei` RLIKE '[A-Za-z]' and `0581_scrty_intrst_prvdr_lei` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','XXX')) OR `0581_scrty_intrst_prvdr_lei` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0581_scrty_intrst_prvdr_lei
    ,CASE WHEN `0590_typ_scrty_intrst_prvdd` IN ('Lien', 'Guarantee', 'Surety', 'Guarantee obligation', 'Other', 'Not applicable', 'Aggregated') THEN 0 ELSE 1 END AS FRMT_0590_typ_scrty_intrst_prvdd
    ,CASE WHEN `0600_flg_clltrl_asst_pstn` IN ('TRUE', 'FALSE', 'Not applicable')  THEN 0 ELSE 1 END AS FRMT_0600_flg_clltrl_asst_pstn
    ,CASE WHEN CAST(ROUND(`0610_crryng_amnt_ifrs`, 2) AS STRING) = CAST(`0610_crryng_amnt_ifrs` AS STRING) AND CAST(`0610_crryng_amnt_ifrs` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0610_crryng_amnt_ifrs
    ,CASE WHEN `0620_blnc_sht_ifrs` IN ('010 Financial liabilities held for trading', '070 Financial liabilities at fair value through profit or loss', '110 Financial liabilities at amortized cost', '280 Other liabilities', '300 Total equity') THEN 0 ELSE 1 END AS FRMT_0620_blnc_sht_ifrs
    ,CASE WHEN CAST(ROUND(`0630_crrying_amnt_ngaap`, 2) AS STRING) = CAST(`0630_crrying_amnt_ngaap` AS STRING) AND CAST(`0630_crrying_amnt_ngaap` AS STRING) NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0630_crrying_amnt_ngaap
    ,CASE WHEN `0640_blnc_sht_ngaap` RLIKE '[A-Za-z]' and `0580_scrty_intrst_prvdr` NOT IN ('N/A','11111111111','11111111111.00','11111111111.000000','1111-11-11','0000-00-00','0001-01-01','9999-12-31','MISS','00000','99999999999','999999999999999','99999999999.00','99999999999.000000','-9999.9999','','Not applicable','XXX') THEN 0 ELSE 1 END AS FRMT_0640_blnc_sht_ngaap
    ,CASE WHEN `5000_flg_shrhldr_not_rsltn_grp` IN ('TRUE', 'FALSE')  THEN 0 ELSE 1 END AS FRMT_5000_flg_shrhldr_not_rsltn_grp
    ,CASE WHEN `5010_flg_art21_7a_srmr` IN ('TRUE', 'FALSE')  THEN 0 ELSE 1 END AS FRMT_5010_flg_art21_7a_srmr

-- FROM BU_CAPTOOLS_WORK.SIMUL_B02000
FROM BU_LOANTAPE_WORK.OUT_B0200_MAIN_LIABILITIES
	WHERE REF_DATE='${REF_DATE}' 
-- 	AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.SIMUL_B02000)

) as B0200
;


/*B0500_GUARANTEES*/ 
SELECT 
SUM(v_2_0053) AS B0500_LVL2_H_0030_governing_law,
SUM(v_2_0054) AS B0500_LVL2_H_0050_typ_guarantee,
SUM(v_2_0055) AS B0500_LVL2_H_0060_max_amnt_guarantee,
SUM(v_2_0056) AS B0500_LVL2_H_0070_flg_scrd,
SUM(v_2_0057) AS B0500_LVL2_H_0080_amnt_clltrl,
SUM(FRMT_0010_row_nmbr) AS `B0500_FRMT_0010_row_nmbr`,
SUM(FRMT_0020_uniq_id_guarantee) AS `B0500_FRMT_0020_uniq_id_guarantee`,
SUM(FRMT_0030_governing_law) AS `B0500_FRMT_0030_governing_law`,
SUM(FRMT_0040_flg_art12g_3_srmr) AS `B0500_FRMT_0040_flg_art12g_3_srmr`,
SUM(FRMT_0050_typ_guarantee) AS `B0500_FRMT_0050_typ_guarantee`,
SUM(FRMT_0060_max_amnt_guarantee) AS `B0500_FRMT_0060_max_amnt_guarantee`,
SUM(FRMT_0070_flg_scrd) AS `B0500_FRMT_0070_flg_scrd`,
SUM(FRMT_0080_amnt_clltrl) AS `B0500_FRMT_0080_amnt_clltrl`,
SUM(FRMT_0090_guarantee_trggr) AS `B0500_FRMT_0090_guarantee_trggr`,
SUM(FRMT_0100_dt_mtrty_clltrl) AS `B0500_FRMT_0100_dt_mtrty_clltrl`,
SUM(FRMT_0110_scrts_clltrl_id) AS `B0500_FRMT_0110_scrts_clltrl_id`,
SUM(FRMT_0120_typ_clltrlztn) AS `B0500_FRMT_0120_typ_clltrlztn`,
SUM(FRMT_0130_typ_prtctn_vl) AS `B0500_FRMT_0130_typ_prtctn_vl`,
SUM(FRMT_0150_prtctn_vltn_apprch) AS `B0500_FRMT_0150_prtctn_vltn_apprch`

FROM 
	(
	SELECT *
    ,CASE WHEN `0030_governing_law` NOT IN ('AF','AX','AL','DZ','AS','AD','AO','AI','AQ','AG','AR','AM','AW','AU','AT','AZ','BS','BH','BD','BB','BY','BE','BZ','BJ','BM','BT','BO','BQ','BA','BW','BV','BR','IO','BN','BG','BF','BI','CV','KH','CM','CA','KY','CF','TD','CL','CN','CX','CC','CO','KM','CG','CD','CK','CR','CI','HR','CU','CW','CY','CZ','DK','DJ','DM','DO','EC','EG','SV','GQ','ER','EE','SZ','ET','FK','FO','FJ','FI','FR','GF','PF','TF','GA','GM','GE','DE','GH','GI','GR','GL','GD','GP','GU','GT','GG','GN','GW','GY','HT','HM','VA','HN','HK','HU','IS','IN','ID','IR','IQ','IE','IM','IL','IT','JM','JP','JE','JO','KZ','KE','KI','KP','KR','KW','KG','LA','LV','LB','LS','LR','LY','LI','LT','LU','MO','MG','MW','MY','MV','ML','MT','MH','MQ','MR','MU','YT','MX','FM','MD','MC','MN','ME','MS','MA','MZ','MM','NA','NR','NP','NL','NC','NZ','NI','NE','NG','NU','NF','MK','MP','NO','OM','PK','PW','PS','PA','PG','PY','PE','PH','PN','PL','PT','PR','QA','RE','RO','RU','RW','BL','SH','KN','LC','MF','PM','VC','WS','SM','ST','SA','SN','RS','SC','SL','SG','SX','SK','SI','SB','SO','ZA','GS','SS','ES','LK','SD','SR','SJ','SE','CH','SY','TW','TJ','TZ','TH','TL','TG','TK','TO','TT','TN','TR','TM','TC','TV','UG','UA','AE','GB','US','UM','UY','UZ','VU','VE','VN','VG','VI','WF','EH','YE','ZM','ZW') THEN 1 ELSE 0 END AS v_2_0053
	,CASE WHEN `0050_typ_guarantee` IN ('Issuance', 'Counterparty', 'Unlimited', 'Other types of guarantee than issuance guarantees, counterparty guarantees and unlimited guarantees') THEN 0 ELSE 1 END AS v_2_0054
	,CASE WHEN `0060_max_amnt_guarantee` < 0 THEN 1 ELSE 0 END AS v_2_0055
	,CASE WHEN `0070_flg_scrd` IN ('Issuance', 'Counterparty', 'Unlimited', 'Other types of guarantee than issuance guarantees, counterparty guarantees and unlimited guarantees') THEN 0 ELSE 1 END AS v_2_0056
	,CASE WHEN `0080_amnt_clltrl` < 0 AND `0070_flg_scrd` = 'Secured' THEN 1 ELSE 0 END AS v_2_0057

	,CASE WHEN CAST(`0010_row_nmbr` AS STRING) NOT RLIKE '^[0-9]+$' THEN 1 ELSE 0 END AS FRMT_0010_row_nmbr
	,CASE WHEN `0020_uniq_id_guarantee` NOT RLIKE '[A-Za-z]' THEN 1 ELSE 0 END AS FRMT_0020_uniq_id_guarantee
	,CASE WHEN LENGTH(`0030_governing_law`) != 2 THEN 1 ELSE 0 END AS FRMT_0030_governing_law
	,CASE WHEN `0040_flg_art12g_3_srmr` NOT IN ('TRUE', 'FALSE') THEN 1 ELSE 0 END AS FRMT_0040_flg_art12g_3_srmr
	,CASE WHEN `0050_typ_guarantee` NOT IN ('Issuance', 'Counterparty', 'Unlimited', 'Other types of guarantee than issuance guarantees, counterparty guarantees and unlimited guarantees') THEN 1 ELSE 0 END AS FRMT_0050_typ_guarantee
	,CASE WHEN CAST(ROUND(`0060_max_amnt_guarantee`, 2) AS STRING) != CAST(`0060_max_amnt_guarantee` AS STRING) THEN 1 ELSE 0 END AS FRMT_0060_max_amnt_guarantee
	,CASE WHEN `0070_flg_scrd` NOT IN ('Secured', 'Unsecured') THEN 1 ELSE 0 END AS FRMT_0070_flg_scrd
	,CASE WHEN CAST(ROUND(`0080_amnt_clltrl`, 2) AS STRING) != CAST(`0080_amnt_clltrl` AS STRING) THEN 1 ELSE 0 END AS FRMT_0080_amnt_clltrl
	,CASE WHEN `0090_guarantee_trggr` != 'Default' THEN 1 ELSE 0 END AS FRMT_0090_guarantee_trggr
	,CASE WHEN `0100_dt_mtrty_clltrl` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN 1 ELSE 0 END AS FRMT_0100_dt_mtrty_clltrl
	,CASE WHEN `0110_scrts_clltrl_id` NOT RLIKE '[A-Za-z]' THEN 1 ELSE 0 END AS FRMT_0110_scrts_clltrl_id
	,CASE WHEN `0120_typ_clltrlztn` NOT RLIKE '[A-Za-z]' THEN 1 ELSE 0 END AS FRMT_0120_typ_clltrlztn
	,CASE WHEN `0130_typ_prtctn_vl` NOT IN ('Notional amount', 'Fair value','Market value','Long-term sustainable value','Other protection value') THEN 1 ELSE 0 END AS FRMT_0130_typ_prtctn_vl
	,CASE WHEN `0140_dt_vltn_scrty` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'  THEN 1 ELSE 0 END AS FRMT_0140_dt_vltn_scrty
	,CASE WHEN `0150_prtctn_vltn_apprch` NOT IN ('Mark-to-market valuation', 'Counterparty estimation','Creditor valuation','Third party valuation') THEN 1 ELSE 0 END AS FRMT_0150_prtctn_vltn_apprch

-- 	FROM BU_CAPTOOLS_WORK.SIMUL_B0500
	FROM bu_loantape_work.out_b0500_guarantees
	WHERE REF_DATE='${REF_DATE}' 
-- 	AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.SIMUL_B0500)
	) AS B500
;



/*B9000_COUNTERPARTIES*/
SELECT 
SUM(v_1_0056) AS B9000_LVL1_H_0030_cntrprty_rsltn_grp,
SUM(v_2_0058) AS B9000_LVL2_H_0030_cntrprty_rsltn_grp,
SUM(v_2_0059) AS B9000_LVL2_H_0080_cntrprty_typ,
SUM(v_2_0060) AS B9000_LVL2_H_0090_cntry_cntrprty,
--SUM(v_2_0061) AS B9000_LVL2_W_0100_rlvnt_amnt_wdc,
SUM(FRMT_0010_row_nmbr) AS `B9000_FRMT_0010_row_nmbr`,
SUM(FRMT_0011_tab_origin) AS `B9000_FRMT_0011_tab_origin`,
SUM(FRMT_0020_uniq_id_knwn_cntrprty) AS `B9000_FRMT_0020_uniq_id_knwn_cntrprty`,
SUM(FRMT_0030_cntrprty_rsltn_grp) AS `B9000_FRMT_0030_cntrprty_rsltn_grp`,
SUM(FRMT_0040_cntrprty_nm) AS `B9000_FRMT_0040_cntrprty_nm`,
SUM(FRMT_0050_cntrprty_lei) AS `B9000_FRMT_0050_cntrprty_lei`,
SUM(FRMT_0060_typ_cntrprty_id) AS `B9000_FRMT_0060_typ_cntrprty_id`,
SUM(FRMT_0070_cntrprty_id) AS `B9000_FRMT_0070_cntrprty_id`,
SUM(FRMT_0080_cntrprty_typ) AS `B9000_FRMT_0080_cntrprty_typ`,
SUM(FRMT_0090_cntry_cntrprty) AS `B9000_FRMT_0090_cntry_cntrprty`,
SUM(FRMT_0100_rlvnt_amnt_wdc) AS `B9000_FRMT_0100_rlvnt_amnt_wdc`

FROM
	(
	SELECT *
	,CASE WHEN `0030_cntrprty_rsltn_grp`= '' OR `0030_cntrprty_rsltn_grp` IS NULL THEN 1 ELSE 0 END AS v_1_0056

	,CASE WHEN `0030_cntrprty_rsltn_grp` NOT IN ('Intragroup and intra-resolution group', 'Intragroup but not intra-resolution group', 'No') THEN 1 ELSE 0 END AS v_2_0058
	,CASE WHEN `0080_cntrprty_typ` NOT IN ('Households', 'Micro & SME', 'Corporates', 'Institutions', 'Other financial corporations', 'Insurance firms & pension funds', 'Government, central banks & supranationals', 'Non identified, listed on an exchange platform', 'Non identified, not listed on an exchange platform') THEN 1 ELSE 0 END AS v_2_0059
    ,CASE WHEN `0080_cntrprty_typ` NOT IN ('XX', '99') AND `0090_cntry_cntrprty` NOT IN ('AF','AX','AL','DZ','AS','AD','AO','AI','AQ','AG','AR','AM','AW','AU','AT','AZ','BS','BH','BD','BB','BY','BE','BZ','BJ','BM','BT','BO','BQ','BA','BW','BV','BR','IO','BN','BG','BF','BI','CV','KH','CM','CA','KY','CF','TD','CL','CN','CX','CC','CO','KM','CG','CD','CK','CR','CI','HR','CU','CW','CY','CZ','DK','DJ','DM','DO','EC','EG','SV','GQ','ER','EE','SZ','ET','FK','FO','FJ','FI','FR','GF','PF','TF','GA','GM','GE','DE','GH','GI','GR','GL','GD','GP','GU','GT','GG','GN','GW','GY','HT','HM','VA','HN','HK','HU','IS','IN','ID','IR','IQ','IE','IM','IL','IT','JM','JP','JE','JO','KZ','KE','KI','KP','KR','KW','KG','LA','LV','LB','LS','LR','LY','LI','LT','LU','MO','MG','MW','MY','MV','ML','MT','MH','MQ','MR','MU','YT','MX','FM','MD','MC','MN','ME','MS','MA','MZ','MM','NA','NR','NP','NL','NC','NZ','NI','NE','NG','NU','NF','MK','MP','NO','OM','PK','PW','PS','PA','PG','PY','PE','PH','PN','PL','PT','PR','QA','RE','RO','RU','RW','BL','SH','KN','LC','MF','PM','VC','WS','SM','ST','SA','SN','RS','SC','SL','SG','SX','SK','SI','SB','SO','ZA','GS','SS','ES','LK','SD','SR','SJ','SE','CH','SY','TW','TJ','TZ','TH','TL','TG','TK','TO','TT','TN','TR','TM','TC','TV','UG','UA','AE','GB','US','UM','UY','UZ','VU','VE','VN','VG','VI','WF','EH','YE','ZM','ZW') THEN 1 ELSE 0 END AS v_2_0060
	--,CASE WHEN `0030_cntrprty_rsltn_grp` != 'No' AND `0100_rlvnt_amnt_wdc` != 0 THEN 1 ELSE 0 END AS v_2_0061 /*Não aplicável a non resolution entities - QA2025-74*/

	,CASE WHEN `0010_row_nmbr` <= 0 THEN 1 ELSE 0 END AS FRMT_0010_row_nmbr
	,CASE WHEN `0011_tab_origin` NOT IN ('B0200','B0300','B0400','B0500') THEN 1 ELSE 0 END AS FRMT_0011_tab_origin
	,CASE WHEN `0020_uniq_id_knwn_cntrprty` NOT RLIKE '[A-Za-z]' THEN 1 ELSE 0 END AS FRMT_0020_uniq_id_knwn_cntrprty
	,CASE WHEN `0030_cntrprty_rsltn_grp` NOT IN ('Intragroup and intra-resolution group', 'Intragroup but not intra-resolution group', 'No') THEN 1 ELSE 0 END AS FRMT_0030_cntrprty_rsltn_grp
	,CASE WHEN `0040_cntrprty_nm` != '' OR `0040_cntrprty_nm` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0040_cntrprty_nm
	,CASE WHEN `0050_cntrprty_lei` != '' OR `0050_cntrprty_lei` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0050_cntrprty_lei
	,CASE WHEN `0060_typ_cntrprty_id` != '' OR `0060_typ_cntrprty_id` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0060_typ_cntrprty_id
	,CASE WHEN `0070_cntrprty_id` != '' OR `0070_cntrprty_id` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0070_cntrprty_id
	,CASE WHEN `0080_cntrprty_typ` != '' OR `0080_cntrprty_typ` = 'Not applicable' THEN 0 ELSE 1 END AS FRMT_0080_cntrprty_typ
	,CASE WHEN `0090_cntry_cntrprty` NOT IN ('AF','AX','AL','DZ','AS','AD','AO','AI','AQ','AG','AR','AM','AW','AU','AT','AZ','BS','BH','BD','BB','BY','BE','BZ','BJ','BM','BT','BO','BQ','BA','BW','BV','BR','IO','BN','BG','BF','BI','CV','KH','CM','CA','KY','CF','TD','CL','CN','CX','CC','CO','KM','CG','CD','CK','CR','CI','HR','CU','CW','CY','CZ','DK','DJ','DM','DO','EC','EG','SV','GQ','ER','EE','SZ','ET','FK','FO','FJ','FI','FR','GF','PF','TF','GA','GM','GE','DE','GH','GI','GR','GL','GD','GP','GU','GT','GG','GN','GW','GY','HT','HM','VA','HN','HK','HU','IS','IN','ID','IR','IQ','IE','IM','IL','IT','JM','JP','JE','JO','KZ','KE','KI','KP','KR','KW','KG','LA','LV','LB','LS','LR','LY','LI','LT','LU','MO','MG','MW','MY','MV','ML','MT','MH','MQ','MR','MU','YT','MX','FM','MD','MC','MN','ME','MS','MA','MZ','MM','NA','NR','NP','NL','NC','NZ','NI','NE','NG','NU','NF','MK','MP','NO','OM','PK','PW','PS','PA','PG','PY','PE','PH','PN','PL','PT','PR','QA','RE','RO','RU','RW','BL','SH','KN','LC','MF','PM','VC','WS','SM','ST','SA','SN','RS','SC','SL','SG','SX','SK','SI','SB','SO','ZA','GS','SS','ES','LK','SD','SR','SJ','SE','CH','SY','TW','TJ','TZ','TH','TL','TG','TK','TO','TT','TN','TR','TM','TC','TV','UG','UA','AE','GB','US','UM','UY','UZ','VU','VE','VN','VG','VI','WF','EH','YE','ZM','ZW') THEN 1 ELSE 0 END AS FRMT_0090_cntry_cntrprty
	,CASE WHEN CAST(ROUND(`0100_rlvnt_amnt_wdc`, 2) AS STRING) != CAST(`0100_rlvnt_amnt_wdc` AS STRING) THEN 1 ELSE 0 END AS FRMT_0100_rlvnt_amnt_wdc
	
-- 	FROM BU_CAPTOOLS_WORK.SIMUL_B9000_COUNTERPARTIES
    FROM bu_loantape_work.out_b9000_counterparties
	WHERE REF_DATE='${REF_DATE}' 
-- 	AND ID_CORRIDA IN (SELECT MAX(ID_CORRIDA) FROM BU_CAPTOOLS_WORK.SIMUL_B9000_COUNTERPARTIES)
	) AS AUX
;

