`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2023 20:45:23
// Design Name: 
// Module Name: menudisplay
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


module menudisplay(
    input clock, input showmenu , input [6144:0] pixel_index , output reg [15:0] oled_data, output reg[3:0] choice
    );
    
    
    parameter RED = 16'hF800;
    parameter GREEN = 16'h07E0;
    parameter BLACK = 16'h0;
    parameter WHITE = ~BLACK;
    reg[1:0] state;
    reg [7:0] x,y ;
    wire M, E, N, U;
    wire menu, topheight, midheight, botheight;
    
    assign menu = M || E || N || U;
    assign topheight = (y > 48 && y < 65);
    assign midheight = (y > 26  && y < 40);
    assign botheight = (y > 1 && y <18);
    
    assign M = ( ((76 < x < 92) && ( 58 < y < 61)) || (( 89 < x  < 92) && topheight ) || (( 82 < x  < 85) && topheight ) || (( 76 < x  < 79) && topheight ) );
    assign E = ( (( 62 < x  < 68 ) && (48 < y < 51)) || (( 62 < x  < 68 ) && (62 < y < 65)) || (( 62 < x  < 68 ) && ( 53< y < 57)) || (( 62 < x  < 65) && topheight ) );
    assign N = ( (( 62 < x  < 68 ) && (48 < y < 51)) || (( 62 < x  < 68 ) && (62 < y < 65)) || (( 62 < x  < 68 ) && ( 53< y < 57)) || (( 62 < x  < 65) && topheight ) );
    assign U = ( (( 62 < x  < 68 ) && (48 < y < 51)) || (( 62 < x  < 68 ) && (62 < y < 65)) || (( 62 < x  < 68 ) && ( 53< y < 57)) || (( 62 < x  < 65) && topheight ) );
    
    
    always @ (posedge clock) begin
    
             x = pixel_index % 96;
             y = pixel_index / 96;
             
             
             
             
             
    
    
    end
    
    
    
endmodule
