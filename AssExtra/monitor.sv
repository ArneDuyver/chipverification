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
    byte regA, flags;
    bit prev_valid;
    prev_valid = 0;

    forever begin
      @(negedge this.ifc.clock);
      if (prev_valid) begin
        regA = this.ifc.probe[15:8];
        flags = this.ifc.probe[7:0];
        trans_mon = new(regA, flags);
        this.mon2che.put(trans_mon);
      end
      prev_valid = this.ifc.valid;
    end /* forever */

  endtask : run

endclass : monitor
`endif