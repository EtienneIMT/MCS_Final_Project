* ==========================================
* 16-Bit Column Peripherals for 2kb SRAM
* ==========================================

* --- Write Driver ---
.subckt WRITE_DRIVER D_in WEN BL BLB
Xinv_D D_in D_in_b INV
Mn_w1 BLB WEN node1 GND nmos_sram m=2
Mn_w2 node1 D_in GND GND nmos_sram m=2
Mn_w3 BL WEN node2 GND nmos_sram m=2
Mn_w4 node2 D_in_b GND GND nmos_sram m=2
.ends

* --- Transmission Gate ---
.subckt TG IN OUT EN EN_B
Mp IN EN_B OUT VDD pmos_sram m=2
Mn IN EN   OUT GND nmos_sram m=2
.ends

* --- 1-to-2 Column MUX ---
.subckt COL_MUX A0 A0_B BL_0 BLB_0 BL_1 BLB_1 BL_int BLB_int
X_TG_BL0  BL_0  BL_int  A0_B A0 TG
X_TG_BLB0 BLB_0 BLB_int A0_B A0 TG
X_TG_BL1  BL_1  BL_int  A0 A0_B TG
X_TG_BLB1 BLB_1 BLB_int A0 A0_B TG
.ends

* --- Current-Mode Sense Amplifier (CMSA) ---
.subckt CMSA PRE SAEN BL BLB sense sense_b
Mpre_sa1 sense   PRE VDD VDD pmos_rvt m=2
Mpre_sa2 sense_b PRE VDD VDD pmos_rvt m=2
Meq_sa   sense   PRE sense_b VDD pmos_rvt m=2
Mpre_int1 int_l PRE VDD VDD pmos_rvt m=1
Mpre_int2 int_r PRE VDD VDD pmos_rvt m=1
Mpl sense   sense_b VDD    VDD pmos_rvt m=2
Mpr sense_b sense   VDD    VDD pmos_rvt m=2
Mnl sense   sense_b int_l  GND nmos_rvt m=2
Mnr sense_b sense   int_r  GND nmos_rvt m=2
Min_l int_l BLB tail_n GND nmos_rvt m=2
Min_r int_r BL  tail_n GND nmos_rvt m=2
Mtail tail_n SAEN GND GND nmos_rvt m=4
.ends

* ==========================================
* MAIN MACRO: 16-BIT COLUMN PERIPHERAL BLOCK
* ==========================================
.subckt COL_PERIPHERALS A0 A0_B PRE SAEN WEN 
+ BL_0 BLB_0 BL_1 BLB_1 BL_2 BLB_2 BL_3 BLB_3 BL_4 BLB_4 BL_5 BLB_5 BL_6 BLB_6 BL_7 BLB_7 BL_8 BLB_8 BL_9 BLB_9 BL_10 BLB_10 BL_11 BLB_11 BL_12 BLB_12 BL_13 BLB_13 BL_14 BLB_14 BL_15 BLB_15 BL_16 BLB_16 BL_17 BLB_17 BL_18 BLB_18 BL_19 BLB_19 BL_20 BLB_20 BL_21 BLB_21 BL_22 BLB_22 BL_23 BLB_23 BL_24 BLB_24 BL_25 BLB_25 BL_26 BLB_26 BL_27 BLB_27 BL_28 BLB_28 BL_29 BLB_29 BL_30 BLB_30 BL_31 BLB_31 
+ D_0 D_1 D_2 D_3 D_4 D_5 D_6 D_7 D_8 D_9 D_10 D_11 D_12 D_13 D_14 D_15 
+ Q_0 Q_b_0 Q_1 Q_b_1 Q_2 Q_b_2 Q_3 Q_b_3 Q_4 Q_b_4 Q_5 Q_b_5 Q_6 Q_b_6 Q_7 Q_b_7 Q_8 Q_b_8 Q_9 Q_b_9 Q_10 Q_b_10 Q_11 Q_b_11 Q_12 Q_b_12 Q_13 Q_b_13 Q_14 Q_b_14 Q_15 Q_b_15 

* --- BIT 0 ---
Mpre1_0 BL_0 PRE VDD VDD pmos_sram m=2
Mpre2_0 BLB_0 PRE VDD VDD pmos_sram m=2
Meq_0 BL_0 PRE BLB_0 VDD pmos_sram m=2
Mpre1_16 BL_16 PRE VDD VDD pmos_sram m=2
Mpre2_16 BLB_16 PRE VDD VDD pmos_sram m=2
Meq_16 BL_16 PRE BLB_16 VDD pmos_sram m=2
X_MUX_0 A0 A0_B BL_0 BLB_0 BL_16 BLB_16 BL_int_0 BLB_int_0 COL_MUX
X_SA_0 PRE SAEN BL_int_0 BLB_int_0 Q_0 Q_b_0 CMSA
X_WD_0 D_0 WEN BL_int_0 BLB_int_0 WRITE_DRIVER

