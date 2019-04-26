`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:24:02 12/22/2018 
// Design Name: 
// Module Name:    Device 
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
module Device(
    input Clk,
    input GNT,
    inout Req,  
    inout Frame,
    inout IRDY,
    inout TRDY,
    inout [31:0] AD_Line,
    inout [3:0] C_BE,
    inout Dev_Sel,
	 input [2:0]Data_num,
	 input Master_RW,
	 input [31:0] Address_to_Contact
    );

//Device Internal Memory:
reg [31:0] Memory [9:0];
reg [3:0] index ;
 
//Flags for each inout signal:
reg Frame_reg; 
reg IRDY_reg;
reg TRDY_reg ;
reg Dev_Sel_reg ;
reg [31:0]AD_Line_reg;
reg [3:0] C_BE_reg;
reg Req_reg;
reg [2:0]Data_num_reg;

//Flags for indication Read/Write/Turn_around operation:
reg Turn_around_Flag;
reg Frame_Flag; 
reg Master;
reg Slave;
reg Master_Read_Flag;
reg Master_Write_Flag;
reg First;
reg second;
reg Owner_Address;
reg [1:0] Third;

//--------------------------------------------Value of the Device addresses-----------------------------------------------

parameter Address_A = 32'b0000_0000_0000_0000_0000_0000_0000_0000,     
          Address_B=32'b0000_0000_0000_0000_0000_0000_0000_0001,   
			 Address_C = 32'b0000_0000_0000_0000_0000_0000_0000_0010,
          Read_Operation=4'b1010,       
			 Write_Operation=4'b1011;


//-----------------------------------------------Assigements------------------------------------------------------------- 
  
assign Frame = ( Master && !Frame_Flag && First)?  (Frame_reg): 1'bz;    //la2n al master al wa7ed ali bykteb ala al frame lama b2a nrf3 al frame hn7ot al master ba zero noshof b2a cond kman ashn nktb feh
assign Req   = (Master && !Frame_Flag && First)?  (Req_reg)  : 1'bz;
assign C_BE  = (Master && !Frame_Flag && First)?  (C_BE_reg) : 4'bzzzz;
assign AD_Line =(Master && !Frame_Flag && First && !second)? (AD_Line_reg) : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
assign IRDY  = (Master && !Frame_Flag && second)? (IRDY_reg) : 1'bz;

assign TRDY   = (Slave && (Master_Read_Flag || Master_Write_Flag) )?      (TRDY_reg) : (1'bz) ; 
assign Dev_Sel= (Slave && (Master_Read_Flag || Master_Write_Flag) )?    (Dev_Sel_reg): (1'bz) ; 

//-----------------------------------------------------------------------------------------------------------------------

initial
begin
index = 4'b0000;
First = 1'b0;
second = 1'b0;
Master = 1'b0;
Slave = 1'b0;
end


always @(posedge Clk)
begin

//if (!Third)
//begin
//Third = 2'b01;
//end


if(!GNT)
begin
if (Frame) begin Frame_Flag = 1;  Data_num_reg = Data_num ; end
end


//------------------------------------------------------------Master Side---------------------------------------------------
if ( Frame_Flag || Master)
begin
Master = 1;
 
if(!TRDY && !IRDY && !Dev_Sel)
begin
//begin a Data Transfer:
if (Master_RW)
begin
if (Turn_around_Flag == 1) begin Turn_around_Flag = 1'b0; end

else 
//Master Read from the slave and save the data into Memory:
begin
Memory[index] = AD_Line;
index = index + 1;
end
//Data_num_reg = Data_num_reg -1;
end // if Master_RW

end //else if 

end  //bat3et al if (!GNT)


//-----------------------------------------------------Slave Side------------------------------------------------------------

else
begin
//hena ana ka slave ya2ema montazer an al Grant bt3i yekon besefr fa aro7 at check al bus ashn akon master aw montazer master yenadeni 

if (AD_Line ==  Address_to_Contact && !Slave)
       begin
       Owner_Address = Address_to_Contact;

            if (C_BE == Read_Operation)
                    begin  
                   Master_Read_Flag  = 1'b1;
                   Master_Write_Flag = 1'b0;
                    end

            else if (C_BE == Write_Operation)
                    begin 
                   Master_Read_Flag  = 1'b0;
Master_Write_Flag = 1'b1;

end

end //if el kebera

//_________________-__________________________________________ Hene 7etet al data ______________________________________--

else
//hena ana la2eet data ala AD Line:
begin
if(!TRDY && !IRDY && !Dev_Sel && (Owner_Address == Address_to_Contact) )
begin
//begin a Data Transfer:

if (!Master_RW)
begin
//Master Read from the slave and save the data into Memory:
Memory[index] = AD_Line;
index = index +1;
//if (index == Data_num) begin  index = 4'b0000; end
end // if Master_RW

end

end 

//////////////////////////////////////////////////////
end //else al keberaa 5alees
 //////////////////////////////////////////////////////////////
end // posedge always





always @(negedge Clk)
begin


/*
if (Third == 2'b01)
begin
index = 4'b0000;
First = 1'b0;
second = 1'b0;
Master = 1'b0;
Slave = 1'b0;
Third = 2'b10;
end
*/
//------------------------------------------------Master Side----------------------------------------------------- 
if (Master)
begin 

if( Frame_Flag)
begin

Frame_reg = 1'b0;              // 1-Put Frame = 0
Req_reg = 1'b1;                     // 2-Req_Master = 1
AD_Line_reg = Address_to_Contact ;   //3-send tha target address
// 4-Here we check on the input signal which determine the Master wanted operation Read/Write:
if (Master_RW) begin  C_BE_reg = Read_Operation;  end    // Master_RW = 1 -> Read  
else           begin  C_BE_reg = Write_Operation; end    // Master_RW = 0 -> Write 

Frame_Flag = 1'b0;
First = 1'b1;
Turn_around_Flag = 1'b1;

end //if frame flag

else
begin
IRDY_reg = (!Frame_reg && First)?  1'b0: 1'b1;
second = 1'b1;
//(Master_Read)? ( (Master_Write)? 1'bz:1'b0 ):( (Master_Write)? 1'b0:1'bz );

if (Master_RW)
begin

if (Turn_around_Flag == 1'b0)
begin
//This means that the Turn around cycle has finished:
Data_num_reg = Data_num_reg - 1;
if(Data_num_reg == 0)
begin 
Frame_reg = 1; 
//Third = 2'b00;
end
end

end

//Write Operation:
else
begin
Data_num_reg = Data_num_reg - 1;
if(Data_num_reg == 0)
begin 
Frame_reg = 1; 
//Third = 2'b00;
end
end


end //else

end  //if master


//------------------------------------------------------Slave Side-----------------------------------------------------
else

begin
//Master Read and Slave Write:
if ( (Master_Read_Flag == 1'b1) &&  (Master_Write_Flag == 1'b0) )
begin

TRDY_reg = 1'b0;
Dev_Sel_reg = 1'b0;
Slave = 1'b1;

if (Turn_around_Flag == 1'b1)
begin
Turn_around_Flag = 1'b0;
end

end //if

//Master Write and Slave Read:
else if ((Master_Read_Flag == 1'b0) &&  (Master_Write_Flag == 1'b1))
begin
TRDY_reg = 1'b0;
Dev_Sel_reg = 1'b0;
Slave = 1'b1;
end

end //else

//----------------------------------------------------------------------------------------------------------------------
end //always
endmodule



