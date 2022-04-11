----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.03.2022 22:02:14
-- Design Name: 
-- Module Name: RAM_WriteFirst - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM_WriteFirst is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (3 downto 0);
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0));
end RAM_WriteFirst;

architecture Behavioral of RAM_WriteFirst is

type RAM_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal RAM: ram_type := (x"0001", x"0002", x"0003", x"0004", x"0005", x"0006", others => x"0000");

begin

    process (clk)
    begin
        if clk'event and clk = '1' then
            if we = '1' then
                RAM(conv_integer(addr)) <= di;
                do <= di;
            else
               do <= RAM( conv_integer(addr));
            end if;
        end if;
    end process;

end Behavioral;
