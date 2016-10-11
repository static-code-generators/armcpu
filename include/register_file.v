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
    input                    write_en,
    input [WORD_SIZE - 1:0]  write_data,
    input [ADDR_WIDTH - 1:0] write_reg, // size of reg address line is log_2(NUM_REGS)
    input [ADDR_WIDTH - 1:0] read_reg_1, read_reg_2,
    // outputs
    output [WORD_SIZE - 1:0]  out_data_1, out_data_2,
    output [WORD_SIZE - 1:0]  pc
);
    reg [WORD_SIZE - 1:0] registers[NUM_REGS - 1:0];
    integer i;

    // Read operation is combinatorial (runs asynchronously)
    // `registers[read_reg_1]` implicitly builds address decoder for
    // `read_reg_1`; synthesized logic is larger and slower than it needs to be.
    // TODO: Make explicit address decoder module for better speed and size.
    assign out_data_1 = registers[read_reg_1]; 
    assign out_data_2 = registers[read_reg_2];
    assign pc = registers[15];

    // Write operation is sequential (clocked at posedge)
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < NUM_REGS; i = i + 1)
                registers[i] <= 0;
        end
        else if (write_en) begin
            registers[write_reg] <= write_data;
        end
    end

endmodule
