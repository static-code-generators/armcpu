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
		$finish;
	end

	initial begin
		$monitor("sel: %b, rotate_imm: %b, shift_imm: %b, rs: %b, shifter %b",
			sel, rotate_imm, shift_imm, rs, shifter);
	end

	shifter_mux smux(sel, rotate_imm, shift_imm, rs, shifter);
endmodule
