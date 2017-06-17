`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:22:30 10/14/2011 
// Design Name: 
// Module Name:    vga 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define PAL 640		//--Pixels/Active Line (pixels)
`define LAF 480		//--Lines/Active Frame (lines)
`define PLD 800	   //--Pixel/Line Divider
`define LFD 521	   //--Line/Frame Divider
`define HPW 96		   //--Horizontal synchro Pulse Width (pixels)
`define HFP 16		   //--Horizontal synchro Front Porch (pixels)
//`define HBP 48		--Horizontal synchro Back Porch (pixels)
`define VPW 2   		//--Vertical synchro Pulse Width (lines)
`define VFP 10		   //--Vertical synchro Front Porch (lines)
//`define VBP 29     //--Vertical synchro Back Porch (lines)

module vga(ck, keycode ,Hcnt, Vcnt, HS, VS, outRed, outGreen, outBlue);
	input ck;
	input [7:0] keycode;
	output reg HS, VS;
	output reg [2:0] outRed, outGreen;
	output reg [1:0] outBlue;

	output reg [9:0] Hcnt, Vcnt;	
	reg ck25MHz;
	
	// -- divide 50MHz clock to 25MHz

	always @ (posedge ck)
		ck25MHz<= ~ck25MHz;
		
	always @ (posedge ck25MHz) begin
		if (Hcnt == `PLD-1) begin
			Hcnt<= 10'h0;
			if (Vcnt == `LFD-1) 
				Vcnt <= 10'h0;
			else 
				Vcnt <= Vcnt + 10'h1;
		end
		else 
			Hcnt<= Hcnt +10'h1;
	end
			
	
//-- Generates HS - active low
	always @(posedge ck25MHz) begin
		if (Hcnt == `PAL-1 +`HFP)
			HS<=1'b0;
		else if (Hcnt == `PAL-1+`HFP+`HPW)
			HS<=1'b1;
	end

//-- Generates VS - active low
	always @(posedge ck25MHz) begin
		if (Vcnt ==`LAF-1+`VFP)
			VS <= 1'b0;
		else if (Vcnt== `LAF-1+`VFP+`VPW)
			VS <= 1'b1;	
	end 

reg [14:0] addra;
wire [7:0] douta;

	always @ (posedge ck25MHz) begin
		
		if ((Hcnt <`PAL) && (Vcnt < `LAF)) begin
			//your design for lab9
			
			if(Hcnt>199 && Hcnt<320 && Vcnt>49 && Vcnt<210)begin
			
			outRed <= douta[7:5];
			outGreen <= douta[4:2]; 
			outBlue <= douta[1:0];
			
			addra<=addra+15'h1;
			
			end else begin
			if(Vcnt<50 || Vcnt>209) begin
				addra<=15'h0;
			end
			outRed <= 3'b111;
			outGreen <= 3'b111;
			outBlue <= 2'b11;
			end
		end
		else begin
			
			outRed <= 3'b000;
			outGreen <= 3'b000;
			outBlue <= 2'b00;
		end
	end
	//added from framebuffer
	frameBuffer your_instance_name (
  .clka(ck25MHz), // input clka
  .addra(addra), // input [14 : 0] addra
  .douta(douta) // output [7 : 0] douta
);
	
	
endmodule