module GRMU (clk, rst, ce, in, out); // The Mux and Register Unit

    parameter R_NO_R = 1;
    parameter WIDTH = 18;
    parameter string RSTTYPE = "SYNC";

    input clk, rst, ce;
    input [WIDTH-1:0] in;
    output [WIDTH-1:0] out;

    reg [WIDTH-1:0] out_reg;


    generate
        
        if (RSTTYPE == "SYNC") begin

            always @(posedge clk) begin
                if (rst) begin
                    out_reg <= 0;
                end else if (ce) begin
                out_reg <= in;
                end
            end

        end else if (RSTTYPE == "ASYNC") begin

            always @(posedge clk or posedge rst) begin
                if (rst) begin
                    out_reg <= 0;
                end else if (ce) begin
                out_reg <= in;
                end
            end

        end

    endgenerate

    assign out = (R_NO_R)? out_reg : in;

endmodule