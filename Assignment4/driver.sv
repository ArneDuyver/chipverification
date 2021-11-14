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
      @(negedge this.ifc.clock);
      this.ifc.reset <= 0; //QUESTION: Is this neccessary?
      this.ifc.valid <= 1;
      this.ifc.instruction <= instr.instruction;
    end /* forever */        
  endtask : run

  task rst_iface();
    @(negedge this.ifc.clock);
    this.ifc.reset <= 1;
    this.ifc.valid <= 0;
    repeat (2) @(posedge this.ifc.clock);
    this.ifc.reset <= 0;
    this.ifc.valid <= 0;
  endtask : rst_iface

endclass : driver
`endif
