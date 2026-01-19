`timescale 1ns / 1ps
import cpu_types::*;
import opcode::*;
module control_unit(
    input logic [6:0] opcode,
    input logic [2:0] funct3, 
    output ctrl_t ctrl_out
    );
    ctrl_t ctrl;
    always_comb begin
    //defaults
        ctrl.regwrite = 1'b0;
        ctrl.memread = 1'b0;
        ctrl.memwrite = 1'b0;
        ctrl.memsize = 2'b10;
        ctrl.branch = 1'b0;
        ctrl.mem_signed_load =1'b1;
        ctrl.alusrc_a = 1'b0;
        ctrl.alusrc_b = 1'b0;
        ctrl.jump = 1'b0;
        ctrl.aluop = 2'b00;
        ctrl.wb_sel = 2'b00;
        ctrl.pc_src = 2'b00;
    
        case(opcode)
        // R type
        R_TYPE: begin // ADD, SUB, SLL, SOR, SRL, SRA, OR, AND, LR.D, SC.D
            ctrl.regwrite = 1'b1;
            ctrl.aluop = 2'b10;
        end
        // I type
        I_TYPE_IMM: begin // IMMEDIATES: ADDI, SLLI, XORI, SRLI, SRAI, ORI, ANDI
            ctrl.regwrite = 1'b1;
            ctrl.alusrc_b = 1'b1;
            ctrl.aluop = 2'b10;
        end
        I_TYPE_LOAD: begin // LOAD: LB, LH, LW, LBU, LHU
            ctrl.regwrite = 1'b1;
            ctrl.memread = 1'b1;
            ctrl.wb_sel = 2'b01;
            ctrl.alusrc_b = 1'b1;
            ctrl.aluop = 2'b00;
            case (funct3)
                3'b000: ctrl.memsize = 2'b00;
                3'b001: ctrl.memsize = 2'b01;
                3'b010: ctrl.memsize = 2'b10;
                3'b100: begin
                    ctrl.memsize = 2'b00;
                    ctrl.mem_signed_load = 1'b0;
                end
                3'b101: begin
                    ctrl.memsize = 2'b01;
                    ctrl.mem_signed_load = 1'b0;
                end
            endcase
        end
        I_TYPE_JALR: begin //JALR
            ctrl.regwrite = 1'b1;
            ctrl.alusrc_b = 1'b1;
            ctrl.jump = 1'b1;
            ctrl.aluop = 2'b00;
            ctrl.wb_sel = 2'b10;
            ctrl.pc_src = 2'b11;
        end
        //S- types
        S_TYPE: begin // STORES: SB, SH, SW
            ctrl.memwrite = 1'b1;
            ctrl.alusrc_b = 1'b1;
            ctrl.aluop = 2'b00;
            case (funct3)
                3'b000: ctrl.memsize = 2'b00;
                3'b001: ctrl.memsize = 2'b01;
                3'b010: ctrl.memsize = 2'b10;
            endcase
        end
        //SB-types
        SB_TYPE: begin //BRANCH: BEQ, BNE, BLT, BGE, BLTU, BGEU
            ctrl.branch = 1'b1;
            ctrl.aluop = 2'b01;
            ctrl.pc_src = 2'b01;
        end
        //U-types
        U_TYPE_LUI: begin //LUI
            ctrl.regwrite = 1'b1;
            ctrl.alusrc_b = 1'b1;
            ctrl.aluop = 2'b10;
        end
        U_TYPE_AUIPC: begin //AUIPC
            ctrl.regwrite = 1'b1;
            ctrl.alusrc_a = 1'b1;
            ctrl.alusrc_b = 1'b1;
            ctrl.aluop = 2'b00;
        end
        //UJ-types
        UJ_TYPE: begin //JAL
            ctrl.regwrite = 1'b1;
            ctrl.jump = 1'b1;
            ctrl.alusrc_a = 1'b1;
            ctrl.alusrc_b = 1'b1;
            ctrl.aluop = 2'b00;
            ctrl.wb_sel = 2'b10;
            ctrl.pc_src = 2'b10;
        end
        endcase
    end
    assign ctrl_out = ctrl;
endmodule
