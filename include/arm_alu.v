module arm_alu
(
    output reg [31:0] alu_out,
    output reg [31:0] cpsr_next, // wired to cpsr_in of register_file, set cpsr_we to high IFF you want this to update CPSR (S_BIT == 1)
    input      [31:0] alu_op1, // usually wired to Rn
    input      [31:0] alu_op2, // usually wired to shifter_operand
    input      [3:0]  alu_op_sel, // these correspond to instruction[24:21] for data_processing ones
    input      [31:0] cpsr_prev // wired to cpsr_out
);

    reg borrow;

    always @ (*) begin
        cpsr_next[31:0] = cpsr_prev[31:0];
        case (alu_op_sel)
            `AND, `TST:
                alu_out                       = alu_op1 & alu_op2;
            `EOR, `TEQ:
                alu_out                       = alu_op1 ^ alu_op2;
            `ADD, `CMN: begin
                {cpsr_next[`CPSR_C], alu_out} = alu_op1 + alu_op2;
                cpsr_next[`CPSR_V]            = CALC_OVERFLOW(alu_op1[31], alu_op2[31], alu_out[31]);
            end
            `ADC: begin
                {cpsr_next[`CPSR_C], alu_out} = alu_op1 + alu_op2 + cpsr_prev[`CPSR_C];
                cpsr_next[`CPSR_V]            = CALC_OVERFLOW(alu_op1[31], alu_op2[31], alu_out[31]);
            end
            `SUB, `CMP: begin
                {borrow, alu_out}             = alu_op1 - alu_op2;
                cpsr_next[`CPSR_V]            = CALC_OVERFLOW(alu_op1[31], ~alu_op2[31], alu_out[31]);
                cpsr_next[`CPSR_C]            = ~borrow; // for subtraction, carry = ~borrow in arm
            end
            `SBC: begin
                {borrow, alu_out}             = alu_op1 - alu_op2 - ~cpsr_prev[`CPSR_C];
                cpsr_next[`CPSR_V]            = CALC_OVERFLOW(alu_op1[31], ~alu_op2[31], alu_out[31]);
                cpsr_next[`CPSR_C]            = ~borrow;
            end
            `RSB: begin
                {borrow, alu_out}             = alu_op2 - alu_op1;
                cpsr_next[`CPSR_V]            = CALC_OVERFLOW(alu_op2[31], ~alu_op1[31], alu_out[31]);
                cpsr_next[`CPSR_C]            = ~borrow;
            end
            `RSC: begin
                {borrow, alu_out}             = alu_op2 - alu_op1 - ~cpsr_prev[`CPSR_C];
                cpsr_next[`CPSR_V]            = CALC_OVERFLOW(alu_op2[31], ~alu_op1[31], alu_out[31]);
                cpsr_next[`CPSR_C]            = ~borrow;
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
        $display("\tALU cpsr_next %b cpsr_prev %b", cpsr_next[31:28], cpsr_prev[31:28]);
    end

    /**
    * Calculate overflow bit for addition.
    * For subtraction (diff = num1 - num2), call it like
    *     CALC_OVERFLOW(num1sign, ~num2sign, diffsign)
    * reference http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt
    */
    function CALC_OVERFLOW(input num1sign, input num2sign, input sumsign);
        CALC_OVERFLOW = (~num1sign & ~num2sign & sumsign) | (num1sign & num2sign & ~sumsign);
    endfunction
endmodule
