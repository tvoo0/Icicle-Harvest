`timescale 1ns / 1ps

module Selector(
    input [15:0] N,
    input [3:0] sel,
    output [3:0] H
    );
    
    assign H[3] = sel[3] & N[15] | sel[2] & N[11] | sel[1] & N[7] | sel[0] & N[3];
    assign H[2] = sel[3] & N[14] | sel[2] & N[10] | sel[1] & N[6] | sel[0] & N[2];
    assign H[1] = sel[3] & N[13] | sel[2] & N[9] | sel[1] & N[5] | sel[0] & N[1];
    assign H[0] = sel[3] & N[12] | sel[2] & N[8] | sel[1] & N[4] | sel[0] & N[0];
    
endmodule