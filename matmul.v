`default_nettype none

module matmul (
    input wire i_clk,
    input wire i_trigger,
    input wire [6:0] i_a [3][3],
    input wire [6:0] i_b [3][3],
    output wire o_ready,
    output reg [6:0] o_result [3][3]
);
    localparam
        READY        = 1'b0,
        PROCESSING   = 1'b1;

    reg state = READY;
    /* matrix [row][column] */
    reg [6:0] mat_a [3][3];
    reg [6:0] mat_b [3][3];
    reg [6:0] mat_res [3][3];

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
                    mat_res[row][col] <= mat_a[row][0] * mat_b[0][col] +
                                            mat_a[row][1] * mat_b[1][col] +
                                            mat_a[row][2] * mat_b[2][col];
                end
            end

        end
    end

    always @ (i_clk) begin
        if (state == READY) begin
            o_result <= mat_res;
        end else begin
            o_result[0] <= '{7'b0, 7'b0, 7'b0};
            o_result[1] <= '{7'b0, 7'b0, 7'b0};
            o_result[2] <= '{7'b0, 7'b0, 7'b0};
        end
    end
endmodule
