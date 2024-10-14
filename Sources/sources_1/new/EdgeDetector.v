`timescale 1ns / 1ps

module EdgeDetector(
    input clk,
    input enter,
    output Edge
    );
    
    wire q0, q1;       // Previous state of enter

    // Use FDRE flip-flops to store the previous state of enter and detect edge
    FDRE #(.INIT(1'b0)) ff_1 (.C(clk), .R(1'b0), .CE(1'b1), .D(enter), .Q(q0));
    FDRE #(.INIT(1'b0)) ff_2 (.C(clk), .R(1'b0), .CE(1'b1), .D(q0), .Q(q1));

    assign Edge = q0 & ~q1;
endmodule
