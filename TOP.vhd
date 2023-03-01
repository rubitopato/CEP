----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2022 16:40:42
-- Design Name: 
-- Module Name: TOP - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port ( data_available : in STD_LOGIC;
           clk : in std_logic;
           reset : in std_logic;
           i2c_scl :inout STD_LOGIC;
           i2c_sda :inout STD_LOGIC;
           an0 : out std_logic; -- Anodo del visualizador 0 (menor peso)
            an1 : out std_logic; -- Anodo del visualizador 1
            an2 : out std_logic; -- Anodo del visualizador 2
            an3 : out std_logic; -- Anodo del visualizador 3
            an4 : out std_logic; -- Anodo del visualizador 4
            an5 : out std_logic; -- Anodo del visualizador 5
            an6 : out std_logic; -- Anodo del visualizador 6
            an7 : out std_logic; -- Anodo del visualizador 7 (mayor peso)
           A : out STD_LOGIC;
           B : out STD_LOGIC;
           C : out STD_LOGIC;
           D : out STD_LOGIC;
           E : out STD_LOGIC;
           F : out STD_LOGIC;
           G : out STD_LOGIC;
           DP : out STD_LOGIC);
end TOP;

architecture Behavioral of TOP is

signal int_output : std_logic;
signal int_ack_aux : std_logic;
signal ce_generator : std_logic;
signal port_id_aux : std_logic_vector(7 downto 0);
signal in_port_aux : std_logic_vector(7 downto 0);
signal out_port_aux : std_logic_vector(7 downto 0);
signal write_strobe_aux : std_logic;
signal read_strobe_aux : std_logic;
signal en_comb_circuit : std_logic;
signal out_comb_circuit : std_logic_vector(7 downto 0);
signal in_comb_circuit : std_logic_vector(7 downto 0);
signal en_display : std_logic;
signal ce_0 : std_logic;
signal ce_1 : std_logic;
signal ce_2 : std_logic;
signal ce_3 : std_logic;
signal ce_4 : std_logic;
signal ce_5 : std_logic;
signal ce_6 : std_logic;
signal ce_7 : std_logic;
signal ce_8 : std_logic;
signal ce_9 : std_logic;
signal ce_10 : std_logic;
signal vis0_aux : std_logic_vector(7 downto 0);
signal vis1_aux : std_logic_vector(7 downto 0);
signal vis2_aux : std_logic_vector(7 downto 0);
signal vis3_aux : std_logic_vector(7 downto 0);
signal vis4_aux : std_logic_vector(7 downto 0);
signal vis5_aux : std_logic_vector(7 downto 0);
signal vis6_aux : std_logic_vector(7 downto 0);
signal vis7_aux : std_logic_vector(7 downto 0);

signal reset_n :std_logic;

component gestion_2_interrupciones
   port (
      clk_micro      :  in  std_logic;
      interrupt_ack  :  in  std_logic;
      peticion_int_0 :  in  std_logic;
      peticion_int_1 :  in  std_logic;
      reset          :  in  std_logic;
      interrupt      :  out  std_logic;
      origen_int     :  out  std_logic
   );
   end component;
