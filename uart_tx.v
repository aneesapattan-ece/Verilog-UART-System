module uart_tx(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_done
);

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] data_reg;

parameter IDLE  = 2'b00,
          START = 2'b01,
          DATA  = 2'b10,
          STOP  = 2'b11;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state <= IDLE;
        tx <= 1'b1;
        tx_done <= 0;
        bit_index <= 0;
        data_reg <= 0;
    end

    else
    begin
        tx_done <= 0;

        case(state)

            IDLE:
            begin
                tx <= 1'b1;

                if(tx_start)
                begin
                    data_reg <= tx_data;
                    bit_index <= 0;
                    state <= START;
                end
            end

            START:
            begin
                tx <= 1'b0;
                state <= DATA;
            end

            DATA:
            begin
                tx <= data_reg[bit_index];

                if(bit_index == 3'd7)
                    state <= STOP;
                else
                    bit_index <= bit_index + 1;
            end

            STOP:
            begin
                tx <= 1'b1;
                tx_done <= 1'b1;
                state <= IDLE;
            end

        endcase
    end
end

endmodule