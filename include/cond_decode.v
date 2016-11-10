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
            `EQ : valid <=  cpsr[`Z_BIT];
            `NE : valid <= ~cpsr[`Z_BIT];
            `CS : valid <=  cpsr[`C_BIT]; 
            `CC : valid <= ~cpsr[`C_BIT];
            `MI : valid <=  cpsr[`N_BIT];
            `PL : valid <= ~cpsr[`N_BIT];
            `VS : valid <=  cpsr[`V_BIT];
            `VC : valid <= ~cpsr[`V_BIT];
            `HI : valid <= (cpsr[`C_BIT]) && (~cpsr[`Z_BIT]);
            `LS : valid <= (~cpsr[`C_BIT]) || (cpsr[`Z_BIT]);
            `GE : valid <= ((cpsr[`N_BIT]) && (cpsr[`V_BIT])) || ((~cpsr[`N_BIT]) && (~cpsr[`V_BIT]));
            `LT : valid <= ((~cpsr[`N_BIT]) && (cpsr[`V_BIT])) || ((cpsr[`N_BIT]) && (~cpsr[`V_BIT]));
            `GT : valid <= (~cpsr[`Z_BIT]) && (((cpsr[`N_BIT]) && (cpsr[`V_BIT])) || ((~cpsr[`N_BIT]) && (~cpsr[`V_BIT])));
            `LE : valid <= (cpsr[`Z_BIT]) && (((~cpsr[`N_BIT]) && (cpsr[`V_BIT])) || ((cpsr[`N_BIT]) && (~cpsr[`V_BIT])));
            `AL : valid <= 1'b1;
            default : valid <= 1'b0;
        endcase
    end

endmodule
