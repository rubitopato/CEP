library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_FD8CE is
    Port ( D : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           Q : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           clr : in STD_LOGIC);
end register_FD8CE;

architecture Behavioral of register_FD8CE is
signal qaux: std_logic_vector(7 DOWNTO 0);

begin
Q<= qaux;
    process(clk)
        begin
            if(clr='1') then
                qaux<="00000000";
            elsif(clk = '1' and clk'event) then
                if(ce='1') then
                    qaux<=D;
                else
                    qaux<=qaux;
                end if;
            end if;
  
    end process;

end Behavioral;
