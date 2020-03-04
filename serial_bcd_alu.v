module serial_bcd_alu (
  input rst_n, clk, en, in,
  output result
);
  wire [15:0] A, B, nines_A;
  wire [19:0] AplusB, AminusB, negAplusB, alu_out;
  wire ctrl;
  wire [32:0] alu_in;
  reg en_1c, en_2c;

  sipo33 ser_in(
    .rst_n(rst_n),
    .clk(clk),
    .shift(en),
    .s_in(in),
    .p_out(alu_in)
  );

  assign A = alu_in[15:0];
  assign B = alu_in[31:16];
  assign ctrl = alu_in[32];

  nines_4 nines_comp_A ( .A(A), .nines_A(nines_A));

  hw4_q1b adder ( .C(1'b0), .A(A), .B(B), .S(AplusB));
  hw4_q1b subtractor ( .C(1'b0), .A(nines_A), .B(B), .S(negAplusB));

  assign AplusB[19:17] = 3'b0;
  assign negAplusB[19:17] = 3'b0;

  nines_4 nines_comp_sub ( .A(negAplusB), .nines_A(AminusB));

  assign alu_out = ctrl ? AminusB : AplusB;  

  assign alu_out[19:16] = 4'b0;
  assign AminusB[19:16] = 4'b0;

  always @(posedge clk)
  begin 
    if (~rst_n) begin
      en_1c <= 1'b0;
      en_2c <= 1'b0;
    end
    else begin 
      en_1c <= en;
      en_2c <= en_1c;
    end
  end

  piso20 out ( .rst_n(rst_n), .clk(clk), .capture(en_1c), .shift(~en_2c), .p_in(alu_out), .s_out(result));

endmodule

module nines_comp (
  input [3:0] pos,
  output [3:0] neg
);
  
  wire [3:0] not_pos;

  assign not_pos = ~pos;
  assign neg = not_pos + 10;

endmodule

module nines_4 (
  input [15:0] A,
  output [15:0] nines_A
);
  nines_comp thousands_A ( .pos(A[15:12]), .neg(nines_A[15:12]));
  nines_comp hundreds_A ( .pos(A[11:8]), .neg(nines_A[11:8]));
  nines_comp tens_A ( .pos(A[7:4]), .neg(nines_A[7:4]));
  nines_comp ones_A ( .pos(A[3:0]), .neg(nines_A[3:0]));
endmodule

module nines_comp_tb;

  reg [15:0] A, B, bcd;
  wire [15:0] bcd_neg;
  wire [19:0] negAplusB, nines_A, AminusB;

  nines_4 DUT ( .A(A), .nines_A(nines_A));
  hw4_q1b subtractor ( .C(1'b0), .A(nines_A), .B(B), .S(negAplusB));
  nines_4 nines_comp_sub ( .A(negAplusB), .nines_A(AminusB));
  assign negAplusB[19:16] = 0;
  assign AminusB[19:16] = 0;

  initial
  begin
    $monitor( $time, ": A=%1d%1d%1d%1d B=%1d%1d%1d%1d  9's A = %1d%1d%1d%1d A-B=%1d%1d%1d%1d",
	A[15:12], A[11:8], A[7:4], A[3:0],
	B[15:12], B[11:8], B[7:4], B[3:0],
        nines_A[15:12], nines_A[11:8], nines_A[7:4], nines_A[3:0],
	AminusB[15:12], AminusB[11:8], AminusB[7:4], AminusB[3:0]);
   A[15:12] = 2;
   A[11:8] = 3;
   A[7:4] = 7;
   A[3:0] = 9;
   B[15:12] = 1;
   B[11:8] = 5;
   B[7:4] = 9;
   B[3:0] = 1;
   #10  bcd = 9871;
   #10  bcd = 0012;
   #10  bcd = 1234;
   #10  bcd = 5555;
   #10  bcd = 6782;
   #10  bcd = 9082;
   #10  bcd = 8843;
   #10  bcd = 1760;
   #10  bcd = 9;

  end
endmodule


