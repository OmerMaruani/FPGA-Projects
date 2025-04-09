library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration




entity stopwatch is


   	GENERIC( G_CLOKCS_PER_10ms : INTEGER := 50e3 );
	

   	port(
		CLK : in std_logic;
		RSTn : in std_logic;
		SW_START_STOP : in std_logic;
		SW_CLEAR : in std_logic;
		SW_LAP : in std_logic;
		HUND_ONES_7SEG: out std_logic_vector(6 downto 0) ;
		HUND_TENS_7SEG: out std_logic_vector(6 downto 0) ;
		SEC_ONES_7SEG :out std_logic_vector(6 downto 0) ;
		SEC_TENS_7SEG :out std_logic_vector(6 downto 0)
	);
	
         
end stopwatch;

-- Dataflow Modelling Style
-- Architecture definition

ARCHITECTURE struct OF stopwatch IS


	COMPONENT sync_diff

	generic (
    		G_DERIVATE_RISING_EDGE  : boolean := true;
    		G_SIG_IN_INIT_VALUE     : std_logic := '0';
   		 G_RESET_ACTIVE_VALUE    : std_logic := '0'
		);
	port (
		   CLK             : in    std_logic;  -- system clock
 		   RST             : in    std_logic;  -- asynchronous reset, polarity is according to G_RESET_ACTIVE_VALUE
		   SIG_IN          : in    std_logic;  -- async input signal
		   SIG_OUT         : out   std_logic   -- synced & derivative output
		);
	END COMPONENT;





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






	COMPONENT counter

	
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


	END COMPONENT;



	COMPONENT bcd_to_7seg

	port(
    		BCD_IN          : in std_logic_vector(3 downto 0);
   		 D_OUT           : out std_logic_vector(6 downto 0));



	END COMPONENT;






SIGNAL S_SW_START_STOP : std_logic := '0';
SIGNAL S_SW_CLEAR : std_logic := '0';
SIGNAL S_SW_LAP : std_logic := '0';


SIGNAL S_COUNT_LAP :std_logic :='0';
SIGNAL S_COUNT_CLEAR :std_logic :='0';
SIGNAL S_COUNT_ENABLE :std_logic :='0';

SIGNAL S_PULSE :std_logic := '0';

SIGNAL S_BCD1 : std_logic_vector(3 downto 0);
SIGNAL S_BCD2 : std_logic_vector(3 downto 0);
SIGNAL S_BCD3 : std_logic_vector(3 downto 0);
SIGNAL S_BCD4 : std_logic_vector(3 downto 0);

  	




BEGIN




S1: sync_diff
	generic map(
    		G_DERIVATE_RISING_EDGE => true,
    		G_SIG_IN_INIT_VALUE  => '0',  
   		 G_RESET_ACTIVE_VALUE  => '0' 
		)
	port map ( CLK, RSTn, SW_START_STOP, S_SW_START_STOP);


S2: sync_diff
	generic map(
    		G_DERIVATE_RISING_EDGE => true,
    		G_SIG_IN_INIT_VALUE  => '0',  
   		 G_RESET_ACTIVE_VALUE => '0' 
		)
	port map ( CLK, RSTn, SW_CLEAR, S_SW_CLEAR);

S3: sync_diff
	generic map(
    		G_DERIVATE_RISING_EDGE => true,
    		G_SIG_IN_INIT_VALUE  => '0',  
   		 G_RESET_ACTIVE_VALUE  => '0' 
		)
	port map ( CLK, RSTn, SW_LAP, S_SW_LAP);
		  







C1: controller

	generic map( G_RESET_ACTIVE_VALUE  =>'0' 

			)

	port map( CLK, RSTn, SW_START_STOP,SW_CLEAR,SW_LAP, --S_SW_START_STOP
			S_COUNT_ENABLE, S_COUNT_CLEAR,S_COUNT_LAP);



P2 : pulse_generator_new

	generic map( 	G_CLOCKS_PER_PULSE => G_CLOKCS_PER_10ms,
			G_RESET_ACTIVE_VALUE => '0')


	port map(  CLK, RSTn, S_COUNT_CLEAR,S_COUNT_ENABLE,S_PULSE

);
  	
 


C2 : counter


	generic map( 	G_RESET_ACTIVE_VALUE => '0')


	port map(  CLK, RSTn, S_COUNT_CLEAR,S_PULSE,
		S_COUNT_LAP,S_BCD1,S_BCD2,S_BCD3,S_BCD4 );




  


B1 : bcd_to_7seg

	
	port map ( S_BCD1, HUND_ONES_7SEG);


B2 : bcd_to_7seg

	
	port map ( S_BCD2, HUND_TENS_7SEG);


B3 : bcd_to_7seg

	
	port map ( S_BCD3, SEC_ONES_7SEG);


B4 : bcd_to_7seg

	
	port map ( S_BCD4, SEC_TENS_7SEG);
    		
	
	
END struct ;	