`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2025 10:55:41
// Design Name: 
// Module Name: System_top
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


module System_top(
input clk,
input rst,
input [4:0] ra3,
output wire [31:0] pc_current,
 output wire [31:0] instr,
  output wire [31:0] rd3
    );
    
    
    wire we;
    wire [31:0] A;
    wire [31:0] wd_dm;
    wire [31:0] rd_dm;
    wire WE1,WE2,WE;
    wire [1:0] Rd_sel;
    reg [3:0] rd_dm_in;
    wire Done;
    wire Error;
    wire [31:0] product;
    wire [31:0] gpo2;
    wire [31:0] gpi2;
    wire [31:0] RD;
dmem dmem (
    .clk            (clk),
    .we             (we),
    .a              (A[7:2]),
    .d              (wd_dm),
    .q              (rd_dm),
    .rst            (rst)
);
        
        
 Address_decoder  Add_decoder_sys(
  .A  (A[3:2]),
 .WE (we),
 .WE1(WE1),
  .WE2(WE2),
 .RdSel (Rd_sel)
    );
    
mips_top mips_sys(
      .clk (clk),
      .rst (rst),
      .ra3 (ra3),
      .we_dm (we),
       .alu_out (A),
       .wd_dm (wd_dm),
       .rd_dm (RD),
        .pc_current (pc_current),
         .instr (instr),


        .rd3(rd3)
);


FATopModule  FATopModule_sys(
    .Go (WE1),
    .CLK (clk),
    .n (wd_dm[3:0]),
    .Done (Done),
    .Error (Error),
    .product (product)
    );

    mux4 #(32) mux_sys(
        .sel(Rd_sel),
        .a  (rd_dm),
        .b  (rd_dm),
        .c  (product),
        .d  (gpo2),
        .y  (RD)   
    );
    
    gpio_top gpio_top_sys(
        .A (A[3:2]) ,
        .WE (WE2),
         .RST (rst),
        .CLK (clk),
        .RD (gpi2),
       .gpi1 (gpi2), //gpi1 not L or I
       .gpi2 (gpi2),
        .WD (wd_dm),
        .gpo1 (gpo1),
        .gpo2 (gpo1)
    );
   
endmodule
