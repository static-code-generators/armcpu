`define S_BIT 20

`define L_BIT 20
`define W_BIT 21
`define B_BIT 22
`define U_BIT 23
`define P_BIT 24
`define I_BIT 25

`define EQ 0000
`define NE 0001
`define CS 0010
`define CC 0011
`define MI 0100
`define PL 0101
`define VS 0110
`define VC 0111
`define HI 1000
`define LS 1001
`define GE 1010
`define LT 1011
`define GT 1100
`define LE 1101
`define AL 1110

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
`define LSLIMM 4'0000
`define LSLREG 4'0001
`define LSRIMM 4'0010
`define LSRREG 4'0011
`define ASRIMM 4'0100
`define ASRREG 4'0101
`define RORIMM 4'0110
`define RORREG 4'0111
