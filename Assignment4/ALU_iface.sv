`ifndef DEF_IFC
`define DEF_IFC
interface ALU_iface ( input logic clock );
  logic [7:0] data_a;
  logic [7:0] data_b;
  logic [2:0] operation;
  logic [3:0] flags_in;
  logic [7:0] data_z;
  logic [3:0] flags_out;
endinterface
`endif