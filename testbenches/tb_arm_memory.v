module tb_arm_memory;
    reg clk;
    reg [0:1] we;
    reg [0:1][31:0] addr;
    reg [0:1][31:0] data_in;

    wire [0:1] excpt;
    wire [0:1][31:0] data_out;

    arm_memory uut(clk, addr, data_in, we, excpt, data_out);

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        we[0] = 0;
        we[1] = 0;
        data_in[0] = 0;
        data_in[1] = 0;
        $monitor("time %d, addr: %x, data: %x, excpt: %b, we: %b",
            $time, addr[0], data_out[0], excpt[0], we[0]);
        #5 
        // Write to memory
        addr[0] = 32'h00000000;
        data_in[0] = 1;
        we[0] = 1;
        #5
        // Read from memory
        we[0] = 0;
        #5 
        // Write to memory
        addr[0] = 32'h00000010;
        data_in[0] = 32'h1f1e003b;
        we[0] = 1;
        #5
        // Read from memory address 0x10
        we[0] = 0;
        #5
        // Read from memory address 0x00
        addr[0] = 32'h00000000;
        #5
        $finish;
    end

endmodule
