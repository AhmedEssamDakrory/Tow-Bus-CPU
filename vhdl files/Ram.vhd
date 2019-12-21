
-- Simple generic RAM Model

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity sync_ram is
  port (
    clock   : in  std_logic;
    we      : in  std_logic;
    address : in  std_logic_vector(15 downto 0);
    datain  : in  std_logic_vector(15 downto 0);
    dataout : out std_logic_vector(15 downto 0)
  );
end entity sync_ram;

architecture RTL of sync_ram is

   type ram_type is array (0 to (2**16)) of std_logic_vector(15 Downto 0);
   signal read_address : std_logic_vector(15 downto 0);
   
   impure function init_ram (ram_file_name : in string) return ram_type is
   file ramfile : text is in ram_file_name;
   variable line_read : line;
   variable ram_to_return : ram_type;
   begin
    for i in ram_type'range loop
     if endfile(ramfile) then exit;
     end if;
     readline(ramfile, line_read);
     read(line_read, ram_to_return(i));
    end loop;
   return ram_to_return;
   end function;
   
   signal Ram : ram_type := init_ram("ram1.dat");
  
begin

  RamProc: process(clock) is

  begin
    if rising_edge(clock) then
      if we = '1' then
        ram(to_integer(unsigned(address))) <= datain;
      end if;
      read_address <= address;
    end if;
  end process RamProc;

  dataout <= ram(to_integer(unsigned(read_address)));

end architecture RTL;
