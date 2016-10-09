`include "arm_defines.vh"

module arm_decode_instruction
(
    input      [31:0] inst, // input instruction
    output reg [3:0]  alu_sel // select ALU function 
    // need to decide other outputs of the decoder
);
    reg [3:0] cond;
    reg i;
    reg [3:0] opcode;
    reg s;
    reg [3:0] rn, rd;
    reg [11:0] operand_2;

    always_comb begin
        // what we do now
    end
endmodule
