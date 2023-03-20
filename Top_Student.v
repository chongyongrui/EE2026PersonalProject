`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

module Top_Student (
    // Delete this comment and include Basys3 inputs and outputs here
    input btnR, input btnL, input clock, inout PS2Clk, inout PS2Data, input reset,  input [15:0] sw,
    output [7:0] JXADC, output [15:0]led , output [3:0] an, output [6:0] seg
    
    );
   
    wire [11:0]x_pos,y_pos;
    parameter RED = 16'hF800;
    parameter GREEN = 16'h07E0;
    parameter BLACK = 16'h0;
    parameter WHITE = ~BLACK;
    parameter YELLOW = 16'b11111_111111_01101;  
    parameter ORANGE = 16'b11111_101010_00110;
     parameter BLUE = 16'b00101_011010_11000;
    reg[1:0] remembercolor = 1'b0;
    reg[15:0] customcolor = 16'b0;
    reg [3:0] count = 0;
    
    wire colortrigger;
    wire righttrigger;
    
    MouseCtl mousemod(
        .clk(clock),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data),
        .middle(colortrigger),
        .right(righttrigger),
        .left(led[15]),
        .xpos(x_pos),
        .ypos(y_pos)
             
    );
    
    //OLED CLOCK
    wire clk6p25m;
    wire clk10hz;
    wire clk10khz;
    wire frame_begin;
    wire [12:0] pixel_index;
    clk6p25m clk6p25m_output (clock, clk6p25m);
    clk10hz clk10hz_output (clock, clk10hz) ; 
    clk10khz clk10khz_output (clock, clk10khz) ; 
    reg [15:0] oled_data = 16'h0;
    reg [7:0] x,y ;
    wire [7:0]out_x_pos, out_y_pos;
    reg [7:0]scaled_x_pos, scaled_y_pos;
    reg [7:0] movingx = 90;
    
    x_scaler scalex (clock, x_pos,out_x_pos);
    y_scaler scaley (clock, y_pos, out_y_pos);
    
    reg [1:0] photonum = 2'b00;
    reg [3:0] gamestate = 0;
    
    //0 = menu , 1 == easy , 2 == medium , 3 == hard , 4 == custom , 5 == win, 6 == lose , 7 == ??
   
    reg [6144:0]memory  = 6144'b0;
    
    reg[16:0] red0;
    reg[16:0] red1;
    reg[16:0] green0;
    reg[16:0] green1;
    reg[16:0] blue0;
    reg[16:0] blue1;
    reg[16:0] partycolor;
    reg[6:0] segment = 7'b111111;
    reg[3:0] anode = 4'b1111;
    reg[2:0] choice = 3'b0;
    reg dot = 1'b1;
    reg starteasyclock = 0;
    
    assign an = anode;
    assign seg = segment;
    
     
    assign led[0] = (gamestate == 0)? 1:0;
    assign led[1] = (gamestate == 1)? 1:0;
    assign led[2] = (gamestate == 2)? 1:0;
    assign led[3] = (gamestate == 3)? 1:0;
    assign led[4] = (gamestate == 4)? 1:0;
    assign led[5] = (choice == 1)? 1:0;
    assign led[6] = (choice == 2)? 1:0;
    assign led[7] = (choice == 3)? 1:0;
    assign led[8] = (choice == 4)? 1:0;
    
  
   
    wire rightbtn;
    wire leftbtn;
     
     
     Oled_Display(
              .clk(clk6p25m), .reset(reset), .pixel_data(oled_data), .cs(JXADC[0]), .sdin(JXADC[1]), .sclk(JXADC[3]),
              .d_cn(JXADC[4]), .resn(JXADC[5]), .vccen(JXADC[6]), .pmoden(JXADC[7]), .pixel_index(pixel_index));
    always @ (posedge clk10hz)
    begin
          if (count == 15 && (choice == 1 || choice == 2 || choice == 3)  ) begin
                 count <= 0;
                end
          else if (count == 43 && choice == 4) begin
                    count <= 0;
                end
          else if (count == 30 && (gamestate == 5 || gamestate == 6)) begin
                   count <= 0;
                 end
          
          else begin
                  count <= count + 1;
          end
    end   
    
    //always block to draw the image
    
    always @ (posedge clock) 
        begin
         
         partycolor <= partycolor +1; 
         
         // code to change cursor colour 
         remembercolor = (colortrigger == 1)?  ~remembercolor : remembercolor;   
         x = pixel_index % 96;
         y = pixel_index / 96;
         scaled_x_pos =  96 - ((out_x_pos>95)? 95 : (out_x_pos<1)? 1 : out_x_pos)  ;
         scaled_y_pos = 64 - ((out_y_pos>63)? 63 : (out_y_pos<1)? 1 : out_y_pos) ; 
        
        
         //color mixer formula
         
         red0 <= (sw[0])? 16'b00111_000000_00000 : 16'b0;
         red1 <= (sw[1])? 16'b11000_000000_00000 : 16'b0;
         green0 <= (sw[2])? 16'b00000_00111_00000 : 16'b0;
         green1 <= (sw[3])? 16'b00000_110000_00000 : 16'b0;
         blue0 <= (sw[4])? 16'b00000_00000_00111 : 16'b0;
         blue1 <= (sw[5])? 16'b00000_000000_11000 : 16'b0;   
         customcolor <= red0 + red1 + green0 + green1 + blue0 + blue1;
         
        
         if (gamestate == 0) //menu display 
         begin
         
          // lines below are to show the cursor and move the cursor on input
         if (x > scaled_x_pos-1 && x < scaled_x_pos+2 && y > scaled_y_pos-1 && y < scaled_y_pos+2 ) 
                                           oled_data <= (remembercolor) ? GREEN : WHITE;
         
             
   
         
            else if ( x>60 && x <84 && y > 36 && y < 60) oled_data <= YELLOW ; //easy box
            else if ( x > 12 && x < 36 && y > 36 && y < 60) oled_data <= ORANGE; // med box
            else if ( x>60 && x <84 && y > 4 && y < 28) oled_data <= RED ;  // hard box
            else if ( x > 12 && x < 36 && y > 4 && y < 28) oled_data <= BLUE; //cust box
            else 
            oled_data <= (sw[7])? partycolor : BLACK;
           
            
            if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 60 > scaled_y_pos-1 && 36 < scaled_y_pos+2 &&righttrigger ) // mouse click easy box
                                               gamestate <= 1;
                                               
             if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 60 > scaled_y_pos-1 && 36 < scaled_y_pos+2 &&righttrigger ) // mouse click med box
                                                           gamestate <= 2;
                                                           
             if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 28 > scaled_y_pos-1 && 4 < scaled_y_pos+2 &&righttrigger) // mouse click hard box
                                                           gamestate <= 3;
                                               
            if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 28 > scaled_y_pos-1 && 4 < scaled_y_pos+2 &&righttrigger) // mouse click cust box
                                                           gamestate <= 4;   
            
             // mouse over easy box
            if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 60 > scaled_y_pos-1 && 36 < scaled_y_pos+2) choice<=  1 ;
            
            if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 60 > scaled_y_pos-1 && 36 < scaled_y_pos+2) choice <=  2; // mouse over med box
                      
                        
            if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 28 > scaled_y_pos-1 && 4 < scaled_y_pos+2) choice <=3; // mouse over hard box
                        
            
             if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 28 > scaled_y_pos-1 && 4 < scaled_y_pos+2)choice <= 4 ; // mouse over cust box
                      
            
         end
         
         
         else if (gamestate == 1)begin
         
                    
         
                     if (x > movingx-1 &&  x < movingx +2 && y > scaled_y_pos-1 && y < scaled_y_pos+2) begin
                                                   oled_data <= (remembercolor) ? GREEN : WHITE;
                     end
                     else if ( x<95 && x >70) oled_data <= BLUE ; 
                     else if ( x >= 0 && x < 10) oled_data <= GREEN; 
                     else if ( x >= 47 && x <= 49 && y >=52 && y <= 65) oled_data <= WHITE ;  
                     else if ( x >=  48 && x <= 70 && y >=51 && y <= 53) oled_data <= WHITE ;  
                     else if ( x >= 58 && x <= 60 && y >=39 && y <= 52) oled_data <= WHITE ;  
                     else if ( x >= 35 && x <= 37 && y >=39 && y <= 65) oled_data <= WHITE ;  
                     else if ( x >= 10 && x <= 12 && y >=0 && y <= 52) oled_data <= WHITE ;  
                     else if ( x >= 48 && x <= 70 && y >=25 && y <= 27) oled_data <= WHITE ;  
                     else if ( x >= 48 && x <= 70 && y >=12 && y <= 14) oled_data <= WHITE ;  
                     else if ( x >= 58 && x <= 60 && y >=0 && y <= 13) oled_data <= WHITE ;  
                     else if ( x >= 23 && x <= 36 && y >=25 && y <= 27) oled_data <= WHITE ;  
                     else if ( x >= 23 && x <= 36 && y >=12 && y <= 14) oled_data <= WHITE ;  
                     else if ( x >= 35 && x <= 37 && y >=13 && y <= 26) oled_data <= WHITE ;  
                     else if ( x >= 22 && x <= 24 && y >=26 && y <= 39) oled_data <= WHITE ;  
                     else oled_data <= (sw[7])? partycolor : BLACK; 
                     
                     
                     starteasyclock = 1; 
                     if ( movingx >= 0 && movingx < 10) gamestate <= 5; // win game
                  else if ( movingx >= 47 && movingx <= 49 && scaled_y_pos >=52 && scaled_y_pos <= 65) gamestate <= 6;   
                  else if ( movingx >=  48 && movingx <= 70 && scaled_y_pos >=51 && scaled_y_pos <= 53) gamestate <= 6;
                  else if ( movingx >= 58 && movingx <= 60 && scaled_y_pos >=39 && scaled_y_pos <= 52) gamestate <= 6;   
                  else if ( movingx >= 35 && movingx <= 37 && scaled_y_pos >=39 && scaled_y_pos <= 65) gamestate <= 6;   
                  else if ( movingx >= 10 && movingx <= 12 && scaled_y_pos >=0 && scaled_y_pos <= 52) gamestate <= 6;  
                  else if ( movingx >= 48 && movingx <= 70 && scaled_y_pos >=25 && scaled_y_pos <= 27) gamestate <= 6;   
                  else if ( movingx >= 48 && movingx <= 70 && scaled_y_pos >=12 && scaled_y_pos <= 14) gamestate <= 6;   
                  else if ( movingx >= 58 && movingx <= 60 && scaled_y_pos >=0 && scaled_y_pos <= 13) gamestate <= 6;  
                  else if ( movingx >= 23 && movingx <= 36 && scaled_y_pos >=25 && scaled_y_pos <= 27) gamestate <= 6;
                   else if ( movingx >= 23 && movingx <= 36 && scaled_y_pos >=12 && scaled_y_pos <= 14) gamestate <= 6;
                   else if ( movingx >= 35 && movingx <= 37 && scaled_y_pos >=13 && scaled_y_pos <= 26) gamestate <= 6;
                   else if ( movingx >= 22 && movingx <= 24 && scaled_y_pos >=26 && scaled_y_pos <= 39)gamestate <= 6;
                     
                               
         
         
         end
         
         //draw and erase function
         
         else if (gamestate == 4) begin
         
                    // lines below are to show the cursor and move the cursor on input
                      if (x > scaled_x_pos-1 && x < scaled_x_pos+2 && y > scaled_y_pos-1 && y < scaled_y_pos+2) begin
                                           oled_data <= (remembercolor) ? GREEN : WHITE;
                      end
                    else if (memory[pixel_index] == 1)
                        oled_data <= customcolor;
                     else 
                        oled_data <= (sw[7])? partycolor : BLACK;
                        
                        
                        if (righttrigger)  begin
                                 memory[96*(scaled_y_pos-1)+scaled_x_pos] <= (sw[15])? 0 : 1;  
                         end
         end
         
         else if (gamestate == 5) begin  // win game
                     if ( x>=28 && x <=32 && y >= 10 && y <= 20) oled_data <= GREEN ; //easy box
                     else if ( x>=62 && x <=67 && y >= 10 && y <= 20) oled_data <= GREEN ;  // med box
                     else if ( x>=38 && x <=42 && y >= 30 && y <= 50) oled_data <= GREEN ;   // hard box
                     else if ( x>=52 && x <=57 && y >= 30 && y <= 50) oled_data <= GREEN ; 
                     else if ( x>=33 && x <=62 && y >= 10 && y <= 13) oled_data <= GREEN ;   // hard box
                     else 
                     oled_data <= (sw[7])? partycolor : BLACK;
         
                     if (righttrigger) begin
                        gamestate <= 0;
                        choice <= 3'b0;
                         starteasyclock <= 0;
                        
                     end

         end
         
         
         else if (gamestate == 6) begin // lose game 
         
         
                      if ( x>=28 && x <=32 && y >= 10 && y <= 20) oled_data <= RED ; //easy box
                      else if ( x>=62 && x <=67 && y >= 10 && y <= 20) oled_data <= RED ;  // med box
                      else if ( x>=38 && x <=42 && y >= 30 && y <= 50) oled_data <= RED ;   // hard box
                      else if ( x>=52 && x <=57 && y >= 30 && y <= 50) oled_data <= RED ; 
                      else if ( x>=33 && x <=62 && y >= 17 && y <= 20) oled_data <= RED ;   // hard box
                      else 
                      oled_data <= (sw[7])? partycolor : BLACK;
          
                      if (righttrigger) begin
                         gamestate <= 0;
                         choice <= 3'b0;
                         starteasyclock <= 0;
                         
                      end
         
         
         
         
         
         
         end
                        
          //reset drawing function
          if(reset) begin
                     memory <= 6144'b0; 
                     gamestate <= 0; 
                     choice <= 3'b0;
                     starteasyclock <= 0;
                     
          end
                                  
         
  
            
         x <= x+1;
         y <= y+1;
 

            
        end 
        
        
        
        
        
//easy mode obeject movement

always @ (posedge clk10hz) begin
    if (starteasyclock == 1) begin
        movingx <= movingx - 1;
    end
    else begin
        movingx <= 90;
    end



end    
        
        
        
        
        
        
        
        
        
        
        
        
 //show the difficult when mouse over the colored square in menu page      
            
always @ (posedge clk10khz)
begin
    if (gamestate == 5) begin // display yay
            if (count == 0) begin   
                        anode[3:1] <= 2'b011;
                        segment[6:0] <= 7'b0010001;
                        dot <= 1'b1;
                    
              end
              else if (count == 14) begin   
                      anode[3:0] <= 4'b1011;
                      segment[6:0] <= 7'b0001000;
                      dot <= 1'b1;
                  
              end
              else if (count == 28) begin   
                      anode[3:0] <= 4'b1101;
                      segment[6:0] <= 7'b0010001;
                      dot <= 1'b1;
                  
              end
    end
    
    else if (gamestate == 6) begin
                if (count == 0) begin   
                            anode[3:2] <= 2'b01;
                            segment[6:0] <= 7'b0000011;
                            dot <= 1'b1;
                        
                  end
                  else if (count == 14) begin   
                          anode[3:0] <= 4'b1011;
                          segment[6:0] <= 7'b0100011;
                          dot <= 1'b1;
                      
                  end
                  else if (count == 28) begin   
                          anode[3:0] <= 4'b1101;
                          segment[6:0] <= 7'b0100011;
                          dot <= 1'b1;
                      
                  end
        end






     else if (choice == 1 || choice == 2 || choice == 3 ) begin
            if (count == 0) begin   
                    anode[3:2] <= 2'b01;
                    segment[6:0] <= 7'b1000111;
                    dot <= 1'b1;
                
            end
            
            else if (count == 14) begin
                if (choice == 1)
                begin
                    anode[3:2] <= 2'b10;
                    segment[6:0] <= 7'b1111001;
                    dot <= 1'b1;
                end
                else if (choice == 2)
                begin
                    anode[3:2] <= 2'b10;
                    segment[6:0] <= 7'b0100100;
                    dot <= 1'b1;
                end
                else if (choice == 3)
                begin
                    anode[3:2] <= 2'b10;
                    segment[6:0] <= 7'b0110000;
                    dot <= 1'b1;
                end
                
                else
                begin
                    segment[6:0] <= 7'b1111111;
                    dot <= 1'b1;
                    anode <= 4'b1111;
                end
            end
                    
      end
      
      
      else if (choice == 4 ) begin
                  if (count == 0) begin   
                          anode[3:0] <= 4'b0111;
                          segment[6:0] <= 7'b1000110;
                          dot <= 1'b1;
                      
                  end
                  else if (count == 14) begin   
                        anode[3:0] <= 4'b1011;
                        segment[6:0] <= 7'b1000001;
                        dot <= 1'b1;
                    
                end
                else if (count == 28) begin   
                        anode[3:0] <= 4'b1101;
                        segment[6:0] <= 7'b0010010;
                        dot <= 1'b1;
                    
                end
                else if (count == 42) begin   
                        anode[3:0] <= 4'b1110;
                        segment[6:0] <= 7'b0000111;
                        dot <= 1'b1;
                    
               end
                  
                          
            end
 end
        
endmodule







// mouse output scaler to fit into display bits

module x_scaler (
input clock, input [11:0]in, output reg [7:0]out
);
reg[11:0] in1 = 12'b0;
always @ (posedge clock)    
    begin
    in1 = in / 4 ;
    out = in1;
    end

endmodule

module y_scaler (
input clock, input [11:0]in, output reg [7:0]out
);
reg[11:0] in1 = 12'b0;
always @ (posedge clock)    
    begin
    in1 = in / 4 ;
    out = in1;
    end

endmodule




