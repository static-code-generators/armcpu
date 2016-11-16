module tb_arm_memory;
    reg clk, rst, write1, write2;
    reg [31:0] addr1;
    reg [31:0] addr2;
    reg [31:0] data_in1;
    reg [31:0] data_in2;

    wire excpt;
    wire [31:0] data_out1;
    wire [31:0] data_out2;

    arm_memory uut(clk, rst, addr1, addr2, data_in1, data_in2, write1, write2,
                   excpt, data_out1, data_out2);

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        write1 = 0;
        write2 = 0;
        data_in1 = 0;
        data_in2 = 0;
        $monitor("time %d, addr1: %x, data1: %x, data2: %x, excpt: %b, write1: %b",
            $time, addr1, data_out1, data_out2, excpt, write1);
        #5 
        addr1 = 32'h00000000;
        data_in1 = 1;
        write1 = 1;
        #5
        write1 = 0;  
        #5 
        addr1 = 32'h00000004;
        data_in1 = 25;
        write1 = 1;
        #5
        write1 = 0; 
        #5
        addr1 = 32'h00000000;
        #5
        $finish;
    end

endmodule
