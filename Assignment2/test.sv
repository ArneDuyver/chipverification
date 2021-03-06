`ifndef DEF_TEST
`define DEF_TEST
`include "ALU_iface.sv"
`include "environment.sv"

module test (ALU_iface ifc);
  environment env = new(ifc);

  initial
  begin
    env.run();
  end

endmodule : test
`endif