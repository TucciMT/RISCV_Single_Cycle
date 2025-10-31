module Execution_stage (
    input wire Branch_EXE,
    input wire ALUSrc_EXE,
    input wire [2:0] ALUControl_EXE,
    input wire [31:0] RD1_EXE,
    input wire [31:0] RD2_EXE,
    input wire [31:0] PC_EXE,
    input wire [31:0] ImmExt_EXE,
    output wire [31:0] ALUResult_EXE,
    output wire [31:0] PCTarget_EXE,
    output wire [31:0] WriteData_EXE,
    output wire PCSrc_EXE,
    input wire RegWrite_EXE,
    input wire MemWrite_EXE,
    input wire ResultSrc_EXE,
    input wire [4:0] Rd_EXE

);

wire [31:0] ALUSrcB; //!Entrada B da ALU
wire Zero_EXE;


assign PCSrc_EXE = Zero_EXE & Branch_EXE;
assign WriteData_EXE = RD2_EXE;

//MUX_SRCB
Mux2x1 #(
    .N(32)          //!Multiplexador 2x1 de 32 bits
) MUX_SRCB (
    .a(RD2_EXE),        //!Entrada "0"
    .b(ImmExt_EXE),     //!Entrada "1"
    .sel(ALUSrc_EXE),   //!Sinal de seleção
    .y(ALUSrcB)      //!Saída do multiplexador
);

//ALU
ALU ALU(
    .SrcA(RD1_EXE),                //!Entrada A da ALU
    .SrcB(ALUSrcB),                //!Entrada B da ALU
    .ALUControl(ALUControl_EXE),    //!Sinal de controle da ALU
    .ALUResult(ALUResult_EXE),      //!Resultado da ALU
    .Zero(Zero_EXE)                 //!Indicativo se o resultado da operação for zero
);

//ADDER_PCTARGET
adder ADDER_PCTARGET (
    .a(PC_EXE),         //!Endereço atual do PROGRAM_COUNTER para gerar PCTarget
    .b(ImmExt_EXE),     //!Instrução estendida para gerar PCTarget
    .sum(PCTarget_EXE)  //!Sinal de entrada do MUX do PCTarget (Entrada 1)
);
    
endmodule