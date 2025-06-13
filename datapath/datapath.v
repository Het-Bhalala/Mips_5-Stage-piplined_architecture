module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        output wire EX_MEM_we_dm 
            );
       
    wire [4:0]  rf_wa;
    wire [4:0]  ramux;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] pc_rec_next;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] wd_rf;
    wire [31:0] rb_val;
    wire [31:0] mulWB;
    wire        zero;
    wire [31:0] multi;  //  output wire 
    wire muxmul;        // wire for multiplication unit 
    wire [31:0] pc_jr_next;
    wire [31:0] rd2_temp;
    wire [31:0] temp_alu;
    wire [4:0] shamt;
    wire       branch;
    wire       jump;
    wire       reg_dst;
    wire       we_reg;
    wire       alu_src;
    wire       dm2reg;
    wire [3:0] alu_ctrl;// increase the bit so that sll and slr can uniquely indentified
    wire jrSrc; // wire for jr mux 
    wire jalsrc; // wire jal mux
       // variable for pipleline regsisor IF/ID
   wire  [31:0] IF_ID_pc_plus4, IF_ID_instr;
   
   // variable for pipeline regsistor ID/EX
   wire [31:0] ID_EX_alu_pa,ID_EX_alu_pb,ID_EX_rd3,ID_EX_sext_imm,ID_EX_pc_plus4;
   wire [31:0] ID_EX_jta;
   wire [4:0] ID_EX_Shamt;
   
   //
   
   
   // variable for pipeline regsistor EX/MEM
   wire  [31:0] EX_MEM_alu_out, EX_MEM_zero,EX_MEM_pc_next,EX_MEM_alu_pb,EX_MEM_multi;
   wire  EX_MEM_muxmul;
 
 // varaible for pipeline regsistor MEM/WB
   wire  [31:0] MEM_WB_alu_out,MEM_WB_rd_dm,MEM_WB_multi;
   
   
 // space for the control unit
 //_____________________ IF/ID_____________________________
 wire [31:0] IF_ID_we_reg, IF_ID_pc_src,IF_ID_reg_dst,IF_ID_jalsrc,IF_ID_alu_src,IF_ID_jrSrc,IF_ID_jump,IF_ID_dm2reg,IF_ID_muxmul;
wire [3:0]  IF_ID_alu_ctrl;// changed control from 3 bit to 4 bit 
 //____________________ ID/EX______________________________

wire [31:0]ID_EX_pc_src,ID_EX_reg_dst,ID_EX_jalsrc,ID_EX_alu_src,ID_EX_jrSrc,ID_EX_jump,ID_EX_dm2reg,ID_EX_muxmul,ID_EX_we_reg;
wire [3:0]  ID_EX_alu_ctrl;
wire [4:0] ID_EX_rf_wa;
wire ID_EX_we_dm;
 //____________________EX/MEM_______________________________
 wire  [31:0] EX_MEM_pc_src,EX_MEM_reg_dst,EX_MEM_jalsrc,EX_MEM_alu_src,EX_MEM_jrSrc,EX_MEM_jump,EX_MEM_dm2reg, EX_MEM_we_reg,EX_MEM_alu_pa;
  wire [3:0]  EX_MEM_alu_ctrl;
  wire [31:0] EX_MEM_pc_plus4;
  wire [31:0] EX_MEM_jta;
  wire [4:0] EX_MEM_rf_wa;


 //__________________MEM/WD_________________________________ 
  wire [31:0] MEM_WB_pc_src,MEM_WB_reg_dst,MEM_WB_jalsrc,MEM_WB_alu_src,MEM_WB_jrSrc,MEM_WB_jump,MEM_WB_dm2reg,MEM_WB_muxmul, MEM_WB_we_reg,MEM_WB_alu_pa,MEM_WB_temp_alu;
  wire [31:0] MEM_WB_pc_plus4;
  wire [31:0] MEM_WB_jta;
  wire [4:0] MEM_WB_rf_wa;

 

    
    assign wd_dm    = EX_MEM_alu_pb;
