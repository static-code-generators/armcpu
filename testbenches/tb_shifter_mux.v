module tb_shifter_mux;
    reg[1:0] sel;
    reg[3:0] rotate_imm;
    reg[4:0] shift_imm;
    reg[31:0] rs;
    wire[31:0] shifter;

    integer i;

    initial begin
        sel = 0;
        rotate_imm = 0;
        shift_imm = 0;
        rs = 0;

        #5;

        for (i = 0; i < (1 << 4); i = i + 1) begin
            #1 rotate_imm = i;
        end

        #5;
        sel = 1;

        for (i = 0; i < (1 << 5); i = i + 1) begin
            #1 shift_imm = i;
        end

        #5;
        sel = 2;

        for (i = 0; i < 32; i = i + 1) begin
            #1 rs = rs | (1 << i);
        end

        #5;
        $display("all ok");
        $finish;
    end

    always @ (shifter) begin
        case (sel)
            2'b00: begin
                if (shifter != {{28{rotate_imm[3]}}, rotate_imm}) begin
                    $display("bad bad | sel: %b, rotate_imm: %b, shifter: %b",
                        sel, rotate_imm, shifter);
                    $stop;
                end
            end
            2'b01: begin
                if (shifter != {{27{shift_imm[4]}}, shift_imm}) begin
                    $display("bad bad | sel: %b, shift_imm: %b, shifter: %b",
                        sel, shift_imm, shifter);
                    $stop;
                end
            end
            2'b10: begin
                if (shifter != rs) begin
                    $display("bad bad | sel: %b, rs: %d, shifter: %d",
                        sel, rs, shifter);
                    $stop;
                end
            end
        endcase
    end

    shifter_mux smux(sel, rotate_imm, shift_imm, rs, shifter);
endmodule
