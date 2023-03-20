`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2022 16:54:14
// Design Name: 
// Module Name: colors
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


module colour(
    input [12:0] pixel_index, 
    input CLOCK, sw13, sw14, btnR, btnL,
    input [15:0] curr_pixel_oled,
    output reg [15:0] oled_data,
    output [15:0] selected_colour 
    );
    
     parameter BLACK = 16'b0;
     parameter WHITE = ~BLACK;
     parameter LIGHT_YELLOW = 16'b11111_111111_10011;    //255, 255, 153 -> 32, 64, 19.125
     parameter YELLOW1 = 16'b11111_111111_01101;      //255, 255, 102 -> 32, 64, 12.75
     parameter DARK_YELLOW = 16'b11001_110011_00000;        //204, 204, 0 -> 25.5, 51, 0
     
     parameter BEIGE = 16'b1111111011010011;
     parameter ORANGE = 16'b11111_101010_00110;
     parameter BROWN = 16'b11000_010010_00000;
     parameter RED = 16'b11111_000000_00000;
     parameter PURPLE = 16'b11001_011010_11101;
     parameter TURQUOISE = 16'b00010_110000_11001;
     parameter BLUE = 16'b00101_011010_11000;
     parameter GREEN = 16'b00001_100100_01010;
     parameter LIGHT_GREEN = 16'b01110_110100_00111;
     parameter YELLOW = 16'b11111_111110_01011;
     parameter DARK_GREY = 16'b01111_11110_01111;
     parameter GREY = 16'b11000_110000_11000;
    
    reg [3:0] state = 0;
    wire [7:0] x = pixel_index % 96;
    wire [7:0] y = pixel_index / 96;

    assign selected_colour = (state == 0) ? BLACK :
                             (state == 1) ? BEIGE :
                             (state == 2) ? ORANGE:
                             (state == 3) ? BROWN:
                             (state == 4) ? RED:
                             (state == 5) ? PURPLE:
                             (state == 6) ? TURQUOISE:
                             (state == 7) ? BLUE:
                             (state == 8) ? GREEN:
                             (state == 9) ? LIGHT_GREEN:
                             (state == 10) ? YELLOW:
                             (state == 11) ? DARK_GREY:
                             GREY;
    wire [15:0] colourmenudisp [0:12];
    
    wire [12:0] box;
    assign box[0] = ((x >= 3 && x <= 8 && (y == 56 || y == 61)) || (x == 3 || x == 8) && y >= 56 && y <= 61);
    assign box[1] = ((x >= 10 && x <= 15 && (y == 56 || y == 61)) || (x == 10 || x == 15) && y >= 56 && y <= 61);
    assign box[2] = ((x >= 17 && x <= 22 && (y == 56 || y == 61)) || (x == 17 || x == 22) && y >= 56 && y <= 61);
    assign box[3] = ((x >= 24 && x <= 29 && (y == 56 || y == 61)) || (x == 24 || x == 29) && y >= 56 && y <= 61);
    assign box[4] = ((x >= 31 && x <= 36 && (y == 56 || y == 61)) || (x == 31 || x == 36) && y >= 56 && y <= 61);
    assign box[5] = ((x >= 38 && x <= 43 && (y == 56 || y == 61)) || (x == 38 || x == 43) && y >= 56 && y <= 61);
    assign box[6] = ((x >= 45 && x <= 50 && (y == 56 || y == 61)) || (x == 45 || x == 50) && y >= 56 && y <= 61);
    assign box[7] = ((x >= 52 && x <= 57 && (y == 56 || y == 61)) || (x == 52 || x == 57) && y >= 56 && y <= 61);
    assign box[8] = ((x >= 59 && x <= 64 && (y == 56 || y == 61)) || (x == 59 || x == 64) && y >= 56 && y <= 61);
    assign box[9] = ((x >= 66 && x <= 71 && (y == 56 || y == 61)) || (x == 66 || x == 71) && y >= 56 && y <= 61);
    assign box[10] = ((x >= 73 && x <= 78 && (y == 56 || y == 61)) || (x == 73 || x == 78) && y >= 56 && y <= 61);
    assign box[11] = ((x >= 80 && x <= 85 && (y == 56 || y == 61)) || (x == 80 || x == 85) && y >= 56 && y <= 61);
    assign box[12] = ((x >= 87 && x <= 92 && (y == 56 || y == 61)) || (x == 87 || x == 92) && y >= 56 && y <= 61);
    
    wire bigbox;
    assign bigbox = ((x >= 0 && x <= 95 && (y == 54 || y == 63)) || ((x == 0 || x == 95) && y >= 54 && y <= 63));
    
    wire [12:0] colour;
    assign colour[0] = (x >= 5 && x <= 6 && y >= 58 && y <= 59);
    assign colour[1] = (x >= 12 && x <= 13 && y >= 58 && y <= 59);
    assign colour[2] = (x >= 19 && x <= 20 && y >= 58 && y <= 59);
    assign colour[3] = (x >= 26 && x <= 27 && y >= 58 && y <= 59);
    assign colour[4] = (x >= 33 && x <= 34 && y >= 58 && y <= 59); 
    assign colour[5] = (x >= 40 && x <= 41 && y >= 58 && y <= 59);
    assign colour[6] = (x >= 47 && x <= 48 && y >= 58 && y <= 59);
    assign colour[7] = (x >= 54 && x <= 55 && y >= 58 && y <= 59);
    assign colour[8] = (x >= 61 && x <= 62 && y >= 58 && y <= 59);
    assign colour[9] = (x >= 68 && x <= 69 && y >= 58 && y <= 59);
    assign colour[10] = (x >= 75 && x <= 76 && y >= 58 && y <= 59);
    assign colour[11] = (x >= 82 && x <= 83 && y >= 58 && y <= 59);
    assign colour[12] = (x >= 89 && x <= 90 && y >= 58 && y <= 59);
    
    assign colourmenudisp[0] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[0];
    assign colourmenudisp[1] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[1];
    assign colourmenudisp[2] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[2];
    assign colourmenudisp[3] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[3];                          
    assign colourmenudisp[4] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[4];                           
    assign colourmenudisp[5] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[5];
    assign colourmenudisp[6] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[6];                         
    assign colourmenudisp[7] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[7];
    assign colourmenudisp[8] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[8];
    assign colourmenudisp[9] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[9];
    assign colourmenudisp[10] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[10];                                                           
    assign colourmenudisp[11] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[11];                                                          
    assign colourmenudisp[12] = bigbox || colour[0] || colour[1] || colour[2] || colour[3] || colour[4] || colour[5] ||
                               colour[6] || colour[7] || colour[8] || colour[9] || colour[10] || colour[11] || colour[12] ||
                               box[12];                                                          
                                                              
   
    reg pressed = 0;
    reg [26:0] count = 0;
   
    always @(posedge CLOCK) begin
        if (pressed == 1) begin
            count <= (count == 24999999) ? 0 : count + 1;
            pressed <= (count == 24999999) ? 0 : 1;
        end
        if (btnR && state != 12 && pressed == 0 && sw13) begin
            state <= state + 1;
            pressed <= 1;
        end
        else if (btnL && state != 0 && pressed == 0 && sw13) begin
            state <= state - 1;
            pressed <= 1;
        end
    end
    
    always @(*) begin
        if (sw13 && sw14) begin
        if (colourmenudisp[state]) begin
            if (bigbox)
                oled_data <= BLACK;
            else if (box[0] || box[1] || box[2] || box[3] || box[4] || box[5] || box[6] || box[7] || box[8] || box[9] || box[10] || box[11] || box[12])
                oled_data <= RED; 
            else if (colour[0])
                oled_data <= BLACK;
            else if (colour[1])
                oled_data <= BEIGE;
            else if (colour[2])
                oled_data <= ORANGE;
            else if (colour[3])
                oled_data <= BROWN;
            else if (colour[4])
                oled_data <= RED;
            else if (colour[5])
                oled_data <= PURPLE;
            else if (colour[6])
                oled_data <= TURQUOISE;
            else if (colour[7])
                oled_data <= BLUE;
            else if (colour[8])
                oled_data <= GREEN;
            else if (colour[9])
                oled_data <= LIGHT_GREEN;
            else if (colour[10])
                oled_data <= YELLOW;
            else if (colour[11])
                oled_data <= DARK_GREY;
            else if (colour[12])
                oled_data <= GREY;
                
        end
        else
            oled_data <= curr_pixel_oled;   //whatever is on the drawing board
        end
        else
            oled_data <= curr_pixel_oled; //whatever is on the drawing board
    end
    
     
endmodule