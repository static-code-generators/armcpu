`define NB_REGIONS     2
`define MEM_DATA       0
`define MEM_TEXT       1
`define MEM_DATA_START 32'h10000000
`define MEM_DATA_SIZE  32'h00000100 // 256 bytes, 64 words
`define MEM_DATA_TOP   `MEM_DATA_START + `MEM_DATA_SIZE
`define MEM_TEXT_START 32'h00000000
`define MEM_TEXT_SIZE  32'h00000100
`define MEM_TEXT_TOP   `MEM_TEXT_START + `MEM_TEXT_SIZE

module arm_memory
(
    input             clk,
    input      [31:0] addr1,
    input      [31:0] addr2,
    input      [31:0] data_in1,
    input      [31:0] data_in2,
    input      [0:1]  we,           // write enable
    output reg [0:1]  excpt,        // exception bit
    output     [31:0] data_out1,
    output     [31:0] data_out2
);
    // used for implementing dual ports using for loop
    wire [31:0] addr[0:1];
    wire [31:0] data_in[0:1];
    reg [31:0] data_out[0:1];
    integer i;

    assign addr[0] = addr1;
    assign addr[1] = addr2;
    assign data_in[0] = data_in1;
    assign data_in[1] = data_in2;
    assign data_out1 = data_out[0];
    assign data_out2 = data_out[1];


    /*always @ (data_in[1]) begin
        $display("mem1: data_in %x", data_in[1]);
    end

    always @ (we[1]) begin
        $display("we: %x", we[1]);
    end

    always @ (data_in[0]) begin
        $display("mem0: data_in %x", data_in[0]);
    end

    [>always @ (data_out[0]) begin
        $display("mem0: data_out %x", data_out[0]);
    end<]
    always @ (data_out[1]) begin
        $display("mem1: data_out %x", data_out[1]);
    end*/

    // internal registers used for decoding
    reg region_sel [0:1];
    reg [31:0] offset [0:1];

    // Memory regions
    reg [7:0] data_region[0 : `MEM_DATA_SIZE - 1];
    reg [7:0] text_region[0 : `MEM_TEXT_SIZE - 1];

    // Combinatorial reads and address decoding
    always @ (*) begin
        for (i = 0; i < 2; i = i + 1) begin
            ADDR_DECODE(offset[i], region_sel[i], excpt[i], addr[i]);
            if (!excpt[i]) begin
                if (region_sel[i] == `MEM_DATA) begin
                    data_out[i] = (data_region[offset[i] + 0] << 24) |
                                  (data_region[offset[i] + 1] << 16) |
                                  (data_region[offset[i] + 2] <<  8) |
                                  (data_region[offset[i] + 3] <<  0); 
                end
                else begin
                    data_out[i] = (text_region[offset[i] + 0] << 24) |
                                  (text_region[offset[i] + 1] << 16) |
                                  (text_region[offset[i] + 2] <<  8) |
                                  (text_region[offset[i] + 3] <<  0); 
                end
            end
            else
                data_out[i] = 32'bx;
        end
    end

    // Sequential writes
    always @ (posedge clk) begin
        for (i = 0; i < 2; i = i + 1) begin
            if (we[i] && !excpt[i]) begin
            //$display("mem%b: offset %x, region %x excpt %x addr %x we %x", i[0], offset[i], region_sel[i], excpt[i], addr[i], we[i]);
                if (region_sel[i] == `MEM_DATA) begin
                    data_region[offset[i] + 0] <= (data_in[i] >> 24) & 8'hFF; 
                    data_region[offset[i] + 1] <= (data_in[i] >> 16) & 8'hFF; 
                    data_region[offset[i] + 2] <= (data_in[i] >>  8) & 8'hFF; 
                    data_region[offset[i] + 3] <= (data_in[i] >>  0) & 8'hFF; 
                end
                else begin
                    text_region[offset[i] + 0] <= (data_in[i] >> 24) & 8'hFF; 
                    text_region[offset[i] + 1] <= (data_in[i] >> 16) & 8'hFF; 
                    text_region[offset[i] + 2] <= (data_in[i] >>  8) & 8'hFF; 
                    text_region[offset[i] + 3] <= (data_in[i] >>  0) & 8'hFF; 
                end
            end
        end
    end

    // Address decoder
    task ADDR_DECODE
    (
        output reg [31:0] offset,
        output reg region_sel,
        output reg excpt, 
        input [31:0] addr
    );
        if ((addr >= `MEM_DATA_START) && (addr < `MEM_DATA_TOP)) begin
            offset     = addr - `MEM_DATA_START;
            region_sel = `MEM_DATA;
            excpt      = 0;
        end
        else if ((addr >= `MEM_TEXT_START) && (addr < `MEM_TEXT_TOP)) begin
            offset     = addr - `MEM_TEXT_START;
            region_sel = `MEM_TEXT;
            excpt      = 0;
        end
        else begin
            offset     = 32'bx;
            region_sel = 2'bx;
            excpt      = 1;
        end
    endtask
endmodule
