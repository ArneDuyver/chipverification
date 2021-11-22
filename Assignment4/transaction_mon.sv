`ifndef DEF_TRANS_MON
`define DEF_TRANS_MON
class transaction_mon;

  byte regA,flags;

  function new(byte regA, byte flags);
    this.regA = regA;
    this.flags = flags;
  endfunction : new

  function string toString();
    return $sformatf("regA: %02x, flags: %02x.", this.regA, this.flags);
  endfunction : toString

endclass : transaction_mon
`endif