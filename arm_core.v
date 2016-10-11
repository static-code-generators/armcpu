`include "arm_defines.vh"

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

    // NB: Slight deviation from armsimc here.
    // We need to instantiate all wires for all instruction
    // formats possible within the top module only, so individual
    // register/operand decoding will not take place within
    // instruction execution blocks anymore.

    // Some common encoded chunks for all instructions
    wire [3:0] dcd_cond, dcd_opcode;
    wire [3:0] dcd_rn, dcd_rd, dcd_rm;
    wire [4:0] dcd_shift_amt;
    wire [1:0] dcd_shift;

    assign dcd_cond = inst[31:28];
    assign dcd_opcode = inst[24:21];
    assign dcd_rn = inst[19:16];
    assign dcd_rd = inst[15:12];
    assign dcd_rm = inst[3:0];
    assign dcd_shift_amt = inst[11:7];
    assign dcd_shift = inst[6:5];

    // DATA PROCESSING - dp
    wire [3:0] dcd_dp_rotate;
    wire [3:0] dcd_dp_rs;
    wire [7:0] dcd_dp_immed;

    assign dcd_dp_rotate = inst[11:8];
    assign dcd_dp_rs = inst[11:8];
    assign dcd_dp_immed = inst[7:0];

    // BRANCH - br
    wire [23:0] dcd_br_offset;

    assign dcd_br_offset = inst[23:0];
    
    // LOAD-STORE - ls
    wire [11:0] dcd_ls_immed;
    
    assign dcd_ls_immed = inst[11:0];

    // MULTIPLY - mul
    wire [3:0] dcd_mul_rd, dcd_mul_rn, dcd_mul_rs, dcd_mul_rm; // rn is used only in MLA inst

    assign dcd_mul_rd = inst[19:16];
    assign dcd_mul_rn = inst[15:12];
    assign dcd_mul_rs = inst[11:8];
    assign dcd_mul_rm = inst[3:0];

    // SWI - swi
    wire [23:0] dcd_swi_number;

    assign dcd_swi_number = inst[23:0];

    // Need to hook PC up to register file
    wire [31:0] pc;
    assign inst_addr = pc;

    reg [31:0] cpsr;
    
    arm_decode MainDecoder
    (

    );

    cond_decode CondDecoder
    (

    );

    register_file Register
    (

    );

    arm_alu alu
    (

    );

    arm_mac mac
    (

    );

    barrel_shifter Shifter
    (

    );

    // Instantiate muxes as required between each module
    // Mux select lines will have to be appropriately set
    // by the main decode unit

endmodule
