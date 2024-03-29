----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.02.2022 21:38:07
-- Design Name: 
-- Module Name: Combinational_Shifter - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Combinational_Shifter is
    Port ( sw : in STD_LOGIC_VECTOR (7 downto 0);
         led : out STD_LOGIC_VECTOR (4 downto 0));
end Combinational_Shifter;

architecture Behavioral of Combinational_Shifter is

signal shift1: STD_LOGIC_VECTOR (4 downto 0);
signal shift2: STD_LOGIC_VECTOR (4 downto 0);

begin

    process(sw)
    begin
        if sw(5) = '1' then -- shift with 1 position
            if sw(7) = '0' then
                shift1 <= sw(3 downto 0) & '0'; -- shift left
            else
                shift1 <= sw(4) & sw(4 downto 1); -- shift right arithmetic
            end if;
        else
            shift1 <= sw(4 downto 0);
        end if;
    end process;

    process(sw, shift1)
    begin
        if sw(6) = '1' then -- shift with 2 position
            if sw(7) = '0' then
                shift2 <= shift1(2 downto 0) & "00"; -- shift left
            else
                shift2 <= shift1(4) & shift1(4) & shift1(4 downto 2); -- shift right arithmetic
            end if;
        else
            shift2 <= shift1;
        end if;
    end process;

    led <= shift2;

end Behavioral;
