`timescale 1ns / 1ps

module countUD8L(
    input clk,
    input UD,
    input CE,
    input LD,
    input [7:0] Din,
    output [7:0] Qout,
    output UTC,
    output DTC
    );
    
    // Declare wires for interconnecting the 4-bit counters
    wire [7:0] Q;
    wire CE0, CE1;
    wire UTC_0, UTC_1;
    wire DTC_0, DTC_1;
  
    assign CE0 = CE;
    assign CE1 = (UD & UTC_0 & CE0) | (~UD & DTC_0 & CE0);
    
    // Instantiate four instances of the 4-bit counter
    countUD4L count8counter0 (.clk(clk), .UD(UD), .CE(CE0|LD), .LD(LD), .Din(Din[3:0]), .Qout(Qout[3:0]), .UTC(UTC_0),.DTC(DTC_0));
    countUD4L count8counter1 (.clk(clk), .UD(UD), .CE(CE1|LD), .LD(LD), .Din(Din[7:4]), .Qout(Qout[7:4]), .UTC(UTC_1),.DTC(DTC_1));
                
    assign UTC = UTC_0 & UTC_1;
    assign DTC = DTC_0 & DTC_1;
    
endmodule