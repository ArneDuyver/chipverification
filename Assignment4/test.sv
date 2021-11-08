`ifndef DEF_TEST
`define DEF_TEST
`include "ALU_iface.sv"
`include "environment.sv"

module test (ALU_iface ifc);
  environment env = new(ifc);

  initial
  begin
    env.rst_for_new_test();
    env.run(1, 8*100);
    env.rst_for_new_test();
    env.run(2, 100);
    env.rst_for_new_test();
    env.run(3, 100);
    env.rst_for_new_test();
    env.run(4, 100);
    env.rst_for_new_test();
    env.run(5, 1000);
    env.showReport();
  end

endmodule : test
`endif