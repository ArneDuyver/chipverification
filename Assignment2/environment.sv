`ifndef DEF_ENV
`define DEF_ENV

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checker.sv"
`include "scoreboard.sv"

class environment;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2che;
  mailbox #(transaction) mon2che;
  mailbox #(byte) che2scb;

  virtual ALU_iface ifc;

  generator gen;
  driver drv;
  monitor mon;
  checkers check;
  scoreboard scb;

  function new(virtual ALU_iface ifc);
    this.ifc = ifc;
    this.gen2drv = new(100);
    this.gen2che = new(100);
    this.mon2che = new(100);
    this.che2scb = new(100);

    this.gen = new(this.gen2drv, this.gen2che);
    this.drv = new(ifc, this.gen2drv);
    this.mon = new(ifc, this.mon2che);

    this.check = new(this.gen2che,this.mon2che,this.che2scb);
    this.scb = new(this.che2scb);

  endfunction : new

  task run();
    fork
      begin      
        fork 
          check.run();
          mon.run(); 
          drv.run(); 
          gen.run();
        join_none;
        //wait for ome time
        repeat (10) @(posedge this.ifc.clock);
        //start the downstream
        fork
          //start generating
          this.scb.run(100);
        join_any
        //wait
        repeat (10) @(posedge this.ifc.clock);
        //terminalte threads
        disable fork;
      end;
    join;

    this.scb.showReport();

  endtask : run

endclass : environment
`endif