module invalid_BCD (
    input [3:0] A,
    output F
);

  assign F = ( A[3] & A[2] ) | ( A[3] & A[1] );

endmodule

module invalid_BCD_tb;

  reg [3:0] BCD;
  wire invalid;
  integer i;
  invalid_BCD DUT( .A(BCD), .F(invalid) );

  initial
  begin
    $monitor( $time, ": %04b is %s",
      BCD, invalid ? "invalid" : valid );
    
    BCD = 0;
    for( i=1; i<2**4; i=i+1 ) begin
      #10 BCD = i;
    end

    #10 $stop;
  end

endmodule
