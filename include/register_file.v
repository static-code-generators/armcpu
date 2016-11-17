/* 
* A parameterized Register File; to be instantiated in the top level module
*/
module register_file
#(
    parameter WORD_SIZE = 32,
    parameter NUM_REGS = 16,
    parameter ADDR_WIDTH = 4
)
(
    // inputs
    input                    clk,
    input                    reset,
    // for registers
    input                    rd_we,
    input [WORD_SIZE - 1:0]  rd_in,
    input [ADDR_WIDTH - 1:0] write_rd, // size of reg address line is log_2(NUM_REGS)
    input [ADDR_WIDTH - 1:0] read_rn, read_rm, read_rs,
    // for cpsr and pc
    input [WORD_SIZE - 1:0]  pc_in, cpsr_in,
    input                    pc_we, cpsr_we,
    // outputs
    output [WORD_SIZE - 1:0]  rn_out, rm_out, rs_out,
    output [WORD_SIZE - 1:0]  pc_out, cpsr_out
);
    // declaring memory elements
    reg [WORD_SIZE - 1:0] registers[NUM_REGS - 1:0];
    reg [WORD_SIZE - 1:0] cpsr;

    // assigning outputs
    assign rn_out = registers[read_rn]; 
    assign rm_out = registers[read_rm];
    assign pc_out = registers[15];
    assign cpsr_out = cpsr;

    integer i;

    // Write operation is sequential (clocked at posedge)
    always @(posedge clk or posedge reset) begin // asynchronous reset
        if (reset) begin
            for (i = 0; i < NUM_REGS; i = i + 1)
                registers[i] <= 0;
            cpsr = 32'b0;
        end
        else begin 
            if (rd_we) begin
                registers[write_rd] <= rd_in;
            end
            if (pc_we) begin
                registers[15] <= pc_in;
            end
            if (cpsr_we) begin
                cpsr <= cpsr_in;
            end
        end
    end

endmodule
