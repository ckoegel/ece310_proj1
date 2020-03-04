module sipo33 (
  input rst_n, clk, shift, s_in,
  output [32:0] p_out
);

  wire [32:0] shifted, nstate;

  dff #( .WIDTH(33) ) state (
    .rst_n( rst_n ),
    .clk( clk ),
    .D( nstate ),
    .Q( p_out )
  );

  assign shifted = {s_in, p_out } >> 1;

  assign nstate = shift ? shifted : p_out;

endmodule
