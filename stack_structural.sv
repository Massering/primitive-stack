
module stack_structural_easy(
    output wire[3:0] O_DATA, 
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND, 
    input wire[2:0] INDEX,
    input wire[3:0] I_DATA
    ); 
    
    // put your code here, the other module (stack_structural_normal) must be deleted

endmodule



module stack_structural_normal(
    inout wire[3:0] IO_DATA, 
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX
    ); 
    
    // put your code here, the other module (stack_structural_easy) must be deleted

endmodule
