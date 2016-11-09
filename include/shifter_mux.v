module shifter_mux
(
    input  [1:0]  sel,
    input  [3:0]  rotate_imm,
    input  [4:0]  shift_imm,
    input  [31:0] rs,
    output [31:0] shifter
);

    always @(*) begin
        case (sel)
            2'b00: begin
                shifter <= {{28{rotate_imm[3]}}, rotate_imm}; // sign-extended
            end
            2'b01: begin
                shifter <= {{27{shift_imm[4]}}, shift_imm};
            end
            2'b10: begin
                shifter <= rs;
            end
        endcase
    end

endmodule
