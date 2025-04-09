library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration




entity pulse_generator_new_tb is 
end entity ;



-- Dataflow Modelling Style
-- Architecture definition

architecture test of pulse_generator_new_tb is


	COMPONENT pulse_generator_new

	GENERIC( G_CLOCKS_PER_PULSE : INTEGER :=100 ;
 	   G_RESET_ACTIVE_VALUE: std_logic :='0' );

  	 port(
		CLK : in std_logic;
		RST : in std_logic;
		CLEAR : in std_logic;
		ENA: in std_logic;
		PULSE : out std_logic );
	




	END COMPONENT;


	--singal is nesecesry--
SIGNAL S_CLEAR :  std_logic:='0';
SIGNAL S_CLK ,S_RST,S_ENA : std_logic := '1';
SIGNAL S_PULSE: std_logic;
--SIGNAL RUN    : std_logic:='1';

begin
----- dut instantiation -----

DUT : pulse_generator_new
	GENERIC MAP(	G_CLOCKS_PER_PULSE => 4,
			G_RESET_ACTIVE_VALUE => '0' )
		
	--PORT  MAP(S_RATE,S_CLK,S_RESET,S_PULSE);
	PORT MAP(S_CLK,S_RST,S_CLEAR,S_ENA,S_PULSE);





----CLOCK------

		PROCESS
		BEGIN
			
			for i in 0 to 50 loop
				wait for 3 ns;
				s_clk <= not s_clk;
	
				wait for 3 ns;
				s_clk <= not s_clk;
				END LOOP;
				wait;
		END PROCESS;






---- Signal's Waves Creation ----





S_CLEAR <= '1' after 60 ns, '0' after 70 ns;
S_RST<= '0' after 80 ns, '1' after 125 ns;
S_ENA<= '0' after 30 ns, '1' after 50 ns;

end test;	