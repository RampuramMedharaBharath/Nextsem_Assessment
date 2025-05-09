module axi_stream_tb;

    // Parameters
    parameter TDATA_WIDTH = 32;
    parameter CLK_PERIOD = 10;  // 100 MHz clock

    // Signals
    reg                     aclk = 0;
    reg                     aresetn = 0;
    reg [TDATA_WIDTH-1:0]   s_axis_tdata;
    reg [TDATA_WIDTH/8-1:0] s_axis_tkeep;
    reg                     s_axis_tvalid;
    reg                     s_axis_tlast;
    wire                    s_axis_tready;
    wire [TDATA_WIDTH-1:0]  m_axis_tdata;
    wire [TDATA_WIDTH/8-1:0] m_axis_tkeep;
    wire                    m_axis_tvalid;
    wire                    m_axis_tlast;
    reg                     m_axis_tready;
    reg [1:0]               mode;
    reg [TDATA_WIDTH-1:0]   constant_value;

    // Instantiate DUT
    axi_stream_processor #(
        .TDATA_WIDTH(TDATA_WIDTH)
    ) dut (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tkeep(s_axis_tkeep),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tready(s_axis_tready),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tkeep(m_axis_tkeep),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .mode(mode),
        .constant_value(constant_value)
    );

    // Clock generation
    always #(CLK_PERIOD/2) aclk = ~aclk;

    // Test procedure
    initial begin
        // Initialize signals
        aresetn = 0;
        s_axis_tdata = 0;
        s_axis_tkeep = 0;
        s_axis_tvalid = 0;
        s_axis_tlast = 0;
        m_axis_tready = 1;
        mode = 0;
        constant_value = 32'h0000000A;  // Constant = 10

        // Reset
        #20 aresetn = 1;

        // Test Mode 0: Pass-through
        $display("Testing Mode 0: Pass-through");
        mode = 2'd0;
        #20;
        s_axis_tdata = 32'hDEADBEEF;
        s_axis_tkeep = 4'hF;
        s_axis_tvalid = 1;
        s_axis_tlast = 0;
        #10;
        s_axis_tlast = 1;
        #10;
        s_axis_tvalid = 0;
        #20;

        // Test Mode 1: Byte reversal
        $display("Testing Mode 1: Byte reversal");
        mode = 2'd1;
        #20;
        s_axis_tdata = 32'h12;
        s_axis_tkeep = 4'hF;
        s_axis_tvalid = 1;
        s_axis_tlast = 0;
        #10;
        s_axis_tlast = 1;
        #10;
        s_axis_tvalid = 0;
        #20;

        // Test Mode 2: Add constant
        $display("Testing Mode 2: Add constant");
        mode = 2'd2;
        #20;
        s_axis_tdata = 32'h00000005;
        s_axis_tkeep = 4'hF;
        s_axis_tvalid = 1;
        s_axis_tlast = 0;
        #10;
        s_axis_tlast = 1;
        #10;
        s_axis_tvalid = 0;
        #20;

        // Test backpressure
        $display("Testing backpressure");
        mode = 2'd0;
        m_axis_tready = 0;  // Simulate downstream stall
        #20;
        s_axis_tdata = 32'h12345678;
        s_axis_tkeep = 4'hF;
        s_axis_tvalid = 1;
        s_axis_tlast = 0;
        #30;
        m_axis_tready = 1;  // Release backpressure
        #20;
        s_axis_tvalid = 0;
        #20;

        $display("Test completed");
        $finish;
    end

    // Monitor outputs
    always @(posedge aclk) begin
        if (m_axis_tvalid && m_axis_tready) begin
            $display("Output: TDATA=%h, TKEEP=%h, TLAST=%b", m_axis_tdata, m_axis_tkeep, m_axis_tlast);
        end
    end

endmodule
