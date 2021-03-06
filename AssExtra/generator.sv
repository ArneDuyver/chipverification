`ifndef DEF_GEN
`define DEF_GEN
`include "machinecode_instruction.sv"

class generator;
  mailbox #(machinecode_instruction) gen2drv;
  mailbox #(machinecode_instruction) gen2che; 
  
  function new(mailbox #(machinecode_instruction) g2d, mailbox #(machinecode_instruction) g2e);
    this.gen2drv = g2d;
    this.gen2che = g2e;
  endfunction : new

  task run();
    machinecode_instruction instr;
    //$display("[GEN] Starting ...");

    forever begin
      instr = new(8'b0); //Send a non valid ALU instruction if no randomization is enabled
      instr.rand_ALU_instruction.constraint_mode(1);
      instr.test_instruction.constraint_mode(0);
      void'(instr.randomize());
      this.gen2drv.put(instr);
      this.gen2che.put(instr);
    end /* forever*/
  endtask : run

endclass : generator
`endif