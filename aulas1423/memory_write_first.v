module memory_write_first #(
    parameter DATA_WIDTH = 8,
    parameter ADDRESS_WIDTH = 4
) (
    input wire clk,
    input wire we,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

    localparam DEPTH = 1 << ADDRESS_WIDTH;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
        dout <= we ? din : mem[addr]; // escrita tem prioridade
    end

    always @(*) 
        dout <= mem[addr]; // leitura assíncrona

endmodule