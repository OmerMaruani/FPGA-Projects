library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration




entity pulse_generator_tb is 
end entity ;



-- Dataflow Modelling Style
-- Architecture definition

architecture test of pulse_generator_tb is


	COMPONENT pulse_generator

   	GENERIC( G_CLOCKS_PER_PULSE : INTEGER := 3);

   	port(
	CLK : in std_logic;
	RESET : in std_logic;
	RATE : in std_logic;
	PULSE : out std_logic );
	END COMPONENT;


	--singal is nesecesry--
SIGNAL S_RATE :  std_logic:='1';
SIGNAL S_CLK ,S_RESET : std_logic := '1';
SIGNAL S_PULSE: std_logic;
--SIGNAL RUN    : std_logic:='1';

begin
----- dut instantiation -----

DUT : pulse_generator
	GENERIC MAP(G_CLOCKS_PER_PULSE => 4)
	--PORT  MAP(S_RATE,S_CLK,S_RESET,S_PULSE);
	port map(	CLK=> S_CLK,
			RESET =>S_RESET,
			RATE => S_RATE,
			PULSE=> S_PULSE);





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





S_RATE <= '0' after 100 ns;
S_RESET<= '0' after 80 ns, '1' after 125 ns;
end architecture;	