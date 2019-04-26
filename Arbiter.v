`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:20 12/26/2018 
// Design Name: 
// Module Name:    Arbiter 
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
module Arbiter(Clk, frame, ReqA, ReqB, ReqC, GNTA, GNTB, GNTC );
input ReqA, ReqB, ReqC ,Clk, frame;
output reg GNTA, GNTB, GNTC;
reg GNTA_reg;
reg GNTA_Flag, GNTB_Flag, GNTC_Flag;
//reg GNTA_reg, GNTB_reg, GNTC_reg ;


//assign GNTA =  (!ReqA)?   GNTA_reg:1'b1  ;

//assign GNTA = (!Clk)?  (GNTA_reg) : (1'bz) ;


always @ (posedge Clk )
begin 
//Enable Grant:
if (!ReqA)        
begin 
GNTA_Flag<=1'b1;
GNTB_Flag<=1'b0; 
GNTC_Flag<=1'b0; 
end

else if (!ReqB)   
begin 
GNTA_Flag<=1'b0;
GNTB_Flag<=1'b1;
GNTC_Flag<=1'b0; 
end

else if (!ReqC)   
begin 
GNTA_Flag<=1'b0;
GNTB_Flag<=1'b0;
GNTC_Flag<=1'b1;  
end


if (ReqA && !frame )
begin GNTA_Flag<= 1'b0;  end

else if (ReqB && !frame)
begin GNTB_Flag<=1'b0;    end

else if (ReqC && !frame)
begin GNTC_Flag<=1'b0;  end

end


always @ (negedge Clk)
begin
GNTA = (GNTA_Flag)?    (!(GNTB_Flag && GNTC_Flag)? 1'b0:1'b1) : 1'b1;

GNTB = (GNTB_Flag)?    (!(GNTA_Flag && GNTC_Flag)? 1'b0:1'b1) : 1'b1;

GNTC = (GNTC_Flag)?    (!(GNTB_Flag && GNTA_Flag)? 1'b0:1'b1) : 1'b1;
end

endmodule


