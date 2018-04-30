`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/25 17:05:59
// Design Name: 
// Module Name: cpu
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


module CPU(
    input clk,
    input rst,
    output [31:0] inst,
    output [31:0] pc,
    output [31:0] addr
    );
    
   /*IMEM*/
   wire [31:0] imem_addra;
   wire [31:0] instruction;
   
   /*DMEM*/
   wire dmem_ena;
   wire dmem_wea;
   wire [31:0] dmem_addra;
   wire [31:0] dmem_dina;
   wire [31:0] dmem_douta;
      
   /*PC*/
   wire pc_ena;
   wire [31:0] pc_data_in;
   
   /*ALU*/
   wire [31:0] alu_a;
   wire [31:0] alu_b;
   wire [3:0] aluc;
   wire [31:0] r;
   wire zero, carry, negative, overflow;
   
   /*REGFILES*/
   wire rf_we;
   wire [4:0] rf_raddr1;
   wire [4:0] rf_raddr2;
   wire [4:0] rf_waddr;
   wire [31:0] rf_wdata;
   wire [31:0] rf_rdata1;
   wire [31:0] rf_rdata2;  
   
   /*INSTRUCTIONS*/
   wire ADD = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b100000);
   wire ADDU = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b100001);
   wire SUB = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b100010);
   wire SUBU = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b100011);
   wire AND = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b100100);
   wire OR = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b100101);
   wire XOR = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b100110);
   wire NOR = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b100111);
   wire SLT = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b101010);
   wire SLTU = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b101011);
   wire SLL = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b000000);
   wire SRL = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b000010);
   wire SRA = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b000011);
   wire SLLV = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b000100);
   wire SRLV = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b000110);
   wire SRAV = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b000111);
   wire JR = (instruction[31:26] == 6'b0 && instruction[5:0] == 6'b001000);
   
   wire ADDI = (instruction[31:26] == 6'b001000);
   wire ADDIU = (instruction[31:26] == 6'b001001);
   wire ANDI = (instruction[31:26] == 6'b001100);
   wire ORI = (instruction[31:26] == 6'b001101);
   wire XORI = (instruction[31:26] == 6'b001110);
   wire LW = (instruction[31:26] == 6'b100011);
   wire SW = (instruction[31:26] == 6'b101011);
   wire BEQ = (instruction[31:26] == 6'b000100);
   wire BNE = (instruction[31:26] == 6'b000101);
   wire SLTI = (instruction[31:26] == 6'b001010);
   wire SLTIU = (instruction[31:26] == 6'b001011);
   wire LUI = (instruction[31:26] == 6'b001111);
   
   wire J = (instruction[31:26] == 6'b000010);
   wire JAL = (instruction[31:26] == 6'b000011);
   
   /*CONSTRAL SIGNAL */
   wire s_ext_s;
   wire [1:0] alu_a_mux;
   wire alu_b_mux;
   wire [1:0] pc_mux;
   wire [1:0] rf_wdata_mux;
   wire [1:0] rf_waddr_mux;
   
   wire [31:0] pc_idata1;
   wire [31:0] pc_idata2;
   wire [31:0] pc_idata3;
   wire [31:0] pc_idata4;
   wire [31:0] pc_odata;
   
   wire [4:0] ext5_idata;
   wire [31:0] ext5_odata;
   
   wire [15:0] ext16_idata;
   wire [31:0] ext16_odata;
   
   wire [15:0] ext18_idata;
   wire [31:0] ext18_odata;
   
   wire [31:0] ii_odata;
   
   wire [31:0] alu_a_idata1;
   wire [31:0] alu_a_idata2;
   wire [31:0] alu_a_idata3;
   
   wire [31:0] alu_b_idata1;
   wire [31:0] alu_b_idata2;
   
   wire [4:0] rf_waddr_idata1;
   wire [4:0] rf_waddr_idata2;
   
   assign ext5_idata = instruction[10:6]; //sa
   assign ext16_idata = instruction[15:0]; //imm
   assign ext18_idata = instruction[15:0]; //offset
   
   assign pc_idata1 = imem_addra + 4;     //pc+4
   assign pc_idata2 = rf_rdata1; // rs
   assign pc_idata3 = (r==0 && BEQ || r != 0 && BNE)?imem_addra + 4 + ext18_odata:imem_addra + 4; // npc+offset
   assign pc_idata4 = ii_odata; //pc||index||0^2
   
   assign alu_a_idata1 = rf_rdata1; //rs
   assign alu_a_idata2 = ext5_odata;
   assign alu_a_idata3 = 16;
   
   assign alu_b_idata1 = rf_rdata2; //rt
   assign alu_b_idata2 = ext16_odata; 
   
   assign pc_ena = 1;
   
   assign aluc[0] = SUB || SUBU || OR || NOR || SLT || SRL || SRLV || ORI || BEQ || BNE || SLTI;
   assign aluc[1] = ADD || SUB || XOR || NOR || SLT || SLTU || SLL || SLLV || ADDI || XORI || LW || SW || BEQ || BNE || SLTI || SLTIU;
   assign aluc[2] = AND || OR || XOR || NOR || SLL || SRL || SRA || SLLV || SRLV || SRAV || ANDI || ORI || XORI;
   assign aluc[3] = SLT || SLTU || SLL || SRL || SRA || SLLV || SRLV || SRAV || SLTI || SLTIU || LUI;
   
   assign alu_a_mux[0] = SLL || SRL || SRA;
   assign alu_a_mux[1] = LUI;
   assign alu_b_mux = ADDI || ADDIU || ANDI || ORI || XORI || LW || SW || SLTI || SLTIU || LUI;
   
   
   assign pc_mux[0] = JR || J || JAL;
   assign pc_mux[1] = BEQ || BNE || J || JAL;
   
   assign rf_wdata_mux[0] = LW;
   assign rf_wdata_mux[1] = JAL;
   
   assign s_ext_s = ADDI || ADDIU || LW || SW || BEQ || BNE || SLTI || SLTIU || LUI;
   
   assign rf_we = ADD || ADDU || SUB || SUBU || AND || OR || XOR || NOR || SLT || SLTU ||
   SLL || SRL || SRA || SLLV || SRLV || SRAV || ADDI || ADDIU || ANDI || ORI || XORI || LW ||
   SLTI || SLTIU || LUI || JAL;
   
   assign rf_waddr_mux[0] = ADDI || ADDIU || ANDI || ORI || XORI || LW || SLTI || SLTIU || LUI;
   assign rf_waddr_mux[1] = JAL;
   assign rf_raddr1 = instruction[25:21];   
   assign rf_raddr2 = instruction[20:16];
   
   assign rf_waddr_idata1 = instruction[15:11]; //rd
   assign rf_waddr_idata2 = instruction[20:16]; //rt

   assign dmem_ena = LW || SW;
   assign dmem_wea = SW;
   assign dmem_addra = r;
   assign dmem_dina = rf_rdata2;
    
   Mux4_1 m1(
        .iData1(pc_idata1),
        .iData2(pc_idata2),
        .iData3(pc_idata3),
        .iData4(pc_idata4),
        .sel(pc_mux),
        .oData(pc_data_in)
   );
   
   Mux4_1 m2(
        .iData1(alu_a_idata1),
        .iData2(alu_a_idata2),
        .iData3(alu_a_idata3),
        .iData4(alu_a_idata3),
        .sel(alu_a_mux),
        .oData(alu_a)
   );
   
   Mux2_1 m3(
        .iData1(alu_b_idata1),
        .iData2(alu_b_idata2),
        .sel(alu_b_mux),
        .oData(alu_b)
   );
   
   Mux4_1 m4(
        .iData1(r),
        .iData2(dmem_douta),
        .iData3(imem_addra+4),
        .iData4(imem_addra+4),
        .sel(rf_wdata_mux),
        .oData(rf_wdata)
   );
   
   Mux4_1 m5(
        .iData1(rf_waddr_idata1),
        .iData2(rf_waddr_idata2),
        .iData3(5'b11111),
        .iData4(5'b11111),
        .sel(rf_waddr_mux),
        .oData(rf_waddr)
   );
   
   Ext5 ext5(
        .iData(ext5_idata),
        .oData(ext5_odata)  
   );
   
   Ext16 ext16(
        .iData(ext16_idata),
        .s_ext_s(s_ext_s),
        .oData(ext16_odata)
   );
   
   Ext18 ext18(
        .iData(ext18_idata),
        .oData(ext18_odata)
   );
   
   II ii(
        .pc(imem_addra[31:28]),
        .index(instruction[25:0]),
        .addr(ii_odata)
   );
   
   IMEM imem(
        .a((imem_addra-32'h00400000)/4),
        .spo(instruction)
   );
   
   DMEM dmem(
        .clk(~clk),
        .we(dmem_wea),
        .a(dmem_addra),
        .d(dmem_dina),
        .spo(dmem_douta)
   );
   
   PCReg pcreg(
        .clk(clk),
        .rst(rst),
        .ena(pc_ena),
        .data_in(pc_data_in),
        .data_out(imem_addra)
   );
   
   ALU alu(
        .a(alu_a),
        .b(alu_b),
        .aluc(aluc),
        .r(r),
        .zero(zero),
        .carry(carry),
        .negative(negative),
        .overflow(overflow)
   );
   
   Regfiles cpu_ref(
        .clk(clk),
        .rst(rst),
        .we(rf_we),
        .raddr1(rf_raddr1),
        .raddr2(rf_raddr2),
        .waddr(rf_waddr),
        .wdata(rf_wdata),
        .rdata1(rf_rdata1),
        .rdata2(rf_rdata2)
   );
   
   assign inst = instruction;
   assign pc = imem_addra;
   assign addr = dmem_addra;
endmodule
