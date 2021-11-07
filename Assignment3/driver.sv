`ifndef DEF_DRV
`define DEF_DRV
`include "ALU_iface.sv"
`include "transaction.sv"

class driver;

  virtual ALU_iface ifc;
  mailbox #(transaction) gen2drv;

  function new(virtual ALU_iface ifc, mailbox #(transaction) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  task run();
    transaction tra;

    string s;
    $timeformat(-9,0," ns" , 10);
    s = $sformatf("[%t | DRV] I will start driving for addition", $time);
    //$display(s);
    
    forever begin 
      this.gen2drv.get(tra);
      //$display("[DRV] driving iface...");
      @(negedge this.ifc.clock);
      this.ifc.data_a <= tra.A;
      this.ifc.data_b <= tra.B;
      this.ifc.flags_in <= tra.flags_in;
      this.ifc.operation <= tra.operation;
    end /* forever */
    //This will never happen cause gets interrupted
    s = $sformatf("[%t | DRV] done", $time);
    $display(s);
         
  endtask : run

endclass : driver
`endif
