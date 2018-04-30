`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/29 19:48:30
// Design Name: 
// Module Name: Ext16
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


module Ext16(
    input [15:0] iData,
    input s_ext_s,
    output [31:0] oData
    );
    assign oData = s_ext_s?{{16{iData[15]}},iData}:{16'b0, iData};
endmodule
