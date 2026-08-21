//==============================================================================
// Module Name : full_adder
// Description :
// -----------------------------------------------------------------------------
// Behavioral model of a Full Adder using Verilog HDL.
//
// A Full Adder is a combinational logic circuit that performs the addition of
// three single-bit binary inputs:
//
//      A
//      B
//      Carry-In (Cin)
//
// It generates two outputs:
//
//      Sum
//      Carry-Out (Cout)
//
// In this implementation, the Full Adder is described directly using Boolean
// expressions instead of constructing the circuit from smaller modules. This
// modeling style focuses on the logical behavior of the circuit, making the
// design concise and easy to understand.
//
// Boolean Equations:
//
//      Sum  = A ^ B ^ Cin
//      Cout = (A & B) | (Cin & (A ^ B))
//
// This behavioral approach is commonly used for simple combinational circuits
// and demonstrates how digital logic can be described using continuous
// assignments in Verilog HDL.
//
// Truth Table:
//
//      A   B  Cin | Sum Cout
//     ------------|----------
//      0   0   0  |  0    0
//      0   0   1  |  1    0
//      0   1   0  |  1    0
//      0   1   1  |  0    1
//      1   0   0  |  1    0
//      1   0   1  |  0    1
//      1   1   0  |  0    1
//      1   1   1  |  1    1
//
// Author : Padma Charan S S
// Repository : Verilog Fundamentals
//==============================================================================

module full_adder(
   
    input wire a , b , c_in,
    output wire sum , c_out
);

assign sum = a ^ b ^ c_in;
assign c_out = (a & b) | (c_in & (a ^ b)); // or a&b|b&c|c&a

endmodule
