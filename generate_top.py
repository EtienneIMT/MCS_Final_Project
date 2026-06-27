def generate_top(filename="Final_Project_Top.sp"):
    with open(filename, "w") as f:
        f.write("* ==========================================\n")
        f.write("* FINAL PROJECT TOP-LEVEL TESTBENCH (2kb SRAM)\n")
        f.write("* ==========================================\n\n")

        # 1. Includes and Setup
        f.write(".protect\n")
        f.write(".include '7nm_TT.pm'\n")
        f.write(".unprotect\n\n")
        
        f.write(".include 'sram_array_2kb.sp'\n")
        f.write(".include 'col_peripherals.sp'\n\n")
        
        f.write(".global VDD GND\n")
        f.write("Vdd VDD 0 0.7V\n\n")
        
        # 1.5 SRAM Core Cell
        f.write("* --- 1:1:1 SRAM Cell ---\n")
        f.write(".subckt SRAM WL BL BLB q qb\n")
        f.write("Mpr  q   qb  VDD  VDD  pmos_sram  m=1\n")
        f.write("Mnr  q   qb  GND  GND  nmos_sram  m=1\n")
        f.write("Mpl  qb  q   VDD  VDD  pmos_sram  m=1\n")
        f.write("Mnl  qb  q   GND  GND  nmos_sram  m=1\n")
        f.write("Mnpr BL  WL  q    GND  nmos_sram  m=1\n")
        f.write("Mnpl BLB WL  qb   GND  nmos_sram  m=1\n")
        f.write(".ends\n\n")

        # 2. Basic Gates (Used by Control Logic & Decoder)
        f.write("* --- Basic Logic Gates ---\n")
        f.write(".subckt INV IN OUT\n")
        f.write("Mp1 OUT IN VDD VDD pmos_sram W=54n L=20n\n")
        f.write("Mn1 OUT IN GND GND nmos_sram W=27n L=20n\n")
        f.write(".ends\n\n")

        f.write(".subckt INV_LARGE IN OUT\n")
        f.write("Mp1 OUT IN VDD VDD pmos_sram W=216n L=20n\n")
        f.write("Mn1 OUT IN GND GND nmos_sram W=108n L=20n\n")
        f.write(".ends\n\n")

        f.write(".subckt NAND2 A B OUT\n")
        f.write("Mp1 OUT A VDD VDD pmos_sram W=54n L=20n\n")
        f.write("Mp2 OUT B VDD VDD pmos_sram W=54n L=20n\n")
        f.write("Mn1 OUT A N1  GND nmos_sram W=54n L=20n\n")
        f.write("Mn2 N1  B GND GND nmos_sram W=54n L=20n\n")
        f.write(".ends\n\n")

        f.write(".subckt NAND3 A B C OUT\n")
        f.write("Mp1 OUT A VDD VDD pmos_sram W=54n L=20n\n")
        f.write("Mp2 OUT B VDD VDD pmos_sram W=54n L=20n\n")
        f.write("Mp3 OUT C VDD VDD pmos_sram W=54n L=20n\n")
        f.write("Mn1 OUT A N1  GND nmos_sram W=81n L=20n\n")
        f.write("Mn2 N1  B N2  GND nmos_sram W=81n L=20n\n")
        f.write("Mn3 N2  C GND GND nmos_sram W=81n L=20n\n")
        f.write(".ends\n\n")

        # 3. Global Control Logic
        f.write("* --- Global Control Logic ---\n")
        f.write(".subckt CONTROL_LOGIC CLK WEN PRE SAEN CLK_WL\n")
        f.write("* PRE follows CLK (CLK=0: Precharge, CLK=1: Evaluate)\n")
        f.write("Xinv1 CLK pre_b INV\n")
        f.write("Xinv2 pre_b PRE INV\n\n")
        
        f.write("* Delay CLK slightly for Wordline to ensure precharge is off\n")
        f.write("Xinv3 CLK wl_b INV\n")
        f.write("Xinv4 wl_b CLK_WL INV\n\n")
        
        f.write("* Delay CLK more for SAEN (Sense Amp Enable)\n")
        f.write("Xinv5 CLK d1 INV\n")
        f.write("Xinv6 d1 d2 INV\n")
        f.write("Xinv7 d2 d3 INV\n")
        f.write("Xinv8 d3 clk_del INV\n\n")
        
        f.write("* SAEN is active only during READ (WEN=0) AND delayed CLK=1\n")
        f.write("Xinv9 WEN WEN_b INV\n")
        f.write("Xnand1 clk_del WEN_b saen_b NAND2\n")
        f.write("Xinv10 saen_b SAEN INV\n")
        f.write(".ends\n\n")

        # 4. Re-packaged 6-to-64 Row Decoder (From your Ex2)
        f.write("* --- Row Decoder Subcircuit (From Ex2) ---\n")
        f.write(".subckt ROW_DECODER A0 A1 A2 A3 A4 A5 CLK_IN ")
        for i in range(64): f.write(f"WL_{i} ")
        f.write("\n")
        f.write("Xbuf_clk CLK_IN clk_bar INV\n")
        f.write("Xbuf_clk2 clk_bar clk_buf INV\n")
        for i in range(6):
            f.write(f"Xbuf_a{i}_1 A{i} A_bar_{i} INV\n")
            f.write(f"Xbuf_a{i}_2 A_bar_{i} A_{i}_buf INV\n")
        
        def write_3to8(name, A0, A1, A2, A0_b, A1_b, A2_b, out_prefix):
            logic_table = [
                (A0_b, A1_b, A2_b), (A0, A1_b, A2_b), (A0_b, A1, A2_b), (A0, A1, A2_b),
                (A0_b, A1_b, A2),   (A0, A1_b, A2),   (A0_b, A1, A2),   (A0, A1, A2)
            ]
            for i, (in0, in1, in2) in enumerate(logic_table):
                f.write(f"X_PD_{name}_NAND_{i} {in0} {in1} {in2} {out_prefix}_nand_{i} NAND3\n")
                f.write(f"X_PD_{name}_INV_{i} {out_prefix}_nand_{i} {out_prefix}_{i} INV\n")
                
        write_3to8("1", "A_0_buf", "A_1_buf", "A_2_buf", "A_bar_0", "A_bar_1", "A_bar_2", "P1")
        write_3to8("2", "A_3_buf", "A_4_buf", "A_5_buf", "A_bar_3", "A_bar_4", "A_bar_5", "P2")
        
        for i in range(64):
            p1_idx = i % 8
            p2_idx = i // 8
            f.write(f"X_Final_NAND_{i} P1_{p1_idx} P2_{p2_idx} clk_buf WL_NAND_OUT_{i} NAND3\n")
            f.write(f"X_Final_INV_{i} WL_NAND_OUT_{i} WL_{i} INV_LARGE\n")
        f.write(".ends\n\n")

        # 5. Top Level Instantiations
        f.write("* --- TOP LEVEL INSTANTIATION ---\n")
        f.write("X_CTRL CLK WEN PRE SAEN CLK_WL CONTROL_LOGIC\n\n")
        
        # Note: A[6:1] control the Row Decoder (64 rows). A[0] controls the Col MUX.
        f.write("X_DEC A_1 A_2 A_3 A_4 A_5 A_6 CLK_WL ")
        for i in range(64): f.write(f"WL_{i} ")
        f.write("ROW_DECODER\n\n")

        f.write("X_MEM ")
        for i in range(64): f.write(f"WL_{i} ")
        for i in range(32): f.write(f"BL_{i} BLB_{i} ")
        f.write("SRAM_ARRAY\n\n")

        # Create A_0_B for the peripheral
        f.write("Xinv_A0 A_0 A_0_B INV\n")
        f.write("X_PERIPH A_0 A_0_B PRE SAEN WEN ")
        for i in range(32): f.write(f"BL_{i} BLB_{i} ")
        for i in range(16): f.write(f"D_{i} ")
        for i in range(16): f.write(f"Q_{i} Q_b_{i} ")
        f.write("COL_PERIPHERALS\n\n")

        # 6. Test Vectors & Stimuli
        f.write("* --- TEST STIMULI (4 Cycles) ---\n")
        f.write("* 1GHz Clock (1ns period, 50ps rise/fall as per spec)\n")
        f.write("Vclk CLK 0 PULSE(0 0.7 0 50p 50p 0.45n 1n)\n\n")
        
        f.write("* Cycle 1 (0-1ns): Write '1's to Address 0 (Row 0, Col 0)\n")
        f.write("* Cycle 2 (1-2ns): Write '0's to Address 1 (Row 0, Col 1)\n")
        f.write("* Cycle 3 (2-3ns): Read Address 0 (Expect '1's)\n")
        f.write("* Cycle 4 (3-4ns): Read Address 1 (Expect '0's)\n\n")
        
        # Write Enable (High during 0-2ns for writes, Low during 2-4ns for reads)
        f.write("Vwen WEN 0 PWL(0 0.7  1.9n 0.7  1.95n 0  4n 0)\n")
        
        # Address 0 toggles at 1ns (selects between Col 0 and Col 1)
        f.write("Va0 A_0 0 PWL(0 0  0.9n 0  0.95n 0.7  1.9n 0.7  1.95n 0  2.9n 0  2.95n 0.7  4.5n 0.7)\n")
        # Row Address stays 0 (A_1 to A_6 = 0)
        for i in range(1, 7):
            f.write(f"Va{i} A_{i} 0 DC 0V\n")
            
        # Data Inputs (Write 1 in Cycle 1, Write 0 in Cycle 2)
        for i in range(16):
            f.write(f"Vd{i} D_{i} 0 PWL(0 0.7  0.9n 0.7  0.95n 0  4n 0)\n")
            
        # --- INITIAL CONDITIONS ---
        f.write("* --- INITIAL CONDITIONS ---\n")
        
        # 1. Precharge all array bitlines to VDD
        for i in range(32):
            f.write(f".ic v(BL_{i})=0.7v v(BLB_{i})=0.7v\n")
            
        # 2. Precharge internal Mux bitlines to VDD
        for i in range(16):
            f.write(f".ic v(X_PERIPH.BL_int_{i})=0.7v v(X_PERIPH.BLB_int_{i})=0.7v\n")
            
        # 3. Initialize all 2048 SRAM cells to a known state (store '0')
        for r in range(64):
            for c in range(32):
                f.write(f".ic v(X_MEM.X_cell_{r}_{c}.q)=0v v(X_MEM.X_cell_{r}_{c}.qb)=0.7v\n")
        f.write("\n")
            
        f.write("\n* --- SIMULATION COMMANDS ---\n")
        f.write(".tran 10p 4.5n\n\n")

        f.write("* Tell HSPICE to only save the nodes we explicitly probe\n")
        f.write(".option post=2 probe=1\n\n")

        f.write("* 1. Probe Global Clocks & Controls\n")
        f.write(".probe tran v(CLK) v(WEN) v(PRE) v(SAEN) v(CLK_WL)\n")
        f.write(".probe tran v(A_0)\n\n")

        f.write("* 2. Probe Wordline 0 (The only row activated in this test)\n")
        f.write(".probe tran v(WL_0)\n\n")

        f.write("* 3. Probe the Array Bitlines for Bit 0 (Col 0 and Col 16)\n")
        f.write(".probe tran v(BL_0) v(BLB_0)\n")
        f.write(".probe tran v(BL_16) v(BLB_16)\n\n")

        f.write("* 4. Probe the Internal Muxed Bitlines for Sense Amp 0 / Write Driver 0\n")
        f.write(".probe tran v(X_PERIPH.BL_int_0) v(X_PERIPH.BLB_int_0)\n\n")

        f.write("* 5. Probe the Data Input and Sense Amp Output for Bit 0\n")
        f.write(".probe tran v(D_0) v(Q_0)\n\n")

        f.write("* 6. Probe the Internal Storage Nodes of the targeted SRAM cells!\n")
        f.write("* Cell at Row 0, Col 0 (Address 0)\n")
        f.write(".probe tran v(X_MEM.X_cell_0_0.q) v(X_MEM.X_cell_0_0.qb)\n")
        f.write("* Cell at Row 0, Col 16 (Address 1)\n")
        f.write(".probe tran v(X_MEM.X_cell_0_16.q) v(X_MEM.X_cell_0_16.qb)\n")

    print(f"Successfully generated {filename}! (The Top-Level Testbench)")

if __name__ == "__main__":
    generate_top()
