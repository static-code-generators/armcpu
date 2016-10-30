module arm_alu
(
    output reg [31:0] alu_out,
    input      [31:0] alu_op1, alu_op2,
    input      [3:0]  alu_op_sel, // bus size is 4 assuming max number of ops we can have is 16
    output            n_bit,
    output            z_bit,
    output reg        c_bit,
    output reg        v_bit
);

    assign n_bit = alu_out[31];
    assign z_bit = (alu_out == 0);

    /** For v_bit calculation refer to http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt */
    /* FIXME: Still doesn't take carry bit as input for ADC/SBC/RSC */
    always @ (*) begin
        case (alu_op_sel)
            `AND, `TST: alu_out          = alu_op1 & alu_op2;
            `EOR, `TEQ: alu_out          = alu_op1 ^ alu_op2;
            `SUB, `SBC, `CMP:
                begin
                        {c_bit, alu_out} = alu_op1 - alu_op2;
                        v_bit            = (alu_out[31] & alu_op1[31] & ~alu_op2[31])
                                          | (~alu_out[31] & ~alu_op1[31] & alu_op2[31]);
                end
            `RSB, `RSC:
                begin
                        {c_bit, alu_out} = alu_op2 - alu_op1;
                        v_bit            = (alu_out[31] & ~alu_op1[31] & alu_op2[31])
                                          | (~alu_out[31] & alu_op1[31] & ~alu_op2[31]);
                end
            `ADD, `ADC, `CMN:
                begin
                        {c_bit, alu_out} = alu_op1 + alu_op2;
                        v_bit            = (alu_out[31] & ~alu_op1[31] & ~alu_op2[31])
                                          | (~alu_out[31] & alu_op1[31] & alu_op2[31]);
                end
            `ORR:       alu_out          = alu_op1 | alu_op2;
            `MOV:       alu_out          = alu_op2;
            `BIC:       alu_out          = alu_op1 & ~alu_op2;
            `MVN:       alu_out          = ~alu_op2;
            default:    alu_out          = 32'bx;
        endcase
    end
endmodule
