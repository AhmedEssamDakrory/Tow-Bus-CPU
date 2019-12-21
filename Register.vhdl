LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Register_entity IS
 PORT(
    d   : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    Load  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    q   : OUT STD_LOGIC_VECTOR(16 DOWNTO 0) 
);
END Register_entity;
ARCHITECTURE arch_register OF Register_entity IS

BEGIN
    process(clk, clr)
    begin
        if clr = '1' then
            q <= "00000000000000000";
        elsif rising_edge(clk) then
            if Load = '1' then
                q <= d;
            end if;
        end if;
    end process;
END arch_register;