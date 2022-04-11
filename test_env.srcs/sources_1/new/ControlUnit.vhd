----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2022 13:22:14
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
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

entity ControlUnit is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           AluSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is

begin
    process(opcode)
    begin
    case(opcode) is
        when "000" => 
        	RegDst<='1';
			ExtOp<='0';
			ALUSrc<='0';
			Branch<='0';
			Jump<='0';
			ALUOp<="000";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
    -- I type instruction
        when "001" =>  -- addi
            RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
            ALUOp <= "001";
            MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
        when "010" => -- lw
            RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
            ALUOp <= "010";
            MemWrite<='0';
			MemtoReg<='1';
			RegWrite<='1';
        when "011" => -- sw
            RegDst<='X';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
            ALUOp <= "011";
            MemWrite<='1';
			MemtoReg<='X';
			RegWrite<='0';
        when "100" => -- beq
            RegDst<='X';
			ExtOp<='1';
			ALUSrc<='0';
			Branch<='1';
			Jump<='0';
            ALUOp <= "100";
            MemWrite<='0';
			MemtoReg<='X';
			RegWrite<='0';
        when "101" => -- subi
            RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
            ALUOp <= "101";
            MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
        when "110" => -- lui
            RegDst<='X';
			ExtOp<='0';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
            ALUOp <= "110";
            MemWrite<='0';
			MemtoReg<='X';
			RegWrite<='1';
     -- J type instruction
        when others => 
            RegDst<='X';
			ExtOp<='1';
			ALUSrc<='X';
			Branch<='0';
			Jump<='1';
			ALUOp<="111";
			MemWrite<='0';
			MemtoReg<='X';
			RegWrite<='0';
    end case;
    end process;
    
end Behavioral;
