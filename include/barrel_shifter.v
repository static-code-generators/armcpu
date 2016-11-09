`include "arm_defines.vh"

module barrel_shifter
(
    input               c_flag, // wired to C_BIT of CPSR
    input        [3:0]  barrel_sel, // wired to Decode unit
    input signed [31:0] shiftee, // wired to mux choosing b/w immed_8 and Rm
    input        [31:0] shifter, // wired to mux choosing b/w rotate_imm, shift_imm, and Rs
    output reg   [31:0] shifter_operand,
    output reg   [31:0] shifter_carry_out
);

// Refer to section A5.1 in ARM Manual.
// We expect shiftee to be one of immed_8 and Rm.
// We expect shifter to be one of rotate_imm, shift_imm, and Rs.
// This choice will be made by the Decode unit and passed onto
// muxes which'll choose between these inputs and appropriatly
// extend them to 32 bits.
// Refer to `assets/shitty_datapath.jpg` for a tentative circuit diagram.

// LSLIMM - x000
// LSLREG - 0001
// LSRIMM - x010
// LSRREG - 0011
// ASRIMM - x100
// ASRREG - 0101
// RORIMM - x110
// RORREG - 0111
// Register direct - 00000000

    always @(*) begin
        case (barrel_sel)
            LSLIMM: begin
                if (shifter == 0) begin
                    shifter_operand <= shiftee;
                    shifter_carry_out <= c_flag
                end
                else begin
                    shifter_operand <= shiftee << shifter;
                    shifter_carry_out <= shiftee[32 - shifter];
                begin
            end
            LSLREG: begin
                if (shifter[7:0] == 0) begin
                    shifter_operand <= shiftee;
                    shifter_carry_out <= c_flag;
                end
                else if (shifter[7:0] < 32) begin
                    shifter_operand <= shiftee << shifter[7:0];
                    shifter_carry_out <= shiftee[32 - shifter[7:0]];
                end
                else if (shifter[7:0] == 32) begin
                    shifter_operand <= 0;
                    shifter_carry_out <= shiftee[0];
                end
                else begin /* shifter[7:0] > 32 */
                   shifter_operand <= 0;
                   shifter_carry_out <= 0;
                end
            end
            LSRIMM: begin
                if (shifter == 0) begin
                    shifter_operand <= 0;
                    shifter_carry_out <= shiftee[31];
                end
                else begin /* shifter > 0 */
                    shifter_operand <= shiftee >> shifter;
                    shifter_carry_out <= shiftee[shifter - 1];
                begin
            end
            LSRREG: begin
                if (shifter[7:0] == 0) begin
                    shifter_operand <= shiftee;
                    shifter_carry_out <= c_flag;
                end
                else if (shifter[7:0] < 32) begin
                    shifter_operand <= shiftee >> shifter[7:0];
                    shifter_carry_out <= shiftee[shifter[7:0] - 1];
                end
                else if (shifter[7:0] == 32) begin
                    shifter_operand <= 0;
                    shifter_carry_out <= shiftee[31];
                end
                else begin /* shifter[7:0] > 32 */
                   shifter_operand <= 0;
                   shifter_carry_out <= 0;
                end
            end
            ASRIMM: begin
                if (shifter == 0) begin
                    if (shiftee[31] == 0) begin
                        shifter_operand <= 0;
                        shifter_carry_out <= shiftee[31];
                    end
                    else begin /* shiftee[31] == 1 */
                        shifter_operand <= 32'hFFFFFFFF;
                        shifter_carry_out <= shiftee[31];
                    end
                end
                else begin /* shifter > 0 */
                    shifter_operand <= shiftee >>> shifter;
                    shifter_carry_out <= shiftee[shifter - 1];
                begin
            end
            ASRREG: begin
                if (shifter[7:0] == 0) begin
                    shifter_operand <= shiftee;
                    shifter_carry_out <= c_flag;
                end
                else if (shifter[7:0] < 32) begin
                    shifter_operand <= shiftee >>> shifter[7:0];
                    shifter_carry_out <= shiftee[shifter[7:0] - 1];
                end
                else if (shifter[7:0] == 32) begin
                    shifter_operand <= 0;
                    shifter_carry_out <= shiftee[31];
                end
                else begin /* shifter[7:0] > 32 */
                    if (shiftee[31] == 0) begin
                        shifter_operand <= 0;
                        shifter_carry_out <= shiftee[31];
                    end
                    else begin /* shiftee[31] == 1 */
                        shifter_operand <= 32'hFFFFFFFF;
                        shifter_carry_out <= shiftee[31];
                    end
                end
            end
            RORIMM: begin
                if (shifter == 0) begin // RRX
                    shifter_operand <= ((c_flag << 31) | (shiftee >> 1));
                    shifter_carry_out <= shiftee[0];
                end
                else begin /* shifter > 0 */
                    shifter_operand <= ((shiftee << (32 - shifter)) | (shiftee >> shifter)); // rotate-right
                    shifter_carry_out <= shiftee[shifter - 1];
                end
            end
            RORREG: begin
                if (shifter[7:0] == 0) begin
                    shifter_operand <= shiftee;
                    shifter_carry_out <= c_flag;
                end
                else if (shifter[4:0] == 0) begin
                    shifter_operand <= shiftee;
                    shifter_carry_out <= shiftee[31];
                end
                else begin /* shifter > 0 */
                    shifter_operand <= ((shiftee << (32 - shifter[4:0])) | (shiftee >> shifter[4:0])); // rotate-right
                    shifter_carry_out <= shiftee[shifter[4:0] - 1];
                end
            end
        endcase
    end

endmodule
