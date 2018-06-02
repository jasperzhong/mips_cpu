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
   
   /*MUL*/
   wire [31:0] mul_a;
   wire [31:0] mul_b;
   wire [63:0] mul_z;
   
   wire [31:0] multu_a;
   wire [31:0] multu_b;
   wire [63:0] multu_z;
   
   /*DIV*/
   wire [31:0] div_dividend;
   wire [31:0] div_divisor;
   wire [31:0] div_q;
   wire [31:0] div_r;
   wire div_busy;
   
   wire [31:0] divu_dividend;
   wire [31:0] divu_divisor;
   wire [31:0] divu_q;
   wire [31:0] divu_r;
   wire divu_busy;   
    
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
   
   wire MFC0 = (instruction[31:26] == 6'b010000 && instruction[25:21] == 5'b00000);
   wire MTC0 = (instruction[31:26] == 6'b010000 && instruction[25:21] == 5'b00100);
   wire SYSCALL = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b001100);
   wire TEQ = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b110100);
   wire BREAK = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b001101);
   wire ERET = (instruction[31:26] == 6'b010000 && instruction[5:0] == 6'b011000);
   
   wire CLZ = (instruction[31:26] == 6'b011100 && instruction[5:0] == 6'b100000);
   wire DIVU = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b011011);
   wire DIV = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b011010);
   wire MULTU = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b011001);
   wire MUL = (instruction[31:26] == 6'b011100 && instruction[5:0] == 6'b000010);
   wire MFHI = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b010000);
   wire MFLO = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b010010);
   wire MTHI = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b010001);
   wire MTLO = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b010011);
   wire JALR = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b001001);
    
   wire LB = (instruction[31:26] == 6'b100000);
   wire LBU = (instruction[31:26] == 6'b100100);
   wire LHU = (instruction[31:26] == 6'b100101);
   wire SB = (instruction[31:26] == 6'b101000);
   wire SH = (instruction[31:26] == 6'b101001);
   wire LH = (instruction[31:26] == 6'b100001);
   
   wire BGEZ = (instruction[31:26] == 6'b000001);
   
   /*CONSTRAL SIGNAL */
   wire s_ext_s;
   wire [1:0] alu_a_mux;
   wire [1:0] alu_b_mux;
   wire [1:0] pc_mux;
   wire [3:0] rf_wdata_mux;
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
   wire [31:0] alu_b_idata3;
   
   wire [31:0] rf_wdata_idata1;
   wire [31:0] rf_wdata_idata2;
   wire [31:0] rf_wdata_idata3;
   wire [31:0] rf_wdata_idata4;
   wire [31:0] rf_wdata_idata5;
   wire [31:0] rf_wdata_idata6;
   wire [31:0] rf_wdata_idata7;
   wire [31:0] rf_wdata_idata8;
   wire [31:0] rf_wdata_idata9;
   wire [31:0] rf_wdata_idata10;
   wire [31:0] rf_wdata_idata11;
   wire [31:0] rf_wdata_idata12;
   
   wire [4:0] rf_waddr_idata1;
   wire [4:0] rf_waddr_idata2;
 
   /* cp0 */
   wire exception;
   
   wire [31:0] CP0_out;
   wire [31:0] cause;
   wire [31:0] status;
   wire [31:0] epc_out;
   
   wire hi_we;
   wire lo_we;
   wire [1:0] hi_wdata_mux;
   wire [1:0] lo_wdata_mux;
   
   wire [31:0] hi_data_in;
   wire [31:0] hi_data_out;
   
   wire [31:0] lo_data_in;
   wire [31:0] lo_data_out;
   
   wire [31:0] clz_in;
   wire [31:0] clz_out;
   
   assign exception = SYSCALL||BREAK||(TEQ&&zero);
   assign cause = SYSCALL?32'b100000:BREAK?32'b100100:TEQ?32'b110100:32'b0;
  
   assign ext5_idata = instruction[10:6]; //sa
   assign ext16_idata = instruction[15:0]; //imm
   assign ext18_idata = instruction[15:0]; //offset
   
   /* pc */
   assign pc_ena = 1;
   
   assign pc_mux[0] = JR || J || JAL || JALR || ERET;
   assign pc_mux[1] = BEQ || BNE || J || JAL || BGEZ;
      
   assign pc_idata1 = imem_addra + 4;     //pc+4
   assign pc_idata2 = ERET?epc_out:rf_rdata1; // rs OR epc_out
   assign pc_idata3 = (r==0 && BEQ || r != 0 && BNE || r==0 && BGEZ)?imem_addra + 4 + ext18_odata:imem_addra + 4; // npc+offset
   assign pc_idata4 = ii_odata; //pc||index||0^2
   
   /* alu */
   assign alu_a_mux[0] = SLL || SRL || SRA;
   assign alu_a_mux[1] = LUI;
   assign alu_b_mux[0] = ADDI || ADDIU || ANDI || ORI || XORI || LW || SW || SLTI || SLTIU || LUI 
                     || LB || LBU || LHU || SB || SH || LH;
   assign alu_b_mux[1] = BGEZ;
      
   assign alu_a_idata1 = rf_rdata1; //rs
   assign alu_a_idata2 = ext5_odata;
   assign alu_a_idata3 = 16;
   
   assign alu_b_idata1 = rf_rdata2; //rt
   assign alu_b_idata2 = ext16_odata; 
   assign alu_b_idata3 = 0; //bgez
   
   assign aluc[0] = SUB || SUBU || OR || NOR || SLT || SRL || SRLV || ORI || BEQ || BNE || SLTI || BGEZ;
   assign aluc[1] = ADD || SUB || XOR || NOR || SLT || SLTU || SLL || SLLV || ADDI || XORI || LW || SW || BEQ || BNE || SLTI || SLTIU
                 || LB || LBU || LHU || SB || SH || LH || BGEZ;
   assign aluc[2] = AND || OR || XOR || NOR || SLL || SRL || SRA || SLLV || SRLV || SRAV || ANDI || ORI || XORI;
   assign aluc[3] = SLT || SLTU || SLL || SRL || SRA || SLLV || SRLV || SRAV || SLTI || SLTIU || LUI || BGEZ;
   
   /* regfiles */
   assign rf_we = ADD || ADDU || SUB || SUBU || AND || OR || XOR || NOR || SLT || SLTU ||
      SLL || SRL || SRA || SLLV || SRLV || SRAV || ADDI || ADDIU || ANDI || ORI || XORI || LW ||
      SLTI || SLTIU || LUI || JAL || CLZ || MUL || MFC0 || MFHI || MFLO || JALR || LB || LBU || 
      LHU || LH;
   assign rf_raddr1 = instruction[25:21]; //rs   
   assign rf_raddr2 = instruction[20:16]; //rt
               
   assign rf_waddr_mux[0] = ADDI || ADDIU || ANDI || ORI || XORI || LW || SLTI || SLTIU || LUI || 
                                  MFC0 || LB || LBU || LHU || LH;
   assign rf_waddr_mux[1] = JAL;
 
   assign rf_waddr_idata1 = instruction[15:11]; //rd
   assign rf_waddr_idata2 = instruction[20:16]; //rt
   
   assign rf_wdata_mux[0] = LW || CLZ || MFC0 || MFLO || LBU || LH;
   assign rf_wdata_mux[1] = JAL || CLZ || MFHI || MFLO || JALR || LHU || LH;
   assign rf_wdata_mux[2] = MUL || MFC0 || MFHI || MFLO;
   assign rf_wdata_mux[3] = LB || LBU || LHU || LH;
   
   assign rf_wdata_idata1 = r;
   assign rf_wdata_idata2 = dmem_douta;
   assign rf_wdata_idata3 = imem_addra+4;
   assign rf_wdata_idata4 = clz_out;
   assign rf_wdata_idata5 = mul_z[31:0];
   assign rf_wdata_idata6 = CP0_out;
   assign rf_wdata_idata7 = hi_data_out;
   assign rf_wdata_idata8 = lo_data_out;
   assign rf_wdata_idata9 = {{25{dmem_douta[7]}}, dmem_douta[6:0]};
   assign rf_wdata_idata10 = {24'b0, dmem_douta[7:0]};
   assign rf_wdata_idata11 = {16'b0, dmem_douta[15:0]};
   assign rf_wdata_idata12 = {{17{dmem_douta[15]}}, dmem_douta[14:0]};
   
   
   assign s_ext_s = ADDI || ADDIU || LW || SW || BEQ || BNE || SLTI || SLTIU || LUI ||
          LB || LBU || LHU || SB || SH || LH || BGEZ;
   
   
   /* dmem */
   assign dmem_ena = LW || SW || LB || LBU || LHU || SB || SH || LH;
   assign dmem_wea = SW || SB || SH;
   assign dmem_addra = r;
   assign dmem_dina = SW?rf_rdata2:SH?{rf_rdata2[15:0], 16'b0}:SB?{rf_rdata2[7:0], 24'b0}:32'bz;
   
   
   /* hi/lo */
   assign hi_we = DIVU || DIV || MULTU || MTHI;
   assign lo_we = DIVU || DIV || MULTU || MTLO;
   
   assign hi_wdata_mux[0] = DIV || MTHI;
   assign hi_wdata_mux[1] = MULTU || MTHI;
   
   assign lo_wdata_mux[0] = DIV || MTLO;
   assign lo_wdata_mux[1] = MULTU || MTLO;
   
   
   
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
   
   Mux4_1 m3(
        .iData1(alu_b_idata1),
        .iData2(alu_b_idata2),
        .iData3(alu_b_idata3),
        .iData4(0),
        .sel(alu_b_mux),
        .oData(alu_b)
   );
   
   Mux16_1 m4(
        .iData1(rf_wdata_idata1),
        .iData2(rf_wdata_idata2), 
        .iData3(rf_wdata_idata3), 
        .idata4(rf_wdata_idata4),
        .idata5(rf_wdata_idata5),
        .idata6(rf_wdata_idata6),
        .idata7(rf_wdata_idata7),
        .idata8(rf_wdata_idata8),
        .idata9(rf_wdata_idata9),
        .idata10(rf_wdata_idata10),
        .idata11(rf_wdata_idata11),
        .idata12(rf_wdata_idata12),      
        .idata13(0),
        .idata14(0),
        .idata15(0),
        .idata16(0),  
        .sel(rf_wdata_mux),
        .oData(rf_wdata)
   );
   
   Mux4_1 m5(
        .iData1(rf_waddr_idata1),
        .iData2(rf_waddr_idata2),
        .iData3(5'b11111),
        .iData4(0),
        .sel(rf_waddr_mux),
        .oData(rf_waddr)
   );
   
   Mux4_1 m6(
        .iData1(divu_r),
        .iData2(div_r),
        .iData3(multu[63:32]),
        .iData4(rf_rdata1), //rs
        .sel(hi_wdata_mux),
        .oData(hi_data_in)
   );
   
   Mux4_1 m7(
       .iData1(divu_q),
       .iData2(div_q),
       .iData3(multu[31:0]),
       .iData4(rf_rdata1), //rs
       .sel(lo_wdata_mux),
       .oData(lo_data_in)
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
   
   CP0 cp0(
        .clk(clk),
        .rst(rst),
        .mfc0(MFC0),
        .mtc0(MTC0),
        .eret(ERET),
        .exception(exception),
        .addr(rf_waddr),   //addr_rd
        .data(rf_rdata2),  //data_rt
        .pc(imem_addra),
        .cause(cause),
        .CP0_out(CP0_out),
        .status(status),
        .epc_out(epc_out)
   );
   
   CLZ clz(
        .clz_in(clz_in),
        .clz_out(clz_out)
   );
   
   Mul mul(
        .clk(clk),
        .rst(rst),
        .a(mul_a),
        .b(mul_b),
        .z(mul_z)
   );
   
   Multu multu(
        .clk(clk),
        .rst(rst),
        .a(multu_a),
        .b(multu_b),
        .z(multu_z)
   );   
   
   Div div(
        .dividend(div_dividend),
        .divisor(div_divisor),
        .start(DIV),
        .clock(clk),
        .reset(rst),
        .q(div_q),
        .r(div_r),
        .busy(div_busy)
   );
   
   Divu divu(
       .dividend(divu_dividend),
       .divisor(divu_divisor),
       .start(DIVU),
       .clock(clk),
       .reset(rst),
       .q(divu_q),
       .r(divu_r),
       .busy(divu_busy)
   );
   
   
   PCReg hi(
       .clk(clk),
       .rst(rst),
       .ena(hi_we),
       .data_in(hi_data_in),
       .data_out(hi_data_out)
   );
   
   PCReg lo(
       .clk(clk),
       .rst(rst),
       .ena(lo_we),
       .data_in(lo_data_in),
       .data_out(lo_data_out)
   );
      
   assign inst = instruction;
   assign pc = imem_addra;
   assign addr = dmem_addra;
endmodule
