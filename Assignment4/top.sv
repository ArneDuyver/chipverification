`ifndef DEF_TOP
`define DEF_TOP

`include "ALU_iface.sv"
`include "test.sv"

module top;
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  ALU_iface theInterface (
    .clock(clock)
  );

  // instantiate the DUT and connect it to the interface
  ALU dut (
    .A(theInterface.data_a),
    .B(theInterface.data_b),
    .flags_in(theInterface.flags_in),
    .Z(theInterface.data_z),
    .flags_out(theInterface.flags_out),
    .operation(theInterface.operation)
  );

  // SV testing 
  test tst(theInterface);

endmodule : top
`endif