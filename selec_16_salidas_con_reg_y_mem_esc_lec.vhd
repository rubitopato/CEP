-- Circuito de selección de 16 periféricos de salida, realizado mediante
-- codificación binaria, con registros que permiten aumentar la máxima frecuencia de reloj
-- aplicable al sistema formado por el microcontrolador Picoblaze y sus periféricos

-- Los registros se intercalan entre el decodificador y la selección del periférico,
-- así como a las señales de dato de salida del microcontrolador (OUT_PORT (7:0))

-- Las salidas de dato de este circuito (out_port_reg) deben conectarse
-- directamente a todos los periféricos de salida

-- Incluye un camino especial para conectar memorias de
-- capacidad hasta 128 posiciones de 8 bits como periférico tanto de salida (escritura)
-- como de entrada (lectura)
-- La memoria se selecciona cuando el bit de mayor peso (bit 7) de port_id(7:0) vale uno
-- Entre las salidas de dirección del microcontrolador (PORT_ID) y las entradas de
-- dirección de la memoria NO se puede intercalar en este caso un registro para aumentar
-- la frecuencia del sistema completo.
-- SÍ se podrá intercalar, en cambio, un registro entre las salidas de dato de la memoria
-- y las entradas de datos del microcontrolador

-- La memoria se selecciona cuando el bit de mayor peso (bit 7) de la dirección de
-- E/S del microcontrolador (PORT_ID) vale 1

-- Realizado por Luis Jacobo Álvarez Ruiz de Ojeda el 27/6/2005.
-- Dpto. Tecnología Electrónica.
-- Universidad de Vigo

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity selec_16_salidas_con_reg_y_mem_esc_lec is
    Port ( port_id : in std_logic_vector(7 downto 0);
           write_strobe : in std_logic;
			  out_port: in std_logic_vector (7 downto 0);
           sel_puerto_00_out : out std_logic;
           sel_puerto_01_out : out std_logic;
           sel_puerto_02_out : out std_logic;
			  sel_puerto_03_out : out std_logic;
           sel_puerto_04_out : out std_logic;
			  sel_puerto_05_out : out std_logic;
           sel_puerto_06_out : out std_logic;
			  sel_puerto_07_out : out std_logic;
           sel_puerto_08_out : out std_logic;
           sel_puerto_09_out : out std_logic;
           sel_puerto_0A_out : out std_logic;
			  sel_puerto_0B_out : out std_logic;
           sel_puerto_0C_out : out std_logic;
			  sel_puerto_0D_out : out std_logic;
           sel_puerto_0E_out : out std_logic;
			  sel_puerto_0F_out : out std_logic;
			  sel_mem_out : out std_logic;
			  out_port_reg: out std_logic_vector (7 downto 0);
			  address_mem: out std_logic_vector (6 downto 0);
			  reset : in std_logic;
           clk_micro : in std_logic
			  );
end selec_16_salidas_con_reg_y_mem_esc_lec;

architecture Behavioral of selec_16_salidas_con_reg_y_mem_esc_lec is

signal sel: std_logic_vector (4 downto 0):=(others => '0');			-- Entradas del decodificador de selección de periféricos de salida
signal selmem: std_logic:='0';							      -- Selección de la memoria
signal selmem_reg: std_logic:='0';							   -- Selección de la memoria ya sincronizada
signal selout: std_logic_vector (15 downto 0):=(others => '0');		-- Salidas del decodificador de periféricos
signal selout_reg: std_logic_vector (15 downto 0):=(others => '0');	-- Salidas del registro de "pipeline"

begin

sel <= port_id(7) & port_id (3 downto 0);
selmem <= port_id(7);

