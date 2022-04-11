----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2022 11:40:23
-- Design Name: 
-- Module Name: ExecutionUnit - Behavioral
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

entity ExecutionUnit is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           PCOut : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc : in STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR (15 downto 0);
           zero : out STD_LOGIC);
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

signal ALUCtrl : STD_LOGIC_VECTOR (2 downto 0);
signal ALU2 : STD_LOGIC_VECTOR (15 downto 0);
signal ALURes2 : STD_LOGIC_VECTOR (15 downto 0);

begin

ALU2 <= RD2 when ALUSrc <= '0' else Ext_Imm;

ComputeBranchAddr: BranchAddress <= PCOut + Ext_Imm; 

ALUControl: process(ALUOp)
     begin
     case ALUOp is
         when "000" => -- R type
            case func is
                when "000" => ALUCtrl <= "000"; -- add
                when "001" => ALUCtrl <= "001"; -- sub
                when "010" => ALUCtrl <= "010"; -- sll
                when "011" => ALUCtrl <= "011"; -- srl
                when "100" => ALUCtrl <= "100"; -- and
                when "101" => ALUCtrl <= "101"; -- or
                when "110" => ALUCtrl <= "110"; -- xor
                when others => ALUCtrl <= "111"; -- nand
            end case;
         when "001" => ALUCtrl <= "000"; -- addi => +
         when "010" => ALUCtrl <= "000"; -- lw => +
         when "011" => ALUCtrl <= "000"; -- sw => +
         when "100" => ALUCtrl <= "001"; -- beq => -
         when "101" => ALUCtrl <= "001"; -- subi => -
         when "110" => ALUCtrl <= "101"; -- lui => or
         when others => ALUCtrl <= "000"; -- jump
     end case;
     end process;
     
ALU: process(ALUCtrl, RD1, sa, func)
     begin
     case ALUCtrl is
         when "000" => ALURes2 <= RD1 + ALU2;
         when "001" => ALURes2 <= RD1 - ALU2;
         when "010" => 
                if sa = '0' then 
                    ALURes2 <= RD1;
                else 
                    ALURes2 <= RD1(14 downto 0) & '0';
                end if;
         when "011" =>
                if sa = '0' then 
                    ALURes2 <= RD1;
                else 
                    ALURes2 <= '0' & RD1(15 downto 1);
                end if;
         when "100" => ALURes2 <= RD1 and ALU2;
         when "101" => ALURes2 <= RD1 or ALU2;
         when "110" => ALURes2 <= RD1 xor ALU2;
         when others => ALURes2 <= RD1 nand ALU2;
     end case;
     zero <= '1' when ALURes2 = "000" else '0';
     end process;
     
    ZeroDetection:process(ALURes2)
    begin 
        if ALURes2 = X"0000" then 
            zero <= '1';
        else 
            zero <= '0';
        end if;
    end process;
     
     ALURes <= ALURes2;

end Behavioral;
