* ==========================================
* FINAL PROJECT TOP-LEVEL TESTBENCH (2kb SRAM)
* ==========================================

.protect
.include '7nm_TT.pm'
.unprotect

.include 'sram_array_2kb.sp'
.include 'col_peripherals.sp'

.global VDD GND
Vdd VDD 0 0.7V

* --- 1:1:1 SRAM Cell ---
.subckt SRAM WL BL BLB q qb
Mpr  q   qb  VDD  VDD  pmos_sram  m=1
Mnr  q   qb  GND  GND  nmos_sram  m=1
Mpl  qb  q   VDD  VDD  pmos_sram  m=1
Mnl  qb  q   GND  GND  nmos_sram  m=1
Mnpr BL  WL  q    GND  nmos_sram  m=1
Mnpl BLB WL  qb   GND  nmos_sram  m=1
.ends

* --- Basic Logic Gates ---
.subckt INV IN OUT
Mp1 OUT IN VDD VDD pmos_sram W=54n L=20n
Mn1 OUT IN GND GND nmos_sram W=27n L=20n
.ends

.subckt INV_LARGE IN OUT
Mp1 OUT IN VDD VDD pmos_sram W=216n L=20n
Mn1 OUT IN GND GND nmos_sram W=108n L=20n
.ends

.subckt NAND2 A B OUT
Mp1 OUT A VDD VDD pmos_sram W=54n L=20n
Mp2 OUT B VDD VDD pmos_sram W=54n L=20n
Mn1 OUT A N1  GND nmos_sram W=54n L=20n
Mn2 N1  B GND GND nmos_sram W=54n L=20n
.ends

.subckt NAND3 A B C OUT
Mp1 OUT A VDD VDD pmos_sram W=54n L=20n
Mp2 OUT B VDD VDD pmos_sram W=54n L=20n
Mp3 OUT C VDD VDD pmos_sram W=54n L=20n
Mn1 OUT A N1  GND nmos_sram W=81n L=20n
Mn2 N1  B N2  GND nmos_sram W=81n L=20n
Mn3 N2  C GND GND nmos_sram W=81n L=20n
.ends

* --- Global Control Logic ---
.subckt CONTROL_LOGIC CLK WEN PRE SAEN CLK_WL
* PRE follows CLK (CLK=0: Precharge, CLK=1: Evaluate)
Xinv1 CLK pre_b INV
Xinv2 pre_b PRE INV

* Delay CLK slightly for Wordline to ensure precharge is off
Xinv3 CLK wl_b INV
Xinv4 wl_b CLK_WL INV

* Delay CLK more for SAEN (Sense Amp Enable)
Xinv5 CLK d1 INV
Xinv6 d1 d2 INV
Xinv7 d2 d3 INV
Xinv8 d3 clk_del INV

* SAEN is active only during READ (WEN=0) AND delayed CLK=1
Xinv9 WEN WEN_b INV
Xnand1 clk_del WEN_b saen_b NAND2
Xinv10 saen_b SAEN INV
.ends

* --- Row Decoder Subcircuit (From Ex2) ---
.subckt ROW_DECODER A0 A1 A2 A3 A4 A5 CLK_IN WL_0 WL_1 WL_2 WL_3 WL_4 WL_5 WL_6 WL_7 WL_8 WL_9 WL_10 WL_11 WL_12 WL_13 WL_14 WL_15 WL_16 WL_17 WL_18 WL_19 WL_20 WL_21 WL_22 WL_23 WL_24 WL_25 WL_26 WL_27 WL_28 WL_29 WL_30 WL_31 WL_32 WL_33 WL_34 WL_35 WL_36 WL_37 WL_38 WL_39 WL_40 WL_41 WL_42 WL_43 WL_44 WL_45 WL_46 WL_47 WL_48 WL_49 WL_50 WL_51 WL_52 WL_53 WL_54 WL_55 WL_56 WL_57 WL_58 WL_59 WL_60 WL_61 WL_62 WL_63 
Xbuf_clk CLK_IN clk_bar INV
Xbuf_clk2 clk_bar clk_buf INV
Xbuf_a0_1 A0 A_bar_0 INV
Xbuf_a0_2 A_bar_0 A_0_buf INV
Xbuf_a1_1 A1 A_bar_1 INV
Xbuf_a1_2 A_bar_1 A_1_buf INV
Xbuf_a2_1 A2 A_bar_2 INV
Xbuf_a2_2 A_bar_2 A_2_buf INV
Xbuf_a3_1 A3 A_bar_3 INV
Xbuf_a3_2 A_bar_3 A_3_buf INV
Xbuf_a4_1 A4 A_bar_4 INV
Xbuf_a4_2 A_bar_4 A_4_buf INV
Xbuf_a5_1 A5 A_bar_5 INV
Xbuf_a5_2 A_bar_5 A_5_buf INV
X_PD_1_NAND_0 A_bar_0 A_bar_1 A_bar_2 P1_nand_0 NAND3
X_PD_1_INV_0 P1_nand_0 P1_0 INV
X_PD_1_NAND_1 A_0_buf A_bar_1 A_bar_2 P1_nand_1 NAND3
X_PD_1_INV_1 P1_nand_1 P1_1 INV
X_PD_1_NAND_2 A_bar_0 A_1_buf A_bar_2 P1_nand_2 NAND3
X_PD_1_INV_2 P1_nand_2 P1_2 INV
X_PD_1_NAND_3 A_0_buf A_1_buf A_bar_2 P1_nand_3 NAND3
X_PD_1_INV_3 P1_nand_3 P1_3 INV
X_PD_1_NAND_4 A_bar_0 A_bar_1 A_2_buf P1_nand_4 NAND3
X_PD_1_INV_4 P1_nand_4 P1_4 INV
X_PD_1_NAND_5 A_0_buf A_bar_1 A_2_buf P1_nand_5 NAND3
X_PD_1_INV_5 P1_nand_5 P1_5 INV
X_PD_1_NAND_6 A_bar_0 A_1_buf A_2_buf P1_nand_6 NAND3
X_PD_1_INV_6 P1_nand_6 P1_6 INV
X_PD_1_NAND_7 A_0_buf A_1_buf A_2_buf P1_nand_7 NAND3
X_PD_1_INV_7 P1_nand_7 P1_7 INV
X_PD_2_NAND_0 A_bar_3 A_bar_4 A_bar_5 P2_nand_0 NAND3
X_PD_2_INV_0 P2_nand_0 P2_0 INV
X_PD_2_NAND_1 A_3_buf A_bar_4 A_bar_5 P2_nand_1 NAND3
X_PD_2_INV_1 P2_nand_1 P2_1 INV
X_PD_2_NAND_2 A_bar_3 A_4_buf A_bar_5 P2_nand_2 NAND3
X_PD_2_INV_2 P2_nand_2 P2_2 INV
X_PD_2_NAND_3 A_3_buf A_4_buf A_bar_5 P2_nand_3 NAND3
X_PD_2_INV_3 P2_nand_3 P2_3 INV
X_PD_2_NAND_4 A_bar_3 A_bar_4 A_5_buf P2_nand_4 NAND3
X_PD_2_INV_4 P2_nand_4 P2_4 INV
X_PD_2_NAND_5 A_3_buf A_bar_4 A_5_buf P2_nand_5 NAND3
X_PD_2_INV_5 P2_nand_5 P2_5 INV
X_PD_2_NAND_6 A_bar_3 A_4_buf A_5_buf P2_nand_6 NAND3
X_PD_2_INV_6 P2_nand_6 P2_6 INV
X_PD_2_NAND_7 A_3_buf A_4_buf A_5_buf P2_nand_7 NAND3
X_PD_2_INV_7 P2_nand_7 P2_7 INV
X_Final_NAND_0 P1_0 P2_0 clk_buf WL_NAND_OUT_0 NAND3
X_Final_INV_0 WL_NAND_OUT_0 WL_0 INV_LARGE
X_Final_NAND_1 P1_1 P2_0 clk_buf WL_NAND_OUT_1 NAND3
X_Final_INV_1 WL_NAND_OUT_1 WL_1 INV_LARGE
X_Final_NAND_2 P1_2 P2_0 clk_buf WL_NAND_OUT_2 NAND3
X_Final_INV_2 WL_NAND_OUT_2 WL_2 INV_LARGE
X_Final_NAND_3 P1_3 P2_0 clk_buf WL_NAND_OUT_3 NAND3
X_Final_INV_3 WL_NAND_OUT_3 WL_3 INV_LARGE
X_Final_NAND_4 P1_4 P2_0 clk_buf WL_NAND_OUT_4 NAND3
X_Final_INV_4 WL_NAND_OUT_4 WL_4 INV_LARGE
X_Final_NAND_5 P1_5 P2_0 clk_buf WL_NAND_OUT_5 NAND3
X_Final_INV_5 WL_NAND_OUT_5 WL_5 INV_LARGE
X_Final_NAND_6 P1_6 P2_0 clk_buf WL_NAND_OUT_6 NAND3
X_Final_INV_6 WL_NAND_OUT_6 WL_6 INV_LARGE
X_Final_NAND_7 P1_7 P2_0 clk_buf WL_NAND_OUT_7 NAND3
X_Final_INV_7 WL_NAND_OUT_7 WL_7 INV_LARGE
X_Final_NAND_8 P1_0 P2_1 clk_buf WL_NAND_OUT_8 NAND3
X_Final_INV_8 WL_NAND_OUT_8 WL_8 INV_LARGE
X_Final_NAND_9 P1_1 P2_1 clk_buf WL_NAND_OUT_9 NAND3
X_Final_INV_9 WL_NAND_OUT_9 WL_9 INV_LARGE
X_Final_NAND_10 P1_2 P2_1 clk_buf WL_NAND_OUT_10 NAND3
X_Final_INV_10 WL_NAND_OUT_10 WL_10 INV_LARGE
X_Final_NAND_11 P1_3 P2_1 clk_buf WL_NAND_OUT_11 NAND3
X_Final_INV_11 WL_NAND_OUT_11 WL_11 INV_LARGE
X_Final_NAND_12 P1_4 P2_1 clk_buf WL_NAND_OUT_12 NAND3
X_Final_INV_12 WL_NAND_OUT_12 WL_12 INV_LARGE
X_Final_NAND_13 P1_5 P2_1 clk_buf WL_NAND_OUT_13 NAND3
X_Final_INV_13 WL_NAND_OUT_13 WL_13 INV_LARGE
X_Final_NAND_14 P1_6 P2_1 clk_buf WL_NAND_OUT_14 NAND3
X_Final_INV_14 WL_NAND_OUT_14 WL_14 INV_LARGE
X_Final_NAND_15 P1_7 P2_1 clk_buf WL_NAND_OUT_15 NAND3
X_Final_INV_15 WL_NAND_OUT_15 WL_15 INV_LARGE
X_Final_NAND_16 P1_0 P2_2 clk_buf WL_NAND_OUT_16 NAND3
X_Final_INV_16 WL_NAND_OUT_16 WL_16 INV_LARGE
X_Final_NAND_17 P1_1 P2_2 clk_buf WL_NAND_OUT_17 NAND3
X_Final_INV_17 WL_NAND_OUT_17 WL_17 INV_LARGE
X_Final_NAND_18 P1_2 P2_2 clk_buf WL_NAND_OUT_18 NAND3
X_Final_INV_18 WL_NAND_OUT_18 WL_18 INV_LARGE
X_Final_NAND_19 P1_3 P2_2 clk_buf WL_NAND_OUT_19 NAND3
X_Final_INV_19 WL_NAND_OUT_19 WL_19 INV_LARGE
X_Final_NAND_20 P1_4 P2_2 clk_buf WL_NAND_OUT_20 NAND3
X_Final_INV_20 WL_NAND_OUT_20 WL_20 INV_LARGE
X_Final_NAND_21 P1_5 P2_2 clk_buf WL_NAND_OUT_21 NAND3
X_Final_INV_21 WL_NAND_OUT_21 WL_21 INV_LARGE
X_Final_NAND_22 P1_6 P2_2 clk_buf WL_NAND_OUT_22 NAND3
X_Final_INV_22 WL_NAND_OUT_22 WL_22 INV_LARGE
X_Final_NAND_23 P1_7 P2_2 clk_buf WL_NAND_OUT_23 NAND3
X_Final_INV_23 WL_NAND_OUT_23 WL_23 INV_LARGE
X_Final_NAND_24 P1_0 P2_3 clk_buf WL_NAND_OUT_24 NAND3
X_Final_INV_24 WL_NAND_OUT_24 WL_24 INV_LARGE
X_Final_NAND_25 P1_1 P2_3 clk_buf WL_NAND_OUT_25 NAND3
X_Final_INV_25 WL_NAND_OUT_25 WL_25 INV_LARGE
X_Final_NAND_26 P1_2 P2_3 clk_buf WL_NAND_OUT_26 NAND3
X_Final_INV_26 WL_NAND_OUT_26 WL_26 INV_LARGE
X_Final_NAND_27 P1_3 P2_3 clk_buf WL_NAND_OUT_27 NAND3
X_Final_INV_27 WL_NAND_OUT_27 WL_27 INV_LARGE
X_Final_NAND_28 P1_4 P2_3 clk_buf WL_NAND_OUT_28 NAND3
X_Final_INV_28 WL_NAND_OUT_28 WL_28 INV_LARGE
X_Final_NAND_29 P1_5 P2_3 clk_buf WL_NAND_OUT_29 NAND3
X_Final_INV_29 WL_NAND_OUT_29 WL_29 INV_LARGE
X_Final_NAND_30 P1_6 P2_3 clk_buf WL_NAND_OUT_30 NAND3
X_Final_INV_30 WL_NAND_OUT_30 WL_30 INV_LARGE
X_Final_NAND_31 P1_7 P2_3 clk_buf WL_NAND_OUT_31 NAND3
X_Final_INV_31 WL_NAND_OUT_31 WL_31 INV_LARGE
X_Final_NAND_32 P1_0 P2_4 clk_buf WL_NAND_OUT_32 NAND3
X_Final_INV_32 WL_NAND_OUT_32 WL_32 INV_LARGE
X_Final_NAND_33 P1_1 P2_4 clk_buf WL_NAND_OUT_33 NAND3
X_Final_INV_33 WL_NAND_OUT_33 WL_33 INV_LARGE
X_Final_NAND_34 P1_2 P2_4 clk_buf WL_NAND_OUT_34 NAND3
X_Final_INV_34 WL_NAND_OUT_34 WL_34 INV_LARGE
X_Final_NAND_35 P1_3 P2_4 clk_buf WL_NAND_OUT_35 NAND3
X_Final_INV_35 WL_NAND_OUT_35 WL_35 INV_LARGE
X_Final_NAND_36 P1_4 P2_4 clk_buf WL_NAND_OUT_36 NAND3
X_Final_INV_36 WL_NAND_OUT_36 WL_36 INV_LARGE
X_Final_NAND_37 P1_5 P2_4 clk_buf WL_NAND_OUT_37 NAND3
X_Final_INV_37 WL_NAND_OUT_37 WL_37 INV_LARGE
X_Final_NAND_38 P1_6 P2_4 clk_buf WL_NAND_OUT_38 NAND3
X_Final_INV_38 WL_NAND_OUT_38 WL_38 INV_LARGE
X_Final_NAND_39 P1_7 P2_4 clk_buf WL_NAND_OUT_39 NAND3
X_Final_INV_39 WL_NAND_OUT_39 WL_39 INV_LARGE
X_Final_NAND_40 P1_0 P2_5 clk_buf WL_NAND_OUT_40 NAND3
X_Final_INV_40 WL_NAND_OUT_40 WL_40 INV_LARGE
X_Final_NAND_41 P1_1 P2_5 clk_buf WL_NAND_OUT_41 NAND3
X_Final_INV_41 WL_NAND_OUT_41 WL_41 INV_LARGE
X_Final_NAND_42 P1_2 P2_5 clk_buf WL_NAND_OUT_42 NAND3
X_Final_INV_42 WL_NAND_OUT_42 WL_42 INV_LARGE
X_Final_NAND_43 P1_3 P2_5 clk_buf WL_NAND_OUT_43 NAND3
X_Final_INV_43 WL_NAND_OUT_43 WL_43 INV_LARGE
X_Final_NAND_44 P1_4 P2_5 clk_buf WL_NAND_OUT_44 NAND3
X_Final_INV_44 WL_NAND_OUT_44 WL_44 INV_LARGE
X_Final_NAND_45 P1_5 P2_5 clk_buf WL_NAND_OUT_45 NAND3
X_Final_INV_45 WL_NAND_OUT_45 WL_45 INV_LARGE
X_Final_NAND_46 P1_6 P2_5 clk_buf WL_NAND_OUT_46 NAND3
X_Final_INV_46 WL_NAND_OUT_46 WL_46 INV_LARGE
X_Final_NAND_47 P1_7 P2_5 clk_buf WL_NAND_OUT_47 NAND3
X_Final_INV_47 WL_NAND_OUT_47 WL_47 INV_LARGE
X_Final_NAND_48 P1_0 P2_6 clk_buf WL_NAND_OUT_48 NAND3
X_Final_INV_48 WL_NAND_OUT_48 WL_48 INV_LARGE
X_Final_NAND_49 P1_1 P2_6 clk_buf WL_NAND_OUT_49 NAND3
X_Final_INV_49 WL_NAND_OUT_49 WL_49 INV_LARGE
X_Final_NAND_50 P1_2 P2_6 clk_buf WL_NAND_OUT_50 NAND3
X_Final_INV_50 WL_NAND_OUT_50 WL_50 INV_LARGE
X_Final_NAND_51 P1_3 P2_6 clk_buf WL_NAND_OUT_51 NAND3
X_Final_INV_51 WL_NAND_OUT_51 WL_51 INV_LARGE
X_Final_NAND_52 P1_4 P2_6 clk_buf WL_NAND_OUT_52 NAND3
X_Final_INV_52 WL_NAND_OUT_52 WL_52 INV_LARGE
X_Final_NAND_53 P1_5 P2_6 clk_buf WL_NAND_OUT_53 NAND3
X_Final_INV_53 WL_NAND_OUT_53 WL_53 INV_LARGE
X_Final_NAND_54 P1_6 P2_6 clk_buf WL_NAND_OUT_54 NAND3
X_Final_INV_54 WL_NAND_OUT_54 WL_54 INV_LARGE
X_Final_NAND_55 P1_7 P2_6 clk_buf WL_NAND_OUT_55 NAND3
X_Final_INV_55 WL_NAND_OUT_55 WL_55 INV_LARGE
X_Final_NAND_56 P1_0 P2_7 clk_buf WL_NAND_OUT_56 NAND3
X_Final_INV_56 WL_NAND_OUT_56 WL_56 INV_LARGE
X_Final_NAND_57 P1_1 P2_7 clk_buf WL_NAND_OUT_57 NAND3
X_Final_INV_57 WL_NAND_OUT_57 WL_57 INV_LARGE
X_Final_NAND_58 P1_2 P2_7 clk_buf WL_NAND_OUT_58 NAND3
X_Final_INV_58 WL_NAND_OUT_58 WL_58 INV_LARGE
X_Final_NAND_59 P1_3 P2_7 clk_buf WL_NAND_OUT_59 NAND3
X_Final_INV_59 WL_NAND_OUT_59 WL_59 INV_LARGE
X_Final_NAND_60 P1_4 P2_7 clk_buf WL_NAND_OUT_60 NAND3
X_Final_INV_60 WL_NAND_OUT_60 WL_60 INV_LARGE
X_Final_NAND_61 P1_5 P2_7 clk_buf WL_NAND_OUT_61 NAND3
X_Final_INV_61 WL_NAND_OUT_61 WL_61 INV_LARGE
X_Final_NAND_62 P1_6 P2_7 clk_buf WL_NAND_OUT_62 NAND3
X_Final_INV_62 WL_NAND_OUT_62 WL_62 INV_LARGE
X_Final_NAND_63 P1_7 P2_7 clk_buf WL_NAND_OUT_63 NAND3
X_Final_INV_63 WL_NAND_OUT_63 WL_63 INV_LARGE
.ends

* --- TOP LEVEL INSTANTIATION ---
X_CTRL CLK WEN PRE SAEN CLK_WL CONTROL_LOGIC

X_DEC A_1 A_2 A_3 A_4 A_5 A_6 CLK_WL WL_0 WL_1 WL_2 WL_3 WL_4 WL_5 WL_6 WL_7 WL_8 WL_9 WL_10 WL_11 WL_12 WL_13 WL_14 WL_15 WL_16 WL_17 WL_18 WL_19 WL_20 WL_21 WL_22 WL_23 WL_24 WL_25 WL_26 WL_27 WL_28 WL_29 WL_30 WL_31 WL_32 WL_33 WL_34 WL_35 WL_36 WL_37 WL_38 WL_39 WL_40 WL_41 WL_42 WL_43 WL_44 WL_45 WL_46 WL_47 WL_48 WL_49 WL_50 WL_51 WL_52 WL_53 WL_54 WL_55 WL_56 WL_57 WL_58 WL_59 WL_60 WL_61 WL_62 WL_63 ROW_DECODER

X_MEM WL_0 WL_1 WL_2 WL_3 WL_4 WL_5 WL_6 WL_7 WL_8 WL_9 WL_10 WL_11 WL_12 WL_13 WL_14 WL_15 WL_16 WL_17 WL_18 WL_19 WL_20 WL_21 WL_22 WL_23 WL_24 WL_25 WL_26 WL_27 WL_28 WL_29 WL_30 WL_31 WL_32 WL_33 WL_34 WL_35 WL_36 WL_37 WL_38 WL_39 WL_40 WL_41 WL_42 WL_43 WL_44 WL_45 WL_46 WL_47 WL_48 WL_49 WL_50 WL_51 WL_52 WL_53 WL_54 WL_55 WL_56 WL_57 WL_58 WL_59 WL_60 WL_61 WL_62 WL_63 BL_0 BLB_0 BL_1 BLB_1 BL_2 BLB_2 BL_3 BLB_3 BL_4 BLB_4 BL_5 BLB_5 BL_6 BLB_6 BL_7 BLB_7 BL_8 BLB_8 BL_9 BLB_9 BL_10 BLB_10 BL_11 BLB_11 BL_12 BLB_12 BL_13 BLB_13 BL_14 BLB_14 BL_15 BLB_15 BL_16 BLB_16 BL_17 BLB_17 BL_18 BLB_18 BL_19 BLB_19 BL_20 BLB_20 BL_21 BLB_21 BL_22 BLB_22 BL_23 BLB_23 BL_24 BLB_24 BL_25 BLB_25 BL_26 BLB_26 BL_27 BLB_27 BL_28 BLB_28 BL_29 BLB_29 BL_30 BLB_30 BL_31 BLB_31 SRAM_ARRAY

Xinv_A0 A_0 A_0_B INV
X_PERIPH A_0 A_0_B PRE SAEN WEN BL_0 BLB_0 BL_1 BLB_1 BL_2 BLB_2 BL_3 BLB_3 BL_4 BLB_4 BL_5 BLB_5 BL_6 BLB_6 BL_7 BLB_7 BL_8 BLB_8 BL_9 BLB_9 BL_10 BLB_10 BL_11 BLB_11 BL_12 BLB_12 BL_13 BLB_13 BL_14 BLB_14 BL_15 BLB_15 BL_16 BLB_16 BL_17 BLB_17 BL_18 BLB_18 BL_19 BLB_19 BL_20 BLB_20 BL_21 BLB_21 BL_22 BLB_22 BL_23 BLB_23 BL_24 BLB_24 BL_25 BLB_25 BL_26 BLB_26 BL_27 BLB_27 BL_28 BLB_28 BL_29 BLB_29 BL_30 BLB_30 BL_31 BLB_31 D_0 D_1 D_2 D_3 D_4 D_5 D_6 D_7 D_8 D_9 D_10 D_11 D_12 D_13 D_14 D_15 Q_0 Q_b_0 Q_1 Q_b_1 Q_2 Q_b_2 Q_3 Q_b_3 Q_4 Q_b_4 Q_5 Q_b_5 Q_6 Q_b_6 Q_7 Q_b_7 Q_8 Q_b_8 Q_9 Q_b_9 Q_10 Q_b_10 Q_11 Q_b_11 Q_12 Q_b_12 Q_13 Q_b_13 Q_14 Q_b_14 Q_15 Q_b_15 COL_PERIPHERALS

* --- TEST STIMULI (4 Cycles) ---
* 1GHz Clock (1ns period, 50ps rise/fall as per spec)
Vclk CLK 0 PULSE(0 0.7 0 50p 50p 0.45n 1n)

* Cycle 1 (0-1ns): Write '1's to Address 0 (Row 0, Col 0)
* Cycle 2 (1-2ns): Write '0's to Address 1 (Row 0, Col 1)
* Cycle 3 (2-3ns): Read Address 0 (Expect '1's)
* Cycle 4 (3-4ns): Read Address 1 (Expect '0's)

