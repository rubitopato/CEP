-- Circuito de selección de 16 periféricos de entrada, realizado mediante un multiplexor
-- con un registro a su salida

-- Incluye un camino sin registro de salida, especial para conectar memorias de
-- capacidad hasta 128 posiciones de 8 bits como periféricos de entrada
-- La memoria se selecciona cuando el bit de mayor peso (bit 7) de port_id(7:0) vale uno

-- No incluye registros individuales para cada puerto de entrada, por lo que la información
-- de cada puerto debe ser estable antes de entrar al multiplexor

-- Realizado por Luis Jacobo Álvarez Ruiz de Ojeda el 27/6/2005.
-- Dpto. Tecnología Electrónica.
-- Universidad de Vigo

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity selec_16_entradas_con_reg_y_bypass is
    Port ( puerto_00_in : in std_logic_vector(7 downto 0);
           puerto_01_in : in std_logic_vector(7 downto 0);
			  puerto_02_in : in std_logic_vector(7 downto 0);
			  puerto_03_in : in std_logic_vector(7 downto 0);
			  puerto_04_in : in std_logic_vector(7 downto 0);
           puerto_05_in : in std_logic_vector(7 downto 0);
			  puerto_06_in : in std_logic_vector(7 downto 0);
			  puerto_07_in : in std_logic_vector(7 downto 0);
			  puerto_08_in : in std_logic_vector(7 downto 0);
           puerto_09_in : in std_logic_vector(7 downto 0);
			  puerto_0A_in : in std_logic_vector(7 downto 0);
			  puerto_0B_in : in std_logic_vector(7 downto 0);
			  puerto_0C_in : in std_logic_vector(7 downto 0);
           puerto_0D_in : in std_logic_vector(7 downto 0);
			  puerto_0E_in : in std_logic_vector(7 downto 0);
			  puerto_0F_in : in std_logic_vector(7 downto 0);
			  mem_in : in std_logic_vector(7 downto 0);
           port_id : in std_logic_vector(7 downto 0);
           reset : in std_logic;
           clk_micro : in std_logic;
           in_port : out std_logic_vector(7 downto 0));
end selec_16_entradas_con_reg_y_bypass;

architecture Behavioral of selec_16_entradas_con_reg_y_bypass is

signal sel: std_logic_vector (3 downto 0):=(others => '0');		-- Selección de canal del multiplexor de 16 canales
signal muxout: std_logic_vector (7 downto 0):=(others => '0');	-- Salida del multiplexor de 8 bits
signal regout: std_logic_vector (7 downto 0):=(others => '0');	-- Salida del registro de 8 bits

begin

-- Utiliza solamente los 4 bits de menor peso de port_id(7:0) del microcontrolador
-- para seleccionar el puerto de entrada
sel <= port_id (3 downto 0);

-- Descripción del multiplexor de 16 canales de 8 bits para los puertos de entrada
process  (sel,
			 puerto_00_in, puerto_01_in, puerto_02_in, puerto_03_in,
			 puerto_04_in, puerto_05_in, puerto_06_in, puerto_07_in,
			 puerto_08_in, puerto_09_in, puerto_0A_in, puerto_0B_in,
			 puerto_0C_in, puerto_0D_in, puerto_0E_in, puerto_0F_in
			)
begin

	Case sel is
		when "0000" =>  muxout <= puerto_00_in;
		when "0001" =>  muxout <= puerto_01_in;
		when "0010" =>  muxout <= puerto_02_in;
		when "0011" =>  muxout <= puerto_03_in;
		when "0100" =>  muxout <= puerto_04_in;
		when "0101" =>  muxout <= puerto_05_in;
		when "0110" =>  muxout <= puerto_06_in;
		when "0111" =>  muxout <= puerto_07_in;
		when "1000" =>  muxout <= puerto_08_in;
		when "1001" =>  muxout <= puerto_09_in;
		when "1010" =>  muxout <= puerto_0A_in;
		when "1011" =>  muxout <= puerto_0B_in;
		when "1100" =>  muxout <= puerto_0C_in;
		when "1101" =>  muxout <= puerto_0D_in;
		when "1110" =>  muxout <= puerto_0E_in;
		when "1111" =>  muxout <= puerto_0F_in;
		when others => muxout <= "00000000";
	end case;

end process;

-- Descripción del registro de 8 bits que permite aumentar la máxima frecuencia de reloj
-- aplicable al sistema formado por el microcontrolador Picoblaze y sus periféricos
-- Se conecta entre el multiplexor de selección de datos de los periféricos de entrada
-- y la entrada de datos del microcontrolador (IN_PORT)
process (clk_micro, reset)
begin
   if reset='1' then
         regout <= "00000000";  	-- Puesta a cero asíncrona del registro
   elsif (clk_micro'event and clk_micro='1') then
         regout <= muxout;			-- Entrada síncronizada
   end if;
end process;

-- Descripción del multiplexor de 2 canales de 8 bits que permite seleccionar entre el
-- camino con registro (normal) y el camino sin registro (bypass) para la memoria
in_port <= 	regout when (port_id(7)='0') else
				mem_in when (port_id(7)='1') else
				"00000000";

end Behavioral;
