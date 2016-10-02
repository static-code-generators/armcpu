module arm_alu
(
    output reg [31:0] alu_out,
    input      [31:0] alu_op1, alu_op2,
    input      [3:0]  alu_op_sel // bus size is 4 assuming max number of ops we can have is 16
);
    always_comb begin
        alu_out = alu_op1 + alu_op2;
        // add more cases depending on alu_op_sel
    end
endmodule
