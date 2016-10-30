module arm_alu
(
    output reg [31:0] alu_out,
    input      [31:0] alu_op1, alu_op2,
    input      [3:0]  alu_op_sel // bus size is 4 assuming max number of ops we can have is 16
);

    /* FIXME: Not checking carry bit rn */
    always @ (*) begin
        case (alu_op_sel)
            `AND, `TST:       alu_out <= alu_op1 & alu_op2;
            `EOR, `TEQ:       alu_out <= alu_op1 ^ alu_op2;
            `SUB, `SBC, `CMP: alu_out <= alu_op1 - alu_op2;
            `RSB, `RSC:       alu_out <= alu_op2 - alu_op1;
            `ADD, `ADC, `CMN: alu_out <= alu_op1 + alu_op2;
            `ORR:             alu_out <= alu_op1 | alu_op2;
            `MOV:             alu_out <= alu_op2;
            `BIC:             alu_out <= alu_op1 & ~alu_op2;
            `MVN:             alu_out <= ~alu_op2;
            default:          alu_out <= 32'bx;
        endcase
    end
endmodule
