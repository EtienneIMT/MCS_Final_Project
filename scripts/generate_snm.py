import os

def generate_snm(filename="sp_files/sram_snm.sp"):
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, "w") as f:
        f.write("* ==========================================\n")
        f.write("* SRAM SNM (Static Noise Margin) TESTBENCH\n")
        f.write("* ==========================================\n\n")

        f.write(".protect\n")
        f.write(".include '7nm_TT.pm'\n")
        f.write(".unprotect\n\n")
        
        f.write(".global VDD GND\n")
        f.write("Vdd VDD 0 0.7V\n\n")

        # 1. Broken-Loop SRAM Cell for SNM
        # Mpr/Mnr (Right Inverter): Input is qb_in, Output is q_out
        # Mpl/Mnl (Left Inverter): Input is q_in, Output is qb_out
        f.write("* --- Broken-Loop 1:1:2 SRAM Cell ---\n")
        f.write(".subckt SRAM_BROKEN WL BL BLB q_in qb_out qb_in q_out\n")
        # Right Inverter (driven by qb_in, outputs q_out)
        f.write("Mpr  q_out   qb_in  VDD  VDD  pmos_sram  m=1\n")
        f.write("Mnr  q_out   qb_in  GND  GND  nmos_sram  m=2\n") # optimized m=2
        # Left Inverter (driven by q_in, outputs qb_out)
        f.write("Mpl  qb_out  q_in   VDD  VDD  pmos_sram  m=1\n")
        f.write("Mnl  qb_out  q_in   GND  GND  nmos_sram  m=2\n") # optimized m=2
        # Access Transistors
        f.write("Mnpr BL  WL  q_out   GND  nmos_sram  m=1\n")
        f.write("Mnpl BLB WL  qb_out  GND  nmos_sram  m=1\n")
        f.write(".ends\n\n")

        # 2. Top Level Instantiation
        f.write("X_CELL WL BL BLB q_in qb_out qb_in q_out SRAM_BROKEN\n\n")

        # 3. Biasing for READ SNM
        f.write("* Read operation: WL=VDD, BL=VDD, BLB=VDD\n")
        f.write("Vwl WL 0 0.7V\n")
        f.write("Vbl BL 0 0.7V\n")
        f.write("Vblb BLB 0 0.7V\n\n")

        # 4. DC Sweep Sources
        # We sweep Vsweep from 0 to 0.7V.
        # To get the VTC of both inverters simultaneously, we connect Vsweep to both inputs.
        # Since the cell is symmetric, q_out and qb_out will be identical functions of Vsweep.
        f.write("Vsweep Vsweep 0 0V\n")
        f.write("E1 q_in 0 Vsweep 0 1\n")
        f.write("E2 qb_in 0 Vsweep 0 1\n\n")

        # 5. Simulation Commands
        f.write(".dc Vsweep 0 0.7 0.001\n")
        f.write(".option post=2 probe=1\n")
        f.write(".print dc v(q_out) v(qb_out)\n")

    print(f"Successfully generated {filename}!")

if __name__ == "__main__":
    generate_snm()
