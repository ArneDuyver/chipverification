`ifndef DEF_DRV
`define DEF_DRV
`include "GB_iface.sv"
`include "machinecode_instruction.sv"

class driver;

  virtual GB_iface ifc;
  mailbox #(machinecode_instruction) gen2drv;

  function new(virtual GB_iface ifc, mailbox #(machinecode_instruction) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  task run();
    machinecode_instruction instr;

    forever begin 
      this.gen2drv.get(instr);
      @(posedge this.ifc.clock);
      //this.ifc.reset <= 0; //Is this neccessary? I dont think so
      this.ifc.valid <= 1;
      @(negedge this.ifc.clock);
      this.ifc.instruction <= instr.instruction;
    end /* forever */        
  endtask : run

  task rst_iface();
    @(posedge this.ifc.clock);
    this.ifc.valid <= 0;
    @(negedge this.ifc.clock);
    this.ifc.reset <= 1;
    repeat (2) @(posedge this.ifc.clock);
    this.ifc.reset <= 0;
    //Possibly add some clock cycles while doing nothing if nesseccary
  endtask : rst_iface

endclass : driver
`endif
