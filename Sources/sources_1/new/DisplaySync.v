`timescale 1ns / 1ps

module DisplaySync(
    input clk,
    input [15:0] row, column,
    output Hsync,
    output Vsync
    );
    
    wire [15:0] V, H;
    
    assign V = row[15:0];
    assign H = column[15:0];
    
    assign Hsync = ~((16'd655 <= H) & (H <= 16'd750));
    assign Vsync = ~((16'd489 <= V) & (V <= 16'd490));
    
endmodule
