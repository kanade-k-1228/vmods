module FifoSync #(
    parameter integer DATA_W = 8,
    parameter integer FIFO_ADDR_W = 4,
    parameter integer FIFO_SIZE = 16
) (
    input wire resetn,
    input wire clk,
    input wire [DATA_W-1 : 0] input_data,
    output reg [DATA_W-1 : 0] output_data,
    input wire write_en,
    input wire read_en,
    output reg is_empty,
    output reg is_full
);

  // Local Registors
  reg [DATA_W-1 : 0] fifo_ram[0 : FIFO_SIZE-1];
  reg [FIFO_ADDR_W-1 : 0] write_ptr;
  reg [FIFO_ADDR_W-1 : 0] read_ptr;

  // FIFO
  always @(posedge clk) begin
    // Reset
    if (!resetn) begin
      write_ptr <= 0;
      read_ptr  <= 0;
      is_full   <= 0;
      is_empty  <= 1;
    end

    // Write
    if (!is_full & write_en) begin
      fifo_ram[write_ptr] <= input_data;  // Emplace Data
      write_ptr <= write_ptr + 1;  // Cyclic Adder
      is_full <= ((read_ptr - write_ptr) % 16 == 1) ? 1 : 0;  // Writer catch up with Rreader
      is_empty <= 0;
    end

    // Read
    if (!is_empty & read_en) begin
      output_data <= fifo_ram[read_ptr];  // Pop Data
      read_ptr    <= read_ptr + 1;  // Cyclic Adder
      is_empty    <= ((write_ptr - read_ptr) % 16 == 1) ? 1 : 0;  // Reader catch up with Writer
      is_full     <= 0;
    end
  end

endmodule
