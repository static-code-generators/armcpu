/* 
* A parameterized Register File; to be instantiated in the top level file
*/
module register_file
#(
    parameter WORD_SIZE = 32;
    parameter NUM_REGS = 16;
    parameter ADDR_WIDTH = 4;
)
(
    input clk,
    input reset,
    input write_data,
    input [ADDR_WIDTH - 1:0] write_reg, // size of reg address line is log_2(NUM_REGS)
    input [ADDR_WIDTH - 1:0] read_reg_1, read_reg_2,
    output reg [WORD_SIZE - 1:0] out_data_1, out_data_2
);
    reg [WORD_SIZE - 1:0] registers[NUM_REGS:0];
    integer i;

    // Read operation is combinatorial (runs asynchronously)
    always_comb begin
        // `registers[read_reg_1]` implicitly builds address decoder for
        // `read_reg_1`; synthesized logic is larger and slower than it needs to be.
        // TODO: Make explicit address decoder module for better speed and size.
        out_data_1 = registers[read_reg_1]; 
        out_data_2 = registers[read_reg_2];
    end

    // Write operation is sequential (clocked at posedge)
    always_ff @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < NUM_REGS; i = i + 1)
                registers[i] <= 0;
        end
        else
            registers[write_reg] <= write_data;
    end

endmodule

/*
* A plain old lonely register.
*/
module register
(
    output reg [31:0] q; // Current value of register
    input      [31:0] d; // Next value of register to be changed at next positive clock egde
    input             clk, enable, rst_b;
    // NB: The reset signal is active low, enable is active high
);
    always_ff @(posedge clk or negedge rst_b) begin
        if (~rst_b)
            q <= 0;
        else if (enable)
            q <= d;
    end
endmodule
