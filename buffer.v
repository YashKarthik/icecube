`default_nettype none

module buffer(
    input wire i_clk,
    input wire i_rst,
    input wire [7:0] i_data,
    output wire [7:0] o_mat [9],
    output wire o_recvd
);
    integer i;
    reg [3:0] w_addr;
    reg [7:0] memory [9];

    assign o_mat = memory;
    assign o_recvd = (w_addr == 9);

    always @ (posedge i_clk) begin
        if (i_rst) begin
            w_addr <= 0;
            for (i=0; i<10; i=i+1) memory[i] <= 0;
        end else if (i_data != memory[w_addr]) begin
            memory[w_addr + 1] <= i_data;
            w_addr <= w_addr + 1;
        end
    end

endmodule
