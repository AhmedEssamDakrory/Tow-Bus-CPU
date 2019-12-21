library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;
entity ALU is
    port(
        clk:in std_logic;
        Operation:in std_logic_vector(27 downto 0);
        A,Dstin :in std_logic_vector(16 downto 0);
        F:out std_logic_vector(15 downto 0)
    );
end ALU;
architecture ALU_arcitecture of ALU is
    component Register_entity is
        PORT(
        d   : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
        Load  : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        q   : OUT STD_LOGIC_VECTOR(16 DOWNTO 0));
    end component;
            -----------Register Flag----------------
            --|x|x|x|x|x|x|x|x|x|x|PF|OF|DF|SF|ZF|CF|-
            -----------------------------------------
    -------------------------Falgs Register Signals----------------------
    signal UpdateFlags,OutFlag:std_logic_vector(16 downto 0);
    signal LoadFlags,ClearFlags:std_logic;

    ------------------------Destination Register Signals-----------------
    signal DstOut:std_logic_vector(16 downto 0);
    signal ClearDst:std_logic;

    signal result:std_logic_vector(16 downto 0);

    function CheckParity (F: in std_logic_vector)
    return std_logic is
    variable PF : std_logic := '1';
    begin
    for i in 0 to F'length-1 loop
      PF := PF xor F(i);
    end loop;
    return PF;
    end function CheckParity;

    function CheckZero (F: in std_logic_vector)
    return std_logic is
    variable Zero : std_logic := '0';
    begin
    for i in 0 to F'length-1 loop
      Zero := Zero or F(i);
    end loop;
    return Zero;
    end function CheckZero;
begin
    FlagRegister:Register_entity port map(UpdateFlags,LoadFlags,ClearFlags,clk,OutFlag);
    DstRegister:Register_entity port map(Dstin,load=>'1',clr=>ClearDst,clk=>clk,q=>DstOut);
    process(clk,LoadFlags,ClearFlags,ClearDst,UpdateFlags,OutFlag,Operation,result)
    Variable Carry:std_logic:=OutFlag(0);
    Variable Zero:std_logic:=OutFlag(1);
    Variable Fvariable:std_logic_vector(15 downto 0):=result(15 downto 0);
    begin
        if Operation(0)='1' then--A+1
            result<= std_logic_vector(signed(A)+1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=result(16);
        elsif Operation(1)='1' or Operation(4)='1' then--A+B
            result<=std_logic_vector(signed(A)+signed(DstOut));
            F<=result(15 downto 0);
            UpdateFlags(0)<=result(16);
        elsif Operation(2)='1' then--A-1
            result<=std_logic_vector(signed(A)-1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=result(16);
        elsif Operation(3)='1' then--Nop A
            result<=A;
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(5)='1' then--A+B+Carry
            result<=std_logic_vector(signed(A)+signed(DstOut)+signed(std_logic_vector(to_unsigned(0, 15))&std_logic(OutFlag(0))));
            F<=result(15 downto 0);
            UpdateFlags(0)<=result(16);
        elsif Operation(6)='1' then--B-A
            result<=std_logic_vector(signed(DstOut)-signed(A));
            F<=result(15 downto 0);
            UpdateFlags(0)<=result(16);
        elsif Operation(7)='1' then--B-A-Carry
            result<=std_logic_vector(signed(DstOut)-signed(A)-signed(std_logic_vector(to_unsigned(0, 15))&std_logic(OutFlag(0))));
            F<=result(15 downto 0);
            UpdateFlags(0)<=result(16);
        elsif Operation(8)='1' then--A and b
            result<=A and DstOut;
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(9)='1' then--A or B
            result<=A or DstOut;
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(10)='1' then--A xnor B
            result<=A xnor DstOut;
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(11)='1' then--B+1
            result<=std_logic_vector(signed(DstOut)+1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=result(16);
        elsif Operation(12)='1' then--B-1
            result<=std_logic_vector(signed(DstOut)-1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=result(16);
        elsif Operation(13)='1' then--F=0
            result<= (others => '0');
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(14)='1' then--Inv B
            result<= not DstOut;
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(15)='1' then--Logical shift right B
            result<=std_logic_vector(unsigned(DstOut) srl 1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(16)='1' then --Rotate right
            result(15 downto 0)<= std_logic_vector(unsigned(DstOut (15 downto 0)) ror 1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(17)='1' then--Roate Right with carry
            UpdateFlags(0)<=DstOut(0);
            result <= std_logic_vector(unsigned(DstOut) srl 1);
            result(15)<=Carry;
            F<=result(15 downto 0);
        elsif Operation(18)='1' then--Arithmatic shift right
            result(15)<=DstOut(15);
            result(14 downto 0) <= std_logic_vector(signed(DstOut(14 downto 0)) srl 1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(19)='1' then--logical shift left
            result<=std_logic_vector(unsigned(DstOut) sll 1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(20)='1' then--rotate left
            result(15 downto 0) <= std_logic_vector(unsigned(DstOut (15 downto 0)) rol 1);
            F<=result(15 downto 0);
            UpdateFlags(0)<=OutFlag(0);
        elsif Operation(21)='1' then--rotate left with carry
            UpdateFlags(0)<=DstOut(15);
            result(15 downto 0) <= std_logic_vector(unsigned(DstOut (15 downto 0)) sll 1);
            result(0)<=Carry;
            F<=result(15 downto 0);     
        end if;
        ---------Update Flags--------------------------
        LoadFlags<='1';
        Fvariable:=result(15 downto 0);
        Carry:=OutFlag(0);
        Zero:=OutFlag(1);
        UpdateFlags(1)<=(not CheckZero(Fvariable));---ZF---(1:Zero,0:else)
        UpdateFlags(4)<=Carry and Zero; --OF
        UpdateFlags(2)<=Fvariable(15);--SF
        UpdateFlags(5)<=CheckParity(Fvariable);--PF--(1:even,0:odd)
        
    end process;
end ALU_arcitecture;