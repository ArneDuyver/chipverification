`include "ALU_iface.sv"

module top; 
  logic clock=0;
  // clock generation - 100 MHz
  always #5 clock = ~clock;

  logic [7:0] a, b, z;

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
  integer logf;
// provide stimuli
  initial begin
    //Logfile
    logf = $fopen("tests_log.txt", "w");
    //Initial flush: set all inputs to 0
    $display("Starting test: resetting...");
    theInterface.data_a <= 8'h0;
    theInterface.data_b <= 8'h0;
    theInterface.flags_in <= 4'h0;
    theInterface.operation <= 3'h0;
    repeat (10) @(posedge clock);

    //Initial setup: set input a to 1 and operation is "add"
    $display("Initial setup...");
    theInterface.data_a <= 8'h1;
    repeat (10) @(posedge clock);

    //Run tests
    $display("Starting tests...");
    for(int i=0;i<256;i++) begin
      theInterface.data_b <= i;
      a =  theInterface.data_a;
      b =  theInterface.data_b;
      z =  theInterface.data_z;
      $display("--- a = %0d, b = %0d, out = %0d", a,b,z);
      $fwrite(logf, "a = %0d, b = %0d, out = %0d \n", a,b,z);
      @(posedge clock);
    end
    
    $display("Ending tests...");
    $fclose(logf);
    repeat (50) @(posedge clock);
    $finish;
  end

endmodule : top