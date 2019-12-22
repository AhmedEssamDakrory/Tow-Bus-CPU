library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use std.env.stop;

entity processor is
    generic(
        width : integer := 16
        );
port(
    busa,busb : inout std_logic_vector(width-1 downto 0);
	clk,reset : in std_logic
);
end processor;

architecture arch of processor is
component REG IS
	GENERIC ( N : INTEGER := 16 ) ;
	PORT ( 	D			: IN 		STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;
			Resetn, Clock, Load	: IN 		STD_LOGIC ;
			Q	: OUT 	STD_LOGIC_VECTOR(N-1 DOWNTO 0) ) ;
end component ;
component FlipFlop IS
	PORT ( 	D			: IN 		STD_LOGIC ;
			Resetn, Clock, Load	: IN 		STD_LOGIC ;
			Q	: OUT 	STD_LOGIC ) ;
end component;
component Register_entity IS
 PORT(
    d   : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    Load  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    q   : OUT STD_LOGIC_VECTOR(16 DOWNTO 0) 
);
end component;

component ALU is
    port(
        clk:in std_logic;
        Operation:in std_logic_vector(34 downto 0);
        A,DstOut :in std_logic_vector(16 downto 0);
        OutSignal:out std_logic_vector(15 downto 0);
        F:out std_logic_vector(15 downto 0)
    );
end component;

component TRI_STATE IS
  GENERIC(N : INTEGER := 16);
  PORT(ENABLE : IN STD_LOGIC;
  data_in : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
  data_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) );
end component;
component sig_generator IS
	PORT( 
	      inst                  :   IN std_logic_vector (18 DOWNTO 0);
 	      ir                    :   IN std_logic_vector(15 DOWNTO 0 );
 	      MPC                   :   IN std_logic_vector(4 DOWNTO 0);
 	      
	     	alu                    :   out std_logic_vector(7 DOWNTO 0);	--f0	0 2
	     	alu1                  :   out std_logic_vector (15 DOWNTO 0);
	     	alu2                  :   out std_logic_vector(15 DOWNTO 0);	
	     	out1                  :   out std_logic_vector (7 DOWNTO 0);	--f1
	     	out2                  :   out std_logic_vector (7 DOWNTO 0);	--f2
	     	in1                   :   out std_logic_vector (7 DOWNTO 0);	--f3
	     	in2                   :   out std_logic_vector (3 DOWNTO 0);	--f4 
	     	rout                  :   out std_logic_vector (7 DOWNTO 0);    
	     	rin                   :   out std_logic_vector (7 DOWNTO 0)
	     	);
END component;

component ROM is
    generic(
        addr_width : integer := 32; -- store 32 elements
        addr_bits  : integer := 5;  -- required bits to store 32 elements
        data_width : integer := 19  -- each element has 19-bits (5: next adress, 14: microinstruction)
        );
port(
    addr : in std_logic_vector(addr_bits-1 downto 0);
    data : out std_logic_vector(data_width-1 downto 0);
	clk : in std_logic
);

end component;

component sync_ram is
  port (
    clock   : in  std_logic;
    we      : in  std_logic;
    address : in  std_logic_vector(15 downto 0);
    datain  : in  std_logic_vector(15 downto 0);
    dataout : out std_logic_vector(15 downto 0)
  );
end component;

component PLA IS
	PORT( ir                    :    IN std_logic_vector (15 DOWNTO 0);
		  clk                   :    in std_logic;
	      na                    :    IN std_logic_vector (4 DOWNTO 0); -- next address
	      flags                 :    IN std_logic_vector(15 Downto 0); -- flag register from alu 0-> zero flag and 1-> carry flag
	      F                     :    OUT std_logic_vector (4 DOWNTO 0)	); -- next address after branching
END component;

--data
signal R0,R1,R2,R3,R4,R5,R6,R7,MDR,MAR,DST,SRC,Z,IR,flags , bus_a_or_b1,bus_a_or_b2,F,address_Field_Of_IR, from_ram, bus_b_or_ram , from_Ram_Or_IR : std_logic_vector(15 downto 0);
--f0
signal MDRin,DSTin,SRCin_a,INC_A,DEC_A,ADD_AB,clk_invert,interupt  : std_logic;
--f1
signal R0out,R1out,R2out,R3out,R4out,R5out,R6out,R7out,MDRout,SRCout : std_logic;
--f2
signal IRout,Zout,Zout1,MARout,MARin_A : std_logic;
--f3
signal R0in,R7in,R1in,R2in,R3in,R4in,R5in,R6in,SRCin_b,flag,RD,WR : std_logic;
--f4
signal Zin,IRin,MARin_B,SRCin_a_or_b,MARin_A_or_B, MDRin_or_RD ,Q: std_logic;
signal operation :std_logic_vector(34 downto 0);

--groups
signal f0,f1,f2,f3,which_Rin , which_Rout : std_logic_vector(7 downto 0);
signal f4 : std_logic_vector(3 downto 0);
signal alu1 : std_logic_vector(15 downto 0); 
signal alu2 : std_logic_vector(15 downto 0);
signal MicroI_data : std_logic_vector(18 downto 0); 
signal MPC,tmp,MPC_ROM : std_logic_vector(4 downto 0);
signal con1 , con2 : std_logic_vector(16 downto 0);
begin
  
  
--assigning signals----------------------------------
-- group0
INC_A <= f0(0);
ADD_AB <= f0(1);
DEC_A <= f0(2);
DSTin <= f0(3);	   
SRCin_a <= f0(4);
MDRin <= f0(5);
--group1-----------------------------------------------------
--which Rxout
R0out <= (f1(0) or f1(1)) and which_Rout(0);
R1out <= (f1(0) or f1(1)) and which_Rout(1);
R2out <= (f1(0) or f1(1)) and which_Rout(2);
R3out <= (f1(0) or f1(1)) and which_Rout(3);
R4out <= (f1(0) or f1(1)) and which_Rout(4);
R5out <= (f1(0) or f1(1)) and which_Rout(5);
R6out <= (f1(0) or f1(1)) and which_Rout(6);
R7out <= ((f1(0) or f1(1)) and which_Rout(7)) or f1(2);
--pcout?!1

