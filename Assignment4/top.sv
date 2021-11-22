`ifndef DEF_TOP
`define DEF_TOP

`include "GB_iface.sv"
`include "test.sv"

module top; 
  
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  GB_iface ifc (
    .clock(clock)
  );

  // instantiate the DUT and connect it to the interface
  gbprocessor dut (
    .reset(ifc.reset),
    .clock(ifc.clock),
    .instruction(ifc.instruction),
    .valid(ifc.valid),
    .probe(ifc.probe) 
  );

  // SV testing 
  test tst(ifc);


  //Covergroups
  covergroup cover_group @(posedge clock);
    option.at_least = 100;
    cover_point_instruction: 
      coverpoint ifc.instruction[5:3]
      iff(ifc.valid) 
      {
        bins bin_ADC = { 1 };
        bins bin_SBC = { 3 };
        bins bin_CP = { 7 };
      }
    cover_point_carryFlag:
      coverpoint ifc.probe[0]
      iff(ifc.valid) 
      {
        bins bin_carry_flag = { 1 };
      }

  endgroup

  cover_group cover_group_inst = new;

endmodule : top
`endif