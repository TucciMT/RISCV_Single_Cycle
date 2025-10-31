module Main_decoder (
    input  [6:0] Op,
    input  [2:0] funct3,
    output reg Branch,
    output reg ResultSrc,
    output reg MemWrite,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg [1:0] size,    //  00=byte, 01=half, 10=word
    output reg sign_ext       //  0=sign extend, 1=zero extendNO
);

    // Instruções possíveis
    localparam lw     = 7'b0000011,
               sw     = 7'b0100011,
               R_type = 7'b0110011,
               beq    = 7'b1100011,
               addi   = 7'b0010011;

    always @(*) begin
        // valores padrão
        Branch    = 1'b0;
        ResultSrc = 1'b0;
        MemWrite  = 1'b0;
        ALUSrc    = 1'b0;
        ImmSrc    = 2'b00;
        RegWrite  = 1'b0;
        ALUOp     = 2'b00;
        size      = 2'b10;   // default: word
        sign_ext  = 1'b1;    // default: zero extend

        case (Op)
            lw: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ResultSrc = 1'b1;
                // Decodifica funct3 para loads
                case (funct3)
                    3'b000: begin size=2'b00; sign_ext=1'b0; end // LB
                    3'b001: begin size=2'b01; sign_ext=1'b0; end // LH
                    3'b010: begin size=2'b10; sign_ext=1'b0; end // LW
                    3'b100: begin size=2'b00; sign_ext=1'b1; end // LBU
                    3'b101: begin size=2'b01; sign_ext=1'b1; end // LHU
                endcase
            end
            sw: begin
                ImmSrc   = 2'b01;
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                // Decodifica funct3 para stores
                case (funct3)
                    3'b000: size=2'b00; // SB
                    3'b001: size=2'b01; // SH
                    3'b010: size=2'b10; // SW
                endcase
            end
            R_type: begin
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end
            beq: begin
                ImmSrc = 2'b10;
                Branch = 1'b1;
                ALUOp  = 2'b01;
            end
            addi: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b10;
            end
        endcase
    end

endmodule
