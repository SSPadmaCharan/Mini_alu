`timescale 1ns/1ps

module alu_unit_tb;
reg [3:0]a;
reg [3:0]b;
reg s_mux;
reg cb_in;
reg [4:0]exp;
reg [3:0]expected_d;
reg expected_b;

wire flag;
wire [3:0]result;


alu_unit dut(
    .a(a),
    .b(b),
    .cb_in(cb_in),
    .s_mux(s_mux),
    .flag(flag),
    .result(result)
);
integer i;
localparam total_test_cases_alu = 2**10;
localparam delay =10 ;
integer f_counter = 0;

initial begin
    $dumpfile("waveform_alu_unit.vcd");
    $dumpvars(0,alu_unit_tb);

    for (i =0 ;i<total_test_cases_alu ;i=i+1 ) begin

        {s_mux,cb_in,b,a}=i;

        #delay;

    if (s_mux==1'b0) begin

        exp=a+b+cb_in;
        if ({flag,result}==exp) begin
                 $display("PASS : Test Case %0d", i+1);
        
    end
    else
    begin
    $display("--------------------------------------");
    $display("FAIL : Test Case %0d", i);
    $display("A         = %b", a);
    $display("B         = %b", b);
    $display("Cin       = %b", cb_in);
    $display("s_mux     = %b",s_mux);
    $display("Expected  = %b", exp);
    $display("Received  = %b", {flag,result});
    $display("--------------------------------------");

    f_counter=f_counter + 1;
    end

    end

    else 
    begin
           expected_d = a - b - cb_in;
expected_b = ({1'b0,a} < ({1'b0,b} + cb_in));
exp = {expected_b, expected_d};


        if (exp=={flag,result}) begin

            $display("PASS : Test Case %0d", i+1);
            
        end

        else 
        begin
    $display("--------------------------------------");
    $display("FAIL : Test Case %0d", i);
    $display("A         = %b", a);
    $display("B         = %b", b);
    $display("Cin       = %b", cb_in);
    $display("s_mux     = %b",s_mux);
    $display("Expected  = %b", exp);
    $display("Received  = %b", {flag,result});
    $display("--------------------------------------");

    f_counter=f_counter + 1;
        end

    end

    

        
    end


 if (f_counter == 0)
    $display("RESULT : ALL TEST CASES PASSED");
else
    $display("RESULT : %0d TEST CASE(S) FAILED", f_counter);

$display("========== Logic unit Automated Test Completed ==========");
  $finish;




end
endmodule
