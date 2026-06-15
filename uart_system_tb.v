module testbench;

reg clk;
reg reset;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_done;

wire [7:0] rx_data;
wire rx_done;

uart_tx transmitter(
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_done(tx_done)
);

uart_rx receiver(
    .clk(clk),
    .reset(reset),
    .rx(tx),          // Connect TX output directly to RX input
    .rx_data(rx_data),
    .rx_done(rx_done)
);

always #5 clk = ~clk;

initial
begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);

    clk = 0;
    reset = 1;
    tx_start = 0;
    tx_data = 8'b10101010;

    #10 reset = 0;

    #10;
    tx_start = 1;

    #10;
    tx_start = 0;

    #200;

    $finish;
end

endmodule