`ifndef DEF_TRANS
`define DEF_TRANS
class transaction;

  rand byte A;
  rand byte B;
  byte Z;
  randc bit [2:0] operation;
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

  task updateOutcome_ADC();
    shortint a, b, z;
    bit carry;
    carry = this.flags_in[0];
    a = unsigned'(this.A);
    b = unsigned'(this.B);
    z = (a + b + carry) % 256;

    this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
    this.flags_out[2] = 1'b0; // subtract flag (always clear in addition)
    this.flags_out[1] = ( (((a%16) + (b%16) + carry) > 15) ? 1'b1 : 1'b0 ); // half carry flag
    this.flags_out[0] = ( ((a + b + carry) > z) ? 1'b1 : 1'b0); // carry flag

    this.Z = byte'(z);
  endtask : updateOutcome_ADC

  task updateOutcome_SUB();
    shortint a, b, z;

    a = unsigned'(this.A);
    b = unsigned'(this.B);
    z = (a - b) % 256;

    this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
    this.flags_out[2] = 1'b0; // subtract flag (always clear in addition)
    this.flags_out[1] = ( ((a%16) < (b%16)) ? 1'b1 : 1'b0 );
    this.flags_out[0] = ( (a < b) ? 1'b1 : 1'b0); // carry flag

    this.Z = byte'(z);
  endtask : updateOutcome_SUB

  task updateOutcome_SUBC();
    shortint a, b, z;
    bit carry;
    carry = this.flags_in[0];
    a = unsigned'(this.A);
    b = unsigned'(this.B);
    z = (a - b - carry) % 256;

    this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
    this.flags_out[2] = 1'b0; // subtract flag (always clear in addition)
    this.flags_out[1] = ( ((a%16) < ((b%16) + carry) > 15) ? 1'b1 : 1'b0 ); // half carry flag
    this.flags_out[0] = ( (a < (b + carry)) ? 1'b1 : 1'b0); // carry flag

    this.Z = byte'(z);
  endtask : updateOutcome_SUBC

  task updateOutcome_AND();
    shortint a, b, z;
    a = unsigned'(this.A);
    b = unsigned'(this.B);
    z = a & b;

    this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
    this.flags_out[2] = 1'b0; // Reset
    this.flags_out[1] = 1'b1; // Set
    this.flags_out[0] = 1'b0; // Reset

    this.Z = byte'(z);
  endtask : updateOutcome_AND

  task updateOutcome_XOR();
    shortint a, b, z;
    a = unsigned'(this.A);
    b = unsigned'(this.B);
    z = a ^ b;

    this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
    this.flags_out[2] = 1'b0; // Reset
    this.flags_out[1] = 1'b0; // Reset
    this.flags_out[0] = 1'b0; // Reset

    this.Z = byte'(z);
  endtask : updateOutcome_XOR

  task updateOutcome_OR();
    shortint a, b, z;
    a = unsigned'(this.A);
    b = unsigned'(this.B);
    z = a | b;

    this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
    this.flags_out[2] = 1'b0; // Reset
    this.flags_out[1] = 1'b0; // Reset
    this.flags_out[0] = 1'b0; // Reset

    this.Z = byte'(z);
  endtask : updateOutcome_OR

  task updateOutcome_CMP();
    shortint a, b, z;
    a = unsigned'(this.A);
    b = unsigned'(this.B);
    z = a; // equals throw away result according to documentation

    this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
    this.flags_out[2] = 1'b1; // Set
    this.flags_out[1] = ( ((a%16) < ((b%16)) > 15) ? 1'b1 : 1'b0 ); // half carry flag
    this.flags_out[0] = ( (a < b) ? 1'b1 : 1'b0); // carry flag

    this.Z = byte'(z);
  endtask : updateOutcome_CMP

  constraint test1 { 
    operation inside {[3'b000 : 3'b111]};
    flags_in == 4'b0;
  }

  constraint test2 {
    operation == 3'b010;
    B > A;
  }

  constraint test3 {
    operation == 3'b101;
    B == 8'h55;
  }

  constraint test4 {
    operation == 3'b001;
    flags_in[0] == 1'b1;
  }

  constraint test5 {
    operation dist {[0:6] := 4, 7 := 1 }; 
  }

endclass : transaction;
//TODO: if a lot of thins fail, write a short program to test some functionalities
`endif