# NIGHTLY REPORT: 2kb SRAM Design Verification and Iterations

## Overview
This report details the automated verification and code modifications performed overnight to advance the 2kb SRAM project (128x16 array size, 64x32 physical array). The core functionality, sizing constraints, and signal propagation were audited, corrected, and verified through HSPICE simulations executed on the remote server.

## Iterations and Corrections

### 1. Verification of the 128x16 Architecture
- **Logical vs. Physical:** The specs dictate a 128x16 SRAM. However, standard design constraints allocate 6 bits (A[6:1]) for the row decoder (64 rows) and 1 bit (A[0]) for the column decoder (MUX=2). Therefore, the physical array was correctly generated as 64 rows by 32 columns. No structural changes were needed to the base 64x32 grid to fulfill the 128x16 logical requirement.
- **Path Bug Fixes:** Removed relative path assignments (`../sp_files`) in the Python scripts and standardized to `sp_files/` to ensure successful automated builds from the project's root directory (`FP/`).

### 2. Implementation of Input Buffers (Infinite Drive Prevention)
- **Constraint:** The specifications require that all input data pass through the smallest buffer to prevent infinite driving ability.
- **Fix:** Added a new `.subckt BUFFER IN OUT` comprising two cascaded minimum-sized inverters. The ideal voltage sources (`Vclk`, `Vwen`, `Va`, `Vd`) were renamed to feed into these buffers before driving the top-level testbench.

### 3. WEN (Write Enable) Logic Correction
- **Bug:** `generate_top.py` and `generate_columns.py` previously defined `WEN=1` for writes and `WEN=0` for reads. The project guidelines explicitly define `WEN=0` for write and `WEN=1` for read.
- **Fix:** 
  - Restructured the internal write driver (`WRITE_DRIVER`) to operate on `WEN_b` (inverted WEN) during writes.
  - Corrected the top-level testbench stimuli to drive `WEN=0` during Write cycles (0-2ns) and `WEN=0.7V` during Read cycles (2-4ns).
  - Modified the Sense Amp Enable (SAEN) control logic to properly activate on `WEN=1` (Read).

### 4. Waveform & Plotting Diagnostics
- **Bug:** `plot_waveforms.py` was failing in the headless SSH environment due to Matplotlib's default X11 Tkinter backend. Additionally, `sram_sim.lis` lacked the printed transient table data necessary for plotting because `.probe tran` was used instead of `.print tran`.
- **Fix:** 
  - Forced Matplotlib to use the `Agg` headless backend.
  - Replaced `.probe tran` with `.print tran` in `generate_top.py`.
  - Adjusted the output path in `plot_waveforms.py` to correctly drop the PNG in `results/`.
  
## Final Metrics and Simulation Results
- **Simulation Time:** ~20s CPU time per transient run (4.5ns window).
- **Target Frequency:** 1GHz (1ns period, 0.45ns pulse width, 50ps rise/fall times).
- **Functionality Checked:** 
  - Cycle 1 (0-1ns): Successful write of `1` to Address 0.
  - Cycle 2 (1-2ns): Successful write of `0` to Address 1.
  - Cycle 3 (2-3ns): Successful read from Address 0.
  - Cycle 4 (3-4ns): Successful read from Address 1.
- **Output:** The plotted waveforms have been generated successfully and saved at `results/sram_waveforms.png`.

## Next Steps
1. **Delay & Timing Analysis:** While functionality operates correctly at 1GHz, we need to extract the exact access times (t_AA) to ensure the CMSA correctly triggers and resolves within the 1ns period limit. We may need to add `.measure` statements in `generate_top.py` for automated extraction.
2. **Post-Layout Simulation:** Once the schematic is completely tuned, layout parasitic extraction (PEX) can be initiated to verify timing constraints with RC parasitics.
3. **Power Analysis:** Average dynamic power and static leakage power can be extracted for full design characterization.
