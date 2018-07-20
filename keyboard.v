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
    
    reg [3:0] cnt;
    reg [7:0] data_cur;
    reg [7:0] data_pre;
    
    always @(negedge kclk) begin
        case (cnt)
            1: ;
            2: data_cur[0] <= kdata;
            3: data_cur[1] <= kdata;
            4: data_cur[2] <= kdata;
            5: data_cur[3] <= kdata;
            6: data_cur[4] <= kdata;
            7: data_cur[5] <= kdata;
            8: data_cur[6] <= kdata;
            9: data_cur[7] <= kdata;
            10:kb_ready <= 1'b1;
            11:kb_ready <= 1'b0;
        endcase
        
        if(cnt <= 10)
            cnt <= cnt + 4'h1;
        else
            cnt <= 4'h1;
    end
    
    always @(posedge kb_ready) begin
        if(data_cur == 8'hf0) 
            kb_data <= data_pre;
        else
            data_pre <= data_cur;
    end
endmodule