* --- BIT 1 ---
Mpre1_1 BL_1 PRE VDD VDD pmos_sram m=2
Mpre2_1 BLB_1 PRE VDD VDD pmos_sram m=2
Meq_1 BL_1 PRE BLB_1 VDD pmos_sram m=2
Mpre1_17 BL_17 PRE VDD VDD pmos_sram m=2
Mpre2_17 BLB_17 PRE VDD VDD pmos_sram m=2
Meq_17 BL_17 PRE BLB_17 VDD pmos_sram m=2
X_MUX_1 A0 A0_B BL_1 BLB_1 BL_17 BLB_17 BL_int_1 BLB_int_1 COL_MUX
X_SA_1 PRE SAEN BL_int_1 BLB_int_1 Q_1 Q_b_1 CMSA
X_WD_1 D_1 WEN BL_int_1 BLB_int_1 WRITE_DRIVER

* --- BIT 2 ---
Mpre1_2 BL_2 PRE VDD VDD pmos_sram m=2
Mpre2_2 BLB_2 PRE VDD VDD pmos_sram m=2
Meq_2 BL_2 PRE BLB_2 VDD pmos_sram m=2
Mpre1_18 BL_18 PRE VDD VDD pmos_sram m=2
Mpre2_18 BLB_18 PRE VDD VDD pmos_sram m=2
Meq_18 BL_18 PRE BLB_18 VDD pmos_sram m=2
X_MUX_2 A0 A0_B BL_2 BLB_2 BL_18 BLB_18 BL_int_2 BLB_int_2 COL_MUX
X_SA_2 PRE SAEN BL_int_2 BLB_int_2 Q_2 Q_b_2 CMSA
X_WD_2 D_2 WEN BL_int_2 BLB_int_2 WRITE_DRIVER

* --- BIT 3 ---
Mpre1_3 BL_3 PRE VDD VDD pmos_sram m=2
Mpre2_3 BLB_3 PRE VDD VDD pmos_sram m=2
Meq_3 BL_3 PRE BLB_3 VDD pmos_sram m=2
Mpre1_19 BL_19 PRE VDD VDD pmos_sram m=2
Mpre2_19 BLB_19 PRE VDD VDD pmos_sram m=2
Meq_19 BL_19 PRE BLB_19 VDD pmos_sram m=2
X_MUX_3 A0 A0_B BL_3 BLB_3 BL_19 BLB_19 BL_int_3 BLB_int_3 COL_MUX
X_SA_3 PRE SAEN BL_int_3 BLB_int_3 Q_3 Q_b_3 CMSA
X_WD_3 D_3 WEN BL_int_3 BLB_int_3 WRITE_DRIVER

* --- BIT 4 ---
Mpre1_4 BL_4 PRE VDD VDD pmos_sram m=2
Mpre2_4 BLB_4 PRE VDD VDD pmos_sram m=2
Meq_4 BL_4 PRE BLB_4 VDD pmos_sram m=2
Mpre1_20 BL_20 PRE VDD VDD pmos_sram m=2
Mpre2_20 BLB_20 PRE VDD VDD pmos_sram m=2
Meq_20 BL_20 PRE BLB_20 VDD pmos_sram m=2
X_MUX_4 A0 A0_B BL_4 BLB_4 BL_20 BLB_20 BL_int_4 BLB_int_4 COL_MUX
X_SA_4 PRE SAEN BL_int_4 BLB_int_4 Q_4 Q_b_4 CMSA
X_WD_4 D_4 WEN BL_int_4 BLB_int_4 WRITE_DRIVER

* --- BIT 5 ---
Mpre1_5 BL_5 PRE VDD VDD pmos_sram m=2
Mpre2_5 BLB_5 PRE VDD VDD pmos_sram m=2
Meq_5 BL_5 PRE BLB_5 VDD pmos_sram m=2
Mpre1_21 BL_21 PRE VDD VDD pmos_sram m=2
Mpre2_21 BLB_21 PRE VDD VDD pmos_sram m=2
Meq_21 BL_21 PRE BLB_21 VDD pmos_sram m=2
X_MUX_5 A0 A0_B BL_5 BLB_5 BL_21 BLB_21 BL_int_5 BLB_int_5 COL_MUX
X_SA_5 PRE SAEN BL_int_5 BLB_int_5 Q_5 Q_b_5 CMSA
X_WD_5 D_5 WEN BL_int_5 BLB_int_5 WRITE_DRIVER

