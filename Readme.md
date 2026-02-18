# SHA1 Software–Hardware Co-Design

This project implements the SHA-1 hashing algorithm in both:

- Embedded C (for Nios II / FPGA system)
- SystemVerilog hardware state machine

The goal is to demonstrate software–hardware co-design and FPGA-based verification of a cryptographic hashing algorithm.

## Project Structure

- software/ → Embedded C implementation
- hardware/ → SystemVerilog RTL and testbench

## Features

- Full SHA-1 message padding
- 80-round compression function
- Hardware state machine implementation
- Testbench verification
