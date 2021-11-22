`ifndef DEF_MON
`define DEF_MON
`include "GB_iface.sv"
`include "transaction_mon.sv"

class monitor;

  virtual GB_iface ifc;
  mailbox #(transaction_mon) mon2che;

  function new(virtual GB_iface ifc, mailbox #(transaction_mon) m2c);
    this.ifc = ifc;
    this.mon2che = m2c;
  endfunction : new

  task run();
    transaction_mon trans_mon;
    byte regA, flags,regA_prev,flags_prev;
    bit prev_valid,valid;
    prev_valid = 0;
    regA = 0;
    flags = 0;

    forever begin
      @(posedge this.ifc.clock);
      regA_prev = regA;
      flags_prev = flags;
      prev_valid = valid;
      regA = this.ifc.probe[15:8];
      flags = this.ifc.probe[7:0];
      valid = this.ifc.valid
      
      if (prev_valid) begin
        trans_mon = new(regA_prev, flags_prev);
        this.mon2che.put(trans_mon);
      end
    end /* forever */

  endtask : run

endclass : monitor
`endif