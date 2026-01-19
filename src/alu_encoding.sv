`timescale 1ns / 1ps
package alu_encoding;
    typedef enum logic [3:0] {
        ALU_ADD = 4'b0000,
        ALU_SUB = 4'b0001,
        ALU_AND = 4'b0010,
        ALU_OR = 4'b0011,
        ALU_XOR = 4'b0100,
        ALU_SLT = 4'b0101,
        ALU_SLL = 4'b0110,
        ALU_SRL = 4'b0111,
        ALU_SRA = 4'b1000,
        ALU_PASS_B = 4'b1001
    } alu_encoding_t;
endpackage