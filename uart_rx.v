module uart_rx(
    input clk,
    input reset,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done
);

reg [1:0] state;
reg [2:0] bit_index;

parameter IDLE  = 2'b00,
          START = 2'b01,
          DATA  = 2'b10,
          STOP  = 2'b11;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state <= IDLE;
        rx_data <= 8'b0;
        rx_done <= 0;
        bit_index <= 0;
    end

    else
    begin
        rx_done <= 0;

        case(state)

            IDLE:
            begin
                if(rx == 0)
                    state <= START;
            end

            START:
            begin
                bit_index <= 0;
                state <= DATA;
            end

            DATA:
            begin
                rx_data[bit_index] <= rx;

                if(bit_index == 3'd7)
                    state <= STOP;
                else
                    bit_index <= bit_index + 1;
            end

            STOP:
            begin
                if(rx == 1)
                    rx_done <= 1;

                state <= IDLE;
            end

        endcase
    end
end

endmodule