import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def parse_spice_val(s):
    """Convert HSPICE values to Python float"""
    s = s.strip().lower()
    if not s: return 0.0
    multipliers = {'f': 1e-15, 'p': 1e-12, 'n': 1e-9, 'u': 1e-6, 'm': 1e-3,  'k': 1e3, 'meg': 1e6, 'g': 1e9, 't': 1e12}
    for suffix, mult in multipliers.items():
        if s.endswith(suffix):
            try: return float(s[:-len(suffix)]) * mult
            except ValueError: pass
    try: return float(s)
    except ValueError: return 0.0

def plot_hspice_lis(filename):
    time_data = []
    signals = {}
    
    with open(filename, 'r') as f:
        lines = f.readlines()
        
    in_table = False
    current_headers = []
    
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        if line == 'x':
            in_table = True
            current_headers = []
            i += 1
            continue
        if line == 'y':
            in_table = False
            i += 1
            continue
            
        if in_table:
            if line.startswith('time'):
                # Force to lowercase to simplify subsequent lookups
                current_headers = [h.lower() for h in lines[i+1].strip().split()]
                for sig in current_headers:
                    if sig not in signals: signals[sig] = []
                i += 2
                continue
            
            cols = line.split()
            if len(cols) == len(current_headers) + 1:
                t_val = parse_spice_val(cols[0])
                if len(time_data) < len(signals[current_headers[0]]) + 1:
                    time_data.append(t_val)
                for j, sig in enumerate(current_headers):
                    val = parse_spice_val(cols[j+1])
                    signals[sig].append(val)
        i += 1

    # --- DISPLAY SECTION (3 SUBPLOTS) ---
    fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(12, 10), sharex=True)
    
    # Plot 1: Control Signals
    if "clk" in signals: ax1.plot(time_data, signals["clk"], label="CLK", linestyle="--", color="gray")
    if "wen" in signals: ax1.plot(time_data, signals["wen"], label="WEN (Write=0, Read=1)", color="purple")
    if "a_0" in signals: ax1.plot(time_data, signals["a_0"], label="A_0 (Address)", color="orange")
    ax1.set_title("1. Global Control Signals")
    ax1.set_ylabel("Voltage (V)")
    ax1.legend(loc="upper right")
    ax1.grid(True, linestyle='--', alpha=0.6)

    # Figure 2: Bitlines, Input and Output
    if "d_0" in signals: ax2.plot(time_data, signals["d_0"], label="Data In (D_0)", color="brown", linestyle=":")
    if "bl_0" in signals: ax2.plot(time_data, signals["bl_0"], label="BL_0", color="blue")
    if "blb_0" in signals: ax2.plot(time_data, signals["blb_0"], label="BLB_0", color="red", linestyle="-.")
    if "q_0" in signals: ax2.plot(time_data, signals["q_0"], label="Sense Amp Out (Q_0)", color="green", linewidth=2)
    ax2.set_title("2. Bitlines and Data Signals (Peripherals)")
    ax2.set_ylabel("Voltage (V)")
    ax2.legend(loc="upper right")
    ax2.grid(True, linestyle='--', alpha=0.6)

    # Figure 3: Internal nodes of the 6T SRAM cell
    # The exact signal names depend on how HSPICE prints them; handle possible cases
    q_int = signals.get("v(x_mem.x_cell_0_0.q)") or signals.get("x_mem.x_cell_0_0.q")
    qb_int = signals.get("v(x_mem.x_cell_0_0.qb)") or signals.get("x_mem.x_cell_0_0.qb")
    
    if q_int: ax3.plot(time_data, q_int, label="Internal Cell (Q)", color="blue")
    if qb_int: ax3.plot(time_data, qb_int, label="Internal Cell (QB)", color="red", linestyle="--")
    ax3.set_title("3. Internal Latch of SRAM Cell (Row 0, Col 0)")
    ax3.set_ylabel("Voltage (V)")
    ax3.set_xlabel("Time (seconds)")
    ax3.legend(loc="center right")
    ax3.grid(True, linestyle='--', alpha=0.6)

    plt.tight_layout()
    plt.savefig("results/sram_waveforms.png", dpi=300) 
    plt.close()

if __name__ == "__main__":
    plot_hspice_lis("results/sram_sim.lis")
