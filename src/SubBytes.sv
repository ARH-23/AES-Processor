//
// SubBytes Layer of the AES round
//

import AESDefinitions::*;

module SubBytes(input state_t in,
                output state_t out);

`ifdef INFER_RAM
byte_t sbox[0:255];

initial
begin
  $readmemh("./src/mem/Sbox.mem", sbox);
end
`endif

always_comb
  begin

    // Each byte of the output is the element in the sbox LUT where the high
    // and low parts of the input byte are used as the indices of the 2D LUT
    for(int i = 0; i < 16; i++)
    begin
      `ifdef INFER_RAM
      out[i] = sbox[(in[i][7:4]*16) + in[i][3:0]];
      `else
      out[i] = sbox[in[i][7:4]][in[i][3:0]];
      `endif
    end
    `ifdef DEBUG
      $display("%m");
      $display("In: %h",in);
      $display("Out: %h", out);
    `endif
  end
endmodule

module SubBytesInverse(input state_t in,
                       output state_t out);

`ifdef INFER_RAM
byte_t invSbox[0:255];

initial
begin
  $readmemh("./src/mem/InvSbox.mem", invSbox);
end
`endif

always_comb
  begin

    // Each byte of the output is the element in the inverse sbox LUT where the
    // high and low parts of the input byte are used as the indices of the 2D 
    // LUT
    for(int i = 0; i < 16; i++)
    begin
      `ifdef INFER_RAM
      out[i] = invSbox[(in[i][7:4]*16) + in[i][3:0]];
      `else
      out[i] = invSbox[in[i][7:4]][in[i][3:0]];
      `endif
    end
    `ifdef DEBUG
      $display("%m");
      $display("In: %h",in);
      $display("Out: %h", out);
    `endif
  end
endmodule
