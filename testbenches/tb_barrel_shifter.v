module tb_barrel_shifter;

    reg c_flag;
    reg [3:0] barrel_sel;
    reg [31:0] shiftee, shifter;

    wire [31:0] shifter_operand, shifter_carry_out;

    barrel_shifter bs
    (
        .c_flag(c_flag),
        .barrel_sel(barrel_sel),
        .shiftee(shiftee),
        .shifter(shifter),
        .shifter_operand(shifter_operand),
        .shifter_carry_out(shifter_carry_out)
    );

    initial begin
        $monitor("c_flag: %b, barrel_sel: %b, shiftee: %x, shifter: %x, shifter_operand: %x, shifter_carry_out: %x",
            c_flag, barrel_sel, shiftee, shifter, shifter_operand, shifter_carry_out);
    end

    initial begin
        c_flag = 0;
        shiftee = 63;
        shifter = 14;
        #2 barrel_sel = `IMMED;
        #2 barrel_sel = `LSLIMM;
        #2 barrel_sel = `LSRIMM;
        #2 barrel_sel = `ASRIMM;
        #2 barrel_sel = `RORIMM;
        #2 $finish;
    end

endmodule
