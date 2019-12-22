LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY REG IS
	GENERIC ( N : INTEGER := 16 ) ;
	PORT ( 	D			: IN 		STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;
			Resetn, Clock, Load	: IN 		STD_LOGIC ;
			Q	: OUT 	STD_LOGIC_VECTOR(N-1 DOWNTO 0) ) ;
END REG ;

ARCHITECTURE A1 OF REG IS	
BEGIN
	PROCESS ( Resetn, Clock )
	BEGIN
		IF (Resetn = '0') THEN
			Q <= (OTHERS => '0') ;
		ELSIF (FALLING_EDGE(CLOCK)) THEN
		  IF (Load ='1') THEN    
			     Q <= D ;
			END IF;
		END IF ;
	END PROCESS ;
END A1 ;

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY FlipFlop IS
	PORT ( 	D			: IN 		STD_LOGIC ;
			Resetn, Clock, Load	: IN 		STD_LOGIC ;
			Q	: OUT 	STD_LOGIC ) ;
END FlipFlop;

ARCHITECTURE A2 OF FlipFlop IS	
BEGIN
	PROCESS ( Resetn, Clock )
	BEGIN
		IF (Resetn = '0') THEN
			Q <= '0' ;
		ELSIF (FALLING_EDGE(CLOCK)) THEN
		  IF (Load ='1') THEN    
			     Q <= D ;
			END IF;
		END IF ;
	END PROCESS ;
END A2 ;