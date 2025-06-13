module auxdec (
        input  wire [1:0] alu_op,
        input  wire [5:0] funct,
        output wire [3:0] alu_ctrl,
        output wire jrSrc,
        output wire jalsrc
    );

    reg [3:0] ctrl;
    reg jr = 0;
    reg jal = 0;
    
    assign {alu_ctrl} = ctrl;
    assign jrSrc = jr;
    assign jalsrc = jal;
    always @ (alu_op, funct) begin

        case (alu_op)
            2'b00: ctrl = 4'b0010;          // ADD
            2'b01: ctrl = 4'b0110;          // SUB
            default: case (funct)
                6'b10_0100: ctrl = 4'b0000; // AND
                6'b10_0101: ctrl = 4'b0001; // OR
                6'b10_0000: ctrl = 4'b0010; // ADD
                6'b10_0010: ctrl = 4'b0110; // SUB
                6'b10_1010: ctrl = 4'b0111; // SLT
		         6'b01_1001: ctrl = 4'b0011; // MULT
		          6'b01_0010: ctrl = 4'b0101; // MULLO
		          6'b01_0000: ctrl = 4'b0100; // MULHI	
		          6'b00_1000: jr = 1; //jr
		          6'b00_0101: jal = 1 ; // jal
                  6'b00_0000: ctrl = 4'b1000; // SLL (NEW)
                 6'b00_0010: ctrl = 4'b1001; // SRL (NEW)
                default:   
                begin  ctrl = 4'bxxxx;
                jr <= 0;
                jal <= 0;
                end 
            endcase
        endcase
    end

endmodule