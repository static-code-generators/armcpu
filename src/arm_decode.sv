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
        // Decoding will be different for branch, multiply, etc. instructions (obviously)
        // Sample for data processing instructions:
        // ------------------------------------------------------------
        // |31    28|27  26|25 |24    21|20 |19  16|15  12|11        0|
        // ------------------------------------------------------------
        // |  Cond  |  00  | I | OpCode | S |  Rn  |  Rd  | Operand 2 |
        // ------------------------------------------------------------
        cond = inst[31:28];
        i = inst[25];
        opcode = inst[24:21];
        s = inst[20]
        rn = inst[19:16];
        rd = inst[15:12];
        operand_2 = inst[11:0];
        // Then do magic with the above...
    end
endmodule
