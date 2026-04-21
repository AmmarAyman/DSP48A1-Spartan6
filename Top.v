module Top (
    input clk, 
    input [17:0] D,
    input RSTD,
    input CED,
    input [17:0] B, 
    input [17:0] BCIN,
    input RSTB,
    input CEB,
    input [17:0] A,
    input RSTA,
    input CEA,
    input [47:0] C,
    input CEC,
    input RSTC,
    input [7:0] opcode,
    output [47:0] P
);

    parameter DREG = 1;
    parameter B0REG = 0;
    parameter A0REG = 0;
    parameter CREG = 1;
    parameter B_INPUT = "DIRECT";

    // The First Colum of the Design

    // The D Reg
    wire [17:0] DREG_out;
    GRMU #(.R_NO_R(DREG)) DR (.clk(clk), .rst(RSTD), .ce(CED), .in(D), .out(DREG_out));


    // The B0 Reg
    wire [17:0] B0_in;

    assign B0_in = (B_INPUT == "DIRECT")? B:
                   (B_INPUT == "CASCADE")? BCIN:
                    18'b0;

    wire [17:0] B0REG_out;
    GRMU #(.R_NO_R(B0REG)) B0R (.clk(clk), .rst(RSTB), .ce(CEB), .in(B0_in), .out(B0REG_out)); 


    // The A0 Reg
    wire [17:0] A0REG_out;
    GRMU #(.R_NO_R(A0REG)) A0R (.clk(clk), .rst(RSTA), .ce(CEA), .in(A), .out(A0REG_out));


    // The C Reg
    wire [47:0] CREG_out;
    GRMU #(.WIDTH(48), .R_NO_R(CREG)) CR (.clk(clk), .rst(RSTC), .ce(CEC), .in(C), .out(CREG_out));


endmodule