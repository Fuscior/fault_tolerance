`timescale 1ns / 1ps

module dwc_V3_03_tb( );

localparam period =10.0; //clk period 

logic clk,reset;
logic [31:0]data_a, data_b; //32bit data in from mBlaze
logic [31:0]data_set;       //when mb loads data its flag
logic [31:0]ack;          //mb got resut

logic [31:0]isMatch;    //compare flag 
logic [31:0]done;       //comparitor finished     

logic interupt_prompt;  //promt MB to check regs

dwc_V3_03 U1(.*);

initial
    begin
        clk= 1'b0;
        forever #(period/2) clk= ~clk;  //clock shape half of period
    end
    
initial
    begin
        @(negedge clk);
        reset=0;
        data_a=0;
        data_b=0;
        ack=0;
        
        @(negedge clk); // match
        data_a=255;
        @(negedge clk);
        data_set=1;
        @(negedge clk); 
        data_b=255;
        @(negedge clk);
        data_set=2;
        @(negedge clk);
        data_set=3;
        
        @(negedge clk);
        data_set=0;
        @(negedge clk);
        ack=1;
        @(negedge clk);
        ack=0;
        
        @(negedge clk); // no match
        data_a=111;
        @(negedge clk);
        data_set=1;
        @(negedge clk); 
        data_b=255;
        @(negedge clk);
        data_set=2;
        @(negedge clk);
        data_set=3;
        
        @(negedge clk);
        data_set=0;
        @(negedge clk);
        ack=1;
        @(negedge clk);
        ack=0;
        
        @(negedge clk); // match
        data_a=255;
        @(negedge clk);
        data_set=1;
        @(negedge clk); 
        data_b=255;
        @(negedge clk);
        data_set=2;
        @(negedge clk);
        data_set=3;
        
        @(negedge clk);
        data_set=0;
        @(negedge clk);
        ack=1;
        @(negedge clk);
        ack=0;


        

    end
endmodule