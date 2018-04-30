`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/29 19:48:30
// Design Name: 
// Module Name: Ext18
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


module Ext18(
    input [15:0] iData,
    output [31:0] oData
    );
    assign oData = {{14{iData[15]}}, iData, 2'b0};
endmodule
