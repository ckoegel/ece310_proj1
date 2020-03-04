module hw4_q1b (
  input C,
  input [15:0] A, B,
  output [16:0] S
);

  // Intermediate carries
  wire [3:1] carry;

  BCD_digit_add ones(
    .cin(C),
    .a(A[3:0]),
    .b(B[3:0]),
    .cout(carry[1]),
    .sum(S[3:0])
  );

  BCD_digit_add tens(
    .cin(carry[1]),
    .a(A[7:4]),
    .b(B[7:4]),
    .cout(carry[2]),
    .sum(S[7:4])
  );

  BCD_digit_add hundreds(
    .cin(carry[2]),
    .a(A[11:8]),
    .b(B[11:8]),
    .cout(carry[3]),
    .sum(S[11:8])
  );

  BCD_digit_add thousands(
    .cin(carry[3]),
    .a(A[15:12]),
    .b(B[15:12]),
    .cout(S[16]),
    .sum(S[15:12])
  );

endmodule

module hw4_q1c;

  reg cin;
  reg [3:0] A [0:3];
  reg [3:0] B [0:3];
  wire [3:0] S [0:3];
  wire smsb;

  hw4_q1b DUT(
    .C(cin),
    .A({A[3],A[2],A[1],A[0]}),
    .B({B[3],B[2],B[1],B[0]}),
    .S({smsb,S[3],S[2],S[1],S[0]})
  );

  initial
  begin
    $monitor( $time, ": %x + %x%x%x%x + %x%x%x%x = %s%x%x%x%x",
      cin, A[3], A[2], A[1], A[0],
      B[3], B[2], B[1], B[0],
      smsb ? "1" : "", S[3], S[2], S[1], S[0]
    );

    cin = 0;
    A[3] = 4'h1; A[2] = 2; A[1] = 3; A[0] = 4;
    B[3] = 4'h5; B[2] = 6; B[1] = 7; B[0] = 8;

    #10 $stop;
  end

endmodule