//    assign alu_out =  EX_MEM_temp_alu;
    assign shamt = ID_EX_Shamt;
  //  assign pc_src = branch & zero;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {IF_ID_pc_plus4[31:28], IF_ID_instr[25:0], 2'b00};
    
    assign pc_src = ((alu_pa == rd2_temp) && branch) ? 1:0;
    
    
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   


	    mux2 #(32) pc_src_mux (
            .sel            (pc_src),
            .a              (pc_plus4),
            .b              (bta),
            .y              (pc_pre)
        ); 
	
         mux2 #(32) pc_jmp_mux (
            .sel            (MEM_WB_jump),
            .a              (pc_pre),
            .b              (MEM_WB_jta),
            .y              (pc_next)
        ); 
     mux2 #(32) Jrmux(
            .sel            (MEM_WB_jrSrc),
            .a              (pc_next),
            .b              (MEM_WB_alu_pa),
            .y              (pc_rec_next)
        );    
        
      dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_rec_next),
            .q              (pc_current)
        );
      adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );
   //////////////////////////////////////////////////
        IF_ID_file  IF_ID_stage (
         .clk    (clk),
         .rst    (rst),
         .instr   (instr),
         .pc_plus4 (pc_plus4),
         .IF_ID_pc_plus4 (IF_ID_pc_plus4),
          .IF_ID_instr  (IF_ID_instr)
        );
//////////////////////////////////////////////////////////
    controlunit cu (
            .opcode         (IF_ID_instr[31:26]),
            .funct          (IF_ID_instr[5:0]),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .we_dm          (we_dm),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .jrSrc          (jrSrc),// for jr instruction mux
            .jalsrc         (jalsrc)// for jal instruction mux
        );
    //Fetch Over //

    //Decode Start // 
      mux2 #(5) rf_wa_mux (
            .sel            (reg_dst),
            .a              (IF_ID_instr[20:16]),
            .b              (IF_ID_instr[15:11]),
            .y              (ramux)
        );
      mux2 #(5) ra_mux (
            .sel            (jalsrc),
            .a              (ramux),
            .b              (5'b11111),
            .y              (rf_wa)
        );
    
    
     regfile rf (
            .clk            (clk),
            .we             (MEM_WB_we_reg),
            .ra1            (IF_ID_instr[25:21]),
            .ra2            (IF_ID_instr[20:16]),
            .ra3            (ra3),
            .wa             (MEM_WB_rf_wa),
            .wd             (wd_rf),
            .rd1            (alu_pa),
            .rd2            (rd2_temp),
            .rd3            (rd3),
            .rst            (rst)
        );

    signext se (
            .a              (IF_ID_instr[15:0]),
            .y              (sext_imm)
        );
        
        adder pc_plus_br (
            .a              (IF_ID_pc_plus4),
            .b              (ba),
            .y              (bta)
        );     
        
ID_EX_file ID_EX_stage (
    .clk(clk),
    .rst(rst),
    .jump(jump),
    .reg_dst(reg_dst),
    .we_reg(we_reg),
    .alu_src(alu_src),
    .dm2reg(dm2reg),
    .alu_ctrl(alu_ctrl),
    .jta(jta),
    .jrSrc(jrSrc),
    .jalsrc(jalsrc),
    .we_dm(we_dm),
    .alu_pa(alu_pa),
    .rd2_temp(rd2_temp),
    .sext_imm(sext_imm),
    .rf_wa(rf_wa),
    .IF_ID_instr(IF_ID_instr),
    .ID_EX_alu_pa(ID_EX_alu_pa),
    .ID_EX_alu_pb(ID_EX_alu_pb),
    .ID_EX_sext_imm(ID_EX_sext_imm),
    .ID_EX_rf_wa(ID_EX_rf_wa),
    .ID_EX_Shamt(ID_EX_Shamt),
    .ID_EX_jta(ID_EX_jta),
    .ID_EX_alu_ctrl(ID_EX_alu_ctrl),
    .ID_EX_alu_src(ID_EX_alu_src),
    .ID_EX_jrSrc(ID_EX_jrSrc),
    .ID_EX_jump(ID_EX_jump),
    .ID_EX_we_reg(ID_EX_we_reg),
    .ID_EX_jalsrc(ID_EX_jalsrc),
    .ID_EX_dm2reg(ID_EX_dm2reg),
    .ID_EX_reg_dst(ID_EX_reg_dst),
    .ID_EX_we_dm(ID_EX_we_dm)
);



    // Excute Start  // 
    mux2 #(32) alu_pb_mux (
            .sel            (ID_EX_alu_src),
            .a              (ID_EX_alu_pb),
            .b              (ID_EX_sext_imm),
            .y              (alu_pb)
        );
