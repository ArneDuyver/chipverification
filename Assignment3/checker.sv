`ifndef DEF_CHE
`define DEF_CHE
`include "transaction.sv"
`include "transaction_mon.sv"

class checkers;

  mailbox #(transaction) gen2che;
  mailbox #(transaction_mon) mon2che;
  mailbox #(byte) che2scb;

  function new(mailbox #(transaction) g2c, mailbox #(transaction_mon) m2c, mailbox #(byte) c2s);
    this.gen2che = g2c;
    this.mon2che = m2c;
    this.che2scb = c2s;
  endfunction : new

  task run; 
    transaction_mon received_result;
    transaction expected_result;
    int index = 0;
    forever begin 
      this.mon2che.get(received_result);
      this.gen2che.get(expected_result);
      if (expected_result.Z == received_result.Z)
      begin
        if (expected_result.flags_out == received_result.flags_out)
        begin
          $display("[CHE] success test%d, expected: %s", index, expected_result.toString());
          $display("[CHE] success test%d, received: %s",index, received_result.toString());
          this.che2scb.put(byte'(1));
        end else begin
          $display("[CHE] failed test%d, expected: %s",index, expected_result.toString());
          $display("[CHE] failed test%d, received: %s",index, received_result.toString());
          this.che2scb.put(byte'(0));
        end
      end else begin
        $display("[CHE] failed test%d, expected: %s",index, expected_result.toString());
        $display("[CHE] failed test%d, received: %s",index, received_result.toString());
        this.che2scb.put(byte'(0));
      end
    end
    index = index + 1;
  endtask
  
endclass : checkers
`endif