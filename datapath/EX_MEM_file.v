`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2025 19:40:05
// Design Name: 
// Module Name: EX_MEM_file
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


module EX_MEM_file(
input wire clk,
input wire rst,
   input wire ID_EX_jrSrc, // wire for jr mux 
    input wire ID_EX_jalsrc, // wire jal mux
     input wire       ID_EX_jump,
      input wire      ID_EX_dm2reg,
       input wire ID_EX_we_dm,
        input wire [31:0] ID_EX_jta,
        input wire [4:0] ID_EX_rf_wa,
         input wire [31:0] ID_EX_alu_pa,
   input wire       ID_EX_we_reg,
   input wire [31:0] ID_EX_alu_pb,
   input wire [31:0] temp_alu,
   input wire [31:0] multi,
   input wire muxmul,
    output reg EX_MEM_jrSrc, // wire for jr mux 
    output reg EX_MEM_jalsrc, // wire jal mux
     output reg       EX_MEM_jump,
    output reg      EX_MEM_dm2reg,
   output reg EX_MEM_we_dm,
    output reg [31:0] EX_MEM_jta,
    output reg [4:0] EX_MEM_rf_wa,
     output reg [31:0] EX_MEM_alu_pa,
       output reg       EX_MEM_we_reg,
       output reg [31:0] EX_MEM_alu_pb,
       output reg [31:0] EX_MEM_temp_alu,
       output reg [31:0] EX_MEM_multi,
       output reg EX_MEM_muxmul
    );
    
   always @(posedge clk or posedge rst)
   begin
   if (rst)
   begin
    EX_MEM_jrSrc     <= 0;
    EX_MEM_jalsrc    <= 0;
    EX_MEM_jump      <= 0;
    EX_MEM_dm2reg    <= 0;
    EX_MEM_we_dm     <= 0;
    EX_MEM_jta       <= 0;
    EX_MEM_rf_wa     <= 0;
    EX_MEM_alu_pa    <= 0;
    EX_MEM_we_reg    <= 0;
    EX_MEM_alu_pb    <= 0;
    EX_MEM_temp_alu  <= 0;
    EX_MEM_multi     <= 0;
    EX_MEM_muxmul    <= 0;
   end
   else 
   begin 
    EX_MEM_jrSrc     <= ID_EX_jrSrc;
    EX_MEM_jalsrc    <= ID_EX_jalsrc;
    EX_MEM_jump      <= ID_EX_jump;
    EX_MEM_dm2reg    <= ID_EX_dm2reg;
    EX_MEM_we_dm     <= ID_EX_we_dm;
    EX_MEM_jta       <= ID_EX_jta;
    EX_MEM_rf_wa     <= ID_EX_rf_wa;
    EX_MEM_alu_pa    <= ID_EX_alu_pa;
    EX_MEM_we_reg    <= ID_EX_we_reg;
    EX_MEM_alu_pb    <= ID_EX_alu_pb;
    EX_MEM_temp_alu  <= temp_alu;
    EX_MEM_multi     <= multi;
    EX_MEM_muxmul    <= muxmul;
   end   
   end 
   
endmodule
