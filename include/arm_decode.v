/*
 * Main instruction decoder module
 * Passes control signals to ALU, MAC, multiple multiplexers, etc.
 * to perform correct sequence of operations. 
 * Basically a MIPS-style 'Control Unit', following Hennesey and Patterson.
 */
module arm_decode
(
    input             cond_pass, // wired to output of cond_checker module, only changes outputs if cond_pass is true
    input      [31:0] inst, // input instruction
    /*---------- Outputs ------------*/
    // Inputs to register file:
    output reg [3:0]  write_rd, read_rn, read_rm, read_rs,
    output reg        rd_we, pc_we, cpsr_we,
    output reg [31:0] rd_in, pc_in, cpsr_in, // this line will probably change
    
    // Control signals for various modules
    // Inputs to shiftee_mux (all register inputs will be connected to
    // register file, only immediate values connected via decoder:
    output reg        shiftee_sel,
    output     [7:0]  immed_8_shiftee_in, 

    // Inputs to shifter_mux:
    output reg [1:0]  shifter_sel,
    output     [3:0]  rotate_imm_shifter_in,
    output     [4:0]  shift_imm_shifter_in,

    output reg [3:0]  alu_sel, // wired to ALU
    output reg [3:0]  barrel_sel // wired to barrel_shifter
);

    /*----------------- Assigning decoded chunks ------------------*/

    /*
    * Sections:
        * From Instruction-type POV
        * From Module POV
            * For shiftee_mux
            * For shifter_mux
    */

    /*------------ From Instruction-type POV ---------------*/

    wire [3:0] dcd_cond, dcd_opcode;
    wire [3:0] dcd_rn, dcd_rd, dcd_rm, dcd_rs;

    assign dcd_cond = inst[31:28];
    assign dcd_opcode = inst[24:21];
    assign dcd_rn = inst[19:16];
    assign dcd_rd = inst[15:12];
    assign dcd_rm = inst[3:0];
    assign dcd_rs = inst[11:8];

    // Below are relevant for load-store and data processing, not branch
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

    /*------------ Instruction-type POV end ---------------*/

    /*------------ From module POV ------------*/
    
    // For shiftee_mux inputs:
    assign immed_8_shiftee_in = dcd_dp_immed;

    // For shifter_mux inputs:
    assign shift_imm_shifter_in = dcd_shift_amt;
    assign rotate_imm_shifter_in = dcd_dp_rotate;

    /*------------ Module POV end ------------*/

    /*----------------- Decoded chunks end ------------------*/

    /*----------- Actual decoding by instruction details ---------*/

    always @(*) begin
        if (cond_pass == 1) begin

            /*--------------- OP-SPECIFIC DECODING -------------*/
            case (inst[27:26])

                /*--------- DATA PROCESSING INSTRUCTIONS ---------*/
                2'b00: begin
                    // For register file:
                    read_rn <= dcd_rn;
                    write_rd <= dcd_rd;
                    rd_we <= 1'b1;
                    cpsr_we <= inst[`S_BIT];

                    // For alu:
                    alu_sel <= dcd_opcode;

                    /*--------------- FOR BARREL SHIFTER -----------------*/
                    case (inst[`I_BIT])
                        1'b1: begin /* 32-bit immediate */
                            shiftee_sel <= `IMMED_8_SEL;
                            shifter_sel <= `ROTATE_IMM_SEL;
                        end
                        1'b0: begin
                            read_rm <= dcd_rm; // shiftee register only in (obviously) non-immediate shifter operands

                            case (inst[4])
                                1'b0: begin /* immediate shifts */
                                    shiftee_sel <= `RM_SEL;
                                    shifter_sel <= `SHIFT_IMM_SEL;
                                    /*--- FOR BARREL_SEL ----*/
                                    case (dcd_shift)
                                        2'b00: barrel_sel <= `LSLIMM;
                                        2'b01: barrel_sel <= `LSRIMM;
                                        2'b10: barrel_sel <= `ASRIMM;
                                        2'b11: barrel_sel <= `RORIMM;
                                    endcase
                                    /*--- BARREL_SEL END ----*/
                                end
                                1'b1: begin /* register shifts */
                                    if (inst[7] == 0) begin
                                        read_rs <= dcd_rs; // le wild shifter register appeared
                                        shiftee_sel <= `RM_SEL;
                                        shifter_sel <= `RS_SEL;
                                        /*--- FOR BARREL_SEL ----*/
                                        case (dcd_shift)
                                            2'b00: barrel_sel <= `LSLREG;
                                            2'b01: barrel_sel <= `LSRREG;
                                            2'b10: barrel_sel <= `ASRREG;
                                            2'b11: barrel_sel <= `RORREG;
                                        endcase
                                        /*--- BARREL_SEL END ----*/
                                    end
                                end
                            endcase
                        end
                    endcase
                    /*--------------- END BARREL SHIFTER -----------------*/

                end
                /*--------- END DATA PROCESSING ----------*/

                /*--------- LOAD/STORE INSTRUCTIONS ----------*/
                // Note that we aren't covering Load/store multiple here
                2'b01: begin

                end
                /*------------ END LOAD/STORE --------------*/
                
                /*------------ BRANCH INSTRUCTIONS -----------*/
                2'b10: begin

                end
                /*------------ END BRANCH -----------*/

            endcase

            /*--------------- END OP-SPECIFIC DECODING -------------*/

        end
    end

endmodule
