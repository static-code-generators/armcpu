module arm_alu
(
    output reg [31:0] alu_out,
    output reg [31:0] cpsr_next, // wired to cpsr_in of register_file, set cpsr_be to high IFF you want these to update cpsr (S_BIT == 1)
    input      [31:0] alu_op1, alu_op2,
    input      [3:0]  alu_op_sel, // these correspond to instruction[24:21] for data_processing ones
    input      [31:0] cpsr_prev // wired to cpsr_out
);

    /** For CPSR_V calculation refer to http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt */
    always @ (*) begin
        cpsr_next[31:0] = cpsr_prev[31:0];
        case (alu_op_sel)
            `AND, `TST:
                alu_out                       = alu_op1 & alu_op2;
            `EOR, `TEQ:
                alu_out                       = alu_op1 ^ alu_op2;
            `SUB, `CMP: begin
                {cpsr_next[`CPSR_C], alu_out} = alu_op1 - alu_op2;
                cpsr_next[`CPSR_V]            = (alu_out[31] & alu_op1[31] & ~alu_op2[31])
                                              | (~alu_out[31] & ~alu_op1[31] & alu_op2[31]);
                cpsr_next[`CPSR_C]            = ~cpsr_next[`CPSR_C]; // for subtraction, carry = ~borrow in arm
            end
            `SBC: begin
                {cpsr_next[`CPSR_C], alu_out} = alu_op1 - alu_op2 - ~cpsr_prev[`CPSR_C];
                cpsr_next[`CPSR_V]            = (alu_out[31] & alu_op1[31] & ~alu_op2[31])
                                              | (~alu_out[31] & ~alu_op1[31] & alu_op2[31]);
                cpsr_next[`CPSR_C]            = ~cpsr_next[`CPSR_C]; // for subtraction, carry = ~borrow in arm
            end
            `RSB: begin
                {cpsr_next[`CPSR_C], alu_out} = alu_op2 - alu_op1;
                cpsr_next[`CPSR_V]            = (alu_out[31] & ~alu_op1[31] & alu_op2[31])
                                              | (~alu_out[31] & alu_op1[31] & ~alu_op2[31]);
                cpsr_next[`CPSR_C]            = ~cpsr_next[`CPSR_C];
            end
            `RSC: begin
                {cpsr_next[`CPSR_C], alu_out} = alu_op2 - alu_op1 - ~cpsr_prev[`CPSR_C];
                cpsr_next[`CPSR_V]            = (alu_out[31] & ~alu_op1[31] & alu_op2[31])
                                              | (~alu_out[31] & alu_op1[31] & ~alu_op2[31]);
                cpsr_next[`CPSR_C]            = ~cpsr_next[`CPSR_C];
            end
            `ADD, `CMN: begin
                {cpsr_next[`CPSR_C], alu_out} = alu_op1 + alu_op2;
                cpsr_next[`CPSR_V]            = (alu_out[31] & ~alu_op1[31] & ~alu_op2[31])
                                              | (~alu_out[31] & alu_op1[31] & alu_op2[31]);
            end
            `ADC: begin
                {cpsr_next[`CPSR_C], alu_out} = alu_op1 + alu_op2 + cpsr_prev[`CPSR_C];
                cpsr_next[`CPSR_V]            = (alu_out[31] & ~alu_op1[31] & ~alu_op2[31]);
            end
            `ORR:
                alu_out                       = alu_op1 | alu_op2;
            `MOV:
                alu_out                       = alu_op2;
            `BIC:
                alu_out                       = alu_op1 & ~alu_op2;
            `MVN:
                alu_out                       = ~alu_op2;
            default:
                alu_out                       = 32'bx;
        endcase
        cpsr_next[`CPSR_N] = alu_out[31];
        cpsr_next[`CPSR_Z] = (alu_out == 0);
    end
endmodule
