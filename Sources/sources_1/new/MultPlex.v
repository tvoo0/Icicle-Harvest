`timescale 1ns / 1ps

module MultPlex(
    input s,
    input [7:0] i0,
    input [7:0] i1,
    output [7:0] y
    );
  
    
    assign y = (~{8{s}} & i0) | ({8{s}} & i1);
    
endmodule
