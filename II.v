`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/29 19:48:30
// Design Name: 
// Module Name: II
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


module II(
    input [3:0] pc,
    input [25:0] index,
    output [31:0] addr
    );
    assign addr={pc,index, 2'b0};
endmodule
