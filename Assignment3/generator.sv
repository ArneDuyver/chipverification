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

  task runTest1();
    transaction tra;
    
    int id;
    id = 0;
    $display("[GEN] Starting Test 1");

    forever begin
      tra = new();
      tra.test1.constraint_mode(1);
      tra.test2.constraint_mode(0);
      tra.test3.constraint_mode(0);
      tra.test4.constraint_mode(0);
      tra.test5.constraint_mode(0);
      void'(tra.randomize());
      updateOutcome(tra);
      if (id == 0) $display("[GEN] tr%d: %s", id, tra.toString());
      this.gen2drv.put(tra);
      this.gen2che.put(tra);
      id = id + 1;
    end /* forever*/
  endtask : runTest1

  task updateOutcome(transaction tra);
    case(tra.operation)
      0 : tra.updateOutcome_ADD;
      1 : tra.updateOutcome_ADC;
      2 : tra.updateOutcome_SUB;
      3 : tra.updateOutcome_SUBC;
      4 : tra.updateOutcome_AND;
      5 : tra.updateOutcome_XOR;
      6 : tra.updateOutcome_OR;
      7 : tra.updateOutcome_CMP;
      default : tra.updateOutcome_ADD;
    endcase
  endtask : updateOutcome

endclass : generator
`endif