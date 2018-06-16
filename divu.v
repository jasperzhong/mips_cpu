`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/03 01:31:03
// Design Name: 
// Module Name: DIVU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Divu(
    input [31:0] dividend,
    input [31:0] divisor,
    input start,
    input clock,
    input reset,
    output [31:0] q,
    output [31:0] r,
    output reg busy
    );
    wire ready;
    reg[4:0] count;
    reg[31:0] tmp_q;
    reg[31:0] tmp_r;
    reg[31:0] tmp_b;
    reg tmp_sign;
    wire[32:0] sub_add = tmp_sign?({tmp_r,q[31]} + {1'b0, tmp_b}):({tmp_r,q[31]} - {1'b0, tmp_b});
    assign r = tmp_sign?tmp_r + tmp_b:tmp_r;
    assign q = tmp_q;
    always @(negedge clock or posedge reset) begin
        if(reset) begin
            count <= 0;
            busy <= 0;
        end else begin
            if(start) begin
                tmp_r <= 0;
                tmp_sign <= 0;
                tmp_q <= dividend;
                tmp_b <= divisor;
                count <= 0;
                busy <= 1;
            end else if(busy) begin
                tmp_r <= sub_add[31:0];
                tmp_sign <= sub_add[32];
                tmp_q <= {tmp_q[30:0],~sub_add[32]};
                count <= count + 1;
                if(count == 31) busy <= 0;
            end
        end
    end
endmodule

