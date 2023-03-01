--------------------------------------------------------------------------------------
-- Control_visualizador_dinamico_8digitos_7seg 
--
-- Este bloque realiza el control dinámico de los 8 visualizadores de la placa Nexys-4 
-- Las entradas son vectores de 8 bits que indican los segmentos activos y el valor del
-- punto decimal para cada uno de los dígitos
-- En esta placa tanto los ánodos como los cátodos son activos a nivel cero
-------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control_visualizador_dinamico_8digitos_7seg is
    Port (
           ------------------- ENTRADAS 
           reset : in std_logic;    -- Puesta en estado inicial de todo el circuito
			  clk : in std_logic;      -- Reloj global
			  clk_en : in std_logic;   -- Señal de habilitación que controla la frecuencia de barrido de los dígitos
						-- Valores de los segmentos, activos a nivel uno, en orden A,B,C,D,E,F,G,DP
			  vis0_D : in std_logic_vector(7 downto 0); -- Segmentos correspondientes al dí­gito 0 (menor peso)
           vis1_D : in std_logic_vector(7 downto 0); -- Segmentos correspondientes al dí­gito 1
           vis2_D : in std_logic_vector(7 downto 0); -- Segmentos correspondientes al dí­gito 2
		     vis3_D : in std_logic_vector(7 downto 0); -- Segmentos correspondientes al dí­gito 3
			  vis4_D : in std_logic_vector(7 downto 0); -- Segmentos correspondientes al dí­gito 4
           vis5_D : in std_logic_vector(7 downto 0); -- Segmentos correspondientes al dí­gito 5
           vis6_D : in std_logic_vector(7 downto 0); -- Segmentos correspondientes al dí­gito 6
		     vis7_D : in std_logic_vector(7 downto 0); -- Segmentos correspondientes al dí­gito 7 (mayor peso)			  
			         -- Habilitaciones de los visualizadores
           gvis : in std_logic;  -- Habilitación global del visualizador de 4 dí­gitos
           gvis0 : in std_logic; -- Habilitación del dí­gito 0 (menor peso)
           gvis1 : in std_logic; -- Habilitación del dí­gito 1
           gvis2 : in std_logic; -- Habilitación del dí­gito 2
           gvis3 : in std_logic; -- Habilitación del dí­gito 3
           gvis4 : in std_logic; -- Habilitación del dí­gito 4
           gvis5 : in std_logic; -- Habilitación del dí­gito 5
           gvis6 : in std_logic; -- Habilitación del dí­gito 6
           gvis7 : in std_logic; -- Habilitación del dí­gito 7 (mayor peso)			  
			  ------------------- SALIDAS 
           an0 : out std_logic; -- Anodo del visualizador 0 (menor peso)
           an1 : out std_logic; -- Anodo del visualizador 1
           an2 : out std_logic; -- Anodo del visualizador 2
           an3 : out std_logic; -- Anodo del visualizador 3
           an4 : out std_logic; -- Anodo del visualizador 4
           an5 : out std_logic; -- Anodo del visualizador 5
           an6 : out std_logic; -- Anodo del visualizador 6
           an7 : out std_logic; -- Anodo del visualizador 7 (mayor peso)			  
			         -- Segmentos comunes a los cuatro dí­gitos del visualizador
           A : out std_logic;
           B : out std_logic;
           C : out std_logic;
           D : out std_logic;
           E : out std_logic;
           F : out std_logic;
           G : out std_logic;
           DP : out std_logic
			  );
end Control_visualizador_dinamico_8digitos_7seg;



architecture Behavioral of Control_visualizador_dinamico_8digitos_7seg is

-- Señal del contador que selecciona el visualizador activo
signal contador_vis	: std_logic_vector (2 downto 0);
-- Salida del multiplexor que selecciona el dato de entrada a visualizar
signal mux_vis	: std_logic_vector (7 downto 0);
-- Vector de activacion de ánodo en función del visualizador activo
signal anodos	: std_logic_vector (7 downto 0);


begin

---------- SELECCION DEL VISUALIZADOR ACTIVO  ---------------------------
-- Contador de 3 bits con habilitación de contaje que                  -- 
-- indica el visualizador que está activo en cada instante				  --
-------------------------------------------------------------------------

	process (reset, clk)
	begin
		if reset ='1' then contador_vis <= "000";
		elsif (clk ='1' and clk'event) then
			if clk_en ='1' then
				if contador_vis = "111" then contador_vis <= "000";
				else contador_vis <= contador_vis + 1;
				end if;
			end if;
		end if;
	end process;
	


---------- ACTIVACION DE LOS ANODOS  ------------------------------------
-- Decodificador 1 entre 8 para seleccion del ánodo activo             -- 
-- en cada instante							                                --
-------------------------------------------------------------------------	

	anodos <= 	"00000001" when contador_vis = "000" else
			      "00000010" when contador_vis = "001" else
			      "00000100" when contador_vis = "010" else
			      "00001000" when contador_vis = "011" else
					"00010000" when contador_vis = "100" else
			      "00100000" when contador_vis = "101" else
			      "01000000" when contador_vis = "110" else
			      "10000000" when contador_vis = "111" else
			      "00000000";


---------- SELECCIÓN DEL DATO A VISUALIZAR  -----------------------------
-- Multiplexor de ocho canales para la seleccion del                 -- 
-- dato a visualizar, correspondiente al digito del visualizador		  --
-- seleccionado en cada instante							                    --					                                
-------------------------------------------------------------------------

	mux_vis <= 	vis0_D when contador_vis = "000" else 
			      vis1_D when contador_vis = "001" else 
			      vis2_D when contador_vis = "010" else 
			      vis3_D when contador_vis = "011" else 
					vis4_D when contador_vis = "100" else 
			      vis5_D when contador_vis = "101" else 
			      vis6_D when contador_vis = "110" else 
			      vis7_D when contador_vis = "111" else
			      X"00";

					
-- Anodos de cada digito con habilitacion del visualizador y habilitación del digito
	an7 <= not(gvis and gvis7 and anodos(7)); -- Visualizador de mayor peso
	an6 <= not(gvis and gvis6 and anodos(6));
	an5 <= not(gvis and gvis5 and anodos(5));
	an4 <= not(gvis and gvis4 and anodos(4));
	an3 <= not(gvis and gvis3 and anodos(3));
	an2 <= not(gvis and gvis2 and anodos(2));
	an1 <= not(gvis and gvis1 and anodos(1));
	an0 <= not(gvis and gvis0 and anodos(0)); -- Visualizador de menor peso

-- Catodos comunes a todos los dígitos, activos a nivel bajo
	A <= not mux_vis(7);
	B <= not mux_vis(6);
	C <= not mux_vis(5);
	D <= not mux_vis(4);
	E <= not mux_vis(3);
	F <= not mux_vis(2);
	G <= not mux_vis(1);

-- Catodo correspondiente al punto decimal, activo a nivel bajo
	DP <= not mux_vis(0);


end Behavioral;

