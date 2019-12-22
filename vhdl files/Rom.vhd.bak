library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
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
end ROM;

architecture arch of ROM is

    type rom_type is array (0 to addr_width-1) of std_logic_vector(data_width-1 downto 0);
    
    signal ROM : rom_type := (
                            "0000000000000000000", -- 0 not used
                            "0000011010000100101", -- 1 pcin,mdrout,irin,zout
                            "0000000000000000000", -- 2 not used
                            "1000010010010111111", -- 3 mdrout,srcin-a
                            "0001100100001000010", -- 4 rsrcout,f=a+b,marin-b,rd,zout*
                            "0010001110000100111", -- 5 zout,pcin,mdrout,dstin
                            "0110101110000100111", -- 6 mdrout,zout,pcin,dstin
                            "1000010010000101111", -- 7 zout,rsrcin,mdrout,srcin-a
                            "1000010000010111111", -- 8 rsrcout,srcin-a
                            "0111111000010000011", -- 9 rsrcout,marin-a,rd
                            "0011100000010000000", -- 10 rsrcout,marin-a,rd,f=a+1,zin
                            "1000010010001101111", -- 11 mdrout,srcin-a,marout,rsrcin
                            "0101101000001000010", -- 12 rsrcout,f=a-1,rd,marin-b,zout*
                            "1001100100101000010", -- 13 rdstout,f=a+b,marin-b,rd,zout*
                            "0010100001010000000", -- 14 pcout,marin-a,rd,f=a+1,zin
                            "1000010010010111011", -- 15 mdrout,srcin-a,flag
                            "1100101100110111111", -- 16 rdstout,dstin
                            "1101011000110000011", -- 17 rdstout,marin-a,rd
                            "1110000000110000000", -- 18 rdstout,marin-a,rd,f=a+1,zin
                            "1100101110010111111", -- 19 mdrout,dstin
                            "1010101000101000010", -- 20 rdstout,marin-b,rd,f=a-1,zout*
                            "0111111010010000011", -- 21 mdrout,marin-a,rd
                            "0011000001010000000", -- 22 pcout,marin-a,rd,f=a+1,zin
                            "1111100101101000111", -- 23 pcin,f=a+b,zout*,srcout
                            "1011101101000010111", -- 24 pcout,dstin,irout,srcin-b
                            "1111111001101010011", -- 25 srcout,rdstin,zout*
                            "1100101110010111011", -- 26 mdrout,dstin,flag
                            "1101011010010000011", -- 27 mdrout,marin-a,rd
                            "1100101110000110011", -- 28 zout,rdstin,mdrout,dstin
                            "1111110101101001011", -- 29 srcout,mdrin,wrt,zout*
                            "1100101110001110011", -- 30 mdrout,dstin,rdstin,marout
                            "0000100001010000000"  -- 31 pcout,marin-a,rd,zin,f=a+1
        );
begin
	process(clk)
	begin 
		if( clk'event and clk = '1' ) then
			data <= ROM(to_integer(unsigned(addr)));
		end if ;
	end process ;
end arch; 