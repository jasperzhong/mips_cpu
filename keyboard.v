`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/17 02:48:01
// Design Name: 
// Module Name: Keyboard
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


module Keyboard(
    input clk,
    input kclk,
    input kdata,
    input rst,
    input keyboard_cs,
    output reg [7:0] kb_data,
    output reg kb_ready
    );
    
    reg isBreak;
    reg [3:0] cnt;
    reg [10:0] datacur;
    
    always @ (negedge kclk or posedge rst) begin
        if(rst) begin
            kb_data = 0;
            cnt = 0;
            isBreak = 0;
            kb_ready = 1'b0;
        end
        else 
        if(isBreak == 1'b1) begin
            datacur[cnt] = kdata;
            cnt = cnt + 1;
            if(cnt == 11) cnt = 0;
            if(cnt == 0) begin
                kb_data = datacur[8:1];
                kb_ready = 1'b1;
                isBreak = 0;
            end
        end
        else begin
            datacur[cnt] = kdata;
            cnt = cnt + 1;
            if(cnt == 11) cnt = 0;
            if (datacur[8:1] == 8'hF0) isBreak = 1;
        end
    end
endmodule
