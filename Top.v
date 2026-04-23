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
    input RSTM,
    input CEM,
    input [47:0] PCIN,
    input [7:0] opcode,
    output [17:0] BCOUT,
    output [35:0] M,
    output [47:0] PCOUT,
    output [47:0] P
);

    parameter DREG = 1;
    parameter B0REG = 0;
    parameter B1REG = 1;
    parameter A0REG = 0;
    parameter A1REG = 1;
    parameter CREG = 1;
    parameter MREG = 1;
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


    // The First adder_subtractor
    wire [17:0] add_sub_nc_out;
    add_sub add_sub_nc (.in1(DREG_out), .in2(B0REG_out), .op(opcode[6]), .out(add_sub_nc_out));

    // After first add_sub MUX
    wire [17:0] af_as_mux;
    assign af_as_mux = (opcode[4])? add_sub_nc_out : B0REG_out;

    // B1 Reg
    wire [17:0] B1REG_out;
    GRMU #(.R_NO_R(B1REG)) B1R (.clk(clk), .rst(RSTB), .ce(CEB), .in(af_as_mux), .out(B1REG_out));

    // A1 Reg
    wire [17:0] A1REG_out;
    GRMU #(.R_NO_R(A1REG)) A1R (.clk(clk), .rst(RSTA), .ce(CEA), .in(A0REG_out), .out(A1REG_out)); 

    // BCOUT
    assign BCOUT = B1REG_out;


    // The Multiplier
    wire [35:0] mult_out;
    assign mult_out = B1REG_out * A1REG_out;

    // M REG
    wire [35:0] MREG_out;
    GRMU #(.WIDTH(36), .R_NO_R(MREG)) MR (.clk(clk), .rst(RSTM), .ce(CEM), .in(mult_out), .out(MREG_out));

    // The M output 
    assign M = MREG_out;

    // The MUX X 
    wire [47:0] mux_x_out;
    wire [47:0] P_internal;

    assign mux_x_out = (opcode[1:0] == 2'b00)? 48'b0:
                       (opcode[1:0] == 2'b01)? {12'b0, MREG_out}:
                       (opcode[1:0] == 2'b10)? P_internal:
                       (opcode[1:0] == 2'b11)? {DREG_out[11:0], A1REG_out, B1REG_out}:
                       48'b0;

    
    // The MUX Z
    wire [47:0] mux_z_out;

    assign mux_z_out = (opcode[3:2] == 2'b00)? 48'b0:
                       (opcode[3:2] == 2'b01)? PCIN:
                       (opcode[3:2] == 2'b10)? P_internal:
                       (opcode[3:2] == 2'b11)? CREG_out:
                       48'b0;


endmodule