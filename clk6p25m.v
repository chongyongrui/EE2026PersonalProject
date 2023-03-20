`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2023 09:21:06
// Design Name: 
// Module Name: clk6p25m
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


module clk1hz(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 50000000) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule

module clk6p25m(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 7) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule

module clk10khz(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 5000) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule


module clk10hz(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 4999999) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule