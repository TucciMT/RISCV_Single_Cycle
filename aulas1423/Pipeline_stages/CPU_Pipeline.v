module CPU_Pipeline (
    input clk, rst
);

// --- Estágio IF (Instruction Fetch) ---
wire [31:0] PCPlus4_IF, Instr_IF, PC_IF;

// --- Estágio ID (Instruction Decode) ---
wire [31:0] RD1_ID, RD2_ID, ImmExt_ID;
wire [4:0] Rd_ID;
wire [2:0] ALUControl_ID;
wire [1:0] ImmSrc_ID;
wire [1:0] size_ID;        // NOVO: tamanho da operação de memória
wire sign_ext_ID;          // NOVO: tipo de extensão (sinal/zero
wire RegWrite_ID, MemWrite_ID, Branch_ID, ALUSrc_ID, ResultSrc_ID;
reg [31:0] Instr_ID, PC_ID;


// --- Estágio EXE (Execute) ---
wire [31:0] ALUResult_EXE, WriteData_EXE, PCTarget_EXE;
wire PCSrc_EXE;
reg [31:0] RD1_EXE, RD2_EXE, PC_EXE, ImmExt_EXE;
reg [4:0] Rd_EXE;
reg [2:0] ALUControl_EXE;
reg Branch_EXE, ALUSrc_EXE, RegWrite_EXE, MemWrite_EXE, ResultSrc_EXE;
reg [1:0] size_EXE;         // NOVO: tamanho da operação de memória
reg sign_ext_EXE;          // NOVO: tipo de extensão (sinal/zero

// --- Estágio MEM (Memory Access) ---
wire [31:0] ReadData_MEM;
wire [31:0] WriteData_MEM, ALUResult_MEM;
reg [4:0] Rd_MEM;
reg MemWrite_MEM, ResultSrc_MEM, RegWrite_MEM;
reg [1:0] size_MEM;         // NOVO: tamanho da operação de memória
reg sign_ext_MEM;          // NOVO: tipo de extensão (sinal/zero)

// --- Estágio WB (Write Back) ---
wire [31:0] Result_WB;
reg [31:0] ReadData_WB, ALUResult_WB;
reg [4:0] Rd_WB;
reg ResultSrc_WB, RegWrite_WB;

always @(posedge clk) begin
    // --- Propagação do estágio IF para o ID ---
    // A instrução e seu endereço (PC) avançam para o estágio de decodificação.
    Instr_ID <= Instr_IF;
    PC_ID <= PC_IF;

    // --- Propagação do estágio ID para o EXE ---
    // Os dados lidos do banco de registradores (RD1, RD2), o imediato, o endereço do registrador
    // de destino (Rd) e todos os sinais de controle avançam para o estágio de execução.
    PC_EXE <= PC_ID;
    RD1_EXE <= RD1_ID;
    RD2_EXE <= RD2_ID;
    ImmExt_EXE <= ImmExt_ID;
    Rd_EXE <= Rd_ID;
    ALUControl_EXE <= ALUControl_ID;
    ALUSrc_EXE <= ALUSrc_ID;
    Branch_EXE <= Branch_ID;
    MemWrite_EXE <= MemWrite_ID;
    ResultSrc_EXE <= ResultSrc_ID;
    RegWrite_EXE <= RegWrite_ID;
    size_EXE <= size_ID;         // NOVO: tamanho da operação de memória
    sign_ext_EXE <= sign_ext_ID; // NOVO: tipo de extensão

    // --- Propagação do estágio EXE para o MEM ---
    // O resultado da ALU, o dado a ser escrito na memória (vindo de RD2), o Rd e os
    // sinais de controle para MEM e WB avançam para o estágio de memória.
    // Os sinais Branch, ALUSrc e ALUControl não avançam, pois foram usados em EXE.
  
    Rd_MEM <= Rd_EXE;
    MemWrite_MEM <= MemWrite_EXE;
    ResultSrc_MEM <= ResultSrc_EXE;
    RegWrite_MEM <= RegWrite_EXE;
    size_MEM <= size_EXE;         // NOVO: tamanho da operação de memória
    sign_ext_MEM <= sign_ext_EXE; // NOVO: tipo de extensão 

    // --- Propagação do estágio MEM para o WB ---
    // O dado lido da memória, o resultado da ALU (que passou direto pelo estágio MEM),
    // o Rd e os sinais de controle para WB avançam para o estágio de escrita.
    // O sinal MemWrite não avança, pois foi usado em MEM.
    ReadData_WB <= ReadData_MEM;
    ALUResult_WB <= ALUResult_MEM;
    Rd_WB <= Rd_MEM;
    ResultSrc_WB <= ResultSrc_MEM;
    RegWrite_WB <= RegWrite_MEM;
