module add_sub (in1, in2, op, out, cin, carry);
    
    parameter WIDTH = 18;
    parameter CRY = 0;

    input [WIDTH-1:0] in1, in2;
    input op;
    input cin;

    output [WIDTH-1:0] out;
    output carry;

    generate
        
        if (!CRY) begin

            assign out = (op == 0)? (in1 + in2) : (in1 - in2);
            assign carry = 0;            

        end else begin
            
            wire [WIDTH:0] out_wcry;

            assign out_wcry = (op == 0)? ({1'b0, in1} + {1'b0, in2} + cin) : ({1'b0, in1} - ({1'b0, in2} + cin));

            assign carry = out_wcry[WIDTH];
            assign out = out_wcry[WIDTH-1:0];

        end

    endgenerate


endmodule