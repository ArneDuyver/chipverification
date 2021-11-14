`ifndef DEF_MON
`define DEF_MON
`include "GB_iface.sv"
`include "machinecode_instruction.sv"

class monitor;

  virtual GB_iface ifc;
  mailbox #(machinecode_instruction) mon2che;

  function new(virtual GB_iface ifc, mailbox #(machinecode_instruction) m2c); //TODO: 1 make a new class for monitor to send value regA and flags in regF
    this.ifc = ifc;
    this.mon2che = m2c;
  endfunction : new

  task run();
    machinecode_instruction instr; //TODO: change to THINGY
    byte regA, instruction;
    bit [3:0] flags;
    bit prev_valid;

    forever begin
      @(negedge this.ifc.clock);
      
      regA = this.ifc.probe[15:8];
      flasg = this.ifc.probe[7:4];
      instruction = this.ifc.instruction; //not really neccessary to send to checker I think.
      tra = new(A, B, flags_in, operation, Z, flags_out);//TODO: change to make a THINGY

      if (this.ifc.valid && prev_valid) begin
        this.mon2che.put(THINGY); //TODO: fix THINGY
      end

      prev_valid = this.ifc.valid;

    end /* forever */
  endtask : run

endclass : monitor
`endif