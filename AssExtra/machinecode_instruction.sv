`ifndef DEF_MACHCODE
`define DEF_MACHCODE



class machinecode_instruction;
  rand byte instruction;

  constraint rand_ALU_instruction { 
    //Make the instruction an ALU instruction
    instruction[7:6] == 2'b10;
    //Choose the ALU opcode between valid values. From 0 to and with 7 are valid opcodes for the ALU
    instruction[5:3] inside {[3'b000 : 3'b111]};
    //Choose the operand between valid values (5:0). For all other values 2nd operand is regA so maybe add 6 for that case
    instruction[2:0] inside {[3'b000 : 3'b110]};
  }
  
  constraint test_instruction { 
    //Make the instruction an ALU instruction
    instruction[7:0] == 8'h83;
  }

  function new(byte given_instruction);
    this.instruction = given_instruction;
  endfunction : new

endclass : machinecode_instruction
`endif