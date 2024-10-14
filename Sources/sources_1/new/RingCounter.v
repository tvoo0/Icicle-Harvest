`timescale 1ns / 1ps

module RingCounter(
    input clk,
    input Advance,
    output [3:0] Qout
    );
    // Internal signals
    wire [3:0] Q;  // Register to hold the current state of the counter
    
    // Instantiate four FDRE Flip-Flops for the ring counter
    FDRE #(.INIT(1'b1)) QRC0_FF (.C(clk), .R(1'b0), .CE(Advance), .D(Q[3]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) QRC1_FF (.C(clk), .R(1'b0), .CE(Advance), .D(Q[0]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) QRC2_FF (.C(clk), .R(1'b0), .CE(Advance), .D(Q[1]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) QRC3_FF (.C(clk), .R(1'b0), .CE(Advance), .D(Q[2]), .Q(Q[3]));

    // Output the current state of the ring counter
    assign Qout[0] = Q[0];
    assign Qout[1] = Q[1];
    assign Qout[2] = Q[2];
    assign Qout[3] = Q[3];


endmodule