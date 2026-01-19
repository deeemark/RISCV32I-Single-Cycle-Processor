`timescale 1ns / 1ps

module data_memory(
    input logic reset,
    input logic clk,
    input logic [31:0] addr, wdata,
    input logic memread,
    input logic memwrite,
    input logic [1:0] mem_size,
    input logic mem_signed,
    output logic [31:0] rdata,
    output logic misaligned
    );
    //misalignment detection
    always_comb begin
        misaligned = 1'b0;
        if (memread || memwrite) begin
            unique case (mem_size)
                2'b00: misaligned = 1'b0;                 // byte always aligned
                2'b01: misaligned = addr[0];              // halfword needs addr[0]==0
                2'b10: misaligned = |addr[1:0];           // word needs addr[1:0]==00
                default: misaligned = 1'b0;
            endcase
        end
    end
    logic [31:0] dmem [0:1023];
    logic [1:0] byte_offset; 
    logic [$clog2(1024)-1:0] word_index;
    assign word_index = addr[$clog2(1024)+1:2]; 
    assign byte_offset = addr[1:0];
    //load logic
    logic [7:0] byte_val;
    logic [15:0] half_val;
    logic [31:0] word;
    assign word = dmem[word_index];
    always_comb begin
          byte_val = 8'b0;
          half_val = 16'b0;
        
          if (memread || memwrite) begin
            unique case (mem_size)
              2'b00: unique case (byte_offset)
                2'b00: byte_val = word[7:0];
                2'b01: byte_val = word[15:8];
                2'b10: byte_val = word[23:16];
                2'b11: byte_val = word[31:24];
              endcase
        
              2'b01: begin
                if (byte_offset[1]) half_val = word[31:16];
                else                half_val = word[15:0];
              end
        
              default: ; // word or invalid
            endcase
          end
        end
    //store logic
    logic [31:0] new_word;
    always_comb begin
          new_word = word;
        
          if (memwrite) begin
            unique case (mem_size)
              2'b00: unique case (byte_offset)
                2'b00: new_word = {word[31:8],  wdata[7:0]};
                2'b01: new_word = {word[31:16], wdata[7:0], word[7:0]};
                2'b10: new_word = {word[31:24], wdata[7:0], word[15:0]};
                2'b11: new_word = {wdata[7:0],  word[23:0]};
              endcase
        
              2'b01: begin
                if (byte_offset[1]) new_word = {wdata[15:0], word[15:0]};
                else                new_word = {word[31:16], wdata[15:0]};
              end
        
              2'b10: new_word = wdata;
        
              default: ; // do nothing
            endcase
          end
        end
   always_ff @(posedge clk) begin
        if (reset) begin
            integer k;
            for (k = 0; k < 1024; k++) begin
                dmem[k] <= 32'h0000_0000;
            end
        end
        else if (memwrite && !misaligned) begin
            dmem[word_index] <= new_word;
        end
    end
    always_comb begin
        rdata = 32'b0;
        if (memread) begin
            if (misaligned) begin
                rdata = 32'b0;
            end
            else begin
                if (mem_size == 2'b00 && mem_signed) 
                    rdata = {{24{byte_val[7]}}, byte_val};
                else if (mem_size == 2'b00 && ~mem_signed)
                    rdata = {24'b0 , byte_val};
                else if (mem_size == 2'b01 && mem_signed)
                    rdata = {{16{half_val[15]}}, half_val};
                else if (mem_size == 2'b01 && ~mem_signed)
                    rdata = {16'b0, half_val};
                else
                    rdata = word;
            end
        end
    end
endmodule

