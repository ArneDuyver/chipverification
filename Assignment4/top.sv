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
    option.at_least = 1;
    cover_point: coverpoint ifc.instruction
    //iff(ifc.valid) 
    {
      bins bin_only_a0 = { 160 };
    }
  endgroup

  cover_group cover_group_inst = new;

endmodule : top
`endif