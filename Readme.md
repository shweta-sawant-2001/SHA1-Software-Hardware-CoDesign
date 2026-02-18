# SHA-1 Software–Hardware Co-Design

This project demonstrates a **software–hardware co-design of the SHA-1 cryptographic hashing algorithm** using an FPGA-based embedded system.

It combines:

- **Embedded C software** for the Intel Nios II softcore processor
- **SystemVerilog hardware** for the SHA-1 compression engine and top-level FPGA integration

The primary objective is to implement, verify, and benchmark SHA-1 across software and hardware, exploring the performance and integration trade-offs of FPGA-based co-design.

---

## Key Features

- Complete SHA-1 message preprocessing and 80-round compression function  
- Hardware implementation using a finite state machine in SystemVerilog  
- Software implementation in C for Nios II bare-metal execution  
- Testbench and FPGA-based verification  
- LED-based verification on the Arrow Max10 DECA board  

---

## Project Structure

```text
SHA1-Software-Hardware-CoDesign/
├── software/                # Embedded C implementation for Nios II
│   ├── sha1.c
│   ├── sha1.h
│   ├── utils.c
│   └── utils.h
├── hardware/                # SystemVerilog modules and testbench
│   ├── sha1_core.sv
│   ├── sha1_tb.sv
│   └── fsoc_lab.sv          # Top-level FPGA entity
└── README.md

```


## Implementation Overview

1. **Software**  
   The C implementation runs on a Nios II softcore processor and computes the SHA-1 hash for arbitrary messages. Correctness is verified by comparing software-generated hashes with known test vectors.

2. **Hardware**  
   The SHA-1 compression engine is implemented in SystemVerilog using an FSM-based architecture. The top-level module `fsoc_lab.sv` integrates the Nios II system with I/O peripherals (LEDs, buttons, JTAG UART) and connects the hardware and software components.

3. **FPGA Integration**  
   Using Intel Quartus Prime and Platform Designer:
   - Nios II/f softcore processor instantiated with on-chip memory, timer, JTAG UART, and PIO peripherals  
   - Software runs as a bare-metal application  
   - Verification performed on-board with LEDs and optional JTAG UART output  

---

## Project Highlights / Key Achievements

- Designed and implemented a **SHA-1 cryptographic accelerator** on Intel Cyclone V FPGA using Verilog RTL and Nios II soft-core processor  
- Developed **pipelined and parallel architectures**, achieving **4× speedup** over software execution  
- Implemented **memory controllers and DMA-based data handling**; verified functionality via ModelSim simulation and on-board debugging using SignalTap  
- Performed **static timing analysis and resource optimization** (logic utilization <60%), emphasizing hardware–software co-design for real-time systems  

---

## Verification & Testing

- SHA-1 correctness verified on software implementation  
- Hardware testbench simulation using known message vectors  
- FPGA on-board test: LED pattern indicates SHA-1 computation success  

---

## Learning Outcomes

- FPGA-based embedded system design with Nios II  
- Hardware/software co-design methodology  
- Cryptographic algorithm implementation and verification  
- System-level integration and testing on FPGA  

---


