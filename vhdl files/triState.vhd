LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY TRI_STATE IS
  GENERIC(N : INTEGER := 16);
  PORT(ENABLE : IN STD_LOGIC;
  data_in : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
  data_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) );
END TRI_STATE;

ARCHITECTURE TS OF TRI_STATE IS
BEGIN
    PROCESS(ENABLE , data_in )
      BEGIN
        IF ENABLE = '1' THEN
          data_out <= data_in ;
        ELSE
          data_out <= (OTHERS => 'Z');
        END IF;
    END PROCESS;
END TS;