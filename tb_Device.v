`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:21:44 12/24/2018
// Design Name:   Device
// Module Name:   C:/Users/El TAWHEED/Xilinx/pci_project/tb_Device.v
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

module tb_Device;

	// Inputs
	reg Clk;
	reg GNT_A;
	reg GNT_B;
	reg [2:0]Data_Num;
	reg [31:0] Address_to_contact_B;
	reg [31:0] Address_to_contact_C;
	reg Master_RW;
	
	// Outputs
	wire Req_A;
	wire Req_B;

	// Bidirs
	wire Frame;
	wire IRDY;
	wire TRDY;
	wire [31:0] AD_Line;
	wire [3:0] C_BE;
	wire Dev_Sel;
   
	// Register to write on the Wires:
   reg Frame_reg;
	reg IRDY_reg;
	reg TRDY_reg;
	reg Dev_Sel_reg;
	reg[31:0] AD_Line_reg;
	reg[3:0] C_BE_reg;
	reg Req_A_reg;
	reg Req_B_reg;
	


	// Instantiate the Unit Under Test (UUT)
	
	Device A (
		 Clk, 
		 GNT_A,		 
		 Req_A, 
		 Frame, 
		 IRDY, 
		 TRDY, 
		 AD_Line, 
		 C_BE, 
		 Dev_Sel, 
		 Data_Num,
		 Master_RW,
		 Address_to_contact_B
	);
	
	
	
	Device B (
		 Clk, 
		 GNT_B,		 
		 Req_B, 
		 Frame, 
		 IRDY, 
		 TRDY, 
		 AD_Line, 
		 C_BE, 
		 Dev_Sel, 
		 Data_Num,
		 Master_RW,
		 Address_to_contact_B
	);
	Device C (
		 Clk, 
		 GNT_B,		 
		 Req_B, 
		 Frame, 
		 IRDY, 
		 TRDY, 
		 AD_Line, 
		 C_BE, 
		 Dev_Sel, 
		 Data_Num,
		 Master_RW,
		 Address_to_contact_C
	);
	
		Arbiter D(Clk, Frame, Req_A, Req_B, Req_C, GNT_A, GNT_B, GNT_C );
	
	
	assign Frame = Frame_reg;
	assign IRDY = IRDY_reg;
	assign TRDY = TRDY_reg;
	assign Dev_Sel = Dev_Sel_reg;
	assign Req_A = Req_A_reg;
	assign Req_B = Req_B_reg;
	assign AD_Line = AD_Line_reg;
	assign C_BE = C_BE_reg;
	
	/*-------------------------------------------------Start Test Bench---------------------------------------*/
	
	always 
	begin
	#5 Clk = ~ Clk;
	end
	
	
	initial 
	 begin
		// Initialize Inputs: At Time = 0
		Clk = 0;
		
		Req_A_reg = 0;
		Req_B_reg = 0;
		
		 GNT_A = 1'b0;
	    GNT_B= 1'b1;
		
		Frame_reg = 1'b1;
		IRDY_reg = 1'b1;
		TRDY_reg = 1'b1;
		Dev_Sel_reg = 1'b1;
		
		AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
		C_BE_reg = 4'bzzzz;
		
		Master_RW = 1'b0;
		Data_Num = 3'b010;
		
		Address_to_contact_B = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
		Address_to_contact_C = 32'b0000_0000_0000_0000_0000_0000_0000_0010;
		
		//Address of device B
		
	    #5
      fork
		// execute at time = 10
      #5 Frame_reg = 1'bz;		
		#5 Req_A_reg = 1'bz;
		//#5 AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
      join	
		
		//Time = 25
		#5 
		
		//Time = 30
		fork
		#5 IRDY_reg = 1'bz;
		#5 TRDY_reg = 1'bz;
		#5 Dev_Sel_reg = 1'bz;
		//Master put the data on AD Line after sending the address
		#5  AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
		#5 AD_Line_reg = 32'b0000_0000_0000_0000_1111_1111_1111_1111;
		#5 GNT_A = 1'b1;
	   #5 GNT_B= 1'b0;
		join
		
		//Time = 30 
		#10 AD_Line_reg = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
		
		//#10 AD_Line_reg = 32'b1111_0000_1111_0000_0000_0000_1111_1111;
	end
      
endmodule

