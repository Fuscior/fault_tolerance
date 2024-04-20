`timescale 1ns / 1ps

module axi_lite_master_tb;

    // Signal declarations for S00_AXI
    logic S00_ACLK, S00_ARESETN;
    logic [31:0] S00_AXI_awaddr, S00_AXI_wdata, S00_AXI_araddr, S00_AXI_rdata;
    logic [2:0] S00_AXI_awprot, S00_AXI_arprot;
    logic S00_AXI_awvalid, S00_AXI_wvalid, S00_AXI_arvalid;
    logic S00_AXI_awready, S00_AXI_wready, S00_AXI_arready, S00_AXI_rready;
    logic [3:0] S00_AXI_wstrb;
    logic [1:0] S00_AXI_bresp, S00_AXI_rresp;
    logic S00_AXI_bvalid, S00_AXI_bready, S00_AXI_rvalid;
    // S01_AXI
    logic [31:0] S01_AXI_awaddr, S01_AXI_wdata, S01_AXI_araddr, S01_AXI_rdata;
    logic [2:0] S01_AXI_awprot, S01_AXI_arprot;
    logic S01_AXI_awvalid, S01_AXI_awready, S01_AXI_wvalid, S01_AXI_wready;
    logic [3:0] S01_AXI_wstrb;
    logic [1:0] S01_AXI_bresp, S01_AXI_rresp;
    logic S01_AXI_bvalid, S01_AXI_bready, S01_AXI_arvalid, S01_AXI_arready, S01_AXI_rvalid, S01_AXI_rready;
  
    // design specific signals
    logic PB_0;
    logic PB_1;
    logic PB_2;
    logic DEBOUNCED_0;
    logic DEBOUNCED_1;
    logic DEBOUNCED_2;
    logic interupt_0;
    logic interupt_1;
    logic hsync_0;
    logic vsync_0;
    logic [11:0] rgb_0;
    logic usb_uart_txd;
    logic usb_uart_rxd;

    // Clock generation
    always #5 S00_ACLK = ~S00_ACLK;

    axi_with_ip U1(.*);

    initial begin
        // Initialize signals
        PB_0 = 0;
        PB_1 = 0;
        PB_2 = 0;
        usb_uart_rxd = 0;
        // common clock and reset
        S00_ACLK = 0;
        S00_ARESETN = 1;
        // S00
        S00_AXI_awaddr = 0;
        S00_AXI_wdata = 0;
        S00_AXI_araddr = 0;
        S00_AXI_awprot = 0;
        S00_AXI_arprot = 0;
        S00_AXI_wstrb = 4'hF; // Assuming all bytes are valid
        // S01
        S01_AXI_awaddr = 0;
        S01_AXI_wdata = 0;
        S01_AXI_araddr = 0;
        S01_AXI_awprot = 0;
        S01_AXI_arprot = 0;
        S01_AXI_wstrb = 4'hF;

        // Reset pulse
        #10 S00_ARESETN = 1;
        #10 S00_ARESETN = 0;
        #20 S00_ARESETN = 1;

        // Wait for reset deassertion
        wait(S00_ARESETN);
        wait(S00_ACLK);

        //read operation
        axi_read_S00(32'h44A0_0000);
        axi_read_S00(32'h44A0_0004);

        //write operation
        axi_write_S00(32'h44A0_0000, 32'hDEADBEEF);
        axi_write_S00(32'h44A0_0004, 32'hBA53B411);

        //read operation
        axi_read_S00(32'h44A0_0000);
        axi_read_S00(32'h44A0_0004);

        #100;
        //$finish;
    end

    // Write task simplified to just initiate write operation
    task axi_write_S00(input logic [31:0] addr, input logic [31:0] data); begin
            S00_AXI_awaddr = addr;
            S00_AXI_wdata = data;
            S00_AXI_awvalid = 1'b1;
            S00_AXI_wvalid = 1'b1;
            S00_AXI_wstrb = 4'hF; // Assuming all bytes are valid
            $display("Writing 0x%08X to addr 0x%08X", data, addr);
            wait(S00_AXI_awready);
            wait(S00_AXI_wvalid == 0);
        end
    endtask

    // Read task simplified to just initiate read operation
    task axi_read_S00(input logic [31:0] addr); begin
            S00_AXI_araddr = addr;
            S00_AXI_arvalid = 1'b1;
            wait(S00_AXI_rready);
            wait(S00_AXI_rready == 0);
        end
    endtask

    always @(posedge S00_AXI_rready) begin
        $display("Reading 0x%08X at addr 0x%08X", S00_AXI_rdata, S00_AXI_araddr);
    end

    // Continuous monitoring for write and read acknowledgements
    always_ff @(posedge S00_ACLK) begin
        if (S00_ARESETN) begin
            // Write acknowledgement
            if (S00_AXI_awready && S00_AXI_awvalid) begin
                S00_AXI_awvalid <= 1'b0; // Completing write address phase
            end
            if (S00_AXI_wready && S00_AXI_wvalid) begin
                S00_AXI_wvalid <= 1'b0; // Completing write data phase
            end
            if (S00_AXI_bvalid) begin
                S00_AXI_bready <= 1'b1; // Completing write response phase
            end else begin
                S00_AXI_bready <= 1'b0;
            end
            
            // Read acknowledgement
            if (S00_AXI_arready && S00_AXI_arvalid) begin
                S00_AXI_arvalid <= 1'b0; // Completing read address phase
            end
            if (S00_AXI_rvalid) begin
                S00_AXI_rready <= 1'b1; // Ready to accept read data
                // Optionally capture read data here
            end else begin
                S00_AXI_rready <= 1'b0;
            end
        end else begin
            // Reset logic
            S00_AXI_awvalid <= 0;
            S00_AXI_wvalid <= 0;
            S00_AXI_arvalid <= 0;
            S00_AXI_bready <= 0;
            S00_AXI_rready <= 0;
        end
    end

    // S01_AXI write and read channel handling
    always_ff @(posedge S00_ACLK) begin
        if (S00_ARESETN) begin
            // Write acknowledgement
            if (S01_AXI_awready && S01_AXI_awvalid) begin
                S01_AXI_awvalid <= 1'b0; // Completing write address phase
            end
            if (S01_AXI_wready && S01_AXI_wvalid) begin
                S01_AXI_wvalid <= 1'b0; // Completing write data phase
            end
            if (S01_AXI_bvalid) begin
                S01_AXI_bready <= 1'b1; // Completing write response phase
            end else begin
                S01_AXI_bready <= 1'b0;
            end
            
            // Read acknowledgement
            if (S01_AXI_arready && S01_AXI_arvalid) begin
                S01_AXI_arvalid <= 1'b0; // Completing read address phase
            end
            if (S01_AXI_rvalid) begin
                S01_AXI_rready <= 1'b1; // Ready to accept read data
                // Optionally capture read data here
            end else begin
                S01_AXI_rready <= 1'b0;
            end
        end else begin
            // Reset logic
            S01_AXI_awvalid <= 0;
            S01_AXI_wvalid <= 0;
            S01_AXI_arvalid <= 0;
            S01_AXI_bready <= 0;
            S01_AXI_rready <= 0;
        end
    end

endmodule
