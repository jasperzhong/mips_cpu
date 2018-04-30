`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/29 20:36:27
// Design Name: 
// Module Name: mux4_1
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


module Mux4_1(
    input [31:0] iData1,
    input [31:0] iData2,
    input [31:0] iData3,
    input [31:0] iData4,
    input [1:0] sel,
    output [31:0] oData
    );
    
    assign oData = (sel == 2'b00)?iData1: 
                   (sel == 2'b01)?iData2:
                   (sel == 2'b10)?iData3:
                   iData4;
endmodule
