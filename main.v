`default_nettype none

module main (
    input wire clk,
    input wire RX,
    input wire[3:0] SW, // SW[0] is global reset
    output wire TX,
    output wire LED_R,
    output wire LED_G,
    output wire LED_B
);

    wire baud_clk;
    wire mat_ready;
    wire [7:0] mat_tx;
    wire tx_ready;
    wire LED_R_inv;
    wire LED_G_inv;
    wire LED_B_inv;
    wire [7:0] mat_in [9];
    wire [7:0] mat_out [9];
    wire [7:0] mat_cells;

    reg state = 0;
    reg trigger = 0;
    reg [7:0] mat_a [9];
    reg [7:0] mat_b [9];

    assign LED_B = ~LED_B_inv;
    assign LED_R = ~LED_R_inv;
    assign LED_G = ~LED_G_inv;

    clock baud(
        .i_clk(clk),
        .i_rst(~SW[0]),
        .o_clk(baud_clk)
    );

    receiver uart_rx(
        .i_clk(clk),
        .i_rx(RX),
        .i_rst(~SW[0]),
        .o_data(mat_cells),
        .ready(LED_B_inv)
    );

    buffer mat_buff(
        .i_clk(clk),
        .i_rst(~SW[0]),
        .i_data(mat_cells),
        .o_mat(mat_in),
        .o_recvd(LED_G_inv)
    );

    matmul multiplier(
        .i_clk(clk),
        .i_trigger(trigger),
        .i_a(mat_a),
        .i_b(mat_b),
        .o_ready(mat_ready),
        .o_result(mat_out)
    );

    tx_buffer tx_buff (
        .i_clk(clk),
        .i_rst(~SW[0]),
        .i_next(LED_R),
        .i_mat(mat_out),
        .o_data(mat_tx),
        .o_ready(tx_ready)
    );

    transmitter uart_tx(
        .i_clk(baud_clk),
        .i_tx_start(tx_ready),
        .busy(LED_R_inv),
        .i_data(mat_tx),
        .o_data(TX)
    );


    always @ (posedge clk) begin
        if (~LED_G) begin
            if (state == 0) begin
                mat_a <= mat_in;
                state <= 1;
                trigger <= 0;
            end else begin
                mat_b <= mat_in;
                state <= 0;
                trigger <= 1;
            end
        end
    end

endmodule
