`timescale 1ns / 1ps


module dwc_04_01_tb( );

localparam period =10.0; //clk period 

logic         clk;
logic         rst;
logic         clear;
logic         data_set_a;
logic         data_set_b;
logic [31:0]  data_a;
logic [31:0]  data_b;
logic [31:0]  lfsr_mask;      //sudo random mask

logic         dwc_enable;     //enough compaire
logic         error_enable;   //enable mask to force erros

logic        interupt_0; 
logic        interupt_1;
logic        done;
logic        ready_0;
logic        ready_1;
logic        match;
logic [11:0] vga_output;

logic [31:0]A;  //inters tb
logic [31:0]B;
logic [31:0]dwc_en;
logic [31:0]error_en;

dwc_04_01 U1(.*);
    
initial
    begin
        @(negedge clk); //multi 1
        reset();

        @(negedge clk); 
        lfsr_mask= '1;

        @(negedge clk); 
        dwc_en<=0;
        error_en<=1;
        A<=555;
        B<=55;
        @(negedge clk); 
        write_sycn(dwc_en, error_en, A,B);
        

        @(negedge clk); 
        dwc_en<=0;
        error_en<=0;
        A<=5;
        B<=5;
        @(negedge clk); 
        write_sycn(dwc_en, error_en, A,B);

        @(negedge clk); 
        dwc_en<=1;
        error_en<=1;
        A<=55;
        B<=55;
        @(negedge clk); 
        write_sycn(dwc_en, error_en, A,B);

        @(negedge clk); 
        dwc_en<=0;
        error_en<=1;
        A<=55;
        B<=55;
        @(negedge clk); 
        write_sycn(dwc_en, error_en, A,B);


        @(negedge clk); 
        dwc_en<=1;
        error_en<=0;
        A<=55;
        B<=55;
        @(negedge clk); 
        write_sycn(dwc_en, error_en, A,B);

        @(negedge clk); 
        data_a <= 5;
        data_b <=7;

        @(negedge clk); 
        data_set_a<=1;
        data_set_b<=1;

        

        @(negedge clk); 
        data_set_a<=0;
        data_set_b<=0;


    end

initial
    begin
        clk= 1'b0;
        forever #(period/2) clk= ~clk;  //clock shape half of period
    end

//tasks
    task reset();
        @(negedge clk);
        data_set_a <= '0;
        data_set_b <= '0;
        data_a  <= '0;
        data_b  <= '0;  
        dwc_enable <= '0;
        error_enable<= '0;
        #50@(negedge clk);

    endtask

    task write_sycn(
        input logic [31:0]dwc_enable_inter,
        input logic [31:0]error_enable_inter,

        input logic [31:0]A,
        input logic [31:0]B
        );

        @(negedge clk);
        dwc_enable <= dwc_enable_inter;
        error_enable<= error_enable_inter;
        @(negedge clk);
        data_a<= A;
        @(negedge clk);
        data_set_a<=1;

        @(negedge clk);
        data_b<= B;
        @(negedge clk);
        data_set_b<=1;

        #50@(negedge clk);
        data_set_a <= '0;
        data_set_b <= '0;

    endtask
    
endmodule
