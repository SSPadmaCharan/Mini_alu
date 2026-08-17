`timescale 1ns/1ps

module logic_unit_tb;
reg [3:0]a;
reg [3:0]b;
reg [2:0]s;
reg [3:0]exp;
wire [3:0]y;

logic_unit dut(
    .a(a),
    .b(b),
    .s(s),

    .y(y)
);
integer i;
localparam total_test_cases_logic = 2**(4+4+3) ;
localparam delay =0 ;
integer f_counter=0;


initial begin
    $dumpfile("waveform_logic_unit.vcd");
    $dumpvars(0,logic_unit_tb);

$display("========== Logic unit Automated Test Started ==========");
    for ( i=0 ;i<total_test_cases_logic ;i=i+1 ) begin
        {s,a,b}=i;
        #delay;

     if (s==3'b000) begin
        exp=a&b;
        
     end
    else if (s==3'b001) begin
        exp=a|b;
    end

  

    else if (s==3'b010) begin
        exp=a^b;
    end
    else if (s==3'b011) begin
        exp=~(a&b);
    end
    else if (s=='b100) begin
        exp=~(a|b);
    end
    else if (s==3'b101) begin
        exp=~(a^b);
    end

    else begin
        exp=4'b0000;

    end

    if (exp==y) begin
         $display("PASS : Test Case %0d", i+1);
        
    end
    else begin
         $display("--------------------------------------");
           $display("FAIL : Test Case %0d", i+1);
           $display("S=%b",s);
            $display("A=%b",a);
            $display("B=%b",b);
            $display("Expected=%b",exp);
            $display("Recieved=%b",y);
            $display("--------------------------------------");
    f_counter=f_counter+1;
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
