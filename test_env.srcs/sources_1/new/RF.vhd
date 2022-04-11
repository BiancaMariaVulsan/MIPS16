----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.03.2022 13:18:10
-- Design Name: 
-- Module Name: RF - Behavioral
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

entity RF is
    Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           Wen : in std_logic;
           clk : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end RF;

architecture Behavioral of RF is

type register_type is array(0 to 255) of std_logic_vector(0 to 15);
signal Rf_sig: register_type := (x"0001", x"0002", x"0003", x"0004", x"0005", x"0006", x"0007", x"0008", x"0009", others => x"0000");

begin

    process(clk)
    begin
        if clk = '0' and falling_edge(clk) then
            if wen = '1' then
                Rf_sig(conv_integer(WA)) <= WD;
            end if;
        end if;
    end process;
    
    RD1 <= Rf_sig(conv_integer(RA1));
    RD2 <= Rf_sig(conv_integer(RA2));

end Behavioral;
