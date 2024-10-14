`timescale 1ns / 1ps


module countUD4L(
    input clk,
    input UD,
    input CE,
    input LD,
    input [3:0] Din,
    output [3:0] Qout,
    output UTC,
    output DTC
    );
    //inc = UD (just to note)

    wire [3:0] D;
    wire [3:0] Q;
    wire [3:0] Increment, Decrement, Load;
    
    assign Increment[0] = ~LD & (UD & ((UD ^ Q[0])));
    assign Increment[1] = ~LD & (UD & ((UD & Q[0]) ^ Q[1]));
    assign Increment[2] = ~LD & (UD & ((UD & Q[0] & Q[1]) ^ Q[2]));
    assign Increment[3] = ~LD & (UD & ((UD & Q[0] & Q[1] & Q[2]) ^ Q[3]));
    
    assign Decrement[0] = ~LD & (~UD & (~UD ^ Q[0]));
    assign Decrement[1] = ~LD & (~UD & ((~UD & ~Q[0]) ^ Q[1]));
    assign Decrement[2] = ~LD & (~UD & ((~UD & ~Q[0] & ~Q[1]) ^ Q[2]));
    assign Decrement[3] = ~LD & (~UD & ((~UD & ~Q[0] & ~Q[1] & ~Q[2]) ^ Q[3]));
    
    assign Load[0] = (LD & Din[0]);
    assign Load[1] = (LD & Din[1]);
    assign Load[2] = (LD & Din[2]);
    assign Load[3] = (LD & Din[3]);
    
    assign D[0] = Increment[0] | Decrement[0] | Load[0];
    assign D[1] = Increment[1] | Decrement[1] | Load[1];
    assign D[2] = Increment[2] | Decrement[2] | Load[2];
    assign D[3] = Increment[3] | Decrement[3] | Load[3];
    
    FDRE #(.INIT(1'b0)) Q0_FF (.C(clk), .R(1'b0), .CE(CE | LD), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) Q1_FF (.C(clk), .R(1'b0), .CE(CE | LD), .D(D[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) Q2_FF (.C(clk), .R(1'b0), .CE(CE | LD), .D(D[2]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) Q3_FF (.C(clk), .R(1'b0), .CE(CE | LD), .D(D[3]), .Q(Q[3]));
    
    assign UTC = Q[0] & Q[1] & Q[2] & Q[3];
    assign DTC = ~Q[0] & ~Q[1] & ~Q[2] & ~Q[3];
    
    assign Qout[0] = Q[0];
    assign Qout[1] = Q[1];
    assign Qout[2] = Q[2];
    assign Qout[3] = Q[3];
    
    
endmodule
