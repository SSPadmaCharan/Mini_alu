module ripple_sub(
    input [3:0]a,
    input[3:0]b,
    input b_in,
    output [3:0]d,
    output b_out
);

wire [2:0]br;

full_sub sub1(
    .a(a[0]),
    .b(b[0]),
    .b_in(b_in),

    .d(d[0]),
    .b_out(br[0])
);


full_sub sub2(
    .a(a[1]),
    .b(b[1]),
    .b_in(br[0]),

    .d(d[1]),
    .b_out(br[1])
);


full_sub sub3(
    .a(a[2]),
    .b(b[2]),
    .b_in(br[1]),

    .d(d[2]),
    .b_out(br[2])
);


full_sub sub4(
    .a(a[3]),
    .b(b[3]),
    .b_in(br[2]),

    .d(d[3]),
    .b_out(b_out)
);

endmodule
