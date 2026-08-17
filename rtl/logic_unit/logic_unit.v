module logic_unit(
    input [3:0]a,
    input [3:0]b,
    input [2:0]s,
    output reg [3:0]y
    
);

wire [3:0]and_r;
wire [3:0]xnor_r;
wire [3:0]xor_r;
wire [3:0]or_r;
wire [3:0]nor_r;
wire [3:0]nand_r;

and_g u_and(
    .a(a),
    .b(b),
    .y(and_r)
);

nand_g u_nand(
    .a(a),
    .b(b),
    .y(nand_r)
);

or_g u_or(
    .a(a),
    .b(b),
    .y(or_r)
);

nor_g u_nor(
    .a(a),
    .b(b),
    .y(nor_r)
);

xor_g u_xor(
    .a(a),
    .b(b),
    .y(xor_r)
);

xnor_g u_xnor(
    .a(a),
    .b(b),
    .y(xnor_r)
);

always @(*) begin

    case (s)
       3'b000 : y=and_r ;
       3'b001 : y=or_r;
       3'b010 : y=xor_r;
       3'b011 : y=nand_r;
       3'b100 : y=nor_r;
       3'b101 : y=xnor_r;

        default: 
         y=4'b0000;

    endcase

    
end



endmodule