* --- BIT 6 ---
Mpre1_6 BL_6 PRE VDD VDD pmos_sram m=2
Mpre2_6 BLB_6 PRE VDD VDD pmos_sram m=2
Meq_6 BL_6 PRE BLB_6 VDD pmos_sram m=2
Mpre1_22 BL_22 PRE VDD VDD pmos_sram m=2
Mpre2_22 BLB_22 PRE VDD VDD pmos_sram m=2
Meq_22 BL_22 PRE BLB_22 VDD pmos_sram m=2
X_MUX_6 A0 A0_B BL_6 BLB_6 BL_22 BLB_22 BL_int_6 BLB_int_6 COL_MUX
X_SA_6 PRE SAEN BL_int_6 BLB_int_6 Q_6 Q_b_6 CMSA
X_WD_6 D_6 WEN BL_int_6 BLB_int_6 WRITE_DRIVER

* --- BIT 7 ---
Mpre1_7 BL_7 PRE VDD VDD pmos_sram m=2
Mpre2_7 BLB_7 PRE VDD VDD pmos_sram m=2
Meq_7 BL_7 PRE BLB_7 VDD pmos_sram m=2
Mpre1_23 BL_23 PRE VDD VDD pmos_sram m=2
Mpre2_23 BLB_23 PRE VDD VDD pmos_sram m=2
Meq_23 BL_23 PRE BLB_23 VDD pmos_sram m=2
X_MUX_7 A0 A0_B BL_7 BLB_7 BL_23 BLB_23 BL_int_7 BLB_int_7 COL_MUX
X_SA_7 PRE SAEN BL_int_7 BLB_int_7 Q_7 Q_b_7 CMSA
X_WD_7 D_7 WEN BL_int_7 BLB_int_7 WRITE_DRIVER

* --- BIT 8 ---
Mpre1_8 BL_8 PRE VDD VDD pmos_sram m=2
Mpre2_8 BLB_8 PRE VDD VDD pmos_sram m=2
Meq_8 BL_8 PRE BLB_8 VDD pmos_sram m=2
Mpre1_24 BL_24 PRE VDD VDD pmos_sram m=2
Mpre2_24 BLB_24 PRE VDD VDD pmos_sram m=2
Meq_24 BL_24 PRE BLB_24 VDD pmos_sram m=2
X_MUX_8 A0 A0_B BL_8 BLB_8 BL_24 BLB_24 BL_int_8 BLB_int_8 COL_MUX
X_SA_8 PRE SAEN BL_int_8 BLB_int_8 Q_8 Q_b_8 CMSA
X_WD_8 D_8 WEN BL_int_8 BLB_int_8 WRITE_DRIVER

* --- BIT 9 ---
Mpre1_9 BL_9 PRE VDD VDD pmos_sram m=2
Mpre2_9 BLB_9 PRE VDD VDD pmos_sram m=2
Meq_9 BL_9 PRE BLB_9 VDD pmos_sram m=2
Mpre1_25 BL_25 PRE VDD VDD pmos_sram m=2
Mpre2_25 BLB_25 PRE VDD VDD pmos_sram m=2
Meq_25 BL_25 PRE BLB_25 VDD pmos_sram m=2
X_MUX_9 A0 A0_B BL_9 BLB_9 BL_25 BLB_25 BL_int_9 BLB_int_9 COL_MUX
X_SA_9 PRE SAEN BL_int_9 BLB_int_9 Q_9 Q_b_9 CMSA
X_WD_9 D_9 WEN BL_int_9 BLB_int_9 WRITE_DRIVER

* --- BIT 10 ---
Mpre1_10 BL_10 PRE VDD VDD pmos_sram m=2
Mpre2_10 BLB_10 PRE VDD VDD pmos_sram m=2
Meq_10 BL_10 PRE BLB_10 VDD pmos_sram m=2
Mpre1_26 BL_26 PRE VDD VDD pmos_sram m=2
Mpre2_26 BLB_26 PRE VDD VDD pmos_sram m=2
Meq_26 BL_26 PRE BLB_26 VDD pmos_sram m=2
X_MUX_10 A0 A0_B BL_10 BLB_10 BL_26 BLB_26 BL_int_10 BLB_int_10 COL_MUX
X_SA_10 PRE SAEN BL_int_10 BLB_int_10 Q_10 Q_b_10 CMSA
X_WD_10 D_10 WEN BL_int_10 BLB_int_10 WRITE_DRIVER

