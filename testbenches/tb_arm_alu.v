module tb_arm_alu;
    reg [31:0] alu_op1, alu_op2;
    reg [3:0] alu_op_sel;
    reg [31:0] cpsr_prev;
    wire [31:0] cpsr_next;
    wire [31:0] alu_out;

    initial begin
        cpsr_prev = 32'b0;
        alu_op1 = 32;
        alu_op2 = 96;

        alu_op_sel = `AND;
        #2 alu_op_sel = `EOR;
        #2 alu_op_sel = `SUB;
        #2 alu_op_sel = `RSB;
        #2 alu_op_sel = `ORR;
        #2 alu_op_sel = `ADD;
        #2 alu_op_sel = `BIC;

        /* check if carry_bit is used in ADC */
        #2 alu_op1 = 32'hffffffff;
        alu_op2 = 2;
        alu_op_sel = `ADD;
        #2 cpsr_prev = cpsr_next;
        alu_op_sel = `ADC;

        /* check if overflow bit is working correctly */
        #2 alu_op1 = 32'h7fffffff;
        alu_op2 = 2;
        alu_op_sel = `ADD;

        #2 $finish;
    end

    initial begin
        $monitor("op1: %x, op2: %x, sel: %b, out: %x, n: %b, z: %b, c: %b, v: %b",
            alu_op1, alu_op2, alu_op_sel, alu_out, cpsr_next[`CPSR_N],
            cpsr_next[`CPSR_Z], cpsr_next[`CPSR_C], cpsr_next[`CPSR_V]);
    end

    arm_alu alu(alu_out, cpsr_next, alu_op1, alu_op2, alu_op_sel, cpsr_prev);
endmodule