component Interrupt_counter
   port (
      clk    :  in  std_logic;
      clk_en :  in  std_logic;
      reset  :  in  std_logic;
      output :  out  std_logic
   );
   end component;
    component picoblaze3_empotrado_s7
   port (
      clk           :  in  std_logic;
      interrupt     :  in  std_logic;
      reset         :  in  std_logic;
      in_port       :  in  std_logic_vector(7 downto 0);
      interrupt_ack :  out  std_logic;
      read_strobe   :  out  std_logic;
      write_strobe  :  out  std_logic;
      out_port      :  out  std_logic_vector(7 downto 0);
      port_id       :  out  std_logic_vector(7 downto 0)
   );
   end component;
   component i2c_master_edn
   port (
      clk        :  in  std_logic;
      ctrl_ce    :  in  std_logic;
      data_tx_ce :  in  std_logic;
      reset      :  in  std_logic;
      scl_i      :  in  std_logic;
      sda_i      :  in  std_logic;
      ctrl       :  in  std_logic_vector(7 downto 0);
      data_tx    :  in  std_logic_vector(7 downto 0);
      scl_o      :  out  std_logic;
      sda_o      :  out  std_logic;
      data_rx    :  out  std_logic_vector(7 downto 0);
      status     :  out  std_logic_vector(7 downto 0)
   );
   end component;
   
   component Control_visualizador_dinamico_8digitos_7seg
   port (
      clk    :  in  std_logic;
      clk_en :  in  std_logic;
      gvis   :  in  std_logic;
      gvis0  :  in  std_logic;
      gvis1  :  in  std_logic;
      gvis2  :  in  std_logic;
      gvis3  :  in  std_logic;
      gvis4  :  in  std_logic;
      gvis5  :  in  std_logic;
      gvis6  :  in  std_logic;
      gvis7  :  in  std_logic;
      reset  :  in  std_logic;
      vis0_D :  in  std_logic_vector(7 downto 0);
      vis1_D :  in  std_logic_vector(7 downto 0);
      vis2_D :  in  std_logic_vector(7 downto 0);
      vis3_D :  in  std_logic_vector(7 downto 0);
      vis4_D :  in  std_logic_vector(7 downto 0);
      vis5_D :  in  std_logic_vector(7 downto 0);
      vis6_D :  in  std_logic_vector(7 downto 0);
      vis7_D :  in  std_logic_vector(7 downto 0);
      A      :  out  std_logic;
      an0    :  out  std_logic;
      an1    :  out  std_logic;
      an2    :  out  std_logic;
      an3    :  out  std_logic;
      an4    :  out  std_logic;
      an5    :  out  std_logic;
      an6    :  out  std_logic;
      an7    :  out  std_logic;
      B      :  out  std_logic;
      C      :  out  std_logic;
      D      :  out  std_logic;
      DP     :  out  std_logic;
      E      :  out  std_logic;
      F      :  out  std_logic;
      G      :  out  std_logic
   );
   end component;
   
   component Generador_CE_1KHz
   port (
      clk     :  in  std_logic;
      reset   :  in  std_logic;
      ce_1KHz :  out  std_logic
   );
   end component;
   
   component bin_to_7seg_anodo
   port (
      en    :  in  std_logic;
      DIN   :  in  std_logic_vector(7 downto 0);
      output : out std_logic_vector(7 downto 0)
   );
   end component;

    component selec_16_entradas_con_reg_y_bypass
   port (
      clk_micro    :  in  std_logic;
      reset        :  in  std_logic;
      mem_in       :  in  std_logic_vector(7 downto 0);
      port_id      :  in  std_logic_vector(7 downto 0);
      puerto_00_in :  in  std_logic_vector(7 downto 0);
      puerto_0A_in :  in  std_logic_vector(7 downto 0);
      puerto_0B_in :  in  std_logic_vector(7 downto 0);
      puerto_0C_in :  in  std_logic_vector(7 downto 0);
      puerto_0D_in :  in  std_logic_vector(7 downto 0);
      puerto_0E_in :  in  std_logic_vector(7 downto 0);
      puerto_0F_in :  in  std_logic_vector(7 downto 0);
      puerto_01_in :  in  std_logic_vector(7 downto 0);
      puerto_02_in :  in  std_logic_vector(7 downto 0);
      puerto_03_in :  in  std_logic_vector(7 downto 0);
      puerto_04_in :  in  std_logic_vector(7 downto 0);
      puerto_05_in :  in  std_logic_vector(7 downto 0);
      puerto_06_in :  in  std_logic_vector(7 downto 0);
      puerto_07_in :  in  std_logic_vector(7 downto 0);
      puerto_08_in :  in  std_logic_vector(7 downto 0);
      puerto_09_in :  in  std_logic_vector(7 downto 0);
      in_port      :  out  std_logic_vector(7 downto 0)
   );
   end component;
   
   component selec_16_salidas_con_reg_y_mem_esc_lec
   port (
      clk_micro         :  in  std_logic;   
      reset             :  in  std_logic;   
      write_strobe      :  in  std_logic;   
      out_port          :  in  std_logic_vector(7 downto 0);
      port_id           :  in  std_logic_vector(7 downto 0);
      sel_mem_out       :  out  std_logic;  
      sel_puerto_00_out :  out  std_logic;  
      sel_puerto_0A_out :  out  std_logic;  
      sel_puerto_0B_out :  out  std_logic;  
      sel_puerto_0C_out :  out  std_logic;  
      sel_puerto_0D_out :  out  std_logic;  
      sel_puerto_0E_out :  out  std_logic;  
      sel_puerto_0F_out :  out  std_logic;  
      sel_puerto_01_out :  out  std_logic;  
      sel_puerto_02_out :  out  std_logic;  
      sel_puerto_03_out :  out  std_logic;  
      sel_puerto_04_out :  out  std_logic;  
      sel_puerto_05_out :  out  std_logic;  
      sel_puerto_06_out :  out  std_logic;  
      sel_puerto_07_out :  out  std_logic;  
      sel_puerto_08_out :  out  std_logic;  
      sel_puerto_09_out :  out  std_logic;  
      address_mem       :  out  std_logic_vector(6 downto 0);
      out_port_reg      :  out  std_logic_vector(7 downto 0)
   );
   end component;
   
   component register_FD8CE
   port (
      ce  :  in  std_logic;
      clk :  in  std_logic;
      clr :  in  std_logic;
      D   :  in  std_logic_vector(7 downto 0);
      Q   :  out  std_logic_vector(7 downto 0)
   );
   end component;
  signal datatopicoblaze : std_logic_vector(7 downto 0);
  signal status_aux : std_logic_vector(7 downto 0);
  signal status_aux_n : std_logic_vector(7 downto 0);
  signal data_tx_aux : std_logic_vector(7 downto 0);
  signal ctrl_aux : std_logic_vector(7 downto 0);
  signal scl_o : std_logic;
  signal sda_i : std_logic;
  signal sda_o : std_logic;
  signal scl_i : std_logic;
  signal counter_output : std_logic;
