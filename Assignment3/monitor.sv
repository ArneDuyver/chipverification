`ifndef DEF_MON
`define DEF_MON
`include "ALU_iface.sv"
`include "transaction.sv"
`include "transaction_mon.sv"

class monitor;

  virtual ALU_iface ifc;
  mailbox #(transaction_mon) mon2che;

  function new(virtual ALU_iface ifc, mailbox #(transaction_mon) m2c);
    this.ifc = ifc;
    this.mon2che = m2c;
  endfunction : new

  task run();
    transaction_mon tra;
    byte A, B, Z;
    bit [2:0] operation;
    bit [3:0] flags_in;
    bit [3:0] flags_out;
    int id;
    id = 0;
    forever begin
      @(negedge this.ifc.clock);
      
      A = this.ifc.data_a;
      B = this.ifc.data_b;
      Z = this.ifc.data_z;
      operation = this.ifc.operation;
      flags_in = this.ifc.flags_in;
      flags_out = this.ifc.flags_out;
      tra = new(A, B, flags_in, operation, Z, flags_out);
      //if (id >= 0) $display("[MON] tr_mon%d: %s", id, tra.toString());

      if (check_valid(A,B,flags_in,operation) != 0) begin
        this.mon2che.put(tra);
      end

      id = id + 1;
    end /* forever */
  endtask : run

  function check_valid(byte A,byte B,bit [3:0] flags_in,bit [2:0] operation);
    return A || B || flags_in || operation;
  endfunction : check_valid

endclass : monitor
`endif