module BCD_digit_add (
  input cin,
  input [3:0] a, b,
  output cout,
  output [3:0] sum
);

  // This is the carry from the simple addition
  wire carry;

  // This is the 4 bit sum from the simple add
  wire [3:0] tmp_sum;

  // This holds whether the sum was invalid
  wire sum_invalid;

  // This holds the tmp sum plus 6 for us to
  // choose
  wire [3:0] tmp_sum_p6;

  // To add two BCD digits together we need to
  // add them as we would any 4 bit number and
  // check to see if a carry was generated or
  // if the resulting value is an invalid BCD
  // code word.  In either case we need to add
  // 6 to the quantity and assert a carry;
  // otherwise we simply send on the 4 bit
  // result

  // Since this is not a procedural language and
  // everything is running all the time (think
  // hardware) then we instantiate the constructs
  // to perform the functions we need and just
  // select the result we want to send

  // This is the 4-bit adder that simply adds
  // the two values together as binary; notice
  // that I connected the concatenation of an
  // internal carry and temporary sum to the
  // 5 bit adder output to separate the carry
  // from the sum
  fa_cla_4bit binary_add (
    .A(a),
    .B(b),
    .Cin(cin),
    .F({carry, tmp_sum})
  );

  // The tmp_sum needs to be evaluated whether
  // it is a valid BCD value or not
  invalid_BCD valid_result (
    .A(tmp_sum),
    .F(sum_invalid)
  );

  // In the meantime we're also computing the plus
  // 6 value of tmp_sum and we'll select which we
  // want to use with a mux
  plus6_dfl sum_plus6 (
    .a(tmp_sum),
    .f(tmp_sum_p6)
  );

  // Now we need to select between the two sums
  // based on whether there was a carry or there
  // was an invalid BCD value
  assign cout = carry | sum_invalid;

  // Even though we're sending the cout to the top
  // of the digit adder we can use it internally
  // for our mux
  assign sum = cout ? tmp_sum_p6 : tmp_sum;

endmodule

module BCD_digit_add_tb;

  integer i, j, k;

  reg cin;
  reg [3:0] a, b;
  wire cout;
  wire [3:0] sum;

  BCD_digit_add DUT (
    .cin(cin),
    .a(a),
    .b(b),
    .cout(cout),
    .sum(sum)
  );

  initial
  begin
    $monitor( $time, ": %1b + %1d + %1d = %1b%1x",
      cin, a, b, cout, sum );

    cin = 0; a = 0; b = 0;
    for(i=0;i<2;i=i+1) begin
      for(j=0;j<10;j=j+1) begin
        for(k=1;k<10;k=k+1) begin
          #10 cin = i; a = j; b = k;
        end
      end
    end

    #10 $stop;
  end

endmodule
