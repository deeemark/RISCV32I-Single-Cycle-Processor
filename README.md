# RV32I Single-Cycle CPU (SystemVerilog)

A fully functional RV32I single-cycle RISC-V CPU implemented in SystemVerilog, with byte/halfword/word memory access,
sign & zero extension, misalignment detection, and hex-file program loading.

---

## Features

### Core Architecture

- RV32I base integer instruction set
- Single-cycle datapath
- 32 × 32-bit register file (x0 hardwired to zero)
- Modular design (ALU, control, branch unit, PC selector, etc.)

### ISA

- R-type(`ADD`, `SUB`, `SLL`, `SOR`, `SRL`, `SRA`, `OR`, `AND`, `LR.D`, `SC.D`)
- I-type(`ADDI`, `SLLI`, `XORI`, `SRLI`, `SRAI`, `ORI`, `ANDI`, `LB`, `LH`, `LW`, `LBU`, `LHU`, `JALR`)
- S-type(`SB`, `SH`, `SW`)
- SB-type(`BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`)
- U-type(`LUI`, `AUIPC`)
- UJ-type(JAL)

### Memory System

- Instruction memory loaded from `.hex` file using `$readmemh`
- Data memory with:
  - Byte (`LB`, `LBU`, `SB`)
  - Halfword (`LH`, `LHU`, `SH`)
  - Word (`LW`, `SW`)
  - Signed and unsigned loads
  - Misalignment detection and stall

### Control & Execution

- Full control unit + ALU control
- Branch comparator (BEQ, BNE, BLT, BGE, etc.)
- PC source mux (PC+4, branch target, jump target)
- Write-back mux (ALU, memory, PC+4)

### Verification

- Self-checking testbench
- Register & memory dump at end of execution
- Cycle-by-cycle tracing
- Misaligned access detection

---

## How Programs Are Loaded

Instruction memory uses:

```systemverilog
$readmemh("program.hex", mem);
```

Each line in the hex file is one 32-bit instruction.

---

## Reset Behavior

- Register file cleared on reset
- Data memory cleared on reset
- PC reset to `0x00000000`

---

## Running Simulation

1. Place your program in `program.hex`
2. Run behavioral simulation

---

## Future Improvements

- 5-stage pipeline
- Multi-cycle instructions
- Hazard detection & forwarding
- Exception handling
- Cache integration
- Formal verification

---

## License

MIT

by DeMarkus Taylor
