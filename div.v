`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/03 01:31:03
// Design Name: 
// Module Name: DIV
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


module Div(
    input [31:0]dividend,       //被除数               
    input [31:0]divisor,        //除数   
    input start,                //启动除法运算      
    input clock,      
    input reset,   
    output [31:0]q,             //商      
    output [31:0]r,             //余数         
    output reg busy                 //除法器忙标志位 
    );
    
    wire ready;
    reg[4:0] count;
    reg[31:0] tmp_q;
    reg[31:0] tmp_r;
    reg[31:0] tmp_b;
    reg tmp_sign;
    
    wire [31:0] dividend_temp;
    wire [31:0] divisor_temp;
    wire [31:0] q_temp;
    wire [31:0] r_temp;
    
    assign dividend_temp=dividend[31]?(~dividend+1):dividend;
    assign divisor_temp=divisor[31]?(~divisor+1):divisor;
    
    wire[32:0] sub_add=tmp_sign?({tmp_r,q_temp[31]}+{1'b0,tmp_b}):({tmp_r,q_temp[31]}-{1'b0,tmp_b});
    assign r_temp=tmp_sign?tmp_r+tmp_b:tmp_r;
    assign q_temp=tmp_q;
    
    assign r=dividend[31]?(~r_temp+1):r_temp;//r_temp>0
    assign q=(dividend[31]==divisor[31])?q_temp:(~q_temp+1);
    
    always @(negedge clock or posedge reset)
    begin
        if(reset)
        begin
            count<=5'b0;
            busy<=0;
        end
        else
        begin
            if(start&~busy)
            begin
                tmp_r<=32'b0;
                tmp_sign<=0;
                tmp_q<=dividend_temp;
                tmp_b<=divisor_temp;
                count<=5'b0;
                busy<=1'b1;
            end
            else if(busy)
            begin
                tmp_r<=sub_add[31:0];
                tmp_sign<=sub_add[32];
                tmp_q<={tmp_q[30:0],~sub_add[32]};
                count<=count+5'b1;
                if(count==5'b11111)
                    busy<=0;
            end
        end
    end 
endmodule