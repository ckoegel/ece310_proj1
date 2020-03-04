module piso20 (
  input rst_n, clk, capture, shift,
  input [19:0] p_in,
  output s_out
);

  wire [19:0] cstate, nstate;
  wire [19:0] next_shift, shifted;

  dff #( .WIDTH(20) ) state (
    .rst_n( rst_n ),
    .clk( clk ),
    .D( nstate ),
    .Q( cstate )
  );

  assign s_out = cstate[0];

  assign shifted = cstate >> 1;

  assign next_shift = shift ? shifted : cstate;
 
  assign nstate = capture ? p_in : next_shift;

endmodule   
