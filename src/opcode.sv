package opcode;
    typedef enum logic [6:0] {
        R_TYPE = 7'b0110011,
        I_TYPE_IMM = 7'b0010011,
        I_TYPE_LOAD = 7'b0000011,
        I_TYPE_JALR = 7'b1100111,
        S_TYPE = 7'b0100011,
        SB_TYPE = 7'b1100011,
        U_TYPE_LUI = 7'b0110111,
        U_TYPE_AUIPC = 7'b0010111,
        UJ_TYPE = 7'b1101111
    } opcode_t;
endpackage
