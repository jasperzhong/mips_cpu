`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/26 15:35:43
// Design Name: 
// Module Name: alu
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


module ALU(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow
    );
    
    always @(*) begin
        case (aluc)
        4'b0000:begin {carry ,r} = a + b; zero = (r==0); negative = r[31]; end
        4'b0010:begin r = a + b; overflow = (r[31]&~a[31]&~b[31] | ~r[31]&a[31]&b[31]); zero = (r==0); negative = r[31]; end
        4'b0001:begin {carry, r} = a - b; zero = (r==0); negative = r[31]; end
        4'b0011:begin r = a - b; overflow = (r[31]&~a[31]&b[31] | ~r[31]&a[31]&~b[31]); zero = (r==0); negative = r[31]; end
        4'b0100:begin r = a & b; zero = (r==0); negative = r[31]; end
        4'b0101:begin r = a | b; zero = (r==0); negative = r[31]; end
        4'b0110:begin r = a ^ b; zero = (r==0); negative = r[31]; end
        4'b0111:begin r = ~(a | b); zero = (r==0); negative = r[31]; end
        4'b1000:begin r = {b[15:0], 16'b0}; zero = (r==0); negative = r[31]; end
        4'b1001:begin r = {b[15:0], 16'b0}; zero = (r==0); negative = r[31]; end
        4'b1011:begin r = $signed(a)<$signed(b)?32'b1:32'b0; zero=(a-b==0)?1:0;negative=($signed(a)<$signed(b))?1:0;end
        4'b1010:begin r = (a<b)?32'b1:32'b0; zero = (a==b); negative = r[31]; end
        4'b1100:begin r = $signed(b) >>> $signed(a); zero = (r==0); carry = b[a-1]; negative = r[31]; end
        4'b1110:begin r = b << a; zero = (r==0); carry = b[31-a+1]; negative = r[31]; end
        4'b1111:begin r = b << a; zero = (r==0); carry = b[31-a+1]; negative = r[31]; end
        4'b1101:begin r = b >> a; zero = (r==0); carry = b[a-1]; negative = r[31]; end
        endcase
    end
    
    
endmodule