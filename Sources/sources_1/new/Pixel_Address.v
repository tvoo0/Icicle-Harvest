`timescale 1ns / 1ps

module Pixel_Address(
    input clk,
    input reset,
    input [15:0] Din,
    output [15:0] Hout, Vout,
    output UTC,
    output DTC
    );
    
    Counter16Bit row (.clk(clk), .UD(1'b1), .CE(Hout == 16'd799), .LD(Vout == 16'd524 & Hout == 16'd799), .Din(16'b0), .Qout(Vout), .UTC(), .DTC());
    Counter16Bit column (.clk(clk), .UD(1'b1), .CE(1'b1), .LD(Hout == 16'd799), .Din(16'b0), .Qout(Hout), .UTC(), .DTC());
    
endmodule
