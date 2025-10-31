module memTopo32LittleEndian #(

    parameter DATA_WIDTH    = 32,
    parameter ADDRESS_WIDTH = 5
) ( 
    input  wire                     clk,        // Clock
    input  wire [1:0]               size,       // funct3[1:0] 00: byte, 01: half, 10: word
    input  wire [ADDRESS_WIDTH-1:0] addr,       // Endereco em BYTES
    input  wire [DATA_WIDTH-1:0]    din,        // Entrada de dados (rs2)
    input  wire                     sign_ext,   // funct3[2] 0: extensão de sinal , 1: zero extension
    input  wire                     writeEnable,// Habilita escrita (vem do controle)
    output wire [DATA_WIDTH-1:0]    dout        // Saida de dados (rdata)
);

    wire [3:0]  byteEnable;
    wire [31:0] mem_dout;
    wire [31:0] rdata;
    wire [31:0] adjusted_din; // Sinal ajustado para din

    // Ajusta din com base no addr_offset para byte e half-word
    assign adjusted_din = (size == 2'b10) ? din : (din << (8 * addr[1:0]));

    // Decodifica byte enables a partir do offset de byte
    byteEnableDecoder decoder (
        .addr_offset(addr[1:0]),
        .size(size),
        .writeEnable(writeEnable),
        .byteEnable(byteEnable)
    );

    // Memória byte-endereçável: passa endereço em bytes
    memByteAddressable32WF #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) mem_inst (
        .clk(clk),
        .byteEnable(byteEnable),
        .addr(addr),
        .din(adjusted_din), 
        .dout(mem_dout)
    );

    // Ajusta leitura conforme offset/tamanho e extensão
    memReadManager read_inst (
        .dout(mem_dout),
        .addr_offset(addr[1:0]),
        .size(size),
        .sign_extend(sign_ext),
        .rdata(rdata)
    );

    assign dout = rdata;

endmodule