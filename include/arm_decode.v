`include "arm_defines.vh"

/*
 * Main instruction decoder module
 * Passes control signals to ALU, MAC, multiple multiplexers, etc.
 * to perform correct sequence of operations. 
 * Basically a MIPS-style 'Control Unit', following Hennesey and Patterson.
 */
module arm_decode
(
    input      [31:0] inst, // input instruction
    output reg [3:0]  alu_sel // select ALU function 
    // need to decide other outputs of the decoder
);
    wire [3:0] cond, opcode;

    assign cond = inst[31:28];
    assign opcode = inst[24:21];

    // what we do now
    
endmodule
