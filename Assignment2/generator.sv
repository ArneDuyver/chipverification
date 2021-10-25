`ifndef DEF_GEN
`define DEF_GEN
`include "transaction.sv"

class generator;
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2che; 
  
  function new(mailbox #(transaction) g2d, mailbox #(transaction) g2e);
    this.gen2drv = g2d;
    this.gen2che = g2e;
  endfunction : new

  task run();
    transaction tra;

    forever begin
      tra = this.generateTransaction();
      //$display("%s", tra.toString());
      this.gen2drv.put(tra);
      this.gen2che.put(tra);
    end /*end forever*/    
  endtask : run

  function transaction generateTransaction;
    byte A, B, Z;
    bit [2:0] operation;
    bit [3:0] flags_in;
    bit [3:0] flags_out;

    transaction tra;

    /* for now only generate addition w.o. carry */
    A = 20;
    B = 30;
    Z = (A + B) % 256;
    operation = 3'b0;
    flags_in = 4'b0;
    flags_out = 4'b0010; 

    tra = new(A, B, flags_in, operation, Z, flags_out);

    return tra;
  endfunction : generateTransaction

endclass : generator
`endif