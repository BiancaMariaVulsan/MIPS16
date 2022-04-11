----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2022 13:18:52
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( clk : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           sa : out STD_LOGIC;
           func : out STD_LOGIC_VECTOR (2 downto 0));
end ID;

architecture Behavioral of ID is

component RF is
    Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           Wen : in std_logic;
           clk : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal write_addr : std_logic_vector(2 downto 0):= "000";
signal ExtImm: std_logic_vector(15 downto 0);

begin

    reg: RF
    Port map(
           RA1 => instr(12 downto 10),
           RA2 => instr(9 downto 7),
           WA => write_addr,
           WD => WriteData,
           Wen => RegWrite,
           clk => clk,
           RD1 => RD1,
           RD2 => RD2
           );
           
    process(ExtOp,instr)   
    begin
        case (ExtOp) is
            when '1' => 	
                    case (instr(6)) is
                        when '0' => ExtImm <= B"000000000" & instr(6 downto 0);
                        when '1' =>  ExtImm <=	B"111111111" & instr(6 downto 0);
                        when others => ExtImm <= ExtImm;
                    end case;
            when others => ExtImm <= B"000000000" & instr(6 downto 0);
        end case;
    end process;
           
     write_addr <= instr(9 downto 7) when RegDst='0' else instr(6 downto 4);
     
--     ext_unit: process(ExtOp, instr)
--     begin
--        if ExtOp = '1' then
--            if instr(6) = '1' then
--                ExtImm <= x"11" & '1' & instr(6 downto 0); 
--            else
--                ExtImm <= x"00" & '0' & instr(6 downto 0);
--            end if;
--         end if;
--     end process;
     
     sa <= instr(3);
     func <= instr(2 downto 0);
     Ext_Imm <= ExtImm;
end Behavioral;
