module DSP_tb();
    
    reg clk;
    reg [17:0] D, B, A, BCIN;
    reg  RSTD, RSTB, RSTA, RSTC, RSTM, RSTP;
    reg CED, CEB, CEA, CEC, CEM, CEP;
    reg  CARRYIN, CECARRYIN, RSTCARRYIN;
    reg [47:0] C, PCIN;
    reg [7:0] opcode;

    wire CARRYOUT, CARRYOUTF;
    wire [17:0] BCOUT;
    wire [35:0] M;
    wire [47:0] PCOUT, P;

    integer error_count = 0, correct_count = 0;

    Top DUT (
        .clk(clk),
        .D(D),
        .B(B),
        .A(A),
        .BCOUT(BCOUT),
        .BCIN(BCIN),
        .RSTD(RSTD),
        .RSTB(RSTB),
        .RSTA(RSTA),
        .RSTC(RSTC),
        .RSTM(RSTM),
        .RSTP(RSTP),
        .CED(CED),
        .CEB(CEB),
        .CEA(CEA),
        .CEC(CEC),
        .CEM(CEM),
        .CEP(CEP),
        .CARRYIN(CARRYIN),
        .CECARRYIN(CECARRYIN),
        .RSTCARRYIN(RSTCARRYIN),
        .CARRYOUT(CARRYOUT),
        .CARRYOUTF(CARRYOUTF),
        .C(C),
        .P(P),
        .PCIN(PCIN),
        .PCOUT(PCOUT),
        .opcode(opcode),
        .M(M)
    );


    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end


    initial begin
        
        // The rst phase 2.1
        RSTD = 1; RSTB = 1; RSTA = 1; RSTC = 1; RSTM = 1; RSTP = 1; RSTCARRYIN = 1;

        D = $random; B = $random; A = $random; BCIN = $random;
        CED = $random; CEB = $random; CEA = $random; CEC = $random; CEM = $random; CEP = $random;
        CARRYIN = $random; CECARRYIN = $random;
        C = $random; PCIN = $random;
        opcode = $random;

        @(negedge clk);

        if (CARRYOUT == 0 && CARRYOUTF == 0 && BCOUT == 0 && M == 0 && PCOUT == 0 && P == 0) begin
            $display("Reset Phase PASSED !");
            correct_count = correct_count + 1;
        end else begin
            $display("Reset Phase FAILED !!!: CARRYOUT=%b, CARRYOUTF=%b, BCOUT=%b, M=%b, PCOUT=%b, P=%b", CARRYOUT, CARRYOUTF, BCOUT, M, PCOUT, P);
            error_count = error_count + 1;
        end

        RSTD = 0; RSTB = 0; RSTA = 0; RSTC = 0; RSTM = 0; RSTP = 0; RSTCARRYIN = 0;
        CED = 1; CEB = 1; CEA = 1; CEC = 1; CEM = 1; CEP = 1;


        // Path 1 (2.2)
        opcode = 8'b11011101;
        A = 20;
        B = 10;
        C = 350;
        D = 25;

        BCIN = $random;
        PCIN = $random;
        CARRYIN = $random;

        repeat(4) @(negedge clk);

        if (BCOUT == 18'hf && M == 36'h12c && P == 48'h32 && PCOUT == 48'h32 && CARRYOUT == 0 && CARRYOUTF == 0) begin
            $display("PATH 1 Passed !");
            correct_count = correct_count + 1;
        end else begin
            $display("PATH 1 FAIELD !!!: BCOUT=%h, M=%h, P=%h, PCOUT=%h, CARRYOUT=%h, CARRYOUTF=%h", BCOUT, M, P, PCOUT, CARRYOUT, CARRYOUTF);
            error_count = error_count + 1;
        end


        $stop;

    end



endmodule