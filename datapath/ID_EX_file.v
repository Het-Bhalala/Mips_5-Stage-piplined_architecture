`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2025 18:21:20
// Design Name: 
// Module Name: ID_EX_file
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


module ID_EX_file(
   input clk,
   input rst,
   input wire       jump,
   input wire       reg_dst,
   input wire       we_reg,
   input wire       alu_src,
   input wire       dm2reg,
   input wire [31:0] jta,
   input wire [3:0] alu_ctrl,// increase the bit so that sll and slr can uniquely indentified
   input wire jrSrc, // wire for jr mux 
   input wire jalsrc, // wire jal mux
   input wire we_dm,
   input wire [31:0] alu_pa,
   input wire [31:0] rd2_temp,
   input wire [31:0] sext_imm,
   input wire [4:0] rf_wa,
   input wire [31:0] IF_ID_instr,
   output reg [31:0] ID_EX_alu_pa,
   output reg [31:0] ID_EX_alu_pb,
   output reg [31:0] ID_EX_sext_imm,
   output reg [4:0] ID_EX_rf_wa,
   output reg [4:0] ID_EX_Shamt,
   output reg [31:0] ID_EX_jta,
   output reg [3:0] ID_EX_alu_ctrl,
   output reg ID_EX_alu_src,
   output reg ID_EX_jrSrc,
   output reg ID_EX_jump,
   output reg ID_EX_we_reg,
    output reg ID_EX_jalsrc,
     output reg ID_EX_dm2reg, 
     output reg ID_EX_reg_dst,
      output reg ID_EX_we_dm
    );
    
always @(posedge clk or posedge rst)
begin
if (rst)
begin
   ID_EX_alu_pa     <= 0;
   ID_EX_alu_pb     <= 0;
   ID_EX_sext_imm   <= 0;
   ID_EX_rf_wa <= 0;
   ID_EX_Shamt <= 0;
   
    ID_EX_alu_ctrl <= 0 ;
    ID_EX_alu_src <= 0 ;
    ID_EX_jrSrc <= 0 ;
    ID_EX_jump <= 0 ;
    ID_EX_we_reg <= 0;   
    ID_EX_jalsrc <= 0;
    ID_EX_dm2reg <=  0;
    ID_EX_reg_dst <= 0; 
    ID_EX_we_dm <= 0;
    ID_EX_jta <= 0;
end 
else 
   begin 
   ID_EX_alu_pa     <= alu_pa;
   ID_EX_alu_pb     <= rd2_temp;
   ID_EX_sext_imm   <= sext_imm;
   ID_EX_rf_wa <= rf_wa;
   ID_EX_Shamt <= IF_ID_instr[10:6];
   
    ID_EX_alu_ctrl <= alu_ctrl ;
    ID_EX_alu_src <= alu_src ;
    ID_EX_jrSrc <= jrSrc ;
    ID_EX_jump <= jump ;
    ID_EX_we_reg <= we_reg;   
    ID_EX_jalsrc <= jalsrc;
    ID_EX_dm2reg <=  dm2reg;
    ID_EX_reg_dst <= reg_dst; 
    ID_EX_we_dm <= we_dm;
    ID_EX_jta <= jta;
    
  //  ID_EX_pc_src <= IF_ID_pc_src;
   // ID_EX_rd3        <= rd3;
   // ID_EX_pc_plus4 <= IF_ID_pc_plus4;
   end 
   end
endmodule
