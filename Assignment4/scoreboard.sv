`ifndef DEF_SCB
`define DEF_SCB
class scoreboard;

  mailbox #(byte) che2scb;

  int no_tests_done;
  int no_tests_ok;
  int no_tests_nok;

  function new(mailbox c2s);
    this.che2scb = c2s;
    no_tests_done = 0;
    no_tests_ok = 0;
    no_tests_nok = 0;
  endfunction : new

  task run();
    byte result;
    int coverage;
    coverage = 0;

    while (coverage != 100) begin
      this.che2scb.get(result);
      //$display("[SCB] result = %d",result);
      no_tests_done++; 
      
      if (result > 0)
      begin 
        no_tests_ok++; 
        //$display("[SCB] successful test registered (^_^)");
      end else begin
        no_tests_nok++;
        //$display("[SCB] unsuccessful test registered");

      end
      coverage = $get_coverage();
    end /* while*/
  endtask : run


  task showReport;
    $display("[SCB] Test report");
    $display("[SCB] ------------");
    $display("[SCB] # tests done         : %0d", this.no_tests_done);
    $display("[SCB] # tests ok           : %0d", this.no_tests_ok);
    $display("[SCB] # tests failed       : %0d", this.no_tests_nok);
    $display("[SCB] # tests success rate : %0.2f", (this.no_tests_ok*100.0)/this.no_tests_done);
    $display("[SCB] # coverage           : %0.2f", $get_coverage());
  endtask : showReport
endclass : scoreboard
`endif