begin

i2c_scl <= scl_o when scl_o= '0' else 'Z';
scl_i <= i2c_scl;

i2c_sda <= sda_o when sda_o= '0' else 'Z';
sda_i <= i2c_sda;

reset_n<=not reset;

gestion_2_interrupciones_inst: gestion_2_interrupciones
   port map (
      clk_micro      => clk,    
      interrupt_ack  => int_ack_aux,
      peticion_int_0 => status_aux(2),
      peticion_int_1 => counter_output,
      reset          => reset_n,        
      interrupt      => int_output    
      --origen_int     => origen_int   
   );
   Interrupt_counter_inst: Interrupt_counter
   port map (
      clk    => clk,
      clk_en => ce_generator,
      reset  => reset_n,
      output => counter_output
   );
   i2c_master_edn_inst: i2c_master_edn
   port map (
      clk                 => clk,               
      ctrl_ce             => ce_10,           
      data_tx_ce          => ce_9,        
      reset               => reset_n,             
      scl_i               => scl_i,             
      sda_i               => sda_i,             
      ctrl(7 downto 0)    => out_port_aux,  
      data_tx(7 downto 0) => out_port_aux,
      scl_o               => scl_o,             
      sda_o               => sda_o,             
      data_rx(7 downto 0) => datatopicoblaze,
      status(7 downto 0)  => status_aux
   );

   picoblaze3_empotrado_s7_inst: picoblaze3_empotrado_s7
   port map (
      clk                  => clk,                
      interrupt            => int_output,          
      reset                => reset_n,              
      in_port(7 downto 0)  => in_port_aux,
      interrupt_ack        => int_ack_aux,      
      read_strobe          => read_strobe_aux,        
      write_strobe         => write_strobe_aux,       
      out_port(7 downto 0) => out_port_aux,
      port_id(7 downto 0)  => port_id_aux
   );
   
   Control_visualizador_dinamico_8digitos_7seg_inst: Control_visualizador_dinamico_8digitos_7seg
   port map (
      clk                => clk,              
      clk_en             => ce_generator,           
      gvis               => '1',             
      gvis0              => '1',            
      gvis1              => '1',            
      gvis2              => '1',            
      gvis3              => '1',            
      gvis4              => '1',            
      gvis5              => '1',            
      gvis6              => '1',            
      gvis7              => '1',            
      reset              => reset_n,            
      vis0_D(7 downto 0) => vis0_aux,
      vis1_D(7 downto 0) => vis1_aux,
      vis2_D(7 downto 0) => vis2_aux,
      vis3_D(7 downto 0) => vis3_aux,
      vis4_D(7 downto 0) => vis4_aux,
      vis5_D(7 downto 0) => vis5_aux,
      vis6_D(7 downto 0) => vis6_aux,
      vis7_D(7 downto 0) => vis7_aux,
      A                  => A,                
      an0                => an0,              
      an1                => an1,              
      an2                => an2,              
      an3                => an3,              
      an4                => an4,              
      an5                => an5,              
      an6                => an6,              
      an7                => an7,              
      B                  => B,                
      C                  => C,                
      D                  => D,                
      DP                 => DP,               
      E                  => E,                
      F                  => F,                
      G                  => G                
   );
   
   Generador_CE_1KHz_inst: Generador_CE_1KHz
   port map (
      clk     => clk,   
      reset   => reset_n, 
      ce_1KHz => ce_generator
   );
   
   bin_to_7seg_anodo_inst: bin_to_7seg_anodo
   port map (        
      en              => '1',            
      DIN(7 downto 0) => in_comb_circuit,
      output(7 downto 0) => out_comb_circuit            
   );
   
   selec_16_entradas_con_reg_y_bypass_inst: selec_16_entradas_con_reg_y_bypass
   port map (
      clk_micro                => clk,              
      reset                    => reset_n,                  
      mem_in(7 downto 0)       => "00000000",     
      port_id(7 downto 0)      => port_id_aux,    
      puerto_00_in(7 downto 0) => datatopicoblaze,
      puerto_0A_in(7 downto 0) => "00000000",
      puerto_0B_in(7 downto 0) => "00000000",
      puerto_0C_in(7 downto 0) => "00000000",
      puerto_0D_in(7 downto 0) => "00000000",
      puerto_0E_in(7 downto 0) => "00000000",
      puerto_0F_in(7 downto 0) => "00000000",
      puerto_01_in(7 downto 0) => "00000000",
      puerto_02_in(7 downto 0) => out_comb_circuit,
      puerto_03_in(7 downto 0) => "00000000",
      puerto_04_in(7 downto 0) => "00000000",
      puerto_05_in(7 downto 0) => "00000000",
      puerto_06_in(7 downto 0) => "00000000",
      puerto_07_in(7 downto 0) => "00000000",
      puerto_08_in(7 downto 0) => "00000000",
      puerto_09_in(7 downto 0) => "00000000",
      in_port(7 downto 0)      => in_port_aux    
   );
   
   selec_16_salidas_con_reg_y_mem_esc_lec_inst: selec_16_salidas_con_reg_y_mem_esc_lec
   port map (
      clk_micro                => clk,              
      reset                    => reset_n,                  
      write_strobe             => write_strobe_aux,           
      out_port(7 downto 0)     => out_port_aux,   
      port_id(7 downto 0)      => port_id_aux,    
      --sel_mem_out              => sel_mem_out,            
      sel_puerto_00_out        => ce_0,      
     sel_puerto_0A_out        => ce_10 ,      
     --sel_puerto_0B_out        => sel_puerto_0B_out,      
      --sel_puerto_0C_out        => sel_puerto_0C_out,      
      --sel_puerto_0D_out        => sel_puerto_0D_out,      
      --sel_puerto_0E_out        => sel_puerto_0E_out,      
      --sel_puerto_0F_out        => sel_puerto_0F_out,      
      sel_puerto_01_out        => ce_1,      
      sel_puerto_02_out        => ce_2,      
      sel_puerto_03_out        => ce_3,      
      sel_puerto_04_out        => ce_4,      
      sel_puerto_05_out        => ce_5,      
      sel_puerto_06_out        => ce_6,      
      sel_puerto_07_out        => ce_7,      
      sel_puerto_08_out        => ce_8,      
      sel_puerto_09_out        => ce_9      
      --address_mem(6 downto 0)  => address_mem(6 downto 0),
      --out_port_reg(7 downto 0) => out_port_reg(7 downto 0)
   );
   
   register_FD8CE_inst_0: register_FD8CE
   port map (
      ce            => ce_0,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => vis0_aux
   );
   
   register_FD8CE_inst_1: register_FD8CE
   port map (
      ce            => ce_1,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => vis1_aux
   );
   
   register_FD8CE_inst_2: register_FD8CE
   port map (
      ce            => ce_2,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => vis2_aux
   );
   
   register_FD8CE_inst_3: register_FD8CE
   port map (
      ce            => ce_3,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => vis3_aux
   );
   
   register_FD8CE_inst_4: register_FD8CE
   port map (
      ce            => ce_4,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => vis4_aux
   );
   
   register_FD8CE_inst_5: register_FD8CE
   port map (
      ce            => ce_5,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => vis5_aux
   );
   
   register_FD8CE_inst_6: register_FD8CE
   port map (
      ce            => ce_6,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => vis6_aux
   );
   
   register_FD8CE_inst_7: register_FD8CE
   port map (
      ce            => ce_7,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => vis7_aux
   );
   
   register_FD8CE_inst_8: register_FD8CE
   port map (
      ce            => ce_8,          
      clk           => clk,         
      clr           => reset_n,         
      D(7 downto 0) => out_port_aux,
      Q(7 downto 0) => in_comb_circuit
   );
--    register_FD8CE_inst_datatx: register_FD8CE
--   port map (
--      ce            => ce_9,          
--      clk           => clk,         
--      clr           => reset_n,         
--      D(7 downto 0) => out_port_aux,
--      Q(7 downto 0) => data_tx_aux
--   );
--    register_FD8CE_inst_ctrl: register_FD8CE
--   port map (
--      ce            => ce_10,          
--      clk           => clk,         
--      clr           => reset_n,         
--      D(7 downto 0) => out_port_aux,
--      Q(7 downto 0) => ctrl_aux
--   );
end Behavioral;
