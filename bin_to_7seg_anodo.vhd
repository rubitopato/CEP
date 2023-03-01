-- Decodificador de binario a 7 segmentos para visualizadores de
-- anodo comun
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bin_to_7seg_anodo is
    Port ( en : in std_logic;
           DIN : in std_logic_vector(7 downto 0);
           output : out std_logic_vector(7 downto 0)
           );
end bin_to_7seg_anodo;

architecture Behavioral of bin_to_7seg_anodo is
signal entradas_dec: std_logic_vector (3 downto 0);
signal segmentos: std_logic_vector (7 downto 0);

begin
    entradas_dec<=DIN(3 downto 0);
	With entradas_dec select

	-- El orden de los segmentos es G,F,E,D,C,B,A
	segmentos <= "11111100" when "0000",  --0
					 "01100000" when "0001",  --1
					 "11011010" when "0010",	--2
					 "11110010" when "0011",	--3
					 "01100110" when "0100",	--4
					 "10110110" when "0101",	--5
					 "10111110" when "0110",	--6
					 "11100000" when "0111",	--7
					 "11111110" when "1000",	--8
					 "11100110" when "1001",	--9
					 "11101110" when "1010",	--A
					 "00111110" when "1011",	--b
					 "10011100" when "1100",	--C
					 "01111010" when "1101",	--d
					 "10011110" when "1110",	--E
					 "10001110" when "1111",	--F
					 "00000000" when others;	-- Todos los LEDs apagados

output<=segmentos;



end Behavioral;
