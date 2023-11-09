`define NOP  2'b00
`define PUSH 2'b01 
`define POP  2'b10
`define GET  2'b11

module stack_behaviour_normal (
    inout wire[3:0] IO_DATA, 
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX
    );

    reg [3:0] stack[4:0];
    integer top_index;

    reg [3:0] io_data;
    assign IO_DATA = io_data;

    always @ (RESET)
    begin
        top_index = 0;
        for (integer i = 0; i < 5; i = i + 1) begin
            stack[i] = 4'b0;
        end
    end

    always @ (CLK, IO_DATA, INDEX, COMMAND)
    begin
        if (CLK) begin
            case (COMMAND)
                `PUSH: begin
                    stack[(top_index + 1) % 5] = IO_DATA;
                    top_index = (top_index + 1) % 5;
                end
                `POP: begin
                    io_data = stack[top_index];
                    top_index = (top_index + 4) % 5;
                end
                `GET: begin
                    io_data = stack[(top_index + 15 - INDEX) % 5];
                end
            endcase
        end
    end

    always @ (negedge CLK) io_data = 4'bZZZZ;
endmodule
