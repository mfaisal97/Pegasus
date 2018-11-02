// file: Datapath.v
// author: @ahmedleithy

`include "defines.v"

`timescale 1ns/1ns

module Datapath(
    input clk, 
    input rst
    );
    
    //Instruction Fetch-Decode register
    //wires declaration
    wire ssignal;
    wire branch;
    wire stall;
    wire rstsync;
    wire alu_src_two_sel;
    wire mem_read;
    wire mem_write;
    wire reg_write_back;
    wire unconditionalbranch;
    wire lui;
    wire write;
    wire jal;
    wire jalr;
    wire em_jal;
    wire em_jalr;
    wire em_lui;
    wire em_mem_read;
    wire em_mem_write;
    wire em_reg_write_back; 
    wire em_branch; 
    wire em_unconditionalbranch; 
    wire em_forward_a;
    wire em_forward_b; 
    wire em_forward_store;                    
      
                       
    wire [`Data_SIZE] pc;
    wire [`Data_SIZE] pc4;
    wire [`Data_SIZE] instregin;
    wire [`Data_SIZE] nextpc;
    wire [`Data_SIZE] immediate;
    wire [`Data_SIZE] inst;
    wire [`Data_SIZE] rs1;
    wire [`Data_SIZE] rs2;
    wire [`Data_SIZE] rs2_muxout;
    wire [4:0] WB_addr;
    wire [`Data_SIZE] em_immediate;
    wire [4:0] em_rd_addr;
    wire [2:0] em_func3;
    wire [`Data_SIZE] em_pc;
    wire [`Data_SIZE] em_pc4;
    wire [`Data_SIZE] em_rs1;
    wire [`Data_SIZE] em_rs2_muxout;

    //execmem
    wire forward_a;
    wire forward_b;
    wire forward_store;
    

    
    wire [`Data_SIZE] aluout;
    wire [`Data_SIZE] aluin_1;
    wire [`Data_SIZE] aluin_2;
    
    wire [`Data_SIZE] memout; //rd_data
    wire [`Data_SIZE] memaddressmuxout;
    wire [`Data_SIZE] meminputmuxout;
    wire [`Data_SIZE] branch_PC;
    wire [`Data_SIZE] branch_Imm;


    
    //aluflags
    wire s;
    wire v;
    wire c;
    wire zf;
    
    wire branch_taken;
    
    //writeback
    wire [`Data_SIZE] rfwritedata;
    wire [`Data_SIZE] wb_pc4;
    wire [`Data_SIZE] wb_immediate;
    wire [`Data_SIZE] wb_aluout;
    wire [`Data_SIZE] wb_memout;
    wire wbjal;
    wire wbjalr;
    wire wb_lui;
    wire wb_mem_read;
    wire wb_reg_write_back;
    wire wb_branch;
    wire wb_unconditionalbranch;
    wire [4:0] wb_rd_addr;
                 
              
                  
           
                
    wire [`ALUSEL_SIZE] alusel;
    

    
    //----------------- FIRST STAGE - FETCH-DECODE --------------------------------
    
    //module instantiation
    
    
    ResetSync resetsyncronizer(
    .clk(clk),
    .inrst(rst),
    .outrst(rstsync)
    );
    
    
    SlowSignal slow(
        .clk(clk),
        .rst(rstsync),
        .slow_signal(ssignal)
    );
        
    ALU_Control alucontrol(
    .OpCode(inst[`IR_opcode]), 
    .Inst(inst[`IR_funct3]), 
    .Inst30(inst[`IR_30]), 
    .ALU_Sel(alusel)
    );
    
    
    //  assign Pipeline_1_RegIn = {immediate[31:30],lui, inst[`IR_funct3],pc4, pc, immediate[29:0], mem_read, mem_write, reg_write_back, branch, unconditionalbranch, rd_addr, rs1, rs2_muxout, forward_a, forward_b, forward_store};
                              //      178:177     176  175:173,    172:141, 140:109, 108:79,         76,       75,         74,            73,        72,        71:67,  66:35,       34:3,     2,            1,          0
   
   
    assign nextpc = branch_taken | em_jal ? branch_PC : (em_jalr? aluout : pc4); //2nd stage//check check
    //branch, unconditional
    assign pc4 = pc + `FOUR;
    assign unconditionalbranch = jal | jalr;
    
    Register #(`THIRTY_TWO) pcreg (
        .clk(clk),
        .rst(rstsync),
        .load(~ssignal),
        .data_in(nextpc), //next PC MUX NEEEDED
        .data_out(pc)
    );
    
    
    Register #(`THIRTY_TWO) instreg (
        .clk(clk),
        .rst(rstsync),
        .load(ssignal),
        .data_in(instregin),
        .data_out(inst)
    );
        

    
    rv32_ImmGen immgen(
        .IR(inst),
        .Imm(immediate)
    );
    
    
    ControlUnit cunit(
        .opcode(inst[`IR_opcode]),
        .alu_src_two_sel(alu_src_two_sel),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write_back(reg_write_back),
        .branch(branch),
        .lui(lui),
        .jal(jal),
        .jalr(jalr)
    );
    
    assign write = wb_reg_write_back & ~ssignal;
    assign WB_addr = write? wb_rd_addr:inst[`IR_rs2];
    wire [4:0] rs1_addr;
    assign rs1_addr = inst[`IR_rs1];
    
    
    RegisterFile rf(
        .clk(clk),
        .rst(rstsync),
        .reg_write(write), //regwriteback add slow_signal
        .write_data(rfwritedata),
        .port_one_address(rs1_addr),
        .port_two_address(WB_addr),
        .port_one_data(rs1),
        .port_two_data(rs2)
    );

    assign rs2_muxout = alu_src_two_sel? immediate:rs2;
  /*  MUX2x1 #(32) imm_VS_rs2 (
        .A(rs2),
        .B(immediate),
        .sel(),
        .out(rs2_muxout)
        );  
*/
    ForwardingUnit fu(
        .opcode(inst[6:2]),
        .rs1(rs1_addr), 
        .rs2(inst[`IR_rs2]), 
        .rd(em_rd_addr), 
        .reg_write(em_reg_write_back), 
        .forward_a(forward_a), 
        .forward_b(forward_b),  
        .forward_store(forward_store)
        );
        
  //  assign Pipeline_1_RegIn = {jal, jalr, immediate[31:30],lui, inst[`IR_funct3],pc4, pc, immediate[29:0], mem_read, mem_write, reg_write_back, branch, unconditionalbranch, inst[`IR_rd], rs1, rs2_muxout, forward_a, forward_b, forward_store};
    
                            //  178  177  176:175            174  173:171,    170:139, 138:107, 106:77,         76,       75,         74,            73,        72,             71:67,  66:35,       34:3,     2,            1,          0
  
     Register #(179) Pipeline_1 (
        .clk(clk),
        .rst(rstsync),
        .load(~ssignal), //CHECK THIS!!
        .data_in({jal, 
                  jalr, 
                  immediate[31:30],
                  lui, 
                  inst[`IR_funct3],
                  pc4, 
                  pc, 
                  immediate[29:0],
                  mem_read, 
                  mem_write, 
                  reg_write_back, 
                  branch, 
                  unconditionalbranch, 
                  inst[`IR_rd], 
                  rs1, 
                  rs2_muxout, 
                  forward_a, 
                  forward_b, 
                  forward_store}),
        .data_out({em_jal, 
                   em_jalr, 
                   em_immediate[31:30],
                   em_lui, 
                   em_func3,
                   em_pc4, 
                   em_pc, 
                   em_immediate[29:0],
                   em_mem_read, 
                   em_mem_write, 
                   em_reg_write_back, 
                   em_branch, 
                   em_unconditionalbranch, 
                   em_rd_addr, 
                   em_rs1, 
                   em_rs2_muxout, 
                   em_forward_a, 
                   em_forward_b, 
                   em_forward_store})
    );

    MUX2x1 #(`THIRTY_TWO) forwardA  (
        .A(em_rs1), //rs1
        .B(rfwritedata), //pipline 2
        .sel(em_forward_a),
        .out(aluin_1)
    ); 
    
    MUX2x1 #(`THIRTY_TWO) forwardB  (
        .A(em_rs2_muxout),//rs2
        .B(rfwritedata), //pipline 2
        .sel(em_forward_b),
        .out(aluin_2)
    ); 

    //Excute-Memory Register
    //----------------- SECOND STAGE - EXEC-MEM --------------------------------
     
    ALU alu(
        .sel(alusel), 
        .A(aluin_1), 
        .B(aluin_2), 
        .out(aluout), 
        .ZeroFlag(zf),
        .Cout(c),
        .SignedBit(s),
        .Overflow(v)
    );
    assign branch_PC = em_pc + em_immediate;
