library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity declaration




entity counter is


   GENERIC( G_RESET_ACTIVE_VALUE: std_logic :='0' );

   port(
	CLK 	: in std_logic;
	RST 	: in std_logic;
	CLEAR 	: in std_logic;
	ENA	: in std_logic;
	OEn 	: in std_logic;
	HUND_ONES :out std_logic_vector(3 downto 0);
	HUND_TENS :out  std_logic_vector(3 downto 0);
	SEC_ONES :out  std_logic_vector(3 downto 0);
	SEC_TENS :out  std_logic_vector(3 downto 0) );
	
         
end counter;

-- Dataflow Modelling Style
-- Architecture definition

architecture Logic of counter is

--SIGNAL CNT: INTEGER := 0;
--SIGNAL INT_RATE: INTEGER :=  1;
--SIGNAL MAX_COUNT: INTEGER:= (1*G_CLOCKS_PER_PULSE) -1;


SIGNAL S_SEC_TENS : INTEGER RANGE 0 TO 5:=0 ;
SIGNAL S_SEC_ONES : INTEGER RANGE 0 TO 9:=0 ;
SIGNAL S_HUND_TENS : INTEGER RANGE 0 TO 9:=0 ;
SIGNAL S_HUND_ONES : INTEGER RANGE 0 TO 9:=0 ;


	




begin
	
--MAX_COUNT <= (1*G_CLOCKS_PER_PULSE) when (RATE = '0') else (2*G_CLOCKS_PER_PULSE) ;
	
--	PROCESS(RATE)
--	BEGIN 
--	
--	IF RATE ='0' THEN INT_RATE <=1;
--	ELSIF RATE = '1' THEN INT_RATE <=2;
--	END IFsMAX_COUNT <= (INT_RATE*G_CLOCKS_PER_PULSE) -1;
--	END PROCESS;
--


	PROCESS(CLK, RST)
	
	BEGIN
	
	IF RST= G_RESET_ACTIVE_VALUE THEN
				S_SEC_TENS <= 0; 
				S_SEC_ONES <= 0;	
				S_HUND_TENS <= 0;
				S_HUND_ONES <= 0;
				
				
				
		--S_SEC_ONES < > S_HUND_ONES
		--S_SEC_TENS < > S_HUND_TENS		

	ELSIF  CLK 'event and CLK= '1' THEN

		IF CLEAR = '1' THEN
				S_SEC_TENS <= 0; 
				S_SEC_ONES <= 0;	
				S_HUND_TENS <= 0;
				S_HUND_ONES <= 0;
				
				



		ELSIF ENA = '1' THEN
		
			IF S_HUND_ONES= 9 THEN
				S_HUND_ONES <= 0;
			
				IF S_HUND_TENS = 9 THEN
					S_HUND_TENS <=0;


					IF S_SEC_ONES =9 THEN
						S_SEC_ONES <=0;


						IF S_SEC_TENS =5 THEN
							S_SEC_TENS <=0;
						ELSIF S_SEC_TENS <5 THEN
							S_SEC_TENS <= S_SEC_TENS +1;

						END IF;
					


					ELSIF S_SEC_ONES <9 THEN
							S_SEC_ONES <= S_SEC_ONES+1;

					END IF;

				ELSIF S_HUND_TENS <9 THEN
					S_HUND_TENS <= S_HUND_TENS+1;


				END IF;


			ELSIF S_HUND_ONES <9 THEN 
				S_HUND_ONES <= S_HUND_ONES +1;


			END IF;

									
		END IF ;	
										
 						
        END IF ;



	IF OEn = '0' or RST= G_RESET_ACTIVE_VALUE THEN

		HUND_ONES <= std_logic_vector(to_unsigned(S_HUND_ONES, HUND_ONES'length) ) ;
		HUND_TENS <=std_logic_vector(to_unsigned(S_HUND_TENS, HUND_TENS'length) ) ;
		SEC_ONES<= std_logic_vector(to_unsigned(S_SEC_ONES, SEC_ONES'length) ) ;
		SEC_TENS<= std_logic_vector(to_unsigned(S_SEC_TENS, SEC_TENS'length) ) ;
	
	END IF;
	

	END PROCESS;



	
	
end Logic ;	