`timescale 1ns / 1ps

module branch_comparator(
    input logic [31:0] rs1, rs2,
    input logic zero,
    input logic [2:0] funct3,
    input logic branch,
    output logic branch_taken
    );
    logic eq, lt, ltu;
    assign eq = zero;
    assign lt = ($signed(rs1) < $signed(rs2));
    assign ltu = (rs1 < rs2);
    always_comb begin
        branch_taken = 1'b0; // default
        if (branch) begin
            unique case (funct3)
                3'b000: branch_taken = eq; //BEQ
                3'b001: branch_taken = ~eq; //BNE
                3'b100: branch_taken = lt; //BLT
                3'b101: branch_taken = ~lt; //BGE
                3'b110: branch_taken = ltu; //BLTU
                3'b111: branch_taken = ~ltu; //BGEU    
                default: branch_taken = 1'b0; // illegal funct3
            endcase
        end
    end
endmodule
