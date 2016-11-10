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
    /*---------- Outputs ------------*/
    // Inputs to register file:
    output reg [3:0]  write_rd, read_rn, read_rm, read_rs,
    output reg        rd_we, pc_we, cpsr_we,
    output reg [31:0] rd_in, pc_in, cpsr_in, // this line will probably change
    
    // Control signals for various modules
    // Inputs to shiftee_mux:
    output reg        shiftee_sel, // wired to shiftee_mux

    // Inputs to shifter_mux:
    output reg [1:0]  shifter_sel, // wired to shifter_mux

    output reg [3:0]  alu_sel, // wired to ALU
    output reg [3:0]  barrel_sel, // wired to barrel_shifter
);

    /*----------------- Decoded chunks ------------------*/

    wire [3:0] dcd_cond, dcd_opcode;
    wire [3:0] dcd_rn, dcd_rd, dcd_rm, dcd_rs;

    assign dcd_cond = inst[31:28];
    assign dcd_opcode = inst[24:21];
    assign dcd_rn = inst[19:16];
    assign dcd_rd = inst[15:12];
    assign dcd_rm = inst[3:0];
    assign dcd_rs = inst[11:8];

    wire [4:0] dcd_shift_amt;
    wire [1:0] dcd_shift;

    assign dcd_shift_amt = inst[11:7];
    assign dcd_shift = inst[6:5];

    // DATA PROCESSING - dp
    wire [3:0] dcd_dp_rotate;
    wire [7:0] dcd_dp_immed;

    assign dcd_dp_rotate = inst[11:8];
    assign dcd_dp_immed = inst[7:0];

    // BRANCH - br
    wire [23:0] dcd_br_offset;

    assign dcd_br_offset = inst[23:0];
    
    // LOAD-STORE - ls
    wire [11:0] dcd_ls_immed;
    
    assign dcd_ls_immed = inst[11:0];

    // MULTIPLY - mul
    // No more decoded chunks required

    /*---------------------------------------------------*/

    always @(*) begin

        /*--------------- FOR BARREL_SEL -----------------*/
        case (inst[I_BIT])
            1'b1: begin /* 32-bit immediate */
                shiftee_sel <= IMMED_8_SEL;
                shifter_sel <= ROTATE_IMM_SEL;
            end
            1'b0: begin
                case (inst[4])
                1'b0: begin /* immediate shifts */
                    shiftee_sel <= RM_SEL;
                    shifter_sel <= SHIFT_IMM_SEL;
                end
                1'b1: begin /* register shifts */
                    if (inst[7] == 0) begin
                        shiftee_sel <= RM_SEL;
                        shifter_sel <= RS_SEL;
                    end
                end
                endcase
            end
        endcase
        /*--------------- END BARREL_SEL -----------------*/

        /*--------------- FOR ALU_SEL -----------------*/


        /*--------------- END ALU_SEL -----------------*/

        /*--------------- OP-SPECIFIC DECODING -------------*/

        case (dcd_opcode)

            
        endcase

        /*--------------- END OP-SPECIFIC DECODING -------------*/

    end

endmodule
