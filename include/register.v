/*
* A plain old lonely register.
* Do we need it? We do not know.
*/
module register
#(
    parameter WIDTH = 32
)
(
    // inputs
    input                    clk, enable, rst,
    input      [WIDTH - 1:0] d, // Next value of register to be set at next positive clock edge
    // outputs
    output reg [WIDTH - 1:0] q // Current value of register
);
    // rst is active high
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 0;
        else if (enable) // Priority of rst > enable
            q <= d;
    end
endmodule
