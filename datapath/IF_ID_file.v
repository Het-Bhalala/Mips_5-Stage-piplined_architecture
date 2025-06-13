`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2025 17:53:30
// Design Name: 
// Module Name: IF_ID_file
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


module IF_ID_file(
input clk,rst,
input  wire [31:0] instr,
input  wire  [31:0] pc_plus4,
output reg [31:0]IF_ID_pc_plus4,
output reg [31:0] IF_ID_instr
    );

    always @(posedge clk or posedge rst)
    begin 
    if (rst)
    begin
          IF_ID_pc_plus4 <= 0;
     IF_ID_instr <= 0;
    end 
    else 
    begin
     IF_ID_pc_plus4 <= pc_plus4;
     IF_ID_instr <= instr;
    end
    end 
endmodule
