`timescale 1ns / 1ps

module register_file(
    input logic reset,
    input logic clk,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic regwrite,
    input logic [31:0] rd_data,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
    );
    logic [31:0] regs [31:0];
    integer i;
    assign rs1_data = (rs1 == 0) ? 32'b0 : regs[rs1];
    assign rs2_data = (rs2 == 0) ? 32'b0 : regs[rs2];
    always_ff @(posedge clk) begin
        if (reset) begin
                for (i = 0; i < 32; i++)
                    regs[i] <= 'b0;
        end
        else if (rd != 0 && regwrite) begin
            regs[rd] <= rd_data;
        end
    end
endmodule
