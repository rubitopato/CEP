----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:31:39 09/13/2015 
-- Design Name: 
-- Module Name:    codificador_con_prioridad_n_bits - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity codificador_con_prioridad_2_a_1 is
    Port ( cod_in : in  STD_LOGIC_VECTOR(1 DOWNTO 0);
           cod_out : out  STD_LOGIC);
end codificador_con_prioridad_2_a_1;

architecture Behavioral of codificador_con_prioridad_2_a_1 is

begin

	cod_out <= '0' when cod_in(0) = '1' else
							 '1' when cod_in(1) = '1' else
							 '0';

end Behavioral;

