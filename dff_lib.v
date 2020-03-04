module dff #(
  parameter WIDTH=4
) (
  input rst_n, clk,
  input [WIDTH-1:0] D,
  output reg [WIDTH-1:0] Q
);

  always @( posedge clk )
  begin
    if( !rst_n )
      Q <= 0;
    else
      Q <= D;
  end

endmodule

module dff_en #(
  parameter WIDTH=4
) (
  input rst_n, en, clk,
  input [WIDTH-1:0] D,
  output reg [WIDTH-1:0] Q
);

  always @( posedge clk )
  begin
    if( !rst_n )
      Q <= 0;
    else
      if( en )
        Q <= D;
      else
        Q <= Q;
  end

endmodule
