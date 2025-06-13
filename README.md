# ✨ Pipelined MIPS Processor + Factorial Accelerator + GPIO SoC ✨

---

## 🎯 Purpose

Convert a basic 15-instruction, 32-bit single-cycle MIPS processor into a **5-stage pipelined design**.  
Then, hook it up with a **factorial accelerator** and a simple **GPIO unit** using memory-mapped registers.

---

## 🛠 What’s Inside?

This project is all about building a tiny **System-on-Chip (SoC)** that includes:

- 🚀 A 5-stage pipelined MIPS processor  
- 🔢 A factorial accelerator (handles 4-bit inputs)  
- 🎛️ A simple GPIO unit for input/output  

All connected through the MIPS local bus with memory-mapped interfaces.

---

## 🔍 Details & Features

- Built on an **enhanced single-cycle MIPS** supporting these cool instructions:  
  `multu`, `mfhi`, `mflo`, `jr`, `jal`, `sll`, `srl`  
- Runs a factorial test program using nested procedure calls — stress testing the pipeline!  
- Handles **data & control hazards** with forwarding and stalling to keep things smooth.  
- GPIO reads the input number `n` and outputs the factorial `n!`.  

---

## 📊 What I Achieved

- Designed & verified the pipelined datapath and control units.  
- Built a hazard detection and forwarding unit to minimize stalls.  
- Integrated the factorial accelerator & GPIO through memory-mapped registers.  
- Compared performance between software-only and hardware-accelerated factorial calculations.  
- Created graphs showing how the runtime changes with different input sizes.

---

## 🛠 How to Run / Simulate

1. Open your favorite simulator (Vivado, ModelSim, etc.)  
2. Load all Verilog source files + testbenches  
3. Run the simulation & check waveforms for correctness  

---

## 📚 Future Plans

- Add multiply/divide instructions support  
- Improve hazard detection & pipeline efficiency  
- Expand SoC with more peripherals & accelerators  
- Try real FPGA implementation!

---

✌️ *Thanks for checking out my project!*  
If you want to chat about MIPS or SoCs, hit me up!

---

**— Het Bhalala**  
*Computer Engineering Graduate Student*  
*github.com/Het-Bhalala*

