module arm_memory
#(
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
    input [31:0] addr1,
    input [31:0] addr2,
    input [31:0] data_in1,
    input [31:0] data_in2,
    input write1,
    input write2,
    // Outputs
    output reg excpt,
    output reg [31:0] data_out1,
    output reg [31:0] data_out2
);
    // Memory regions
    reg [7:0] data_region[data_length:0];
    reg [7:0] text_region[text_length:0];

    wire [31:0] offset1, offset2;

    assign offset1 = CALC_OFFSET(addr1);
    assign offset2 = CALC_OFFSET(addr2);

    // Reading is asychronous
    always @(*) begin
        // Port 1
        if (!write1) begin
            if ((addr1 >= data_start) && (addr1 < data_top))
                data_out1 = (data_region[offset1 + 0] << 24) |
                            (data_region[offset1 + 1] << 16) |
                            (data_region[offset1 + 2] <<  8) |
                            (data_region[offset1 + 3] <<  0); 
            else if ((addr1 >= text_start) && (addr1 < text_top))
                data_out1 = (text_region[offset1 + 0] << 24) |
                            (text_region[offset1 + 1] << 16) |
                            (text_region[offset1 + 2] <<  8) |
                            (text_region[offset1 + 3] <<  0);
            else
                excpt = 1; // no region; we're daed
        end
        else
            data_out1 = 32'hxxxxxxxx;

        // Port 2
        if (!write2) begin
            if ((addr1 >= data_start) && (addr1 < data_top))
                data_out2 = (data_region[offset2 + 0] << 24) |
                            (data_region[offset2 + 1] << 16) |
                            (data_region[offset2 + 2] <<  8) |
                            (data_region[offset2 + 3] <<  0); 
            else if ((addr2 >= text_start) && (addr2 < text_top))
                data_out2 = (text_region[offset2 + 0] << 24) |
                            (text_region[offset2 + 1] << 16) |
                            (text_region[offset2 + 2] <<  8) |
                            (text_region[offset2 + 3] <<  0);
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
                data_region[offset1 + 0] = (data_in1 >> 24) & 8'hFF; 
                data_region[offset1 + 1] = (data_in1 >> 16) & 8'hFF; 
                data_region[offset1 + 2] = (data_in1 >>  8) & 8'hFF; 
                data_region[offset1 + 3] = (data_in1 >>  0) & 8'hFF; 
            end
            else if ((addr1 >= text_start) && (addr1 < text_top)) begin
                text_region[offset1 + 0] = (data_in1 >> 24) & 8'hFF; 
                text_region[offset1 + 1] = (data_in1 >> 16) & 8'hFF; 
                text_region[offset1 + 2] = (data_in1 >>  8) & 8'hFF; 
                text_region[offset1 + 3] = (data_in1 >>  0) & 8'hFF;
            end
            else
                excpt = 1;
        end
        else
            data_out1 = 32'hxxxxxxxx;

        // Port 2
        if (write2) begin
            if ((addr2 >= data_start) && (addr2 < data_top)) begin
                data_region[offset2 + 0] = (data_in2 >> 24) & 8'hFF; 
                data_region[offset2 + 1] = (data_in2 >> 16) & 8'hFF; 
                data_region[offset2 + 2] = (data_in2 >>  8) & 8'hFF; 
                data_region[offset2 + 3] = (data_in2 >>  0) & 8'hFF; 
            end
            else if ((addr2 >= text_start) && (addr2 < text_top)) begin
                text_region[offset2 + 0] = (data_in2 >> 24) & 8'hFF; 
                text_region[offset2 + 1] = (data_in2 >> 16) & 8'hFF; 
                text_region[offset2 + 2] = (data_in2 >>  8) & 8'hFF; 
                text_region[offset2 + 3] = (data_in2 >>  0) & 8'hFF;
            end
            else
                excpt = 1;
        end
        else
            data_out2 = 32'hxxxxxxxx;
    end

    function [31:0] CALC_OFFSET
    (
        input [29:0] addr
    );
        if ((addr >= data_start) && (addr < data_top))
            CALC_OFFSET = addr - data_start;
        else if ((addr >= text_start) && (addr < text_top))
            CALC_OFFSET = addr - text_start;
        else
            CALC_OFFSET = 32'bx;
    endfunction
endmodule