////////////////////////// ALU LOGIC ///////////////////////////////////////////////

    alu alu (
            .op             (ID_EX_alu_ctrl),
            .a              (ID_EX_alu_pa),
            .b              (alu_pb),
            .shamt          (shamt), 
            .zero           (zero),
            .y              (temp_alu)
        );
        
    mul mult(
	    .a              (ID_EX_alu_pa),
        .b              (alu_pb),
	    .mulwe          (ID_EX_alu_ctrl),
	   .mul		    (multi),
	   .muxmul      (muxmul)
	);
	
EX_MEM_file EX_MEM_stage (
    .clk(clk),
    .rst(rst),
    .ID_EX_jrSrc(ID_EX_jrSrc),
    .ID_EX_jalsrc(ID_EX_jalsrc),
    .ID_EX_jump(ID_EX_jump),
    .ID_EX_dm2reg(ID_EX_dm2reg),
    .ID_EX_we_dm(ID_EX_we_dm),
    .ID_EX_jta(ID_EX_jta),
    .ID_EX_rf_wa(ID_EX_rf_wa),
    .ID_EX_alu_pa(ID_EX_alu_pa),
    .ID_EX_we_reg(ID_EX_we_reg),
    .ID_EX_alu_pb(ID_EX_alu_pb),
    .temp_alu(temp_alu),
    .multi(multi),
    .muxmul(muxmul),
    .EX_MEM_jrSrc(EX_MEM_jrSrc),
    .EX_MEM_jalsrc(EX_MEM_jalsrc),
    .EX_MEM_jump(EX_MEM_jump),
    .EX_MEM_dm2reg(EX_MEM_dm2reg),
    .EX_MEM_we_dm(EX_MEM_we_dm),
    .EX_MEM_jta(EX_MEM_jta),
    .EX_MEM_rf_wa(EX_MEM_rf_wa),
    .EX_MEM_alu_pa(EX_MEM_alu_pa),
    .EX_MEM_we_reg(EX_MEM_we_reg),
    .EX_MEM_alu_pb(EX_MEM_alu_pb),
    .EX_MEM_temp_alu(alu_out),
    .EX_MEM_multi(EX_MEM_multi),
    .EX_MEM_muxmul(EX_MEM_muxmul)
);
	
	
/////////////////////// ALU LOGIC COMPLETE /////////////////////////////////////////////	


MEM_WB_file MEM_WB_stage (
    .clk(clk),
    .rst(rst),
     .rd_dm(rd_dm),
    .EX_MEM_jrSrc(EX_MEM_jrSrc),
    .EX_MEM_jalsrc(EX_MEM_jalsrc),
    .EX_MEM_jump(EX_MEM_jump),
    .EX_MEM_dm2reg(EX_MEM_dm2reg),
    .EX_MEM_we_reg(EX_MEM_we_reg),
    .EX_MEM_temp_alu(alu_out),
    .EX_MEM_alu_pa(EX_MEM_alu_pa),
    .EX_MEM_rf_wa(EX_MEM_rf_wa),
    .EX_MEM_jta(EX_MEM_jta),
    .EX_MEM_multi(EX_MEM_multi),
    .EX_MEM_muxmul(EX_MEM_muxmul),
    .MEM_WB_jrSrc(MEM_WB_jrSrc),
    .MEM_WB_jalsrc(MEM_WB_jalsrc),
    .MEM_WB_jump(MEM_WB_jump),
    .MEM_WB_dm2reg(MEM_WB_dm2reg),
    .MEM_WB_we_reg(MEM_WB_we_reg),
    .MEM_WB_temp_alu(MEM_WB_temp_alu),
    .MEM_WB_alu_pa(MEM_WB_alu_pa),
    .MEM_WB_rf_wa(MEM_WB_rf_wa),
    .MEM_WB_jta(MEM_WB_jta),
    .MEM_WB_multi(MEM_WB_multi),
    .MEM_WB_muxmul(MEM_WB_muxmul),
     .MEM_WB_rd_dm(MEM_WB_rd_dm)
);

    mux2 #(32) rf_wd_mux (
            .sel            (MEM_WB_dm2reg),
            .a              (MEM_WB_temp_alu),
            .b              (MEM_WB_rd_dm),
            .y              (rb_val)
        );  
        
   mux2 #(32) WB (
       .sel    (MEM_WB_muxmul),
	   .a      (MEM_WB_multi),
       .b      (rb_val),
	   .y      (mulWB)
	);
	
          mux2 #(32) jalmux (
          .sel   (MEM_WB_jalsrc),
	      .a     (mulWB),
          .b     (IF_ID_pc_plus4),
	      .y     (wd_rf)
	);
	

        
 
        
   
   

      

		  
  

    // Excute Over // 
    
    
    

    // Memory Start //

     
    // Memory Over // 
    
    
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    // Write Back Start // 
    
    


	
	
	
	
	

    // Write Back Over //
     
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
endmodule





    
//    // Decode Over//
// /*always @(posedge clk)
//   begin 
//   ID_EX_alu_pa     <= alu_pa;
//   ID_EX_alu_pb     <= rd2_temp;
//   ID_EX_sext_imm   <= sext_imm;
//   ID_EX_rf_wa <= rf_wa;
//   ID_EX_Shamt <= IF_ID_instr[10:6];
//   ID_EX_jta <=  IF_ID_instr[25:0];
   
