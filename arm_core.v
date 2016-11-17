/*
 * Top-level module for instantiating all other modules.
 */
module arm_core
(
    // Inputs
    input             clk, rst,
    input      [31:0] inst,
    input      [31:0] mem_data_out, // Data from memory load
    // Outputs
    output reg        halted,
    output reg [29:0] mem_addr,     // Address of data to load
    output reg [29:0] inst_addr,    // Address of next instruction to load from memory
    // Load op inputs to memory are 30 bits because lower 2 bits are
    // implicity zero, address divisible by 4 because word-aligned
    output reg [31:0] mem_data_in   // Data for memory store
);

    // For register_file:
    wire        rd_we;
    wire [31:0] rd_in;
    wire [3:0]  write_rd;
    wire [3:0]  read_rn, read_rm, read_rs;
    wire [31:0] pc_in, cpsr_in;
    wire        pc_we, cpsr_we;
    wire [31:0] rn_out, rm_out, rs_out;
    wire [31:0] pc_out, cpsr_out;

    // For cond_decode:
    wire cond_pass;

    // For shiftee_mux:
    wire        shiftee_sel;
    wire [7:0]  immed_8;
    wire [31:0] shiftee;

    // For shifter_mux:
    wire [1:0]  shifter_sel;
    wire [3:0]  rotate_imm;
    wire [4:0]  shift_imm;
    wire [31:0] shifter;

    // For barrel_shifter:
    wire [3:0]  barrel_sel;
    wire [31:0] shifter_operand;  
    wire [31:0] shifter_carry_out;

    // For arm_alu:
    wire [31:0] alu_out;
    wire [3:0]  alu_sel;

    register_file Register
    (
        // Inputs
        .clk(clk),
        .reset(rst),
        .rd_we(rd_we),
        .write_rd(write_rd),
        .read_rn(read_rn),
        .read_rm(read_rm),
        .read_rs(read_rs),
        .pc_in(pc_in),
        .cpsr_in(cpsr_in),
        .pc_we(pc_we),
        // Outputs
        .rn_out(rn_out),
        .rm_out(rm_out),
        .rs_out(rs_out),
        .pc_out(pc_out),
        .cpsr_out(cpsr_out)
    );

    cond_decode CondDecoder
    (
        // Inputs
        .inst(inst),
        .cpsr(cpsr_out),
        // Outputs
        .valid(cond_pass)
    );
 
    shiftee_mux ShifteeMux
    (
        // Inputs
        .sel(shiftee_sel),
        .immed_8(immed_8),
        .rm(rm_out),
        // Output
        .shiftee(shiftee)
    );

    shifter_mux ShifterMux
    (
        // Inputs
        .sel(shifter_sel),
        .rotate_imm(rotate_imm),
        .shift_imm(shift_imm),
        .rs(rs_out),
        // Output
        .shifter(shifter)
    );

    barrel_shifter Shifter
    (
        // Inputs
        .c_flag(cpsr_out[`CPSR_C]),
        .barrel_sel(barrel_sel),
        .shiftee(shiftee),
        .shifter(shifter),
        // Outputs
        .shifter_operand(shifter_operand),
        .shifter_carry_out(shifter_carry_out)
    );

    arm_alu alu
    (
        // Outputs
        .alu_out(alu_out),
        .cpsr_next(cpsr_in),
        // Inputs
        .alu_op1(rn_out),
        .alu_op2(shifter_operand),
        .alu_op_sel(alu_sel),
        .cpsr_prev(cpsr_out)
    );

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

    //arm_mac mac
    //(

    //);
    
    // Instantiate muxes as required between each module
    // Mux select lines will have to be appropriately set
    // by the main decode unit

endmodule
