# FPGA Trading System

A high-frequency trading (HFT) system implemented on an FPGA (Basys 3), designed to simulate real-world electronic trading under ultra-low latency constraints. This project emulates network packet flows, order matching, and risk control using Verilog-based hardware logic and UART communication. Along with the main modules, the project includes dedicated testbenches for each file to verify functionality, ensure correctness, and simulate realistic trading scenarios before deployment to hardware.


Key Features
TCP-like Packet Parsing

Price-Time Priority Matching Engine

Risk Management Controls

UART I/O for Trade Transmission

Modular & Testable Verilog Architecture
