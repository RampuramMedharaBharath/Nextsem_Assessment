# Nextsem_Assessment
AXI_Stream
Overview
The AXI-Stream Processor is a parameterizable Verilog module that processes AXI-Stream data with a selectable TDATA width (32 or 64 bits). It supports three modes controlled via AXI-Lite registers: pass-through, byte reversal, and constant addition. The module ensures proper AXI-Stream protocol compliance, including backpressure, TLAST, and TKEEP handling.
Architecture
•	Input Stage: Accepts AXI-Stream data (TDATA, TKEEP, TLAST, TVALID) and handles backpressure using TREADY.
•	Processing Stage: Selects the operation based on the AXI-Lite mode register:
o	Mode 0: Passes TDATA unchanged.
o	Mode 1: Reverses byte order within each word using a function.
o	Mode 2: Adds a constant (from AXI-Lite register) to TDATA.
•	Output Stage: Drives the AXI-Stream master interface with processed data, propagating TKEEP and TLAST.
•	Control: AXI-Lite interface provides two registers: mode (2 bits) and constant (TDATA_WIDTH bits).
Assumptions
•	AXI-Lite interface is simplified to direct register inputs for simulation.
•	TSTRB is assumed equivalent to TKEEP (common in AXI-Stream).
•	Input data is aligned to the TDATA width.
•	Clock frequency is assumed to be 100 MHz for timing analysis.
Optimizations
•	Pipelining: Single-cycle processing to minimize latency.
•	Resource Sharing: Byte reversal uses a combinatorial function to avoid LUT overhead.
•	Backpressure: Efficient TREADY handling to prevent stalls.
•	Parameterization: TDATA_WIDTH parameter allows reuse for 32/64-bit systems.

Synthesis Results (Artix-7 XC7A100T)
•	Resource Utilization (estimated):
o	LUTs: ~150 (32-bit), ~250 (64-bit) due to wider data paths.
o	FFs: ~100 (32-bit), ~150 (64-bit) for registers.
o	No DSPs or BRAMs used.
•	Timing:
o	Critical path: Byte reversal logic (combinatorial).
o	Max frequency: >200 MHz (meets 100 MHz target).
•	Tools: Vivado 2023.2 (assumed for estimation).
Verification
•	Testbench: Simulates all modes, backpressure, and edge cases (e.g., TLAST, partial TKEEP).
•	Coverage: Tests mode transitions, constant addition overflow, and backpressure stalls.
•	Edge Cases: Handles reset, invalid mode values (defaults to pass-through).
Potential Improvements
•	Add pipeline registers for higher clock frequencies.
•	Implement full AXI-Lite slave interface for real-world integration.
•	Support unaligned TDATA transfers.
Block Diagram
The block diagram (as shown in the first image) illustrates the module's interfaces:
•	Inputs:
o	AXI-Stream Slave: s_axis_tdata[31:0], s_axis_tkeep[3:0], s_axis_tlast, s_axis_tvalid, s_axis_tready.
o	AXI-Lite Control: constant_value[31:0], mode[1:0].
o	Clock and Reset: aclk, aresetn.
•	Outputs:
o	AXI-Stream Master: m_axis_tdata[31:0], m_axis_tkeep[3:0], m_axis_tlast, m_axis_tvalid, m_axis_tready.
The module processes input data based on the selected mode and forwards the result to the master interface, adhering to AXI-Stream handshaking.

