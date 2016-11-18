module shiftee_mux
(
    input      [1:0]  sel,
    input      [7:0]  immed_8,
    input      [31:0] immed_32,
    input      [31:0] rm,
    output reg [31:0] shiftee
);

    always @(*) begin
        case (sel)
            `IMMED_8_SEL: begin
                shiftee <= {{24{immed_8[7]}}, immed_8};
            end
            `RM_SEL: begin
                shiftee <= rm;
            end
            `IMMED_32_SEL: begin
                shiftee <= immed_32;
            end
        endcase
    end

endmodule
