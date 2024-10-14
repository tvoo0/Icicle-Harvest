module Add8(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0]S,
    output Cout
    );
    
    wire[7:0] C;
    
    fulladd A1(A[0],B[0],Cin,S[0],C[0]);
    fulladd A2(A[1],B[1],C[0],S[1],C[1]);
    fulladd A3(A[2],B[2],C[1],S[2],C[2]);
    fulladd A4(A[3],B[3],C[2],S[3],C[3]);
    fulladd A5(A[4],B[4],C[3],S[4],C[4]);
    fulladd A6(A[5],B[5],C[4],S[5],C[5]);
    fulladd A7(A[6],B[6],C[5],S[6],C[6]);
    fulladd A8(A[7],B[7],C[6],S[7],Cout);

endmodule


module fulladd(
    
    input A,
    input B,
    input Cin,
    output S,
    output Cout
    );
    
    assign S = (A^B^Cin);
    assign Cout = ((A&B) | (B&Cin) | (A&Cin));

endmodule