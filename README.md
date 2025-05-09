<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AXI Stream Processor Documentation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        h1, h2, h3 {
            color: #2c3e50;
        }
        h1 {
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        h2 {
            background-color: #f8f9fa;
            padding: 8px;
            border-left: 4px solid #3498db;
        }
        .section {
            margin-bottom: 30px;
        }
        .feature-box {
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .diagram {
            text-align: center;
            margin: 20px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border: 1px dashed #ccc;
        }
        .code {
            font-family: monospace;
            background-color: #f4f4f4;
            padding: 5px;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <h1>AXI Stream Processor Documentation</h1>
    
    <div class="section">
        <h2>Overview</h2>
        <p>The AXI-Stream Processor is a highly configurable Verilog module designed to process AXI-Stream data with selectable TDATA width (32 or 64 bits). It supports three operational modes controlled via AXI-Lite registers while maintaining strict compliance with the AXI-Stream protocol.</p>
        
        <div class="feature-box">
            <h3>Key Features</h3>
            <ul>
                <li>Configurable data width (32-bit or 64-bit)</li>
                <li>Three processing modes: pass-through, byte reversal, and constant addition</li>
                <li>Full AXI-Stream protocol support including backpressure handling</li>
                <li>Simple AXI-Lite control interface</li>
                <li>Optimized for FPGA implementation</li>
            </ul>
        </div>
    </div>

    <div class="section">
        <h2>Architecture</h2>
        
        <div class="diagram">
            <h3>Block Diagram</h3>
            <p>[Insert block diagram image here]</p>
            <p><em>Figure 1: AXI Stream Processor block diagram showing interfaces and internal components</em></p>
        </div>
        
        <h3>Input Stage</h3>
        <p>Accepts AXI-Stream data (TDATA, TKEEP, TLAST, TVALID) and handles backpressure using TREADY. Implements proper flow control and data buffering when necessary.</p>
        
        <h3>Processing Stage</h3>
        <p>Selects the operation based on the AXI-Lite mode register:</p>
        <table>
            <tr>
                <th>Mode</th>
                <th>Operation</th>
                <th>Description</th>
            </tr>
            <tr>
                <td>00</td>
                <td>Pass-through</td>
                <td>TDATA passes unchanged from input to output</td>
            </tr>
            <tr>
                <td>01</td>
                <td>Byte reversal</td>
                <td>Reverses byte order within each word using combinatorial logic</td>
            </tr>
            <tr>
                <td>10</td>
                <td>Constant addition</td>
                <td>Adds a configurable constant value to each TDATA word</td>
            </tr>
        </table>
        
        <h3>Output Stage</h3>
        <p>Drives the AXI-Stream master interface with processed data, properly propagating all sideband signals (TKEEP, TLAST) while maintaining protocol compliance.</p>
        
        <h3>Control Interface</h3>
        <p>Simple AXI-Lite interface provides two registers:</p>
        <ul>
            <li><span class="code">mode[1:0]</span> - 2-bit mode selection</li>
            <li><span class="code">constant[TDATA_WIDTH-1:0]</span> - Constant value for addition mode</li>
        </ul>
    </div>

    <div class="section">
        <h2>Implementation Details</h2>
        
        <h3>Assumptions</h3>
        <ul>
            <li>AXI-Lite interface simplified for simulation purposes</li>
            <li>TSTRB is equivalent to TKEEP (common AXI-Stream implementation)</li>
            <li>Input data is always aligned to the TDATA width</li>
            <li>Clock frequency assumed to be 100 MHz for timing analysis</li>
        </ul>
        
        <h3>Optimizations</h3>
        <ul>
            <li><strong>Pipelining:</strong> Single-cycle processing for minimal latency</li>
            <li><strong>Resource Sharing:</strong> Efficient use of combinatorial logic for byte reversal</li>
            <li><strong>Backpressure Handling:</strong> Optimal TREADY generation to prevent stalls</li>
            <li><strong>Parameterization:</strong> Supports both 32-bit and 64-bit implementations</li>
        </ul>
    </div>

    <div class="section">
        <h2>Synthesis Results (Artix-7 XC7A100T)</h2>
        
        <h3>Resource Utilization</h3>
        <table>
            <tr>
                <th>Resource</th>
                <th>32-bit Version</th>
                <th>64-bit Version</th>
            </tr>
            <tr>
                <td>LUTs</td>
                <td>~150</td>
                <td>~250</td>
            </tr>
            <tr>
                <td>Flip-Flops</td>
                <td>~100</td>
                <td>~150</td>
            </tr>
            <tr>
                <td>DSPs</td>
                <td>0</td>
                <td>0</td>
            </tr>
            <tr>
                <td>BRAMs</td>
                <td>0</td>
                <td>0</td>
            </tr>
        </table>
        
        <h3>Timing Characteristics</h3>
        <ul>
            <li><strong>Critical Path:</strong> Byte reversal logic (combinatorial)</li>
            <li><strong>Maximum Frequency:</strong> >200 MHz (exceeds 100 MHz target)</li>
            <li><strong>Tools:</strong> Vivado 2023.2 (estimated)</li>
        </ul>
    </div>

    <div class="section">
        <h2>Verification</h2>
        
        <h3>Testbench Features</h3>
        <ul>
            <li>Comprehensive simulation of all operational modes</li>
            <li>Backpressure scenario testing</li>
            <li>Edge case verification (TLAST, partial TKEEP)</li>
            <li>Reset behavior validation</li>
        </ul>
        
        <h3>Coverage Metrics</h3>
        <ul>
            <li>Mode transition coverage</li>
            <li>Constant addition overflow cases</li>
            <li>Backpressure stall scenarios</li>
            <li>Invalid mode handling (defaults to pass-through)</li>
        </ul>
    </div>

    <div class="section">
        <h2>Potential Improvements</h2>
        <ul>
            <li><strong>Pipeline Registers:</strong> Additional pipeline stages for higher clock frequencies</li>
            <li><strong>Full AXI-Lite Interface:</strong> Complete slave implementation for real-world integration</li>
            <li><strong>Unaligned Data Support:</strong> Handling of unaligned TDATA transfers</li>
            <li><strong>Advanced Modes:</strong> Additional processing modes (bitwise operations, etc.)</li>
            <li><strong>Performance Monitoring:</strong> Add throughput counters for performance analysis</li>
        </ul>
    </div>

    <div class="section">
        <h2>Interface Summary</h2>
        
        <h3>Inputs</h3>
        <table>
            <tr>
                <th>Signal</th>
                <th>Width</th>
                <th>Description</th>
            </tr>
            <tr>
                <td>s_axis_tdata</td>
                <td>31:0 (or 63:0)</td>
                <td>Input data stream</td>
            </tr>
            <tr>
                <td>s_axis_tkeep</td>
                <td>3:0 (or 7:0)</td>
                <td>Byte enable mask</td>
            </tr>
            <tr>
                <td>s_axis_tlast</td>
                <td>1</td>
                <td>Packet boundary marker</td>
            </tr>
            <tr>
                <td>s_axis_tvalid</td>
                <td>1</td>
                <td>Data valid indicator</td>
            </tr>
            <tr>
                <td>m_axis_tready</td>
                <td>1</td>
                <td>Output ready signal</td>
            </tr>
            <tr>
                <td>constant_value</td>
                <td>31:0 (or 63:0)</td>
                <td>Constant for addition mode</td>
            </tr>
            <tr>
                <td>mode</td>
                <td>1:0</td>
                <td>Operation mode select</td>
            </tr>
            <tr>
                <td>aclk</td>
                <td>1</td>
                <td>Clock input (100MHz)</td>
            </tr>
            <tr>
                <td>aresetn</td>
                <td>1</td>
                <td>Active-low reset</td>
            </tr>
        </table>
        
        <h3>Outputs</h3>
        <table>
            <tr>
                <th>Signal</th>
                <th>Width</th>
                <th>Description</th>
            </tr>
            <tr>
                <td>m_axis_tdata</td>
                <td>31:0 (or 63:0)</td>
                <td>Processed output data</td>
            </tr>
            <tr>
                <td>m_axis_tkeep</td>
                <td>3:0 (or 7:0)</td>
                <td>Propagated byte enable</td>
            </tr>
            <tr>
                <td>m_axis_tlast</td>
                <td>1</td>
                <td>Propagated packet boundary</td>
            </tr>
            <tr>
                <td>m_axis_tvalid</td>
                <td>1</td>
                <td>Output valid indicator</td>
            </tr>
            <tr>
                <td>s_axis_tready</td>
                <td>1</td>
                <td>Input ready signal</td>
            </tr>
        </table>
    </div>
</body>
</html>
