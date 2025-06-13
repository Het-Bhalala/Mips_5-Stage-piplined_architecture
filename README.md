# MIPS 5-Stage Pipelined Architecture

This project implements a 5-stage pipelined MIPS processor in Verilog, designed to enhance instruction throughput using classic pipeline stages and hazard handling mechanisms. The design includes support for data forwarding and hazard detection to minimize pipeline stalls and improve performance.

## Pipeline Stages
The processor follows the standard 5-stage pipeline:
1. **IF (Instruction Fetch)**: Fetches the instruction from memory.
2. **ID (Instruction Decode)**: Decodes the instruction and reads register operands.
3. **EX (Execute)**: Performs arithmetic/logic operations or computes addresses.
4. **MEM (Memory Access)**: Accesses data memory for load/store instructions.
5. **WB (Write Back)**: Writes the result back to the register file.

## Key Features
- ✅ **Data forwarding** to resolve data hazards without unnecessary stalls.
- ✅ **Hazard detection unit** for load-use hazard handling.
- ✅ Support for:
  - R-type instructions (ADD, SUB, AND, OR, SLT, etc.)
  - I-type instructions (LW, SW, BEQ, BNE, etc.)
  - J-type instructions (JUMP)
- ✅ Branch handling with pipeline flushing on taken branches.
- ✅ Modular design (separate datapath, control unit, forwarding unit, hazard detection).

## Project Structure
