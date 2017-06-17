//Listing 9.5
module kb
   (
    input wire clk, reset,
    input wire ps2d, ps2c,
    output wire tx
   );

   // signal declaration
   wire [7:0] key_code;
   wire kb_not_empty, kb_buf_empty;

   // body
   // instantiate keyboard scan code circuit
   kb_code kb_code_unit
      (.clk(clk), .reset(reset), .ps2d(ps2d), .ps2c(ps2c),
       .rd_key_code(kb_not_empty), .key_code(key_code),
       .kb_buf_empty(kb_buf_empty));

  

   assign kb_not_empty = ~kb_buf_empty;

endmodule