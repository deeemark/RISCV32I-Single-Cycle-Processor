`timescale 1ns / 1ps
import alu_encoding::*;
module ALU(
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic [3:0] alu_ctrl,
    output logic zero,
    output logic [31:0] alu_res
    );
    always_comb begin
        alu_res = 32'b0;
        unique case (alu_ctrl)
            ALU_ADD: alu_res = rs1 + rs2;
            ALU_SUB: alu_res = rs1 - rs2;
            ALU_AND: alu_res = rs1 & rs2;
            ALU_OR: alu_res = rs1 | rs2;
            ALU_XOR: alu_res = rs1 ^ rs2;
            ALU_SLT: alu_res = ($signed(rs1) < $signed(rs2)) ? 1 : 0;
            ALU_SLL: alu_res = rs1 << rs2[4:0];
            ALU_SRL: alu_res = rs1 >> rs2[4:0];
            ALU_SRA: alu_res = $signed(rs1) >>> rs2[4:0];
            ALU_PASS_B: alu_res = rs2;
        endcase
    end
    assign zero = (alu_res == '0);
endmodule
