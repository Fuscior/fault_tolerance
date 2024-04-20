`timescale 1ns / 1ps


module sw_debouncer_tb( );

localparam period =10.0; //clk period 

logic clk; 
logic rst; 
logic PB; //raw signal from switch

logic DEBOUNCED; //debounced signal


sw_debouncer U1(.*);
    
initial
    begin
        @(negedge clk); 
        rst = 0;
        PB = 0;
        @(negedge clk); 
        rst = 1;
        @(negedge clk); 
        rst = 0;

        @(negedge clk);
        PB = 1;
        @(negedge clk);
        PB = 0;
    end

initial
    begin
        clk= 1'b0;
        forever #(period/2) clk= ~clk;  //clock shape half of period
    end

//tasks

endmodule
