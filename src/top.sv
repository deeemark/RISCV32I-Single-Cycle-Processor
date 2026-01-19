`timescale 1ns / 1ps
import cpu_types::*;

module top(
    input logic clk, reset
);
    //========================================================
    //PC counter
    //========================================================
    //ctrl signals
    ctrl_t ctrl;
    logic [31:0] pc, pc_next;
    logic misaligned;
    logic mem_access;
    assign mem_access = ctrl.memread || ctrl.memwrite;
    always_ff @(posedge clk) begin
        if (reset)
            pc <= 32'h0000_0000;
        else if (mem_access && misaligned)
            pc <= pc; //stall 
        else
            pc <= pc_next;
    end
    //========================================================
    //Instruction memory
    //========================================================
    logic [31:0] instr;
    
    instruction_memory u_instruction_memory(
        .pc(pc[11:2]), //byte alligned to word alligned
        .instr(instr)
    );

    //instruction fields
    logic [6:0 ]opcode;
    logic [4:0] rs1, rs2, rd;
    logic [2:0] funct3;
    logic bit30;
    assign opcode = instr[6:0];
    assign rd = instr[11:7];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign funct3 = instr[14:12];
    assign bit30 = instr[30];
    
    
    
    //========================================================
    //Immediate gen
    //========================================================
    logic [31:0] imm;
    
    imm_gen u_imm_gen(
        .instr(instr),
        .imm(imm)
    );
    //========================================================
    //Register file
    //========================================================
    logic [31:0] wb_data, rs1_data, rs2_data;
    
    register_file u_register_file(
        .reset(reset),
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .regwrite(ctrl.regwrite),
        .rd_data(wb_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)   
    );
    //========================================================
    //Control unit
    //========================================================
    control_unit u_control_unit(
        .opcode(opcode),
        .funct3(funct3),
        .ctrl_out(ctrl)
    );
    //========================================================
    //ALU control unit
    //========================================================
    logic [3:0] alu_ctrl;
    alu_control u_alu_cntrl(
        .ctrl(ctrl),
        .opcode(opcode),
        .funct3(funct3),
        .bit30(bit30),
        .alu_ctrl(alu_ctrl)
    );
    //========================================================
    //ALU
    //========================================================
    logic [31:0] alu_res;
    logic zero;
    ALU u_ALU(
        .rs1(ctrl.alusrc_a ? pc : rs1_data),
        .rs2(ctrl.alusrc_b ? imm : rs2_data),
        .alu_ctrl(alu_ctrl),
        .zero(zero),
        .alu_res(alu_res)
    );
    //========================================================
    //Branch comparator
    //========================================================
    logic branch_taken;
    branch_comparator u_branch_comparator(
        .rs1(rs1_data),
        .rs2(rs2_data),
        .zero(zero),
        .funct3(funct3),
        .branch(ctrl.branch),
        .branch_taken(branch_taken)
    );
    pc_selector u_pc_selector(
        .imm(imm),
        .pc(pc),
        .rs1(rs1_data),
        .pc_src(ctrl.pc_src),
        .branch_taken(branch_taken),
        .pc_next(pc_next)
    );
    //========================================================
    //Data Memory
    //========================================================
    logic [31:0] rdata;
    data_memory u_data_memory(
        .reset(reset),
        .clk(clk),
        .addr(alu_res),
        .wdata(rs2_data),
        .memread(ctrl.memread),
        .memwrite(ctrl.memwrite),
        .mem_size(ctrl.memsize),
        .mem_signed(ctrl.mem_signed_load),
        .rdata(rdata),
        .misaligned(misaligned)
    );
    //========================================================
    //WB mux
    //========================================================
    always_comb begin
        wb_data = alu_res;
    unique case (ctrl.wb_sel)
        2'b01: wb_data = rdata;
        2'b10: wb_data = pc + 32'd4;
        default: ;
    endcase
    end
endmodule
