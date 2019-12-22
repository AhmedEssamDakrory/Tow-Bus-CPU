LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY PLA IS
	PORT( ir                    :    IN std_logic_vector (15 DOWNTO 0);
		  clk 					:	 in std_logic;
	      na                    :    IN std_logic_vector (4 DOWNTO 0); -- next address
	      flags                 :    IN std_logic_vector(15 Downto 0); -- flag register from alu 0-> zero flag and 1-> carry flag
	      F                     :    OUT std_logic_vector (4 DOWNTO 0)	); -- next address after branching
END ENTITY PLA;


ARCHITECTURE arch1 of PLA IS

signal br : std_logic_vector(6 downto 0); -- branch final wires 
signal branch_stats : std_logic;

function reduction ( input    : in std_logic_vector(7 downto 0))
    return std_logic is
    variable res : std_logic := '1';
  begin
    for i in 0 to 7 loop
      res := res and input(i);
    end loop;
    return res;
     
end function reduction;


BEGIN
 
   ---  branch circuit
  br(0) <= reduction(ir( 15 downto 8 ) and "00001001");
  br(1) <= reduction(ir( 15 downto 8 ) and "00001010") and flags(1);
  br(2) <= reduction(ir( 15 downto 8) and "00001100") and (not flags(1));
  br(3) <= reduction(ir( 15 downto 8) and "00001101") and (not flags(1));
  br(4) <= reduction(ir( 15 downto 8) and "00001110") and ((not flags(1)) or flags(0));
  br(5) <= reduction(ir( 15 downto 8) and "00001111") and flags(0);
  br(6) <= reduction(ir( 15 downto 8) and "00001000") and (flags(1) or flags(0));
  branch_stats <= br(0) or br(1) or br(2) or br(3) or br(4) or br(5) or br(6) ;
  
  process(ir , na,clk)
    variable flag,flag2: std_logic := '0';
    variable f1,f2,x,y,indir: std_logic ;
    variable temp : std_logic_vector(2 downto 0);
    begin
	if falling_edge(clk)then
		-- @ address 0
		if( na = "00000") then
		   flag := '0';
		   flag2 := '0';
		   f1 := ir(15) or ir(14) or ir(13) or ir(12);
			 f2 := ir(11);
			 x := not f1;
			 y := f1 or f2 ; 
			 if( x = '0') THEN -- fetch src
			temp := ir(11) & ir(10) & (ir(9) and ( not ir(10)) and (not ir(11)));
		   elsif(x='1' and y = '0') THEN -- fetch des
			temp := ir(5) & ir(4) & ( ir(3) and (not ir(4)) and (not ir(5)));
		   else -- branch or goto 31
			temp := branch_stats & branch_stats & branch_stats; 
		   end if;
		   F <= x & y & temp ;
		elsif( na = "10000") then -- @ address 16
		  -- fetch dest
		  if(ir(11 downto 9) = "001" or ir(9) = '0' or flag = '1') then
				indir :=  (not ir(5)) and (not ir(4)) and ir(3);
			  f <= na or ("00" & ir(5 downto 4) & indir);
		  -- not direct src
		  else 
		   flag := '1';
		   f <= na or "00101";
		  end if;
		elsif( na = "11001") then -- @ address 25
		   if( ir(3) = '0' or flag2 = '1')then -- apply operation
				if( ir(5 downto 3) = "000") then
					f <= na or ("00"& ir(3)& "00");
				else
					f <= "11101";
					end if;
		  else -- not direct dest
			f <= "11011";
			flag2 := '1';
		  end if;
		else
		  f <= na; 
	  end if;
	end if;  
  end process;               
END arch1;  