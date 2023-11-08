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
    reg [2:0] top_index;

    reg [3:0] io_data;
    assign IO_DATA = io_data;

    always @ (RESET)
    begin
        $display("RESET");
        top_index = 3'b000;
        for (integer i = 0; i < 5; i = i + 1) begin
            stack[i] = 4'b0000;
        end
    end

    always @ (CLK)
    begin
        case (COMMAND)
            `PUSH: begin
                    top_index <= (top_index + 1) % 5;
                    stack[top_index] <= IO_DATA;
            end
            `POP: begin
                io_data <= stack[top_index];
                top_index <= (top_index - 1 + 5) % 5;
            end
            `GET: io_data <= stack[top_index - INDEX];
            default: ;
        endcase
    end

    always @ (negedge CLK) 
    begin
        io_data <= 4'bZZZZ;
    end
endmodule
