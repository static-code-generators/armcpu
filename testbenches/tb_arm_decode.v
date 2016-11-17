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

    // For shiftee_mux:
    wire        shiftee_sel;
    wire [7:0]  immed_8;

    // For shifter_mux:
    wire [1:0]  shifter_sel;
    wire [3:0]  rotate_imm;
    wire [4:0]  shift_imm;

    // For barrel_shifter:
    wire [3:0]  barrel_sel;

    // For arm_alu:
    wire [3:0]  alu_sel;

   
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
        // To shiftee_mux:
        .shiftee_sel(shiftee_sel),
        .immed_8_shiftee_in(immed_8),
        // To shifter_mux:
        .shifter_sel(shifter_sel),
        .rotate_imm_shifter_in(rotate_imm),
        .shift_imm_shifter_in(shift_imm),
        // To arm_alu:
        .alu_sel(alu_sel),
        // To barrel_shifter:
        .barrel_sel(barrel_sel)
    );

    initial begin
        $dumpfile("blah.vcd");
        $dumpvars;

        #10 inst = 32'b11100010000000010001000000000010; // AND R1, R1, #2
            cond_pass = 1'b1;
        #10 $finish;
    end

endmodule
