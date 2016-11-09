module shiftee_mux
(
    input             sel,
    input      [7:0]  immed_8,
    input      [31:0] rm,
    output reg [31:0] shiftee
);

    always @(*) begin
        case (sel)
            1'b0: begin
                shiftee <= {{24{immed_8[7]}}, immed_8};
            end
            1'b1: begin
                shiftee <= rm;
            end
        endcase
    end

endmodule
