module alu_unit(
    input [3:0]a,
    input [3:0]b,
    input cb_in,

    input s_mux,

   
    output reg [3:0]result,
    output reg flag
    
);


wire c_out;
wire b_out;
wire [3:0]s;
wire [3:0]d;

ripple_carry_adder u_adder(
    .a(a),
    .b(b),
    .c_in(cb_in),

    .s(s),
    .c_out(c_out)
);

ripple_sub u_subractor(
    .a(a),
    .b(b),
    .b_in(cb_in),

    .d(d),
    .b_out(b_out)
);

always @(*) begin

case (s_mux)
    1'b0:  result=s;
    1'b1: result=d;
    default: result = 4'b0000;

endcase

end
always @(*) begin

case (s_mux)
    1'b0: flag=c_out;
    1'b1: flag=b_out; 
    default: flag=0;

endcase


end

endmodule


