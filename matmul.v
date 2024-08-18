`default_nettype none

module matmul (
    input wire i_clk,
    input wire i_trigger,
    input wire [6:0] i_a [9],
    input wire [6:0] i_b [9],
    output wire o_ready,
    output reg [6:0] o_result [9]
);
    localparam
        READY        = 1'b0,
        PROCESSING   = 1'b1;

    reg state = READY;
    /* matrix [row][column] */
    reg [6:0] mat_a [9];
    reg [6:0] mat_b [9];
    reg [6:0] mat_res [9];

    integer row;
    integer col;

    assign o_ready = (state == READY);

    always @(posedge i_clk) begin

        if (i_trigger && state == READY) begin
            state <= PROCESSING;

            mat_a <= i_a;
            mat_b <= i_b;

        end else begin
            state <= READY;

            for (row = 0; row < 3; row = row + 1) begin
                for (col = 0; col < 3; col = col + 1) begin
                    mat_res[row*3 + col] <= mat_a[row*3 + 0] * mat_b[0*3 + col] +
                                            mat_a[row*3 + 1] * mat_b[1*3 + col] +
                                            mat_a[row*3 + 2] * mat_b[2*3 + col];
                end
            end

        end
    end

    always @ (i_clk) begin
        if (state == READY) begin
            o_result <= mat_res;
        end
    end
endmodule
