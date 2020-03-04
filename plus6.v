module p6_fa (
  input a, b, cin,
  output cout, sum
);

  wire p, g;

  assign p = a ^ b;
  assign g = a & b;

  assign sum = p ^ cin;
  assign cout = ( p & cin ) | g;

endmodule

module p6_fa_4bit (
  input [3:0] a, b,
  input cin,
  output [4:0] sum
);

  wire [4:1] carry;

  p6_fa bit0 ( a[0], b[0],      cin, carry[1], sum[0] );
  p6_fa bit1 ( a[1], b[1], carry[1], carry[2], sum[1] );
  p6_fa bit2 ( a[2], b[2], carry[2], carry[3], sum[2] );
  p6_fa bit3 ( a[3], b[3], carry[3], carry[4], sum[3] );

  assign sum[4] = carry[4];

endmodule

module plus6_str (
  input [3:0] a,
  output [3:0] f
);

  wire [3:0] b;
  wire cin;
  wire [4:0] tmp_sum;
  wire cout;

  // This is the constant 6 value
  assign b = 4'b0110;
  assign cin = 1'b0;

  p6_fa_4bit plus6 ( a, b, cin, tmp_sum );

  assign { cout, f } = tmp_sum;

endmodule

module plus6_dfl (
  input [3:0] a,
  output [3:0] f
);

  assign f[0] = a[0];
  assign f[1] = ~a[1];
  assign f[2] = ( (~a[2]) & (~a[1]) ) | 
    a[2] & a[1];
  assign f[3] = ( a[3] & (~a[2]) & (~a[1]) ) |
    ( (~a[3]) & a[2] ) |
    ( (~a[3]) & a[1] );

endmodule

module plus6_tb;

  reg [3:0] A;
  wire [3:0] F_STR, F_DFL;
  integer i;

  plus6_str DUT_STR ( A, F_STR );
  plus6_dfl DUT_DFL ( A, F_DFL );

  initial
  begin
    $monitor( $time, ": %04b (%2d) + 6 = %04b (%2d); %04b (%2d)",
      A, A, F_STR, F_STR, F_DFL, F_DFL );

    A = 0;
    for( i=1; i<2**4; i=i+1 ) begin
      #10 A = i;
    end

    #10 $stop;
  end

endmodule
