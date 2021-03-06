`ifndef DEF_TEST
`define DEF_TEST
`include "GB_iface.sv"
`include "environment.sv"

module test (GB_iface ifc);
  environment env = new(ifc);

  initial
  begin
    env.rst_for_new_test();
    env.run();
    env.showReport();
    $stop;//$finish;
  end

endmodule : test
`endif