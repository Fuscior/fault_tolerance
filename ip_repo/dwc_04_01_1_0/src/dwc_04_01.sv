//backup verilog

`timescale 1ns / 1ps
 
//todo 
//dwc enable logic, if off bypass DWC data_a to output
//error enable used lfsr as a mask to force errors

//fix vga bit lenght error
module dwc_04_01  (
    input logic         clk,
    input logic         rst,
    input logic         clear,
    input logic         data_set_a,
    input logic         data_set_b,
    input logic [31:0]  data_a,
    input logic [31:0]  data_b,
    input logic [31:0]  lfsr_mask,      //sudo random mask
    input logic         dwc_enable,     //enough compaire
    input logic         error_enable,   //enable mask to force erros

    output logic        interupt_0, 
    output logic        interupt_1,
    output logic        done,
    output logic        ready_0,
    output logic        ready_1,
    output logic        match,
    output logic [11:0] vga_output
);

typedef enum logic [2:0]{S0,S1,S2,S3}state_type;    //update to > 2 hamming distance
state_type current_state, next_state;

logic enable_compare;
logic dwc_bypass;

reg       reg_match;
reg       reg_done;
reg       reg_ready_0;
reg       reg_ready_1;
reg [11:0]reg_vga_output;    

always_comb
    begin
        interupt_0      <= 0;   
        interupt_1      <= 0;
        enable_compare  <= 0;

        case(current_state)
            S0:begin                    //initial state
                reg_done     <= 0;
                reg_ready_0  <= 0;
                reg_ready_1  <= 0;
                
                if(dwc_enable == 0) //bypass logic
                    dwc_bypass <= 1;   //test with white
                else
                    dwc_bypass <= 0;
                    
                if(data_set_a & data_set_b & dwc_enable) begin   //data writen 
                    reg_ready_0 <= 0;
                    reg_ready_1 <= 0;
                    next_state <= S1;
                end
                else
                    next_state <= S0;
            end

            S1:begin                    //initial state
                enable_compare <= 1;
                reg_done <= 1;

                next_state <= S2;
            end

            S2:begin                    //clear CPU_1
                interupt_1 <= 1;

                if(data_set_b == 0)begin
                    reg_ready_1 <= 1;
                    next_state <= S3;
                end
                else begin
                    reg_ready_1 <= 0;
                    next_state <= S2;
                end
            end
    
            S3:begin                    //clear CPU_0
                interupt_0 <= 1;

                if(data_set_a == 0)begin
                    reg_ready_0 <= 1;
                    next_state <= S0;
                    reg_done <= 0;
                end
                else begin
                    reg_ready_0 <= 0;
                    next_state <= S3;
                end
            end


            default: next_state <= S0;  //catch state

        endcase
    end



always_ff@(posedge clk) //next state on pos edge clk
begin
    if(enable_compare)
        if(data_a == data_b) begin
            reg_match       <= 1;
            reg_vga_output  <= data_a;
            end
        else
            begin
                reg_match <= 0;
                reg_vga_output  <= '1;
            end
end

always_ff@(posedge clk)
begin
    match           <= reg_match;
    done            <= reg_done;
    ready_0         <= reg_ready_0;
    ready_1         <= reg_ready_1;
    //vga_output      <= reg_vga_output;  
    
    if(dwc_bypass)
        vga_output <= '1;
    else
        vga_output <= reg_vga_output;  
end

always_ff@(posedge clk) //next state on pos edge clk
begin
    if(rst)
        current_state <= S0; 
    else
        current_state <= next_state;

    if(clear)
        current_state <= S0;
end
endmodule