-- Descripción del decodificador binario que permite seleccionar entre 16 periféricos
process (sel)
begin

	Case sel is
		when "00000" =>  selout <= "0000000000000001";
		when "00001" =>  selout <= "0000000000000010";
		when "00010" =>  selout <= "0000000000000100";
		when "00011" =>  selout <= "0000000000001000";
		when "00100" =>  selout <= "0000000000010000";
		when "00101" =>  selout <= "0000000000100000";
		when "00110" =>  selout <= "0000000001000000";
		when "00111" =>  selout <= "0000000010000000";
		when "01000" =>  selout <= "0000000100000000";
		when "01001" =>  selout <= "0000001000000000";
		when "01010" =>  selout <= "0000010000000000";
		when "01011" =>  selout <= "0000100000000000";
		when "01100" =>  selout <= "0001000000000000";
		when "01101" =>  selout <= "0010000000000000";
		when "01110" =>  selout <= "0100000000000000";
		when "01111" =>  selout <= "1000000000000000";
		when others =>   selout <= "0000000000000000";
	end case;

end process;

-- Descripción del registro de 16 bits que permite aumentar la máxima frecuencia de reloj
-- aplicable al sistema formado por el microcontrolador Picoblaze y sus periféricos
-- Se conecta entre las salidas del decodificador que selecciona el periférico y la
-- selección del periférico propiamente dicha, que ya incluye la señal WRITE_STROBE
process (clk_micro, reset)
begin
   if reset='1' then
         selout_reg <= "0000000000000000";  	-- Puesta a cero asíncrona del registro
   elsif (clk_micro'event and clk_micro='1') then
         selout_reg <= selout;						-- Salida del decodificador síncronizada
   end if;
end process;

-- Descripción del biestable que permite aumentar la máxima frecuencia de reloj
-- aplicable al sistema formado por el microcontrolador Picoblaze y sus periféricos
-- Se conecta entre la señal que selecciona la memoria y la
-- selección de la memoria propiamente dicha, que ya incluye la señal WRITE_STROBE
process (clk_micro, reset)
begin
   if reset='1' then
			selmem_reg <= '0';         	-- Puesta a cero asíncrona del registro
   elsif (clk_micro'event and clk_micro='1') then
			selmem_reg <= selmem;			-- Salida del decodificador síncronizada
   end if;
end process;

-- La selección de cada periférico es simplemente la combinación de la activación
-- de la salida correspondiente del decodificador de la dirección de E/S del
-- microcontrolador (PORT_ID(7:0)), una vez sincronizada mediante un biestable 
-- y de la orden de escritura WRITE_STROBE
sel_puerto_00_out <= write_strobe and selout_reg(0);
sel_puerto_01_out <= write_strobe and selout_reg(1);
sel_puerto_02_out <= write_strobe and selout_reg(2);
sel_puerto_03_out <= write_strobe and selout_reg(3);
sel_puerto_04_out <= write_strobe and selout_reg(4);
sel_puerto_05_out <= write_strobe and selout_reg(5);
sel_puerto_06_out <= write_strobe and selout_reg(6);
sel_puerto_07_out <= write_strobe and selout_reg(7);
sel_puerto_08_out <= write_strobe and selout_reg(8);
sel_puerto_09_out <= write_strobe and selout_reg(9);
sel_puerto_0A_out <= write_strobe and selout_reg(10);
sel_puerto_0B_out <= write_strobe and selout_reg(11);
sel_puerto_0C_out <= write_strobe and selout_reg(12);
sel_puerto_0D_out <= write_strobe and selout_reg(13);
sel_puerto_0E_out <= write_strobe and selout_reg(14);
sel_puerto_0F_out <= write_strobe and selout_reg(15);

sel_mem_out <= write_strobe and selmem_reg;

-- Entradas de dirección de la memoria
address_mem <= port_id (6 downto 0);

-- Descripción del registro de 8 bits que permite aumentar la máxima frecuencia de reloj
-- aplicable al sistema formado por el microcontrolador Picoblaze y sus periféricos
-- Se conecta entre las salidas de dato del microcontrolador (OUT_PORT) y las entradas
-- de dato de los periféricos de salida
process (clk_micro, reset)
begin
   if reset='1' then
         out_port_reg <= "00000000";  	-- Puesta a cero asíncrona del registro
   elsif (clk_micro'event and clk_micro='1') then
         out_port_reg <= out_port;		-- Salida síncronizada
   end if;
end process;


end Behavioral;
