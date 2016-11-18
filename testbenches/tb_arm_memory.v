`define NULL 0
`define TEST_FILE_NAME "test/additest.x"

module tb_arm_memory;
    reg clk;
    reg [0:1] we;
    reg [0:1][31:0] addr;
    reg [0:1][31:0] data_in;

    wire [0:1] excpt;
    wire [0:1][31:0] data_out;

    integer data_file;
    integer scan_file;
    reg [31:0] captured_data;

    integer index;

    arm_memory uut(clk, addr, data_in, we, excpt, data_out);

    always #1 clk = ~clk;

    initial begin
        index = 0;
        clk = 0;
        we[0] = 0;
        we[1] = 0;
        data_in[0] = 0;
        addr[0] = 0;
        data_file = $fopen(`TEST_FILE_NAME, "r");
        if (data_file == `NULL) begin
            $display("bad bad | data file handle was NULL");
            $finish;
        end
    end

    initial begin
        $monitor("%d %x", addr[1], data_out[1]);
    end
    
    always @(negedge clk) begin
        scan_file = $fscanf(data_file, "%x\n", captured_data);
        if (!$feof(data_file)) begin
            $display("read from file: %x, trying to write to: %d",
                captured_data, index);
            we[0] = 0; //not ready to write yet.
            data_in[0] = captured_data;
            addr[0] = index;
            addr[1] = index; //this will probably lead to one ghost change.
            we[0] = 1; //cool we can write now.
            index = index + 1;
            #5;
        end
        else $finish;
    end

    //oddly, this never triggers.
    always @(data_out[1]) begin
        $display("index: %d, data: %x",
            addr[1], data_out[1]);
    end
endmodule
