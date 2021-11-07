`ifndef DEF_TEST
`define DEF_TEST
`include "ALU_iface.sv"
`include "environment.sv"

module test (ALU_iface ifc);
  environment env = new(ifc);

  initial
  begin
    //Test1
    env.run(1,8*100);
    //Test2
    env.run(2,100);
    //Test3
    env.run(3,100);
    //Test4
    env.run(4,100);
    //Test5
    env.run(5,1000);
    $finish;
  end

endmodule : test
`endif