//       assign Pipeline_1_RegIn = {jal, jalr, immediate[31:30],lui, inst[`IR_funct3],pc4, pc, immediate[29:0], mem_read, mem_write, reg_write_back, branch, unconditionalbranch, inst[`IR_rd], rs1, rs2_muxout, forward_a, forward_b, forward_store};
                               //  178  177  176:175            174  173:171,    170:139, 138:107, 106:77,         76,       75,         74,            73,        72,             71:67,  66:35,       34:3,     2,            1,          0
  /*  
    wire branch_taken_temp, branch_taken_temp2;
    
    Register #(1) branchregister (
            .clk(clk),
            .rst(rstsync),
            .load(`ONEs_1), //CHECK THIS!!
            .data_in(branch_taken_temp),
            .data_out(branch_taken_temp2)
        ); 
    */    
    BranchControlUnit bcu(
        .branch(em_branch),
        .ssignal(`ONEs_1),
        .unconditionalbranch(em_unconditionalbranch),
        .func3(em_func3),
        .zeroflag(zf),
        .cout(c),
        .signbit(s),
        .overflow(v),
        .takebranch(branch_taken)//or temp
    );

  // assign branch_taken = branch_taken_temp | branch_taken_temp2;
   
   
    assign memaddressmuxout = (em_mem_read|em_mem_write)&ssignal ? aluout : pc; 
    
    Memory memory(
        .clk(clk),
        .slow_signal(~ssignal),
        .address(memaddressmuxout),
        .data(meminputmuxout),
        .memread(em_mem_read),
        .memwrite(em_mem_write),
        .funct3(em_func3),
        .dataout(memout) //its rd_data! //rd_EX_MEM
    );
    
    assign meminputmuxout =  em_forward_store? rfwritedata: aluin_2;
    //Pipeline_1_RegIn = {inst[`IR_funct3],pc4, pc, immediate, mem_read, mem_write, reg_write_back, branch, unconditionalbranch, rd_addr, rs1, rs2instmuxout, forward_a, forward_b, forward_store};
                            //  175:173, 172:141, 140:109, 108:79, 76,       75,         74,            73,        72,        71:67,  66:35,       34:3,     2,            1,          0
                             
                            
                               //      rd_addr         
           //    137                          136                   135 :104                                         103:72                        71                        70                   69                    68:64                    63:32   31:0
    Register #(138) Pipeline_2 (
        .clk(clk),
        .rst(rstsync),
        .load(ssignal), //CHECK THIS!!
        .data_in({em_lui,
                  em_mem_read,
                  em_pc4,
                  em_immediate,
                  em_reg_write_back,
                  em_branch,
                  em_unconditionalbranch, 
                  em_rd_addr, 
                  memout, 
                  aluout}),
        .data_out({wb_lui,
                   wb_mem_read,
                   wb_pc4,
                   wb_immediate,
                   wb_reg_write_back,
                   wb_branch,
                   wb_unconditionalbranch, 
                   wb_rd_addr, 
                   wb_memout, 
                   wb_aluout})
    );
  
    //----------------- THIRD STAGE - WB --------------------------------
    //wbjalr and jal = aluout = Pipeline_2_RegOut[31:0]
    //wblui = immediate = Pipeline_2_RegOut[103:72]
    //wbmemread = rd data = memout = Pipeline_2_RegOut[63:32]
    //wbpc4 = pc4 = Pipeline_2_RegOut[135:104]
    //
    assign rfwritedata = wb_lui ? wb_immediate :  wb_unconditionalbranch ? wb_pc4 : wb_mem_read? wb_memout : wb_aluout;
    assign rs2in = write ? wb_rd_addr: inst[24:20];

    MUX2x1 #(`THIRTY_TWO) irmux(memout,`NOP,branch_taken,instregin); //FLUSH SIGNAL 


    
endmodule
