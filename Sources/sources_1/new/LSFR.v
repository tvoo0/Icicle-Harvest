`timescale 1ns / 1ps

module LSFR(
    input clk,
    output [7:0] RndN
    );
   
    wire [7:0] Q;
    wire [7:0] D;
    assign D[0] = (Q[0] ^ Q[5] ^ Q[6] ^ Q[7]);
    assign D[7:1] = Q[6:0];
    
    // Instantiate four FDRE Flip-Flops for the shift counter
    FDRE #(.INIT(1'b1)) RndQ0_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) RndQ1_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) RndQ2_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[2]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) RndQ3_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[3]), .Q(Q[3]));
    FDRE #(.INIT(1'b0)) RndQ4_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[4]), .Q(Q[4]));
    FDRE #(.INIT(1'b0)) RndQ5_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[5]), .Q(Q[5]));
    FDRE #(.INIT(1'b0)) RndQ6_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[6]), .Q(Q[6]));
    FDRE #(.INIT(1'b0)) RndQ7_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[7]), .Q(Q[7]));

    assign RndN = Q;
endmodule
