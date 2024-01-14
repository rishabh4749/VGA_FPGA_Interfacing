`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2024 22:52:22
// Design Name: 
// Module Name: des
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Interfacing VGA(Video Graphics Array) with SPARTAN3E
// Working frequency of the assumed VGA is 25 MHz
module des(clk, //Main clock
clk_25, //25 MHz clock needed for proper functioning of the VGA
rstv, //VGA reset
rst, //Main reset
red,blue,green, //RGB control signals
vga_hsync,vga_vsync // VGA synchronisation control signals
);

input clk,rstv,rst;
output reg red,blue,green;
output reg vga_hsync,vga_vsync; //Control signals
//Two registers for keeping the track of the current pixel position
reg [9:0] hs=0;
reg [9:0] vs=0;
output reg clk_25; 

//Generation of the required 25MHz clock from the main clock
always @ (posedge clk) 

begin
if(rst)
clk_25<=1'b0;
else
clk_25<=~clk_25; 
end

always @ (posedge clk_25)
begin

if(rstv) //If VGA is reset then all the registers would be initialised to their reset value

begin //closed
hs<=0;
vs<=0;
red<=0;
green<=0;
blue<=0;
end

else
 
begin

if(hs==799) //End of one row of horizontal pixels

begin 
hs<=0; //Back to the first pixel in horizontal row
if(vs==521) //Last row
vs<=0; //Back to first row
else
vs<=vs+1; //Increment row number 
end 

else
hs<=hs+1; //Horizontal pixel increment

if((hs>=656)&&(hs<752)) //Sync Pulse region of h_sync signal which lies in the inactive region of the display
vga_hsync<=0; //h_sync becomes zero in the sync pulse region 
else
vga_hsync<=1; //h_sync remains 1 otherwise i.e., in Front Porch (640 to 656) and Back Porch (752 to 800) regions

if((vs>=490)&&(vs<492)) //Sync Pulse region of v_sync signal which lies in the inactive region of the display
vga_vsync<=0; //v_sync becomes zero in the sync pulse region
else
vga_vsync<=1; //v_sync remains 1 otherwise i.e., in Front Porch (480 to 490) and Back Porch (492 to 521) regions

end

end

endmodule
