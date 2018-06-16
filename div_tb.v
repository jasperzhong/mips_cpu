`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/16 03:34:02
// Design Name: 
// Module Name: div_tb
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


module div_tb();
    reg clk;
    reg [31:0] dividend, divisor;
    wire [31:0] q, v;
    reg start, rst;
    wire busy;
    always #5 clk=~clk;
    
    Div div(dividend, divisor, start&~busy, clk, rst, q, v, busy);
    initial begin
    start = 1;
    clk = 0;
    rst = 1;
    dividend = 8;
    divisor = 32'hffff_fffd;
    #20
    rst = 0;

    end

endmodule
