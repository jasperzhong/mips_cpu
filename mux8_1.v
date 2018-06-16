`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/29 20:36:27
// Design Name: 
// Module Name: mux2_1
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


module Mux8_1(
    input [31:0] iData1,
    input [31:0] iData2,
    input [31:0] iData3,
    input [31:0] iData4,
    input [31:0] iData5,
    input [31:0] iData6,
    input [31:0] iData7,
    input [31:0] iData8,
    input [2:0] sel,
    output reg [31:0] oData
    );
    always @(*) begin
        case(sel)
            0: oData = iData1;
            1: oData = iData2;
            2: oData = iData3;
            3: oData = iData4;
            4: oData = iData5;
            5: oData = iData6;
            6: oData = iData7;
            7: oData = iData8;    
        endcase
    end
endmodule
