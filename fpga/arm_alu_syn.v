/* ALU OP_SEL and also OPCODE for data processing instructions */
`define AND 4'b0000
`define EOR 4'b0001
`define SUB 4'b0010
`define RSB 4'b0011
`define ADD 4'b0100
`define ADC 4'b0101
`define SBC 4'b0110
`define RSC 4'b0111
`define TST 4'b1000
`define TEQ 4'b1001
`define CMP 4'b1010
`define CMN 4'b1011
`define ORR 4'b1100
`define MOV 4'b1101
`define BIC 4'b1110
`define MVN 4'b1111

/* For CPSR */
`define CPSR_N 3
`define CPSR_Z 2
`define CPSR_C 1
`define CPSR_V 0

module arm_alu_syn
(
    output reg [3:0] alu_out,
    output reg [3:0] cpsr_out,
    input      [3:0] alu_op1,
    input      [3:0] alu_op2,
    input      [3:0]  alu_op_sel
);

    reg borrow;

    always @ (*) begin
        case (alu_op_sel)
            `AND, `TST:
                alu_out                       = alu_op1 & alu_op2;
            `EOR, `TEQ:
                alu_out                       = alu_op1 ^ alu_op2;
            `ADD, `CMN: begin
                {cpsr_out[`CPSR_C], alu_out} = alu_op1 + alu_op2;
                cpsr_out[`CPSR_V]            = CALC_OVERFLOW(alu_op1[3], alu_op2[3], alu_out[3]);
            end
            `ADC: begin
                {cpsr_out[`CPSR_C], alu_out} = alu_op1 + alu_op2 + cpsr_out[`CPSR_C];
                cpsr_out[`CPSR_V]            = CALC_OVERFLOW(alu_op1[3], alu_op2[3], alu_out[3]);
            end
            `SUB, `CMP: begin
                {borrow, alu_out}             = alu_op1 - alu_op2;
                cpsr_out[`CPSR_V]            = CALC_OVERFLOW(alu_op1[3], ~alu_op2[3], alu_out[3]);
                cpsr_out[`CPSR_C]            = ~borrow; // for subtraction, carry = ~borrow in arm
            end
            `SBC: begin
                {borrow, alu_out}             = alu_op1 - alu_op2 - ~cpsr_out[`CPSR_C];
                cpsr_out[`CPSR_V]            = CALC_OVERFLOW(alu_op1[3], ~alu_op2[3], alu_out[3]);
                cpsr_out[`CPSR_C]            = ~borrow;
            end
            `RSB: begin
                {borrow, alu_out}             = alu_op2 - alu_op1;
                cpsr_out[`CPSR_V]            = CALC_OVERFLOW(alu_op2[3], ~alu_op1[3], alu_out[3]);
                cpsr_out[`CPSR_C]            = ~borrow;
            end
            `RSC: begin
                {borrow, alu_out}             = alu_op2 - alu_op1 - ~cpsr_out[`CPSR_C];
                cpsr_out[`CPSR_V]            = CALC_OVERFLOW(alu_op2[3], ~alu_op1[3], alu_out[3]);
                cpsr_out[`CPSR_C]            = ~borrow;
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
                alu_out                       = 4'bx;
        endcase
        cpsr_out[`CPSR_N] = alu_out[3];
        cpsr_out[`CPSR_Z] = (alu_out == 0);
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




