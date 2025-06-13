`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2025 22:15:52
// Design Name: 
// Module Name: MEM_WB_file
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


module MEM_WB_file (
    input clk,
    input rst,
    input wire EX_MEM_jrSrc,    // wire for jr mux 
    input wire EX_MEM_jalsrc,   // wire jal mux
    input wire EX_MEM_jump,
    input wire EX_MEM_dm2reg,
    input wire EX_MEM_we_reg,
    input wire [31:0] EX_MEM_temp_alu,
    input wire [31:0] EX_MEM_alu_pa,
    input wire [4:0] EX_MEM_rf_wa,
    input wire [31:0] EX_MEM_jta,
    input wire [31:0] EX_MEM_multi,
    input wire EX_MEM_muxmul,
    input wire [31:0]rd_dm,
    output reg [31:0] MEM_WB_rd_dm,
    output reg MEM_WB_jrSrc,    // wire for jr mux 
    output reg MEM_WB_jalsrc,   // wire jal mux
    output reg MEM_WB_jump,
    output reg MEM_WB_dm2reg,
    output reg MEM_WB_we_reg,
    output reg [31:0] MEM_WB_temp_alu,
    output reg [31:0] MEM_WB_alu_pa,
    output reg [4:0] MEM_WB_rf_wa,
    output reg [31:0] MEM_WB_jta,
    output reg [31:0] MEM_WB_multi,
    output reg MEM_WB_muxmul
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        MEM_WB_jrSrc     <= 0;
        MEM_WB_jalsrc    <= 0;
        MEM_WB_jump      <= 0;
        MEM_WB_dm2reg    <= 0;
        MEM_WB_we_reg    <= 0;
        MEM_WB_temp_alu  <= 0;
        MEM_WB_alu_pa    <= 0;
        MEM_WB_rf_wa     <= 0;
        MEM_WB_jta       <= 0;
        MEM_WB_multi     <= 0;
        MEM_WB_muxmul    <= 0;
        MEM_WB_rd_dm     <= 0;
    end 
    else 
    begin
        MEM_WB_jrSrc     <= EX_MEM_jrSrc;
        MEM_WB_jalsrc    <= EX_MEM_jalsrc;
        MEM_WB_jump      <= EX_MEM_jump;
        MEM_WB_dm2reg    <= EX_MEM_dm2reg;
        MEM_WB_we_reg    <= EX_MEM_we_reg;
        MEM_WB_temp_alu  <= EX_MEM_temp_alu;
        MEM_WB_alu_pa    <= EX_MEM_alu_pa;
        MEM_WB_rf_wa     <= EX_MEM_rf_wa;
        MEM_WB_jta       <= EX_MEM_jta;
        MEM_WB_multi     <= EX_MEM_multi;
        MEM_WB_muxmul    <= EX_MEM_muxmul;
        MEM_WB_rd_dm     <= rd_dm;
    end
end

endmodule


