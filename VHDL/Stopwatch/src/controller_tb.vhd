library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration




entity controller_tb is 
end entity ;



-- Dataflow Modelling Style
-- Architecture definition

architecture test of controller_tb is

	

	COMPONENT controller
	
	generic( G_RESET_ACTIVE_VALUE : std_logic := '0');

	port(	CLK: IN std_logic ;
		RST: IN std_logic ;
		SW_START_STOP: IN std_logic ;
		SW_CLEAR: IN std_logic ;
		SW_LAP: IN std_logic;

		COUNT_ENA :OUT std_logic;
		COUNT_CLEAR: OUT std_logic;
		COUNT_LAP : OUT std_logic);	
	
	END COMPONENT;


	--singal is nesecesry--

SIGNAL S_CLK ,S_RST: std_logic :='1';

SIGNAL S_SW_START_STOP, S_SW_CLEAR,S_SW_LAP : std_logic :='0';

SIGNAL S_COUNT_ENA,S_COUNT_CLEAR,S_COUNT_LAP :std_logic:= '0'; 


begin
----- dut instantiation -----

DUT : controller
	generic map( G_RESET_ACTIVE_VALUE => '0' )

	port map(
			S_CLK,S_RST, S_SW_START_STOP,S_SW_CLEAR,S_SW_LAP,
			S_COUNT_ENA,S_COUNT_CLEAR,S_COUNT_LAP );


----CLOCK------

		PROCESS
		BEGIN
			
			for i in 0 to 200 loop
				wait for 10 ns;
				s_clk <= not s_clk;
	
				wait for 10 ns;
				s_clk <= not s_clk;
				END LOOP;
				wait;
		END PROCESS;

		
--		PROCESS
--		BEGIN
--			
--			for i in 0 to 50 loop
--				wait for 5 ns;
--				S_SW_START_STOP <= NOT S_SW_START_STOP;
--	
--				wait for 4 ns;
--				S_SW_cLEAR<= NOT S_SW_CLEAR;
--
--				wait for 6 ns;
--				S_SW_LAP <= NOT S_SW_LAP;
--
--				END LOOP;
--				wait;
--		END PROCESS;






---- Signal's Waves Creation ----



S_RST <= '0' after 300 ns;
S_SW_START_STOP <= '1' after 20 ns , '0' after 40 ns , '1' after 60 ns ,'0' after 80 ns ;--, '1' after 180 ns , '0' after 200 ns,'1' after 200 ns, '0' after 220 ns;
S_SW_CLEAR <= '1' after 40 ns , '0' after 60 ns;
S_SW_LAP <= '1' after 140 ns , '0' after 160 ns;



end test;	