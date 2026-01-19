`timescale 1ns / 1ps
import cpu_types::*;
import opcode::*;
import alu_encoding::*;
module alu_control(
    input ctrl_t ctrl,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic bit30,
    output logic [3:0] alu_ctrl
    );
    always_comb begin
        alu_ctrl = 4'b0;
        case (ctrl.aluop)
            2'b00: alu_ctrl = ALU_ADD;
            2'b01: alu_ctrl = ALU_SUB;
            2'b10: 
                case (opcode)
                    R_TYPE: begin 
                        case (funct3)
                            3'b0: alu_ctrl = bit30 ? ALU_SUB : ALU_ADD;
                            3'b101: alu_ctrl = bit30 ? ALU_SRA : ALU_SRL;
                            3'b111: alu_ctrl = ALU_AND;
                            3'b110: alu_ctrl = ALU_OR;
                            3'b100: alu_ctrl = ALU_XOR;
                            3'b010: alu_ctrl = ALU_SLT;
                            3'b001: alu_ctrl = ALU_SLL;
                        endcase
                    end
                    I_TYPE_IMM: begin
                        case(funct3)
                            3'b0: alu_ctrl = ALU_ADD;
                            3'b111: alu_ctrl = ALU_AND;
                            3'b110: alu_ctrl = ALU_OR;
                            3'b100: alu_ctrl = ALU_XOR;
                            3'b010: alu_ctrl = ALU_SLT;
                            3'b001: alu_ctrl = ALU_SLL;
                            3'b101: alu_ctrl = bit30 ? ALU_SRA : ALU_SRL;
                        endcase
                    end
                    U_TYPE_LUI: alu_ctrl = ALU_PASS_B;
                    default: alu_ctrl = ALU_ADD;
                endcase 
        endcase
    end
endmodule
