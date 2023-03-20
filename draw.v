`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2022 11:27:17
// Design Name: 
// Module Name: draw
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


module draw(
    input btnC,
    input btnL,
    input btnR,
    input sw1, 
    input sw2,
    input sw13,
    input sw14,
    input sw15,
    input [15:0] curr_pixel_colour, 
    input [12:0] pixel_index, 
    input [7:0] curr_pixel_x, 
    input [7:0] curr_pixel_y,
    input CLOCK,
    output [15:0] oled_data, 
    output [15:0] cursor_data,
    output reg changed = 0,
    input [15:0] background_data,
    input sw6,
    input sw7
    );
    parameter NEON_GREEN = 16'b00111_111111_00010;
  
    reg [15:0] cursor_data_holder = 0;
    reg [15:0] oled_data_holder = 0;

    reg old_colour_state = 0;
    wire [15:0] colour_palette_oled_data;
    wire [15:0] selected_colour;
    
    
    wire [7:0] x = pixel_index % 96;
    wire [7:0] y = pixel_index / 96;
    
    reg[22:0] count = 0;
    reg onesec = 0;
    reg pressed = 0;
    reg [22:0] pressed_count = 0;
    
    colour(pixel_index,CLOCK, sw13, sw14, btnR, btnL,curr_pixel_colour,colour_palette_oled_data,selected_colour);
            
    assign cursor_data = (sw13) ? colour_palette_oled_data : cursor_data_holder;
    assign oled_data = (sw13) ? colour_palette_oled_data : oled_data_holder; 
    
    always @(posedge CLOCK) begin
        count <= (count == 99999999) ? 0 : count + 1;
        onesec <= (count == 99999999) ? ~onesec : onesec;
        pressed_count <= (pressed_count == 499) ? 0 : pressed_count+1;
        if (pressed)begin
            pressed <= (pressed_count == 0) ? 0 : 1;
        end
        if (curr_pixel_x == x && curr_pixel_y == y)
                        cursor_data_holder <= NEON_GREEN;
                    else if (curr_pixel_x + 1 == x && curr_pixel_y == y)
                        cursor_data_holder <= NEON_GREEN;
                    else if (curr_pixel_x == x && curr_pixel_y + 1 == y)
                        cursor_data_holder <= NEON_GREEN;
                    else if (curr_pixel_x + 1 == x && curr_pixel_y + 1 == y)
                        cursor_data_holder <= NEON_GREEN;
                    else
                        cursor_data_holder <= curr_pixel_colour;
        if (sw2 && !sw15) begin
            if (x == curr_pixel_x && y == curr_pixel_y) begin
                changed <= 1;
                oled_data_holder <= (sw1) ? (sw6 | sw7) ? background_data : 16'b1111111111111111:selected_colour;
            end
            else if (x == curr_pixel_x && y == curr_pixel_y + 1) begin
                changed <= 1;
                oled_data_holder <= (sw1) ? (sw6 | sw7) ? background_data : 16'b1111111111111111:selected_colour;
            end
            else begin
                oled_data_holder <= curr_pixel_colour;
                changed <= 0;
            end
        end
        else if (btnC & !pressed && !sw15) begin
            if (x == curr_pixel_x && y == curr_pixel_y) begin
                changed <= 1;
                pressed <= 1;
                oled_data_holder <= (sw1) ? 16'b1111111111111111:selected_colour;  
            end
            else if (!sw15) begin
                oled_data_holder <= curr_pixel_colour;
            end
        end
        else if (!sw15) begin
            changed <= 0;
            oled_data_holder <= curr_pixel_colour;
        end 
        else if (sw15 & (sw6 | sw7))begin
        changed <= 1;
        oled_data_holder <= background_data;
       
        end
        
        else if (sw15) begin
            changed <= 1;
            oled_data_holder <= 16'b1111111111111111;
        end
    end
    
    
endmodule