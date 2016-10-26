module tb_arm_alu;
    reg [31:0] alu_op1, alu_op2;
    reg [3:0] alu_op_sel;
    wire [31:0] alu_out;

    initial begin
        alu_op1 = 32;
        alu_op2 = 96;
        alu_op_sel = `AND;
        #2 alu_op_sel = `EOR;
        #2 alu_op_sel = `SUB;
        #2 alu_op_sel = `RSB;
        #2 alu_op_sel = `ORR;
        #2 alu_op_sel = `ADD;
        #2 alu_op_sel = `BIC;
        #2 $finish;
    end

    initial begin
        $monitor("op1: %x, op2: %x, sel: %b, out: %x", alu_op1, alu_op2,
                 alu_op_sel, alu_out);
    end

    arm_alu alu(alu_out, alu_op1, alu_op2, alu_op_sel);
endmodule
