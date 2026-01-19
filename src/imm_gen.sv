`timescale 1ns / 1ps
import opcode::*;
module imm_gen(
    input logic [31:0] instr,
    output logic [31:0]imm
    );
    logic [6:0] opcode;
    assign opcode = instr[6:0];
    always_comb begin
        unique case(opcode)
        //I-type instruction
            //Loads
            I_TYPE_LOAD: imm = {{20{instr[31]}},instr[31:20]};
            //Immediate operations
            I_TYPE_IMM: 
                unique case (instr[14:12])
                // shift left and right logic only use the first 4 bits of imm
                // and are 0 extended
                    3'b101: imm = {27'b0,
                                   instr[24:20]};
                    3'b001: imm = {27'b0,
                                   instr[24:20]};
                    default: imm = {{20{instr[31]}},
                                     instr[31:20]};
                endcase
             I_TYPE_JALR: imm = {{20{instr[31]}}, instr[31:20]};
         //S-type
             S_TYPE: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
         //SB-type
             SB_TYPE: imm = {{19{instr[31]}},
                               instr[31],
                               instr[7],
                               instr[30:25],
                               instr[11:8],
                               1'b0};
         //U-type
              U_TYPE_LUI: imm = {instr[31:12], 12'b0};
              U_TYPE_AUIPC: imm = {instr[31:12], 12'b0};
         //UJ-TYPE
              UJ_TYPE: imm = {{11{instr[31]}}, //JAL: very wacky ngl
                              instr[31],
                              instr[19:12],
                              instr[20],
                              instr[30:21],
                              1'b0}; 
              default: imm = 32'b0;
        endcase
    end
    
endmodule
