module Control_Unit (
    input [6:0] Op,
    input [2:0] funct3,
    input funct7,
    output ResultSrc,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [2:0] ALUControl,
    output Branch,
    output [1:0] size,   
    output sign_ext    
);

wire [1:0] ALUOp;

Main_decoder MainDecoder (
.Op(Op),
.funct3(funct3),
.Branch(Branch),
.ResultSrc(ResultSrc),
.MemWrite(MemWrite),
.ALUSrc(ALUSrc),
.ImmSrc(ImmSrc),
.RegWrite(RegWrite),
.ALUOp(ALUOp),
.size(size),   
.sign_ext(sign_ext)  
);

ALU_decoder ALUDecoder (
.ALUOp(ALUOp),
.funct3(funct3),
.funct7(funct7),
.op(Op[5]),
.ALUControl(ALUControl)
);
    
endmodule