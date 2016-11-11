`include "arm_defines.vh"

/*
 * Outputs valid signal depending on current status of CPSR
 */
module cond_decode
(
    input [31:0] inst, cpsr,
    output reg valid
);
    wire [3:0] cond;

    assign cond = inst[31-:4]; //wired to condition bits in instruction

    always @ (inst) begin
        case(cond)
            `EQ : valid <=  cpsr[`CPSR_Z];
            `NE : valid <= ~cpsr[`CPSR_Z];
            `CS : valid <=  cpsr[`CPSR_C]; 
            `CC : valid <= ~cpsr[`CPSR_C];
            `MI : valid <=  cpsr[`CPSR_N];
            `PL : valid <= ~cpsr[`CPSR_N];
            `VS : valid <=  cpsr[`CPSR_V];
            `VC : valid <= ~cpsr[`CPSR_V];
            `HI : valid <= (cpsr[`CPSR_C]) && (~cpsr[`CPSR_Z]);
            `LS : valid <= (~cpsr[`CPSR_C]) || (cpsr[`CPSR_Z]);
            `GE : valid <= ((cpsr[`CPSR_N]) && (cpsr[`CPSR_V])) || ((~cpsr[`CPSR_N]) && (~cpsr[`CPSR_V]));
            `LT : valid <= ((~cpsr[`CPSR_N]) && (cpsr[`CPSR_V])) || ((cpsr[`CPSR_N]) && (~cpsr[`CPSR_V]));
            `GT : valid <= (~cpsr[`CPSR_Z]) && (((cpsr[`CPSR_N]) && (cpsr[`CPSR_V])) || ((~cpsr[`CPSR_N]) && (~cpsr[`CPSR_V])));
            `LE : valid <= (cpsr[`CPSR_Z]) || (((~cpsr[`CPSR_N]) && (cpsr[`CPSR_V])) || ((cpsr[`CPSR_N]) && (~cpsr[`CPSR_V])));
            `AL : valid <= 1'b1;
            default : valid <= 1'b0;
        endcase
    end

endmodule
