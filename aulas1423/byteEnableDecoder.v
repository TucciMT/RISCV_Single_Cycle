module byteEnableDecoder (
    input wire [1:0] addr_offset, // addr[1:0] mem alinhada
    input wire [1:0] size,        // funct3[1:0] 00: byte, 01: half, 10: word
    output reg [3:0] byteEnable,  // Saida em One Hot para Memoria
    input writeEnable             // Habilita escrita (vem do controle)
);
    always @(*) begin
        if (!writeEnable)
            byteEnable = 4'b0000;
        else begin
            case (size)
                2'b00: byteEnable = 4'b0001 << addr_offset; // SB
                2'b01: begin // SH
                    case (addr_offset)
                        2'b00: byteEnable = 4'b0011;
                        2'b01: byteEnable = 4'b0110;
                        2'b10: byteEnable = 4'b1100;
                        default: byteEnable = 4'b0000; // desalinhado
                    endcase
                end
                2'b10: byteEnable = 4'b1111; // SW
                default: byteEnable = 4'b0000;
            endcase
        end
    end
endmodule