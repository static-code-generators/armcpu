module arm_memory
(
    parameter NOF_BYTES = 2048,
    // Text segment
    parameter data_start = 32'h00000000,
    parameter data_words = 32'h00000100, // 256
    parameter data_length = data_words * 4,
    parameter data_top = data_start + data_length,

    // Data segment
    parameter text_start = 32'h00100000,
    parameter text_words = 32'h00000100, // 256
    parameter text_length = text_words * 4,
    parameter text_top = text_start + text_length
)
(
    // Inputs
    input clk, rst,
    // Two-port memory
    input [29:0] addr1,
    input [29:0] addr2,
    input [31:0] data_in1,
    input [32:0] data_in2,
    input write1,
    input write2,
    // Outputs
    output excpt,
    output [31:0] data_out1,
    output [31:0] data_out2
);
    // Memory regions
    reg [7:0] data_region[data_length:0];
    reg [7:0] text_region[text_length:0];

    wire [31:0] offset_data;
    wire [31:0] offset_text;

    assign offset_data = 

    // Reading is asychronous
    always @(*) begin
        // Port 1
        if (!write1) begin
            if ((addr1 >= data_start) && (addr1 < data_top))
                data_out1 = (data_region[offset + 0] << 24) |
                            (data_region[offset + 1] << 16) |
                            (data_region[offset + 2] <<  8) |
                            (data_region[offset + 3] <<  0); 
            else if ((addr1 >= text_start) && (addr1 < text_top))
                data_out1 = (text_region[offset + 0] << 24) |
                            (text_region[offset + 1] << 16) |
                            (text_region[offset + 2] <<  8) |
                            (text_region[offset + 3] <<  0);
            else
                excpt = 1; // no region; we're daed
        end
        else
            data_out1 = 32'hxxxxxxxx;

        // Port 2
        if (!write2) begin
            if ((addr1 >= data_start) && (addr1 < data_top))
                data_out2 = (data_region[offset + 0] << 24) |
                            (data_region[offset + 1] << 16) |
                            (data_region[offset + 2] <<  8) |
                            (data_region[offset + 3] <<  0); 
            else if ((addr2 >= text_start) && (addr2 < text_top))
                data_out2 = (text_region[offset + 0] << 24) |
                            (text_region[offset + 1] << 16) |
                            (text_region[offset + 2] <<  8) |
                            (text_region[offset + 3] <<  0);
            else
                excpt = 1;
        end
        else
            data_out2 = 32'hxxxxxxxx;
    end

    // Writing is clocked at posedge
    always @(posedge clk) begin
        // Port 1
        if (write1) begin
            if ((addr1 >= data_start) && (addr1 < data_top)) begin
                data_region[offset + 0] = (data_in1 >> 24) & 0xFF; 
                data_region[offset + 1] = (data_in1 >> 16) & 0xFF; 
                data_region[offset + 2] = (data_in1 >>  8) & 0xFF; 
                data_region[offset + 3] = (data_in1 >>  0) & 0xFF; 
            end
            else if ((addr1 >= text_start) && (addr1 < text_top))
                text_region[offset + 0] = (data_in1 >> 24) & 0xFF; 
                text_region[offset + 1] = (data_in1 >> 16) & 0xFF; 
                text_region[offset + 2] = (data_in1 >>  8) & 0xFF; 
                text_region[offset + 3] = (data_in1 >>  0) & 0xFF;
            else
                excpt = 1;
        end
        else
            data_out1 = 32'hxxxxxxxx;

        // Port 2
        if (write2) begin
            if ((addr2 >= data_start) && (addr2 < data_top)) begin
                data_region[offset + 0] = (data_in2 >> 24) & 0xFF; 
                data_region[offset + 1] = (data_in2 >> 16) & 0xFF; 
                data_region[offset + 2] = (data_in2 >>  8) & 0xFF; 
                data_region[offset + 3] = (data_in2 >>  0) & 0xFF; 
            end
            else if ((addr2 >= text_start) && (addr2 < text_top))
                text_region[offset + 0] = (data_in2 >> 24) & 0xFF; 
                text_region[offset + 1] = (data_in2 >> 16) & 0xFF; 
                text_region[offset + 2] = (data_in2 >>  8) & 0xFF; 
                text_region[offset + 3] = (data_in2 >>  0) & 0xFF;
            else
                excpt = 1;
        end
        else
            data_out2 = 32'hxxxxxxxx;
    end
