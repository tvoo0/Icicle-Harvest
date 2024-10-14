`timescale 1ns / 1ps

module SignChanger(
    input [7:0] a,
    input sign,
    output [7:0] d,
    output ovfl
    );
    
    wire [7:0] sum;
    wire p;
    wire [7:0] inverted_a;
    wire [8:0] d2;
    
    assign inverted_a = ~a;
    Add8 add(.A(d2), .B((8'b00000001 & sign) | (8'b00000000 & ~sign)), .Cin(1'b0), .S(d), .Cout(p));
    MultPlex m(.i0(a), .i1(~a), .s(sign), .y(d2));
    
    assign ovfl = ( a[7] & ~a[6] & ~a[5] & ~a[4] & ~a[3] & ~a[2] & ~a[1] & ~a[0] & sign);
endmodule
