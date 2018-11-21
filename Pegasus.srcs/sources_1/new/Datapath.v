// file: Datapath.v
// author: @ahmedleithy
/*******************************************************************
*
* Module: Datapath.v
* Project: Project_Name
* Author: Ahmed Leithy,    ahmed.leithym@aucegypt.edu         
*         Arig Mostafa,    areeg.mostafa@aucegypt.edu
*         Muhammad Faisal, mfaisal@aucegypt.edu
*
* Description: put your description here
* Change history: 01/01/17 â€“ Did something
* 10/29/17 â€“ Did something else
*
**********************************************************************/
`include "defines.v"

`timescale 1ns/1ns

module Datapath(
    input clk, 
    input rst,
    input NMI,
    input status,
    input [2:0] interrupt_index
    );
    
    
    //Instruction Fetch-Decode register
    //wires declaration
    wire ssignal;
    wire not_compressed;
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
    wire auipc;
    wire csr;
    wire csr_read_write;
    wire csr_src1_sel_imm;
    wire csr_src1_sel_rc;
    wire csr_src2_sel;
    wire em_auipc;
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
    wire em_csr_src1_sel_imm;
    wire em_csr_src1_sel_rc;
    wire em_csr_read_write;
    wire em_csr;
              
    wire [3:0] mie_csr_file_con_block;
    wire time_int_file_con_block;
    wire interrupt_indicator;
    wire ebreak_identifier;
    wire ecall_identifier;
    wire mret_identifier;
    wire [2:0] mipWire;
                                   
    wire [`DATA_SIZE] pc;
    wire [`DATA_SIZE] pc4;
    wire [`DATA_SIZE] instregin;
    wire [`DATA_SIZE] fetchedinst;
    wire [`DATA_SIZE] nextpc;
    wire [`DATA_SIZE] immediate;
    wire [`DATA_SIZE] inst;
    wire [`DATA_SIZE] rs1;
    wire [`DATA_SIZE] aluin_1_imm;
    wire [`DATA_SIZE] aluin_1_imm_xor;
    wire [`DATA_SIZE] rs2;
    wire [`DATA_SIZE] rs2_muxout;
    wire [`DATA_SIZE] rs2_muxout_csr;
    wire [`DATA_SIZE] csr_data_out;
    wire [`CSR_ADDR_SIZE] csr_addr;
    wire [`CSR_ADDR_SIZE] wb_csr_addr;
    wire [`CSR_ADDR_SIZE] em_csr_addr;
    
    wire [`IR_rd] rd_addr;    
    wire [4:0] WB_addr;
    
    
    
    wire [`DATA_SIZE] em_immediate;
    wire [4:0] em_rd_addr;
    wire [2:0] em_func3;
    wire [`DATA_SIZE] em_pc;
    wire [`DATA_SIZE] em_pc4;
    wire [`DATA_SIZE] em_rs1;
    wire [`DATA_SIZE] em_rs2_muxout;
    wire [`DATA_SIZE] wb_auipcdata;
    wire [`DATA_SIZE] em_handlerpc;
    wire [4:0] rs2in;
    //execmem
    wire forward_a;
    wire forward_b;
    wire forward_store;
    wire [`DATA_SIZE]  em_rs2;
    wire [`DATA_SIZE] aluout;
    wire [`DATA_SIZE] aluout_rs1;
    wire [`DATA_SIZE] aluin_1;
    wire [`DATA_SIZE] aluin_2;
    
    wire [`DATA_SIZE] memout; //rd_data
    wire [`DATA_SIZE] memout_rs2;
    wire [`DATA_SIZE] memaddressmuxout;
    wire [`DATA_SIZE] meminputmuxout;
    wire [`DATA_SIZE] branch_PC;
    wire [`DATA_SIZE] branch_Imm;

    //aluflags
    wire s;
    wire v;
    wire c;
    wire zf;
    wire branch_taken;
    wire em_mret;
    wire em_ebreak;
    wire em_ecall;
    //writeback
    wire [`DATA_SIZE] rfwritedata;
    wire [`DATA_SIZE] wb_pc4;
    wire [`DATA_SIZE] wb_aluout;
    wire [`DATA_SIZE] wb_memout;
    wire wb_auipc;
    wire wbjal;
    wire wbjalr;
    wire wb_lui;
    wire wb_mem_read;
    wire wb_reg_write_back;
    wire wb_branch;
    wire wb_unconditionalbranch;
    wire wb_csr;
    wire [4:0] wb_rd_addr;               
    wire [`ALUSEL_SIZE] alusel;
    wire [`ALUSEL_SIZE] em_alusel;
    wire [`DATA_SIZE] pipepc,pipepc4;
    wire [`DATA_SIZE] mepcWire;
    wire [`DATA_SIZE] InterrRegWire;
    wire interruptEdge, interruptEdge2;
    wire [`DATA_SIZE] handlerpc;
    wire [`DATA_SIZE] mepcout;
    wire [`DATA_SIZE] em_mepcout;
    wire instructionRet;
    
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
    
    
 
   
   assign nextpc = (interruptEdge2 && mipWire[1]) ? handlerpc : em_jalr ? aluout : (branch_taken | em_jal? branch_PC: pc4); //2nd stage//check check
    //branch, unconditional
    //assign pc4 = pc + 2; // +4 became + 2-----------------------------------------------------------------------
    PC_Incrementor pc4_2(
                .not_compressed(not_compressed), 
                .PC(pc),
                .PC_Next(pc4)
            );

    assign unconditionalbranch = jal | jalr | mret_identifier | ecall_identifier | ebreak_identifier;
    
    Register #(`THIRTY_TWO) pcreg (
        .clk(clk),
        .rst(rstsync),
        .load(ssignal),//change to signal
        .data_in(nextpc), //next PC MUX NEEEDED
        .data_out(pc)
    );
    
    CompressedInstExtender extender (
        .compressed_inst(fetchedinst),
        .extended_inst(instregin),
        .not_compressed(not_compressed)
    );
    
    Register #(`THIRTY_TWO) instreg (
        .clk(clk),
        .rst(rstsync),
        .load(ssignal),
        .data_in(instregin),
        .data_out(inst)
    );
        
 Register #(`SIXTY_FOUR) pipelinepcreg (
           .clk(clk),
           .rst(rstsync),
           .load(ssignal),//change to signal
           .data_in({pc,pc4}), //next PC MUX NEEEDED
           .data_out({pipepc,pipepc4})
       );
       
    
    rv32_ImmGen immgen(
        .IR(inst),
        .Imm(immediate)
    );
    
    
    ControlUnit cunit(
        .opcode({inst[`IR_opcode], inst[1:0]}),
        .funct3(inst[`IR_funct3]),
        .csr_code(inst[`IR_csr]),
        .alu_src_two_sel(alu_src_two_sel),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write_back(reg_write_back),
        .branch(branch),
        .lui(lui),
        .jal(jal),
        .jalr(jalr),
        .auipc(auipc),
        .csr(csr),
        .csr_read_write(csr_read_write),
        .csr_src1_sel_imm(csr_src1_sel_imm),
        .csr_src1_sel_rc(csr_src1_sel_rc),
        .csr_src2_sel(csr_src2_sel),
        .ebreak_identifier(ebreak_identifier),
        .ecall_identifier(ecall_identifier),
        .mret_identifier(mret_identifier)
    );
    
    assign write = wb_reg_write_back & ssignal; //was ~signal - added wb_mem_read
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
    
    assign csr_write_in =  wb_csr & ssignal;
    assign csr_addr = csr_write_in ? wb_csr_addr : inst[`CSR_ADDR_LOCATION];
    
    
    
    Register #(`THIRTY_TWO) interruptPC (
            .clk(clk),
            .rst(rstsync),
            .load(~ssignal),
            .data_in(pc),
            .data_out(InterrRegWire)
        );
        wire [4:0]interrupt_being_handled;
        wire [4:0]interrupt_will_be_handled;
    
    Register #(5) waitingInterrupts(
            .clk(clk),
            .rst(rstsync),
            .load(interruptEdge),
            .data_in(interrupt_will_be_handled),
            .data_out(interrupt_being_handled)
    ); 
    
    wire forceBitReset; 
    wire forceBitInterrupt;
    wire timerSolved; 
   
    assign forceBitReset = rstsync | em_mret&ssignal;
    
    Register #(1) ForceBit(
                .clk(clk),
                .rst(forceBitReset),
                .load(interrupt_indicator),
                .data_in(interrupt_indicator),
                .data_out(forceBitInterrupt)
        ); 
        
    assign mepcWire =  mipWire[1] ? InterrRegWire : em_pc4 ;
    assign instructionRet =  (  em_mem_read || 
                                em_mem_write ||
                                em_reg_write_back || 
                                em_branch || 
                                em_unconditionalbranch ||
                                em_ebreak ||
                                em_ecall) 
                                && ssignal;
    
    assign timerSolved = em_mret & interrupt_being_handled[2];
    
    CSR csr_file (
        .clk(clk),
        .rst(rstsync),
        .interrupt_indicator(interruptEdge),
        .instruction_retired(instructionRet),
        .timerSolved(timerSolved),
        .PC(mepcWire),
        .address(csr_addr),
        .dataIn(wb_aluout),
        .CSRwrite(csr_write_in),
        .CSRout(csr_data_out),
        .mieSignals(mie_csr_file_con_block),
        .mipInput(mipWire),
        .timerInterrupt(time_int_file_con_block),
        .mepcout(mepcout)
        );
        
    Concurrency_Block con_block(
        .NMI(NMI),
        .ECALL(ecall_identifier),
        .EBREAK(ebreak_identifier),
        .TMR(time_int_file_con_block),
        .INT(status),
        .int_index(interrupt_index),
        .MIE_output(mie_csr_file_con_block),
        .interrupt_indicator(interrupt_indicator),
        .handler_location(handlerpc),
        .MIP_input(mipWire),
        .all_interrupts(interrupt_will_be_handled) //5bits
        );
        
        
     RisingEdgeDetector edgedetector(
            .clk(clk),
            .rst(rst),
            .signal(forceBitInterrupt),
            .signal_edge(interruptEdge)
            );
            
    RisingEdgeDetector2Cycle edgedetector2cycle(
            .clk(clk),
            .rst(rst),
            .signal(forceBitInterrupt),
            .signal_edge(interruptEdge2)
            );

    
    assign rs2_muxout = alu_src_two_sel? immediate : rs2;
    assign rs2_muxout_csr = csr_src2_sel ? csr_data_out : rs2_muxout;


    ForwardingUnit fu(
        .opcode(inst[6:2]),
        .rs1(rs1_addr), 
        .rs2(inst[`IR_rs2]), 
        .rd(em_rd_addr), 
        .reg_write(em_reg_write_back|em_mem_read), 
        .forward_a(forward_a), 
        .forward_b(forward_b),  
        .forward_store(forward_store)
        );
        
        
        wire pipeline1rst;
        assign pipline1rst = rstsync || (interruptEdge2 && mipWire[1]);
        
        
   Register #(317) Pipeline_1 (
        .clk(clk),
        .rst(pipline1rst),
        .load(~ssignal), //CHECK THIS!!//stayed the same
        .data_in({
                  handlerpc,
                  mret_identifier,
                  ecall_identifier,
                  ebreak_identifier,
                  mepcout,
                  rs2,
                  auipc,
                  jal, 
                  jalr, 
                  immediate[31:0],
                  lui, 
                  inst[`IR_funct3],
                  pipepc4, 
                  pipepc, 
                  mem_read, 
                  mem_write, 
                  reg_write_back, 
                  branch, 
                  unconditionalbranch, 
                  inst[`IR_rd], 
                  rs1, 
                  rs2_muxout_csr, 
                  forward_a, 
                  forward_b, 
                  forward_store,
                  alusel,
                  csr_read_write,
                  csr_src1_sel_imm,
                  csr_src1_sel_rc,
                  csr,
                  inst[`CSR_ADDR_LOCATION]}),
        .data_out({
                    em_handlerpc,
                   em_mret,
                   em_ecall,
                   em_ebreak,
                   em_mepcout,
                   em_rs2,
                   em_auipc,
                   em_jal, 
                   em_jalr, 
                   em_immediate[31:0],
                   em_lui, 
                   em_func3,
                   em_pc4, 
                   em_pc, 
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
                   em_forward_store,
                   em_alusel,
                   em_csr_read_write,
                   em_csr_src1_sel_imm,
                   em_csr_src1_sel_rc,
                   em_csr,
                   em_csr_addr})
    );

    MUX2x1 #(`THIRTY_TWO) forwardA  (
        .A(em_rs1), //rs1
        .B(rfwritedata), //pipline 2
        .sel(em_forward_a),
        .out(aluin_1)
    );
    
    assign aluin_1_imm = em_csr_src1_sel_imm ? immediate : aluin_1;
    assign aluin_1_imm_xor = em_csr_src1_sel_rc ? aluin_1_imm ^ `ONES_DATA  : aluin_1_imm; 
    
    MUX2x1 #(`THIRTY_TWO) forwardB  (
        .A(em_rs2_muxout),//rs2
        .B(rfwritedata), //pipline 2
        .sel(em_forward_b),
        .out(aluin_2)
    ); 

    //Excute-Memory Register
    //----------------- SECOND STAGE - EXEC-MEM --------------------------------
     
    ALU alu(
        .sel(em_alusel), 
        .A(aluin_1_imm_xor), 
        .B(aluin_2), 
        .out(aluout), 
        .ZeroFlag(zf),
        .Cout(c),
        .SignedBit(s),
        .Overflow(v)
    );
    assign branch_PC =  em_mret ? em_mepcout :  (em_ebreak | em_ecall) ? em_handlerpc : (em_pc + em_immediate);

    BranchControlUnit bcu(
        .branch(em_branch),
        .ssignal(`ONE_1),
        .unconditionalbranch(em_unconditionalbranch),
        .func3(em_func3),
        .zeroflag(zf),
        .cout(c),
        .signbit(s),
        .overflow(v),
        .takebranch(branch_taken)//or temp
    );

   
    assign memaddressmuxout = (em_mem_read|em_mem_write)&ssignal ? aluout : pc; //was signal
    
    Memory memory(
        .clk(clk),
        .slow_signal(ssignal),
        .nexta(nextpc[1:0]),
        .address(memaddressmuxout),
        .data(meminputmuxout),
        .memread(em_mem_read),
        .memwrite(em_mem_write),
        .funct3(em_func3),
        .dataout(memout) //its rd_data! //rd_EX_MEM
    );
    
    assign meminputmuxout =  em_forward_store ? rfwritedata : em_rs2;
    assign aluout_rs1 =  em_csr_read_write ? aluin_1 : aluout;
    assign memout_rs2 = em_csr ? aluin_2 : memout ; 
 
   Register #(152) Pipeline_2 (
        .clk(clk),
        .rst(rstsync),
        .load(~ssignal), //CHECK THIS!! //was signal
        .data_in({em_auipc,
                  em_lui,
                  em_mem_read,
                  em_pc4,
                  branch_PC,
                  em_reg_write_back,
                  em_branch,
                  em_unconditionalbranch, 
                  em_rd_addr, 
                  memout_rs2, 
                  aluout_rs1,
                  em_csr,
                  em_csr_addr}),
        .data_out({wb_auipc,
                   wb_lui,
                   wb_mem_read,
                   wb_pc4,
                   wb_auipcdata,
                   wb_reg_write_back,
                   wb_branch,
                   wb_unconditionalbranch, 
                   wb_rd_addr, 
                   wb_memout, 
                   wb_aluout,
                   wb_csr,
                   wb_csr_addr})
    );
  
  //we dnt need lui or imm with us now bs keep it just n case
  
    //----------------- THIRD STAGE - WB --------------------------------
    //wbjalr and jal = aluout = Pipeline_2_RegOut[31:0]
    //wblui = immediate = Pipeline_2_RegOut[103:72]
    //wbmemread = rd data = memout = Pipeline_2_RegOut[63:32]
    //wbpc4 = pc4 = Pipeline_2_RegOut[135:104]
    //
//    assign rfwritedata = wb_lui ? wb_immediate :  wb_unconditionalbranch ? wb_pc4 : wb_mem_read? wb_memout : wb_aluout;
    assign rfwritedata = wb_unconditionalbranch ? wb_pc4 : (wb_mem_read | wb_csr )? wb_memout : wb_auipc ? wb_auipcdata : wb_aluout ;

    assign rs2in = write ? wb_rd_addr: inst[24:20];

    //MUX2x1 #(`THIRTY_TWO) irmux(memout,`NOP, branch_taken,fetchedinst); //FLUSH SIGNAL 
    assign fetchedinst =  branch_taken|interruptEdge2 ? `NOP: memout; 
   

    
endmodule


