`timescale 1ns / 1ps
package cpu_types;
    typedef struct packed {
        logic  branch;
        logic memread;
        logic memwrite;
        logic [1:0] memsize;
        logic mem_signed_load;
        logic [1:0] pc_src;
        logic alusrc_a;
        logic alusrc_b;
        logic regwrite;
        logic jump;
        logic [1:0] aluop;
        logic [1:0] wb_sel;
    } ctrl_t;
endpackage