//    ID_EX_alu_ctrl <= alu_ctrl ;
//    ID_EX_alu_src <= alu_src ;
//    ID_EX_jrSrc <= jrSrc ;
//    ID_EX_jump <= jump ;
//    ID_EX_we_reg <= we_reg;   
//    ID_EX_jalsrc <= jalsrc;
//    ID_EX_dm2reg <=  dm2reg;
//    ID_EX_reg_dst <= reg_dst; 
//    ID_EX_we_reg <= we_reg;
//    ID_EX_we_dm <= we_dm;
    
//  //  ID_EX_pc_src <= IF_ID_pc_src;
//   // ID_EX_rd3        <= rd3;
//   // ID_EX_pc_plus4 <= IF_ID_pc_plus4;
//   end     */
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

   // pipleline regsister 
 /*  always @(posedge clk)
   begin 
     IF_ID_pc_plus4 <= pc_plus4;
     IF_ID_instr <= instr;
     
     
     IF_ID_reg_dst <= reg_dst; 
     IF_ID_jalsrc <=  jalsrc;
     IF_ID_we_reg <= we_reg;
     
     IF_ID_pc_src <= pc_src;
     IF_ID_alu_ctrl <= alu_ctrl;
     IF_ID_alu_src <= alu_src;
     IF_ID_jrSrc <= jrSrc;
     IF_ID_jump <= jump;
     IF_ID_dm2reg <= dm2reg;
    
   end*/
   
   //    always @(posedge clk)
//    begin
//    EX_MEM_alu_out <= temp_alu;
//    EX_MEM_zero    <= zero;
//    EX_MEM_alu_pb  <= ID_EX_alu_pb;
//    EX_MEM_pc_next <= pc_next;
//    EX_MEM_multi   <= multi;
//    EX_MEM_muxmul  <= muxmul;
//     EX_MEM_we_reg <= ID_EX_we_reg ;
//   EX_MEM_jalsrc  <= ID_EX_jalsrc ;
//     EX_MEM_dm2reg <= ID_EX_dm2reg;
//       EX_MEM_pc_plus4 <= ID_EX_pc_plus4;  // <-- New line added
//       EX_MEM_rf_wa <= ID_EX_rf_wa;

//       end



//      always @(posedge clk)
//    begin
//        MEM_WB_alu_out <= EX_MEM_alu_out;
//        MEM_WB_rd_dm <= rd_dm;
//        MEM_WB_multi <= multi;
//        MEM_WB_jalsrc <= EX_MEM_jalsrc;
//        MEM_WB_dm2reg <= EX_MEM_dm2reg ;
//        MEM_WB_muxmul <= EX_MEM_muxmul;
//        MEM_WB_we_reg  <= EX_MEM_we_reg ;
//        MEM_WB_pc_plus4 <= EX_MEM_pc_plus4; // <-- New line added
//        MEM_WB_rf_wa <= EX_MEM_rf_wa;

//    end
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////   