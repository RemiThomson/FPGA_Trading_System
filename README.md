# FPGA Trading System

A high-frequency trading (HFT) system implemented on an FPGA (Basys 3), designed to simulate real-world electronic trading under ultra-low latency constraints. This project emulates network packet flows, order matching, and risk control using Verilog-based hardware logic and UART communication. Along with the main modules, the project includes dedicated testbenches for each file to verify functionality, ensure correctness, and simulate realistic trading scenarios before deployment to hardware.


## Key Features

- TCP-like Packet Parsing

- Price-Time Priority Matching Engine

- Risk Management Controls

- UART I/O for Trade Transmission

- Modular & Testable Verilog Architecture

## Project Structure

hft_fpga_system/

├── hft_fpga_system.srcs/

│ ├── sources_1/

│ │ └── new/

│ │ ├── order_matching_engine.v

│ │ ├── tcp_ip_stack.v
│ │ ├── ethernet_layer.v
│ │ ├── ip_layer.v
│ │ ├── tcp_layer.v
│ │ ├── custom_ip_core.v
│ │ ├── axi_stream_if.v
│ │ ├── risk_management.v
│ │ └── top_level.v
│ ├── constrs_1/
│ │ └── new/
│ │ └── timing_constraints.xdc
│ └── sim_1/
│ └── new/
│ ├── tb_order_matching_engine.v
│ ├── tb_tcp_ip_stack.v
│ ├── tb_custom_ip_core.v
│ ├── tb_risk_management.v
│ └── tb_top_level.v
├── hft_fpga_system.xpr



