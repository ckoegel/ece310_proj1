module fa_cla (
  input cin, a, b,
  output cout, sum,
  output p, g
);

  assign p = a ^ b;
  assign g = a & b;

  assign sum  =   p ^ cin;
  assign cout = ( p & cin ) | g;

endmodule

module fa_cla_tb;

  integer i;
  wire p, g, cout, sum;
  reg cin, a, b;

  fa_cla DUT(
    .cin(cin),
    .a(a),
    .b(b),
    .cout(cout),
    .sum(sum),
    .p(p),
    .g(g)
  );

  initial begin
    $monitor( $time, ": %03b => %02b, %b, %b",
      { cin, a, b }, { cout, sum }, p, g );

    { cin, a, b } = 0;
    for( i=1; i<2**3; i=i+1 ) begin
      #10 { cin, a, b } = i;
    end

    #10 $stop;
  end

endmodule
