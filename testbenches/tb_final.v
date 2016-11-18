`define NULL 0
`define TEST_FILE_NAME "test/additest.x"

module tb_final;

    reg        clk;
    wire [1:0] we;
    wire [1:0] excpt;

    assign we[0] = 1'b0;
    assign we[1] = mem_write_en;

    arm_memory memauri
    (
        // Inputs
        .clk(clk),
        .addr1(inst_addr),
        .addr2(mem_addr),
        .data_in1(),
        .data_in2(mem_data_in),
        .we(we),
        .excpt(excpt),
        // Outputs
        .data_out1(inst),
        .data_out2(mem_data_out)
    );

    arm_core core
    (
        // Inputs
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .mem_data_out(mem_data_out),
        // Outputs
        .halted(halted),
        .mem_addr(mem_addr),
        .inst_addr(inst_addr),
        .mem_data_in(mem_data_in)
        .mem_write_en(mem_write_en)
    );

endmodule
