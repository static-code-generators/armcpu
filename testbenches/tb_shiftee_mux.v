module tb_shiftee_mux;
    reg [1:0] sel;
    reg [7:0] immed_8;
    reg [31:0] immed_32;
    reg [31:0] rm;
    wire [31:0] shiftee;

    integer i;

    initial begin
        sel = 0;
        immed_8  = 0;
        rm = 0;

        #5;

        for (i = 0; i < (1 << 8); i = i + 1) begin
            #1 immed_8 = i;
        end

        #5;
        sel = 1;

        for (i = 0; i < 32; i = i + 1) begin
            #1 rm = rm | (1 << i);
        end

        #5;
        $display("all ok");
        $finish;
    end

    always @(shiftee) begin
        case (sel)
            2'b00: begin
                if (shiftee != {{24{immed_8[7]}}, immed_8}) begin
                    $display("bad bad | sel: %b, immed_8: %b, shiftee: %b",
                        sel, immed_8, shiftee);
                    $stop;
                end
            end
            2'b01: begin
                if (shiftee != rm) begin
                    $display("bad bad | sel: %b, rm: %d, shiftee %d",
                        sel, rm, shiftee);
                    $stop;
                end
            end
        endcase
    end

    shiftee_mux smux(sel, immed_8, immed_32, rm, shiftee);
endmodule
