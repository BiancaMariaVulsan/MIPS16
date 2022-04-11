----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.02.2022 23:25:59
-- Design Name: 
-- Module Name: ArithmLU - Behavioral
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

entity ArithmLU is
    Port ( clk : in STD_LOGIC;
         mpg_en : in STD_LOGIC;
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         digits : out STD_LOGIC_VECTOR (15 downto 0);
         leds : out STD_LOGIC_VECTOR (15 downto 0));
end ArithmLU;

architecture Behavioral of ArithmLU is
    signal sel: STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal digits_aux : STD_LOGIC_VECTOR (15 downto 0);
begin

    count: process(mpg_en, clk)
    begin
        if rising_edge(clk) then
            if mpg_en = '1' then
                sel <= sel + '1';
            end if;
        end if;
    end process;

    mux: process(sel, sw)
    begin
        case sel is
            when "00" => digits_aux <= (X"000" & sw(3 downto 0)) + (X"000" & sw(7 downto 4));
            when "01" => digits_aux <= (X"000" & sw(3 downto 0)) - (X"000" & sw(7 downto 4));
            when "10" => digits_aux <= sw(13 downto 0) & "00";
            when others => digits_aux <= X"00" & "00" & sw(7 downto 2);
        end case;
        digits <= digits_aux;
    end process;

    zero_detector: process(digits_aux)
    begin
        if digits_aux = X"0000" then
            leds(7) <= '1';
        else
            leds(7) <= '0';
        end if;
    end process;

end Behavioral;
