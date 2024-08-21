`default_nettype none

module tx_buffer (
    input wire i_clk,
    input wire i_rst,
    input wire i_next,
    input wire [7:0] i_mat [9],
    output wire [7:0] o_data,
    output wire o_ready
);
    reg [3:0] r_addr;
    reg ready;

    assign o_ready = ready;
    assign o_data = i_rst ? 0 : i_mat[r_addr];

    always @(posedge i_clk) begin
        if (i_rst) begin
            r_addr <= 0;
            ready <= 0;
        end else if (i_next && r_addr < 10) begin
            r_addr <= r_addr + 1;
            ready <= 1;
        end else begin
            ready <= 0;
        end
    end
endmodule

