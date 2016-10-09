/*
* A plain old lonely register.
* Do we need it? We do not know.
*/
module register
(
    parameter WIDTH = 32;
)
(
    output reg [WIDTH - 1:0] q; // Current value of register
    input      [WIDTH - 1:0] d; // Next value of register to be changed at next positive clock egde
    input                    clk, enable, rst;
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            q <= 0;
        else if (enable) // Priority of rst > enable
            q <= d;
    end
endmodule
