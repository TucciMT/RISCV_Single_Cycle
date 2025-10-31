module Decoder_stage (
    input wire clk,
    input wire rst,
    input wire RegWrite_WB,
    input wire [31:0] Instr_ID,
    input wire [31:0] Result_WB,
    input wire [4:0] Rd_WB,
    output wire RegWrite_ID,
    output wire MemWrite_ID,
    output wire Branch_ID,
    output wire ALUSrc_ID,
    output wire ResultSrc_ID,
    output wire [1:0] ImmSrc_ID,
    output wire [2:0] ALUControl_ID,
    output wire [4:0] Rd_ID,
    output wire [31:0] RD1_ID,
    output wire [31:0] RD2_ID,
    output wire [31:0] ImmExt_ID,
    input wire [31:0] PC_ID,
    output wire [1:0] size_ID,        // NOVO: tamanho da operação de memória
    output wire sign_ext_ID          // NOVO: tipo de extensão (sinal/zero
);

wire [24:0] InstrExtend;
wire [6:0] op;
wire [2:0] funct3;
wire [4:0] A1;
wire [4:0] A2;
wire [4:0] A3;
wire funct7;

//ASSIGN wire DOS WIRES NECESSÁRIOS
assign InstrExtend  = Instr_ID[31:7];  //!Extração dos bits de Instr referentes à entrada do EXTEND
assign op           = Instr_ID[6:0];   //!Extração dos bits de Instr referentes ao op da CONTROL_UNIT
assign Rd_ID        = Instr_ID[11:7];   //!Extração dos bits de Instr referentes ao op da CONTROL_UNIT
assign funct3       = Instr_ID[14:12]; //!Extração dos bits de Instr referentes ao funct3 da CONTROL_UNIT
assign A1           = Instr_ID[19:15]; //!Extração dos bits de Instr referentes ao A1 do REGISTER_FILE
assign A2           = Instr_ID[24:20]; //!Extração dos bits de Instr referentes ao A2 do REGISTER_FILE
assign A3           = Instr_ID[11:7];  //!Extração dos bits de Instr referentes ao A3 do REGISTER_FILE
assign funct7       = Instr_ID[30];    //!Extração dos bits de Instr referentes ao funct7 da CONTROL_UNIT

//REGISTER_FILE
register_file REGISTER_FILE (
    .clk(~clk),      //!Clock
    .rst(rst),      //!Reset
    .WE3(RegWrite_WB), //!Controle do REGISTER_FILE
    .A1(A1),        //!Endereço do primeiro registrador de leitura
    .A2(A2),        //!Endereço do segundo registrador de leitura
    .A3(Rd_WB),        //!Endereço do registrador de escrita
    .WD3(Result_WB),   //!Dados a serem escritos no registrador
    .RD1(RD1_ID),      //!Dados lidos do primeiro registrador
    .RD2(RD2_ID)       //!Dados lidos do segundo registrador
);

//CONTROL_UNIT
Control_Unit CONTROL_UNIT (
    .Op(op),                //!Sinal de lógica da CONTROL_UNIT
    .funct3(funct3),        //!Sinal de lógica da CONTROL_UNIT
    .funct7(funct7),        //!Sinal de lógica da CONTROL_UNIT
    .ResultSrc(ResultSrc_ID),  //!Sinal de seleção do multiplexador MUX_RESULT
    .MemWrite(MemWrite_ID),    //!Sinal de habilitação de escrita (ativo em 1) de DATA_MEMORY 
    .ALUSrc(ALUSrc_ID),        //!Sinal de seleção do multiplexador MUX_SRCB
    .ImmSrc(ImmSrc_ID),        //!Sinal de seleção do tipo de extensão a ser realizada pelo EXTEND
    .RegWrite(RegWrite_ID),    //!Sinal de habilitação de escrita (ativo em 1) de REGISTER_FILE
    .ALUControl(ALUControl_ID), //!Sinal de seleção da operação realizada pela ALU
    .Branch(Branch_ID),
    .size(size_ID),    //  00=byte, 01=half, 10=word
    .sign_ext(sign_ext_ID)       //  0=sign extend, 1
);

//EXTEND
extend EXTEND (
    .instr(InstrExtend),    //!Instrução a ser processada
    .immsrc(ImmSrc_ID),        //!Comando contendo o tipo de extensão a ser realizada
    .immext(ImmExt_ID)         //!Saída contendo a extensão da instrução
);
    
endmodule