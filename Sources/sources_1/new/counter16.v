`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 09:33:00 PM
// Design Name: 
// Module Name: Counter16Bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Counter16Bit(
    input clk,
    input UD,
    input CE,
    input LD,
    input [15:0] Din,
    output [15:0] Qout,
    output UTC,
    output DTC
    );
    
    // Declare wires for interconnecting the 4-bit counters
    wire [15:0] Q;
    wire CE0, CE1, CE2, CE3;
    wire UTC_0, UTC_1, UTC_2, UTC_3;
    wire DTC_0, DTC_1, DTC_2, DTC_3;
  
    assign CE0 = CE;
    assign CE1 = (UD & UTC_0 & CE0) | (~UD & DTC_0 & CE0);
    assign CE2 = (UD & UTC_1 & UTC_0 & CE0) | (~UD & DTC_1 & DTC_0 & CE0);
    assign CE3 = (UD & UTC_2 & UTC_0 & UTC_1 & CE0) | (~UD & DTC_2 & DTC_0 & DTC_1 & CE0);
    
    
    
    // Instantiate four instances of the 4-bit counter
    countUD4L counter0 (.clk(clk), .UD(UD), .CE(CE0), .LD(LD), .Din(Din[3:0]), .Qout(Qout[3:0]), .UTC(UTC_0),.DTC(DTC_0));
    countUD4L counter1 (.clk(clk), .UD(UD), .CE(CE1), .LD(LD), .Din(Din[7:4]), .Qout(Qout[7:4]), .UTC(UTC_1),.DTC(DTC_1));
    countUD4L counter2 (.clk(clk), .UD(UD), .CE(CE2), .LD(LD), .Din(Din[11:8]), .Qout(Qout[11:8]), .UTC(UTC_2),.DTC(DTC_2));
    countUD4L counter3 (.clk(clk), .UD(UD), .CE(CE3), .LD(LD), .Din(Din[15:12]), .Qout(Qout[15:12]), .UTC(UTC_3),.DTC(DTC_3));

    // Generate UTC and DTC for the 16-bit counter
    assign UTC = UTC_0 & UTC_1 & UTC_2 & UTC_3;  // UTC is high when all counters reach maximum value (0xFFFF)
    assign DTC = DTC_0 & DTC_1 & DTC_2 & DTC_3;  // DTC is high when all counters reach minimum value (0x0000)
    
endmodule
