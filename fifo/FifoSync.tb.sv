module top;

  /////////////////////////////////////
  // Simulation

  parameter CYCLE = 30_0000;
  initial begin
    $dumpfile("build/FifoSync.vcd");
    $dumpvars(0, top);
    repeat (CYCLE) @(posedge clk);
    $finish;
  end

  /////////////////////////////////////
  // Clock

  reg clk = 0;
  always #5 clk = ~clk;

  /////////////////////////////////////
  // Events

  localparam period = 1;
  integer i;
  initial begin
    resetn = 0;
    #10;
    resetn = 1;

    for (i = 0; i <= 16; i = i + 1) begin
      // Fill Data
      input_data = i;
      write_en   = 1;
      #10;
      write_en = 0;
      #100;
    end
    for (i = 0; i <= 16; i = i + 1) begin
      // Get Data
      input_data = i;
      read_en = 1;
      #10;
      read_en = 0;
      #100;
    end

    // Read & Write at same time
    input_data = 'hAB;
    write_en = 1;
    read_en = 1;
    #10;
    write_en = 0;
    read_en  = 0;
    #100;

  end

  /////////////////////////////////////
  // Main module

  reg resetn;
  reg [7:0] input_data;
  wire [7:0] output_data;
  reg write_en;
  reg read_en;

  FifoSync fifo_sync (
      .resetn(resetn),
      .clk(clk),
      .input_data(input_data),
      .output_data(output_data),
      .write_en(write_en),
      .read_en(read_en)
  );

endmodule
