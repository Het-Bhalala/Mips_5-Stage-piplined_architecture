module alu (
        input  wire [3:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        input  wire [4:0]  shamt,   // NEW: Shift amount from instr[10:6]
        output wire        zero,
        output reg  [31:0] y
    );
    assign zero = (y == 0);

    always @ (op, a, b) begin
        case (op)
            4'b0000: y = a & b;
            4'b0001: y = a | b;
            4'b0010: y = a + b;
            4'b0110: y = a - b;
            4'b0111: y = (a < b) ? 1 : 0;
            4'b1000: y = b << shamt;            // SLL: Shift Left Logical
            4'b1001: y = b >> shamt;            // SRL: Shift Right Logical
      endcase
    end

endmodule