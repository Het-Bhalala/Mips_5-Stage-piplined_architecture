module mul (
    input [31:0] a,
    input [31:0] b,
    input [3:0] mulwe,
    output reg [31:0] mul,
    output  reg muxmul
);

    reg [63:0] multi;

    always @(mulwe) begin
    muxmul <= (mulwe == 4'b0101 || mulwe == 4'b0100) ? 1'b0 : 1'b1;
        case (mulwe)
            4'b0011: begin
                multi = a * b;  // Perform unsigned multiplication
               
            end
            4'b0101: begin
                mul = multi[31:0];  // Lower 32 bits
                
            end
            4'b0100: begin
                mul = multi[63:32];  // Upper 32 bits
                
            end
            default: begin
          
                // Do nothing - hold previous values
            end
        endcase
    end

endmodule

