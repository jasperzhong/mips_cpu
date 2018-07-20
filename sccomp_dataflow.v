`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:14:04 11/24/2013 
// Design Name: 
// Module Name:    sccomp_dataflow 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module sccomp_dataflow(
    input clk_in,
    input rst,
    input [15:0] sw,
    input kclk,
    input kdata,
    output [7:0] o_seg,
    output [7:0] o_sel
    ); 
    wire clk;
    wire [31:0]rdata;
    wire [31:0]wdata;
    wire DM_CS, DM_R, DM_W;
    wire [31:0]instruction, pc, addr;
    
    wire [31:0] data_fmem;
    wire [7:0] kb_data;
    
    wire [2:0] switch;
    
    wire [31:0] ip_in;
    wire seg7_cs, switch_cs, keyboard_cs;
    wire kb_ready;
    
    assign ip_in = pc-32'h00400000;
    
    ClkDiv cpu_clk(
        .clk_in1(clk_in),
        .reset(rst),
        .clk_out1(clk)
    );
    
    /*µØÖ·ÒëÂë*/
    io_sel io_mem(
        .addr(addr), 
        .cs(DM_CS), 
        .sig_w(DM_W), 
        .sig_r(DM_R), 
        .kb_ready(kb_ready),
        .seg7_cs(seg7_cs), 
        .switch_cs(switch_cs),
        .keyboard_cs(keyboard_cs)
    );
    
    /* CPU */
    CPU cpu(
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .rdata(rdata),
        .pc(pc),
        .addr(addr),
        .wdata(wdata),
        .DM_CS(DM_CS),
        .DM_W(DM_W),
        .DM_R(DM_R),
        .switch(switch)
    );
    
    /*Ö¸Áî´æ´¢Æ÷*/
    IMEM imem(
        .a(ip_in/4),
        .spo(instruction)
    );

    /*Êý¾Ý´æ´¢Æ÷*/
    Ram dram(
        .clk(~clk),
        .ena(DM_CS),
        .addr(addr-32'h10010000),
        .switch(switch),
        .data_in(wdata),
        .we(DM_W),
        .data_out(data_fmem)
    );
    
    seg7x16 seg7(
        .clk(clk), 
        .reset(rst), 
        .cs(seg7_cs), 
        .i_data(wdata), 
        .o_seg(o_seg),
        .o_sel(o_sel)
    );
    
    Keyboard keyboard(
        .clk(clk),
        .kclk(kclk),
        .kdata(kdata),
        .rst(rst),
        .keyboard_cs(keyboard_cs),
        .kb_data(kb_data),
        .kb_ready(kb_ready)
    );
    
    sw_mem_sel sw_mem(
        .switch_cs(switch_cs), 
        .keyboard_cs(keyboard_cs),
        .sw(sw), 
        .kb_data(kb_data),
        .data(data_fmem), 
        .data_sel(rdata)
    );
    
endmodule
