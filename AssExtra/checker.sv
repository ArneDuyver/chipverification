`ifndef DEF_CHE
`define DEF_CHE
`include "machinecode_instruction.sv"
`include "transaction_mon.sv"
`include "gbModel.sv"

class checkers;

  mailbox #(machinecode_instruction) gen2che;
  mailbox #(transaction_mon) mon2che;
  mailbox #(byte) che2scb;
  gameboyprocessor gb_model;

  function new(mailbox #(machinecode_instruction) g2c, mailbox #(transaction_mon) m2c, mailbox #(byte) c2s, gameboyprocessor model);
    this.gen2che = g2c;
    this.mon2che = m2c;
    this.che2scb = c2s;
    this.gb_model = model;
    
  endfunction : new

  task run; 
    transaction_mon received_result;
    machinecode_instruction instr;
    
    forever begin 
      this.mon2che.get(received_result);
      this.gen2che.get(instr);
      //Steekproeven om de correctheid van de testen aan te tonen
      
      gb_model.executeALUInstruction(instr.instruction);
      $display("[CHE] Instruction was %h", instr.instruction);
      if (gb_model.A == received_result.regA)
      begin
        if (gb_model.F == received_result.flags)
        begin
          //$display("[CHE] succesful test, expected: regA %h, flags %h ",gb_model.A, gb_model.F);
          //$display("[CHE] succesful test, received: regA %h, flags %h ",received_result.regA, received_result.flags);
          this.che2scb.put(byte'(1));
        end else begin
          $display("[CHE] failed test, expected: regA %h, flags %h ",gb_model.A, gb_model.F);
          $display("[CHE] failed test, received: regA %h, flags %h ",received_result.regA, received_result.flags);
          this.che2scb.put(byte'(0));
        end
      end else begin
        $display("[CHE] failed test, expected: regA %h, flags %h ",gb_model.A, gb_model.F);
        $display("[CHE] failed test, received: regA %h, flags %h ",received_result.regA, received_result.flags);
        this.che2scb.put(byte'(0));
      end
    end
  endtask
  
endclass : checkers
`endif