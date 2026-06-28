# SRAM 1:1:1 Configuration Report

**Goal**: Revert the SRAM cell schematic to match a pre-existing 1:1:1 physical layout and verify 1GHz operation by heavily over-sizing peripheral drivers.

## 1. SRAM Cell Sizing
The 6T SRAM cell has been explicitly reverted to a **1:1:1 configuration**. All transistor sizing parameters in the cell have been forced to `m=1`:
- Pull-Up (Mpr, Mpl): `m=1`
- Pass-Gate (Mnpr, Mnpl): `m=1`
- Pull-Down (Mnr, Mnl): `m=1` (reverted from `m=2`)

## 2. Peripheral Driver Compensation Sizes
To forcefully drive the 1:1:1 cells and prevent slow transitions or read-upsets, the peripheral drivers have been aggressively up-sized. Please use the following parameters when you draw the physical layout for the peripherals:

### **WRITE_DRIVER (Bitline Drivers)**
- Multiplier: `m=32`
- Applied to all four NMOS forcing transistors (`Mn_w1` to `Mn_w4`) to pull bitlines to GND as rapidly as possible.

### **INV_LARGE (Wordline Drivers)**
- PMOS Width: `W=864n` (Length `L=20n`)
- NMOS Width: `W=432n` (Length `L=20n`)
- Used in the final stage of the row decoder to forcefully switch the massive Wordline RC load.

## 3. Performance Verification (1GHz)
With the above aggressive peripheral sizing, the 2kb SRAM array comfortably passes the 1GHz timing constraints (1ns period, 0.45ns pulse width).

**Final Delays (Measured via HSPICE):**
- **Write '1' Delay**: 55.47 ps
- **Write '0' Delay**: 46.84 ps
- **Read '1' Access Time ($t_{AA}$)**: 85.24 ps
- **Read '0' Access Time ($t_{AA}$)**: 88.64 ps

All read and write operations conclude in less than 90ps, leaving an immense timing margin well within the required 450ps window.

*Waveforms have been updated and plotted to `results/sram_waveforms.png`.*
