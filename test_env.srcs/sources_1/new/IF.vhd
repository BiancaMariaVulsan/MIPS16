----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2022 14:30:35
-- Design Name: 
-- Module Name: IF - Behavioral
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

entity IFetch is
    Port ( clk : in STD_LOGIC;
           brench_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jump_addr: in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           jump : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           PCOut : out STD_LOGIC_VECTOR (15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal Mux1: STD_LOGIC_VECTOR (15 downto 0):= x"0000";
signal Mux2: STD_LOGIC_VECTOR (15 downto 0):= x"0000";
signal PC1: STD_LOGIC_VECTOR (15 downto 0):= x"0000";
signal PC: STD_LOGIC_VECTOR (15 downto 0):= x"0000";

component ROM is
    Port ( addr : in STD_LOGIC_VECTOR (15 downto 0);
           data : out STD_LOGIC_VECTOR (15 downto 0));
end component;

begin

    rom_memm: ROM
    Port map( addr => PC,
           data => instruction
           );

    count: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                PC <= x"0000";
            elsif en = '1' then
                PC <= Mux2;
            end if;
        end if;
    end process;

    PC1 <= PC + '1';
    PCOut <= PC1;
    
    Mux1 <= brench_addr when PCSrc='1' else PC1;
    Mux2 <= jump_addr when jump='1' else Mux1;

end Behavioral;
