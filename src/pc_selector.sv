`timescale 1ns / 1ps
module pc_selector(
    input  logic [31:0] imm,
    input  logic [31:0] pc,
    input  logic [31:0] rs1,
    input  logic [1:0]  pc_src,
    input logic branch_taken,
    output logic [31:0] pc_next
);
    always_comb begin
        unique case (pc_src)
            2'b00: pc_next = pc + 32'd4;  // normal
            2'b01: pc_next = branch_taken ? pc + imm : pc + 32'd4; // branch target
            2'b10: pc_next = pc + imm; // jal target
            2'b11: pc_next = (rs1 + imm) & 32'hFFFF_FFFE; // jalr target
            default: pc_next = pc + 32'd4;
        endcase
    end
endmodule