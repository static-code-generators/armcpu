`define S_BIT 20

`define L_BIT 20
`define W_BIT 21
`define B_BIT 22
`define U_BIT 23
`define P_BIT 24
`define I_BIT 25

`define EQ 4'b0000
`define NE 4'b0001
`define CS 4'b0010
`define CC 4'b0011
`define MI 4'b0100
`define PL 4'b0101
`define VS 4'b0110
`define VC 4'b0111
`define HI 4'b1000
`define LS 4'b1001
`define GE 4'b1010
`define LT 4'b1011
`define GT 4'b1100
`define LE 4'b1101
`define AL 4'b1110

/* ALU OP_SEL and also OPCODE for data processing instructions */
`define AND 4'b0000
`define EOR 4'b0001
`define SUB 4'b0010
`define RSB 4'b0011
`define ADD 4'b0100
`define ADC 4'b0101
`define SBC 4'b0110
`define RSC 4'b0111
`define TST 4'b1000
`define TEQ 4'b1001
`define CMP 4'b1010
`define CMN 4'b1011
`define ORR 4'b1100
`define MOV 4'b1101
`define BIC 4'b1110
`define MVN 4'b1111

/* For BARREL_SEL */
`define LSLIMM 4'b0000
`define LSLREG 4'b0001
`define LSRIMM 4'b0010
`define LSRREG 4'b0011
`define ASRIMM 4'b0100
`define ASRREG 4'b0101
`define RORIMM 4'b0110
`define RORREG 4'b0111
`define IMMED  4'b1000

/* For SHIFTEE_SEL */
`define IMMED_8_SEL 1'b0
`define RM_SEL      1'b1

/* For SHIFTER_SEL */
`define ROTATE_IMM_SEL 2'b00
`define SHIFT_IMM_SEL  2'b01
`define RS_SEL         2'b10

/* For CPSR */
`define CPSR_N 31
`define CPSR_Z 30
`define CPSR_C 29
`define CPSR_V 28
