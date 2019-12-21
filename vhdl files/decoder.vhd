LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY decoder IS
  GENERIC ( N : INTEGER := 3 ) ;
	PORT( grp : in std_logic_vector(N-1 downto 0);
	      signals : out std_logic_vector ( (2**N)-1 downto 0)
	     	 );
END ENTITY decoder;


ARCHITECTURE arch1 of decoder IS

BEGIN  
  
signals <= ( to_integer(unsigned(grp)) => '1' , others=>'0' );

END arch1;  
