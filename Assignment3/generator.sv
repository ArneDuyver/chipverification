`ifndef DEF_GEN
`define DEF_GEN
`include "transaction.sv"
`include "extra.h"

class generator;
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2che; 
  
  function new(mailbox #(transaction) g2d, mailbox #(transaction) g2e);
    this.gen2drv = g2d;
    this.gen2che = g2e;
  endfunction : new

  task run();
    transaction tra;
    // Test1
    for (int i=0; i<100*8; i++) begin
      tra = new();
      tra.test1.constraint_mode(1);
      tra.test2.constraint_mode(0);
      tra.test3.constraint_mode(0);
      tra.test4.constraint_mode(0);
      tra.test5.constraint_mode(0);
      void'(tra.randomize());
      updateOutcome(transaction tra);
      //$display("%s", tra.toString());
      this.gen2drv.put(tra);
      this.gen2che.put(tra);
    end 
    // Test2
    for (int i=0; i<100; i++) begin
      tra = new();
      tra.test1.constraint_mode(0);
      tra.test2.constraint_mode(1);
      tra.test3.constraint_mode(0);
      tra.test4.constraint_mode(0);
      tra.test5.constraint_mode(0);
      void'(tra.randomize());
      updateOutcome(tra);
      //$display("%s", tra.toString());
      this.gen2drv.put(tra);
      this.gen2che.put(tra);
    end
    // Test3
    for (int i=0; i<100; i++) begin
      tra = new();
      tra.test1.constraint_mode(0);
      tra.test2.constraint_mode(0);
      tra.test3.constraint_mode(1);
      tra.test4.constraint_mode(0);
      tra.test5.constraint_mode(0);
      void'(tra.randomize());
      updateOutcome(tra);
      //$display("%s", tra.toString());
      this.gen2drv.put(tra);
      this.gen2che.put(tra);
    end
    // Test4
    for (int i=0; i<100; i++) begin
      tra = new();
      tra.test1.constraint_mode(0);
      tra.test2.constraint_mode(0);
      tra.test3.constraint_mode(0);
      tra.test4.constraint_mode(1);
      tra.test5.constraint_mode(0);
      void'(tra.randomize());
      updateOutcome(tra);
      //$display("%s", tra.toString());
      this.gen2drv.put(tra);
      this.gen2che.put(tra);
    end
    // Test5
    for (int i=0; i<1000; i++) begin
      tra = new();
      tra.test1.constraint_mode(0);
      tra.test2.constraint_mode(0);
      tra.test3.constraint_mode(0);
      tra.test4.constraint_mode(0);
      tra.test5.constraint_mode(1);
      void'(tra.randomize());
      updateOutcome(tra);
      //$display("%s", tra.toString());
      this.gen2drv.put(tra);
      this.gen2che.put(tra);
    end


  endtask : run

  task updateOutcome(transaction tra);
    case(tra.operation)
      ADD : tra.updateOutcome_ADD;
      ADC : tra.updateOutcome_ADC;
      SUB : tra.updateOutcome_SUB;
      SUBC : tra.updateOutcome_SUBC;
      AND : tra.updateOutcome_AND;
      XOR : tra.updateOutcome_XOR;
      OR : tra.updateOutcome_OR;
      CMP : tra.updateOutcome_CMP;
      default : tra.updateOutcome_ADD;
    endcase //TODO: Why is this red??
  endtask : updateOutcome
  

endclass : generator
`endif