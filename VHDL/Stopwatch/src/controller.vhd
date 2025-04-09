library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration




entity controller is
	
	generic( G_RESET_ACTIVE_VALUE : std_logic := '0');

	port(	CLK: IN std_logic ;
		RST: IN std_logic ;
		SW_START_STOP: IN std_logic ;
		SW_CLEAR: IN std_logic ;
		SW_LAP: IN std_logic;

		COUNT_ENA :OUT std_logic;
		COUNT_CLEAR: OUT std_logic;
		COUNT_LAP : OUT std_logic);
		
		
		
         
end controller;

-- Dataflow Modelling Style
-- Architecture definition

architecture Logic of controller is



TYPE state_type IS (st_idle,st_stop,st_count,st_lap); 

SIGNAL cur_state: state_type;

SIGNAL S_COUNT_LAP : std_logic:= '0';

SIGNAL S_COUNT_CLEAR: std_logic:='0';
SIGNAL S_COUNT_ENABLE :std_logic:='0' ;



begin
	



		PROCESS(CLK,RST)
		BEGIN 

		
	
		--what val
		IF RST= G_RESET_ACTIVE_VALUE THEN
					cur_state <= st_idle;


		ELSIF CLK'event AND CLK= '1' THEN
		
		CASE cur_state IS

		WHEN st_stop =>	 IF (SW_CLEAR= '1') THEN
										cur_state <= st_idle;

								ELSIF(SW_START_STOP ='1') THEN
									cur_state <= st_count;

								ELSE 
									cur_state <= st_stop;
								
								END IF;
	
		WHEN st_count=>  IF (SW_START_STOP= '1') THEN
									cur_state <= st_stop;
				 
								ELSIF SW_CLEAR = '1' THEN
									cur_state <= st_idle;
								ELSIF SW_LAP = '1' THEN
									cur_state<= st_lap;
								ELSE 
									cur_state <= st_count;
									
								 END IF;



		WHEN st_lap => 	 IF (SW_CLEAR=  '1') THEN
								cur_state <= st_idle;
									 
								ELSE
									cur_state<= st_count;


								END IF;


		WHEN st_idle=> 	 IF (SW_START_STOP= '1') THEN
									cur_state <= st_count;
								 
								ELSE
									cur_state <= st_idle;
									
								 END IF;


	
		
		WHEN OTHERS =>		 NULL;
		END CASE;


		CASE cur_state IS

		WHEN st_stop =>
				S_COUNT_ENABLE<= '0' ;

		WHEN st_count=> 
				S_COUNT_ENABLE <= '1';
				S_COUNT_CLEAR <= '0';

		WHEN st_lap =>
				 S_COUNT_LAP<= NOT S_COUNT_LAP;

		WHEN st_idle => 
				S_COUNT_CLEAR<='1';
				S_COUNT_LAP<='0';
				S_COUNT_ENABLE<='0';
		
		END CASE;

		COUNT_LAP <= S_COUNT_LAP;
		COUNT_CLEAR <= S_COUNT_CLEAR;
		COUNT_ENA <= S_COUNT_ENABLE;
		

	END IF;
	END PROCESS;

	

	
	
end Logic ;	