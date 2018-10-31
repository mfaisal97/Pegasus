// file: ALU_Control_tb.v
// author: @melodyg
// Testbench for ALU_Control

`timescale 1ns/1ns

module ALU_Control_tb;

	//Inputs
	reg [4: 0] OpCode;
	reg [14: 12] Inst;
	reg Inst30;


	//Outputs
	wire [3: 0] ALU_Sel;


	//Instantiation of Unit Under Test
	ALU_Control uut (
		.OpCode(OpCode),
		.Inst(Inst),
		.Inst30(Inst30),
		.ALU_Sel(ALU_Sel)
	);


	initial begin
	//Inputs initialization
		OpCode = 0;
		Inst = 0;
		Inst30 = 0;
	//Wait for the reset
        #25
        OpCode = 5'b01101; //LUI -> ADD
        #25
        OpCode = 5'b00101; //AUIPC -> ADD
        #25
        OpCode = 5'b11011; //JAL -> ADD 
        #25
        OpCode = 5'b11001; //JALR -> ADD 
        #25
        OpCode = 5'b11000; //BEQ/BNE/BLT/BGE/BLTU/BGEU -> SUB 
        #25
        OpCode = 5'b00000; //LB/LH/LW/LBU/LHU -> ADD 
        #25
        OpCode = 5'b01000; //SB/SH/SW-> ADD 
        #25
        OpCode = 5'b00100; //ADDI -> ADD 
		Inst = 3'b000; 
        #25
        Inst = 3'b010; //SLTI -> SLT
        #25
        Inst = 3'b011; //SLTIU -> SLTU
        #25
        Inst = 3'b100; //XORI -> XOR
        #25
        Inst = 3'b110; //ORI -> OR
        #25
        Inst = 3'b111; //ANDI -> AND
        #25
        Inst = 3'b001; //SLLI -> SLL
        #25
        Inst = 3'b101; //SRLI -> SRL
        #25
        Inst = 3'b101; //SRAI -> SRA
		Inst30 = 1'b1;
        #25
        OpCode = 5'b01100; //ADD 
		Inst = 3'b000; 
		Inst30 = 1'b0;
		#25
        Inst30 = 1'b1; //SUB
		#25
        Inst = 3'b001; //SLL
		Inst30 = 1'b0;
		#25
        Inst = 3'b010; //SLT
		#25
        Inst = 3'b011; //SLTU
		#25
        Inst = 3'b100; //XOR
		#25
        Inst = 3'b101; //SRL
		#25
        Inst = 3'b101; //SRA
		Inst30 = 1'b1;
		#25
        Inst = 3'b110; //OR
		Inst30 = 1'b0;
		#25
        Inst = 3'b111; //AND
		#25;
	end

endmodule
