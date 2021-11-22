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
  covergroup cg1 @(posedge clock);
    c1: coverpoint ifc.instruction{
      bins only_200_255 = { [200:$] };
    }
  endgroup

  cg1 cg1_inst = new;

endmodule : top
`endif