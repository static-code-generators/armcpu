module shifter_mux
(
    input      [1:0]  sel,
    input      [3:0]  rotate_imm,
    input      [4:0]  shift_imm,
    input      [31:0] rs,
    output reg [31:0] shifter
);

    always @(*) begin
        case (sel)
            `ROTATE_IMM_SEL: begin
                shifter <= {{28{rotate_imm[3]}}, rotate_imm}; // sign-extended
            end
            `SHIFT_IMM_SEL: begin
                shifter <= {{27{shift_imm[4]}}, shift_imm};
            end
            `RS_SEL: begin
                shifter <= rs;
            end
        endcase
    end

endmodule
