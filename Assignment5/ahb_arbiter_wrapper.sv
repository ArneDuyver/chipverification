`timescale 1ns/1ns 

module ahb_arbiter_wrapper (
    input logic HCLK,
    input logic HRESETn,
    input logic [15:0] HBUSREQx,
    input logic [15:0] HLOCKx,
    output logic [15:0] HGRANTx,
    input logic [15:0] HSPLIT,
    input logic HREADY,
    output [3:0] HMASTER,
    output HMASTLOCK
    );

    ahb_arbiter ahb_arbiter_inst00 (
        HCLK, HRESETn, 
        HBUSREQx, HLOCKx, HGRANTx, HSPLIT,
        HREADY, HMASTER, HMASTLOCK
    );

    /* hic sunt dracones */    
    //-------------------------------------------------------------------------------
    //-- ASSERTIONS
    //-------------------------------------------------------------------------------
    
    //Task 1
    int grant_ones;
    always @(posedge HCLK)
    begin
        grant_ones = HGRANTx[0] + HGRANTx[1] + HGRANTx[2]+ HGRANTx[3]+ HGRANTx[4]+ HGRANTx[5]+ HGRANTx[6]+ HGRANTx[7]+ HGRANTx[8]+ HGRANTx[9]+ HGRANTx[10]+ HGRANTx[11]+ HGRANTx[12]+ HGRANTx[13]+ HGRANTx[14]+ HGRANTx[15];
    end
    
    always @(posedge HCLK)
    begin
        /* I assume that no more then 1 grant signal is active at a time */
        //max_one_grant: assert (~(grant_ones > 1)) $display("%m - number of grants: %b pass", grant_ones); else $info("%m - number of grants: %b  fail",grant_ones);
        max_one_grant: assert (~(grant_ones > 1)) $display("%m - number of grants: %b pass", grant_ones); else $info("%m - number of grants: %b  fail",grant_ones);
    end

    //Task 2
    for (genvar i = 0; i < 16; i++ ) grant_always_given : assert 
        property(@(posedge HCLK) 
            (HBUSREQx[i] |-> strong(##[0:$] HGRANTx[i])) 
        ) $display("%m pass"); else $info("No grant given IDnr: %d", i);
    //Task 3
    for (genvar i = 0; i < 16; i++ ) grant_low_after_ready : assert
        property(@(posedge HCLK) 
            ((HREADY & HGRANTx[i]) |-> ~HGRANTx[i]) 
        ) $display("%m pass"); else $info("No grant didn't return to low after ready: %d", i);
    

endmodule : ahb_arbiter_wrapper
