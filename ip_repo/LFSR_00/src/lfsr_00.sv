`timescale 1ns / 1ps
//32 bit Linear Feedback Shift Register (LFSR)
//pseudo-random sequence generator 

//enable this end or mask side?
//might need to reg value?

module lfsr_00  (
    input logic         clk,
    input logic         rst,
    //input logic         lfsr_enable,

    output logic [31:0] lfsr_mask
);

reg reg_lfsr_mask[31:0];

always_ff@(posedge clk)
begin
    if(rst)
        lfsr_mask <='1;
    else
        lfsr_mask = {lfsr_mask[30:0], (lfsr_mask[31]^lfsr_mask[30]) };   
end

endmodule