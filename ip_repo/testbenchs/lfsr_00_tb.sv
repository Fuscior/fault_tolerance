`timescale 1ns / 1ps

module lfsr_00_tb( );

localparam period =10.0; //clk period 

logic        clk;
logic        rst;
logic        lfsr_enable;

logic [31:0] lfsr_mask;

lfsr_00 U1(.*);

initial
    begin
        @(negedge clk);
        rst <= 0;
        @(negedge clk);
        rst <= 1;
        @(negedge clk);
        rst <= 0;
        
    end

   
initial
    begin
        clk= 1'b0;
        forever #(period/2) clk= ~clk;  //clock shape half of period
    end

endmodule
