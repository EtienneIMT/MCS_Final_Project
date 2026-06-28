def generate_col_peripherals(filename="sp_files/col_peripherals.sp"):
    with open(filename, "w") as f:
        f.write("* ==========================================\n")
        f.write("* 16-Bit Column Peripherals for 2kb SRAM\n")
        f.write("* ==========================================\n\n")

        # ---------------------------------------------------------
        # STEP 1: Write Driver Subcircuit
        # ---------------------------------------------------------
        f.write("* --- Write Driver ---\n")
        f.write(".subckt WRITE_DRIVER D_in WEN BL BLB\n")
        f.write("Xinv_D D_in D_in_b INV\n")
        f.write("Xinv_WEN WEN WEN_b INV\n")
        f.write("Mn_w1 BLB WEN_b node1 GND nmos_sram m=32\n")
        f.write("Mn_w2 node1 D_in GND GND nmos_sram m=32\n")
        f.write("Mn_w3 BL WEN_b node2 GND nmos_sram m=32\n")
        f.write("Mn_w4 node2 D_in_b GND GND nmos_sram m=32\n")
        f.write(".ends\n\n")

        # ---------------------------------------------------------
        # STEP 2: Column MUX Subcircuits
        # ---------------------------------------------------------
        f.write("* --- Transmission Gate ---\n")
        f.write(".subckt TG IN OUT EN EN_B\n")
        f.write("Mp IN EN_B OUT VDD pmos_sram m=2\n")
        f.write("Mn IN EN   OUT GND nmos_sram m=2\n")
        f.write(".ends\n\n")

        f.write("* --- 1-to-2 Column MUX ---\n")
        f.write(".subckt COL_MUX A0 A0_B BL_0 BLB_0 BL_1 BLB_1 BL_int BLB_int\n")
        f.write("X_TG_BL0  BL_0  BL_int  A0_B A0 TG\n")
        f.write("X_TG_BLB0 BLB_0 BLB_int A0_B A0 TG\n")
        f.write("X_TG_BL1  BL_1  BL_int  A0 A0_B TG\n")
        f.write("X_TG_BLB1 BLB_1 BLB_int A0 A0_B TG\n")
        f.write(".ends\n\n")

        # ---------------------------------------------------------
        # FROM EX3: Sense Amplifier Subcircuit
        # ---------------------------------------------------------
        f.write("* --- Current-Mode Sense Amplifier (CMSA) ---\n")
        f.write(".subckt CMSA PRE SAEN BL BLB sense sense_b\n")
        f.write("Mpre_sa1 sense   PRE VDD VDD pmos_rvt m=2\n")
        f.write("Mpre_sa2 sense_b PRE VDD VDD pmos_rvt m=2\n")
        f.write("Meq_sa   sense   PRE sense_b VDD pmos_rvt m=2\n")
        f.write("Mpre_int1 int_l PRE VDD VDD pmos_rvt m=1\n")
        f.write("Mpre_int2 int_r PRE VDD VDD pmos_rvt m=1\n")
        f.write("Mpl sense   sense_b VDD    VDD pmos_rvt m=2\n")
        f.write("Mpr sense_b sense   VDD    VDD pmos_rvt m=2\n")
        f.write("Mnl sense   sense_b int_l  GND nmos_rvt m=2\n")
        f.write("Mnr sense_b sense   int_r  GND nmos_rvt m=2\n")
        f.write("Min_l int_l BLB tail_n GND nmos_rvt m=2\n")
        f.write("Min_r int_r BL  tail_n GND nmos_rvt m=2\n")
        f.write("Mtail tail_n SAEN GND GND nmos_rvt m=4\n")
        f.write(".ends\n\n")

        # ---------------------------------------------------------
        # STEP 3: Generate the 16 Data Bit blocks
        # ---------------------------------------------------------
        f.write("* ==========================================\n")
        f.write("* MAIN MACRO: 16-BIT COLUMN PERIPHERAL BLOCK\n")
        f.write("* ==========================================\n")
        
        # Define the massive subcircuit wrapper for the whole block
        f.write(".subckt COL_PERIPHERALS A0 A0_B PRE SAEN WEN \n")
        f.write("+ ")
        for i in range(32): f.write(f"BL_{i} BLB_{i} ") # 32 array columns
        f.write("\n+ ")
        for i in range(16): f.write(f"D_{i} ") # 16 Data inputs
        f.write("\n+ ")
        for i in range(16): f.write(f"Q_{i} Q_b_{i} ") # 16 Data outputs
        f.write("\n\n")

        for i in range(16):
            f.write(f"* --- BIT {i} ---\n")
            
            # Array Bitline Precharge (Must precharge all 32 array columns)
            f.write(f"Mpre1_{i} BL_{i} PRE VDD VDD pmos_sram m=2\n")
            f.write(f"Mpre2_{i} BLB_{i} PRE VDD VDD pmos_sram m=2\n")
            f.write(f"Meq_{i} BL_{i} PRE BLB_{i} VDD pmos_sram m=2\n")
            
            f.write(f"Mpre1_{i+16} BL_{i+16} PRE VDD VDD pmos_sram m=2\n")
            f.write(f"Mpre2_{i+16} BLB_{i+16} PRE VDD VDD pmos_sram m=2\n")
            f.write(f"Meq_{i+16} BL_{i+16} PRE BLB_{i+16} VDD pmos_sram m=2\n")

            # Column Multiplexer (Routes array columns to internal SA/Write driver)
            f.write(f"X_MUX_{i} A0 A0_B BL_{i} BLB_{i} BL_{i+16} BLB_{i+16} BL_int_{i} BLB_int_{i} COL_MUX\n")

            # Sense Amplifier (Read)
            f.write(f"X_SA_{i} PRE SAEN BL_int_{i} BLB_int_{i} Q_{i} Q_b_{i} CMSA\n")
            
            # Write Driver (Write)
            f.write(f"X_WD_{i} D_{i} WEN BL_int_{i} BLB_int_{i} WRITE_DRIVER\n\n")

        f.write(".ends COL_PERIPHERALS\n")
            
    print(f"Successfully generated {filename}!")

if __name__ == "__main__":
    generate_col_peripherals()
