`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/03 05:39:27
// Design Name: 
// Module Name: mux16_1
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


module Mux16_1(
    input [31:0] iData1,
    input [31:0] iData2,
    input [31:0] iData3,
    input [31:0] iData4,
    input [31:0] iData5,
    input [31:0] iData6,
    input [31:0] iData7,
    input [31:0] iData8,
    input [31:0] iData9,
    input [31:0] iData10,
    input [31:0] iData11,
    input [31:0] iData12,
    input [31:0] iData13,
    input [31:0] iData14,
    input [31:0] iData15,
    input [31:0] iData16,       
    input [3:0] sel,
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
            8: oData = iData9;
            9: oData = iData10;
            10: oData = iData11;
            11: oData = iData12;
            12: oData = iData13;
            13: oData = iData14;
            14: oData = iData15;
            15: oData = iData16;      
        endcase
    end
endmodule
