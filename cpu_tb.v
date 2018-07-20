`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/30 01:38:27
// Design Name: 
// Module Name: cpu_tb
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


module cpu_tb();
    reg clk=0;
    reg rst = 0;
    wire [31:0] inst; 
    wire [31:0] pc;
    wire [31:0] addr;
    
    integer file_output;
    integer counter = 0;
    
    wire [7:0] o_seg, o_sel;
    wire [15:0] sw;
    sccomp_dataflow cpu(clk,rst,sw ,o_seg,o_sel,inst,pc,addr);
    initial begin
    file_output = $fopen("result.txt");
    clk = 0;
    rst = 1;
    #1
    rst = 0;
    end
    
    
    always #1 clk=~clk;
    always @(posedge clk) begin
            counter = counter + 1;
            $fdisplay(file_output, "pc: %h", pc);
            $fdisplay(file_output, "instr: %h", inst);
            $fdisplay(file_output, "regfile0: %h", cpu_tb.cpu.cpu.cpu_ref.array[0]);
            $fdisplay(file_output, "regfile1: %h", cpu_tb.cpu.cpu.cpu_ref.array[1]);
            $fdisplay(file_output, "regfile2: %h", cpu_tb.cpu.cpu.cpu_ref.array[2]);
            $fdisplay(file_output, "regfile3: %h", cpu_tb.cpu.cpu.cpu_ref.array[3]);
            $fdisplay(file_output, "regfile4: %h", cpu_tb.cpu.cpu.cpu_ref.array[4]);
            $fdisplay(file_output, "regfile5: %h", cpu_tb.cpu.cpu.cpu_ref.array[5]);
            $fdisplay(file_output, "regfile6: %h", cpu_tb.cpu.cpu.cpu_ref.array[6]);
            $fdisplay(file_output, "regfile7: %h", cpu_tb.cpu.cpu.cpu_ref.array[7]);
            $fdisplay(file_output, "regfile8: %h", cpu_tb.cpu.cpu.cpu_ref.array[8]);
            $fdisplay(file_output, "regfile9: %h", cpu_tb.cpu.cpu.cpu_ref.array[9]);
            $fdisplay(file_output, "regfile10: %h", cpu_tb.cpu.cpu.cpu_ref.array[10]);
            $fdisplay(file_output, "regfile11: %h", cpu_tb.cpu.cpu.cpu_ref.array[11]);
            $fdisplay(file_output, "regfile12: %h", cpu_tb.cpu.cpu.cpu_ref.array[12]);
            $fdisplay(file_output, "regfile13: %h", cpu_tb.cpu.cpu.cpu_ref.array[13]);
            $fdisplay(file_output, "regfile14: %h", cpu_tb.cpu.cpu.cpu_ref.array[14]);
            $fdisplay(file_output, "regfile15: %h", cpu_tb.cpu.cpu.cpu_ref.array[15]);
            $fdisplay(file_output, "regfile16: %h", cpu_tb.cpu.cpu.cpu_ref.array[16]);
            $fdisplay(file_output, "regfile17: %h", cpu_tb.cpu.cpu.cpu_ref.array[17]);
            $fdisplay(file_output, "regfile18: %h", cpu_tb.cpu.cpu.cpu_ref.array[18]);
            $fdisplay(file_output, "regfile19: %h", cpu_tb.cpu.cpu.cpu_ref.array[19]);
            $fdisplay(file_output, "regfile20: %h", cpu_tb.cpu.cpu.cpu_ref.array[20]);
            $fdisplay(file_output, "regfile21: %h", cpu_tb.cpu.cpu.cpu_ref.array[21]);
            $fdisplay(file_output, "regfile22: %h", cpu_tb.cpu.cpu.cpu_ref.array[22]);
            $fdisplay(file_output, "regfile23: %h", cpu_tb.cpu.cpu.cpu_ref.array[23]);
            $fdisplay(file_output, "regfile24: %h", cpu_tb.cpu.cpu.cpu_ref.array[24]);
            $fdisplay(file_output, "regfile25: %h", cpu_tb.cpu.cpu.cpu_ref.array[25]);
            $fdisplay(file_output, "regfile26: %h", cpu_tb.cpu.cpu.cpu_ref.array[26]);
            $fdisplay(file_output, "regfile27: %h", cpu_tb.cpu.cpu.cpu_ref.array[27]);
            $fdisplay(file_output, "regfile28: %h", cpu_tb.cpu.cpu.cpu_ref.array[28]);
            $fdisplay(file_output, "regfile29: %h", cpu_tb.cpu.cpu.cpu_ref.array[29]);
            $fdisplay(file_output, "regfile30: %h", cpu_tb.cpu.cpu.cpu_ref.array[30]);
            $fdisplay(file_output, "regfile31: %h", cpu_tb.cpu.cpu.cpu_ref.array[31]);            
    end
endmodule
