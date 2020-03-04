module fa_cla_4bit (
  input [3:0] A, B,
  input Cin,
  output [4:0] F
);

  // Even though we're not carrying the cout from
  // each bit to the cin of the next, we need to
  // create a wire to connect to the FA output
  wire [3:0] Cout;

  // These are the P and G values that are
  // connected between the adder phases and the
  // lookahead logic.  A wire is needed to be
  // able to connect them together in the module
  wire [3:0] P, G;

  // This will be the set of wires that connects
  // the output of the lookahead logic to the
  // cin inputs of each of the FA stages
  wire [4:1] Carry;

  fa_cla inst_0(      Cin, A[0], B[0], Cout[0], F[0], P[0], G[0] );
  fa_cla inst_1( Carry[1], A[1], B[1], Cout[1], F[1], P[1], G[1] );
  fa_cla inst_2( Carry[2], A[2], B[2], Cout[2], F[2], P[2], G[2] );
  fa_cla inst_3( Carry[3], A[3], B[3], Cout[3], F[3], P[3], G[3] );

  // The most significant bit of the output is the
  // carry out of the last FA stage.  We can look
  // ahead to get that one as well.  This is just
  // a dataflow assignment to connect it to the
  // correct output
  assign F[4] = Carry[4];

  // This is the instantiation of the logic that
  // computes the carry into each phase of the FA.
  // Rather than place the logic right here I've
  // encapsulated it into another level of
  // hierarchy to keep it together and not clutter
  // the top level design
  fa_cla_4bit_lookahead inst_la( Cin, P, G, Carry );

endmodule

module fa_cla_4bit_lookahead (
  input Cin,
  input [3:0] P, G,
  output [4:1] Carry
);

  assign Carry[1] = ( P[0] & Cin  ) | G[0];

  assign Carry[2] = ( P[1] & P[0] & Cin ) |
    ( P[1] & G[0] ) | G[1];

  assign Carry[3] = ( P[2] & P[1] & P[0] & Cin ) |
    ( P[2] & P[1] & G[0] ) |
    ( P[2] & G[1] ) | G[2];

  assign Carry[4] = ( P[3] & P[2] & P[1] & P[0] & Cin ) |
    ( P[3] & P[2] & P[1] & G[0] ) |
    ( P[3] & P[2] & G[1] ) |
    ( P[3] & G[2] ) | G[3];

endmodule

module fa_cla_4bit_tb;

  reg [3:0] A, B;
  reg Cin;
  wire [4:0] F;

  integer i;

  fa_cla_4bit DUT( .A(A), .B(B), .Cin(Cin), .F(F) );

  initial begin
    $monitor( $time, ": %4b + %4b + %b = %4b",
      A, B, Cin, F );

    { Cin, A, B } = 0;
    for( i=1; i<2**9; i=i+1 ) begin
      #10 { Cin, A, B } = i;
    end

    #10 $stop;
  end

endmodule
