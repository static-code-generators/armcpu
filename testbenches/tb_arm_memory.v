`define NULL 0
`define TEST_FILE_NAME "test/additest.x"

module tb_arm_memory;
    reg clk;
    reg [0:1] we;
    reg [31:0] addr[0:1];
    reg [31:0] data_in[0:1];

    wire [0:1] excpt;
    wire [31:0] data_out[0:1];

    integer data_file;
    integer scan_file;
    reg [31:0] captured_data;

    integer index;

    arm_memory uut(clk, addr[0], addr[1], data_in[0], data_in[1], we, excpt, data_out[0], data_out[1]);

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

    always @(negedge clk) begin
        scan_file = $fscanf(data_file, "%x\n", captured_data);
        if (!$feof(data_file)) begin
            $display("read from file: %x, trying to write to: %d",
                captured_data, index);
            we[1] = 0; //not ready to write yet.
            data_in[1] = captured_data;
            addr[1] = index;
            //addr[1] = index; //this will probably lead to one ghost change.
            we[1] = 1; //cool we can write now.
            index = index + 4;
        end
        else $finish;
    end

    always @(data_out[1]) begin
        $display("index: %d, data: %x",
            addr[1], data_out[1]);
    end
endmodule
