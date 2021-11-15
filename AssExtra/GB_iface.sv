`ifndef DEF_IFC_GB
`define DEF_IFC_GB
  interface GB_iface ( input logic clock );
    logic reset;
    //logic clock; //Is this extra clock signal needed? I dont think so since you can address the clock anyway
    logic [7:0] instruction;
    logic valid;
    logic [15:0] probe;
  endinterface
`endif