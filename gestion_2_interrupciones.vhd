----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:21 09/13/2015 
-- Design Name: 
-- Module Name:    gestion_2_interrupciones_con_prioridad - Behavioral 
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

entity gestion_2_interrupciones is
    Port ( reset : in  STD_LOGIC;
           clk_micro : in  STD_LOGIC;
           peticion_int_0 : in  STD_LOGIC;
			  peticion_int_1 : in STD_LOGIC;
           interrupt_ack : in  STD_LOGIC;
           interrupt : out  STD_LOGIC;
           origen_int : out  STD_LOGIC);
end gestion_2_interrupciones;

architecture Behavioral of gestion_2_interrupciones is

	COMPONENT detector_flancos
	PORT(
		entrada : IN std_logic;
		clk : IN std_logic;
		reset : IN std_logic;          
		fa_entrada : OUT std_logic;
		fd_entrada : OUT std_logic
		);
	END COMPONENT;

	COMPONENT rs_flip_flop
	PORT(
		reset : IN std_logic;
		clk : IN std_logic;
		r : IN std_logic;
		s : IN std_logic;          
		q : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT codificador_con_prioridad_2_a_1
	PORT(
		cod_in : IN std_logic_vector(1 downto 0);          
		cod_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT d_flip_flop
	PORT(
		reset : IN std_logic;
		clk : IN std_logic;
		ce : IN std_logic;
		d : IN std_logic;          
		q : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT or_2_bits
	PORT(
		a : IN std_logic;
		b : IN std_logic;          
		o : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT decodificador_1_a_2
	PORT(
		dec_in : IN std_logic;
		en : IN std_logic;   
		out_0 : OUT std_logic;
		out_1 : OUT std_logic
		);
	END COMPONENT;	

	signal peticion_int_0_fa, peticion_int_1_fa : std_logic;
	signal peticion_int_reg_0, peticion_int_reg_1, int_ack_0, int_ack_1 : std_logic;
	signal peticion_int_reg : std_logic_vector(1 downto 0);
	signal salida_codificador : std_logic;

begin

	Inst_detector_flancos_0: detector_flancos PORT MAP(
		entrada => peticion_int_0,
		clk => clk_micro,
		reset => reset,
		fa_entrada => peticion_int_0_fa,
		fd_entrada => open
	);
	
	Inst_detector_flancos_1: detector_flancos PORT MAP(
		entrada => peticion_int_1,
		clk => clk_micro,
		reset => reset,
		fa_entrada => peticion_int_1_fa,
		fd_entrada => open
	);	

	Inst_rs_flip_flop_0: rs_flip_flop PORT MAP(
		reset => reset,
		clk => clk_micro,
		r => int_ack_0,
		s => peticion_int_0_fa,		
		q => peticion_int_reg_0
	);
	
	Inst_rs_flip_flop_1: rs_flip_flop PORT MAP(
		reset => reset,
		clk => clk_micro,
		r => int_ack_1,
		s => peticion_int_1_fa,		
		q => peticion_int_reg_1
	);
	
	peticion_int_reg <= peticion_int_reg_1 & peticion_int_reg_0;
	
	Inst_codificador_con_prioridad_2_a_1: codificador_con_prioridad_2_a_1 PORT MAP(
		cod_in => peticion_int_reg,
		cod_out => salida_codificador
	);

	Inst_d_flip_flop: d_flip_flop PORT MAP(
		reset => reset,
		clk => clk_micro,
		ce => interrupt_ack,
		d => salida_codificador,
		q => origen_int
	);
	
	Inst_or_2_bits: or_2_bits PORT MAP(
		a => peticion_int_reg_0,
		b => peticion_int_reg_1,
		o => interrupt
	);
	
	Inst_decodificador_1_a_2: decodificador_1_a_2 PORT MAP(
		dec_in => salida_codificador,
		en => interrupt_ack,
		out_0 => int_ack_0,
		out_1 => int_ack_1
	);	

end Behavioral;

