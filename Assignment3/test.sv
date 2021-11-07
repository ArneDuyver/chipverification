`ifndef DEF_TEST
`define DEF_TEST
`include "ALU_iface.sv"
`include "environment.sv"

module test (ALU_iface ifc);
  environment env = new(ifc);

  initial
  begin
    //Test1
    env.run(1,10); //1,100*8
    //Test1 again
    env.run(1,5);
    $finish;
  end

endmodule : test
`endif