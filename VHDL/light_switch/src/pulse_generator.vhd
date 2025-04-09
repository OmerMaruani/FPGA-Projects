library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration




entity pulse_generator is


   GENERIC( G_CLOCKS_PER_PULSE : INTEGER := 4);

   port(
	CLK : in std_logic;
	RESET : in std_logic;
	RATE : in std_logic;
	PULSE : out std_logic );
	
         
end pulse_generator;

-- Dataflow Modelling Style
-- Architecture definition

architecture Logic of pulse_generator is

SIGNAL COUNTER : INTEGER := 0;
SIGNAL INT_RATE: INTEGER :=  1;
SIGNAL MAX_COUNT: INTEGER:= (1*G_CLOCKS_PER_PULSE) -1;




begin
	
--MAX_COUNT <= (1*G_CLOCKS_PER_PULSE) when (RATE = '0') else (2*G_CLOCKS_PER_PULSE) ;
	
--	PROCESS(RATE)
--	BEGIN 
--	
--	IF RATE ='0' THEN INT_RATE <=1;
--	ELSIF RATE = '1' THEN INT_RATE <=2;
--	END IF;
--
--	MAX_COUNT <= (INT_RATE*G_CLOCKS_PER_PULSE) -1;
--	END PROCESS;
--


	PROCESS(CLK, RESET)
	
	BEGIN
	
	IF RESET= '0' THEN
				PULSE <= '0';
				COUNTER <= 0;
				

	ELSIF  CLK 'event and CLK= '1' THEN
		
		
		IF COUNTER = MAX_COUNT THEN
							PULSE <= '1';
							COUNTER <=0 ;

		ELSIF COUNTER < MAX_COUNT THEN
			PULSE <= '0';
			COUNTER <= COUNTER +1;

		ELSIF COUNTER > MAX_COUNT THEN
			COUNTER <= 0;
									
		END IF ;	
										
 						
        END IF ;


	IF RATE ='0' THEN INT_RATE <=1;
	ELSIF RATE = '1' THEN INT_RATE <=2;
	END IF;

	MAX_COUNT <= (INT_RATE*G_CLOCKS_PER_PULSE) -1;
	

	END PROCESS;



	
	
	
end Logic ;	