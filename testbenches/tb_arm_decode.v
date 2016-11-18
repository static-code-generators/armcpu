module tb_arm_decode;
    
    reg cond_pass;
    reg [31:0] inst;
 
    // For register_file:
    wire        rd_we;
    wire [31:0] rd_in;
    wire [3:0]  write_rd;
    wire [3:0]  read_rn, read_rm, read_rs;
    wire [31:0] pc_in, cpsr_in;
    wire        pc_we, cpsr_we;
    wire [31:0] rn_out, rm_out, rs_out;
    wire [31:0] pc_out, cpsr_out;

    // For shiftee_mux:
    wire [1:0]  shiftee_sel;
    wire [7:0]  immed_8;
    wire [31:0] immed_32;

    // For shifter_mux:
    wire [1:0]  shifter_sel;
    wire [3:0]  rotate_imm;
    wire [4:0]  shift_imm;

    // For barrel_shifter:
    wire [3:0]  barrel_sel;

    // For arm_alu:
    wire [3:0]  alu_sel;
    wire [31:0] alu_out;

   
    arm_decode ControlDecodeUnit
    (
        // Inputs
        .cond_pass(cond_pass),
        .inst(inst),
        // Outputs
        // To register_file:
        .write_rd(write_rd),
        .read_rn(read_rn),
        .read_rm(read_rm),
        .read_rs(read_rs),
        .rd_we(rd_we),
        .pc_we(pc_we),
        .cpsr_we(cpsr_we),
        .rd_in(rd_in),
        .pc_in(pc_in),
        .cpsr_in(cpsr_in),
        .rn_out(rn_out),
        .rm_out(rm_out),
        .rs_out(rs_out),
        .pc_out(pc_out),
        .cpsr_out(cpsr_out),
        // To shiftee_mux:
        .shiftee_sel(shiftee_sel),
        .immed_8_shiftee_in(immed_8),
        .immed_32_shiftee_in(immed_32),
        // To shifter_mux:
        .shifter_sel(shifter_sel),
        .rotate_imm_shifter_in(rotate_imm),
        .shift_imm_shifter_in(shift_imm),
        // To arm_alu:
        .alu_sel(alu_sel),
        .alu_out(alu_out),
        // To barrel_shifter:
        .barrel_sel(barrel_sel)
    );

    initial begin
        $dumpfile("blah.vcd");
        $dumpvars;
        $monitor("inst: %x | %b\nalu_sel: %x, barrel_sel: %x, shiftee_sel: %x, shifter_sel: %x\nread_rn: %x, write_rd: %x, read_rm: %x, read_rs: %x\n-------\n",
            inst, inst, alu_sel, barrel_sel, shiftee_sel, shifter_sel, read_rn, write_rd, read_rm, read_rs);
    end

    initial begin
        $monitor("inst: %x | %b\nprogram counter: %d read_rn: %d rn_out: %d\n---------\n",
            inst, inst, pc_out, read_rn, rn_out);
    end

    initial begin
        #10 cond_pass = 1'b1;

        /*---- TEST CASES FOR DATA PROCESSING INSTRUCTIONS ----*/
        // Below cases have been taken from Section A5.1.2, ARM manual
        // Immediate operand value
        #10 inst = 32'hE2011002; // AND R1, R1, #2
        #10 inst = 32'hE3C89CFF; // BIC R9, R8, #0xFF00
        // Register operand value
        #10 inst = 32'hE0834002; // ADD R4, R3, R2
        #10 inst = 32'hE1570008; // CMP R7, R8
        // Shifted register operand value
        #10 inst = 32'hE1A02100; // MOV R2, R0, LSL #2
        #10 inst = 32'hE0859185; // ADD R9, R5, R5, LSL #3
        #10 inst = 32'hE049A228; // SUB R10, R9, R8, LSR #4
        #10 inst = 32'hE1A0C374; // MOV R12, R4, ROR R3
        /*---- DATA PROCESSING INSTRUCTIONS END ----*/

        /*---- TEST CASES FOR LOAD/STORE INSTRUCTIONS ----*/
        // Add your cases here.
        /*---- LOAD/STORE INSTRUCTIONS END ----*/

        /*---- TEST CASES FOR BRANCH INSTRUCTIONS ----*/
        #10 inst = 32'hEB00000A; //BL 42
        /*---- BRANCH INSTRUCTIONS END ----*/

        #10 $finish;
    end

endmodule
