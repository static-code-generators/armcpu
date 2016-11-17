`define WORD_SIZE 32
`define NUM_REGS 16
`define ADDR_WIDTH 4

module tb_register_file;
    reg clk, reset;
    reg rd_we;
    reg [`WORD_SIZE - 1:0] rd_in;
    reg [`ADDR_WIDTH - 1:0] write_rd;
    reg [`ADDR_WIDTH - 1:0] read_rn, read_rm;
    reg [`WORD_SIZE - 1:0] pc_in, cpsr_in;
    reg pc_we, cpsr_we;

    wire [`WORD_SIZE - 1:0] rn_out, rm_out;
    wire [`WORD_SIZE - 1:0] pc_out, cpsr_out;
    integer i;

    reg ok = 1; //is it ok for rn_out to change.

    initial begin
        clk = 0;
        reset = 1;
        rd_we = 0;
        rd_in = 0;
        write_rd = 0;
        read_rn = 0;
        read_rm = 0;
        pc_in = 0;
        cpsr_in = 0;
        pc_we = 0;
        cpsr_we = 0;

        #2 reset = 0;
        #2 rd_we = 1;
        #2 rd_in = 42;

        for (i = 0; i < `NUM_REGS; i = i + 1) begin
            #5
            read_rn = i; //we aren't reading rm for now.
            write_rd = i;
        end

        #5;
        $display("all ok, I think");
        $finish;
    end

    always begin
        #1 clk = clk ^ 1;
    end

    always @(read_rn) begin
        ok = 1;
        #1 ok = 0;
    end

    always @(rn_out) begin
        if (ok) begin
            ok = 0;
        end
        else if (clk == 0) begin
            $display("bad bad | rn_out: %d, changed when clk: %b", rn_out, clk);
            $stop;
        end
    end

    initial begin
        $monitor("clk: %b, reset: %b, rd_we: %b, write_rd: %d, rd_in: %d, read_rn: %d, rn_out: %d",
            clk, reset, rd_we, write_rd, rd_in, read_rn, rn_out);
    end

    register_file reg_file(clk, reset, rd_we, rd_in, write_rd, read_rn, read_rm, pc_in, cpsr_in, pc_we, cpsr_we, rn_out, rm_out, pc_out, cpsr_out);
endmodule