* --- BIT 11 ---
Mpre1_11 BL_11 PRE VDD VDD pmos_sram m=2
Mpre2_11 BLB_11 PRE VDD VDD pmos_sram m=2
Meq_11 BL_11 PRE BLB_11 VDD pmos_sram m=2
Mpre1_27 BL_27 PRE VDD VDD pmos_sram m=2
Mpre2_27 BLB_27 PRE VDD VDD pmos_sram m=2
Meq_27 BL_27 PRE BLB_27 VDD pmos_sram m=2
X_MUX_11 A0 A0_B BL_11 BLB_11 BL_27 BLB_27 BL_int_11 BLB_int_11 COL_MUX
X_SA_11 PRE SAEN BL_int_11 BLB_int_11 Q_11 Q_b_11 CMSA
X_WD_11 D_11 WEN BL_int_11 BLB_int_11 WRITE_DRIVER

* --- BIT 12 ---
Mpre1_12 BL_12 PRE VDD VDD pmos_sram m=2
Mpre2_12 BLB_12 PRE VDD VDD pmos_sram m=2
Meq_12 BL_12 PRE BLB_12 VDD pmos_sram m=2
Mpre1_28 BL_28 PRE VDD VDD pmos_sram m=2
Mpre2_28 BLB_28 PRE VDD VDD pmos_sram m=2
Meq_28 BL_28 PRE BLB_28 VDD pmos_sram m=2
X_MUX_12 A0 A0_B BL_12 BLB_12 BL_28 BLB_28 BL_int_12 BLB_int_12 COL_MUX
X_SA_12 PRE SAEN BL_int_12 BLB_int_12 Q_12 Q_b_12 CMSA
X_WD_12 D_12 WEN BL_int_12 BLB_int_12 WRITE_DRIVER

* --- BIT 13 ---
Mpre1_13 BL_13 PRE VDD VDD pmos_sram m=2
Mpre2_13 BLB_13 PRE VDD VDD pmos_sram m=2
Meq_13 BL_13 PRE BLB_13 VDD pmos_sram m=2
Mpre1_29 BL_29 PRE VDD VDD pmos_sram m=2
Mpre2_29 BLB_29 PRE VDD VDD pmos_sram m=2
Meq_29 BL_29 PRE BLB_29 VDD pmos_sram m=2
X_MUX_13 A0 A0_B BL_13 BLB_13 BL_29 BLB_29 BL_int_13 BLB_int_13 COL_MUX
X_SA_13 PRE SAEN BL_int_13 BLB_int_13 Q_13 Q_b_13 CMSA
X_WD_13 D_13 WEN BL_int_13 BLB_int_13 WRITE_DRIVER

* --- BIT 14 ---
Mpre1_14 BL_14 PRE VDD VDD pmos_sram m=2
Mpre2_14 BLB_14 PRE VDD VDD pmos_sram m=2
Meq_14 BL_14 PRE BLB_14 VDD pmos_sram m=2
Mpre1_30 BL_30 PRE VDD VDD pmos_sram m=2
Mpre2_30 BLB_30 PRE VDD VDD pmos_sram m=2
Meq_30 BL_30 PRE BLB_30 VDD pmos_sram m=2
X_MUX_14 A0 A0_B BL_14 BLB_14 BL_30 BLB_30 BL_int_14 BLB_int_14 COL_MUX
X_SA_14 PRE SAEN BL_int_14 BLB_int_14 Q_14 Q_b_14 CMSA
X_WD_14 D_14 WEN BL_int_14 BLB_int_14 WRITE_DRIVER

* --- BIT 15 ---
Mpre1_15 BL_15 PRE VDD VDD pmos_sram m=2
Mpre2_15 BLB_15 PRE VDD VDD pmos_sram m=2
Meq_15 BL_15 PRE BLB_15 VDD pmos_sram m=2
Mpre1_31 BL_31 PRE VDD VDD pmos_sram m=2
Mpre2_31 BLB_31 PRE VDD VDD pmos_sram m=2
Meq_31 BL_31 PRE BLB_31 VDD pmos_sram m=2
X_MUX_15 A0 A0_B BL_15 BLB_15 BL_31 BLB_31 BL_int_15 BLB_int_15 COL_MUX
X_SA_15 PRE SAEN BL_int_15 BLB_int_15 Q_15 Q_b_15 CMSA
X_WD_15 D_15 WEN BL_int_15 BLB_int_15 WRITE_DRIVER

.ends COL_PERIPHERALS