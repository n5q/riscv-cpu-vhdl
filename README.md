
Implemtation of a **32-bit RISC-V processor** in VHDL, for both **single-cycle** and **multi-cycle** architectures

## Features
- **Single-cycle RISC-V core**
  - Executes each instruction in one clock cycle
  - Includes instruction memory, control unit, datapath, ALU, and register file
- **Multi-cycle RISC-V core**
  - Breaks instruction execution into multiple stages across clock cycles
  - Implements a FSM–based controller
  - Shares hardware resources (ALU, memory, regs) across stages for efficiency

## Architecture Overview
- **Control Units**
  - Single-cycle controller for direct instruction decoding
  - Multi-cycle controller implemented as a FSM
- **Datapath**
  - 32-bit ALU  
  - Register file with read/write support  
  - Program counter and adders  
  - Multiplexers and tri-state buffers  
  - Immediate extension unit  
