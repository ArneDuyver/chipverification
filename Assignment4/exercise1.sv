`ifndef SV_TRA_TRANSACTION
`define SV_TRA_TRANSACTION

class transaction;

  rand byte A;
  rand byte B;
  byte Z;
  rand bit [2:0] operation;
  rand bit [3:0] flags_in;
  bit [3:0] flags_out;

  function new();
    this.A = 0;
    this.B = 0;
    this.Z = 0;
    this.operation = 3'b0;
    this.flags_in = 4'b0;
    this.flags_out = 4'b0;
  endfunction : new

  function string toString();
    return $sformatf("A: %02x, B: %02x, flags_in: %01x, operation: %01x, Z: %02x, flags_out: %01d", this.A, this.B, this.flags_in, this.operation, this.Z, this.flags_out);

  endfunction : toString

  task updateOutcome_ADD();
    shortint a, b, z;

    a = unsigned'(this.A);
    b = unsigned'(this.B);
    z = (a + b) % 256;

    this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
    this.flags_out[2] = 1'b0; // subtract flag (always clear in addition)
    this.flags_out[1] = ( (((a%16) + (b%16)) > 15) ? 1'b1 : 1'b0 ); // half carry flag
    this.flags_out[0] = ( ((a + b) > z) ? 1'b1 : 1'b0); // carry flag

    this.Z = byte'(z);
  endtask : updateOutcome_ADD

endclass : transaction;

program test;
  static transaction myTrans;

  initial 
  begin

    for(int i=0;i<5;i++)
    begin
      myTrans = new();

      void'(myTrans.randomize());

      myTrans.updateOutcome_ADD();

      $display("%s", myTrans.toString());
    end

  end
endprogram : test

`endif