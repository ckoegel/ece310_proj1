module serial_bcd_alu_tb;

  reg rst_n, clk;
  reg en, in;
  reg [19:0] rreg;

  wire result;

  serial_bcd_alu DUT (
    .rst_n( rst_n ),
    .clk( clk ),
    .en( en ),
    .in( in ),
    .result( result )
  );

  always #5 clk = ~clk;

  initial
  begin
    $monitor( $time, ": %0h%0h%0h%0h%0h",
      rreg[19:16], rreg[15:12], rreg[11:8],
      rreg[7:4], rreg[3:0]
    );

    clk = 0;
    rst_n = 0;

    en = 0;
    in = 0;

    #20 rst_n = 1;
    #50 en = 1;
        in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 1;
    #10 in = 1;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 1;
    #10 in = 1;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 en = 0;

    #500 en = 1;
        in = 1;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 1;
    #10 in = 1;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 1;
    #10 in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 en = 0;

    #500 $stop;
  end

  always @( posedge clk )
    if( !rst_n )
      rreg <= 0;
    else
      rreg <= { result, rreg[19:1] };

endmodule
