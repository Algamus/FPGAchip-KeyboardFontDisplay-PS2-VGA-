`timescale 1ns / 1ps

module top( mclk, OutBlue, OutGreen, OutRed,, HS, VS);
	input mclk,ps2d,ps2c,reset;
	wire [7:0] keycode;
	output [2:0] OutRed;
	output [2:0] OutGreen;
	output [1:0] OutBlue;
	output HS, VS;
	
	kb kbinst(.clk(mclk), .reset(reset),.ps2d(ps2d), .ps2c(ps2c),.tx(keycode));
	vga vgainst(.ck(mclk),.keycode(keycode), .HS(HS), .VS(VS), .outRed(OutRed), .outGreen(OutGreen), .outBlue(OutBlue));
	
	
	
endmodule
