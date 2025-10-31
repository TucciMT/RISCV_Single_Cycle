module memByteAddressable32WF #(
    parameter DATA_WIDTH    = 32,
    parameter ADDRESS_WIDTH = 5   
) (
    input  wire                     clk,
    input  wire [3:0]               byteEnable,
    input  wire [ADDRESS_WIDTH-1:0] addr,  // endereço em BYTES
    input  wire [DATA_WIDTH-1:0]    din,
    output wire [DATA_WIDTH-1:0]    dout
);

    // word index (cada palavra tem 4 bytes) -> número de bits para index de palavra
    localparam WORD_ADDR_WIDTH = (ADDRESS_WIDTH > 2) ? (ADDRESS_WIDTH-2) : 1;
    wire [WORD_ADDR_WIDTH-1:0] word_addr = addr[ADDRESS_WIDTH-1:2];

    // Conecta 4 bancos de byte (LSB = byte 0)
    memory_write_first #(.DATA_WIDTH(8), .ADDRESS_WIDTH(WORD_ADDR_WIDTH)) mem_byte0 (
        .clk(clk),
        .we(byteEnable[0]),
        .addr(word_addr),
        .din(din[7:0]),
        .dout(dout[7:0])
    );

    memory_write_first #(.DATA_WIDTH(8), .ADDRESS_WIDTH(WORD_ADDR_WIDTH)) mem_byte1 (
        .clk(clk),
        .we(byteEnable[1]),
        .addr(word_addr),
        .din(din[15:8]),
        .dout(dout[15:8])
    );

    memory_write_first #(.DATA_WIDTH(8), .ADDRESS_WIDTH(WORD_ADDR_WIDTH)) mem_byte2 (
        .clk(clk),
        .we(byteEnable[2]),
        .addr(word_addr),
        .din(din[23:16]),
        .dout(dout[23:16])
    );

    memory_write_first #(.DATA_WIDTH(8), .ADDRESS_WIDTH(WORD_ADDR_WIDTH)) mem_byte3 (
        .clk(clk),
        .we(byteEnable[3]),
        .addr(word_addr),
        .din(din[31:24]),
        .dout(dout[31:24])
    );

endmodule