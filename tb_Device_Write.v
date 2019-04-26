`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:51:30 12/27/2018
// Design Name:   Device
// Module Name:   C:/Users/El TAWHEED/Xilinx/pci_project/Tb_Device_write.v
// Project Name:  pci_project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Device
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Tb_Device_write;

	// Inputs
	reg Clk;
	reg GNT;
	reg [2:0] Data_num;
	reg Master_RW;
	reg [31:0] Address_to_Contact;

	// Bidirs
	wire Req;
	wire Frame;
	wire IRDY;
	wire TRDY;
	wire [31:0] AD_Line;
	wire [3:0] C_BE;
	wire Dev_Sel;

	// Instantiate the Unit Under Test (UUT)
	Device uut (
		.Clk(Clk), 
		.GNT(GNT), 
		.Req(Req), 
		.Frame(Frame), 
		.IRDY(IRDY), 
		.TRDY(TRDY), 
		.AD_Line(AD_Line), 
		.C_BE(C_BE), 
		.Dev_Sel(Dev_Sel), 
		.Data_num(Data_num), 
		.Master_RW(Master_RW), 
		.Address_to_Contact(Address_to_Contact)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		GNT = 0;
		Data_num = 0;
		Master_RW = 0;
		Address_to_Contact = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