end

assign ALUResult_MEM = ALUResult_EXE;
assign WriteData_MEM = WriteData_EXE;

Fetch_stage INSTRUCTION_FETCH (
    .clk(clk),
    .PCTarget_EXE(PCTarget_EXE),
    .PCSrc_EXE(PCSrc_EXE),
    .PCPlus4_IF(PCPlus4_IF),
    .Instr_IF(Instr_IF),
    .PC_IF(PC_IF)
);
    
Decoder_stage INSTRUCTION_DECODER (
    .clk(clk),
    .rst(rst),
    .RegWrite_WB(RegWrite_WB),
    .Instr_ID(Instr_ID),
    .Result_WB(Result_WB),
    .Rd_WB(Rd_WB),
    .RegWrite_ID(RegWrite_ID),
    .MemWrite_ID(MemWrite_ID),
    .Branch_ID(Branch_ID),
    .ALUSrc_ID(ALUSrc_ID),
    .ResultSrc_ID(ResultSrc_ID),
    .ImmSrc_ID(ImmSrc_ID),
    .ALUControl_ID(ALUControl_ID),
    .Rd_ID(Rd_ID),
    .RD1_ID(RD1_ID),
    .RD2_ID(RD2_ID),
    .ImmExt_ID(ImmExt_ID),
    .PC_ID(PC_ID),
    .size_ID(size_ID),
    .sign_ext_ID(sign_ext_ID)
);

Execution_stage EXECUTE (
    .Branch_EXE(Branch_EXE),
    .ALUSrc_EXE(ALUSrc_EXE),
    .ALUControl_EXE(ALUControl_EXE),
    .RD1_EXE(RD1_EXE),
    .RD2_EXE(RD2_EXE),
    .PC_EXE(PC_EXE),
    .ImmExt_EXE(ImmExt_EXE),
    .ALUResult_EXE(ALUResult_EXE),
    .PCTarget_EXE(PCTarget_EXE),
    .WriteData_EXE(WriteData_EXE),
    .PCSrc_EXE(PCSrc_EXE),
    .RegWrite_EXE(RegWrite_EXE),
    .MemWrite_EXE(MemWrite_EXE),
    .ResultSrc_EXE(ResultSrc_EXE),
    .Rd_EXE(Rd_EXE)
);

Memory_stage MEMORY (
    .clk(clk),
    .WriteData_MEM(WriteData_MEM),
    .MemWrite_MEM(MemWrite_MEM),
    .ReadData_MEM(ReadData_MEM),
    .ALUResult_MEM(ALUResult_MEM),
    .Rd_MEM(Rd_MEM),
    .ResultSrc_MEM(ResultSrc_MEM),
    .RegWrite_MEM(RegWrite_MEM),
    .size_MEM(size_MEM),           // NOVO: tamanho da operação de memória
    .sign_ext_MEM(sign_ext_MEM)    // NOVO: tipo de extensão (sinal/zero    
);

WriteBack_stage WriteBack (
    .ReadData_WB(ReadData_WB),
    .ALUResult_WB(ALUResult_WB),
    .ResultSrc_WB(ResultSrc_WB),
    .Result_WB(Result_WB),
    .Rd_WB(Rd_WB),
    .RegWrite_WB(RegWrite_WB)
);

endmodule