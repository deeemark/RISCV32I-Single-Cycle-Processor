`timescale 1ns / 1ps

module instruction_memory #(
    parameter string INIT_FILE = "program1.hex"
    )(
    input logic [9:0] pc,
    output logic [31:0] instr
    );
    (* rom_style = "block" *) logic [31:0] mem [0:1023];
    initial begin
        $readmemh(INIT_FILE, mem);
    end
    assign instr = mem[pc];
endmodule