SRCout <= f1(3);
MDRout <= f1(4);

--group2---------------------------------------------------- 
IRout <= f2(0);
Zout <= f2(1);
Zout1 <= f2(2);
MARout <= f2(3);
MARin_A <= f2(4);

--group3---------------------------------------------------
RD <= f3(0);
WR <= f3(2);
--which Rxin
R0in <= (f3(3) or f3(4)) and which_Rin(0);
R1in <= (f3(3) or f3(4)) and which_Rin(1);
R2in <= (f3(3) or f3(4)) and which_Rin(2);
R3in <= (f3(3) or f3(4)) and which_Rin(3);
R4in <= (f3(3) or f3(4)) and which_Rin(4);
R5in <= (f3(3) or f3(4)) and which_Rin(5);
R6in <= (f3(3) or f3(4)) and which_Rin(6);
R7in <= ((f3(3) or f3(4)) and which_Rin(7)) or f3(1);


SRCin_b <= f3(5);
flag <= f3(6);

--group4---------------------------------------------------


Zin <= f4(0);
IRin <= f4(1);
MARin_B <= f4(2);

Ram_1 : sync_ram port map(clk , WR , MAR , MDR, from_ram);
fetch_Micro_instruction: ROM port map(MPC , MicroI_data , clk);
MPC_ROM <= MicroI_data(18 downto 14);

from_Ram_Or_IR <= MDR when IRin = '1'
else IR;
fetch_next_address: PLA port map(from_Ram_Or_IR,clk , MPC_ROM ,flags , tmp);
clk_invert <= not clk;
Read_FF: FlipFlop port map (RD,reset,clk_invert,'1',Q);
R_0: REG port map(busb,reset,clk,R0in,R0);
R_1: REG port map(busb,reset,clk,R1in,R1);
R_2: REG port map(busb,reset,clk,R2in,R2);
R_3: REG port map(busb,reset,clk,R3in,R3);
R_4: REG port map(busb,reset,clk,R4in,R4);
R_5: REG port map(busb,reset,clk,R5in,R5);
R_6: REG port map(busb,reset,clk,R6in,R6);
R_7: REG port map(busb,reset,clk,R7in,R7);

IR_1: REG port map(busa , reset , clk, IRin , IR );------invert
DST_1: REG port map(busa , reset , clk , DSTin , DST );
Z_1 : REG port map(F ,reset , clk , Zin , Z);
bus_a_or_b1 <= busa when SRCin_a = '1'
else busb;

SRCin_a_or_b <= SRCin_a or SRCin_b;
SRC_1: REG port map(bus_a_or_b1 , reset , clk ,SRCin_a_or_b, SRC );

bus_a_or_b2 <= busa when MARin_A = '1'
else busb;

MARin_A_or_B <= MARin_A or MARin_B;
MAR_1: REG port map(bus_a_or_b2 , reset , clk , MARin_A_or_B, MAR );

MDRin_or_RD <= MDRin or RD or Q;
bus_b_or_ram <= busb when MDRin = '1'
else from_ram;
MDR_1 : REG port map( bus_b_or_ram, reset , clk_invert , MDRin_or_RD , MDR );

TRI_STATE_R0: TRI_STATE port map(R0out , R0 , busa );
TRI_STATE_R1: TRI_STATE port map(R1out , R1 , busa );
TRI_STATE_R2: TRI_STATE port map(R2out , R2 , busa );
TRI_STATE_R3: TRI_STATE port map(R3out , R3 , busa );
TRI_STATE_R4: TRI_STATE port map(R4out , R4 , busa );
TRI_STATE_R5: TRI_STATE port map(R5out , R5 , busa );
TRI_STATE_R6: TRI_STATE port map(R6out , R6 , busa );
TRI_STATE_R7: TRI_STATE port map(R7out , R7 , busa );
TRI_STATE_MAR: TRI_STATE port map(MARout , MAR , busb );
TRI_STATE_MDR: TRI_STATE port map(MDRout , MDR , busa );

address_Field_Of_IR <= "11111111"&IR(7 downto 0) when IR(7) = '1'
else "00000000"&IR(7 downto 0);

TRI_STATE_IR: TRI_STATE port map(IRout , address_Field_Of_IR , busb );
TRI_STATE_SRC: TRI_STATE port map(SRCout , SRC , busa );
TRI_STATE_Zout: TRI_STATE port map(Zout , Z , busb);
TRI_STATE_Zout1: TRI_STATE port map(Zout1 , F , busb);

operation <= alu1 & alu2 & f0(2 downto 0);
sig_generator_1 : sig_generator port map(MicroI_data , IR , MPC , f0 , alu1 , alu2 , f1 , f2 , f3 , f4 , which_Rout , which_Rin );
con1 <= '0' & busa;
con2 <= '0' & DST;
ALU_1:ALU port map(clk,operation,con1,con2,flags,F);

MPC <= tmp;

process (ir)
  begin
	if(ir(15 downto 12) = "1111") then  --hlt
		stop;
    end if;
end process;
end arch;