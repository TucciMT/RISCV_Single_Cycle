module Memory_stage (
    input  wire        clk,
    input  wire [31:0] WriteData_MEM,
    input  wire        MemWrite_MEM,
    output wire [31:0] ReadData_MEM,
    input  wire [31:0] ALUResult_MEM,
    input  wire [4:0]  Rd_MEM,
    input  wire        ResultSrc_MEM,
    input  wire        RegWrite_MEM,
    input  wire [1:0]  size_MEM,     
    input  wire        sign_ext_MEM  
);

    // Instância da nova memória
    memTopo32LittleEndian DATA_MEMORY (
        .clk(clk),
        .size(size_MEM),
        .addr(ALUResult_MEM), 
        .din(WriteData_MEM),
        .sign_ext(sign_ext_MEM),
        .writeEnable(MemWrite_MEM),
        .dout(ReadData_MEM)
    );

endmodule
