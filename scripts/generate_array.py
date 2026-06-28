def generate_sram_array(filename="sp_files/sram_array_2kb.sp"):
    with open(filename, "w") as f:
        f.write("* ==========================================\n")
        f.write("* 2kb SRAM Array (64 Rows x 32 Columns)\n")
        f.write("* Total: 2048 bits\n")
        f.write("* ==========================================\n\n")

        # Start Subcircuit definition
        f.write(".subckt SRAM_ARRAY \n")
        
        # Define Wordline ports (WL_0 to WL_63)
        f.write("+ ")
        for r in range(64):
            f.write(f"WL_{r} ")
            if (r + 1) % 8 == 0:
                f.write("\n+ ")
        
        # Define Bitline ports (BL_0, BLB_0 to BL_31, BLB_31)
        for c in range(32):
            f.write(f"BL_{c} BLB_{c} ")
            if (c + 1) % 4 == 0:
                f.write("\n+ ")
        
        f.write("\n\n")

        # Instantiate the 2048 SRAM cells
        f.write("* --- SRAM Cell Instantiations ---\n")
        for row in range(64):
            f.write(f"* ROW {row}\n")
            for col in range(32):
                # Format: X_cell_row_col WL BL BLB q qb SRAM
                f.write(f"X_cell_{row}_{col} WL_{row} BL_{col} BLB_{col} q_{row}_{col} qb_{row}_{col} SRAM\n")
            f.write("\n")

        f.write(".ends SRAM_ARRAY\n")

    print(f"Successfully generated {filename}! (64x32 Array)")

if __name__ == "__main__":
    generate_sram_array()
