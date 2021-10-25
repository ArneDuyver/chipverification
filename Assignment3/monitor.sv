`ifndef DEF_MON
`define DEF_MON
`include "ALU_iface.sv"
`include "transaction.sv"

class monitor;

  virtual ALU_iface ifc;
  mailbox #(transaction) mon2che;

  function new(virtual ALU_iface ifc, mailbox #(transaction) m2c);
    this.ifc = ifc;
    this.mon2che = m2c;
  endfunction : new

  task run();
    transaction tra;
    byte A, B, Z;
    bit [2:0] operation;
    bit [3:0] flags_in;
    bit [3:0] flags_out;
    
    forever begin
      @(negedge this.ifc.clock);
      
      A = this.ifc.data_a;
      B = this.ifc.data_b;
      Z = this.ifc.data_z;
      operation = this.ifc.operation;
      flags_in = this.ifc.flags_in;
      flags_out = this.ifc.flags_out;
      tra = new(A, B, flags_in, operation, Z, flags_out);
      
      this.mon2che.put(tra);
    end /* forever */
  endtask : run

endclass : monitor
`endif