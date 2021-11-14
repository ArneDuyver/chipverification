`ifndef DEF_ENV
`define DEF_ENV

`include "machinecode_instruction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checker.sv"
`include "scoreboard.sv"
`include "GB_iface.sv"

class environment;

  mailbox #(machinecode_instruction) gen2drv;
  mailbox #(machinecode_instruction) gen2che;
  mailbox #(machinecode_instruction) mon2che;
  mailbox #(byte) che2scb;

  virtual GB_iface ifc;

  generator gen;
  driver drv;
  monitor mon;
  checkers check;
  scoreboard scb;

  function new(virtual GB_iface ifc);
    this.ifc = ifc;
    this.gen2drv = new(5);
    this.gen2che = new(5);
    this.mon2che = new(5);
    this.che2scb = new(5);

    this.gen = new(this.gen2drv, this.gen2che);
    this.drv = new(ifc, this.gen2drv);
    this.mon = new(ifc, this.mon2che);

    this.check = new(this.gen2che,this.mon2che,this.che2scb);
    this.scb = new(this.che2scb);

  endfunction : new

  task rst_for_new_test();
    begin 
      machinecode_instruction instr;
      byte b;
      this.drv.rst_iface();
      while (this.gen2drv.try_get(instr));
      while (this.gen2che.try_get(instr));
      while (this.mon2che.try_get(instr));
      while (this.che2scb.try_get(b));
    end
  endtask : rst_for_new_test

  //TODO: 3
  task run(int nrOfTests);
    fork
      begin  
        fork 
          this.check.run();
          this.mon.run();
          this.drv.run(); 
          this.gen.run();
        join_none;
        //wait for some time
        repeat (10) @(posedge this.ifc.clock);
        fork
          this.scb.run(nrOfTests);
        join_any
        //wait
        repeat (10) @(posedge this.ifc.clock);
        //terminate threads
        disable fork;
      end;
    join;
  endtask : run

  task showReport();
    this.scb.showReport();
  endtask : showReport

endclass : environment
`endif