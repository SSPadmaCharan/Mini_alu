module full_sub(
    input a,b,b_in,
    output d,b_out
);

assign d=a^b^b_in;
assign b_out = (~a & b) | (~a & b_in) | (b & b_in);
endmodule