Vwen WEN 0 PWL(0 0.7  1.9n 0.7  1.95n 0  4n 0)
Va0 A_0 0 PWL(0 0  0.9n 0  0.95n 0.7  1.9n 0.7  1.95n 0  2.9n 0  2.95n 0.7  4.5n 0.7)
Va1 A_1 0 DC 0V
Va2 A_2 0 DC 0V
Va3 A_3 0 DC 0V
Va4 A_4 0 DC 0V
Va5 A_5 0 DC 0V
Va6 A_6 0 DC 0V
Vd0 D_0 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd1 D_1 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd2 D_2 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd3 D_3 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd4 D_4 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd5 D_5 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd6 D_6 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd7 D_7 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd8 D_8 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd9 D_9 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd10 D_10 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd11 D_11 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd12 D_12 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd13 D_13 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd14 D_14 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
Vd15 D_15 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)
* --- INITIAL CONDITIONS ---
.ic v(BL_0)=0.7v v(BLB_0)=0.7v
.ic v(BL_1)=0.7v v(BLB_1)=0.7v
.ic v(BL_2)=0.7v v(BLB_2)=0.7v
.ic v(BL_3)=0.7v v(BLB_3)=0.7v
.ic v(BL_4)=0.7v v(BLB_4)=0.7v
.ic v(BL_5)=0.7v v(BLB_5)=0.7v
.ic v(BL_6)=0.7v v(BLB_6)=0.7v
.ic v(BL_7)=0.7v v(BLB_7)=0.7v
.ic v(BL_8)=0.7v v(BLB_8)=0.7v
.ic v(BL_9)=0.7v v(BLB_9)=0.7v
.ic v(BL_10)=0.7v v(BLB_10)=0.7v
.ic v(BL_11)=0.7v v(BLB_11)=0.7v
.ic v(BL_12)=0.7v v(BLB_12)=0.7v
.ic v(BL_13)=0.7v v(BLB_13)=0.7v
.ic v(BL_14)=0.7v v(BLB_14)=0.7v
.ic v(BL_15)=0.7v v(BLB_15)=0.7v
.ic v(BL_16)=0.7v v(BLB_16)=0.7v
.ic v(BL_17)=0.7v v(BLB_17)=0.7v
.ic v(BL_18)=0.7v v(BLB_18)=0.7v
.ic v(BL_19)=0.7v v(BLB_19)=0.7v
.ic v(BL_20)=0.7v v(BLB_20)=0.7v
.ic v(BL_21)=0.7v v(BLB_21)=0.7v
.ic v(BL_22)=0.7v v(BLB_22)=0.7v
.ic v(BL_23)=0.7v v(BLB_23)=0.7v
.ic v(BL_24)=0.7v v(BLB_24)=0.7v
.ic v(BL_25)=0.7v v(BLB_25)=0.7v
.ic v(BL_26)=0.7v v(BLB_26)=0.7v
.ic v(BL_27)=0.7v v(BLB_27)=0.7v
.ic v(BL_28)=0.7v v(BLB_28)=0.7v
.ic v(BL_29)=0.7v v(BLB_29)=0.7v
.ic v(BL_30)=0.7v v(BLB_30)=0.7v
.ic v(BL_31)=0.7v v(BLB_31)=0.7v
.ic v(X_PERIPH.BL_int_0)=0.7v v(X_PERIPH.BLB_int_0)=0.7v
.ic v(X_PERIPH.BL_int_1)=0.7v v(X_PERIPH.BLB_int_1)=0.7v
.ic v(X_PERIPH.BL_int_2)=0.7v v(X_PERIPH.BLB_int_2)=0.7v
.ic v(X_PERIPH.BL_int_3)=0.7v v(X_PERIPH.BLB_int_3)=0.7v
.ic v(X_PERIPH.BL_int_4)=0.7v v(X_PERIPH.BLB_int_4)=0.7v
.ic v(X_PERIPH.BL_int_5)=0.7v v(X_PERIPH.BLB_int_5)=0.7v
.ic v(X_PERIPH.BL_int_6)=0.7v v(X_PERIPH.BLB_int_6)=0.7v
.ic v(X_PERIPH.BL_int_7)=0.7v v(X_PERIPH.BLB_int_7)=0.7v
.ic v(X_PERIPH.BL_int_8)=0.7v v(X_PERIPH.BLB_int_8)=0.7v
.ic v(X_PERIPH.BL_int_9)=0.7v v(X_PERIPH.BLB_int_9)=0.7v
.ic v(X_PERIPH.BL_int_10)=0.7v v(X_PERIPH.BLB_int_10)=0.7v
.ic v(X_PERIPH.BL_int_11)=0.7v v(X_PERIPH.BLB_int_11)=0.7v
.ic v(X_PERIPH.BL_int_12)=0.7v v(X_PERIPH.BLB_int_12)=0.7v
.ic v(X_PERIPH.BL_int_13)=0.7v v(X_PERIPH.BLB_int_13)=0.7v
.ic v(X_PERIPH.BL_int_14)=0.7v v(X_PERIPH.BLB_int_14)=0.7v
.ic v(X_PERIPH.BL_int_15)=0.7v v(X_PERIPH.BLB_int_15)=0.7v
.ic v(X_MEM.X_cell_0_0.q)=0v v(X_MEM.X_cell_0_0.qb)=0.7v
.ic v(X_MEM.X_cell_0_1.q)=0v v(X_MEM.X_cell_0_1.qb)=0.7v
.ic v(X_MEM.X_cell_0_2.q)=0v v(X_MEM.X_cell_0_2.qb)=0.7v
.ic v(X_MEM.X_cell_0_3.q)=0v v(X_MEM.X_cell_0_3.qb)=0.7v
.ic v(X_MEM.X_cell_0_4.q)=0v v(X_MEM.X_cell_0_4.qb)=0.7v
.ic v(X_MEM.X_cell_0_5.q)=0v v(X_MEM.X_cell_0_5.qb)=0.7v
.ic v(X_MEM.X_cell_0_6.q)=0v v(X_MEM.X_cell_0_6.qb)=0.7v
.ic v(X_MEM.X_cell_0_7.q)=0v v(X_MEM.X_cell_0_7.qb)=0.7v
.ic v(X_MEM.X_cell_0_8.q)=0v v(X_MEM.X_cell_0_8.qb)=0.7v
.ic v(X_MEM.X_cell_0_9.q)=0v v(X_MEM.X_cell_0_9.qb)=0.7v
.ic v(X_MEM.X_cell_0_10.q)=0v v(X_MEM.X_cell_0_10.qb)=0.7v
.ic v(X_MEM.X_cell_0_11.q)=0v v(X_MEM.X_cell_0_11.qb)=0.7v
.ic v(X_MEM.X_cell_0_12.q)=0v v(X_MEM.X_cell_0_12.qb)=0.7v
.ic v(X_MEM.X_cell_0_13.q)=0v v(X_MEM.X_cell_0_13.qb)=0.7v
.ic v(X_MEM.X_cell_0_14.q)=0v v(X_MEM.X_cell_0_14.qb)=0.7v
.ic v(X_MEM.X_cell_0_15.q)=0v v(X_MEM.X_cell_0_15.qb)=0.7v
.ic v(X_MEM.X_cell_0_16.q)=0v v(X_MEM.X_cell_0_16.qb)=0.7v
.ic v(X_MEM.X_cell_0_17.q)=0v v(X_MEM.X_cell_0_17.qb)=0.7v
.ic v(X_MEM.X_cell_0_18.q)=0v v(X_MEM.X_cell_0_18.qb)=0.7v
.ic v(X_MEM.X_cell_0_19.q)=0v v(X_MEM.X_cell_0_19.qb)=0.7v
.ic v(X_MEM.X_cell_0_20.q)=0v v(X_MEM.X_cell_0_20.qb)=0.7v
.ic v(X_MEM.X_cell_0_21.q)=0v v(X_MEM.X_cell_0_21.qb)=0.7v
.ic v(X_MEM.X_cell_0_22.q)=0v v(X_MEM.X_cell_0_22.qb)=0.7v
.ic v(X_MEM.X_cell_0_23.q)=0v v(X_MEM.X_cell_0_23.qb)=0.7v
.ic v(X_MEM.X_cell_0_24.q)=0v v(X_MEM.X_cell_0_24.qb)=0.7v
.ic v(X_MEM.X_cell_0_25.q)=0v v(X_MEM.X_cell_0_25.qb)=0.7v
.ic v(X_MEM.X_cell_0_26.q)=0v v(X_MEM.X_cell_0_26.qb)=0.7v
.ic v(X_MEM.X_cell_0_27.q)=0v v(X_MEM.X_cell_0_27.qb)=0.7v
.ic v(X_MEM.X_cell_0_28.q)=0v v(X_MEM.X_cell_0_28.qb)=0.7v
.ic v(X_MEM.X_cell_0_29.q)=0v v(X_MEM.X_cell_0_29.qb)=0.7v
.ic v(X_MEM.X_cell_0_30.q)=0v v(X_MEM.X_cell_0_30.qb)=0.7v
.ic v(X_MEM.X_cell_0_31.q)=0v v(X_MEM.X_cell_0_31.qb)=0.7v
.ic v(X_MEM.X_cell_1_0.q)=0v v(X_MEM.X_cell_1_0.qb)=0.7v
.ic v(X_MEM.X_cell_1_1.q)=0v v(X_MEM.X_cell_1_1.qb)=0.7v
.ic v(X_MEM.X_cell_1_2.q)=0v v(X_MEM.X_cell_1_2.qb)=0.7v
.ic v(X_MEM.X_cell_1_3.q)=0v v(X_MEM.X_cell_1_3.qb)=0.7v
.ic v(X_MEM.X_cell_1_4.q)=0v v(X_MEM.X_cell_1_4.qb)=0.7v
.ic v(X_MEM.X_cell_1_5.q)=0v v(X_MEM.X_cell_1_5.qb)=0.7v
.ic v(X_MEM.X_cell_1_6.q)=0v v(X_MEM.X_cell_1_6.qb)=0.7v
.ic v(X_MEM.X_cell_1_7.q)=0v v(X_MEM.X_cell_1_7.qb)=0.7v
.ic v(X_MEM.X_cell_1_8.q)=0v v(X_MEM.X_cell_1_8.qb)=0.7v
.ic v(X_MEM.X_cell_1_9.q)=0v v(X_MEM.X_cell_1_9.qb)=0.7v
.ic v(X_MEM.X_cell_1_10.q)=0v v(X_MEM.X_cell_1_10.qb)=0.7v
.ic v(X_MEM.X_cell_1_11.q)=0v v(X_MEM.X_cell_1_11.qb)=0.7v
.ic v(X_MEM.X_cell_1_12.q)=0v v(X_MEM.X_cell_1_12.qb)=0.7v
.ic v(X_MEM.X_cell_1_13.q)=0v v(X_MEM.X_cell_1_13.qb)=0.7v
.ic v(X_MEM.X_cell_1_14.q)=0v v(X_MEM.X_cell_1_14.qb)=0.7v
.ic v(X_MEM.X_cell_1_15.q)=0v v(X_MEM.X_cell_1_15.qb)=0.7v
.ic v(X_MEM.X_cell_1_16.q)=0v v(X_MEM.X_cell_1_16.qb)=0.7v
.ic v(X_MEM.X_cell_1_17.q)=0v v(X_MEM.X_cell_1_17.qb)=0.7v
.ic v(X_MEM.X_cell_1_18.q)=0v v(X_MEM.X_cell_1_18.qb)=0.7v
.ic v(X_MEM.X_cell_1_19.q)=0v v(X_MEM.X_cell_1_19.qb)=0.7v
.ic v(X_MEM.X_cell_1_20.q)=0v v(X_MEM.X_cell_1_20.qb)=0.7v
.ic v(X_MEM.X_cell_1_21.q)=0v v(X_MEM.X_cell_1_21.qb)=0.7v
.ic v(X_MEM.X_cell_1_22.q)=0v v(X_MEM.X_cell_1_22.qb)=0.7v
.ic v(X_MEM.X_cell_1_23.q)=0v v(X_MEM.X_cell_1_23.qb)=0.7v
.ic v(X_MEM.X_cell_1_24.q)=0v v(X_MEM.X_cell_1_24.qb)=0.7v
.ic v(X_MEM.X_cell_1_25.q)=0v v(X_MEM.X_cell_1_25.qb)=0.7v
.ic v(X_MEM.X_cell_1_26.q)=0v v(X_MEM.X_cell_1_26.qb)=0.7v
.ic v(X_MEM.X_cell_1_27.q)=0v v(X_MEM.X_cell_1_27.qb)=0.7v
.ic v(X_MEM.X_cell_1_28.q)=0v v(X_MEM.X_cell_1_28.qb)=0.7v
.ic v(X_MEM.X_cell_1_29.q)=0v v(X_MEM.X_cell_1_29.qb)=0.7v
.ic v(X_MEM.X_cell_1_30.q)=0v v(X_MEM.X_cell_1_30.qb)=0.7v
.ic v(X_MEM.X_cell_1_31.q)=0v v(X_MEM.X_cell_1_31.qb)=0.7v
.ic v(X_MEM.X_cell_2_0.q)=0v v(X_MEM.X_cell_2_0.qb)=0.7v
.ic v(X_MEM.X_cell_2_1.q)=0v v(X_MEM.X_cell_2_1.qb)=0.7v
.ic v(X_MEM.X_cell_2_2.q)=0v v(X_MEM.X_cell_2_2.qb)=0.7v
.ic v(X_MEM.X_cell_2_3.q)=0v v(X_MEM.X_cell_2_3.qb)=0.7v
.ic v(X_MEM.X_cell_2_4.q)=0v v(X_MEM.X_cell_2_4.qb)=0.7v
.ic v(X_MEM.X_cell_2_5.q)=0v v(X_MEM.X_cell_2_5.qb)=0.7v
.ic v(X_MEM.X_cell_2_6.q)=0v v(X_MEM.X_cell_2_6.qb)=0.7v
.ic v(X_MEM.X_cell_2_7.q)=0v v(X_MEM.X_cell_2_7.qb)=0.7v
.ic v(X_MEM.X_cell_2_8.q)=0v v(X_MEM.X_cell_2_8.qb)=0.7v
.ic v(X_MEM.X_cell_2_9.q)=0v v(X_MEM.X_cell_2_9.qb)=0.7v
.ic v(X_MEM.X_cell_2_10.q)=0v v(X_MEM.X_cell_2_10.qb)=0.7v
.ic v(X_MEM.X_cell_2_11.q)=0v v(X_MEM.X_cell_2_11.qb)=0.7v
.ic v(X_MEM.X_cell_2_12.q)=0v v(X_MEM.X_cell_2_12.qb)=0.7v
.ic v(X_MEM.X_cell_2_13.q)=0v v(X_MEM.X_cell_2_13.qb)=0.7v
.ic v(X_MEM.X_cell_2_14.q)=0v v(X_MEM.X_cell_2_14.qb)=0.7v
.ic v(X_MEM.X_cell_2_15.q)=0v v(X_MEM.X_cell_2_15.qb)=0.7v
.ic v(X_MEM.X_cell_2_16.q)=0v v(X_MEM.X_cell_2_16.qb)=0.7v
.ic v(X_MEM.X_cell_2_17.q)=0v v(X_MEM.X_cell_2_17.qb)=0.7v
.ic v(X_MEM.X_cell_2_18.q)=0v v(X_MEM.X_cell_2_18.qb)=0.7v
.ic v(X_MEM.X_cell_2_19.q)=0v v(X_MEM.X_cell_2_19.qb)=0.7v
.ic v(X_MEM.X_cell_2_20.q)=0v v(X_MEM.X_cell_2_20.qb)=0.7v
.ic v(X_MEM.X_cell_2_21.q)=0v v(X_MEM.X_cell_2_21.qb)=0.7v
.ic v(X_MEM.X_cell_2_22.q)=0v v(X_MEM.X_cell_2_22.qb)=0.7v
.ic v(X_MEM.X_cell_2_23.q)=0v v(X_MEM.X_cell_2_23.qb)=0.7v
.ic v(X_MEM.X_cell_2_24.q)=0v v(X_MEM.X_cell_2_24.qb)=0.7v
.ic v(X_MEM.X_cell_2_25.q)=0v v(X_MEM.X_cell_2_25.qb)=0.7v
.ic v(X_MEM.X_cell_2_26.q)=0v v(X_MEM.X_cell_2_26.qb)=0.7v
.ic v(X_MEM.X_cell_2_27.q)=0v v(X_MEM.X_cell_2_27.qb)=0.7v
.ic v(X_MEM.X_cell_2_28.q)=0v v(X_MEM.X_cell_2_28.qb)=0.7v
.ic v(X_MEM.X_cell_2_29.q)=0v v(X_MEM.X_cell_2_29.qb)=0.7v
.ic v(X_MEM.X_cell_2_30.q)=0v v(X_MEM.X_cell_2_30.qb)=0.7v
.ic v(X_MEM.X_cell_2_31.q)=0v v(X_MEM.X_cell_2_31.qb)=0.7v
.ic v(X_MEM.X_cell_3_0.q)=0v v(X_MEM.X_cell_3_0.qb)=0.7v
.ic v(X_MEM.X_cell_3_1.q)=0v v(X_MEM.X_cell_3_1.qb)=0.7v
.ic v(X_MEM.X_cell_3_2.q)=0v v(X_MEM.X_cell_3_2.qb)=0.7v
.ic v(X_MEM.X_cell_3_3.q)=0v v(X_MEM.X_cell_3_3.qb)=0.7v
.ic v(X_MEM.X_cell_3_4.q)=0v v(X_MEM.X_cell_3_4.qb)=0.7v
.ic v(X_MEM.X_cell_3_5.q)=0v v(X_MEM.X_cell_3_5.qb)=0.7v
.ic v(X_MEM.X_cell_3_6.q)=0v v(X_MEM.X_cell_3_6.qb)=0.7v
.ic v(X_MEM.X_cell_3_7.q)=0v v(X_MEM.X_cell_3_7.qb)=0.7v
.ic v(X_MEM.X_cell_3_8.q)=0v v(X_MEM.X_cell_3_8.qb)=0.7v
.ic v(X_MEM.X_cell_3_9.q)=0v v(X_MEM.X_cell_3_9.qb)=0.7v
.ic v(X_MEM.X_cell_3_10.q)=0v v(X_MEM.X_cell_3_10.qb)=0.7v
.ic v(X_MEM.X_cell_3_11.q)=0v v(X_MEM.X_cell_3_11.qb)=0.7v
.ic v(X_MEM.X_cell_3_12.q)=0v v(X_MEM.X_cell_3_12.qb)=0.7v
.ic v(X_MEM.X_cell_3_13.q)=0v v(X_MEM.X_cell_3_13.qb)=0.7v
.ic v(X_MEM.X_cell_3_14.q)=0v v(X_MEM.X_cell_3_14.qb)=0.7v
.ic v(X_MEM.X_cell_3_15.q)=0v v(X_MEM.X_cell_3_15.qb)=0.7v
.ic v(X_MEM.X_cell_3_16.q)=0v v(X_MEM.X_cell_3_16.qb)=0.7v
.ic v(X_MEM.X_cell_3_17.q)=0v v(X_MEM.X_cell_3_17.qb)=0.7v
.ic v(X_MEM.X_cell_3_18.q)=0v v(X_MEM.X_cell_3_18.qb)=0.7v
.ic v(X_MEM.X_cell_3_19.q)=0v v(X_MEM.X_cell_3_19.qb)=0.7v
.ic v(X_MEM.X_cell_3_20.q)=0v v(X_MEM.X_cell_3_20.qb)=0.7v
.ic v(X_MEM.X_cell_3_21.q)=0v v(X_MEM.X_cell_3_21.qb)=0.7v
.ic v(X_MEM.X_cell_3_22.q)=0v v(X_MEM.X_cell_3_22.qb)=0.7v
.ic v(X_MEM.X_cell_3_23.q)=0v v(X_MEM.X_cell_3_23.qb)=0.7v
.ic v(X_MEM.X_cell_3_24.q)=0v v(X_MEM.X_cell_3_24.qb)=0.7v
.ic v(X_MEM.X_cell_3_25.q)=0v v(X_MEM.X_cell_3_25.qb)=0.7v
.ic v(X_MEM.X_cell_3_26.q)=0v v(X_MEM.X_cell_3_26.qb)=0.7v
.ic v(X_MEM.X_cell_3_27.q)=0v v(X_MEM.X_cell_3_27.qb)=0.7v
.ic v(X_MEM.X_cell_3_28.q)=0v v(X_MEM.X_cell_3_28.qb)=0.7v
.ic v(X_MEM.X_cell_3_29.q)=0v v(X_MEM.X_cell_3_29.qb)=0.7v
.ic v(X_MEM.X_cell_3_30.q)=0v v(X_MEM.X_cell_3_30.qb)=0.7v
.ic v(X_MEM.X_cell_3_31.q)=0v v(X_MEM.X_cell_3_31.qb)=0.7v
.ic v(X_MEM.X_cell_4_0.q)=0v v(X_MEM.X_cell_4_0.qb)=0.7v
.ic v(X_MEM.X_cell_4_1.q)=0v v(X_MEM.X_cell_4_1.qb)=0.7v
.ic v(X_MEM.X_cell_4_2.q)=0v v(X_MEM.X_cell_4_2.qb)=0.7v
.ic v(X_MEM.X_cell_4_3.q)=0v v(X_MEM.X_cell_4_3.qb)=0.7v
.ic v(X_MEM.X_cell_4_4.q)=0v v(X_MEM.X_cell_4_4.qb)=0.7v
.ic v(X_MEM.X_cell_4_5.q)=0v v(X_MEM.X_cell_4_5.qb)=0.7v
.ic v(X_MEM.X_cell_4_6.q)=0v v(X_MEM.X_cell_4_6.qb)=0.7v
.ic v(X_MEM.X_cell_4_7.q)=0v v(X_MEM.X_cell_4_7.qb)=0.7v
.ic v(X_MEM.X_cell_4_8.q)=0v v(X_MEM.X_cell_4_8.qb)=0.7v
.ic v(X_MEM.X_cell_4_9.q)=0v v(X_MEM.X_cell_4_9.qb)=0.7v
.ic v(X_MEM.X_cell_4_10.q)=0v v(X_MEM.X_cell_4_10.qb)=0.7v
.ic v(X_MEM.X_cell_4_11.q)=0v v(X_MEM.X_cell_4_11.qb)=0.7v
.ic v(X_MEM.X_cell_4_12.q)=0v v(X_MEM.X_cell_4_12.qb)=0.7v
.ic v(X_MEM.X_cell_4_13.q)=0v v(X_MEM.X_cell_4_13.qb)=0.7v
.ic v(X_MEM.X_cell_4_14.q)=0v v(X_MEM.X_cell_4_14.qb)=0.7v
.ic v(X_MEM.X_cell_4_15.q)=0v v(X_MEM.X_cell_4_15.qb)=0.7v
.ic v(X_MEM.X_cell_4_16.q)=0v v(X_MEM.X_cell_4_16.qb)=0.7v
.ic v(X_MEM.X_cell_4_17.q)=0v v(X_MEM.X_cell_4_17.qb)=0.7v
.ic v(X_MEM.X_cell_4_18.q)=0v v(X_MEM.X_cell_4_18.qb)=0.7v
.ic v(X_MEM.X_cell_4_19.q)=0v v(X_MEM.X_cell_4_19.qb)=0.7v
.ic v(X_MEM.X_cell_4_20.q)=0v v(X_MEM.X_cell_4_20.qb)=0.7v
.ic v(X_MEM.X_cell_4_21.q)=0v v(X_MEM.X_cell_4_21.qb)=0.7v
.ic v(X_MEM.X_cell_4_22.q)=0v v(X_MEM.X_cell_4_22.qb)=0.7v
.ic v(X_MEM.X_cell_4_23.q)=0v v(X_MEM.X_cell_4_23.qb)=0.7v
.ic v(X_MEM.X_cell_4_24.q)=0v v(X_MEM.X_cell_4_24.qb)=0.7v
.ic v(X_MEM.X_cell_4_25.q)=0v v(X_MEM.X_cell_4_25.qb)=0.7v
.ic v(X_MEM.X_cell_4_26.q)=0v v(X_MEM.X_cell_4_26.qb)=0.7v
.ic v(X_MEM.X_cell_4_27.q)=0v v(X_MEM.X_cell_4_27.qb)=0.7v
.ic v(X_MEM.X_cell_4_28.q)=0v v(X_MEM.X_cell_4_28.qb)=0.7v
.ic v(X_MEM.X_cell_4_29.q)=0v v(X_MEM.X_cell_4_29.qb)=0.7v
.ic v(X_MEM.X_cell_4_30.q)=0v v(X_MEM.X_cell_4_30.qb)=0.7v
.ic v(X_MEM.X_cell_4_31.q)=0v v(X_MEM.X_cell_4_31.qb)=0.7v
.ic v(X_MEM.X_cell_5_0.q)=0v v(X_MEM.X_cell_5_0.qb)=0.7v
.ic v(X_MEM.X_cell_5_1.q)=0v v(X_MEM.X_cell_5_1.qb)=0.7v
.ic v(X_MEM.X_cell_5_2.q)=0v v(X_MEM.X_cell_5_2.qb)=0.7v
.ic v(X_MEM.X_cell_5_3.q)=0v v(X_MEM.X_cell_5_3.qb)=0.7v
.ic v(X_MEM.X_cell_5_4.q)=0v v(X_MEM.X_cell_5_4.qb)=0.7v
.ic v(X_MEM.X_cell_5_5.q)=0v v(X_MEM.X_cell_5_5.qb)=0.7v
.ic v(X_MEM.X_cell_5_6.q)=0v v(X_MEM.X_cell_5_6.qb)=0.7v
.ic v(X_MEM.X_cell_5_7.q)=0v v(X_MEM.X_cell_5_7.qb)=0.7v
.ic v(X_MEM.X_cell_5_8.q)=0v v(X_MEM.X_cell_5_8.qb)=0.7v
.ic v(X_MEM.X_cell_5_9.q)=0v v(X_MEM.X_cell_5_9.qb)=0.7v
.ic v(X_MEM.X_cell_5_10.q)=0v v(X_MEM.X_cell_5_10.qb)=0.7v
.ic v(X_MEM.X_cell_5_11.q)=0v v(X_MEM.X_cell_5_11.qb)=0.7v
.ic v(X_MEM.X_cell_5_12.q)=0v v(X_MEM.X_cell_5_12.qb)=0.7v
.ic v(X_MEM.X_cell_5_13.q)=0v v(X_MEM.X_cell_5_13.qb)=0.7v
.ic v(X_MEM.X_cell_5_14.q)=0v v(X_MEM.X_cell_5_14.qb)=0.7v
.ic v(X_MEM.X_cell_5_15.q)=0v v(X_MEM.X_cell_5_15.qb)=0.7v
.ic v(X_MEM.X_cell_5_16.q)=0v v(X_MEM.X_cell_5_16.qb)=0.7v
.ic v(X_MEM.X_cell_5_17.q)=0v v(X_MEM.X_cell_5_17.qb)=0.7v
.ic v(X_MEM.X_cell_5_18.q)=0v v(X_MEM.X_cell_5_18.qb)=0.7v
.ic v(X_MEM.X_cell_5_19.q)=0v v(X_MEM.X_cell_5_19.qb)=0.7v
.ic v(X_MEM.X_cell_5_20.q)=0v v(X_MEM.X_cell_5_20.qb)=0.7v
.ic v(X_MEM.X_cell_5_21.q)=0v v(X_MEM.X_cell_5_21.qb)=0.7v
.ic v(X_MEM.X_cell_5_22.q)=0v v(X_MEM.X_cell_5_22.qb)=0.7v
.ic v(X_MEM.X_cell_5_23.q)=0v v(X_MEM.X_cell_5_23.qb)=0.7v
.ic v(X_MEM.X_cell_5_24.q)=0v v(X_MEM.X_cell_5_24.qb)=0.7v
.ic v(X_MEM.X_cell_5_25.q)=0v v(X_MEM.X_cell_5_25.qb)=0.7v
.ic v(X_MEM.X_cell_5_26.q)=0v v(X_MEM.X_cell_5_26.qb)=0.7v
.ic v(X_MEM.X_cell_5_27.q)=0v v(X_MEM.X_cell_5_27.qb)=0.7v
.ic v(X_MEM.X_cell_5_28.q)=0v v(X_MEM.X_cell_5_28.qb)=0.7v
.ic v(X_MEM.X_cell_5_29.q)=0v v(X_MEM.X_cell_5_29.qb)=0.7v
.ic v(X_MEM.X_cell_5_30.q)=0v v(X_MEM.X_cell_5_30.qb)=0.7v
.ic v(X_MEM.X_cell_5_31.q)=0v v(X_MEM.X_cell_5_31.qb)=0.7v
.ic v(X_MEM.X_cell_6_0.q)=0v v(X_MEM.X_cell_6_0.qb)=0.7v
.ic v(X_MEM.X_cell_6_1.q)=0v v(X_MEM.X_cell_6_1.qb)=0.7v
.ic v(X_MEM.X_cell_6_2.q)=0v v(X_MEM.X_cell_6_2.qb)=0.7v
.ic v(X_MEM.X_cell_6_3.q)=0v v(X_MEM.X_cell_6_3.qb)=0.7v
.ic v(X_MEM.X_cell_6_4.q)=0v v(X_MEM.X_cell_6_4.qb)=0.7v
.ic v(X_MEM.X_cell_6_5.q)=0v v(X_MEM.X_cell_6_5.qb)=0.7v
.ic v(X_MEM.X_cell_6_6.q)=0v v(X_MEM.X_cell_6_6.qb)=0.7v
.ic v(X_MEM.X_cell_6_7.q)=0v v(X_MEM.X_cell_6_7.qb)=0.7v
.ic v(X_MEM.X_cell_6_8.q)=0v v(X_MEM.X_cell_6_8.qb)=0.7v
.ic v(X_MEM.X_cell_6_9.q)=0v v(X_MEM.X_cell_6_9.qb)=0.7v
.ic v(X_MEM.X_cell_6_10.q)=0v v(X_MEM.X_cell_6_10.qb)=0.7v
.ic v(X_MEM.X_cell_6_11.q)=0v v(X_MEM.X_cell_6_11.qb)=0.7v
.ic v(X_MEM.X_cell_6_12.q)=0v v(X_MEM.X_cell_6_12.qb)=0.7v
.ic v(X_MEM.X_cell_6_13.q)=0v v(X_MEM.X_cell_6_13.qb)=0.7v
.ic v(X_MEM.X_cell_6_14.q)=0v v(X_MEM.X_cell_6_14.qb)=0.7v
.ic v(X_MEM.X_cell_6_15.q)=0v v(X_MEM.X_cell_6_15.qb)=0.7v
.ic v(X_MEM.X_cell_6_16.q)=0v v(X_MEM.X_cell_6_16.qb)=0.7v
.ic v(X_MEM.X_cell_6_17.q)=0v v(X_MEM.X_cell_6_17.qb)=0.7v
.ic v(X_MEM.X_cell_6_18.q)=0v v(X_MEM.X_cell_6_18.qb)=0.7v
.ic v(X_MEM.X_cell_6_19.q)=0v v(X_MEM.X_cell_6_19.qb)=0.7v
.ic v(X_MEM.X_cell_6_20.q)=0v v(X_MEM.X_cell_6_20.qb)=0.7v
.ic v(X_MEM.X_cell_6_21.q)=0v v(X_MEM.X_cell_6_21.qb)=0.7v
.ic v(X_MEM.X_cell_6_22.q)=0v v(X_MEM.X_cell_6_22.qb)=0.7v
.ic v(X_MEM.X_cell_6_23.q)=0v v(X_MEM.X_cell_6_23.qb)=0.7v
.ic v(X_MEM.X_cell_6_24.q)=0v v(X_MEM.X_cell_6_24.qb)=0.7v
.ic v(X_MEM.X_cell_6_25.q)=0v v(X_MEM.X_cell_6_25.qb)=0.7v
.ic v(X_MEM.X_cell_6_26.q)=0v v(X_MEM.X_cell_6_26.qb)=0.7v
.ic v(X_MEM.X_cell_6_27.q)=0v v(X_MEM.X_cell_6_27.qb)=0.7v
.ic v(X_MEM.X_cell_6_28.q)=0v v(X_MEM.X_cell_6_28.qb)=0.7v
.ic v(X_MEM.X_cell_6_29.q)=0v v(X_MEM.X_cell_6_29.qb)=0.7v
.ic v(X_MEM.X_cell_6_30.q)=0v v(X_MEM.X_cell_6_30.qb)=0.7v
.ic v(X_MEM.X_cell_6_31.q)=0v v(X_MEM.X_cell_6_31.qb)=0.7v
.ic v(X_MEM.X_cell_7_0.q)=0v v(X_MEM.X_cell_7_0.qb)=0.7v
.ic v(X_MEM.X_cell_7_1.q)=0v v(X_MEM.X_cell_7_1.qb)=0.7v
.ic v(X_MEM.X_cell_7_2.q)=0v v(X_MEM.X_cell_7_2.qb)=0.7v
.ic v(X_MEM.X_cell_7_3.q)=0v v(X_MEM.X_cell_7_3.qb)=0.7v
.ic v(X_MEM.X_cell_7_4.q)=0v v(X_MEM.X_cell_7_4.qb)=0.7v
.ic v(X_MEM.X_cell_7_5.q)=0v v(X_MEM.X_cell_7_5.qb)=0.7v
.ic v(X_MEM.X_cell_7_6.q)=0v v(X_MEM.X_cell_7_6.qb)=0.7v
.ic v(X_MEM.X_cell_7_7.q)=0v v(X_MEM.X_cell_7_7.qb)=0.7v
.ic v(X_MEM.X_cell_7_8.q)=0v v(X_MEM.X_cell_7_8.qb)=0.7v
.ic v(X_MEM.X_cell_7_9.q)=0v v(X_MEM.X_cell_7_9.qb)=0.7v
.ic v(X_MEM.X_cell_7_10.q)=0v v(X_MEM.X_cell_7_10.qb)=0.7v
.ic v(X_MEM.X_cell_7_11.q)=0v v(X_MEM.X_cell_7_11.qb)=0.7v
.ic v(X_MEM.X_cell_7_12.q)=0v v(X_MEM.X_cell_7_12.qb)=0.7v
.ic v(X_MEM.X_cell_7_13.q)=0v v(X_MEM.X_cell_7_13.qb)=0.7v
.ic v(X_MEM.X_cell_7_14.q)=0v v(X_MEM.X_cell_7_14.qb)=0.7v
.ic v(X_MEM.X_cell_7_15.q)=0v v(X_MEM.X_cell_7_15.qb)=0.7v
.ic v(X_MEM.X_cell_7_16.q)=0v v(X_MEM.X_cell_7_16.qb)=0.7v
.ic v(X_MEM.X_cell_7_17.q)=0v v(X_MEM.X_cell_7_17.qb)=0.7v
.ic v(X_MEM.X_cell_7_18.q)=0v v(X_MEM.X_cell_7_18.qb)=0.7v
.ic v(X_MEM.X_cell_7_19.q)=0v v(X_MEM.X_cell_7_19.qb)=0.7v
.ic v(X_MEM.X_cell_7_20.q)=0v v(X_MEM.X_cell_7_20.qb)=0.7v
.ic v(X_MEM.X_cell_7_21.q)=0v v(X_MEM.X_cell_7_21.qb)=0.7v
.ic v(X_MEM.X_cell_7_22.q)=0v v(X_MEM.X_cell_7_22.qb)=0.7v
.ic v(X_MEM.X_cell_7_23.q)=0v v(X_MEM.X_cell_7_23.qb)=0.7v
.ic v(X_MEM.X_cell_7_24.q)=0v v(X_MEM.X_cell_7_24.qb)=0.7v
.ic v(X_MEM.X_cell_7_25.q)=0v v(X_MEM.X_cell_7_25.qb)=0.7v
.ic v(X_MEM.X_cell_7_26.q)=0v v(X_MEM.X_cell_7_26.qb)=0.7v
.ic v(X_MEM.X_cell_7_27.q)=0v v(X_MEM.X_cell_7_27.qb)=0.7v
.ic v(X_MEM.X_cell_7_28.q)=0v v(X_MEM.X_cell_7_28.qb)=0.7v
.ic v(X_MEM.X_cell_7_29.q)=0v v(X_MEM.X_cell_7_29.qb)=0.7v
.ic v(X_MEM.X_cell_7_30.q)=0v v(X_MEM.X_cell_7_30.qb)=0.7v
.ic v(X_MEM.X_cell_7_31.q)=0v v(X_MEM.X_cell_7_31.qb)=0.7v
.ic v(X_MEM.X_cell_8_0.q)=0v v(X_MEM.X_cell_8_0.qb)=0.7v
.ic v(X_MEM.X_cell_8_1.q)=0v v(X_MEM.X_cell_8_1.qb)=0.7v
.ic v(X_MEM.X_cell_8_2.q)=0v v(X_MEM.X_cell_8_2.qb)=0.7v
.ic v(X_MEM.X_cell_8_3.q)=0v v(X_MEM.X_cell_8_3.qb)=0.7v
.ic v(X_MEM.X_cell_8_4.q)=0v v(X_MEM.X_cell_8_4.qb)=0.7v
.ic v(X_MEM.X_cell_8_5.q)=0v v(X_MEM.X_cell_8_5.qb)=0.7v
.ic v(X_MEM.X_cell_8_6.q)=0v v(X_MEM.X_cell_8_6.qb)=0.7v
.ic v(X_MEM.X_cell_8_7.q)=0v v(X_MEM.X_cell_8_7.qb)=0.7v
.ic v(X_MEM.X_cell_8_8.q)=0v v(X_MEM.X_cell_8_8.qb)=0.7v
.ic v(X_MEM.X_cell_8_9.q)=0v v(X_MEM.X_cell_8_9.qb)=0.7v
.ic v(X_MEM.X_cell_8_10.q)=0v v(X_MEM.X_cell_8_10.qb)=0.7v
.ic v(X_MEM.X_cell_8_11.q)=0v v(X_MEM.X_cell_8_11.qb)=0.7v
.ic v(X_MEM.X_cell_8_12.q)=0v v(X_MEM.X_cell_8_12.qb)=0.7v
.ic v(X_MEM.X_cell_8_13.q)=0v v(X_MEM.X_cell_8_13.qb)=0.7v
.ic v(X_MEM.X_cell_8_14.q)=0v v(X_MEM.X_cell_8_14.qb)=0.7v
.ic v(X_MEM.X_cell_8_15.q)=0v v(X_MEM.X_cell_8_15.qb)=0.7v
.ic v(X_MEM.X_cell_8_16.q)=0v v(X_MEM.X_cell_8_16.qb)=0.7v
.ic v(X_MEM.X_cell_8_17.q)=0v v(X_MEM.X_cell_8_17.qb)=0.7v
.ic v(X_MEM.X_cell_8_18.q)=0v v(X_MEM.X_cell_8_18.qb)=0.7v
.ic v(X_MEM.X_cell_8_19.q)=0v v(X_MEM.X_cell_8_19.qb)=0.7v
.ic v(X_MEM.X_cell_8_20.q)=0v v(X_MEM.X_cell_8_20.qb)=0.7v
.ic v(X_MEM.X_cell_8_21.q)=0v v(X_MEM.X_cell_8_21.qb)=0.7v
.ic v(X_MEM.X_cell_8_22.q)=0v v(X_MEM.X_cell_8_22.qb)=0.7v
.ic v(X_MEM.X_cell_8_23.q)=0v v(X_MEM.X_cell_8_23.qb)=0.7v
.ic v(X_MEM.X_cell_8_24.q)=0v v(X_MEM.X_cell_8_24.qb)=0.7v
.ic v(X_MEM.X_cell_8_25.q)=0v v(X_MEM.X_cell_8_25.qb)=0.7v
.ic v(X_MEM.X_cell_8_26.q)=0v v(X_MEM.X_cell_8_26.qb)=0.7v
.ic v(X_MEM.X_cell_8_27.q)=0v v(X_MEM.X_cell_8_27.qb)=0.7v
.ic v(X_MEM.X_cell_8_28.q)=0v v(X_MEM.X_cell_8_28.qb)=0.7v
.ic v(X_MEM.X_cell_8_29.q)=0v v(X_MEM.X_cell_8_29.qb)=0.7v
.ic v(X_MEM.X_cell_8_30.q)=0v v(X_MEM.X_cell_8_30.qb)=0.7v
.ic v(X_MEM.X_cell_8_31.q)=0v v(X_MEM.X_cell_8_31.qb)=0.7v
.ic v(X_MEM.X_cell_9_0.q)=0v v(X_MEM.X_cell_9_0.qb)=0.7v
.ic v(X_MEM.X_cell_9_1.q)=0v v(X_MEM.X_cell_9_1.qb)=0.7v
.ic v(X_MEM.X_cell_9_2.q)=0v v(X_MEM.X_cell_9_2.qb)=0.7v
.ic v(X_MEM.X_cell_9_3.q)=0v v(X_MEM.X_cell_9_3.qb)=0.7v
.ic v(X_MEM.X_cell_9_4.q)=0v v(X_MEM.X_cell_9_4.qb)=0.7v
.ic v(X_MEM.X_cell_9_5.q)=0v v(X_MEM.X_cell_9_5.qb)=0.7v
.ic v(X_MEM.X_cell_9_6.q)=0v v(X_MEM.X_cell_9_6.qb)=0.7v
.ic v(X_MEM.X_cell_9_7.q)=0v v(X_MEM.X_cell_9_7.qb)=0.7v
.ic v(X_MEM.X_cell_9_8.q)=0v v(X_MEM.X_cell_9_8.qb)=0.7v
.ic v(X_MEM.X_cell_9_9.q)=0v v(X_MEM.X_cell_9_9.qb)=0.7v
.ic v(X_MEM.X_cell_9_10.q)=0v v(X_MEM.X_cell_9_10.qb)=0.7v
.ic v(X_MEM.X_cell_9_11.q)=0v v(X_MEM.X_cell_9_11.qb)=0.7v
.ic v(X_MEM.X_cell_9_12.q)=0v v(X_MEM.X_cell_9_12.qb)=0.7v
.ic v(X_MEM.X_cell_9_13.q)=0v v(X_MEM.X_cell_9_13.qb)=0.7v
.ic v(X_MEM.X_cell_9_14.q)=0v v(X_MEM.X_cell_9_14.qb)=0.7v
.ic v(X_MEM.X_cell_9_15.q)=0v v(X_MEM.X_cell_9_15.qb)=0.7v
.ic v(X_MEM.X_cell_9_16.q)=0v v(X_MEM.X_cell_9_16.qb)=0.7v
.ic v(X_MEM.X_cell_9_17.q)=0v v(X_MEM.X_cell_9_17.qb)=0.7v
.ic v(X_MEM.X_cell_9_18.q)=0v v(X_MEM.X_cell_9_18.qb)=0.7v
.ic v(X_MEM.X_cell_9_19.q)=0v v(X_MEM.X_cell_9_19.qb)=0.7v
.ic v(X_MEM.X_cell_9_20.q)=0v v(X_MEM.X_cell_9_20.qb)=0.7v
.ic v(X_MEM.X_cell_9_21.q)=0v v(X_MEM.X_cell_9_21.qb)=0.7v
.ic v(X_MEM.X_cell_9_22.q)=0v v(X_MEM.X_cell_9_22.qb)=0.7v
.ic v(X_MEM.X_cell_9_23.q)=0v v(X_MEM.X_cell_9_23.qb)=0.7v
.ic v(X_MEM.X_cell_9_24.q)=0v v(X_MEM.X_cell_9_24.qb)=0.7v
.ic v(X_MEM.X_cell_9_25.q)=0v v(X_MEM.X_cell_9_25.qb)=0.7v
.ic v(X_MEM.X_cell_9_26.q)=0v v(X_MEM.X_cell_9_26.qb)=0.7v
.ic v(X_MEM.X_cell_9_27.q)=0v v(X_MEM.X_cell_9_27.qb)=0.7v
.ic v(X_MEM.X_cell_9_28.q)=0v v(X_MEM.X_cell_9_28.qb)=0.7v
.ic v(X_MEM.X_cell_9_29.q)=0v v(X_MEM.X_cell_9_29.qb)=0.7v
.ic v(X_MEM.X_cell_9_30.q)=0v v(X_MEM.X_cell_9_30.qb)=0.7v
.ic v(X_MEM.X_cell_9_31.q)=0v v(X_MEM.X_cell_9_31.qb)=0.7v
.ic v(X_MEM.X_cell_10_0.q)=0v v(X_MEM.X_cell_10_0.qb)=0.7v
.ic v(X_MEM.X_cell_10_1.q)=0v v(X_MEM.X_cell_10_1.qb)=0.7v
.ic v(X_MEM.X_cell_10_2.q)=0v v(X_MEM.X_cell_10_2.qb)=0.7v
.ic v(X_MEM.X_cell_10_3.q)=0v v(X_MEM.X_cell_10_3.qb)=0.7v
.ic v(X_MEM.X_cell_10_4.q)=0v v(X_MEM.X_cell_10_4.qb)=0.7v
.ic v(X_MEM.X_cell_10_5.q)=0v v(X_MEM.X_cell_10_5.qb)=0.7v
.ic v(X_MEM.X_cell_10_6.q)=0v v(X_MEM.X_cell_10_6.qb)=0.7v
.ic v(X_MEM.X_cell_10_7.q)=0v v(X_MEM.X_cell_10_7.qb)=0.7v
.ic v(X_MEM.X_cell_10_8.q)=0v v(X_MEM.X_cell_10_8.qb)=0.7v
.ic v(X_MEM.X_cell_10_9.q)=0v v(X_MEM.X_cell_10_9.qb)=0.7v
.ic v(X_MEM.X_cell_10_10.q)=0v v(X_MEM.X_cell_10_10.qb)=0.7v
.ic v(X_MEM.X_cell_10_11.q)=0v v(X_MEM.X_cell_10_11.qb)=0.7v
.ic v(X_MEM.X_cell_10_12.q)=0v v(X_MEM.X_cell_10_12.qb)=0.7v
.ic v(X_MEM.X_cell_10_13.q)=0v v(X_MEM.X_cell_10_13.qb)=0.7v
.ic v(X_MEM.X_cell_10_14.q)=0v v(X_MEM.X_cell_10_14.qb)=0.7v
.ic v(X_MEM.X_cell_10_15.q)=0v v(X_MEM.X_cell_10_15.qb)=0.7v
.ic v(X_MEM.X_cell_10_16.q)=0v v(X_MEM.X_cell_10_16.qb)=0.7v
.ic v(X_MEM.X_cell_10_17.q)=0v v(X_MEM.X_cell_10_17.qb)=0.7v
.ic v(X_MEM.X_cell_10_18.q)=0v v(X_MEM.X_cell_10_18.qb)=0.7v
.ic v(X_MEM.X_cell_10_19.q)=0v v(X_MEM.X_cell_10_19.qb)=0.7v
.ic v(X_MEM.X_cell_10_20.q)=0v v(X_MEM.X_cell_10_20.qb)=0.7v
.ic v(X_MEM.X_cell_10_21.q)=0v v(X_MEM.X_cell_10_21.qb)=0.7v
.ic v(X_MEM.X_cell_10_22.q)=0v v(X_MEM.X_cell_10_22.qb)=0.7v
.ic v(X_MEM.X_cell_10_23.q)=0v v(X_MEM.X_cell_10_23.qb)=0.7v
.ic v(X_MEM.X_cell_10_24.q)=0v v(X_MEM.X_cell_10_24.qb)=0.7v
.ic v(X_MEM.X_cell_10_25.q)=0v v(X_MEM.X_cell_10_25.qb)=0.7v
.ic v(X_MEM.X_cell_10_26.q)=0v v(X_MEM.X_cell_10_26.qb)=0.7v
.ic v(X_MEM.X_cell_10_27.q)=0v v(X_MEM.X_cell_10_27.qb)=0.7v
.ic v(X_MEM.X_cell_10_28.q)=0v v(X_MEM.X_cell_10_28.qb)=0.7v
.ic v(X_MEM.X_cell_10_29.q)=0v v(X_MEM.X_cell_10_29.qb)=0.7v
.ic v(X_MEM.X_cell_10_30.q)=0v v(X_MEM.X_cell_10_30.qb)=0.7v
.ic v(X_MEM.X_cell_10_31.q)=0v v(X_MEM.X_cell_10_31.qb)=0.7v
.ic v(X_MEM.X_cell_11_0.q)=0v v(X_MEM.X_cell_11_0.qb)=0.7v
.ic v(X_MEM.X_cell_11_1.q)=0v v(X_MEM.X_cell_11_1.qb)=0.7v
.ic v(X_MEM.X_cell_11_2.q)=0v v(X_MEM.X_cell_11_2.qb)=0.7v
.ic v(X_MEM.X_cell_11_3.q)=0v v(X_MEM.X_cell_11_3.qb)=0.7v
.ic v(X_MEM.X_cell_11_4.q)=0v v(X_MEM.X_cell_11_4.qb)=0.7v
.ic v(X_MEM.X_cell_11_5.q)=0v v(X_MEM.X_cell_11_5.qb)=0.7v
.ic v(X_MEM.X_cell_11_6.q)=0v v(X_MEM.X_cell_11_6.qb)=0.7v
.ic v(X_MEM.X_cell_11_7.q)=0v v(X_MEM.X_cell_11_7.qb)=0.7v
.ic v(X_MEM.X_cell_11_8.q)=0v v(X_MEM.X_cell_11_8.qb)=0.7v
.ic v(X_MEM.X_cell_11_9.q)=0v v(X_MEM.X_cell_11_9.qb)=0.7v
.ic v(X_MEM.X_cell_11_10.q)=0v v(X_MEM.X_cell_11_10.qb)=0.7v
.ic v(X_MEM.X_cell_11_11.q)=0v v(X_MEM.X_cell_11_11.qb)=0.7v
.ic v(X_MEM.X_cell_11_12.q)=0v v(X_MEM.X_cell_11_12.qb)=0.7v
.ic v(X_MEM.X_cell_11_13.q)=0v v(X_MEM.X_cell_11_13.qb)=0.7v
.ic v(X_MEM.X_cell_11_14.q)=0v v(X_MEM.X_cell_11_14.qb)=0.7v
.ic v(X_MEM.X_cell_11_15.q)=0v v(X_MEM.X_cell_11_15.qb)=0.7v
.ic v(X_MEM.X_cell_11_16.q)=0v v(X_MEM.X_cell_11_16.qb)=0.7v
.ic v(X_MEM.X_cell_11_17.q)=0v v(X_MEM.X_cell_11_17.qb)=0.7v
.ic v(X_MEM.X_cell_11_18.q)=0v v(X_MEM.X_cell_11_18.qb)=0.7v
.ic v(X_MEM.X_cell_11_19.q)=0v v(X_MEM.X_cell_11_19.qb)=0.7v
.ic v(X_MEM.X_cell_11_20.q)=0v v(X_MEM.X_cell_11_20.qb)=0.7v
.ic v(X_MEM.X_cell_11_21.q)=0v v(X_MEM.X_cell_11_21.qb)=0.7v
.ic v(X_MEM.X_cell_11_22.q)=0v v(X_MEM.X_cell_11_22.qb)=0.7v
.ic v(X_MEM.X_cell_11_23.q)=0v v(X_MEM.X_cell_11_23.qb)=0.7v
.ic v(X_MEM.X_cell_11_24.q)=0v v(X_MEM.X_cell_11_24.qb)=0.7v
.ic v(X_MEM.X_cell_11_25.q)=0v v(X_MEM.X_cell_11_25.qb)=0.7v
.ic v(X_MEM.X_cell_11_26.q)=0v v(X_MEM.X_cell_11_26.qb)=0.7v
.ic v(X_MEM.X_cell_11_27.q)=0v v(X_MEM.X_cell_11_27.qb)=0.7v
.ic v(X_MEM.X_cell_11_28.q)=0v v(X_MEM.X_cell_11_28.qb)=0.7v
.ic v(X_MEM.X_cell_11_29.q)=0v v(X_MEM.X_cell_11_29.qb)=0.7v
.ic v(X_MEM.X_cell_11_30.q)=0v v(X_MEM.X_cell_11_30.qb)=0.7v
.ic v(X_MEM.X_cell_11_31.q)=0v v(X_MEM.X_cell_11_31.qb)=0.7v
.ic v(X_MEM.X_cell_12_0.q)=0v v(X_MEM.X_cell_12_0.qb)=0.7v
.ic v(X_MEM.X_cell_12_1.q)=0v v(X_MEM.X_cell_12_1.qb)=0.7v
.ic v(X_MEM.X_cell_12_2.q)=0v v(X_MEM.X_cell_12_2.qb)=0.7v
.ic v(X_MEM.X_cell_12_3.q)=0v v(X_MEM.X_cell_12_3.qb)=0.7v
.ic v(X_MEM.X_cell_12_4.q)=0v v(X_MEM.X_cell_12_4.qb)=0.7v
.ic v(X_MEM.X_cell_12_5.q)=0v v(X_MEM.X_cell_12_5.qb)=0.7v
.ic v(X_MEM.X_cell_12_6.q)=0v v(X_MEM.X_cell_12_6.qb)=0.7v
.ic v(X_MEM.X_cell_12_7.q)=0v v(X_MEM.X_cell_12_7.qb)=0.7v
.ic v(X_MEM.X_cell_12_8.q)=0v v(X_MEM.X_cell_12_8.qb)=0.7v
.ic v(X_MEM.X_cell_12_9.q)=0v v(X_MEM.X_cell_12_9.qb)=0.7v
.ic v(X_MEM.X_cell_12_10.q)=0v v(X_MEM.X_cell_12_10.qb)=0.7v
.ic v(X_MEM.X_cell_12_11.q)=0v v(X_MEM.X_cell_12_11.qb)=0.7v
.ic v(X_MEM.X_cell_12_12.q)=0v v(X_MEM.X_cell_12_12.qb)=0.7v
.ic v(X_MEM.X_cell_12_13.q)=0v v(X_MEM.X_cell_12_13.qb)=0.7v
.ic v(X_MEM.X_cell_12_14.q)=0v v(X_MEM.X_cell_12_14.qb)=0.7v
.ic v(X_MEM.X_cell_12_15.q)=0v v(X_MEM.X_cell_12_15.qb)=0.7v
.ic v(X_MEM.X_cell_12_16.q)=0v v(X_MEM.X_cell_12_16.qb)=0.7v
.ic v(X_MEM.X_cell_12_17.q)=0v v(X_MEM.X_cell_12_17.qb)=0.7v
.ic v(X_MEM.X_cell_12_18.q)=0v v(X_MEM.X_cell_12_18.qb)=0.7v
.ic v(X_MEM.X_cell_12_19.q)=0v v(X_MEM.X_cell_12_19.qb)=0.7v
.ic v(X_MEM.X_cell_12_20.q)=0v v(X_MEM.X_cell_12_20.qb)=0.7v
.ic v(X_MEM.X_cell_12_21.q)=0v v(X_MEM.X_cell_12_21.qb)=0.7v
.ic v(X_MEM.X_cell_12_22.q)=0v v(X_MEM.X_cell_12_22.qb)=0.7v
.ic v(X_MEM.X_cell_12_23.q)=0v v(X_MEM.X_cell_12_23.qb)=0.7v
.ic v(X_MEM.X_cell_12_24.q)=0v v(X_MEM.X_cell_12_24.qb)=0.7v
.ic v(X_MEM.X_cell_12_25.q)=0v v(X_MEM.X_cell_12_25.qb)=0.7v
.ic v(X_MEM.X_cell_12_26.q)=0v v(X_MEM.X_cell_12_26.qb)=0.7v
.ic v(X_MEM.X_cell_12_27.q)=0v v(X_MEM.X_cell_12_27.qb)=0.7v
.ic v(X_MEM.X_cell_12_28.q)=0v v(X_MEM.X_cell_12_28.qb)=0.7v
.ic v(X_MEM.X_cell_12_29.q)=0v v(X_MEM.X_cell_12_29.qb)=0.7v
.ic v(X_MEM.X_cell_12_30.q)=0v v(X_MEM.X_cell_12_30.qb)=0.7v
.ic v(X_MEM.X_cell_12_31.q)=0v v(X_MEM.X_cell_12_31.qb)=0.7v
.ic v(X_MEM.X_cell_13_0.q)=0v v(X_MEM.X_cell_13_0.qb)=0.7v
.ic v(X_MEM.X_cell_13_1.q)=0v v(X_MEM.X_cell_13_1.qb)=0.7v
.ic v(X_MEM.X_cell_13_2.q)=0v v(X_MEM.X_cell_13_2.qb)=0.7v
.ic v(X_MEM.X_cell_13_3.q)=0v v(X_MEM.X_cell_13_3.qb)=0.7v
.ic v(X_MEM.X_cell_13_4.q)=0v v(X_MEM.X_cell_13_4.qb)=0.7v
.ic v(X_MEM.X_cell_13_5.q)=0v v(X_MEM.X_cell_13_5.qb)=0.7v
.ic v(X_MEM.X_cell_13_6.q)=0v v(X_MEM.X_cell_13_6.qb)=0.7v
.ic v(X_MEM.X_cell_13_7.q)=0v v(X_MEM.X_cell_13_7.qb)=0.7v
.ic v(X_MEM.X_cell_13_8.q)=0v v(X_MEM.X_cell_13_8.qb)=0.7v
.ic v(X_MEM.X_cell_13_9.q)=0v v(X_MEM.X_cell_13_9.qb)=0.7v
.ic v(X_MEM.X_cell_13_10.q)=0v v(X_MEM.X_cell_13_10.qb)=0.7v
.ic v(X_MEM.X_cell_13_11.q)=0v v(X_MEM.X_cell_13_11.qb)=0.7v
.ic v(X_MEM.X_cell_13_12.q)=0v v(X_MEM.X_cell_13_12.qb)=0.7v
.ic v(X_MEM.X_cell_13_13.q)=0v v(X_MEM.X_cell_13_13.qb)=0.7v
.ic v(X_MEM.X_cell_13_14.q)=0v v(X_MEM.X_cell_13_14.qb)=0.7v
.ic v(X_MEM.X_cell_13_15.q)=0v v(X_MEM.X_cell_13_15.qb)=0.7v
.ic v(X_MEM.X_cell_13_16.q)=0v v(X_MEM.X_cell_13_16.qb)=0.7v
.ic v(X_MEM.X_cell_13_17.q)=0v v(X_MEM.X_cell_13_17.qb)=0.7v
.ic v(X_MEM.X_cell_13_18.q)=0v v(X_MEM.X_cell_13_18.qb)=0.7v
.ic v(X_MEM.X_cell_13_19.q)=0v v(X_MEM.X_cell_13_19.qb)=0.7v
.ic v(X_MEM.X_cell_13_20.q)=0v v(X_MEM.X_cell_13_20.qb)=0.7v
.ic v(X_MEM.X_cell_13_21.q)=0v v(X_MEM.X_cell_13_21.qb)=0.7v
.ic v(X_MEM.X_cell_13_22.q)=0v v(X_MEM.X_cell_13_22.qb)=0.7v
.ic v(X_MEM.X_cell_13_23.q)=0v v(X_MEM.X_cell_13_23.qb)=0.7v
.ic v(X_MEM.X_cell_13_24.q)=0v v(X_MEM.X_cell_13_24.qb)=0.7v
.ic v(X_MEM.X_cell_13_25.q)=0v v(X_MEM.X_cell_13_25.qb)=0.7v
.ic v(X_MEM.X_cell_13_26.q)=0v v(X_MEM.X_cell_13_26.qb)=0.7v
.ic v(X_MEM.X_cell_13_27.q)=0v v(X_MEM.X_cell_13_27.qb)=0.7v
.ic v(X_MEM.X_cell_13_28.q)=0v v(X_MEM.X_cell_13_28.qb)=0.7v
.ic v(X_MEM.X_cell_13_29.q)=0v v(X_MEM.X_cell_13_29.qb)=0.7v
.ic v(X_MEM.X_cell_13_30.q)=0v v(X_MEM.X_cell_13_30.qb)=0.7v
.ic v(X_MEM.X_cell_13_31.q)=0v v(X_MEM.X_cell_13_31.qb)=0.7v
.ic v(X_MEM.X_cell_14_0.q)=0v v(X_MEM.X_cell_14_0.qb)=0.7v
.ic v(X_MEM.X_cell_14_1.q)=0v v(X_MEM.X_cell_14_1.qb)=0.7v
.ic v(X_MEM.X_cell_14_2.q)=0v v(X_MEM.X_cell_14_2.qb)=0.7v
.ic v(X_MEM.X_cell_14_3.q)=0v v(X_MEM.X_cell_14_3.qb)=0.7v
.ic v(X_MEM.X_cell_14_4.q)=0v v(X_MEM.X_cell_14_4.qb)=0.7v
.ic v(X_MEM.X_cell_14_5.q)=0v v(X_MEM.X_cell_14_5.qb)=0.7v
.ic v(X_MEM.X_cell_14_6.q)=0v v(X_MEM.X_cell_14_6.qb)=0.7v
.ic v(X_MEM.X_cell_14_7.q)=0v v(X_MEM.X_cell_14_7.qb)=0.7v
.ic v(X_MEM.X_cell_14_8.q)=0v v(X_MEM.X_cell_14_8.qb)=0.7v
.ic v(X_MEM.X_cell_14_9.q)=0v v(X_MEM.X_cell_14_9.qb)=0.7v
.ic v(X_MEM.X_cell_14_10.q)=0v v(X_MEM.X_cell_14_10.qb)=0.7v
.ic v(X_MEM.X_cell_14_11.q)=0v v(X_MEM.X_cell_14_11.qb)=0.7v
.ic v(X_MEM.X_cell_14_12.q)=0v v(X_MEM.X_cell_14_12.qb)=0.7v
.ic v(X_MEM.X_cell_14_13.q)=0v v(X_MEM.X_cell_14_13.qb)=0.7v
.ic v(X_MEM.X_cell_14_14.q)=0v v(X_MEM.X_cell_14_14.qb)=0.7v
.ic v(X_MEM.X_cell_14_15.q)=0v v(X_MEM.X_cell_14_15.qb)=0.7v
.ic v(X_MEM.X_cell_14_16.q)=0v v(X_MEM.X_cell_14_16.qb)=0.7v
.ic v(X_MEM.X_cell_14_17.q)=0v v(X_MEM.X_cell_14_17.qb)=0.7v
.ic v(X_MEM.X_cell_14_18.q)=0v v(X_MEM.X_cell_14_18.qb)=0.7v
.ic v(X_MEM.X_cell_14_19.q)=0v v(X_MEM.X_cell_14_19.qb)=0.7v
.ic v(X_MEM.X_cell_14_20.q)=0v v(X_MEM.X_cell_14_20.qb)=0.7v
.ic v(X_MEM.X_cell_14_21.q)=0v v(X_MEM.X_cell_14_21.qb)=0.7v
.ic v(X_MEM.X_cell_14_22.q)=0v v(X_MEM.X_cell_14_22.qb)=0.7v
.ic v(X_MEM.X_cell_14_23.q)=0v v(X_MEM.X_cell_14_23.qb)=0.7v
.ic v(X_MEM.X_cell_14_24.q)=0v v(X_MEM.X_cell_14_24.qb)=0.7v
.ic v(X_MEM.X_cell_14_25.q)=0v v(X_MEM.X_cell_14_25.qb)=0.7v
.ic v(X_MEM.X_cell_14_26.q)=0v v(X_MEM.X_cell_14_26.qb)=0.7v
.ic v(X_MEM.X_cell_14_27.q)=0v v(X_MEM.X_cell_14_27.qb)=0.7v
.ic v(X_MEM.X_cell_14_28.q)=0v v(X_MEM.X_cell_14_28.qb)=0.7v
.ic v(X_MEM.X_cell_14_29.q)=0v v(X_MEM.X_cell_14_29.qb)=0.7v
.ic v(X_MEM.X_cell_14_30.q)=0v v(X_MEM.X_cell_14_30.qb)=0.7v
.ic v(X_MEM.X_cell_14_31.q)=0v v(X_MEM.X_cell_14_31.qb)=0.7v
.ic v(X_MEM.X_cell_15_0.q)=0v v(X_MEM.X_cell_15_0.qb)=0.7v
.ic v(X_MEM.X_cell_15_1.q)=0v v(X_MEM.X_cell_15_1.qb)=0.7v
.ic v(X_MEM.X_cell_15_2.q)=0v v(X_MEM.X_cell_15_2.qb)=0.7v
.ic v(X_MEM.X_cell_15_3.q)=0v v(X_MEM.X_cell_15_3.qb)=0.7v
.ic v(X_MEM.X_cell_15_4.q)=0v v(X_MEM.X_cell_15_4.qb)=0.7v
.ic v(X_MEM.X_cell_15_5.q)=0v v(X_MEM.X_cell_15_5.qb)=0.7v
.ic v(X_MEM.X_cell_15_6.q)=0v v(X_MEM.X_cell_15_6.qb)=0.7v
.ic v(X_MEM.X_cell_15_7.q)=0v v(X_MEM.X_cell_15_7.qb)=0.7v
.ic v(X_MEM.X_cell_15_8.q)=0v v(X_MEM.X_cell_15_8.qb)=0.7v
.ic v(X_MEM.X_cell_15_9.q)=0v v(X_MEM.X_cell_15_9.qb)=0.7v
.ic v(X_MEM.X_cell_15_10.q)=0v v(X_MEM.X_cell_15_10.qb)=0.7v
.ic v(X_MEM.X_cell_15_11.q)=0v v(X_MEM.X_cell_15_11.qb)=0.7v
.ic v(X_MEM.X_cell_15_12.q)=0v v(X_MEM.X_cell_15_12.qb)=0.7v
.ic v(X_MEM.X_cell_15_13.q)=0v v(X_MEM.X_cell_15_13.qb)=0.7v
.ic v(X_MEM.X_cell_15_14.q)=0v v(X_MEM.X_cell_15_14.qb)=0.7v
.ic v(X_MEM.X_cell_15_15.q)=0v v(X_MEM.X_cell_15_15.qb)=0.7v
.ic v(X_MEM.X_cell_15_16.q)=0v v(X_MEM.X_cell_15_16.qb)=0.7v
.ic v(X_MEM.X_cell_15_17.q)=0v v(X_MEM.X_cell_15_17.qb)=0.7v
.ic v(X_MEM.X_cell_15_18.q)=0v v(X_MEM.X_cell_15_18.qb)=0.7v
.ic v(X_MEM.X_cell_15_19.q)=0v v(X_MEM.X_cell_15_19.qb)=0.7v
.ic v(X_MEM.X_cell_15_20.q)=0v v(X_MEM.X_cell_15_20.qb)=0.7v
.ic v(X_MEM.X_cell_15_21.q)=0v v(X_MEM.X_cell_15_21.qb)=0.7v
.ic v(X_MEM.X_cell_15_22.q)=0v v(X_MEM.X_cell_15_22.qb)=0.7v
.ic v(X_MEM.X_cell_15_23.q)=0v v(X_MEM.X_cell_15_23.qb)=0.7v
.ic v(X_MEM.X_cell_15_24.q)=0v v(X_MEM.X_cell_15_24.qb)=0.7v
.ic v(X_MEM.X_cell_15_25.q)=0v v(X_MEM.X_cell_15_25.qb)=0.7v
.ic v(X_MEM.X_cell_15_26.q)=0v v(X_MEM.X_cell_15_26.qb)=0.7v
.ic v(X_MEM.X_cell_15_27.q)=0v v(X_MEM.X_cell_15_27.qb)=0.7v
.ic v(X_MEM.X_cell_15_28.q)=0v v(X_MEM.X_cell_15_28.qb)=0.7v
.ic v(X_MEM.X_cell_15_29.q)=0v v(X_MEM.X_cell_15_29.qb)=0.7v
.ic v(X_MEM.X_cell_15_30.q)=0v v(X_MEM.X_cell_15_30.qb)=0.7v
.ic v(X_MEM.X_cell_15_31.q)=0v v(X_MEM.X_cell_15_31.qb)=0.7v
.ic v(X_MEM.X_cell_16_0.q)=0v v(X_MEM.X_cell_16_0.qb)=0.7v
.ic v(X_MEM.X_cell_16_1.q)=0v v(X_MEM.X_cell_16_1.qb)=0.7v
.ic v(X_MEM.X_cell_16_2.q)=0v v(X_MEM.X_cell_16_2.qb)=0.7v
.ic v(X_MEM.X_cell_16_3.q)=0v v(X_MEM.X_cell_16_3.qb)=0.7v
.ic v(X_MEM.X_cell_16_4.q)=0v v(X_MEM.X_cell_16_4.qb)=0.7v
.ic v(X_MEM.X_cell_16_5.q)=0v v(X_MEM.X_cell_16_5.qb)=0.7v
.ic v(X_MEM.X_cell_16_6.q)=0v v(X_MEM.X_cell_16_6.qb)=0.7v
.ic v(X_MEM.X_cell_16_7.q)=0v v(X_MEM.X_cell_16_7.qb)=0.7v
.ic v(X_MEM.X_cell_16_8.q)=0v v(X_MEM.X_cell_16_8.qb)=0.7v
.ic v(X_MEM.X_cell_16_9.q)=0v v(X_MEM.X_cell_16_9.qb)=0.7v
.ic v(X_MEM.X_cell_16_10.q)=0v v(X_MEM.X_cell_16_10.qb)=0.7v
.ic v(X_MEM.X_cell_16_11.q)=0v v(X_MEM.X_cell_16_11.qb)=0.7v
.ic v(X_MEM.X_cell_16_12.q)=0v v(X_MEM.X_cell_16_12.qb)=0.7v
.ic v(X_MEM.X_cell_16_13.q)=0v v(X_MEM.X_cell_16_13.qb)=0.7v
.ic v(X_MEM.X_cell_16_14.q)=0v v(X_MEM.X_cell_16_14.qb)=0.7v
.ic v(X_MEM.X_cell_16_15.q)=0v v(X_MEM.X_cell_16_15.qb)=0.7v
.ic v(X_MEM.X_cell_16_16.q)=0v v(X_MEM.X_cell_16_16.qb)=0.7v
.ic v(X_MEM.X_cell_16_17.q)=0v v(X_MEM.X_cell_16_17.qb)=0.7v
.ic v(X_MEM.X_cell_16_18.q)=0v v(X_MEM.X_cell_16_18.qb)=0.7v
.ic v(X_MEM.X_cell_16_19.q)=0v v(X_MEM.X_cell_16_19.qb)=0.7v
.ic v(X_MEM.X_cell_16_20.q)=0v v(X_MEM.X_cell_16_20.qb)=0.7v
.ic v(X_MEM.X_cell_16_21.q)=0v v(X_MEM.X_cell_16_21.qb)=0.7v
.ic v(X_MEM.X_cell_16_22.q)=0v v(X_MEM.X_cell_16_22.qb)=0.7v
.ic v(X_MEM.X_cell_16_23.q)=0v v(X_MEM.X_cell_16_23.qb)=0.7v
.ic v(X_MEM.X_cell_16_24.q)=0v v(X_MEM.X_cell_16_24.qb)=0.7v
.ic v(X_MEM.X_cell_16_25.q)=0v v(X_MEM.X_cell_16_25.qb)=0.7v
.ic v(X_MEM.X_cell_16_26.q)=0v v(X_MEM.X_cell_16_26.qb)=0.7v
.ic v(X_MEM.X_cell_16_27.q)=0v v(X_MEM.X_cell_16_27.qb)=0.7v
.ic v(X_MEM.X_cell_16_28.q)=0v v(X_MEM.X_cell_16_28.qb)=0.7v
.ic v(X_MEM.X_cell_16_29.q)=0v v(X_MEM.X_cell_16_29.qb)=0.7v
.ic v(X_MEM.X_cell_16_30.q)=0v v(X_MEM.X_cell_16_30.qb)=0.7v
.ic v(X_MEM.X_cell_16_31.q)=0v v(X_MEM.X_cell_16_31.qb)=0.7v
.ic v(X_MEM.X_cell_17_0.q)=0v v(X_MEM.X_cell_17_0.qb)=0.7v
.ic v(X_MEM.X_cell_17_1.q)=0v v(X_MEM.X_cell_17_1.qb)=0.7v
.ic v(X_MEM.X_cell_17_2.q)=0v v(X_MEM.X_cell_17_2.qb)=0.7v
.ic v(X_MEM.X_cell_17_3.q)=0v v(X_MEM.X_cell_17_3.qb)=0.7v
.ic v(X_MEM.X_cell_17_4.q)=0v v(X_MEM.X_cell_17_4.qb)=0.7v
.ic v(X_MEM.X_cell_17_5.q)=0v v(X_MEM.X_cell_17_5.qb)=0.7v
.ic v(X_MEM.X_cell_17_6.q)=0v v(X_MEM.X_cell_17_6.qb)=0.7v
.ic v(X_MEM.X_cell_17_7.q)=0v v(X_MEM.X_cell_17_7.qb)=0.7v
.ic v(X_MEM.X_cell_17_8.q)=0v v(X_MEM.X_cell_17_8.qb)=0.7v
.ic v(X_MEM.X_cell_17_9.q)=0v v(X_MEM.X_cell_17_9.qb)=0.7v
.ic v(X_MEM.X_cell_17_10.q)=0v v(X_MEM.X_cell_17_10.qb)=0.7v
.ic v(X_MEM.X_cell_17_11.q)=0v v(X_MEM.X_cell_17_11.qb)=0.7v
.ic v(X_MEM.X_cell_17_12.q)=0v v(X_MEM.X_cell_17_12.qb)=0.7v
.ic v(X_MEM.X_cell_17_13.q)=0v v(X_MEM.X_cell_17_13.qb)=0.7v
.ic v(X_MEM.X_cell_17_14.q)=0v v(X_MEM.X_cell_17_14.qb)=0.7v
.ic v(X_MEM.X_cell_17_15.q)=0v v(X_MEM.X_cell_17_15.qb)=0.7v
.ic v(X_MEM.X_cell_17_16.q)=0v v(X_MEM.X_cell_17_16.qb)=0.7v
.ic v(X_MEM.X_cell_17_17.q)=0v v(X_MEM.X_cell_17_17.qb)=0.7v
.ic v(X_MEM.X_cell_17_18.q)=0v v(X_MEM.X_cell_17_18.qb)=0.7v
.ic v(X_MEM.X_cell_17_19.q)=0v v(X_MEM.X_cell_17_19.qb)=0.7v
.ic v(X_MEM.X_cell_17_20.q)=0v v(X_MEM.X_cell_17_20.qb)=0.7v
.ic v(X_MEM.X_cell_17_21.q)=0v v(X_MEM.X_cell_17_21.qb)=0.7v
.ic v(X_MEM.X_cell_17_22.q)=0v v(X_MEM.X_cell_17_22.qb)=0.7v
.ic v(X_MEM.X_cell_17_23.q)=0v v(X_MEM.X_cell_17_23.qb)=0.7v
.ic v(X_MEM.X_cell_17_24.q)=0v v(X_MEM.X_cell_17_24.qb)=0.7v
.ic v(X_MEM.X_cell_17_25.q)=0v v(X_MEM.X_cell_17_25.qb)=0.7v
.ic v(X_MEM.X_cell_17_26.q)=0v v(X_MEM.X_cell_17_26.qb)=0.7v
.ic v(X_MEM.X_cell_17_27.q)=0v v(X_MEM.X_cell_17_27.qb)=0.7v
.ic v(X_MEM.X_cell_17_28.q)=0v v(X_MEM.X_cell_17_28.qb)=0.7v
.ic v(X_MEM.X_cell_17_29.q)=0v v(X_MEM.X_cell_17_29.qb)=0.7v
.ic v(X_MEM.X_cell_17_30.q)=0v v(X_MEM.X_cell_17_30.qb)=0.7v
.ic v(X_MEM.X_cell_17_31.q)=0v v(X_MEM.X_cell_17_31.qb)=0.7v
.ic v(X_MEM.X_cell_18_0.q)=0v v(X_MEM.X_cell_18_0.qb)=0.7v
.ic v(X_MEM.X_cell_18_1.q)=0v v(X_MEM.X_cell_18_1.qb)=0.7v
.ic v(X_MEM.X_cell_18_2.q)=0v v(X_MEM.X_cell_18_2.qb)=0.7v
.ic v(X_MEM.X_cell_18_3.q)=0v v(X_MEM.X_cell_18_3.qb)=0.7v
.ic v(X_MEM.X_cell_18_4.q)=0v v(X_MEM.X_cell_18_4.qb)=0.7v
.ic v(X_MEM.X_cell_18_5.q)=0v v(X_MEM.X_cell_18_5.qb)=0.7v
.ic v(X_MEM.X_cell_18_6.q)=0v v(X_MEM.X_cell_18_6.qb)=0.7v
.ic v(X_MEM.X_cell_18_7.q)=0v v(X_MEM.X_cell_18_7.qb)=0.7v
.ic v(X_MEM.X_cell_18_8.q)=0v v(X_MEM.X_cell_18_8.qb)=0.7v
.ic v(X_MEM.X_cell_18_9.q)=0v v(X_MEM.X_cell_18_9.qb)=0.7v
.ic v(X_MEM.X_cell_18_10.q)=0v v(X_MEM.X_cell_18_10.qb)=0.7v
.ic v(X_MEM.X_cell_18_11.q)=0v v(X_MEM.X_cell_18_11.qb)=0.7v
.ic v(X_MEM.X_cell_18_12.q)=0v v(X_MEM.X_cell_18_12.qb)=0.7v
.ic v(X_MEM.X_cell_18_13.q)=0v v(X_MEM.X_cell_18_13.qb)=0.7v
.ic v(X_MEM.X_cell_18_14.q)=0v v(X_MEM.X_cell_18_14.qb)=0.7v
.ic v(X_MEM.X_cell_18_15.q)=0v v(X_MEM.X_cell_18_15.qb)=0.7v
.ic v(X_MEM.X_cell_18_16.q)=0v v(X_MEM.X_cell_18_16.qb)=0.7v
.ic v(X_MEM.X_cell_18_17.q)=0v v(X_MEM.X_cell_18_17.qb)=0.7v
.ic v(X_MEM.X_cell_18_18.q)=0v v(X_MEM.X_cell_18_18.qb)=0.7v
.ic v(X_MEM.X_cell_18_19.q)=0v v(X_MEM.X_cell_18_19.qb)=0.7v
.ic v(X_MEM.X_cell_18_20.q)=0v v(X_MEM.X_cell_18_20.qb)=0.7v
.ic v(X_MEM.X_cell_18_21.q)=0v v(X_MEM.X_cell_18_21.qb)=0.7v
.ic v(X_MEM.X_cell_18_22.q)=0v v(X_MEM.X_cell_18_22.qb)=0.7v
.ic v(X_MEM.X_cell_18_23.q)=0v v(X_MEM.X_cell_18_23.qb)=0.7v
.ic v(X_MEM.X_cell_18_24.q)=0v v(X_MEM.X_cell_18_24.qb)=0.7v
.ic v(X_MEM.X_cell_18_25.q)=0v v(X_MEM.X_cell_18_25.qb)=0.7v
.ic v(X_MEM.X_cell_18_26.q)=0v v(X_MEM.X_cell_18_26.qb)=0.7v
.ic v(X_MEM.X_cell_18_27.q)=0v v(X_MEM.X_cell_18_27.qb)=0.7v
.ic v(X_MEM.X_cell_18_28.q)=0v v(X_MEM.X_cell_18_28.qb)=0.7v
.ic v(X_MEM.X_cell_18_29.q)=0v v(X_MEM.X_cell_18_29.qb)=0.7v
.ic v(X_MEM.X_cell_18_30.q)=0v v(X_MEM.X_cell_18_30.qb)=0.7v
.ic v(X_MEM.X_cell_18_31.q)=0v v(X_MEM.X_cell_18_31.qb)=0.7v
.ic v(X_MEM.X_cell_19_0.q)=0v v(X_MEM.X_cell_19_0.qb)=0.7v
.ic v(X_MEM.X_cell_19_1.q)=0v v(X_MEM.X_cell_19_1.qb)=0.7v
.ic v(X_MEM.X_cell_19_2.q)=0v v(X_MEM.X_cell_19_2.qb)=0.7v
.ic v(X_MEM.X_cell_19_3.q)=0v v(X_MEM.X_cell_19_3.qb)=0.7v
.ic v(X_MEM.X_cell_19_4.q)=0v v(X_MEM.X_cell_19_4.qb)=0.7v
.ic v(X_MEM.X_cell_19_5.q)=0v v(X_MEM.X_cell_19_5.qb)=0.7v
.ic v(X_MEM.X_cell_19_6.q)=0v v(X_MEM.X_cell_19_6.qb)=0.7v
.ic v(X_MEM.X_cell_19_7.q)=0v v(X_MEM.X_cell_19_7.qb)=0.7v
.ic v(X_MEM.X_cell_19_8.q)=0v v(X_MEM.X_cell_19_8.qb)=0.7v
.ic v(X_MEM.X_cell_19_9.q)=0v v(X_MEM.X_cell_19_9.qb)=0.7v
.ic v(X_MEM.X_cell_19_10.q)=0v v(X_MEM.X_cell_19_10.qb)=0.7v
.ic v(X_MEM.X_cell_19_11.q)=0v v(X_MEM.X_cell_19_11.qb)=0.7v
.ic v(X_MEM.X_cell_19_12.q)=0v v(X_MEM.X_cell_19_12.qb)=0.7v
.ic v(X_MEM.X_cell_19_13.q)=0v v(X_MEM.X_cell_19_13.qb)=0.7v
.ic v(X_MEM.X_cell_19_14.q)=0v v(X_MEM.X_cell_19_14.qb)=0.7v
.ic v(X_MEM.X_cell_19_15.q)=0v v(X_MEM.X_cell_19_15.qb)=0.7v
.ic v(X_MEM.X_cell_19_16.q)=0v v(X_MEM.X_cell_19_16.qb)=0.7v
.ic v(X_MEM.X_cell_19_17.q)=0v v(X_MEM.X_cell_19_17.qb)=0.7v
.ic v(X_MEM.X_cell_19_18.q)=0v v(X_MEM.X_cell_19_18.qb)=0.7v
.ic v(X_MEM.X_cell_19_19.q)=0v v(X_MEM.X_cell_19_19.qb)=0.7v
.ic v(X_MEM.X_cell_19_20.q)=0v v(X_MEM.X_cell_19_20.qb)=0.7v
.ic v(X_MEM.X_cell_19_21.q)=0v v(X_MEM.X_cell_19_21.qb)=0.7v
.ic v(X_MEM.X_cell_19_22.q)=0v v(X_MEM.X_cell_19_22.qb)=0.7v
.ic v(X_MEM.X_cell_19_23.q)=0v v(X_MEM.X_cell_19_23.qb)=0.7v
.ic v(X_MEM.X_cell_19_24.q)=0v v(X_MEM.X_cell_19_24.qb)=0.7v
.ic v(X_MEM.X_cell_19_25.q)=0v v(X_MEM.X_cell_19_25.qb)=0.7v
.ic v(X_MEM.X_cell_19_26.q)=0v v(X_MEM.X_cell_19_26.qb)=0.7v
.ic v(X_MEM.X_cell_19_27.q)=0v v(X_MEM.X_cell_19_27.qb)=0.7v
.ic v(X_MEM.X_cell_19_28.q)=0v v(X_MEM.X_cell_19_28.qb)=0.7v
.ic v(X_MEM.X_cell_19_29.q)=0v v(X_MEM.X_cell_19_29.qb)=0.7v
.ic v(X_MEM.X_cell_19_30.q)=0v v(X_MEM.X_cell_19_30.qb)=0.7v
.ic v(X_MEM.X_cell_19_31.q)=0v v(X_MEM.X_cell_19_31.qb)=0.7v
.ic v(X_MEM.X_cell_20_0.q)=0v v(X_MEM.X_cell_20_0.qb)=0.7v
.ic v(X_MEM.X_cell_20_1.q)=0v v(X_MEM.X_cell_20_1.qb)=0.7v
.ic v(X_MEM.X_cell_20_2.q)=0v v(X_MEM.X_cell_20_2.qb)=0.7v
.ic v(X_MEM.X_cell_20_3.q)=0v v(X_MEM.X_cell_20_3.qb)=0.7v
.ic v(X_MEM.X_cell_20_4.q)=0v v(X_MEM.X_cell_20_4.qb)=0.7v
.ic v(X_MEM.X_cell_20_5.q)=0v v(X_MEM.X_cell_20_5.qb)=0.7v
.ic v(X_MEM.X_cell_20_6.q)=0v v(X_MEM.X_cell_20_6.qb)=0.7v
.ic v(X_MEM.X_cell_20_7.q)=0v v(X_MEM.X_cell_20_7.qb)=0.7v
.ic v(X_MEM.X_cell_20_8.q)=0v v(X_MEM.X_cell_20_8.qb)=0.7v
.ic v(X_MEM.X_cell_20_9.q)=0v v(X_MEM.X_cell_20_9.qb)=0.7v
.ic v(X_MEM.X_cell_20_10.q)=0v v(X_MEM.X_cell_20_10.qb)=0.7v
.ic v(X_MEM.X_cell_20_11.q)=0v v(X_MEM.X_cell_20_11.qb)=0.7v
.ic v(X_MEM.X_cell_20_12.q)=0v v(X_MEM.X_cell_20_12.qb)=0.7v
.ic v(X_MEM.X_cell_20_13.q)=0v v(X_MEM.X_cell_20_13.qb)=0.7v
.ic v(X_MEM.X_cell_20_14.q)=0v v(X_MEM.X_cell_20_14.qb)=0.7v
.ic v(X_MEM.X_cell_20_15.q)=0v v(X_MEM.X_cell_20_15.qb)=0.7v
.ic v(X_MEM.X_cell_20_16.q)=0v v(X_MEM.X_cell_20_16.qb)=0.7v
.ic v(X_MEM.X_cell_20_17.q)=0v v(X_MEM.X_cell_20_17.qb)=0.7v
.ic v(X_MEM.X_cell_20_18.q)=0v v(X_MEM.X_cell_20_18.qb)=0.7v
.ic v(X_MEM.X_cell_20_19.q)=0v v(X_MEM.X_cell_20_19.qb)=0.7v
.ic v(X_MEM.X_cell_20_20.q)=0v v(X_MEM.X_cell_20_20.qb)=0.7v
.ic v(X_MEM.X_cell_20_21.q)=0v v(X_MEM.X_cell_20_21.qb)=0.7v
.ic v(X_MEM.X_cell_20_22.q)=0v v(X_MEM.X_cell_20_22.qb)=0.7v
.ic v(X_MEM.X_cell_20_23.q)=0v v(X_MEM.X_cell_20_23.qb)=0.7v
.ic v(X_MEM.X_cell_20_24.q)=0v v(X_MEM.X_cell_20_24.qb)=0.7v
.ic v(X_MEM.X_cell_20_25.q)=0v v(X_MEM.X_cell_20_25.qb)=0.7v
.ic v(X_MEM.X_cell_20_26.q)=0v v(X_MEM.X_cell_20_26.qb)=0.7v
.ic v(X_MEM.X_cell_20_27.q)=0v v(X_MEM.X_cell_20_27.qb)=0.7v
.ic v(X_MEM.X_cell_20_28.q)=0v v(X_MEM.X_cell_20_28.qb)=0.7v
.ic v(X_MEM.X_cell_20_29.q)=0v v(X_MEM.X_cell_20_29.qb)=0.7v
.ic v(X_MEM.X_cell_20_30.q)=0v v(X_MEM.X_cell_20_30.qb)=0.7v
.ic v(X_MEM.X_cell_20_31.q)=0v v(X_MEM.X_cell_20_31.qb)=0.7v
.ic v(X_MEM.X_cell_21_0.q)=0v v(X_MEM.X_cell_21_0.qb)=0.7v
.ic v(X_MEM.X_cell_21_1.q)=0v v(X_MEM.X_cell_21_1.qb)=0.7v
.ic v(X_MEM.X_cell_21_2.q)=0v v(X_MEM.X_cell_21_2.qb)=0.7v
.ic v(X_MEM.X_cell_21_3.q)=0v v(X_MEM.X_cell_21_3.qb)=0.7v
.ic v(X_MEM.X_cell_21_4.q)=0v v(X_MEM.X_cell_21_4.qb)=0.7v
.ic v(X_MEM.X_cell_21_5.q)=0v v(X_MEM.X_cell_21_5.qb)=0.7v
.ic v(X_MEM.X_cell_21_6.q)=0v v(X_MEM.X_cell_21_6.qb)=0.7v
.ic v(X_MEM.X_cell_21_7.q)=0v v(X_MEM.X_cell_21_7.qb)=0.7v
.ic v(X_MEM.X_cell_21_8.q)=0v v(X_MEM.X_cell_21_8.qb)=0.7v
.ic v(X_MEM.X_cell_21_9.q)=0v v(X_MEM.X_cell_21_9.qb)=0.7v
.ic v(X_MEM.X_cell_21_10.q)=0v v(X_MEM.X_cell_21_10.qb)=0.7v
.ic v(X_MEM.X_cell_21_11.q)=0v v(X_MEM.X_cell_21_11.qb)=0.7v
.ic v(X_MEM.X_cell_21_12.q)=0v v(X_MEM.X_cell_21_12.qb)=0.7v
.ic v(X_MEM.X_cell_21_13.q)=0v v(X_MEM.X_cell_21_13.qb)=0.7v
.ic v(X_MEM.X_cell_21_14.q)=0v v(X_MEM.X_cell_21_14.qb)=0.7v
.ic v(X_MEM.X_cell_21_15.q)=0v v(X_MEM.X_cell_21_15.qb)=0.7v
.ic v(X_MEM.X_cell_21_16.q)=0v v(X_MEM.X_cell_21_16.qb)=0.7v
.ic v(X_MEM.X_cell_21_17.q)=0v v(X_MEM.X_cell_21_17.qb)=0.7v
.ic v(X_MEM.X_cell_21_18.q)=0v v(X_MEM.X_cell_21_18.qb)=0.7v
.ic v(X_MEM.X_cell_21_19.q)=0v v(X_MEM.X_cell_21_19.qb)=0.7v
.ic v(X_MEM.X_cell_21_20.q)=0v v(X_MEM.X_cell_21_20.qb)=0.7v
.ic v(X_MEM.X_cell_21_21.q)=0v v(X_MEM.X_cell_21_21.qb)=0.7v
.ic v(X_MEM.X_cell_21_22.q)=0v v(X_MEM.X_cell_21_22.qb)=0.7v
.ic v(X_MEM.X_cell_21_23.q)=0v v(X_MEM.X_cell_21_23.qb)=0.7v
.ic v(X_MEM.X_cell_21_24.q)=0v v(X_MEM.X_cell_21_24.qb)=0.7v
.ic v(X_MEM.X_cell_21_25.q)=0v v(X_MEM.X_cell_21_25.qb)=0.7v
.ic v(X_MEM.X_cell_21_26.q)=0v v(X_MEM.X_cell_21_26.qb)=0.7v
.ic v(X_MEM.X_cell_21_27.q)=0v v(X_MEM.X_cell_21_27.qb)=0.7v
.ic v(X_MEM.X_cell_21_28.q)=0v v(X_MEM.X_cell_21_28.qb)=0.7v
.ic v(X_MEM.X_cell_21_29.q)=0v v(X_MEM.X_cell_21_29.qb)=0.7v
.ic v(X_MEM.X_cell_21_30.q)=0v v(X_MEM.X_cell_21_30.qb)=0.7v
.ic v(X_MEM.X_cell_21_31.q)=0v v(X_MEM.X_cell_21_31.qb)=0.7v
.ic v(X_MEM.X_cell_22_0.q)=0v v(X_MEM.X_cell_22_0.qb)=0.7v
.ic v(X_MEM.X_cell_22_1.q)=0v v(X_MEM.X_cell_22_1.qb)=0.7v
.ic v(X_MEM.X_cell_22_2.q)=0v v(X_MEM.X_cell_22_2.qb)=0.7v
.ic v(X_MEM.X_cell_22_3.q)=0v v(X_MEM.X_cell_22_3.qb)=0.7v
.ic v(X_MEM.X_cell_22_4.q)=0v v(X_MEM.X_cell_22_4.qb)=0.7v
.ic v(X_MEM.X_cell_22_5.q)=0v v(X_MEM.X_cell_22_5.qb)=0.7v
.ic v(X_MEM.X_cell_22_6.q)=0v v(X_MEM.X_cell_22_6.qb)=0.7v
.ic v(X_MEM.X_cell_22_7.q)=0v v(X_MEM.X_cell_22_7.qb)=0.7v
.ic v(X_MEM.X_cell_22_8.q)=0v v(X_MEM.X_cell_22_8.qb)=0.7v
.ic v(X_MEM.X_cell_22_9.q)=0v v(X_MEM.X_cell_22_9.qb)=0.7v
.ic v(X_MEM.X_cell_22_10.q)=0v v(X_MEM.X_cell_22_10.qb)=0.7v
.ic v(X_MEM.X_cell_22_11.q)=0v v(X_MEM.X_cell_22_11.qb)=0.7v
.ic v(X_MEM.X_cell_22_12.q)=0v v(X_MEM.X_cell_22_12.qb)=0.7v
.ic v(X_MEM.X_cell_22_13.q)=0v v(X_MEM.X_cell_22_13.qb)=0.7v
.ic v(X_MEM.X_cell_22_14.q)=0v v(X_MEM.X_cell_22_14.qb)=0.7v
.ic v(X_MEM.X_cell_22_15.q)=0v v(X_MEM.X_cell_22_15.qb)=0.7v
.ic v(X_MEM.X_cell_22_16.q)=0v v(X_MEM.X_cell_22_16.qb)=0.7v
.ic v(X_MEM.X_cell_22_17.q)=0v v(X_MEM.X_cell_22_17.qb)=0.7v
.ic v(X_MEM.X_cell_22_18.q)=0v v(X_MEM.X_cell_22_18.qb)=0.7v
.ic v(X_MEM.X_cell_22_19.q)=0v v(X_MEM.X_cell_22_19.qb)=0.7v
.ic v(X_MEM.X_cell_22_20.q)=0v v(X_MEM.X_cell_22_20.qb)=0.7v
.ic v(X_MEM.X_cell_22_21.q)=0v v(X_MEM.X_cell_22_21.qb)=0.7v
.ic v(X_MEM.X_cell_22_22.q)=0v v(X_MEM.X_cell_22_22.qb)=0.7v
.ic v(X_MEM.X_cell_22_23.q)=0v v(X_MEM.X_cell_22_23.qb)=0.7v
.ic v(X_MEM.X_cell_22_24.q)=0v v(X_MEM.X_cell_22_24.qb)=0.7v
.ic v(X_MEM.X_cell_22_25.q)=0v v(X_MEM.X_cell_22_25.qb)=0.7v
.ic v(X_MEM.X_cell_22_26.q)=0v v(X_MEM.X_cell_22_26.qb)=0.7v
.ic v(X_MEM.X_cell_22_27.q)=0v v(X_MEM.X_cell_22_27.qb)=0.7v
.ic v(X_MEM.X_cell_22_28.q)=0v v(X_MEM.X_cell_22_28.qb)=0.7v
.ic v(X_MEM.X_cell_22_29.q)=0v v(X_MEM.X_cell_22_29.qb)=0.7v
.ic v(X_MEM.X_cell_22_30.q)=0v v(X_MEM.X_cell_22_30.qb)=0.7v
.ic v(X_MEM.X_cell_22_31.q)=0v v(X_MEM.X_cell_22_31.qb)=0.7v
.ic v(X_MEM.X_cell_23_0.q)=0v v(X_MEM.X_cell_23_0.qb)=0.7v
.ic v(X_MEM.X_cell_23_1.q)=0v v(X_MEM.X_cell_23_1.qb)=0.7v
.ic v(X_MEM.X_cell_23_2.q)=0v v(X_MEM.X_cell_23_2.qb)=0.7v
.ic v(X_MEM.X_cell_23_3.q)=0v v(X_MEM.X_cell_23_3.qb)=0.7v
.ic v(X_MEM.X_cell_23_4.q)=0v v(X_MEM.X_cell_23_4.qb)=0.7v
.ic v(X_MEM.X_cell_23_5.q)=0v v(X_MEM.X_cell_23_5.qb)=0.7v
.ic v(X_MEM.X_cell_23_6.q)=0v v(X_MEM.X_cell_23_6.qb)=0.7v
.ic v(X_MEM.X_cell_23_7.q)=0v v(X_MEM.X_cell_23_7.qb)=0.7v
.ic v(X_MEM.X_cell_23_8.q)=0v v(X_MEM.X_cell_23_8.qb)=0.7v
.ic v(X_MEM.X_cell_23_9.q)=0v v(X_MEM.X_cell_23_9.qb)=0.7v
.ic v(X_MEM.X_cell_23_10.q)=0v v(X_MEM.X_cell_23_10.qb)=0.7v
.ic v(X_MEM.X_cell_23_11.q)=0v v(X_MEM.X_cell_23_11.qb)=0.7v
.ic v(X_MEM.X_cell_23_12.q)=0v v(X_MEM.X_cell_23_12.qb)=0.7v
.ic v(X_MEM.X_cell_23_13.q)=0v v(X_MEM.X_cell_23_13.qb)=0.7v
.ic v(X_MEM.X_cell_23_14.q)=0v v(X_MEM.X_cell_23_14.qb)=0.7v
.ic v(X_MEM.X_cell_23_15.q)=0v v(X_MEM.X_cell_23_15.qb)=0.7v
.ic v(X_MEM.X_cell_23_16.q)=0v v(X_MEM.X_cell_23_16.qb)=0.7v
.ic v(X_MEM.X_cell_23_17.q)=0v v(X_MEM.X_cell_23_17.qb)=0.7v
.ic v(X_MEM.X_cell_23_18.q)=0v v(X_MEM.X_cell_23_18.qb)=0.7v
.ic v(X_MEM.X_cell_23_19.q)=0v v(X_MEM.X_cell_23_19.qb)=0.7v
.ic v(X_MEM.X_cell_23_20.q)=0v v(X_MEM.X_cell_23_20.qb)=0.7v
.ic v(X_MEM.X_cell_23_21.q)=0v v(X_MEM.X_cell_23_21.qb)=0.7v
.ic v(X_MEM.X_cell_23_22.q)=0v v(X_MEM.X_cell_23_22.qb)=0.7v
.ic v(X_MEM.X_cell_23_23.q)=0v v(X_MEM.X_cell_23_23.qb)=0.7v
.ic v(X_MEM.X_cell_23_24.q)=0v v(X_MEM.X_cell_23_24.qb)=0.7v
.ic v(X_MEM.X_cell_23_25.q)=0v v(X_MEM.X_cell_23_25.qb)=0.7v
.ic v(X_MEM.X_cell_23_26.q)=0v v(X_MEM.X_cell_23_26.qb)=0.7v
.ic v(X_MEM.X_cell_23_27.q)=0v v(X_MEM.X_cell_23_27.qb)=0.7v
.ic v(X_MEM.X_cell_23_28.q)=0v v(X_MEM.X_cell_23_28.qb)=0.7v
.ic v(X_MEM.X_cell_23_29.q)=0v v(X_MEM.X_cell_23_29.qb)=0.7v
.ic v(X_MEM.X_cell_23_30.q)=0v v(X_MEM.X_cell_23_30.qb)=0.7v
.ic v(X_MEM.X_cell_23_31.q)=0v v(X_MEM.X_cell_23_31.qb)=0.7v
.ic v(X_MEM.X_cell_24_0.q)=0v v(X_MEM.X_cell_24_0.qb)=0.7v
.ic v(X_MEM.X_cell_24_1.q)=0v v(X_MEM.X_cell_24_1.qb)=0.7v
.ic v(X_MEM.X_cell_24_2.q)=0v v(X_MEM.X_cell_24_2.qb)=0.7v
.ic v(X_MEM.X_cell_24_3.q)=0v v(X_MEM.X_cell_24_3.qb)=0.7v
.ic v(X_MEM.X_cell_24_4.q)=0v v(X_MEM.X_cell_24_4.qb)=0.7v
.ic v(X_MEM.X_cell_24_5.q)=0v v(X_MEM.X_cell_24_5.qb)=0.7v
.ic v(X_MEM.X_cell_24_6.q)=0v v(X_MEM.X_cell_24_6.qb)=0.7v
.ic v(X_MEM.X_cell_24_7.q)=0v v(X_MEM.X_cell_24_7.qb)=0.7v
.ic v(X_MEM.X_cell_24_8.q)=0v v(X_MEM.X_cell_24_8.qb)=0.7v
.ic v(X_MEM.X_cell_24_9.q)=0v v(X_MEM.X_cell_24_9.qb)=0.7v
.ic v(X_MEM.X_cell_24_10.q)=0v v(X_MEM.X_cell_24_10.qb)=0.7v
.ic v(X_MEM.X_cell_24_11.q)=0v v(X_MEM.X_cell_24_11.qb)=0.7v
.ic v(X_MEM.X_cell_24_12.q)=0v v(X_MEM.X_cell_24_12.qb)=0.7v
.ic v(X_MEM.X_cell_24_13.q)=0v v(X_MEM.X_cell_24_13.qb)=0.7v
.ic v(X_MEM.X_cell_24_14.q)=0v v(X_MEM.X_cell_24_14.qb)=0.7v
.ic v(X_MEM.X_cell_24_15.q)=0v v(X_MEM.X_cell_24_15.qb)=0.7v
.ic v(X_MEM.X_cell_24_16.q)=0v v(X_MEM.X_cell_24_16.qb)=0.7v
.ic v(X_MEM.X_cell_24_17.q)=0v v(X_MEM.X_cell_24_17.qb)=0.7v
.ic v(X_MEM.X_cell_24_18.q)=0v v(X_MEM.X_cell_24_18.qb)=0.7v
.ic v(X_MEM.X_cell_24_19.q)=0v v(X_MEM.X_cell_24_19.qb)=0.7v
.ic v(X_MEM.X_cell_24_20.q)=0v v(X_MEM.X_cell_24_20.qb)=0.7v
.ic v(X_MEM.X_cell_24_21.q)=0v v(X_MEM.X_cell_24_21.qb)=0.7v
.ic v(X_MEM.X_cell_24_22.q)=0v v(X_MEM.X_cell_24_22.qb)=0.7v
.ic v(X_MEM.X_cell_24_23.q)=0v v(X_MEM.X_cell_24_23.qb)=0.7v
.ic v(X_MEM.X_cell_24_24.q)=0v v(X_MEM.X_cell_24_24.qb)=0.7v
.ic v(X_MEM.X_cell_24_25.q)=0v v(X_MEM.X_cell_24_25.qb)=0.7v
.ic v(X_MEM.X_cell_24_26.q)=0v v(X_MEM.X_cell_24_26.qb)=0.7v
.ic v(X_MEM.X_cell_24_27.q)=0v v(X_MEM.X_cell_24_27.qb)=0.7v
.ic v(X_MEM.X_cell_24_28.q)=0v v(X_MEM.X_cell_24_28.qb)=0.7v
.ic v(X_MEM.X_cell_24_29.q)=0v v(X_MEM.X_cell_24_29.qb)=0.7v
.ic v(X_MEM.X_cell_24_30.q)=0v v(X_MEM.X_cell_24_30.qb)=0.7v
.ic v(X_MEM.X_cell_24_31.q)=0v v(X_MEM.X_cell_24_31.qb)=0.7v
.ic v(X_MEM.X_cell_25_0.q)=0v v(X_MEM.X_cell_25_0.qb)=0.7v
.ic v(X_MEM.X_cell_25_1.q)=0v v(X_MEM.X_cell_25_1.qb)=0.7v
.ic v(X_MEM.X_cell_25_2.q)=0v v(X_MEM.X_cell_25_2.qb)=0.7v
.ic v(X_MEM.X_cell_25_3.q)=0v v(X_MEM.X_cell_25_3.qb)=0.7v
.ic v(X_MEM.X_cell_25_4.q)=0v v(X_MEM.X_cell_25_4.qb)=0.7v
.ic v(X_MEM.X_cell_25_5.q)=0v v(X_MEM.X_cell_25_5.qb)=0.7v
.ic v(X_MEM.X_cell_25_6.q)=0v v(X_MEM.X_cell_25_6.qb)=0.7v
.ic v(X_MEM.X_cell_25_7.q)=0v v(X_MEM.X_cell_25_7.qb)=0.7v
.ic v(X_MEM.X_cell_25_8.q)=0v v(X_MEM.X_cell_25_8.qb)=0.7v
.ic v(X_MEM.X_cell_25_9.q)=0v v(X_MEM.X_cell_25_9.qb)=0.7v
.ic v(X_MEM.X_cell_25_10.q)=0v v(X_MEM.X_cell_25_10.qb)=0.7v
.ic v(X_MEM.X_cell_25_11.q)=0v v(X_MEM.X_cell_25_11.qb)=0.7v
.ic v(X_MEM.X_cell_25_12.q)=0v v(X_MEM.X_cell_25_12.qb)=0.7v
.ic v(X_MEM.X_cell_25_13.q)=0v v(X_MEM.X_cell_25_13.qb)=0.7v
.ic v(X_MEM.X_cell_25_14.q)=0v v(X_MEM.X_cell_25_14.qb)=0.7v
.ic v(X_MEM.X_cell_25_15.q)=0v v(X_MEM.X_cell_25_15.qb)=0.7v
.ic v(X_MEM.X_cell_25_16.q)=0v v(X_MEM.X_cell_25_16.qb)=0.7v
.ic v(X_MEM.X_cell_25_17.q)=0v v(X_MEM.X_cell_25_17.qb)=0.7v
.ic v(X_MEM.X_cell_25_18.q)=0v v(X_MEM.X_cell_25_18.qb)=0.7v
.ic v(X_MEM.X_cell_25_19.q)=0v v(X_MEM.X_cell_25_19.qb)=0.7v
.ic v(X_MEM.X_cell_25_20.q)=0v v(X_MEM.X_cell_25_20.qb)=0.7v
.ic v(X_MEM.X_cell_25_21.q)=0v v(X_MEM.X_cell_25_21.qb)=0.7v
.ic v(X_MEM.X_cell_25_22.q)=0v v(X_MEM.X_cell_25_22.qb)=0.7v
.ic v(X_MEM.X_cell_25_23.q)=0v v(X_MEM.X_cell_25_23.qb)=0.7v
.ic v(X_MEM.X_cell_25_24.q)=0v v(X_MEM.X_cell_25_24.qb)=0.7v
.ic v(X_MEM.X_cell_25_25.q)=0v v(X_MEM.X_cell_25_25.qb)=0.7v
.ic v(X_MEM.X_cell_25_26.q)=0v v(X_MEM.X_cell_25_26.qb)=0.7v
.ic v(X_MEM.X_cell_25_27.q)=0v v(X_MEM.X_cell_25_27.qb)=0.7v
.ic v(X_MEM.X_cell_25_28.q)=0v v(X_MEM.X_cell_25_28.qb)=0.7v
.ic v(X_MEM.X_cell_25_29.q)=0v v(X_MEM.X_cell_25_29.qb)=0.7v
.ic v(X_MEM.X_cell_25_30.q)=0v v(X_MEM.X_cell_25_30.qb)=0.7v
.ic v(X_MEM.X_cell_25_31.q)=0v v(X_MEM.X_cell_25_31.qb)=0.7v
.ic v(X_MEM.X_cell_26_0.q)=0v v(X_MEM.X_cell_26_0.qb)=0.7v
.ic v(X_MEM.X_cell_26_1.q)=0v v(X_MEM.X_cell_26_1.qb)=0.7v
.ic v(X_MEM.X_cell_26_2.q)=0v v(X_MEM.X_cell_26_2.qb)=0.7v
.ic v(X_MEM.X_cell_26_3.q)=0v v(X_MEM.X_cell_26_3.qb)=0.7v
.ic v(X_MEM.X_cell_26_4.q)=0v v(X_MEM.X_cell_26_4.qb)=0.7v
.ic v(X_MEM.X_cell_26_5.q)=0v v(X_MEM.X_cell_26_5.qb)=0.7v
.ic v(X_MEM.X_cell_26_6.q)=0v v(X_MEM.X_cell_26_6.qb)=0.7v
.ic v(X_MEM.X_cell_26_7.q)=0v v(X_MEM.X_cell_26_7.qb)=0.7v
.ic v(X_MEM.X_cell_26_8.q)=0v v(X_MEM.X_cell_26_8.qb)=0.7v
.ic v(X_MEM.X_cell_26_9.q)=0v v(X_MEM.X_cell_26_9.qb)=0.7v
.ic v(X_MEM.X_cell_26_10.q)=0v v(X_MEM.X_cell_26_10.qb)=0.7v
.ic v(X_MEM.X_cell_26_11.q)=0v v(X_MEM.X_cell_26_11.qb)=0.7v
.ic v(X_MEM.X_cell_26_12.q)=0v v(X_MEM.X_cell_26_12.qb)=0.7v
.ic v(X_MEM.X_cell_26_13.q)=0v v(X_MEM.X_cell_26_13.qb)=0.7v
.ic v(X_MEM.X_cell_26_14.q)=0v v(X_MEM.X_cell_26_14.qb)=0.7v
.ic v(X_MEM.X_cell_26_15.q)=0v v(X_MEM.X_cell_26_15.qb)=0.7v
.ic v(X_MEM.X_cell_26_16.q)=0v v(X_MEM.X_cell_26_16.qb)=0.7v
.ic v(X_MEM.X_cell_26_17.q)=0v v(X_MEM.X_cell_26_17.qb)=0.7v
.ic v(X_MEM.X_cell_26_18.q)=0v v(X_MEM.X_cell_26_18.qb)=0.7v
.ic v(X_MEM.X_cell_26_19.q)=0v v(X_MEM.X_cell_26_19.qb)=0.7v
.ic v(X_MEM.X_cell_26_20.q)=0v v(X_MEM.X_cell_26_20.qb)=0.7v
.ic v(X_MEM.X_cell_26_21.q)=0v v(X_MEM.X_cell_26_21.qb)=0.7v
.ic v(X_MEM.X_cell_26_22.q)=0v v(X_MEM.X_cell_26_22.qb)=0.7v
.ic v(X_MEM.X_cell_26_23.q)=0v v(X_MEM.X_cell_26_23.qb)=0.7v
.ic v(X_MEM.X_cell_26_24.q)=0v v(X_MEM.X_cell_26_24.qb)=0.7v
.ic v(X_MEM.X_cell_26_25.q)=0v v(X_MEM.X_cell_26_25.qb)=0.7v
.ic v(X_MEM.X_cell_26_26.q)=0v v(X_MEM.X_cell_26_26.qb)=0.7v
.ic v(X_MEM.X_cell_26_27.q)=0v v(X_MEM.X_cell_26_27.qb)=0.7v
.ic v(X_MEM.X_cell_26_28.q)=0v v(X_MEM.X_cell_26_28.qb)=0.7v
.ic v(X_MEM.X_cell_26_29.q)=0v v(X_MEM.X_cell_26_29.qb)=0.7v
.ic v(X_MEM.X_cell_26_30.q)=0v v(X_MEM.X_cell_26_30.qb)=0.7v
.ic v(X_MEM.X_cell_26_31.q)=0v v(X_MEM.X_cell_26_31.qb)=0.7v
.ic v(X_MEM.X_cell_27_0.q)=0v v(X_MEM.X_cell_27_0.qb)=0.7v
.ic v(X_MEM.X_cell_27_1.q)=0v v(X_MEM.X_cell_27_1.qb)=0.7v
.ic v(X_MEM.X_cell_27_2.q)=0v v(X_MEM.X_cell_27_2.qb)=0.7v
.ic v(X_MEM.X_cell_27_3.q)=0v v(X_MEM.X_cell_27_3.qb)=0.7v
.ic v(X_MEM.X_cell_27_4.q)=0v v(X_MEM.X_cell_27_4.qb)=0.7v
.ic v(X_MEM.X_cell_27_5.q)=0v v(X_MEM.X_cell_27_5.qb)=0.7v
.ic v(X_MEM.X_cell_27_6.q)=0v v(X_MEM.X_cell_27_6.qb)=0.7v
.ic v(X_MEM.X_cell_27_7.q)=0v v(X_MEM.X_cell_27_7.qb)=0.7v
.ic v(X_MEM.X_cell_27_8.q)=0v v(X_MEM.X_cell_27_8.qb)=0.7v
.ic v(X_MEM.X_cell_27_9.q)=0v v(X_MEM.X_cell_27_9.qb)=0.7v
.ic v(X_MEM.X_cell_27_10.q)=0v v(X_MEM.X_cell_27_10.qb)=0.7v
.ic v(X_MEM.X_cell_27_11.q)=0v v(X_MEM.X_cell_27_11.qb)=0.7v
.ic v(X_MEM.X_cell_27_12.q)=0v v(X_MEM.X_cell_27_12.qb)=0.7v
.ic v(X_MEM.X_cell_27_13.q)=0v v(X_MEM.X_cell_27_13.qb)=0.7v
.ic v(X_MEM.X_cell_27_14.q)=0v v(X_MEM.X_cell_27_14.qb)=0.7v
.ic v(X_MEM.X_cell_27_15.q)=0v v(X_MEM.X_cell_27_15.qb)=0.7v
.ic v(X_MEM.X_cell_27_16.q)=0v v(X_MEM.X_cell_27_16.qb)=0.7v
.ic v(X_MEM.X_cell_27_17.q)=0v v(X_MEM.X_cell_27_17.qb)=0.7v
.ic v(X_MEM.X_cell_27_18.q)=0v v(X_MEM.X_cell_27_18.qb)=0.7v
.ic v(X_MEM.X_cell_27_19.q)=0v v(X_MEM.X_cell_27_19.qb)=0.7v
.ic v(X_MEM.X_cell_27_20.q)=0v v(X_MEM.X_cell_27_20.qb)=0.7v
.ic v(X_MEM.X_cell_27_21.q)=0v v(X_MEM.X_cell_27_21.qb)=0.7v
.ic v(X_MEM.X_cell_27_22.q)=0v v(X_MEM.X_cell_27_22.qb)=0.7v
.ic v(X_MEM.X_cell_27_23.q)=0v v(X_MEM.X_cell_27_23.qb)=0.7v
.ic v(X_MEM.X_cell_27_24.q)=0v v(X_MEM.X_cell_27_24.qb)=0.7v
.ic v(X_MEM.X_cell_27_25.q)=0v v(X_MEM.X_cell_27_25.qb)=0.7v
.ic v(X_MEM.X_cell_27_26.q)=0v v(X_MEM.X_cell_27_26.qb)=0.7v
.ic v(X_MEM.X_cell_27_27.q)=0v v(X_MEM.X_cell_27_27.qb)=0.7v
.ic v(X_MEM.X_cell_27_28.q)=0v v(X_MEM.X_cell_27_28.qb)=0.7v
.ic v(X_MEM.X_cell_27_29.q)=0v v(X_MEM.X_cell_27_29.qb)=0.7v
.ic v(X_MEM.X_cell_27_30.q)=0v v(X_MEM.X_cell_27_30.qb)=0.7v
.ic v(X_MEM.X_cell_27_31.q)=0v v(X_MEM.X_cell_27_31.qb)=0.7v
.ic v(X_MEM.X_cell_28_0.q)=0v v(X_MEM.X_cell_28_0.qb)=0.7v
.ic v(X_MEM.X_cell_28_1.q)=0v v(X_MEM.X_cell_28_1.qb)=0.7v
.ic v(X_MEM.X_cell_28_2.q)=0v v(X_MEM.X_cell_28_2.qb)=0.7v
.ic v(X_MEM.X_cell_28_3.q)=0v v(X_MEM.X_cell_28_3.qb)=0.7v
.ic v(X_MEM.X_cell_28_4.q)=0v v(X_MEM.X_cell_28_4.qb)=0.7v
.ic v(X_MEM.X_cell_28_5.q)=0v v(X_MEM.X_cell_28_5.qb)=0.7v
.ic v(X_MEM.X_cell_28_6.q)=0v v(X_MEM.X_cell_28_6.qb)=0.7v
.ic v(X_MEM.X_cell_28_7.q)=0v v(X_MEM.X_cell_28_7.qb)=0.7v
.ic v(X_MEM.X_cell_28_8.q)=0v v(X_MEM.X_cell_28_8.qb)=0.7v
.ic v(X_MEM.X_cell_28_9.q)=0v v(X_MEM.X_cell_28_9.qb)=0.7v
.ic v(X_MEM.X_cell_28_10.q)=0v v(X_MEM.X_cell_28_10.qb)=0.7v
.ic v(X_MEM.X_cell_28_11.q)=0v v(X_MEM.X_cell_28_11.qb)=0.7v
.ic v(X_MEM.X_cell_28_12.q)=0v v(X_MEM.X_cell_28_12.qb)=0.7v
.ic v(X_MEM.X_cell_28_13.q)=0v v(X_MEM.X_cell_28_13.qb)=0.7v
.ic v(X_MEM.X_cell_28_14.q)=0v v(X_MEM.X_cell_28_14.qb)=0.7v
.ic v(X_MEM.X_cell_28_15.q)=0v v(X_MEM.X_cell_28_15.qb)=0.7v
.ic v(X_MEM.X_cell_28_16.q)=0v v(X_MEM.X_cell_28_16.qb)=0.7v
.ic v(X_MEM.X_cell_28_17.q)=0v v(X_MEM.X_cell_28_17.qb)=0.7v
.ic v(X_MEM.X_cell_28_18.q)=0v v(X_MEM.X_cell_28_18.qb)=0.7v
.ic v(X_MEM.X_cell_28_19.q)=0v v(X_MEM.X_cell_28_19.qb)=0.7v
.ic v(X_MEM.X_cell_28_20.q)=0v v(X_MEM.X_cell_28_20.qb)=0.7v
.ic v(X_MEM.X_cell_28_21.q)=0v v(X_MEM.X_cell_28_21.qb)=0.7v
.ic v(X_MEM.X_cell_28_22.q)=0v v(X_MEM.X_cell_28_22.qb)=0.7v
.ic v(X_MEM.X_cell_28_23.q)=0v v(X_MEM.X_cell_28_23.qb)=0.7v
.ic v(X_MEM.X_cell_28_24.q)=0v v(X_MEM.X_cell_28_24.qb)=0.7v
.ic v(X_MEM.X_cell_28_25.q)=0v v(X_MEM.X_cell_28_25.qb)=0.7v
.ic v(X_MEM.X_cell_28_26.q)=0v v(X_MEM.X_cell_28_26.qb)=0.7v
.ic v(X_MEM.X_cell_28_27.q)=0v v(X_MEM.X_cell_28_27.qb)=0.7v
.ic v(X_MEM.X_cell_28_28.q)=0v v(X_MEM.X_cell_28_28.qb)=0.7v
.ic v(X_MEM.X_cell_28_29.q)=0v v(X_MEM.X_cell_28_29.qb)=0.7v
.ic v(X_MEM.X_cell_28_30.q)=0v v(X_MEM.X_cell_28_30.qb)=0.7v
.ic v(X_MEM.X_cell_28_31.q)=0v v(X_MEM.X_cell_28_31.qb)=0.7v
.ic v(X_MEM.X_cell_29_0.q)=0v v(X_MEM.X_cell_29_0.qb)=0.7v
.ic v(X_MEM.X_cell_29_1.q)=0v v(X_MEM.X_cell_29_1.qb)=0.7v
.ic v(X_MEM.X_cell_29_2.q)=0v v(X_MEM.X_cell_29_2.qb)=0.7v
.ic v(X_MEM.X_cell_29_3.q)=0v v(X_MEM.X_cell_29_3.qb)=0.7v
.ic v(X_MEM.X_cell_29_4.q)=0v v(X_MEM.X_cell_29_4.qb)=0.7v
.ic v(X_MEM.X_cell_29_5.q)=0v v(X_MEM.X_cell_29_5.qb)=0.7v
.ic v(X_MEM.X_cell_29_6.q)=0v v(X_MEM.X_cell_29_6.qb)=0.7v
.ic v(X_MEM.X_cell_29_7.q)=0v v(X_MEM.X_cell_29_7.qb)=0.7v
.ic v(X_MEM.X_cell_29_8.q)=0v v(X_MEM.X_cell_29_8.qb)=0.7v
.ic v(X_MEM.X_cell_29_9.q)=0v v(X_MEM.X_cell_29_9.qb)=0.7v
.ic v(X_MEM.X_cell_29_10.q)=0v v(X_MEM.X_cell_29_10.qb)=0.7v
.ic v(X_MEM.X_cell_29_11.q)=0v v(X_MEM.X_cell_29_11.qb)=0.7v
.ic v(X_MEM.X_cell_29_12.q)=0v v(X_MEM.X_cell_29_12.qb)=0.7v
.ic v(X_MEM.X_cell_29_13.q)=0v v(X_MEM.X_cell_29_13.qb)=0.7v
.ic v(X_MEM.X_cell_29_14.q)=0v v(X_MEM.X_cell_29_14.qb)=0.7v
.ic v(X_MEM.X_cell_29_15.q)=0v v(X_MEM.X_cell_29_15.qb)=0.7v
.ic v(X_MEM.X_cell_29_16.q)=0v v(X_MEM.X_cell_29_16.qb)=0.7v
.ic v(X_MEM.X_cell_29_17.q)=0v v(X_MEM.X_cell_29_17.qb)=0.7v
.ic v(X_MEM.X_cell_29_18.q)=0v v(X_MEM.X_cell_29_18.qb)=0.7v
.ic v(X_MEM.X_cell_29_19.q)=0v v(X_MEM.X_cell_29_19.qb)=0.7v
.ic v(X_MEM.X_cell_29_20.q)=0v v(X_MEM.X_cell_29_20.qb)=0.7v
.ic v(X_MEM.X_cell_29_21.q)=0v v(X_MEM.X_cell_29_21.qb)=0.7v
.ic v(X_MEM.X_cell_29_22.q)=0v v(X_MEM.X_cell_29_22.qb)=0.7v
.ic v(X_MEM.X_cell_29_23.q)=0v v(X_MEM.X_cell_29_23.qb)=0.7v
.ic v(X_MEM.X_cell_29_24.q)=0v v(X_MEM.X_cell_29_24.qb)=0.7v
.ic v(X_MEM.X_cell_29_25.q)=0v v(X_MEM.X_cell_29_25.qb)=0.7v
.ic v(X_MEM.X_cell_29_26.q)=0v v(X_MEM.X_cell_29_26.qb)=0.7v
.ic v(X_MEM.X_cell_29_27.q)=0v v(X_MEM.X_cell_29_27.qb)=0.7v
.ic v(X_MEM.X_cell_29_28.q)=0v v(X_MEM.X_cell_29_28.qb)=0.7v
.ic v(X_MEM.X_cell_29_29.q)=0v v(X_MEM.X_cell_29_29.qb)=0.7v
.ic v(X_MEM.X_cell_29_30.q)=0v v(X_MEM.X_cell_29_30.qb)=0.7v
.ic v(X_MEM.X_cell_29_31.q)=0v v(X_MEM.X_cell_29_31.qb)=0.7v
.ic v(X_MEM.X_cell_30_0.q)=0v v(X_MEM.X_cell_30_0.qb)=0.7v
.ic v(X_MEM.X_cell_30_1.q)=0v v(X_MEM.X_cell_30_1.qb)=0.7v
.ic v(X_MEM.X_cell_30_2.q)=0v v(X_MEM.X_cell_30_2.qb)=0.7v
.ic v(X_MEM.X_cell_30_3.q)=0v v(X_MEM.X_cell_30_3.qb)=0.7v
.ic v(X_MEM.X_cell_30_4.q)=0v v(X_MEM.X_cell_30_4.qb)=0.7v
.ic v(X_MEM.X_cell_30_5.q)=0v v(X_MEM.X_cell_30_5.qb)=0.7v
.ic v(X_MEM.X_cell_30_6.q)=0v v(X_MEM.X_cell_30_6.qb)=0.7v
.ic v(X_MEM.X_cell_30_7.q)=0v v(X_MEM.X_cell_30_7.qb)=0.7v
.ic v(X_MEM.X_cell_30_8.q)=0v v(X_MEM.X_cell_30_8.qb)=0.7v
.ic v(X_MEM.X_cell_30_9.q)=0v v(X_MEM.X_cell_30_9.qb)=0.7v
.ic v(X_MEM.X_cell_30_10.q)=0v v(X_MEM.X_cell_30_10.qb)=0.7v
.ic v(X_MEM.X_cell_30_11.q)=0v v(X_MEM.X_cell_30_11.qb)=0.7v
.ic v(X_MEM.X_cell_30_12.q)=0v v(X_MEM.X_cell_30_12.qb)=0.7v
.ic v(X_MEM.X_cell_30_13.q)=0v v(X_MEM.X_cell_30_13.qb)=0.7v
.ic v(X_MEM.X_cell_30_14.q)=0v v(X_MEM.X_cell_30_14.qb)=0.7v
.ic v(X_MEM.X_cell_30_15.q)=0v v(X_MEM.X_cell_30_15.qb)=0.7v
.ic v(X_MEM.X_cell_30_16.q)=0v v(X_MEM.X_cell_30_16.qb)=0.7v
.ic v(X_MEM.X_cell_30_17.q)=0v v(X_MEM.X_cell_30_17.qb)=0.7v
.ic v(X_MEM.X_cell_30_18.q)=0v v(X_MEM.X_cell_30_18.qb)=0.7v
.ic v(X_MEM.X_cell_30_19.q)=0v v(X_MEM.X_cell_30_19.qb)=0.7v
.ic v(X_MEM.X_cell_30_20.q)=0v v(X_MEM.X_cell_30_20.qb)=0.7v
.ic v(X_MEM.X_cell_30_21.q)=0v v(X_MEM.X_cell_30_21.qb)=0.7v
.ic v(X_MEM.X_cell_30_22.q)=0v v(X_MEM.X_cell_30_22.qb)=0.7v
.ic v(X_MEM.X_cell_30_23.q)=0v v(X_MEM.X_cell_30_23.qb)=0.7v
.ic v(X_MEM.X_cell_30_24.q)=0v v(X_MEM.X_cell_30_24.qb)=0.7v
.ic v(X_MEM.X_cell_30_25.q)=0v v(X_MEM.X_cell_30_25.qb)=0.7v
.ic v(X_MEM.X_cell_30_26.q)=0v v(X_MEM.X_cell_30_26.qb)=0.7v
.ic v(X_MEM.X_cell_30_27.q)=0v v(X_MEM.X_cell_30_27.qb)=0.7v
.ic v(X_MEM.X_cell_30_28.q)=0v v(X_MEM.X_cell_30_28.qb)=0.7v
.ic v(X_MEM.X_cell_30_29.q)=0v v(X_MEM.X_cell_30_29.qb)=0.7v
.ic v(X_MEM.X_cell_30_30.q)=0v v(X_MEM.X_cell_30_30.qb)=0.7v
.ic v(X_MEM.X_cell_30_31.q)=0v v(X_MEM.X_cell_30_31.qb)=0.7v
.ic v(X_MEM.X_cell_31_0.q)=0v v(X_MEM.X_cell_31_0.qb)=0.7v
.ic v(X_MEM.X_cell_31_1.q)=0v v(X_MEM.X_cell_31_1.qb)=0.7v
.ic v(X_MEM.X_cell_31_2.q)=0v v(X_MEM.X_cell_31_2.qb)=0.7v
.ic v(X_MEM.X_cell_31_3.q)=0v v(X_MEM.X_cell_31_3.qb)=0.7v
.ic v(X_MEM.X_cell_31_4.q)=0v v(X_MEM.X_cell_31_4.qb)=0.7v
.ic v(X_MEM.X_cell_31_5.q)=0v v(X_MEM.X_cell_31_5.qb)=0.7v
.ic v(X_MEM.X_cell_31_6.q)=0v v(X_MEM.X_cell_31_6.qb)=0.7v
.ic v(X_MEM.X_cell_31_7.q)=0v v(X_MEM.X_cell_31_7.qb)=0.7v
.ic v(X_MEM.X_cell_31_8.q)=0v v(X_MEM.X_cell_31_8.qb)=0.7v
.ic v(X_MEM.X_cell_31_9.q)=0v v(X_MEM.X_cell_31_9.qb)=0.7v
.ic v(X_MEM.X_cell_31_10.q)=0v v(X_MEM.X_cell_31_10.qb)=0.7v
.ic v(X_MEM.X_cell_31_11.q)=0v v(X_MEM.X_cell_31_11.qb)=0.7v
.ic v(X_MEM.X_cell_31_12.q)=0v v(X_MEM.X_cell_31_12.qb)=0.7v
.ic v(X_MEM.X_cell_31_13.q)=0v v(X_MEM.X_cell_31_13.qb)=0.7v
.ic v(X_MEM.X_cell_31_14.q)=0v v(X_MEM.X_cell_31_14.qb)=0.7v
.ic v(X_MEM.X_cell_31_15.q)=0v v(X_MEM.X_cell_31_15.qb)=0.7v
.ic v(X_MEM.X_cell_31_16.q)=0v v(X_MEM.X_cell_31_16.qb)=0.7v
.ic v(X_MEM.X_cell_31_17.q)=0v v(X_MEM.X_cell_31_17.qb)=0.7v
.ic v(X_MEM.X_cell_31_18.q)=0v v(X_MEM.X_cell_31_18.qb)=0.7v
.ic v(X_MEM.X_cell_31_19.q)=0v v(X_MEM.X_cell_31_19.qb)=0.7v
.ic v(X_MEM.X_cell_31_20.q)=0v v(X_MEM.X_cell_31_20.qb)=0.7v
.ic v(X_MEM.X_cell_31_21.q)=0v v(X_MEM.X_cell_31_21.qb)=0.7v
.ic v(X_MEM.X_cell_31_22.q)=0v v(X_MEM.X_cell_31_22.qb)=0.7v
.ic v(X_MEM.X_cell_31_23.q)=0v v(X_MEM.X_cell_31_23.qb)=0.7v
.ic v(X_MEM.X_cell_31_24.q)=0v v(X_MEM.X_cell_31_24.qb)=0.7v
.ic v(X_MEM.X_cell_31_25.q)=0v v(X_MEM.X_cell_31_25.qb)=0.7v
.ic v(X_MEM.X_cell_31_26.q)=0v v(X_MEM.X_cell_31_26.qb)=0.7v
.ic v(X_MEM.X_cell_31_27.q)=0v v(X_MEM.X_cell_31_27.qb)=0.7v
.ic v(X_MEM.X_cell_31_28.q)=0v v(X_MEM.X_cell_31_28.qb)=0.7v
.ic v(X_MEM.X_cell_31_29.q)=0v v(X_MEM.X_cell_31_29.qb)=0.7v
.ic v(X_MEM.X_cell_31_30.q)=0v v(X_MEM.X_cell_31_30.qb)=0.7v
.ic v(X_MEM.X_cell_31_31.q)=0v v(X_MEM.X_cell_31_31.qb)=0.7v
.ic v(X_MEM.X_cell_32_0.q)=0v v(X_MEM.X_cell_32_0.qb)=0.7v
.ic v(X_MEM.X_cell_32_1.q)=0v v(X_MEM.X_cell_32_1.qb)=0.7v
.ic v(X_MEM.X_cell_32_2.q)=0v v(X_MEM.X_cell_32_2.qb)=0.7v
.ic v(X_MEM.X_cell_32_3.q)=0v v(X_MEM.X_cell_32_3.qb)=0.7v
.ic v(X_MEM.X_cell_32_4.q)=0v v(X_MEM.X_cell_32_4.qb)=0.7v
.ic v(X_MEM.X_cell_32_5.q)=0v v(X_MEM.X_cell_32_5.qb)=0.7v
.ic v(X_MEM.X_cell_32_6.q)=0v v(X_MEM.X_cell_32_6.qb)=0.7v
.ic v(X_MEM.X_cell_32_7.q)=0v v(X_MEM.X_cell_32_7.qb)=0.7v
.ic v(X_MEM.X_cell_32_8.q)=0v v(X_MEM.X_cell_32_8.qb)=0.7v
.ic v(X_MEM.X_cell_32_9.q)=0v v(X_MEM.X_cell_32_9.qb)=0.7v
.ic v(X_MEM.X_cell_32_10.q)=0v v(X_MEM.X_cell_32_10.qb)=0.7v
.ic v(X_MEM.X_cell_32_11.q)=0v v(X_MEM.X_cell_32_11.qb)=0.7v
.ic v(X_MEM.X_cell_32_12.q)=0v v(X_MEM.X_cell_32_12.qb)=0.7v
.ic v(X_MEM.X_cell_32_13.q)=0v v(X_MEM.X_cell_32_13.qb)=0.7v
.ic v(X_MEM.X_cell_32_14.q)=0v v(X_MEM.X_cell_32_14.qb)=0.7v
.ic v(X_MEM.X_cell_32_15.q)=0v v(X_MEM.X_cell_32_15.qb)=0.7v
.ic v(X_MEM.X_cell_32_16.q)=0v v(X_MEM.X_cell_32_16.qb)=0.7v
.ic v(X_MEM.X_cell_32_17.q)=0v v(X_MEM.X_cell_32_17.qb)=0.7v
.ic v(X_MEM.X_cell_32_18.q)=0v v(X_MEM.X_cell_32_18.qb)=0.7v
.ic v(X_MEM.X_cell_32_19.q)=0v v(X_MEM.X_cell_32_19.qb)=0.7v
.ic v(X_MEM.X_cell_32_20.q)=0v v(X_MEM.X_cell_32_20.qb)=0.7v
.ic v(X_MEM.X_cell_32_21.q)=0v v(X_MEM.X_cell_32_21.qb)=0.7v
.ic v(X_MEM.X_cell_32_22.q)=0v v(X_MEM.X_cell_32_22.qb)=0.7v
.ic v(X_MEM.X_cell_32_23.q)=0v v(X_MEM.X_cell_32_23.qb)=0.7v
.ic v(X_MEM.X_cell_32_24.q)=0v v(X_MEM.X_cell_32_24.qb)=0.7v
.ic v(X_MEM.X_cell_32_25.q)=0v v(X_MEM.X_cell_32_25.qb)=0.7v
.ic v(X_MEM.X_cell_32_26.q)=0v v(X_MEM.X_cell_32_26.qb)=0.7v
.ic v(X_MEM.X_cell_32_27.q)=0v v(X_MEM.X_cell_32_27.qb)=0.7v
.ic v(X_MEM.X_cell_32_28.q)=0v v(X_MEM.X_cell_32_28.qb)=0.7v
.ic v(X_MEM.X_cell_32_29.q)=0v v(X_MEM.X_cell_32_29.qb)=0.7v
.ic v(X_MEM.X_cell_32_30.q)=0v v(X_MEM.X_cell_32_30.qb)=0.7v
.ic v(X_MEM.X_cell_32_31.q)=0v v(X_MEM.X_cell_32_31.qb)=0.7v
.ic v(X_MEM.X_cell_33_0.q)=0v v(X_MEM.X_cell_33_0.qb)=0.7v
.ic v(X_MEM.X_cell_33_1.q)=0v v(X_MEM.X_cell_33_1.qb)=0.7v
.ic v(X_MEM.X_cell_33_2.q)=0v v(X_MEM.X_cell_33_2.qb)=0.7v
.ic v(X_MEM.X_cell_33_3.q)=0v v(X_MEM.X_cell_33_3.qb)=0.7v
.ic v(X_MEM.X_cell_33_4.q)=0v v(X_MEM.X_cell_33_4.qb)=0.7v
.ic v(X_MEM.X_cell_33_5.q)=0v v(X_MEM.X_cell_33_5.qb)=0.7v
.ic v(X_MEM.X_cell_33_6.q)=0v v(X_MEM.X_cell_33_6.qb)=0.7v
.ic v(X_MEM.X_cell_33_7.q)=0v v(X_MEM.X_cell_33_7.qb)=0.7v
.ic v(X_MEM.X_cell_33_8.q)=0v v(X_MEM.X_cell_33_8.qb)=0.7v
.ic v(X_MEM.X_cell_33_9.q)=0v v(X_MEM.X_cell_33_9.qb)=0.7v
.ic v(X_MEM.X_cell_33_10.q)=0v v(X_MEM.X_cell_33_10.qb)=0.7v
.ic v(X_MEM.X_cell_33_11.q)=0v v(X_MEM.X_cell_33_11.qb)=0.7v
.ic v(X_MEM.X_cell_33_12.q)=0v v(X_MEM.X_cell_33_12.qb)=0.7v
.ic v(X_MEM.X_cell_33_13.q)=0v v(X_MEM.X_cell_33_13.qb)=0.7v
.ic v(X_MEM.X_cell_33_14.q)=0v v(X_MEM.X_cell_33_14.qb)=0.7v
.ic v(X_MEM.X_cell_33_15.q)=0v v(X_MEM.X_cell_33_15.qb)=0.7v
.ic v(X_MEM.X_cell_33_16.q)=0v v(X_MEM.X_cell_33_16.qb)=0.7v
.ic v(X_MEM.X_cell_33_17.q)=0v v(X_MEM.X_cell_33_17.qb)=0.7v
.ic v(X_MEM.X_cell_33_18.q)=0v v(X_MEM.X_cell_33_18.qb)=0.7v
.ic v(X_MEM.X_cell_33_19.q)=0v v(X_MEM.X_cell_33_19.qb)=0.7v
.ic v(X_MEM.X_cell_33_20.q)=0v v(X_MEM.X_cell_33_20.qb)=0.7v
.ic v(X_MEM.X_cell_33_21.q)=0v v(X_MEM.X_cell_33_21.qb)=0.7v
.ic v(X_MEM.X_cell_33_22.q)=0v v(X_MEM.X_cell_33_22.qb)=0.7v
.ic v(X_MEM.X_cell_33_23.q)=0v v(X_MEM.X_cell_33_23.qb)=0.7v
.ic v(X_MEM.X_cell_33_24.q)=0v v(X_MEM.X_cell_33_24.qb)=0.7v
.ic v(X_MEM.X_cell_33_25.q)=0v v(X_MEM.X_cell_33_25.qb)=0.7v
.ic v(X_MEM.X_cell_33_26.q)=0v v(X_MEM.X_cell_33_26.qb)=0.7v
.ic v(X_MEM.X_cell_33_27.q)=0v v(X_MEM.X_cell_33_27.qb)=0.7v
.ic v(X_MEM.X_cell_33_28.q)=0v v(X_MEM.X_cell_33_28.qb)=0.7v
.ic v(X_MEM.X_cell_33_29.q)=0v v(X_MEM.X_cell_33_29.qb)=0.7v
.ic v(X_MEM.X_cell_33_30.q)=0v v(X_MEM.X_cell_33_30.qb)=0.7v
.ic v(X_MEM.X_cell_33_31.q)=0v v(X_MEM.X_cell_33_31.qb)=0.7v
.ic v(X_MEM.X_cell_34_0.q)=0v v(X_MEM.X_cell_34_0.qb)=0.7v
.ic v(X_MEM.X_cell_34_1.q)=0v v(X_MEM.X_cell_34_1.qb)=0.7v
.ic v(X_MEM.X_cell_34_2.q)=0v v(X_MEM.X_cell_34_2.qb)=0.7v
.ic v(X_MEM.X_cell_34_3.q)=0v v(X_MEM.X_cell_34_3.qb)=0.7v
.ic v(X_MEM.X_cell_34_4.q)=0v v(X_MEM.X_cell_34_4.qb)=0.7v
.ic v(X_MEM.X_cell_34_5.q)=0v v(X_MEM.X_cell_34_5.qb)=0.7v
.ic v(X_MEM.X_cell_34_6.q)=0v v(X_MEM.X_cell_34_6.qb)=0.7v
.ic v(X_MEM.X_cell_34_7.q)=0v v(X_MEM.X_cell_34_7.qb)=0.7v
.ic v(X_MEM.X_cell_34_8.q)=0v v(X_MEM.X_cell_34_8.qb)=0.7v
.ic v(X_MEM.X_cell_34_9.q)=0v v(X_MEM.X_cell_34_9.qb)=0.7v
.ic v(X_MEM.X_cell_34_10.q)=0v v(X_MEM.X_cell_34_10.qb)=0.7v
.ic v(X_MEM.X_cell_34_11.q)=0v v(X_MEM.X_cell_34_11.qb)=0.7v
.ic v(X_MEM.X_cell_34_12.q)=0v v(X_MEM.X_cell_34_12.qb)=0.7v
.ic v(X_MEM.X_cell_34_13.q)=0v v(X_MEM.X_cell_34_13.qb)=0.7v
.ic v(X_MEM.X_cell_34_14.q)=0v v(X_MEM.X_cell_34_14.qb)=0.7v
.ic v(X_MEM.X_cell_34_15.q)=0v v(X_MEM.X_cell_34_15.qb)=0.7v
.ic v(X_MEM.X_cell_34_16.q)=0v v(X_MEM.X_cell_34_16.qb)=0.7v
.ic v(X_MEM.X_cell_34_17.q)=0v v(X_MEM.X_cell_34_17.qb)=0.7v
.ic v(X_MEM.X_cell_34_18.q)=0v v(X_MEM.X_cell_34_18.qb)=0.7v
.ic v(X_MEM.X_cell_34_19.q)=0v v(X_MEM.X_cell_34_19.qb)=0.7v
.ic v(X_MEM.X_cell_34_20.q)=0v v(X_MEM.X_cell_34_20.qb)=0.7v
.ic v(X_MEM.X_cell_34_21.q)=0v v(X_MEM.X_cell_34_21.qb)=0.7v
.ic v(X_MEM.X_cell_34_22.q)=0v v(X_MEM.X_cell_34_22.qb)=0.7v
.ic v(X_MEM.X_cell_34_23.q)=0v v(X_MEM.X_cell_34_23.qb)=0.7v
.ic v(X_MEM.X_cell_34_24.q)=0v v(X_MEM.X_cell_34_24.qb)=0.7v
.ic v(X_MEM.X_cell_34_25.q)=0v v(X_MEM.X_cell_34_25.qb)=0.7v
.ic v(X_MEM.X_cell_34_26.q)=0v v(X_MEM.X_cell_34_26.qb)=0.7v
.ic v(X_MEM.X_cell_34_27.q)=0v v(X_MEM.X_cell_34_27.qb)=0.7v
.ic v(X_MEM.X_cell_34_28.q)=0v v(X_MEM.X_cell_34_28.qb)=0.7v
.ic v(X_MEM.X_cell_34_29.q)=0v v(X_MEM.X_cell_34_29.qb)=0.7v
.ic v(X_MEM.X_cell_34_30.q)=0v v(X_MEM.X_cell_34_30.qb)=0.7v
.ic v(X_MEM.X_cell_34_31.q)=0v v(X_MEM.X_cell_34_31.qb)=0.7v
.ic v(X_MEM.X_cell_35_0.q)=0v v(X_MEM.X_cell_35_0.qb)=0.7v
.ic v(X_MEM.X_cell_35_1.q)=0v v(X_MEM.X_cell_35_1.qb)=0.7v
.ic v(X_MEM.X_cell_35_2.q)=0v v(X_MEM.X_cell_35_2.qb)=0.7v
.ic v(X_MEM.X_cell_35_3.q)=0v v(X_MEM.X_cell_35_3.qb)=0.7v
.ic v(X_MEM.X_cell_35_4.q)=0v v(X_MEM.X_cell_35_4.qb)=0.7v
.ic v(X_MEM.X_cell_35_5.q)=0v v(X_MEM.X_cell_35_5.qb)=0.7v
.ic v(X_MEM.X_cell_35_6.q)=0v v(X_MEM.X_cell_35_6.qb)=0.7v
.ic v(X_MEM.X_cell_35_7.q)=0v v(X_MEM.X_cell_35_7.qb)=0.7v
.ic v(X_MEM.X_cell_35_8.q)=0v v(X_MEM.X_cell_35_8.qb)=0.7v
.ic v(X_MEM.X_cell_35_9.q)=0v v(X_MEM.X_cell_35_9.qb)=0.7v
.ic v(X_MEM.X_cell_35_10.q)=0v v(X_MEM.X_cell_35_10.qb)=0.7v
.ic v(X_MEM.X_cell_35_11.q)=0v v(X_MEM.X_cell_35_11.qb)=0.7v
.ic v(X_MEM.X_cell_35_12.q)=0v v(X_MEM.X_cell_35_12.qb)=0.7v
.ic v(X_MEM.X_cell_35_13.q)=0v v(X_MEM.X_cell_35_13.qb)=0.7v
.ic v(X_MEM.X_cell_35_14.q)=0v v(X_MEM.X_cell_35_14.qb)=0.7v
.ic v(X_MEM.X_cell_35_15.q)=0v v(X_MEM.X_cell_35_15.qb)=0.7v
.ic v(X_MEM.X_cell_35_16.q)=0v v(X_MEM.X_cell_35_16.qb)=0.7v
.ic v(X_MEM.X_cell_35_17.q)=0v v(X_MEM.X_cell_35_17.qb)=0.7v
.ic v(X_MEM.X_cell_35_18.q)=0v v(X_MEM.X_cell_35_18.qb)=0.7v
.ic v(X_MEM.X_cell_35_19.q)=0v v(X_MEM.X_cell_35_19.qb)=0.7v
.ic v(X_MEM.X_cell_35_20.q)=0v v(X_MEM.X_cell_35_20.qb)=0.7v
.ic v(X_MEM.X_cell_35_21.q)=0v v(X_MEM.X_cell_35_21.qb)=0.7v
.ic v(X_MEM.X_cell_35_22.q)=0v v(X_MEM.X_cell_35_22.qb)=0.7v
.ic v(X_MEM.X_cell_35_23.q)=0v v(X_MEM.X_cell_35_23.qb)=0.7v
.ic v(X_MEM.X_cell_35_24.q)=0v v(X_MEM.X_cell_35_24.qb)=0.7v
.ic v(X_MEM.X_cell_35_25.q)=0v v(X_MEM.X_cell_35_25.qb)=0.7v
.ic v(X_MEM.X_cell_35_26.q)=0v v(X_MEM.X_cell_35_26.qb)=0.7v
.ic v(X_MEM.X_cell_35_27.q)=0v v(X_MEM.X_cell_35_27.qb)=0.7v
.ic v(X_MEM.X_cell_35_28.q)=0v v(X_MEM.X_cell_35_28.qb)=0.7v
.ic v(X_MEM.X_cell_35_29.q)=0v v(X_MEM.X_cell_35_29.qb)=0.7v
.ic v(X_MEM.X_cell_35_30.q)=0v v(X_MEM.X_cell_35_30.qb)=0.7v
.ic v(X_MEM.X_cell_35_31.q)=0v v(X_MEM.X_cell_35_31.qb)=0.7v
.ic v(X_MEM.X_cell_36_0.q)=0v v(X_MEM.X_cell_36_0.qb)=0.7v
.ic v(X_MEM.X_cell_36_1.q)=0v v(X_MEM.X_cell_36_1.qb)=0.7v
.ic v(X_MEM.X_cell_36_2.q)=0v v(X_MEM.X_cell_36_2.qb)=0.7v
.ic v(X_MEM.X_cell_36_3.q)=0v v(X_MEM.X_cell_36_3.qb)=0.7v
.ic v(X_MEM.X_cell_36_4.q)=0v v(X_MEM.X_cell_36_4.qb)=0.7v
.ic v(X_MEM.X_cell_36_5.q)=0v v(X_MEM.X_cell_36_5.qb)=0.7v
.ic v(X_MEM.X_cell_36_6.q)=0v v(X_MEM.X_cell_36_6.qb)=0.7v
.ic v(X_MEM.X_cell_36_7.q)=0v v(X_MEM.X_cell_36_7.qb)=0.7v
.ic v(X_MEM.X_cell_36_8.q)=0v v(X_MEM.X_cell_36_8.qb)=0.7v
.ic v(X_MEM.X_cell_36_9.q)=0v v(X_MEM.X_cell_36_9.qb)=0.7v
.ic v(X_MEM.X_cell_36_10.q)=0v v(X_MEM.X_cell_36_10.qb)=0.7v
.ic v(X_MEM.X_cell_36_11.q)=0v v(X_MEM.X_cell_36_11.qb)=0.7v
.ic v(X_MEM.X_cell_36_12.q)=0v v(X_MEM.X_cell_36_12.qb)=0.7v
.ic v(X_MEM.X_cell_36_13.q)=0v v(X_MEM.X_cell_36_13.qb)=0.7v
.ic v(X_MEM.X_cell_36_14.q)=0v v(X_MEM.X_cell_36_14.qb)=0.7v
.ic v(X_MEM.X_cell_36_15.q)=0v v(X_MEM.X_cell_36_15.qb)=0.7v
.ic v(X_MEM.X_cell_36_16.q)=0v v(X_MEM.X_cell_36_16.qb)=0.7v
.ic v(X_MEM.X_cell_36_17.q)=0v v(X_MEM.X_cell_36_17.qb)=0.7v
.ic v(X_MEM.X_cell_36_18.q)=0v v(X_MEM.X_cell_36_18.qb)=0.7v
.ic v(X_MEM.X_cell_36_19.q)=0v v(X_MEM.X_cell_36_19.qb)=0.7v
.ic v(X_MEM.X_cell_36_20.q)=0v v(X_MEM.X_cell_36_20.qb)=0.7v
.ic v(X_MEM.X_cell_36_21.q)=0v v(X_MEM.X_cell_36_21.qb)=0.7v
.ic v(X_MEM.X_cell_36_22.q)=0v v(X_MEM.X_cell_36_22.qb)=0.7v
.ic v(X_MEM.X_cell_36_23.q)=0v v(X_MEM.X_cell_36_23.qb)=0.7v
.ic v(X_MEM.X_cell_36_24.q)=0v v(X_MEM.X_cell_36_24.qb)=0.7v
.ic v(X_MEM.X_cell_36_25.q)=0v v(X_MEM.X_cell_36_25.qb)=0.7v
.ic v(X_MEM.X_cell_36_26.q)=0v v(X_MEM.X_cell_36_26.qb)=0.7v
.ic v(X_MEM.X_cell_36_27.q)=0v v(X_MEM.X_cell_36_27.qb)=0.7v
.ic v(X_MEM.X_cell_36_28.q)=0v v(X_MEM.X_cell_36_28.qb)=0.7v
.ic v(X_MEM.X_cell_36_29.q)=0v v(X_MEM.X_cell_36_29.qb)=0.7v
.ic v(X_MEM.X_cell_36_30.q)=0v v(X_MEM.X_cell_36_30.qb)=0.7v
.ic v(X_MEM.X_cell_36_31.q)=0v v(X_MEM.X_cell_36_31.qb)=0.7v
.ic v(X_MEM.X_cell_37_0.q)=0v v(X_MEM.X_cell_37_0.qb)=0.7v
.ic v(X_MEM.X_cell_37_1.q)=0v v(X_MEM.X_cell_37_1.qb)=0.7v
.ic v(X_MEM.X_cell_37_2.q)=0v v(X_MEM.X_cell_37_2.qb)=0.7v
.ic v(X_MEM.X_cell_37_3.q)=0v v(X_MEM.X_cell_37_3.qb)=0.7v
.ic v(X_MEM.X_cell_37_4.q)=0v v(X_MEM.X_cell_37_4.qb)=0.7v
.ic v(X_MEM.X_cell_37_5.q)=0v v(X_MEM.X_cell_37_5.qb)=0.7v
.ic v(X_MEM.X_cell_37_6.q)=0v v(X_MEM.X_cell_37_6.qb)=0.7v
.ic v(X_MEM.X_cell_37_7.q)=0v v(X_MEM.X_cell_37_7.qb)=0.7v
.ic v(X_MEM.X_cell_37_8.q)=0v v(X_MEM.X_cell_37_8.qb)=0.7v
.ic v(X_MEM.X_cell_37_9.q)=0v v(X_MEM.X_cell_37_9.qb)=0.7v
.ic v(X_MEM.X_cell_37_10.q)=0v v(X_MEM.X_cell_37_10.qb)=0.7v
.ic v(X_MEM.X_cell_37_11.q)=0v v(X_MEM.X_cell_37_11.qb)=0.7v
.ic v(X_MEM.X_cell_37_12.q)=0v v(X_MEM.X_cell_37_12.qb)=0.7v
.ic v(X_MEM.X_cell_37_13.q)=0v v(X_MEM.X_cell_37_13.qb)=0.7v
.ic v(X_MEM.X_cell_37_14.q)=0v v(X_MEM.X_cell_37_14.qb)=0.7v
.ic v(X_MEM.X_cell_37_15.q)=0v v(X_MEM.X_cell_37_15.qb)=0.7v
.ic v(X_MEM.X_cell_37_16.q)=0v v(X_MEM.X_cell_37_16.qb)=0.7v
.ic v(X_MEM.X_cell_37_17.q)=0v v(X_MEM.X_cell_37_17.qb)=0.7v
.ic v(X_MEM.X_cell_37_18.q)=0v v(X_MEM.X_cell_37_18.qb)=0.7v
.ic v(X_MEM.X_cell_37_19.q)=0v v(X_MEM.X_cell_37_19.qb)=0.7v
.ic v(X_MEM.X_cell_37_20.q)=0v v(X_MEM.X_cell_37_20.qb)=0.7v
.ic v(X_MEM.X_cell_37_21.q)=0v v(X_MEM.X_cell_37_21.qb)=0.7v
.ic v(X_MEM.X_cell_37_22.q)=0v v(X_MEM.X_cell_37_22.qb)=0.7v
.ic v(X_MEM.X_cell_37_23.q)=0v v(X_MEM.X_cell_37_23.qb)=0.7v
.ic v(X_MEM.X_cell_37_24.q)=0v v(X_MEM.X_cell_37_24.qb)=0.7v
.ic v(X_MEM.X_cell_37_25.q)=0v v(X_MEM.X_cell_37_25.qb)=0.7v
.ic v(X_MEM.X_cell_37_26.q)=0v v(X_MEM.X_cell_37_26.qb)=0.7v
.ic v(X_MEM.X_cell_37_27.q)=0v v(X_MEM.X_cell_37_27.qb)=0.7v
.ic v(X_MEM.X_cell_37_28.q)=0v v(X_MEM.X_cell_37_28.qb)=0.7v
.ic v(X_MEM.X_cell_37_29.q)=0v v(X_MEM.X_cell_37_29.qb)=0.7v
.ic v(X_MEM.X_cell_37_30.q)=0v v(X_MEM.X_cell_37_30.qb)=0.7v
.ic v(X_MEM.X_cell_37_31.q)=0v v(X_MEM.X_cell_37_31.qb)=0.7v
.ic v(X_MEM.X_cell_38_0.q)=0v v(X_MEM.X_cell_38_0.qb)=0.7v
.ic v(X_MEM.X_cell_38_1.q)=0v v(X_MEM.X_cell_38_1.qb)=0.7v
.ic v(X_MEM.X_cell_38_2.q)=0v v(X_MEM.X_cell_38_2.qb)=0.7v
.ic v(X_MEM.X_cell_38_3.q)=0v v(X_MEM.X_cell_38_3.qb)=0.7v
.ic v(X_MEM.X_cell_38_4.q)=0v v(X_MEM.X_cell_38_4.qb)=0.7v
.ic v(X_MEM.X_cell_38_5.q)=0v v(X_MEM.X_cell_38_5.qb)=0.7v
.ic v(X_MEM.X_cell_38_6.q)=0v v(X_MEM.X_cell_38_6.qb)=0.7v
.ic v(X_MEM.X_cell_38_7.q)=0v v(X_MEM.X_cell_38_7.qb)=0.7v
.ic v(X_MEM.X_cell_38_8.q)=0v v(X_MEM.X_cell_38_8.qb)=0.7v
.ic v(X_MEM.X_cell_38_9.q)=0v v(X_MEM.X_cell_38_9.qb)=0.7v
.ic v(X_MEM.X_cell_38_10.q)=0v v(X_MEM.X_cell_38_10.qb)=0.7v
.ic v(X_MEM.X_cell_38_11.q)=0v v(X_MEM.X_cell_38_11.qb)=0.7v
.ic v(X_MEM.X_cell_38_12.q)=0v v(X_MEM.X_cell_38_12.qb)=0.7v
.ic v(X_MEM.X_cell_38_13.q)=0v v(X_MEM.X_cell_38_13.qb)=0.7v
.ic v(X_MEM.X_cell_38_14.q)=0v v(X_MEM.X_cell_38_14.qb)=0.7v
.ic v(X_MEM.X_cell_38_15.q)=0v v(X_MEM.X_cell_38_15.qb)=0.7v
.ic v(X_MEM.X_cell_38_16.q)=0v v(X_MEM.X_cell_38_16.qb)=0.7v
.ic v(X_MEM.X_cell_38_17.q)=0v v(X_MEM.X_cell_38_17.qb)=0.7v
.ic v(X_MEM.X_cell_38_18.q)=0v v(X_MEM.X_cell_38_18.qb)=0.7v
.ic v(X_MEM.X_cell_38_19.q)=0v v(X_MEM.X_cell_38_19.qb)=0.7v
.ic v(X_MEM.X_cell_38_20.q)=0v v(X_MEM.X_cell_38_20.qb)=0.7v
.ic v(X_MEM.X_cell_38_21.q)=0v v(X_MEM.X_cell_38_21.qb)=0.7v
.ic v(X_MEM.X_cell_38_22.q)=0v v(X_MEM.X_cell_38_22.qb)=0.7v
.ic v(X_MEM.X_cell_38_23.q)=0v v(X_MEM.X_cell_38_23.qb)=0.7v
.ic v(X_MEM.X_cell_38_24.q)=0v v(X_MEM.X_cell_38_24.qb)=0.7v
.ic v(X_MEM.X_cell_38_25.q)=0v v(X_MEM.X_cell_38_25.qb)=0.7v
.ic v(X_MEM.X_cell_38_26.q)=0v v(X_MEM.X_cell_38_26.qb)=0.7v
.ic v(X_MEM.X_cell_38_27.q)=0v v(X_MEM.X_cell_38_27.qb)=0.7v
.ic v(X_MEM.X_cell_38_28.q)=0v v(X_MEM.X_cell_38_28.qb)=0.7v
.ic v(X_MEM.X_cell_38_29.q)=0v v(X_MEM.X_cell_38_29.qb)=0.7v
.ic v(X_MEM.X_cell_38_30.q)=0v v(X_MEM.X_cell_38_30.qb)=0.7v
.ic v(X_MEM.X_cell_38_31.q)=0v v(X_MEM.X_cell_38_31.qb)=0.7v
.ic v(X_MEM.X_cell_39_0.q)=0v v(X_MEM.X_cell_39_0.qb)=0.7v
.ic v(X_MEM.X_cell_39_1.q)=0v v(X_MEM.X_cell_39_1.qb)=0.7v
.ic v(X_MEM.X_cell_39_2.q)=0v v(X_MEM.X_cell_39_2.qb)=0.7v
.ic v(X_MEM.X_cell_39_3.q)=0v v(X_MEM.X_cell_39_3.qb)=0.7v
.ic v(X_MEM.X_cell_39_4.q)=0v v(X_MEM.X_cell_39_4.qb)=0.7v
.ic v(X_MEM.X_cell_39_5.q)=0v v(X_MEM.X_cell_39_5.qb)=0.7v
.ic v(X_MEM.X_cell_39_6.q)=0v v(X_MEM.X_cell_39_6.qb)=0.7v
.ic v(X_MEM.X_cell_39_7.q)=0v v(X_MEM.X_cell_39_7.qb)=0.7v
.ic v(X_MEM.X_cell_39_8.q)=0v v(X_MEM.X_cell_39_8.qb)=0.7v
.ic v(X_MEM.X_cell_39_9.q)=0v v(X_MEM.X_cell_39_9.qb)=0.7v
.ic v(X_MEM.X_cell_39_10.q)=0v v(X_MEM.X_cell_39_10.qb)=0.7v
.ic v(X_MEM.X_cell_39_11.q)=0v v(X_MEM.X_cell_39_11.qb)=0.7v
.ic v(X_MEM.X_cell_39_12.q)=0v v(X_MEM.X_cell_39_12.qb)=0.7v
.ic v(X_MEM.X_cell_39_13.q)=0v v(X_MEM.X_cell_39_13.qb)=0.7v
.ic v(X_MEM.X_cell_39_14.q)=0v v(X_MEM.X_cell_39_14.qb)=0.7v
.ic v(X_MEM.X_cell_39_15.q)=0v v(X_MEM.X_cell_39_15.qb)=0.7v
.ic v(X_MEM.X_cell_39_16.q)=0v v(X_MEM.X_cell_39_16.qb)=0.7v
.ic v(X_MEM.X_cell_39_17.q)=0v v(X_MEM.X_cell_39_17.qb)=0.7v
.ic v(X_MEM.X_cell_39_18.q)=0v v(X_MEM.X_cell_39_18.qb)=0.7v
.ic v(X_MEM.X_cell_39_19.q)=0v v(X_MEM.X_cell_39_19.qb)=0.7v
.ic v(X_MEM.X_cell_39_20.q)=0v v(X_MEM.X_cell_39_20.qb)=0.7v
.ic v(X_MEM.X_cell_39_21.q)=0v v(X_MEM.X_cell_39_21.qb)=0.7v
.ic v(X_MEM.X_cell_39_22.q)=0v v(X_MEM.X_cell_39_22.qb)=0.7v
.ic v(X_MEM.X_cell_39_23.q)=0v v(X_MEM.X_cell_39_23.qb)=0.7v
.ic v(X_MEM.X_cell_39_24.q)=0v v(X_MEM.X_cell_39_24.qb)=0.7v
.ic v(X_MEM.X_cell_39_25.q)=0v v(X_MEM.X_cell_39_25.qb)=0.7v
.ic v(X_MEM.X_cell_39_26.q)=0v v(X_MEM.X_cell_39_26.qb)=0.7v
.ic v(X_MEM.X_cell_39_27.q)=0v v(X_MEM.X_cell_39_27.qb)=0.7v
.ic v(X_MEM.X_cell_39_28.q)=0v v(X_MEM.X_cell_39_28.qb)=0.7v
.ic v(X_MEM.X_cell_39_29.q)=0v v(X_MEM.X_cell_39_29.qb)=0.7v
.ic v(X_MEM.X_cell_39_30.q)=0v v(X_MEM.X_cell_39_30.qb)=0.7v
.ic v(X_MEM.X_cell_39_31.q)=0v v(X_MEM.X_cell_39_31.qb)=0.7v
.ic v(X_MEM.X_cell_40_0.q)=0v v(X_MEM.X_cell_40_0.qb)=0.7v
.ic v(X_MEM.X_cell_40_1.q)=0v v(X_MEM.X_cell_40_1.qb)=0.7v
.ic v(X_MEM.X_cell_40_2.q)=0v v(X_MEM.X_cell_40_2.qb)=0.7v
.ic v(X_MEM.X_cell_40_3.q)=0v v(X_MEM.X_cell_40_3.qb)=0.7v
.ic v(X_MEM.X_cell_40_4.q)=0v v(X_MEM.X_cell_40_4.qb)=0.7v
.ic v(X_MEM.X_cell_40_5.q)=0v v(X_MEM.X_cell_40_5.qb)=0.7v
.ic v(X_MEM.X_cell_40_6.q)=0v v(X_MEM.X_cell_40_6.qb)=0.7v
.ic v(X_MEM.X_cell_40_7.q)=0v v(X_MEM.X_cell_40_7.qb)=0.7v
.ic v(X_MEM.X_cell_40_8.q)=0v v(X_MEM.X_cell_40_8.qb)=0.7v
.ic v(X_MEM.X_cell_40_9.q)=0v v(X_MEM.X_cell_40_9.qb)=0.7v
.ic v(X_MEM.X_cell_40_10.q)=0v v(X_MEM.X_cell_40_10.qb)=0.7v
.ic v(X_MEM.X_cell_40_11.q)=0v v(X_MEM.X_cell_40_11.qb)=0.7v
.ic v(X_MEM.X_cell_40_12.q)=0v v(X_MEM.X_cell_40_12.qb)=0.7v
.ic v(X_MEM.X_cell_40_13.q)=0v v(X_MEM.X_cell_40_13.qb)=0.7v
.ic v(X_MEM.X_cell_40_14.q)=0v v(X_MEM.X_cell_40_14.qb)=0.7v
.ic v(X_MEM.X_cell_40_15.q)=0v v(X_MEM.X_cell_40_15.qb)=0.7v
.ic v(X_MEM.X_cell_40_16.q)=0v v(X_MEM.X_cell_40_16.qb)=0.7v
.ic v(X_MEM.X_cell_40_17.q)=0v v(X_MEM.X_cell_40_17.qb)=0.7v
.ic v(X_MEM.X_cell_40_18.q)=0v v(X_MEM.X_cell_40_18.qb)=0.7v
.ic v(X_MEM.X_cell_40_19.q)=0v v(X_MEM.X_cell_40_19.qb)=0.7v
.ic v(X_MEM.X_cell_40_20.q)=0v v(X_MEM.X_cell_40_20.qb)=0.7v
.ic v(X_MEM.X_cell_40_21.q)=0v v(X_MEM.X_cell_40_21.qb)=0.7v
.ic v(X_MEM.X_cell_40_22.q)=0v v(X_MEM.X_cell_40_22.qb)=0.7v
.ic v(X_MEM.X_cell_40_23.q)=0v v(X_MEM.X_cell_40_23.qb)=0.7v
.ic v(X_MEM.X_cell_40_24.q)=0v v(X_MEM.X_cell_40_24.qb)=0.7v
.ic v(X_MEM.X_cell_40_25.q)=0v v(X_MEM.X_cell_40_25.qb)=0.7v
.ic v(X_MEM.X_cell_40_26.q)=0v v(X_MEM.X_cell_40_26.qb)=0.7v
.ic v(X_MEM.X_cell_40_27.q)=0v v(X_MEM.X_cell_40_27.qb)=0.7v
.ic v(X_MEM.X_cell_40_28.q)=0v v(X_MEM.X_cell_40_28.qb)=0.7v
.ic v(X_MEM.X_cell_40_29.q)=0v v(X_MEM.X_cell_40_29.qb)=0.7v
.ic v(X_MEM.X_cell_40_30.q)=0v v(X_MEM.X_cell_40_30.qb)=0.7v
.ic v(X_MEM.X_cell_40_31.q)=0v v(X_MEM.X_cell_40_31.qb)=0.7v
.ic v(X_MEM.X_cell_41_0.q)=0v v(X_MEM.X_cell_41_0.qb)=0.7v
.ic v(X_MEM.X_cell_41_1.q)=0v v(X_MEM.X_cell_41_1.qb)=0.7v
.ic v(X_MEM.X_cell_41_2.q)=0v v(X_MEM.X_cell_41_2.qb)=0.7v
.ic v(X_MEM.X_cell_41_3.q)=0v v(X_MEM.X_cell_41_3.qb)=0.7v
.ic v(X_MEM.X_cell_41_4.q)=0v v(X_MEM.X_cell_41_4.qb)=0.7v
.ic v(X_MEM.X_cell_41_5.q)=0v v(X_MEM.X_cell_41_5.qb)=0.7v
.ic v(X_MEM.X_cell_41_6.q)=0v v(X_MEM.X_cell_41_6.qb)=0.7v
.ic v(X_MEM.X_cell_41_7.q)=0v v(X_MEM.X_cell_41_7.qb)=0.7v
.ic v(X_MEM.X_cell_41_8.q)=0v v(X_MEM.X_cell_41_8.qb)=0.7v
.ic v(X_MEM.X_cell_41_9.q)=0v v(X_MEM.X_cell_41_9.qb)=0.7v
.ic v(X_MEM.X_cell_41_10.q)=0v v(X_MEM.X_cell_41_10.qb)=0.7v
.ic v(X_MEM.X_cell_41_11.q)=0v v(X_MEM.X_cell_41_11.qb)=0.7v
.ic v(X_MEM.X_cell_41_12.q)=0v v(X_MEM.X_cell_41_12.qb)=0.7v
.ic v(X_MEM.X_cell_41_13.q)=0v v(X_MEM.X_cell_41_13.qb)=0.7v
.ic v(X_MEM.X_cell_41_14.q)=0v v(X_MEM.X_cell_41_14.qb)=0.7v
.ic v(X_MEM.X_cell_41_15.q)=0v v(X_MEM.X_cell_41_15.qb)=0.7v
.ic v(X_MEM.X_cell_41_16.q)=0v v(X_MEM.X_cell_41_16.qb)=0.7v
.ic v(X_MEM.X_cell_41_17.q)=0v v(X_MEM.X_cell_41_17.qb)=0.7v
.ic v(X_MEM.X_cell_41_18.q)=0v v(X_MEM.X_cell_41_18.qb)=0.7v
.ic v(X_MEM.X_cell_41_19.q)=0v v(X_MEM.X_cell_41_19.qb)=0.7v
.ic v(X_MEM.X_cell_41_20.q)=0v v(X_MEM.X_cell_41_20.qb)=0.7v
.ic v(X_MEM.X_cell_41_21.q)=0v v(X_MEM.X_cell_41_21.qb)=0.7v
.ic v(X_MEM.X_cell_41_22.q)=0v v(X_MEM.X_cell_41_22.qb)=0.7v
.ic v(X_MEM.X_cell_41_23.q)=0v v(X_MEM.X_cell_41_23.qb)=0.7v
.ic v(X_MEM.X_cell_41_24.q)=0v v(X_MEM.X_cell_41_24.qb)=0.7v
.ic v(X_MEM.X_cell_41_25.q)=0v v(X_MEM.X_cell_41_25.qb)=0.7v
.ic v(X_MEM.X_cell_41_26.q)=0v v(X_MEM.X_cell_41_26.qb)=0.7v
.ic v(X_MEM.X_cell_41_27.q)=0v v(X_MEM.X_cell_41_27.qb)=0.7v
.ic v(X_MEM.X_cell_41_28.q)=0v v(X_MEM.X_cell_41_28.qb)=0.7v
.ic v(X_MEM.X_cell_41_29.q)=0v v(X_MEM.X_cell_41_29.qb)=0.7v
.ic v(X_MEM.X_cell_41_30.q)=0v v(X_MEM.X_cell_41_30.qb)=0.7v
.ic v(X_MEM.X_cell_41_31.q)=0v v(X_MEM.X_cell_41_31.qb)=0.7v
.ic v(X_MEM.X_cell_42_0.q)=0v v(X_MEM.X_cell_42_0.qb)=0.7v
.ic v(X_MEM.X_cell_42_1.q)=0v v(X_MEM.X_cell_42_1.qb)=0.7v
.ic v(X_MEM.X_cell_42_2.q)=0v v(X_MEM.X_cell_42_2.qb)=0.7v
.ic v(X_MEM.X_cell_42_3.q)=0v v(X_MEM.X_cell_42_3.qb)=0.7v
.ic v(X_MEM.X_cell_42_4.q)=0v v(X_MEM.X_cell_42_4.qb)=0.7v
.ic v(X_MEM.X_cell_42_5.q)=0v v(X_MEM.X_cell_42_5.qb)=0.7v
.ic v(X_MEM.X_cell_42_6.q)=0v v(X_MEM.X_cell_42_6.qb)=0.7v
.ic v(X_MEM.X_cell_42_7.q)=0v v(X_MEM.X_cell_42_7.qb)=0.7v
.ic v(X_MEM.X_cell_42_8.q)=0v v(X_MEM.X_cell_42_8.qb)=0.7v
.ic v(X_MEM.X_cell_42_9.q)=0v v(X_MEM.X_cell_42_9.qb)=0.7v
.ic v(X_MEM.X_cell_42_10.q)=0v v(X_MEM.X_cell_42_10.qb)=0.7v
.ic v(X_MEM.X_cell_42_11.q)=0v v(X_MEM.X_cell_42_11.qb)=0.7v
.ic v(X_MEM.X_cell_42_12.q)=0v v(X_MEM.X_cell_42_12.qb)=0.7v
.ic v(X_MEM.X_cell_42_13.q)=0v v(X_MEM.X_cell_42_13.qb)=0.7v
.ic v(X_MEM.X_cell_42_14.q)=0v v(X_MEM.X_cell_42_14.qb)=0.7v
.ic v(X_MEM.X_cell_42_15.q)=0v v(X_MEM.X_cell_42_15.qb)=0.7v
.ic v(X_MEM.X_cell_42_16.q)=0v v(X_MEM.X_cell_42_16.qb)=0.7v
.ic v(X_MEM.X_cell_42_17.q)=0v v(X_MEM.X_cell_42_17.qb)=0.7v
.ic v(X_MEM.X_cell_42_18.q)=0v v(X_MEM.X_cell_42_18.qb)=0.7v
.ic v(X_MEM.X_cell_42_19.q)=0v v(X_MEM.X_cell_42_19.qb)=0.7v
.ic v(X_MEM.X_cell_42_20.q)=0v v(X_MEM.X_cell_42_20.qb)=0.7v
.ic v(X_MEM.X_cell_42_21.q)=0v v(X_MEM.X_cell_42_21.qb)=0.7v
.ic v(X_MEM.X_cell_42_22.q)=0v v(X_MEM.X_cell_42_22.qb)=0.7v
.ic v(X_MEM.X_cell_42_23.q)=0v v(X_MEM.X_cell_42_23.qb)=0.7v
.ic v(X_MEM.X_cell_42_24.q)=0v v(X_MEM.X_cell_42_24.qb)=0.7v
.ic v(X_MEM.X_cell_42_25.q)=0v v(X_MEM.X_cell_42_25.qb)=0.7v
.ic v(X_MEM.X_cell_42_26.q)=0v v(X_MEM.X_cell_42_26.qb)=0.7v
.ic v(X_MEM.X_cell_42_27.q)=0v v(X_MEM.X_cell_42_27.qb)=0.7v
.ic v(X_MEM.X_cell_42_28.q)=0v v(X_MEM.X_cell_42_28.qb)=0.7v
.ic v(X_MEM.X_cell_42_29.q)=0v v(X_MEM.X_cell_42_29.qb)=0.7v
.ic v(X_MEM.X_cell_42_30.q)=0v v(X_MEM.X_cell_42_30.qb)=0.7v
.ic v(X_MEM.X_cell_42_31.q)=0v v(X_MEM.X_cell_42_31.qb)=0.7v
.ic v(X_MEM.X_cell_43_0.q)=0v v(X_MEM.X_cell_43_0.qb)=0.7v
.ic v(X_MEM.X_cell_43_1.q)=0v v(X_MEM.X_cell_43_1.qb)=0.7v
.ic v(X_MEM.X_cell_43_2.q)=0v v(X_MEM.X_cell_43_2.qb)=0.7v
.ic v(X_MEM.X_cell_43_3.q)=0v v(X_MEM.X_cell_43_3.qb)=0.7v
.ic v(X_MEM.X_cell_43_4.q)=0v v(X_MEM.X_cell_43_4.qb)=0.7v
.ic v(X_MEM.X_cell_43_5.q)=0v v(X_MEM.X_cell_43_5.qb)=0.7v
.ic v(X_MEM.X_cell_43_6.q)=0v v(X_MEM.X_cell_43_6.qb)=0.7v
.ic v(X_MEM.X_cell_43_7.q)=0v v(X_MEM.X_cell_43_7.qb)=0.7v
.ic v(X_MEM.X_cell_43_8.q)=0v v(X_MEM.X_cell_43_8.qb)=0.7v
.ic v(X_MEM.X_cell_43_9.q)=0v v(X_MEM.X_cell_43_9.qb)=0.7v
.ic v(X_MEM.X_cell_43_10.q)=0v v(X_MEM.X_cell_43_10.qb)=0.7v
.ic v(X_MEM.X_cell_43_11.q)=0v v(X_MEM.X_cell_43_11.qb)=0.7v
.ic v(X_MEM.X_cell_43_12.q)=0v v(X_MEM.X_cell_43_12.qb)=0.7v
.ic v(X_MEM.X_cell_43_13.q)=0v v(X_MEM.X_cell_43_13.qb)=0.7v
.ic v(X_MEM.X_cell_43_14.q)=0v v(X_MEM.X_cell_43_14.qb)=0.7v
.ic v(X_MEM.X_cell_43_15.q)=0v v(X_MEM.X_cell_43_15.qb)=0.7v
.ic v(X_MEM.X_cell_43_16.q)=0v v(X_MEM.X_cell_43_16.qb)=0.7v
.ic v(X_MEM.X_cell_43_17.q)=0v v(X_MEM.X_cell_43_17.qb)=0.7v
.ic v(X_MEM.X_cell_43_18.q)=0v v(X_MEM.X_cell_43_18.qb)=0.7v
.ic v(X_MEM.X_cell_43_19.q)=0v v(X_MEM.X_cell_43_19.qb)=0.7v
.ic v(X_MEM.X_cell_43_20.q)=0v v(X_MEM.X_cell_43_20.qb)=0.7v
.ic v(X_MEM.X_cell_43_21.q)=0v v(X_MEM.X_cell_43_21.qb)=0.7v
.ic v(X_MEM.X_cell_43_22.q)=0v v(X_MEM.X_cell_43_22.qb)=0.7v
.ic v(X_MEM.X_cell_43_23.q)=0v v(X_MEM.X_cell_43_23.qb)=0.7v
.ic v(X_MEM.X_cell_43_24.q)=0v v(X_MEM.X_cell_43_24.qb)=0.7v
.ic v(X_MEM.X_cell_43_25.q)=0v v(X_MEM.X_cell_43_25.qb)=0.7v
.ic v(X_MEM.X_cell_43_26.q)=0v v(X_MEM.X_cell_43_26.qb)=0.7v
.ic v(X_MEM.X_cell_43_27.q)=0v v(X_MEM.X_cell_43_27.qb)=0.7v
.ic v(X_MEM.X_cell_43_28.q)=0v v(X_MEM.X_cell_43_28.qb)=0.7v
.ic v(X_MEM.X_cell_43_29.q)=0v v(X_MEM.X_cell_43_29.qb)=0.7v
.ic v(X_MEM.X_cell_43_30.q)=0v v(X_MEM.X_cell_43_30.qb)=0.7v
.ic v(X_MEM.X_cell_43_31.q)=0v v(X_MEM.X_cell_43_31.qb)=0.7v
.ic v(X_MEM.X_cell_44_0.q)=0v v(X_MEM.X_cell_44_0.qb)=0.7v
.ic v(X_MEM.X_cell_44_1.q)=0v v(X_MEM.X_cell_44_1.qb)=0.7v
.ic v(X_MEM.X_cell_44_2.q)=0v v(X_MEM.X_cell_44_2.qb)=0.7v
.ic v(X_MEM.X_cell_44_3.q)=0v v(X_MEM.X_cell_44_3.qb)=0.7v
.ic v(X_MEM.X_cell_44_4.q)=0v v(X_MEM.X_cell_44_4.qb)=0.7v
.ic v(X_MEM.X_cell_44_5.q)=0v v(X_MEM.X_cell_44_5.qb)=0.7v
.ic v(X_MEM.X_cell_44_6.q)=0v v(X_MEM.X_cell_44_6.qb)=0.7v
.ic v(X_MEM.X_cell_44_7.q)=0v v(X_MEM.X_cell_44_7.qb)=0.7v
.ic v(X_MEM.X_cell_44_8.q)=0v v(X_MEM.X_cell_44_8.qb)=0.7v
.ic v(X_MEM.X_cell_44_9.q)=0v v(X_MEM.X_cell_44_9.qb)=0.7v
.ic v(X_MEM.X_cell_44_10.q)=0v v(X_MEM.X_cell_44_10.qb)=0.7v
.ic v(X_MEM.X_cell_44_11.q)=0v v(X_MEM.X_cell_44_11.qb)=0.7v
.ic v(X_MEM.X_cell_44_12.q)=0v v(X_MEM.X_cell_44_12.qb)=0.7v
.ic v(X_MEM.X_cell_44_13.q)=0v v(X_MEM.X_cell_44_13.qb)=0.7v
.ic v(X_MEM.X_cell_44_14.q)=0v v(X_MEM.X_cell_44_14.qb)=0.7v
.ic v(X_MEM.X_cell_44_15.q)=0v v(X_MEM.X_cell_44_15.qb)=0.7v
.ic v(X_MEM.X_cell_44_16.q)=0v v(X_MEM.X_cell_44_16.qb)=0.7v
.ic v(X_MEM.X_cell_44_17.q)=0v v(X_MEM.X_cell_44_17.qb)=0.7v
.ic v(X_MEM.X_cell_44_18.q)=0v v(X_MEM.X_cell_44_18.qb)=0.7v
.ic v(X_MEM.X_cell_44_19.q)=0v v(X_MEM.X_cell_44_19.qb)=0.7v
.ic v(X_MEM.X_cell_44_20.q)=0v v(X_MEM.X_cell_44_20.qb)=0.7v
.ic v(X_MEM.X_cell_44_21.q)=0v v(X_MEM.X_cell_44_21.qb)=0.7v
.ic v(X_MEM.X_cell_44_22.q)=0v v(X_MEM.X_cell_44_22.qb)=0.7v
.ic v(X_MEM.X_cell_44_23.q)=0v v(X_MEM.X_cell_44_23.qb)=0.7v
.ic v(X_MEM.X_cell_44_24.q)=0v v(X_MEM.X_cell_44_24.qb)=0.7v
.ic v(X_MEM.X_cell_44_25.q)=0v v(X_MEM.X_cell_44_25.qb)=0.7v
.ic v(X_MEM.X_cell_44_26.q)=0v v(X_MEM.X_cell_44_26.qb)=0.7v
.ic v(X_MEM.X_cell_44_27.q)=0v v(X_MEM.X_cell_44_27.qb)=0.7v
.ic v(X_MEM.X_cell_44_28.q)=0v v(X_MEM.X_cell_44_28.qb)=0.7v
.ic v(X_MEM.X_cell_44_29.q)=0v v(X_MEM.X_cell_44_29.qb)=0.7v
.ic v(X_MEM.X_cell_44_30.q)=0v v(X_MEM.X_cell_44_30.qb)=0.7v
.ic v(X_MEM.X_cell_44_31.q)=0v v(X_MEM.X_cell_44_31.qb)=0.7v
.ic v(X_MEM.X_cell_45_0.q)=0v v(X_MEM.X_cell_45_0.qb)=0.7v
.ic v(X_MEM.X_cell_45_1.q)=0v v(X_MEM.X_cell_45_1.qb)=0.7v
.ic v(X_MEM.X_cell_45_2.q)=0v v(X_MEM.X_cell_45_2.qb)=0.7v
.ic v(X_MEM.X_cell_45_3.q)=0v v(X_MEM.X_cell_45_3.qb)=0.7v
.ic v(X_MEM.X_cell_45_4.q)=0v v(X_MEM.X_cell_45_4.qb)=0.7v
.ic v(X_MEM.X_cell_45_5.q)=0v v(X_MEM.X_cell_45_5.qb)=0.7v
.ic v(X_MEM.X_cell_45_6.q)=0v v(X_MEM.X_cell_45_6.qb)=0.7v
.ic v(X_MEM.X_cell_45_7.q)=0v v(X_MEM.X_cell_45_7.qb)=0.7v
.ic v(X_MEM.X_cell_45_8.q)=0v v(X_MEM.X_cell_45_8.qb)=0.7v
.ic v(X_MEM.X_cell_45_9.q)=0v v(X_MEM.X_cell_45_9.qb)=0.7v
.ic v(X_MEM.X_cell_45_10.q)=0v v(X_MEM.X_cell_45_10.qb)=0.7v
.ic v(X_MEM.X_cell_45_11.q)=0v v(X_MEM.X_cell_45_11.qb)=0.7v
.ic v(X_MEM.X_cell_45_12.q)=0v v(X_MEM.X_cell_45_12.qb)=0.7v
.ic v(X_MEM.X_cell_45_13.q)=0v v(X_MEM.X_cell_45_13.qb)=0.7v
.ic v(X_MEM.X_cell_45_14.q)=0v v(X_MEM.X_cell_45_14.qb)=0.7v
.ic v(X_MEM.X_cell_45_15.q)=0v v(X_MEM.X_cell_45_15.qb)=0.7v
.ic v(X_MEM.X_cell_45_16.q)=0v v(X_MEM.X_cell_45_16.qb)=0.7v
.ic v(X_MEM.X_cell_45_17.q)=0v v(X_MEM.X_cell_45_17.qb)=0.7v
.ic v(X_MEM.X_cell_45_18.q)=0v v(X_MEM.X_cell_45_18.qb)=0.7v
.ic v(X_MEM.X_cell_45_19.q)=0v v(X_MEM.X_cell_45_19.qb)=0.7v
.ic v(X_MEM.X_cell_45_20.q)=0v v(X_MEM.X_cell_45_20.qb)=0.7v
.ic v(X_MEM.X_cell_45_21.q)=0v v(X_MEM.X_cell_45_21.qb)=0.7v
.ic v(X_MEM.X_cell_45_22.q)=0v v(X_MEM.X_cell_45_22.qb)=0.7v
.ic v(X_MEM.X_cell_45_23.q)=0v v(X_MEM.X_cell_45_23.qb)=0.7v
.ic v(X_MEM.X_cell_45_24.q)=0v v(X_MEM.X_cell_45_24.qb)=0.7v
.ic v(X_MEM.X_cell_45_25.q)=0v v(X_MEM.X_cell_45_25.qb)=0.7v
.ic v(X_MEM.X_cell_45_26.q)=0v v(X_MEM.X_cell_45_26.qb)=0.7v
.ic v(X_MEM.X_cell_45_27.q)=0v v(X_MEM.X_cell_45_27.qb)=0.7v
.ic v(X_MEM.X_cell_45_28.q)=0v v(X_MEM.X_cell_45_28.qb)=0.7v
.ic v(X_MEM.X_cell_45_29.q)=0v v(X_MEM.X_cell_45_29.qb)=0.7v
.ic v(X_MEM.X_cell_45_30.q)=0v v(X_MEM.X_cell_45_30.qb)=0.7v
.ic v(X_MEM.X_cell_45_31.q)=0v v(X_MEM.X_cell_45_31.qb)=0.7v
.ic v(X_MEM.X_cell_46_0.q)=0v v(X_MEM.X_cell_46_0.qb)=0.7v
.ic v(X_MEM.X_cell_46_1.q)=0v v(X_MEM.X_cell_46_1.qb)=0.7v
.ic v(X_MEM.X_cell_46_2.q)=0v v(X_MEM.X_cell_46_2.qb)=0.7v
.ic v(X_MEM.X_cell_46_3.q)=0v v(X_MEM.X_cell_46_3.qb)=0.7v
.ic v(X_MEM.X_cell_46_4.q)=0v v(X_MEM.X_cell_46_4.qb)=0.7v
.ic v(X_MEM.X_cell_46_5.q)=0v v(X_MEM.X_cell_46_5.qb)=0.7v
.ic v(X_MEM.X_cell_46_6.q)=0v v(X_MEM.X_cell_46_6.qb)=0.7v
.ic v(X_MEM.X_cell_46_7.q)=0v v(X_MEM.X_cell_46_7.qb)=0.7v
.ic v(X_MEM.X_cell_46_8.q)=0v v(X_MEM.X_cell_46_8.qb)=0.7v
.ic v(X_MEM.X_cell_46_9.q)=0v v(X_MEM.X_cell_46_9.qb)=0.7v
.ic v(X_MEM.X_cell_46_10.q)=0v v(X_MEM.X_cell_46_10.qb)=0.7v
.ic v(X_MEM.X_cell_46_11.q)=0v v(X_MEM.X_cell_46_11.qb)=0.7v
.ic v(X_MEM.X_cell_46_12.q)=0v v(X_MEM.X_cell_46_12.qb)=0.7v
.ic v(X_MEM.X_cell_46_13.q)=0v v(X_MEM.X_cell_46_13.qb)=0.7v
.ic v(X_MEM.X_cell_46_14.q)=0v v(X_MEM.X_cell_46_14.qb)=0.7v
.ic v(X_MEM.X_cell_46_15.q)=0v v(X_MEM.X_cell_46_15.qb)=0.7v
.ic v(X_MEM.X_cell_46_16.q)=0v v(X_MEM.X_cell_46_16.qb)=0.7v
.ic v(X_MEM.X_cell_46_17.q)=0v v(X_MEM.X_cell_46_17.qb)=0.7v
.ic v(X_MEM.X_cell_46_18.q)=0v v(X_MEM.X_cell_46_18.qb)=0.7v
.ic v(X_MEM.X_cell_46_19.q)=0v v(X_MEM.X_cell_46_19.qb)=0.7v
.ic v(X_MEM.X_cell_46_20.q)=0v v(X_MEM.X_cell_46_20.qb)=0.7v
.ic v(X_MEM.X_cell_46_21.q)=0v v(X_MEM.X_cell_46_21.qb)=0.7v
.ic v(X_MEM.X_cell_46_22.q)=0v v(X_MEM.X_cell_46_22.qb)=0.7v
.ic v(X_MEM.X_cell_46_23.q)=0v v(X_MEM.X_cell_46_23.qb)=0.7v
.ic v(X_MEM.X_cell_46_24.q)=0v v(X_MEM.X_cell_46_24.qb)=0.7v
.ic v(X_MEM.X_cell_46_25.q)=0v v(X_MEM.X_cell_46_25.qb)=0.7v
.ic v(X_MEM.X_cell_46_26.q)=0v v(X_MEM.X_cell_46_26.qb)=0.7v
.ic v(X_MEM.X_cell_46_27.q)=0v v(X_MEM.X_cell_46_27.qb)=0.7v
.ic v(X_MEM.X_cell_46_28.q)=0v v(X_MEM.X_cell_46_28.qb)=0.7v
.ic v(X_MEM.X_cell_46_29.q)=0v v(X_MEM.X_cell_46_29.qb)=0.7v
.ic v(X_MEM.X_cell_46_30.q)=0v v(X_MEM.X_cell_46_30.qb)=0.7v
.ic v(X_MEM.X_cell_46_31.q)=0v v(X_MEM.X_cell_46_31.qb)=0.7v
.ic v(X_MEM.X_cell_47_0.q)=0v v(X_MEM.X_cell_47_0.qb)=0.7v
.ic v(X_MEM.X_cell_47_1.q)=0v v(X_MEM.X_cell_47_1.qb)=0.7v
.ic v(X_MEM.X_cell_47_2.q)=0v v(X_MEM.X_cell_47_2.qb)=0.7v
.ic v(X_MEM.X_cell_47_3.q)=0v v(X_MEM.X_cell_47_3.qb)=0.7v
.ic v(X_MEM.X_cell_47_4.q)=0v v(X_MEM.X_cell_47_4.qb)=0.7v
.ic v(X_MEM.X_cell_47_5.q)=0v v(X_MEM.X_cell_47_5.qb)=0.7v
.ic v(X_MEM.X_cell_47_6.q)=0v v(X_MEM.X_cell_47_6.qb)=0.7v
.ic v(X_MEM.X_cell_47_7.q)=0v v(X_MEM.X_cell_47_7.qb)=0.7v
.ic v(X_MEM.X_cell_47_8.q)=0v v(X_MEM.X_cell_47_8.qb)=0.7v
.ic v(X_MEM.X_cell_47_9.q)=0v v(X_MEM.X_cell_47_9.qb)=0.7v
.ic v(X_MEM.X_cell_47_10.q)=0v v(X_MEM.X_cell_47_10.qb)=0.7v
.ic v(X_MEM.X_cell_47_11.q)=0v v(X_MEM.X_cell_47_11.qb)=0.7v
.ic v(X_MEM.X_cell_47_12.q)=0v v(X_MEM.X_cell_47_12.qb)=0.7v
.ic v(X_MEM.X_cell_47_13.q)=0v v(X_MEM.X_cell_47_13.qb)=0.7v
.ic v(X_MEM.X_cell_47_14.q)=0v v(X_MEM.X_cell_47_14.qb)=0.7v
.ic v(X_MEM.X_cell_47_15.q)=0v v(X_MEM.X_cell_47_15.qb)=0.7v
.ic v(X_MEM.X_cell_47_16.q)=0v v(X_MEM.X_cell_47_16.qb)=0.7v
.ic v(X_MEM.X_cell_47_17.q)=0v v(X_MEM.X_cell_47_17.qb)=0.7v
.ic v(X_MEM.X_cell_47_18.q)=0v v(X_MEM.X_cell_47_18.qb)=0.7v
.ic v(X_MEM.X_cell_47_19.q)=0v v(X_MEM.X_cell_47_19.qb)=0.7v
.ic v(X_MEM.X_cell_47_20.q)=0v v(X_MEM.X_cell_47_20.qb)=0.7v
.ic v(X_MEM.X_cell_47_21.q)=0v v(X_MEM.X_cell_47_21.qb)=0.7v
.ic v(X_MEM.X_cell_47_22.q)=0v v(X_MEM.X_cell_47_22.qb)=0.7v
.ic v(X_MEM.X_cell_47_23.q)=0v v(X_MEM.X_cell_47_23.qb)=0.7v
.ic v(X_MEM.X_cell_47_24.q)=0v v(X_MEM.X_cell_47_24.qb)=0.7v
.ic v(X_MEM.X_cell_47_25.q)=0v v(X_MEM.X_cell_47_25.qb)=0.7v
.ic v(X_MEM.X_cell_47_26.q)=0v v(X_MEM.X_cell_47_26.qb)=0.7v
.ic v(X_MEM.X_cell_47_27.q)=0v v(X_MEM.X_cell_47_27.qb)=0.7v
.ic v(X_MEM.X_cell_47_28.q)=0v v(X_MEM.X_cell_47_28.qb)=0.7v
.ic v(X_MEM.X_cell_47_29.q)=0v v(X_MEM.X_cell_47_29.qb)=0.7v
.ic v(X_MEM.X_cell_47_30.q)=0v v(X_MEM.X_cell_47_30.qb)=0.7v
.ic v(X_MEM.X_cell_47_31.q)=0v v(X_MEM.X_cell_47_31.qb)=0.7v
.ic v(X_MEM.X_cell_48_0.q)=0v v(X_MEM.X_cell_48_0.qb)=0.7v
.ic v(X_MEM.X_cell_48_1.q)=0v v(X_MEM.X_cell_48_1.qb)=0.7v
.ic v(X_MEM.X_cell_48_2.q)=0v v(X_MEM.X_cell_48_2.qb)=0.7v
.ic v(X_MEM.X_cell_48_3.q)=0v v(X_MEM.X_cell_48_3.qb)=0.7v
.ic v(X_MEM.X_cell_48_4.q)=0v v(X_MEM.X_cell_48_4.qb)=0.7v
.ic v(X_MEM.X_cell_48_5.q)=0v v(X_MEM.X_cell_48_5.qb)=0.7v
.ic v(X_MEM.X_cell_48_6.q)=0v v(X_MEM.X_cell_48_6.qb)=0.7v
.ic v(X_MEM.X_cell_48_7.q)=0v v(X_MEM.X_cell_48_7.qb)=0.7v
.ic v(X_MEM.X_cell_48_8.q)=0v v(X_MEM.X_cell_48_8.qb)=0.7v
.ic v(X_MEM.X_cell_48_9.q)=0v v(X_MEM.X_cell_48_9.qb)=0.7v
.ic v(X_MEM.X_cell_48_10.q)=0v v(X_MEM.X_cell_48_10.qb)=0.7v
.ic v(X_MEM.X_cell_48_11.q)=0v v(X_MEM.X_cell_48_11.qb)=0.7v
.ic v(X_MEM.X_cell_48_12.q)=0v v(X_MEM.X_cell_48_12.qb)=0.7v
.ic v(X_MEM.X_cell_48_13.q)=0v v(X_MEM.X_cell_48_13.qb)=0.7v
.ic v(X_MEM.X_cell_48_14.q)=0v v(X_MEM.X_cell_48_14.qb)=0.7v
.ic v(X_MEM.X_cell_48_15.q)=0v v(X_MEM.X_cell_48_15.qb)=0.7v
.ic v(X_MEM.X_cell_48_16.q)=0v v(X_MEM.X_cell_48_16.qb)=0.7v
.ic v(X_MEM.X_cell_48_17.q)=0v v(X_MEM.X_cell_48_17.qb)=0.7v
.ic v(X_MEM.X_cell_48_18.q)=0v v(X_MEM.X_cell_48_18.qb)=0.7v
.ic v(X_MEM.X_cell_48_19.q)=0v v(X_MEM.X_cell_48_19.qb)=0.7v
.ic v(X_MEM.X_cell_48_20.q)=0v v(X_MEM.X_cell_48_20.qb)=0.7v
.ic v(X_MEM.X_cell_48_21.q)=0v v(X_MEM.X_cell_48_21.qb)=0.7v
.ic v(X_MEM.X_cell_48_22.q)=0v v(X_MEM.X_cell_48_22.qb)=0.7v
.ic v(X_MEM.X_cell_48_23.q)=0v v(X_MEM.X_cell_48_23.qb)=0.7v
.ic v(X_MEM.X_cell_48_24.q)=0v v(X_MEM.X_cell_48_24.qb)=0.7v
.ic v(X_MEM.X_cell_48_25.q)=0v v(X_MEM.X_cell_48_25.qb)=0.7v
.ic v(X_MEM.X_cell_48_26.q)=0v v(X_MEM.X_cell_48_26.qb)=0.7v
.ic v(X_MEM.X_cell_48_27.q)=0v v(X_MEM.X_cell_48_27.qb)=0.7v
.ic v(X_MEM.X_cell_48_28.q)=0v v(X_MEM.X_cell_48_28.qb)=0.7v
.ic v(X_MEM.X_cell_48_29.q)=0v v(X_MEM.X_cell_48_29.qb)=0.7v
.ic v(X_MEM.X_cell_48_30.q)=0v v(X_MEM.X_cell_48_30.qb)=0.7v
.ic v(X_MEM.X_cell_48_31.q)=0v v(X_MEM.X_cell_48_31.qb)=0.7v
.ic v(X_MEM.X_cell_49_0.q)=0v v(X_MEM.X_cell_49_0.qb)=0.7v
.ic v(X_MEM.X_cell_49_1.q)=0v v(X_MEM.X_cell_49_1.qb)=0.7v
.ic v(X_MEM.X_cell_49_2.q)=0v v(X_MEM.X_cell_49_2.qb)=0.7v
.ic v(X_MEM.X_cell_49_3.q)=0v v(X_MEM.X_cell_49_3.qb)=0.7v
.ic v(X_MEM.X_cell_49_4.q)=0v v(X_MEM.X_cell_49_4.qb)=0.7v
.ic v(X_MEM.X_cell_49_5.q)=0v v(X_MEM.X_cell_49_5.qb)=0.7v
.ic v(X_MEM.X_cell_49_6.q)=0v v(X_MEM.X_cell_49_6.qb)=0.7v
.ic v(X_MEM.X_cell_49_7.q)=0v v(X_MEM.X_cell_49_7.qb)=0.7v
.ic v(X_MEM.X_cell_49_8.q)=0v v(X_MEM.X_cell_49_8.qb)=0.7v
.ic v(X_MEM.X_cell_49_9.q)=0v v(X_MEM.X_cell_49_9.qb)=0.7v
.ic v(X_MEM.X_cell_49_10.q)=0v v(X_MEM.X_cell_49_10.qb)=0.7v
.ic v(X_MEM.X_cell_49_11.q)=0v v(X_MEM.X_cell_49_11.qb)=0.7v
.ic v(X_MEM.X_cell_49_12.q)=0v v(X_MEM.X_cell_49_12.qb)=0.7v
.ic v(X_MEM.X_cell_49_13.q)=0v v(X_MEM.X_cell_49_13.qb)=0.7v
.ic v(X_MEM.X_cell_49_14.q)=0v v(X_MEM.X_cell_49_14.qb)=0.7v
.ic v(X_MEM.X_cell_49_15.q)=0v v(X_MEM.X_cell_49_15.qb)=0.7v
.ic v(X_MEM.X_cell_49_16.q)=0v v(X_MEM.X_cell_49_16.qb)=0.7v
.ic v(X_MEM.X_cell_49_17.q)=0v v(X_MEM.X_cell_49_17.qb)=0.7v
.ic v(X_MEM.X_cell_49_18.q)=0v v(X_MEM.X_cell_49_18.qb)=0.7v
.ic v(X_MEM.X_cell_49_19.q)=0v v(X_MEM.X_cell_49_19.qb)=0.7v
.ic v(X_MEM.X_cell_49_20.q)=0v v(X_MEM.X_cell_49_20.qb)=0.7v
.ic v(X_MEM.X_cell_49_21.q)=0v v(X_MEM.X_cell_49_21.qb)=0.7v
.ic v(X_MEM.X_cell_49_22.q)=0v v(X_MEM.X_cell_49_22.qb)=0.7v
.ic v(X_MEM.X_cell_49_23.q)=0v v(X_MEM.X_cell_49_23.qb)=0.7v
.ic v(X_MEM.X_cell_49_24.q)=0v v(X_MEM.X_cell_49_24.qb)=0.7v
.ic v(X_MEM.X_cell_49_25.q)=0v v(X_MEM.X_cell_49_25.qb)=0.7v
.ic v(X_MEM.X_cell_49_26.q)=0v v(X_MEM.X_cell_49_26.qb)=0.7v
.ic v(X_MEM.X_cell_49_27.q)=0v v(X_MEM.X_cell_49_27.qb)=0.7v
.ic v(X_MEM.X_cell_49_28.q)=0v v(X_MEM.X_cell_49_28.qb)=0.7v
.ic v(X_MEM.X_cell_49_29.q)=0v v(X_MEM.X_cell_49_29.qb)=0.7v
.ic v(X_MEM.X_cell_49_30.q)=0v v(X_MEM.X_cell_49_30.qb)=0.7v
.ic v(X_MEM.X_cell_49_31.q)=0v v(X_MEM.X_cell_49_31.qb)=0.7v
.ic v(X_MEM.X_cell_50_0.q)=0v v(X_MEM.X_cell_50_0.qb)=0.7v
.ic v(X_MEM.X_cell_50_1.q)=0v v(X_MEM.X_cell_50_1.qb)=0.7v
.ic v(X_MEM.X_cell_50_2.q)=0v v(X_MEM.X_cell_50_2.qb)=0.7v
.ic v(X_MEM.X_cell_50_3.q)=0v v(X_MEM.X_cell_50_3.qb)=0.7v
.ic v(X_MEM.X_cell_50_4.q)=0v v(X_MEM.X_cell_50_4.qb)=0.7v
.ic v(X_MEM.X_cell_50_5.q)=0v v(X_MEM.X_cell_50_5.qb)=0.7v
.ic v(X_MEM.X_cell_50_6.q)=0v v(X_MEM.X_cell_50_6.qb)=0.7v
.ic v(X_MEM.X_cell_50_7.q)=0v v(X_MEM.X_cell_50_7.qb)=0.7v
.ic v(X_MEM.X_cell_50_8.q)=0v v(X_MEM.X_cell_50_8.qb)=0.7v
.ic v(X_MEM.X_cell_50_9.q)=0v v(X_MEM.X_cell_50_9.qb)=0.7v
.ic v(X_MEM.X_cell_50_10.q)=0v v(X_MEM.X_cell_50_10.qb)=0.7v
.ic v(X_MEM.X_cell_50_11.q)=0v v(X_MEM.X_cell_50_11.qb)=0.7v
.ic v(X_MEM.X_cell_50_12.q)=0v v(X_MEM.X_cell_50_12.qb)=0.7v
.ic v(X_MEM.X_cell_50_13.q)=0v v(X_MEM.X_cell_50_13.qb)=0.7v
.ic v(X_MEM.X_cell_50_14.q)=0v v(X_MEM.X_cell_50_14.qb)=0.7v
.ic v(X_MEM.X_cell_50_15.q)=0v v(X_MEM.X_cell_50_15.qb)=0.7v
.ic v(X_MEM.X_cell_50_16.q)=0v v(X_MEM.X_cell_50_16.qb)=0.7v
.ic v(X_MEM.X_cell_50_17.q)=0v v(X_MEM.X_cell_50_17.qb)=0.7v
.ic v(X_MEM.X_cell_50_18.q)=0v v(X_MEM.X_cell_50_18.qb)=0.7v
.ic v(X_MEM.X_cell_50_19.q)=0v v(X_MEM.X_cell_50_19.qb)=0.7v
.ic v(X_MEM.X_cell_50_20.q)=0v v(X_MEM.X_cell_50_20.qb)=0.7v
.ic v(X_MEM.X_cell_50_21.q)=0v v(X_MEM.X_cell_50_21.qb)=0.7v
.ic v(X_MEM.X_cell_50_22.q)=0v v(X_MEM.X_cell_50_22.qb)=0.7v
.ic v(X_MEM.X_cell_50_23.q)=0v v(X_MEM.X_cell_50_23.qb)=0.7v
.ic v(X_MEM.X_cell_50_24.q)=0v v(X_MEM.X_cell_50_24.qb)=0.7v
.ic v(X_MEM.X_cell_50_25.q)=0v v(X_MEM.X_cell_50_25.qb)=0.7v
.ic v(X_MEM.X_cell_50_26.q)=0v v(X_MEM.X_cell_50_26.qb)=0.7v
.ic v(X_MEM.X_cell_50_27.q)=0v v(X_MEM.X_cell_50_27.qb)=0.7v
.ic v(X_MEM.X_cell_50_28.q)=0v v(X_MEM.X_cell_50_28.qb)=0.7v
.ic v(X_MEM.X_cell_50_29.q)=0v v(X_MEM.X_cell_50_29.qb)=0.7v
.ic v(X_MEM.X_cell_50_30.q)=0v v(X_MEM.X_cell_50_30.qb)=0.7v
.ic v(X_MEM.X_cell_50_31.q)=0v v(X_MEM.X_cell_50_31.qb)=0.7v
.ic v(X_MEM.X_cell_51_0.q)=0v v(X_MEM.X_cell_51_0.qb)=0.7v
.ic v(X_MEM.X_cell_51_1.q)=0v v(X_MEM.X_cell_51_1.qb)=0.7v
.ic v(X_MEM.X_cell_51_2.q)=0v v(X_MEM.X_cell_51_2.qb)=0.7v
.ic v(X_MEM.X_cell_51_3.q)=0v v(X_MEM.X_cell_51_3.qb)=0.7v
.ic v(X_MEM.X_cell_51_4.q)=0v v(X_MEM.X_cell_51_4.qb)=0.7v
.ic v(X_MEM.X_cell_51_5.q)=0v v(X_MEM.X_cell_51_5.qb)=0.7v
.ic v(X_MEM.X_cell_51_6.q)=0v v(X_MEM.X_cell_51_6.qb)=0.7v
.ic v(X_MEM.X_cell_51_7.q)=0v v(X_MEM.X_cell_51_7.qb)=0.7v
.ic v(X_MEM.X_cell_51_8.q)=0v v(X_MEM.X_cell_51_8.qb)=0.7v
.ic v(X_MEM.X_cell_51_9.q)=0v v(X_MEM.X_cell_51_9.qb)=0.7v
.ic v(X_MEM.X_cell_51_10.q)=0v v(X_MEM.X_cell_51_10.qb)=0.7v
.ic v(X_MEM.X_cell_51_11.q)=0v v(X_MEM.X_cell_51_11.qb)=0.7v
.ic v(X_MEM.X_cell_51_12.q)=0v v(X_MEM.X_cell_51_12.qb)=0.7v
.ic v(X_MEM.X_cell_51_13.q)=0v v(X_MEM.X_cell_51_13.qb)=0.7v
.ic v(X_MEM.X_cell_51_14.q)=0v v(X_MEM.X_cell_51_14.qb)=0.7v
.ic v(X_MEM.X_cell_51_15.q)=0v v(X_MEM.X_cell_51_15.qb)=0.7v
.ic v(X_MEM.X_cell_51_16.q)=0v v(X_MEM.X_cell_51_16.qb)=0.7v
.ic v(X_MEM.X_cell_51_17.q)=0v v(X_MEM.X_cell_51_17.qb)=0.7v
.ic v(X_MEM.X_cell_51_18.q)=0v v(X_MEM.X_cell_51_18.qb)=0.7v
.ic v(X_MEM.X_cell_51_19.q)=0v v(X_MEM.X_cell_51_19.qb)=0.7v
.ic v(X_MEM.X_cell_51_20.q)=0v v(X_MEM.X_cell_51_20.qb)=0.7v
.ic v(X_MEM.X_cell_51_21.q)=0v v(X_MEM.X_cell_51_21.qb)=0.7v
.ic v(X_MEM.X_cell_51_22.q)=0v v(X_MEM.X_cell_51_22.qb)=0.7v
.ic v(X_MEM.X_cell_51_23.q)=0v v(X_MEM.X_cell_51_23.qb)=0.7v
.ic v(X_MEM.X_cell_51_24.q)=0v v(X_MEM.X_cell_51_24.qb)=0.7v
.ic v(X_MEM.X_cell_51_25.q)=0v v(X_MEM.X_cell_51_25.qb)=0.7v
.ic v(X_MEM.X_cell_51_26.q)=0v v(X_MEM.X_cell_51_26.qb)=0.7v
.ic v(X_MEM.X_cell_51_27.q)=0v v(X_MEM.X_cell_51_27.qb)=0.7v
.ic v(X_MEM.X_cell_51_28.q)=0v v(X_MEM.X_cell_51_28.qb)=0.7v
.ic v(X_MEM.X_cell_51_29.q)=0v v(X_MEM.X_cell_51_29.qb)=0.7v
.ic v(X_MEM.X_cell_51_30.q)=0v v(X_MEM.X_cell_51_30.qb)=0.7v
.ic v(X_MEM.X_cell_51_31.q)=0v v(X_MEM.X_cell_51_31.qb)=0.7v
.ic v(X_MEM.X_cell_52_0.q)=0v v(X_MEM.X_cell_52_0.qb)=0.7v
.ic v(X_MEM.X_cell_52_1.q)=0v v(X_MEM.X_cell_52_1.qb)=0.7v
.ic v(X_MEM.X_cell_52_2.q)=0v v(X_MEM.X_cell_52_2.qb)=0.7v
.ic v(X_MEM.X_cell_52_3.q)=0v v(X_MEM.X_cell_52_3.qb)=0.7v
.ic v(X_MEM.X_cell_52_4.q)=0v v(X_MEM.X_cell_52_4.qb)=0.7v
.ic v(X_MEM.X_cell_52_5.q)=0v v(X_MEM.X_cell_52_5.qb)=0.7v
.ic v(X_MEM.X_cell_52_6.q)=0v v(X_MEM.X_cell_52_6.qb)=0.7v
.ic v(X_MEM.X_cell_52_7.q)=0v v(X_MEM.X_cell_52_7.qb)=0.7v
.ic v(X_MEM.X_cell_52_8.q)=0v v(X_MEM.X_cell_52_8.qb)=0.7v
.ic v(X_MEM.X_cell_52_9.q)=0v v(X_MEM.X_cell_52_9.qb)=0.7v
.ic v(X_MEM.X_cell_52_10.q)=0v v(X_MEM.X_cell_52_10.qb)=0.7v
.ic v(X_MEM.X_cell_52_11.q)=0v v(X_MEM.X_cell_52_11.qb)=0.7v
.ic v(X_MEM.X_cell_52_12.q)=0v v(X_MEM.X_cell_52_12.qb)=0.7v
.ic v(X_MEM.X_cell_52_13.q)=0v v(X_MEM.X_cell_52_13.qb)=0.7v
.ic v(X_MEM.X_cell_52_14.q)=0v v(X_MEM.X_cell_52_14.qb)=0.7v
.ic v(X_MEM.X_cell_52_15.q)=0v v(X_MEM.X_cell_52_15.qb)=0.7v
.ic v(X_MEM.X_cell_52_16.q)=0v v(X_MEM.X_cell_52_16.qb)=0.7v
.ic v(X_MEM.X_cell_52_17.q)=0v v(X_MEM.X_cell_52_17.qb)=0.7v
.ic v(X_MEM.X_cell_52_18.q)=0v v(X_MEM.X_cell_52_18.qb)=0.7v
.ic v(X_MEM.X_cell_52_19.q)=0v v(X_MEM.X_cell_52_19.qb)=0.7v
.ic v(X_MEM.X_cell_52_20.q)=0v v(X_MEM.X_cell_52_20.qb)=0.7v
.ic v(X_MEM.X_cell_52_21.q)=0v v(X_MEM.X_cell_52_21.qb)=0.7v
.ic v(X_MEM.X_cell_52_22.q)=0v v(X_MEM.X_cell_52_22.qb)=0.7v
.ic v(X_MEM.X_cell_52_23.q)=0v v(X_MEM.X_cell_52_23.qb)=0.7v
.ic v(X_MEM.X_cell_52_24.q)=0v v(X_MEM.X_cell_52_24.qb)=0.7v
.ic v(X_MEM.X_cell_52_25.q)=0v v(X_MEM.X_cell_52_25.qb)=0.7v
.ic v(X_MEM.X_cell_52_26.q)=0v v(X_MEM.X_cell_52_26.qb)=0.7v
.ic v(X_MEM.X_cell_52_27.q)=0v v(X_MEM.X_cell_52_27.qb)=0.7v
.ic v(X_MEM.X_cell_52_28.q)=0v v(X_MEM.X_cell_52_28.qb)=0.7v
.ic v(X_MEM.X_cell_52_29.q)=0v v(X_MEM.X_cell_52_29.qb)=0.7v
.ic v(X_MEM.X_cell_52_30.q)=0v v(X_MEM.X_cell_52_30.qb)=0.7v
.ic v(X_MEM.X_cell_52_31.q)=0v v(X_MEM.X_cell_52_31.qb)=0.7v
.ic v(X_MEM.X_cell_53_0.q)=0v v(X_MEM.X_cell_53_0.qb)=0.7v
.ic v(X_MEM.X_cell_53_1.q)=0v v(X_MEM.X_cell_53_1.qb)=0.7v
.ic v(X_MEM.X_cell_53_2.q)=0v v(X_MEM.X_cell_53_2.qb)=0.7v
.ic v(X_MEM.X_cell_53_3.q)=0v v(X_MEM.X_cell_53_3.qb)=0.7v
.ic v(X_MEM.X_cell_53_4.q)=0v v(X_MEM.X_cell_53_4.qb)=0.7v
.ic v(X_MEM.X_cell_53_5.q)=0v v(X_MEM.X_cell_53_5.qb)=0.7v
.ic v(X_MEM.X_cell_53_6.q)=0v v(X_MEM.X_cell_53_6.qb)=0.7v
.ic v(X_MEM.X_cell_53_7.q)=0v v(X_MEM.X_cell_53_7.qb)=0.7v
.ic v(X_MEM.X_cell_53_8.q)=0v v(X_MEM.X_cell_53_8.qb)=0.7v
.ic v(X_MEM.X_cell_53_9.q)=0v v(X_MEM.X_cell_53_9.qb)=0.7v
.ic v(X_MEM.X_cell_53_10.q)=0v v(X_MEM.X_cell_53_10.qb)=0.7v
.ic v(X_MEM.X_cell_53_11.q)=0v v(X_MEM.X_cell_53_11.qb)=0.7v
.ic v(X_MEM.X_cell_53_12.q)=0v v(X_MEM.X_cell_53_12.qb)=0.7v
.ic v(X_MEM.X_cell_53_13.q)=0v v(X_MEM.X_cell_53_13.qb)=0.7v
.ic v(X_MEM.X_cell_53_14.q)=0v v(X_MEM.X_cell_53_14.qb)=0.7v
.ic v(X_MEM.X_cell_53_15.q)=0v v(X_MEM.X_cell_53_15.qb)=0.7v
.ic v(X_MEM.X_cell_53_16.q)=0v v(X_MEM.X_cell_53_16.qb)=0.7v
.ic v(X_MEM.X_cell_53_17.q)=0v v(X_MEM.X_cell_53_17.qb)=0.7v
.ic v(X_MEM.X_cell_53_18.q)=0v v(X_MEM.X_cell_53_18.qb)=0.7v
.ic v(X_MEM.X_cell_53_19.q)=0v v(X_MEM.X_cell_53_19.qb)=0.7v
.ic v(X_MEM.X_cell_53_20.q)=0v v(X_MEM.X_cell_53_20.qb)=0.7v
.ic v(X_MEM.X_cell_53_21.q)=0v v(X_MEM.X_cell_53_21.qb)=0.7v
.ic v(X_MEM.X_cell_53_22.q)=0v v(X_MEM.X_cell_53_22.qb)=0.7v
.ic v(X_MEM.X_cell_53_23.q)=0v v(X_MEM.X_cell_53_23.qb)=0.7v
.ic v(X_MEM.X_cell_53_24.q)=0v v(X_MEM.X_cell_53_24.qb)=0.7v
.ic v(X_MEM.X_cell_53_25.q)=0v v(X_MEM.X_cell_53_25.qb)=0.7v
.ic v(X_MEM.X_cell_53_26.q)=0v v(X_MEM.X_cell_53_26.qb)=0.7v
.ic v(X_MEM.X_cell_53_27.q)=0v v(X_MEM.X_cell_53_27.qb)=0.7v
.ic v(X_MEM.X_cell_53_28.q)=0v v(X_MEM.X_cell_53_28.qb)=0.7v
.ic v(X_MEM.X_cell_53_29.q)=0v v(X_MEM.X_cell_53_29.qb)=0.7v
.ic v(X_MEM.X_cell_53_30.q)=0v v(X_MEM.X_cell_53_30.qb)=0.7v
.ic v(X_MEM.X_cell_53_31.q)=0v v(X_MEM.X_cell_53_31.qb)=0.7v
.ic v(X_MEM.X_cell_54_0.q)=0v v(X_MEM.X_cell_54_0.qb)=0.7v
.ic v(X_MEM.X_cell_54_1.q)=0v v(X_MEM.X_cell_54_1.qb)=0.7v
.ic v(X_MEM.X_cell_54_2.q)=0v v(X_MEM.X_cell_54_2.qb)=0.7v
.ic v(X_MEM.X_cell_54_3.q)=0v v(X_MEM.X_cell_54_3.qb)=0.7v
.ic v(X_MEM.X_cell_54_4.q)=0v v(X_MEM.X_cell_54_4.qb)=0.7v
.ic v(X_MEM.X_cell_54_5.q)=0v v(X_MEM.X_cell_54_5.qb)=0.7v
.ic v(X_MEM.X_cell_54_6.q)=0v v(X_MEM.X_cell_54_6.qb)=0.7v
.ic v(X_MEM.X_cell_54_7.q)=0v v(X_MEM.X_cell_54_7.qb)=0.7v
.ic v(X_MEM.X_cell_54_8.q)=0v v(X_MEM.X_cell_54_8.qb)=0.7v
.ic v(X_MEM.X_cell_54_9.q)=0v v(X_MEM.X_cell_54_9.qb)=0.7v
.ic v(X_MEM.X_cell_54_10.q)=0v v(X_MEM.X_cell_54_10.qb)=0.7v
.ic v(X_MEM.X_cell_54_11.q)=0v v(X_MEM.X_cell_54_11.qb)=0.7v
.ic v(X_MEM.X_cell_54_12.q)=0v v(X_MEM.X_cell_54_12.qb)=0.7v
.ic v(X_MEM.X_cell_54_13.q)=0v v(X_MEM.X_cell_54_13.qb)=0.7v
.ic v(X_MEM.X_cell_54_14.q)=0v v(X_MEM.X_cell_54_14.qb)=0.7v
.ic v(X_MEM.X_cell_54_15.q)=0v v(X_MEM.X_cell_54_15.qb)=0.7v
.ic v(X_MEM.X_cell_54_16.q)=0v v(X_MEM.X_cell_54_16.qb)=0.7v
.ic v(X_MEM.X_cell_54_17.q)=0v v(X_MEM.X_cell_54_17.qb)=0.7v
.ic v(X_MEM.X_cell_54_18.q)=0v v(X_MEM.X_cell_54_18.qb)=0.7v
.ic v(X_MEM.X_cell_54_19.q)=0v v(X_MEM.X_cell_54_19.qb)=0.7v
.ic v(X_MEM.X_cell_54_20.q)=0v v(X_MEM.X_cell_54_20.qb)=0.7v
.ic v(X_MEM.X_cell_54_21.q)=0v v(X_MEM.X_cell_54_21.qb)=0.7v
.ic v(X_MEM.X_cell_54_22.q)=0v v(X_MEM.X_cell_54_22.qb)=0.7v
.ic v(X_MEM.X_cell_54_23.q)=0v v(X_MEM.X_cell_54_23.qb)=0.7v
.ic v(X_MEM.X_cell_54_24.q)=0v v(X_MEM.X_cell_54_24.qb)=0.7v
.ic v(X_MEM.X_cell_54_25.q)=0v v(X_MEM.X_cell_54_25.qb)=0.7v
.ic v(X_MEM.X_cell_54_26.q)=0v v(X_MEM.X_cell_54_26.qb)=0.7v
.ic v(X_MEM.X_cell_54_27.q)=0v v(X_MEM.X_cell_54_27.qb)=0.7v
.ic v(X_MEM.X_cell_54_28.q)=0v v(X_MEM.X_cell_54_28.qb)=0.7v
.ic v(X_MEM.X_cell_54_29.q)=0v v(X_MEM.X_cell_54_29.qb)=0.7v
.ic v(X_MEM.X_cell_54_30.q)=0v v(X_MEM.X_cell_54_30.qb)=0.7v
.ic v(X_MEM.X_cell_54_31.q)=0v v(X_MEM.X_cell_54_31.qb)=0.7v
.ic v(X_MEM.X_cell_55_0.q)=0v v(X_MEM.X_cell_55_0.qb)=0.7v
.ic v(X_MEM.X_cell_55_1.q)=0v v(X_MEM.X_cell_55_1.qb)=0.7v
.ic v(X_MEM.X_cell_55_2.q)=0v v(X_MEM.X_cell_55_2.qb)=0.7v
.ic v(X_MEM.X_cell_55_3.q)=0v v(X_MEM.X_cell_55_3.qb)=0.7v
.ic v(X_MEM.X_cell_55_4.q)=0v v(X_MEM.X_cell_55_4.qb)=0.7v
.ic v(X_MEM.X_cell_55_5.q)=0v v(X_MEM.X_cell_55_5.qb)=0.7v
.ic v(X_MEM.X_cell_55_6.q)=0v v(X_MEM.X_cell_55_6.qb)=0.7v
.ic v(X_MEM.X_cell_55_7.q)=0v v(X_MEM.X_cell_55_7.qb)=0.7v
.ic v(X_MEM.X_cell_55_8.q)=0v v(X_MEM.X_cell_55_8.qb)=0.7v
.ic v(X_MEM.X_cell_55_9.q)=0v v(X_MEM.X_cell_55_9.qb)=0.7v
.ic v(X_MEM.X_cell_55_10.q)=0v v(X_MEM.X_cell_55_10.qb)=0.7v
.ic v(X_MEM.X_cell_55_11.q)=0v v(X_MEM.X_cell_55_11.qb)=0.7v
.ic v(X_MEM.X_cell_55_12.q)=0v v(X_MEM.X_cell_55_12.qb)=0.7v
.ic v(X_MEM.X_cell_55_13.q)=0v v(X_MEM.X_cell_55_13.qb)=0.7v
.ic v(X_MEM.X_cell_55_14.q)=0v v(X_MEM.X_cell_55_14.qb)=0.7v
.ic v(X_MEM.X_cell_55_15.q)=0v v(X_MEM.X_cell_55_15.qb)=0.7v
.ic v(X_MEM.X_cell_55_16.q)=0v v(X_MEM.X_cell_55_16.qb)=0.7v
.ic v(X_MEM.X_cell_55_17.q)=0v v(X_MEM.X_cell_55_17.qb)=0.7v
.ic v(X_MEM.X_cell_55_18.q)=0v v(X_MEM.X_cell_55_18.qb)=0.7v
.ic v(X_MEM.X_cell_55_19.q)=0v v(X_MEM.X_cell_55_19.qb)=0.7v
.ic v(X_MEM.X_cell_55_20.q)=0v v(X_MEM.X_cell_55_20.qb)=0.7v
.ic v(X_MEM.X_cell_55_21.q)=0v v(X_MEM.X_cell_55_21.qb)=0.7v
.ic v(X_MEM.X_cell_55_22.q)=0v v(X_MEM.X_cell_55_22.qb)=0.7v
.ic v(X_MEM.X_cell_55_23.q)=0v v(X_MEM.X_cell_55_23.qb)=0.7v
.ic v(X_MEM.X_cell_55_24.q)=0v v(X_MEM.X_cell_55_24.qb)=0.7v
.ic v(X_MEM.X_cell_55_25.q)=0v v(X_MEM.X_cell_55_25.qb)=0.7v
.ic v(X_MEM.X_cell_55_26.q)=0v v(X_MEM.X_cell_55_26.qb)=0.7v
.ic v(X_MEM.X_cell_55_27.q)=0v v(X_MEM.X_cell_55_27.qb)=0.7v
.ic v(X_MEM.X_cell_55_28.q)=0v v(X_MEM.X_cell_55_28.qb)=0.7v
.ic v(X_MEM.X_cell_55_29.q)=0v v(X_MEM.X_cell_55_29.qb)=0.7v
.ic v(X_MEM.X_cell_55_30.q)=0v v(X_MEM.X_cell_55_30.qb)=0.7v
.ic v(X_MEM.X_cell_55_31.q)=0v v(X_MEM.X_cell_55_31.qb)=0.7v
.ic v(X_MEM.X_cell_56_0.q)=0v v(X_MEM.X_cell_56_0.qb)=0.7v
.ic v(X_MEM.X_cell_56_1.q)=0v v(X_MEM.X_cell_56_1.qb)=0.7v
.ic v(X_MEM.X_cell_56_2.q)=0v v(X_MEM.X_cell_56_2.qb)=0.7v
.ic v(X_MEM.X_cell_56_3.q)=0v v(X_MEM.X_cell_56_3.qb)=0.7v
.ic v(X_MEM.X_cell_56_4.q)=0v v(X_MEM.X_cell_56_4.qb)=0.7v
.ic v(X_MEM.X_cell_56_5.q)=0v v(X_MEM.X_cell_56_5.qb)=0.7v
.ic v(X_MEM.X_cell_56_6.q)=0v v(X_MEM.X_cell_56_6.qb)=0.7v
.ic v(X_MEM.X_cell_56_7.q)=0v v(X_MEM.X_cell_56_7.qb)=0.7v
.ic v(X_MEM.X_cell_56_8.q)=0v v(X_MEM.X_cell_56_8.qb)=0.7v
.ic v(X_MEM.X_cell_56_9.q)=0v v(X_MEM.X_cell_56_9.qb)=0.7v
.ic v(X_MEM.X_cell_56_10.q)=0v v(X_MEM.X_cell_56_10.qb)=0.7v
.ic v(X_MEM.X_cell_56_11.q)=0v v(X_MEM.X_cell_56_11.qb)=0.7v
.ic v(X_MEM.X_cell_56_12.q)=0v v(X_MEM.X_cell_56_12.qb)=0.7v
.ic v(X_MEM.X_cell_56_13.q)=0v v(X_MEM.X_cell_56_13.qb)=0.7v
.ic v(X_MEM.X_cell_56_14.q)=0v v(X_MEM.X_cell_56_14.qb)=0.7v
.ic v(X_MEM.X_cell_56_15.q)=0v v(X_MEM.X_cell_56_15.qb)=0.7v
.ic v(X_MEM.X_cell_56_16.q)=0v v(X_MEM.X_cell_56_16.qb)=0.7v
.ic v(X_MEM.X_cell_56_17.q)=0v v(X_MEM.X_cell_56_17.qb)=0.7v
.ic v(X_MEM.X_cell_56_18.q)=0v v(X_MEM.X_cell_56_18.qb)=0.7v
.ic v(X_MEM.X_cell_56_19.q)=0v v(X_MEM.X_cell_56_19.qb)=0.7v
.ic v(X_MEM.X_cell_56_20.q)=0v v(X_MEM.X_cell_56_20.qb)=0.7v
.ic v(X_MEM.X_cell_56_21.q)=0v v(X_MEM.X_cell_56_21.qb)=0.7v
.ic v(X_MEM.X_cell_56_22.q)=0v v(X_MEM.X_cell_56_22.qb)=0.7v
.ic v(X_MEM.X_cell_56_23.q)=0v v(X_MEM.X_cell_56_23.qb)=0.7v
.ic v(X_MEM.X_cell_56_24.q)=0v v(X_MEM.X_cell_56_24.qb)=0.7v
.ic v(X_MEM.X_cell_56_25.q)=0v v(X_MEM.X_cell_56_25.qb)=0.7v
.ic v(X_MEM.X_cell_56_26.q)=0v v(X_MEM.X_cell_56_26.qb)=0.7v
.ic v(X_MEM.X_cell_56_27.q)=0v v(X_MEM.X_cell_56_27.qb)=0.7v
.ic v(X_MEM.X_cell_56_28.q)=0v v(X_MEM.X_cell_56_28.qb)=0.7v
.ic v(X_MEM.X_cell_56_29.q)=0v v(X_MEM.X_cell_56_29.qb)=0.7v
.ic v(X_MEM.X_cell_56_30.q)=0v v(X_MEM.X_cell_56_30.qb)=0.7v
.ic v(X_MEM.X_cell_56_31.q)=0v v(X_MEM.X_cell_56_31.qb)=0.7v
.ic v(X_MEM.X_cell_57_0.q)=0v v(X_MEM.X_cell_57_0.qb)=0.7v
.ic v(X_MEM.X_cell_57_1.q)=0v v(X_MEM.X_cell_57_1.qb)=0.7v
.ic v(X_MEM.X_cell_57_2.q)=0v v(X_MEM.X_cell_57_2.qb)=0.7v
.ic v(X_MEM.X_cell_57_3.q)=0v v(X_MEM.X_cell_57_3.qb)=0.7v
.ic v(X_MEM.X_cell_57_4.q)=0v v(X_MEM.X_cell_57_4.qb)=0.7v
.ic v(X_MEM.X_cell_57_5.q)=0v v(X_MEM.X_cell_57_5.qb)=0.7v
.ic v(X_MEM.X_cell_57_6.q)=0v v(X_MEM.X_cell_57_6.qb)=0.7v
.ic v(X_MEM.X_cell_57_7.q)=0v v(X_MEM.X_cell_57_7.qb)=0.7v
.ic v(X_MEM.X_cell_57_8.q)=0v v(X_MEM.X_cell_57_8.qb)=0.7v
.ic v(X_MEM.X_cell_57_9.q)=0v v(X_MEM.X_cell_57_9.qb)=0.7v
.ic v(X_MEM.X_cell_57_10.q)=0v v(X_MEM.X_cell_57_10.qb)=0.7v
.ic v(X_MEM.X_cell_57_11.q)=0v v(X_MEM.X_cell_57_11.qb)=0.7v
.ic v(X_MEM.X_cell_57_12.q)=0v v(X_MEM.X_cell_57_12.qb)=0.7v
.ic v(X_MEM.X_cell_57_13.q)=0v v(X_MEM.X_cell_57_13.qb)=0.7v
.ic v(X_MEM.X_cell_57_14.q)=0v v(X_MEM.X_cell_57_14.qb)=0.7v
.ic v(X_MEM.X_cell_57_15.q)=0v v(X_MEM.X_cell_57_15.qb)=0.7v
.ic v(X_MEM.X_cell_57_16.q)=0v v(X_MEM.X_cell_57_16.qb)=0.7v
.ic v(X_MEM.X_cell_57_17.q)=0v v(X_MEM.X_cell_57_17.qb)=0.7v
.ic v(X_MEM.X_cell_57_18.q)=0v v(X_MEM.X_cell_57_18.qb)=0.7v
.ic v(X_MEM.X_cell_57_19.q)=0v v(X_MEM.X_cell_57_19.qb)=0.7v
.ic v(X_MEM.X_cell_57_20.q)=0v v(X_MEM.X_cell_57_20.qb)=0.7v
.ic v(X_MEM.X_cell_57_21.q)=0v v(X_MEM.X_cell_57_21.qb)=0.7v
.ic v(X_MEM.X_cell_57_22.q)=0v v(X_MEM.X_cell_57_22.qb)=0.7v
.ic v(X_MEM.X_cell_57_23.q)=0v v(X_MEM.X_cell_57_23.qb)=0.7v
.ic v(X_MEM.X_cell_57_24.q)=0v v(X_MEM.X_cell_57_24.qb)=0.7v
.ic v(X_MEM.X_cell_57_25.q)=0v v(X_MEM.X_cell_57_25.qb)=0.7v
.ic v(X_MEM.X_cell_57_26.q)=0v v(X_MEM.X_cell_57_26.qb)=0.7v
.ic v(X_MEM.X_cell_57_27.q)=0v v(X_MEM.X_cell_57_27.qb)=0.7v
.ic v(X_MEM.X_cell_57_28.q)=0v v(X_MEM.X_cell_57_28.qb)=0.7v
.ic v(X_MEM.X_cell_57_29.q)=0v v(X_MEM.X_cell_57_29.qb)=0.7v
.ic v(X_MEM.X_cell_57_30.q)=0v v(X_MEM.X_cell_57_30.qb)=0.7v
.ic v(X_MEM.X_cell_57_31.q)=0v v(X_MEM.X_cell_57_31.qb)=0.7v
.ic v(X_MEM.X_cell_58_0.q)=0v v(X_MEM.X_cell_58_0.qb)=0.7v
.ic v(X_MEM.X_cell_58_1.q)=0v v(X_MEM.X_cell_58_1.qb)=0.7v
.ic v(X_MEM.X_cell_58_2.q)=0v v(X_MEM.X_cell_58_2.qb)=0.7v
.ic v(X_MEM.X_cell_58_3.q)=0v v(X_MEM.X_cell_58_3.qb)=0.7v
.ic v(X_MEM.X_cell_58_4.q)=0v v(X_MEM.X_cell_58_4.qb)=0.7v
.ic v(X_MEM.X_cell_58_5.q)=0v v(X_MEM.X_cell_58_5.qb)=0.7v
.ic v(X_MEM.X_cell_58_6.q)=0v v(X_MEM.X_cell_58_6.qb)=0.7v
.ic v(X_MEM.X_cell_58_7.q)=0v v(X_MEM.X_cell_58_7.qb)=0.7v
.ic v(X_MEM.X_cell_58_8.q)=0v v(X_MEM.X_cell_58_8.qb)=0.7v
.ic v(X_MEM.X_cell_58_9.q)=0v v(X_MEM.X_cell_58_9.qb)=0.7v
.ic v(X_MEM.X_cell_58_10.q)=0v v(X_MEM.X_cell_58_10.qb)=0.7v
.ic v(X_MEM.X_cell_58_11.q)=0v v(X_MEM.X_cell_58_11.qb)=0.7v
.ic v(X_MEM.X_cell_58_12.q)=0v v(X_MEM.X_cell_58_12.qb)=0.7v
.ic v(X_MEM.X_cell_58_13.q)=0v v(X_MEM.X_cell_58_13.qb)=0.7v
.ic v(X_MEM.X_cell_58_14.q)=0v v(X_MEM.X_cell_58_14.qb)=0.7v
.ic v(X_MEM.X_cell_58_15.q)=0v v(X_MEM.X_cell_58_15.qb)=0.7v
.ic v(X_MEM.X_cell_58_16.q)=0v v(X_MEM.X_cell_58_16.qb)=0.7v
.ic v(X_MEM.X_cell_58_17.q)=0v v(X_MEM.X_cell_58_17.qb)=0.7v
.ic v(X_MEM.X_cell_58_18.q)=0v v(X_MEM.X_cell_58_18.qb)=0.7v
.ic v(X_MEM.X_cell_58_19.q)=0v v(X_MEM.X_cell_58_19.qb)=0.7v
.ic v(X_MEM.X_cell_58_20.q)=0v v(X_MEM.X_cell_58_20.qb)=0.7v
.ic v(X_MEM.X_cell_58_21.q)=0v v(X_MEM.X_cell_58_21.qb)=0.7v
.ic v(X_MEM.X_cell_58_22.q)=0v v(X_MEM.X_cell_58_22.qb)=0.7v
.ic v(X_MEM.X_cell_58_23.q)=0v v(X_MEM.X_cell_58_23.qb)=0.7v
.ic v(X_MEM.X_cell_58_24.q)=0v v(X_MEM.X_cell_58_24.qb)=0.7v
.ic v(X_MEM.X_cell_58_25.q)=0v v(X_MEM.X_cell_58_25.qb)=0.7v
.ic v(X_MEM.X_cell_58_26.q)=0v v(X_MEM.X_cell_58_26.qb)=0.7v
.ic v(X_MEM.X_cell_58_27.q)=0v v(X_MEM.X_cell_58_27.qb)=0.7v
.ic v(X_MEM.X_cell_58_28.q)=0v v(X_MEM.X_cell_58_28.qb)=0.7v
.ic v(X_MEM.X_cell_58_29.q)=0v v(X_MEM.X_cell_58_29.qb)=0.7v
.ic v(X_MEM.X_cell_58_30.q)=0v v(X_MEM.X_cell_58_30.qb)=0.7v
.ic v(X_MEM.X_cell_58_31.q)=0v v(X_MEM.X_cell_58_31.qb)=0.7v
.ic v(X_MEM.X_cell_59_0.q)=0v v(X_MEM.X_cell_59_0.qb)=0.7v
.ic v(X_MEM.X_cell_59_1.q)=0v v(X_MEM.X_cell_59_1.qb)=0.7v
.ic v(X_MEM.X_cell_59_2.q)=0v v(X_MEM.X_cell_59_2.qb)=0.7v
.ic v(X_MEM.X_cell_59_3.q)=0v v(X_MEM.X_cell_59_3.qb)=0.7v
.ic v(X_MEM.X_cell_59_4.q)=0v v(X_MEM.X_cell_59_4.qb)=0.7v
.ic v(X_MEM.X_cell_59_5.q)=0v v(X_MEM.X_cell_59_5.qb)=0.7v
.ic v(X_MEM.X_cell_59_6.q)=0v v(X_MEM.X_cell_59_6.qb)=0.7v
.ic v(X_MEM.X_cell_59_7.q)=0v v(X_MEM.X_cell_59_7.qb)=0.7v
.ic v(X_MEM.X_cell_59_8.q)=0v v(X_MEM.X_cell_59_8.qb)=0.7v
.ic v(X_MEM.X_cell_59_9.q)=0v v(X_MEM.X_cell_59_9.qb)=0.7v
.ic v(X_MEM.X_cell_59_10.q)=0v v(X_MEM.X_cell_59_10.qb)=0.7v
.ic v(X_MEM.X_cell_59_11.q)=0v v(X_MEM.X_cell_59_11.qb)=0.7v
.ic v(X_MEM.X_cell_59_12.q)=0v v(X_MEM.X_cell_59_12.qb)=0.7v
.ic v(X_MEM.X_cell_59_13.q)=0v v(X_MEM.X_cell_59_13.qb)=0.7v
.ic v(X_MEM.X_cell_59_14.q)=0v v(X_MEM.X_cell_59_14.qb)=0.7v
.ic v(X_MEM.X_cell_59_15.q)=0v v(X_MEM.X_cell_59_15.qb)=0.7v
.ic v(X_MEM.X_cell_59_16.q)=0v v(X_MEM.X_cell_59_16.qb)=0.7v
.ic v(X_MEM.X_cell_59_17.q)=0v v(X_MEM.X_cell_59_17.qb)=0.7v
.ic v(X_MEM.X_cell_59_18.q)=0v v(X_MEM.X_cell_59_18.qb)=0.7v
.ic v(X_MEM.X_cell_59_19.q)=0v v(X_MEM.X_cell_59_19.qb)=0.7v
.ic v(X_MEM.X_cell_59_20.q)=0v v(X_MEM.X_cell_59_20.qb)=0.7v
.ic v(X_MEM.X_cell_59_21.q)=0v v(X_MEM.X_cell_59_21.qb)=0.7v
.ic v(X_MEM.X_cell_59_22.q)=0v v(X_MEM.X_cell_59_22.qb)=0.7v
.ic v(X_MEM.X_cell_59_23.q)=0v v(X_MEM.X_cell_59_23.qb)=0.7v
.ic v(X_MEM.X_cell_59_24.q)=0v v(X_MEM.X_cell_59_24.qb)=0.7v
.ic v(X_MEM.X_cell_59_25.q)=0v v(X_MEM.X_cell_59_25.qb)=0.7v
.ic v(X_MEM.X_cell_59_26.q)=0v v(X_MEM.X_cell_59_26.qb)=0.7v
.ic v(X_MEM.X_cell_59_27.q)=0v v(X_MEM.X_cell_59_27.qb)=0.7v
.ic v(X_MEM.X_cell_59_28.q)=0v v(X_MEM.X_cell_59_28.qb)=0.7v
.ic v(X_MEM.X_cell_59_29.q)=0v v(X_MEM.X_cell_59_29.qb)=0.7v
.ic v(X_MEM.X_cell_59_30.q)=0v v(X_MEM.X_cell_59_30.qb)=0.7v
.ic v(X_MEM.X_cell_59_31.q)=0v v(X_MEM.X_cell_59_31.qb)=0.7v
.ic v(X_MEM.X_cell_60_0.q)=0v v(X_MEM.X_cell_60_0.qb)=0.7v
.ic v(X_MEM.X_cell_60_1.q)=0v v(X_MEM.X_cell_60_1.qb)=0.7v
.ic v(X_MEM.X_cell_60_2.q)=0v v(X_MEM.X_cell_60_2.qb)=0.7v
.ic v(X_MEM.X_cell_60_3.q)=0v v(X_MEM.X_cell_60_3.qb)=0.7v
.ic v(X_MEM.X_cell_60_4.q)=0v v(X_MEM.X_cell_60_4.qb)=0.7v
.ic v(X_MEM.X_cell_60_5.q)=0v v(X_MEM.X_cell_60_5.qb)=0.7v
.ic v(X_MEM.X_cell_60_6.q)=0v v(X_MEM.X_cell_60_6.qb)=0.7v
.ic v(X_MEM.X_cell_60_7.q)=0v v(X_MEM.X_cell_60_7.qb)=0.7v
.ic v(X_MEM.X_cell_60_8.q)=0v v(X_MEM.X_cell_60_8.qb)=0.7v
.ic v(X_MEM.X_cell_60_9.q)=0v v(X_MEM.X_cell_60_9.qb)=0.7v
.ic v(X_MEM.X_cell_60_10.q)=0v v(X_MEM.X_cell_60_10.qb)=0.7v
.ic v(X_MEM.X_cell_60_11.q)=0v v(X_MEM.X_cell_60_11.qb)=0.7v
.ic v(X_MEM.X_cell_60_12.q)=0v v(X_MEM.X_cell_60_12.qb)=0.7v
.ic v(X_MEM.X_cell_60_13.q)=0v v(X_MEM.X_cell_60_13.qb)=0.7v
.ic v(X_MEM.X_cell_60_14.q)=0v v(X_MEM.X_cell_60_14.qb)=0.7v
.ic v(X_MEM.X_cell_60_15.q)=0v v(X_MEM.X_cell_60_15.qb)=0.7v
.ic v(X_MEM.X_cell_60_16.q)=0v v(X_MEM.X_cell_60_16.qb)=0.7v
.ic v(X_MEM.X_cell_60_17.q)=0v v(X_MEM.X_cell_60_17.qb)=0.7v
.ic v(X_MEM.X_cell_60_18.q)=0v v(X_MEM.X_cell_60_18.qb)=0.7v
.ic v(X_MEM.X_cell_60_19.q)=0v v(X_MEM.X_cell_60_19.qb)=0.7v
.ic v(X_MEM.X_cell_60_20.q)=0v v(X_MEM.X_cell_60_20.qb)=0.7v
.ic v(X_MEM.X_cell_60_21.q)=0v v(X_MEM.X_cell_60_21.qb)=0.7v
.ic v(X_MEM.X_cell_60_22.q)=0v v(X_MEM.X_cell_60_22.qb)=0.7v
.ic v(X_MEM.X_cell_60_23.q)=0v v(X_MEM.X_cell_60_23.qb)=0.7v
.ic v(X_MEM.X_cell_60_24.q)=0v v(X_MEM.X_cell_60_24.qb)=0.7v
.ic v(X_MEM.X_cell_60_25.q)=0v v(X_MEM.X_cell_60_25.qb)=0.7v
.ic v(X_MEM.X_cell_60_26.q)=0v v(X_MEM.X_cell_60_26.qb)=0.7v
.ic v(X_MEM.X_cell_60_27.q)=0v v(X_MEM.X_cell_60_27.qb)=0.7v
.ic v(X_MEM.X_cell_60_28.q)=0v v(X_MEM.X_cell_60_28.qb)=0.7v
.ic v(X_MEM.X_cell_60_29.q)=0v v(X_MEM.X_cell_60_29.qb)=0.7v
.ic v(X_MEM.X_cell_60_30.q)=0v v(X_MEM.X_cell_60_30.qb)=0.7v
.ic v(X_MEM.X_cell_60_31.q)=0v v(X_MEM.X_cell_60_31.qb)=0.7v
.ic v(X_MEM.X_cell_61_0.q)=0v v(X_MEM.X_cell_61_0.qb)=0.7v
.ic v(X_MEM.X_cell_61_1.q)=0v v(X_MEM.X_cell_61_1.qb)=0.7v
.ic v(X_MEM.X_cell_61_2.q)=0v v(X_MEM.X_cell_61_2.qb)=0.7v
.ic v(X_MEM.X_cell_61_3.q)=0v v(X_MEM.X_cell_61_3.qb)=0.7v
.ic v(X_MEM.X_cell_61_4.q)=0v v(X_MEM.X_cell_61_4.qb)=0.7v
.ic v(X_MEM.X_cell_61_5.q)=0v v(X_MEM.X_cell_61_5.qb)=0.7v
.ic v(X_MEM.X_cell_61_6.q)=0v v(X_MEM.X_cell_61_6.qb)=0.7v
.ic v(X_MEM.X_cell_61_7.q)=0v v(X_MEM.X_cell_61_7.qb)=0.7v
.ic v(X_MEM.X_cell_61_8.q)=0v v(X_MEM.X_cell_61_8.qb)=0.7v
.ic v(X_MEM.X_cell_61_9.q)=0v v(X_MEM.X_cell_61_9.qb)=0.7v
.ic v(X_MEM.X_cell_61_10.q)=0v v(X_MEM.X_cell_61_10.qb)=0.7v
.ic v(X_MEM.X_cell_61_11.q)=0v v(X_MEM.X_cell_61_11.qb)=0.7v
.ic v(X_MEM.X_cell_61_12.q)=0v v(X_MEM.X_cell_61_12.qb)=0.7v
.ic v(X_MEM.X_cell_61_13.q)=0v v(X_MEM.X_cell_61_13.qb)=0.7v
.ic v(X_MEM.X_cell_61_14.q)=0v v(X_MEM.X_cell_61_14.qb)=0.7v
.ic v(X_MEM.X_cell_61_15.q)=0v v(X_MEM.X_cell_61_15.qb)=0.7v
.ic v(X_MEM.X_cell_61_16.q)=0v v(X_MEM.X_cell_61_16.qb)=0.7v
.ic v(X_MEM.X_cell_61_17.q)=0v v(X_MEM.X_cell_61_17.qb)=0.7v
.ic v(X_MEM.X_cell_61_18.q)=0v v(X_MEM.X_cell_61_18.qb)=0.7v
.ic v(X_MEM.X_cell_61_19.q)=0v v(X_MEM.X_cell_61_19.qb)=0.7v
.ic v(X_MEM.X_cell_61_20.q)=0v v(X_MEM.X_cell_61_20.qb)=0.7v
.ic v(X_MEM.X_cell_61_21.q)=0v v(X_MEM.X_cell_61_21.qb)=0.7v
.ic v(X_MEM.X_cell_61_22.q)=0v v(X_MEM.X_cell_61_22.qb)=0.7v
.ic v(X_MEM.X_cell_61_23.q)=0v v(X_MEM.X_cell_61_23.qb)=0.7v
.ic v(X_MEM.X_cell_61_24.q)=0v v(X_MEM.X_cell_61_24.qb)=0.7v
.ic v(X_MEM.X_cell_61_25.q)=0v v(X_MEM.X_cell_61_25.qb)=0.7v
.ic v(X_MEM.X_cell_61_26.q)=0v v(X_MEM.X_cell_61_26.qb)=0.7v
.ic v(X_MEM.X_cell_61_27.q)=0v v(X_MEM.X_cell_61_27.qb)=0.7v
.ic v(X_MEM.X_cell_61_28.q)=0v v(X_MEM.X_cell_61_28.qb)=0.7v
.ic v(X_MEM.X_cell_61_29.q)=0v v(X_MEM.X_cell_61_29.qb)=0.7v
.ic v(X_MEM.X_cell_61_30.q)=0v v(X_MEM.X_cell_61_30.qb)=0.7v
.ic v(X_MEM.X_cell_61_31.q)=0v v(X_MEM.X_cell_61_31.qb)=0.7v
.ic v(X_MEM.X_cell_62_0.q)=0v v(X_MEM.X_cell_62_0.qb)=0.7v
.ic v(X_MEM.X_cell_62_1.q)=0v v(X_MEM.X_cell_62_1.qb)=0.7v
.ic v(X_MEM.X_cell_62_2.q)=0v v(X_MEM.X_cell_62_2.qb)=0.7v
.ic v(X_MEM.X_cell_62_3.q)=0v v(X_MEM.X_cell_62_3.qb)=0.7v
.ic v(X_MEM.X_cell_62_4.q)=0v v(X_MEM.X_cell_62_4.qb)=0.7v
.ic v(X_MEM.X_cell_62_5.q)=0v v(X_MEM.X_cell_62_5.qb)=0.7v
.ic v(X_MEM.X_cell_62_6.q)=0v v(X_MEM.X_cell_62_6.qb)=0.7v
.ic v(X_MEM.X_cell_62_7.q)=0v v(X_MEM.X_cell_62_7.qb)=0.7v
.ic v(X_MEM.X_cell_62_8.q)=0v v(X_MEM.X_cell_62_8.qb)=0.7v
.ic v(X_MEM.X_cell_62_9.q)=0v v(X_MEM.X_cell_62_9.qb)=0.7v
.ic v(X_MEM.X_cell_62_10.q)=0v v(X_MEM.X_cell_62_10.qb)=0.7v
.ic v(X_MEM.X_cell_62_11.q)=0v v(X_MEM.X_cell_62_11.qb)=0.7v
.ic v(X_MEM.X_cell_62_12.q)=0v v(X_MEM.X_cell_62_12.qb)=0.7v
.ic v(X_MEM.X_cell_62_13.q)=0v v(X_MEM.X_cell_62_13.qb)=0.7v
.ic v(X_MEM.X_cell_62_14.q)=0v v(X_MEM.X_cell_62_14.qb)=0.7v
.ic v(X_MEM.X_cell_62_15.q)=0v v(X_MEM.X_cell_62_15.qb)=0.7v
.ic v(X_MEM.X_cell_62_16.q)=0v v(X_MEM.X_cell_62_16.qb)=0.7v
.ic v(X_MEM.X_cell_62_17.q)=0v v(X_MEM.X_cell_62_17.qb)=0.7v
.ic v(X_MEM.X_cell_62_18.q)=0v v(X_MEM.X_cell_62_18.qb)=0.7v
.ic v(X_MEM.X_cell_62_19.q)=0v v(X_MEM.X_cell_62_19.qb)=0.7v
.ic v(X_MEM.X_cell_62_20.q)=0v v(X_MEM.X_cell_62_20.qb)=0.7v
.ic v(X_MEM.X_cell_62_21.q)=0v v(X_MEM.X_cell_62_21.qb)=0.7v
.ic v(X_MEM.X_cell_62_22.q)=0v v(X_MEM.X_cell_62_22.qb)=0.7v
.ic v(X_MEM.X_cell_62_23.q)=0v v(X_MEM.X_cell_62_23.qb)=0.7v
.ic v(X_MEM.X_cell_62_24.q)=0v v(X_MEM.X_cell_62_24.qb)=0.7v
.ic v(X_MEM.X_cell_62_25.q)=0v v(X_MEM.X_cell_62_25.qb)=0.7v
.ic v(X_MEM.X_cell_62_26.q)=0v v(X_MEM.X_cell_62_26.qb)=0.7v
.ic v(X_MEM.X_cell_62_27.q)=0v v(X_MEM.X_cell_62_27.qb)=0.7v
.ic v(X_MEM.X_cell_62_28.q)=0v v(X_MEM.X_cell_62_28.qb)=0.7v
.ic v(X_MEM.X_cell_62_29.q)=0v v(X_MEM.X_cell_62_29.qb)=0.7v
.ic v(X_MEM.X_cell_62_30.q)=0v v(X_MEM.X_cell_62_30.qb)=0.7v
.ic v(X_MEM.X_cell_62_31.q)=0v v(X_MEM.X_cell_62_31.qb)=0.7v
.ic v(X_MEM.X_cell_63_0.q)=0v v(X_MEM.X_cell_63_0.qb)=0.7v
.ic v(X_MEM.X_cell_63_1.q)=0v v(X_MEM.X_cell_63_1.qb)=0.7v
.ic v(X_MEM.X_cell_63_2.q)=0v v(X_MEM.X_cell_63_2.qb)=0.7v
.ic v(X_MEM.X_cell_63_3.q)=0v v(X_MEM.X_cell_63_3.qb)=0.7v
.ic v(X_MEM.X_cell_63_4.q)=0v v(X_MEM.X_cell_63_4.qb)=0.7v
.ic v(X_MEM.X_cell_63_5.q)=0v v(X_MEM.X_cell_63_5.qb)=0.7v
.ic v(X_MEM.X_cell_63_6.q)=0v v(X_MEM.X_cell_63_6.qb)=0.7v
.ic v(X_MEM.X_cell_63_7.q)=0v v(X_MEM.X_cell_63_7.qb)=0.7v
.ic v(X_MEM.X_cell_63_8.q)=0v v(X_MEM.X_cell_63_8.qb)=0.7v
.ic v(X_MEM.X_cell_63_9.q)=0v v(X_MEM.X_cell_63_9.qb)=0.7v
.ic v(X_MEM.X_cell_63_10.q)=0v v(X_MEM.X_cell_63_10.qb)=0.7v
.ic v(X_MEM.X_cell_63_11.q)=0v v(X_MEM.X_cell_63_11.qb)=0.7v
.ic v(X_MEM.X_cell_63_12.q)=0v v(X_MEM.X_cell_63_12.qb)=0.7v
.ic v(X_MEM.X_cell_63_13.q)=0v v(X_MEM.X_cell_63_13.qb)=0.7v
.ic v(X_MEM.X_cell_63_14.q)=0v v(X_MEM.X_cell_63_14.qb)=0.7v
.ic v(X_MEM.X_cell_63_15.q)=0v v(X_MEM.X_cell_63_15.qb)=0.7v
.ic v(X_MEM.X_cell_63_16.q)=0v v(X_MEM.X_cell_63_16.qb)=0.7v
.ic v(X_MEM.X_cell_63_17.q)=0v v(X_MEM.X_cell_63_17.qb)=0.7v
.ic v(X_MEM.X_cell_63_18.q)=0v v(X_MEM.X_cell_63_18.qb)=0.7v
.ic v(X_MEM.X_cell_63_19.q)=0v v(X_MEM.X_cell_63_19.qb)=0.7v
.ic v(X_MEM.X_cell_63_20.q)=0v v(X_MEM.X_cell_63_20.qb)=0.7v
.ic v(X_MEM.X_cell_63_21.q)=0v v(X_MEM.X_cell_63_21.qb)=0.7v
.ic v(X_MEM.X_cell_63_22.q)=0v v(X_MEM.X_cell_63_22.qb)=0.7v
.ic v(X_MEM.X_cell_63_23.q)=0v v(X_MEM.X_cell_63_23.qb)=0.7v
.ic v(X_MEM.X_cell_63_24.q)=0v v(X_MEM.X_cell_63_24.qb)=0.7v
.ic v(X_MEM.X_cell_63_25.q)=0v v(X_MEM.X_cell_63_25.qb)=0.7v
.ic v(X_MEM.X_cell_63_26.q)=0v v(X_MEM.X_cell_63_26.qb)=0.7v
.ic v(X_MEM.X_cell_63_27.q)=0v v(X_MEM.X_cell_63_27.qb)=0.7v
.ic v(X_MEM.X_cell_63_28.q)=0v v(X_MEM.X_cell_63_28.qb)=0.7v
.ic v(X_MEM.X_cell_63_29.q)=0v v(X_MEM.X_cell_63_29.qb)=0.7v
.ic v(X_MEM.X_cell_63_30.q)=0v v(X_MEM.X_cell_63_30.qb)=0.7v
.ic v(X_MEM.X_cell_63_31.q)=0v v(X_MEM.X_cell_63_31.qb)=0.7v


* --- SIMULATION COMMANDS ---
.tran 10p 4.5n

* Désactiver l'interface binaire et imprimer en format texte sans sauts de page
.option post=0 nopage nomod

* On imprime le temps (implicite) et 5 signaux clés sur une seule ligne 
* pour faciliter la lecture par Python :
.print tran v(CLK) v(WEN) v(A_0)
.print tran v(BL_0) v(BLB_0) v(D_0) v(Q_0)
.print tran v(X_MEM.X_cell_0_0.q) v(X_MEM.X_cell_0_0.qb)

.end