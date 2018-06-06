`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/21 21:07:36
// Design Name: 
// Module Name: cp0
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


module CP0(
    input clk,
    input rst,
    input mfc0, //read
    input mtc0, //write
    input eret, //返回命令
    input exception,  //是否有异常
    input [4:0] addr,   //指定cp0寄存器
    input [31:0] data,  //读写数据
    input [31:0] pc,  
    input [31:0] cause, 
    output [31:0] CP0_out,
    output [31:0] status,
    output [31:0] epc_out //异常起始地址
);  

    wire [31:0] cause_out;
    wire [31:0] bad_vaddr;
    wire wepc, wsta, wcau, wbv;
    //发生异常都需要写入
    assign wbv  = (mtc0 && addr == 5'b01000);
    assign wepc = (mtc0 && addr == 5'b01110)||exception; //14 
    assign wsta = (mtc0 && addr == 5'b01100)||eret||exception; //12  
    assign wcau = (mtc0 && addr == 5'b01101)||exception; //13
    
    wire [31:0] sta = exception?{status[26:0], 5'b0}:eret?{5'b0, status[26:0]}:status;
    wire [31:0] cause_wdata = mtc0?data:cause;
    wire [31:0] status_wdata = mtc0?data:sta;
    wire [31:0] epc_wdata = mtc0?data:pc;
    wire [31:0] bad_wdata = mtc0?data:bad_vaddr;
    
    
    PCReg reg_status(clk, rst, wsta, status_wdata, status);
    PCReg reg_cause(clk, rst, wcau, cause_wdata, cause_out);
    PCReg reg_epc(clk, rst, wepc, epc_wdata, epc_out);
    PCReg reg_bad(clk, rst, wbv, bad_wdata, bad_vaddr);
   
    assign CP0_out = mfc0?((addr == 5'b01100)?
                   status:(addr == 5'b01101)?
                    cause_out:(addr==5'b01110)?
                    epc_out:(addr==5'b01000)?
                    bad_vaddr:32'bz):32'bz;
endmodule
