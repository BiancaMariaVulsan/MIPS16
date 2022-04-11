----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2022 13:15:35
-- Design Name: 
-- Module Name: DataMemory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataMemory is
    Port ( 	clk: in std_logic;
			WriteData: in std_logic_vector(15 downto 0);
			Address: in std_logic_vector(15 downto 0);
			MemWrite: in std_logic;			
			MemData:out std_logic_vector(15 downto 0);
			ALURes :out std_logic_vector(15 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

type ram_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal RAM:ram_type:=(
		X"000A",
		X"000B",
		X"000C",
		X"000D",
		X"000E",
		X"000F",
		X"0001",
		X"0002",	
		others =>X"0000");

begin

process(clk) 			
begin
	if(rising_edge(clk)) then
			if MemWrite='1' then
				RAM(conv_integer(Address))<=WriteData;			
			end if;
		end if;	
end process;

MemData<=RAM(conv_integer(Address));
ALURes<=Address;

end Behavioral;
