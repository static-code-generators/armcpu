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

    cond_decode CondDecoder
    (
        .inst(inst),
        .cpsr(cpsr_out),
        .valid(cond_pass)
    );

    register_file Register
    (
        // Inputs
        .clk(clk),
        .reset(rst),
        .rd_we(rd_we),
        .write_rd(write_rd),
        .read_rn(read_rn),
        .read_rm(read_rm),
        .pc_in(pc_in),
        .cpsr_in(cpsr_in),
        .pc_we(pc_we),
        // Outputs
        .rn_out(rn_out),
        .rm_out(rm_out),
        .pc_out(pc_out),
        .cpsr_out(cpsr_out)
    );

 
    arm_decode ControlDecodeUnit
    (
        // Inputs
        .cond_pass(cond_pass),
        .inst(inst),
        // Outputs
        .write_rd(write_rd),
        .read_rn(read_rn),
        .read_rm(read_rm),
        .rd_we(rd_we),
        .pc_we(pc_we),
        .cpsr_we(cpsr_we),
        .rd_in(rd_in),
        .pc_in(pc_in),
        .cpsr_in(cpsr_in),
        .shiftee_sel(shiftee_sel),
        .immed_8_shiftee_in(immed_8),
        .shifter_sel(shifter_sel),
        .rotate_imm_shifter_in(rotate_imm),
        .shift_imm_shifter_in(shift_imm),
        .alu_sel(alu_sel),
        .barrel_sel(barrel_sel)
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

    barrel_shifter Shifter
    (
        // Inputs
        .c_flag(cpsr_out[`C_BIT]),
        .barrel_sel(barrel_sel),
        .shiftee(shiftee),
        .shifter(shifter),
        // Outputs
        .shifter_operand(shifter_operand),
        .shifter_carry_out(shifter_carry_out)
    );

    shiftee_mux ShifteeMux
    (
        .sel(shiftee_sel),
        .immed_8(immed_8_shiftee_in),
        .rm(rm_out),
        .shiftee(shiftee)
    );

    shifter_mux ShifterMux
    (
        .sel(shifter_sel),
        .rotate_imm(rotate_imm_shifter_in),
        .shift_imm(shift_imm_shifter_in),
        .rs(rs_out),
        .shifter(shifter)
    );

    arm_mac mac
    (

    );
    // Instantiate muxes as required between each module
    // Mux select lines will have to be appropriately set
    // by the main decode unit

endmodule
