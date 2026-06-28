import sys
import os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

def parse_spice_val(s):
    s = s.strip().lower()
    if not s: return 0.0
    mults = {'f':1e-15,'p':1e-12,'n':1e-9,'u':1e-6,'m':1e-3,'k':1e3,'meg':1e6,'g':1e9,'t':1e12}
    for suff, m in mults.items():
        if s.endswith(suff):
            try: return float(s[:-len(suff)])*m
            except: pass
    try: return float(s)
    except: return 0.0

def read_lis(filename):
    with open(filename) as f: lines = f.readlines()
    data = {'v_in': [], 'v_out': []}
    in_table = False
    for line in lines:
        line = line.strip()
        if line == 'x': 
            in_table = True
            continue
        if line == 'y': 
            in_table = False
            continue
        if in_table:
            vals = line.split()
            if len(vals) == 3:
                try:
                    # check if the first token is a number
                    v_in_val = parse_spice_val(vals[0])
                    # If it didn't crash, and it's not a header word
                    if vals[0].lower() not in ['volt', 'voltage', 'q_out', 'qb_out']:
                        v_out1 = parse_spice_val(vals[1])
                        data['v_in'].append(v_in_val)
                        data['v_out'].append(v_out1)
                except:
                    pass
    return data

def calculate_snm(v_in, v_out):
    D = v_out - v_in
    max_S = 0.0
    best_i = 0
    best_j = 0
    
    for i in range(len(v_in)):
        if D[i] <= 0: continue
        K = D[i]
        
        # We need to find j such that D[j] == -K
        j = np.argmin(np.abs(D - (-K)))
        
        S = v_in[i] - v_out[j]
        if S > max_S:
            max_S = S
            best_i = i
            best_j = j
            
    # The square corners are derived from i (top-right on normal curve) 
    # and j (bottom-left on mirrored curve)
    sq_x = v_out[best_j] # bottom-left x
    sq_y = v_in[best_j]  # bottom-left y
    
    return max_S, sq_x, sq_y

def plot_butterfly():
    os.makedirs('results', exist_ok=True)
    d = read_lis('results/sram_snm.lis')
    
    if len(d['v_in']) == 0:
        print("Error: Could not parse VTC data from sram_snm.lis")
        sys.exit(1)
        
    v_in = np.array(d['v_in'])
    v_out = np.array(d['v_out'])
    
    plt.figure(figsize=(8,8))
    plt.plot(v_in, v_out, label='Inverter 1 VTC', linewidth=2, color='b')
    plt.plot(v_out, v_in, label='Inverter 2 VTC (Mirrored)', linewidth=2, color='r')
    
    snm, sq_x, sq_y = calculate_snm(v_in, v_out)
    
    # The square corners are (sq_x, sq_y), (sq_x+snm, sq_y), (sq_x+snm, sq_y+snm), (sq_x, sq_y+snm)
    square_x = [sq_x, sq_x+snm, sq_x+snm, sq_x, sq_x]
    square_y = [sq_y, sq_y, sq_y+snm, sq_y+snm, sq_y]
    plt.plot(square_x, square_y, 'g--', linewidth=2, label=f'Max Inscribed Square\n(SNM = {snm*1000:.2f} mV)')
    
    # Draw the inscribed square for the lower lobe (symmetric)
    square_x_lower = [sq_y, sq_y, sq_y+snm, sq_y+snm, sq_y]
    square_y_lower = [sq_x, sq_x+snm, sq_x+snm, sq_x, sq_x]
    plt.plot(square_x_lower, square_y_lower, 'g--', linewidth=2)
    
    plt.title(f"SRAM Read SNM Butterfly Curve", fontsize=16, fontweight='bold')
    plt.xlabel('Voltage (V)', fontsize=14)
    plt.ylabel('Voltage (V)', fontsize=14)
    plt.grid(True, linestyle=':', alpha=0.8)
    plt.legend(fontsize=12, loc='upper right')
    plt.xlim(0, 0.7)
    plt.ylim(0, 0.7)
    
    plt.tight_layout()
    plot_path = 'results/sram_butterfly.png'
    plt.savefig(plot_path, dpi=300)
    print(f"Saved plot to {plot_path} with SNM = {snm*1000:.2f} mV")

if __name__ == '__main__':
    plot_butterfly()
