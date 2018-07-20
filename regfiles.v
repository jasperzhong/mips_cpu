`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/26 23:24:31
// Design Name: 
// Module Name: array
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


module Regfiles(
    input clk,
    input rst,
    input we,
    input [4:0] raddr1,
    input [4:0] raddr2,
    input [4:0] waddr,
    input [31:0] wdata,
    output [31:0] rdata1,
    output [31:0] rdata2
    );
    
    reg [31:0] array [31:0];
    
    assign rdata1 = array[raddr1];
    assign rdata2 = array[raddr2];
    
    always @(negedge clk or posedge rst) begin
        if(rst) begin
            array[0] = 32'b0; array[16] = 32'b0; 
            array[1] = 32'b0; array[17] = 32'b0; 
            array[2] = 32'b0; array[18] = 32'b0; 
            array[3] = 32'b0; array[19] = 32'b0; 
            array[4] = 32'b0; array[20] = 32'b0; 
            array[5] = 32'b0; array[21] = 32'b0; 
            array[6] = 32'b0; array[22] = 32'b0; 
            array[7] = 32'b0; array[23] = 32'b0; 
            array[8] = 32'b0; array[24] = 32'b0; 
            array[9] = 32'b0; array[25] = 32'b0; 
            array[10] = 32'b0; array[26] = 32'b0; 
            array[11] = 32'b0; array[27] = 32'b0; 
            array[12] = 32'b0; array[28] = 32'b0; 
            array[13] = 32'b0; array[29] = 32'b0; 
            array[14] = 32'b0; array[30] = 32'b0; 
            array[15] = 32'b0; array[31] = 32'b0;         
        end
        else if(we == 1 && waddr != 5'b00000) // reg 0 is always zero
            array[waddr] = wdata;
    end
    
endmodule
