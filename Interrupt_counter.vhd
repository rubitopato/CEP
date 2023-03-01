----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2022 20:06:00
-- Design Name: 
-- Module Name: Interrupt_counter - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Interrupt_counter is
    Port ( clk : in STD_LOGIC;
           clk_en : in STD_LOGIC;
           reset : in STD_LOGIC;
           output : out STD_LOGIC);
end Interrupt_counter;

architecture Behavioral of Interrupt_counter is

signal count : std_logic_vector(10 downto 0):="00000000000";
begin

process(clk,clk_en) 
begin

      if(clk'event and clk='1') then
         if(reset='1') then
          output<='0';
          count<="00000000000";
          elsif(count="1111101000") then --
          output<='1';
          count<="00000000000";
          --elsif(count="11111010000") then --
          --output<='0';
          --count<="00000000000";
          --elsif (count="101111101011110000100000001") then
--          output<='1';
--          count<="000000000000000";
          elsif(clk_en='1') then
          count<=count + 1;
          output<='0';
          else
          output<='0';
          count<=count;
        end if;
    else
     -- output<='0';
      count<=count;
    end if;
end process;

end Behavioral;
