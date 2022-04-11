----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2022 13:53:22
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (3 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

    -- mpg, counter, lab1
    signal s_counter        : std_logic_vector(15 downto 0) := X"0000";
    signal mpg_counter_enable : std_logic                     := '0';

    -- SSD, ALU, lab2
    signal digits_temp        : std_logic_vector(15 downto 0) := X"0000";
    signal digits_aux_alu      : std_logic_vector(15 downto 0) := X"0000";
    signal digits_aux_ram      : std_logic_vector(15 downto 0) := X"0000";
    signal digits_aux_rom      : std_logic_vector(15 downto 0) := X"0000";
    signal digits_aux_reg      : std_logic_vector(15 downto 0) := X"0000";
    
    -- lab 5 instruction fetch
    signal digits_temp_instr   : std_logic_vector(15 downto 0) := X"0000";
    signal digits_temp_pc      : std_logic_vector(15 downto 0) := X"0000";

    -- register file, lab3
    signal RegWr : std_logic                     := '0';
    signal reset : std_logic                     := '0';
    signal rd1_temp, rd2_temp, ram_out : std_logic_vector(15 downto 0) := x"0000";
    signal addr_counter : std_logic_vector(3 downto 0) := "0000";

    -- ROM, lab3
--    signal ROM_addrCnt : std_logic_vector(7 downto 0) := x"00";
--    type ROM_type is array(0 to 255) of std_logic_vector(15 downto 0);
--    signal ROM: ROM_type := (x"0001", x"0002", x"0003", x"0004", x"0005", x"0006",
--                                                          others => x"0000"); -- random values
     
    -- ID lab6
    signal Ext_Imm: std_logic_vector(15 downto 0):=X"0000";
    signal func: std_logic_vector(2 downto 0):="000";
    signal sa: std_logic:= '0';
    signal RegDst : std_logic:= '0';
    signal ExtOp : std_logic:= '0';
    
    -- Control Unit
    signal AluSrc : std_logic:= '0';
    signal Branch : std_logic:= '0';
    signal Jump : std_logic:= '0';
    signal ALUOp : std_logic_vector(2 downto 0):="000";
    signal MemWrite : std_logic:= '0';
    signal MemtoReg : std_logic:= '0';
    
    -- Execution unit lab7
      signal zero: std_logic:='0';
      signal BranchAddress: std_logic_vector (15 downto 0) := x"0000";
      signal ALURes: std_logic_vector (15 downto 0) := x"0000";
      signal PCSrc: std_logic:='0';
      
     -- lab8
     signal ALUResFinal: std_logic_vector (15 downto 0) := x"0000";
     signal MemData: std_logic_vector(15 downto 0);
     signal WriteDataReg: std_logic_vector(15 downto 0);
     signal JumpAddress:std_logic_vector(15 downto 0);
     signal RegWriteEnable : std_logic:= '0'; 
     signal MemWriteEnable : std_logic:= '0'; 
      
    -- declare MPG
    component mpg
        Port( clk    : in  STD_LOGIC;
             btn    : in  STD_LOGIC;
             enable : out STD_LOGIC);
    end component;

    -- declare SSD    
    component SSD is
        Port ( clk : in STD_LOGIC;
             an : out STD_LOGIC_VECTOR (3 downto 0);
             cat : out STD_LOGIC_VECTOR (6 downto 0);
             digit : in STD_LOGIC_VECTOR (15 downto 0));
    end component;

     -- declare ALU, lab2 
        component ArithmLU is
            Port ( mpg_en : in STD_LOGIC;
                 sw : in STD_LOGIC_VECTOR (15 downto 0);
                 clk : in STD_LOGIC;
                 digits : out STD_LOGIC_VECTOR (15 downto 0);
                 leds : out STD_LOGIC_VECTOR (15 downto 0));
        end component;

    -- declare Reg File, lab3
--    component RF is
--        Port ( RA1 : in STD_LOGIC_VECTOR (3 downto 0);
--             RA2 : in STD_LOGIC_VECTOR (3 downto 0);
--             WA : in STD_LOGIC_VECTOR (3 downto 0);
--             WD : in STD_LOGIC_VECTOR (15 downto 0);
--             Wen : in std_logic;
--             clk : in STD_LOGIC;
--             RD1 : out STD_LOGIC_VECTOR (15 downto 0);
--             RD2 : out STD_LOGIC_VECTOR (15 downto 0));
--    end component;

    -- declare RAM, lab3
    component RAM_WriteFirst is
        Port ( clk : in STD_LOGIC;
             we : in STD_LOGIC;
             addr : in STD_LOGIC_VECTOR (3 downto 0);
             di : in STD_LOGIC_VECTOR (15 downto 0);
             do : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    --  lab5
    component IFetch is
        Port ( clk : in STD_LOGIC;
           brench_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jump_addr: in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           jump : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           PCOut : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    -- lab6
    component ID is
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
    end component;
    
    -- lab6
    component ControlUnit is                                
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
    end component;  
    
    component ExecutionUnit is
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
    end component;
    
component DataMemory is
    Port ( 	clk: in std_logic;
			WriteData: in std_logic_vector(15 downto 0);
			Address: in std_logic_vector(15 downto 0);
			MemWrite: in std_logic;			
			MemData:out std_logic_vector(15 downto 0);
			ALURes :out std_logic_vector(15 downto 0));
end component;                                 

begin

    PCSrc <= zero and Branch;
    JumpAddress <= digits_temp_pc(15 downto 13) & digits_temp_instr(12 downto 0);
    
    instr_fetch: IFetch
    Port map( clk => clk,
           brench_addr => BranchAddress,
           jump_addr => JumpAddress,
           PCSrc => PCSrc,
           jump => Jump,
           en => mpg_counter_enable,
           reset => reset,
           instruction => digits_temp_instr,
           PCOut => digits_temp_pc
           );
           
    -- instantiate MPG
    monopuls_1 : mpg
        port map(
            clk    => clk,
            btn    => btn(1),
            enable => mpg_counter_enable
        );

    -- instantiate MPG for the reg file write enable
--    monopuls_2 : mpg
--        port map(
--            clk    => clk,
--            btn    => btn(2),
--            enable => RegWr
--        );
    
    -- instantiate MPG for reset   
    monopuls_3 : mpg
        port map(
            clk    => clk,
            btn    => btn(0),
            enable => reset
        );

    -- instantiate SSD
    seven_seg: SSD
        port map(
            clk   => clk,
            an    => an,
            cat   => cat,
            digit => digits_temp
        );

 -- instantiate ALU 
--    alu: ArithmLU
--        port map(
--            mpg_en => mpg_counter_enable,
--            sw     => sw,
--            clk    => clk,
--            digits => digits_aux_alu,
--            leds   => led
--        );

    RAM_memory: RAM_WriteFirst
        port map ( clk => clk,
                 we => mpg_counter_enable,
                 addr => addr_counter,
                 di => digits_aux_ram,
                 do => ram_out);
                 
    digits_aux_ram <= ram_out(14 downto 0) & '0';
    
--    register_file: RF
--        port map ( RA1 => addr_counter,
--                 RA2 => addr_counter,
--                 WA => addr_counter,
--                 WD => digits_aux_reg,
--                 Wen => mpg_counter_enable,
--                 clk => clk,
--                 RD1 => rd1_temp,
--                 RD2 => rd2_temp);

      RegWriteEnable <= RegWr and mpg_counter_enable;           
      instr_decode: ID
        port map ( clk => clk,
           instr  => digits_temp_instr,
           WriteData  => WriteDataReg,
           RegWrite  => RegWriteEnable,
           RegDst  => RegDst,
           ExtOp  => ExtOp,
           RD1  => rd1_temp,
           RD2  => rd2_temp,
           Ext_Imm  => Ext_Imm,
           sa  => sa,
           func  => func
           );
      digits_aux_reg <= rd1_temp + rd2_temp;

           
      control_unit: ControlUnit                                
        port map ( opcode  => digits_temp_instr(15 downto 13),
           RegDst  => RegDst,                 
           ExtOp  => ExtOp,                    
           AluSrc  => AluSrc,                   
           Branch  => Branch,                   
           Jump  => Jump,                     
           ALUOp  => ALUOp,
           MemWrite  => MemWrite,                 
           MemtoReg  => MemtoReg,                 
           RegWrite  => RegWr                
           );
           
       execution_unit: ExecutionUnit
        port map ( RD1 => rd1_temp, 
           RD2 => rd2_temp,
           Ext_Imm => Ext_Imm,
           PCOut => digits_temp_pc,
           func => func,
           sa => sa,
           ALUOp => ALUOp,
           ALUSrc => ALUSrc,
           ALURes => ALURes,
           BranchAddress => BranchAddress,
           zero => zero
           );
           
        MemWriteEnable <= mpg_counter_enable and MemWrite;
        MEMORY: DataMemory
            port map ( 	clk => clk,
			WriteData => rd2_temp,
			Address => ALURes,
			MemWrite => MemWriteEnable,			
			MemData => MemData,
			ALURes => ALUResFinal);
			
	-- MUX MEM_ALU -> WriteRegister
    process(MemtoReg,ALUResFinal,MemData)
    begin
        case (MemtoReg) is
            when '1' => WriteDataReg<=MemData;
            when others => WriteDataReg<=ALUResFinal;
        end case;
    end process;

    -- for reg file
    count_address_4bit: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                addr_counter <= "0000";
            elsif mpg_counter_enable = '1' then -- using the same signal for write enable and increment, 3.3.2
                addr_counter <= addr_counter + '1';
            end if;
        end if;
    end process;

--    -- ROM, lab3
--    digits_aux_rom <= ROM(conv_integer(ROM_addrCnt));
        
--    -- for ROM
--    count_address_8bit: process(clk)
--    begin
--        if rising_edge(clk) then
--            if mpg_counter_enable = '1' then
--                ROM_addrCnt <= ROM_addrCnt + 1;
--            elsif reset = '1' then
--                ROM_addrCnt <= x"00";
--            end if;
--        end if;
--    end process;
    
    -- display the intermmediate signals
--    choose_output: process(sw, digits_aux_alu, digits_aux_rom, digits_aux_reg, digits_aux_ram)
--    begin
--        case sw(15 downto 13) is
--        when "000" => digits_temp <= digits_aux_alu;
--        when "001" => digits_temp <= digits_aux_rom;
--        when "010" => digits_temp <= digits_aux_reg;
--        when "011" => digits_temp <= digits_aux_ram;
--        when others => digits_temp <= x"0000";
--        end case;
--    end process;
    
    -- lab5: display the output
--    digits_temp <= digits_temp_instr when sw(7) = '1' else digits_temp_pc;

    -- lab6: display output
--    choose_output: process(sw, digits_aux_alu, digits_aux_rom, digits_aux_reg, digits_aux_ram)
--    begin
--        case sw(7 downto 5) is
--        when "000" => digits_temp <= digits_temp_instr;
--        when "010" => digits_temp <= rd1_temp;
--        when "011" => digits_temp <= rd2_temp;
--        when others => digits_temp <= digits_aux_reg;
--        end case;
--    end process;

    -- lab7: display output
    choose_output: process(sw, digits_aux_alu, digits_temp_pc, AluRes, MemData, rd1_temp, rd2_temp, Ext_Imm, WriteDataReg)
    begin
        case sw(7 downto 5) is
        when "000" => digits_temp <= digits_temp_instr;
        when "001" => digits_temp <= digits_temp_pc;
        when "010" => digits_temp <= rd1_temp;
        when "011" => digits_temp <= rd2_temp;
        when "100" => digits_temp <= Ext_Imm;
        when "101" => digits_temp <= MemData;
        when "110" => digits_temp <= WriteDataReg;
        when others => digits_temp <= AluRes;
        end case;
    end process;
    
    -- MUX pentru afisarea pe leduri a semnalelor de control
    process(RegDst,ExtOp,ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWr,sw,func)
    begin
        if sw(0)='0' then		
            led(7)<=RegDst;
            led(6)<=ExtOp;
            led(5)<=ALUSrc;
            led(4)<=Branch;
            led(3)<=Jump;
            led(2)<=MemWrite;
            led(1)<=MemtoReg;
            led(0)<=RegWr;
        else
            led(2 downto 0)<=ALUOp;
            led(7 downto 3)<="00000";
        end if;
    end process;
    
    count: process(clk)
    begin
        if rising_edge(clk) then
            if mpg_counter_enable = '1' then
                s_counter <= s_counter + 1;
            end if;
        end if;
    end process;

end Behavioral;
