library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity declaration




entity matrices_mult is
	
	

	port(	CLK:	 	IN std_logic ;
		RSTn:	 	IN std_logic ;
		STARTn:	 	IN std_logic ;
		DISPLAYn:	 IN std_logic ;

		HEX0 : 		OUT std_logic_vector(6 downto 0) ;
		HEX1 : 		OUT std_logic_vector(6 downto 0);
		HEX2 : 		OUT std_logic_vector(6 downto 0);
		HEX3 : 		OUT std_logic_vector(6 downto 0);
		LEDS_1E4 :	 OUT std_logic_vector(3 downto 0);
		LED_SIGN:	 OUT std_logic;
		LEDG : 		OUT std_logic_vector(3 downto 1) );


	
         
end matrices_mult;

-- Dataflow Modelling Style
-- Architecture definition






architecture Logic of matrices_mult is






SIGNAL S_START,S_DISPLAY : std_logic := '0'  ;

SIGNAL S_RESULT : std_logic_vector(16 downto 0) := (others=>'0'); 
SIGNAL S_RESULTS_READY,S_GOT_ALL_MATRICES : std_logic:='0';
SIGNAL S_BIN : std_logic_vector(15 downto 0):= (others=>'0');


SIGNAL S_ONES,S_TENS,S_HUNDS,S_THOUSENDS: std_logic_vector(3 downto 0):=(others=>'0');

SIGNAL	S_DIN:  std_logic_vector(7 downto 0):= (others=>'0');
SIGNAL  S_DIN_VALID , S_DATA_REQUEST :std_logic := '0';

SIGNAL RST :std_logic:= '0';
SIGNAL RST_NOT : std_logic;
















	COMPONENT main_controller

	
	port(	
		CLK: IN std_logic ;
		RST: IN std_logic ;
		START: IN std_logic ;
		DISPLAY: IN std_logic ;
		DIN: IN std_logic_vector(7 downto 0);
		DIN_VALID : IN std_logic;

		DATA_REQUEST :OUT std_logic;
		RESULT: OUT std_logic_vector(16 downto 0); 
		RESULTS_READY : OUT std_logic;
		GOT_ALL_MATRICES: OUT std_logic );
	

	END COMPONENT;




	COMPONENT sync_diff



	generic (
   			 G_DERIVATE_RISING_EDGE  : boolean := true;
   			 G_SIG_IN_INIT_VALUE     : std_logic := '0'
	);
	port (
   			 CLK             : in    std_logic;  -- system clock
   			 RST             : in    std_logic;  -- asynchronous reset, polarity is according to G_RESET_ACTIVE_VALUE
   			 SIG_IN          : in    std_logic;  -- async input signal
   			 SIG_OUT         : out   std_logic   -- synced & derivative output
	);

	END COMPONENT;




	COMPONENT num_convert

	port (
    		CLK                     : in    std_logic;  -- system clock
			RST			: in    std_logic;
			DIN			: in    std_logic_vector(16 downto 0);
			DIN_VALID		: in    std_logic;
			DOUT			: out   std_logic_vector(15 downto 0);
			SIGN			: out   std_logic
	);
	

	END COMPONENT;
	


	COMPONENT bin2bcd_12bit_sync
	
	port ( 
   			 binIN       		: in    std_logic_vector(15 downto 0);     -- this is the binary number
    			ones        		: out   std_logic_vector(3 downto 0);      -- this is the unity digit
   			 tenths      		: out   std_logic_vector(3 downto 0);      -- this is the tens digit
  			  hunderths   		: out   std_logic_vector(3 downto 0);      -- this is the hundreds digit
   			 thousands   		: out   std_logic_vector(3 downto 0);      -- 
   			 tensofthousands	: out   std_logic_vector(3 downto 0);      -- 
			CLK         		: in    std_logic                           -- clock input
	);


	END COMPONENT;

	COMPONENT bcd_to_7seg

	port(
   		 BCD_IN                      : in    std_logic_vector(3 downto 0);
   		 SHUTDOWNn                   : in    std_logic;
   		 D_OUT                       : out   std_logic_vector(6 downto 0));
			
	

	END COMPONENT;




	COMPONENT data_generator

	port(
	CLK				: in    std_logic;	-- system clock
	RST				: in    std_logic;	-- active high reset
	DATA_REQUEST			: in    std_logic;	-- active high, 1 CLK duration
	DOUT				: out   std_logic_vector(7 downto 0); -- data
	DOUT_VALID			: out   std_logic	-- active high data valid
	);

	END COMPONENT;












begin

RST_NOT <= not RSTn;

	

	s1: sync_diff
		
	generic map(
   			 G_DERIVATE_RISING_EDGE  =>false,
   			 G_SIG_IN_INIT_VALUE     => '0' --1 ??
		)
	port map ( CLK, RST_NOT,STARTn,S_START);

	
	s2: sync_diff
		
	generic map(
   			 G_DERIVATE_RISING_EDGE  =>false,
   			 G_SIG_IN_INIT_VALUE     => '0' --1 ??
		)
	port map ( CLK, RST_NOT,DISPLAYn,S_DISPLAY);




	main3 : main_controller
	
	

	port map(CLK,RST_NOT,S_START,S_DISPLAY,S_DIN,S_DIN_VALID,S_DATA_REQUEST, --S_START,S_DISPLAY, S_DATA_REQUEST
		S_RESULT,S_RESULTS_READY,S_GOT_ALL_MATRICES);




	num_c : num_convert

	port map(CLK,RST_NOT,S_RESULT,S_RESULTS_READY,S_BIN,LED_SIGN);
    		
		
	bin2bcd : bin2bcd_12bit_sync
	

	port map ( S_BIN,S_ONES,S_TENS,S_HUNDS,S_THOUSENDS,LEDS_1E4 ,CLK);


       

	bcd1: bcd_to_7seg

	port map(S_ONES,S_RESULTS_READY,HEX0);
	
	bcd2: bcd_to_7seg

	port map(S_TENS,S_RESULTS_READY,HEX1);

	bcd3: bcd_to_7seg

	port map(S_HUNDS,S_RESULTS_READY,HEX2);


	bcd4: bcd_to_7seg

	port map(S_THOUSENDS,S_RESULTS_READY,HEX3);

	d: data_generator

	port map( CLK, RST_NOT , S_DATA_REQUEST,S_DIN,S_DIN_VALID);



	PROCESS(S_GOT_ALL_MATRICES,S_RESULTS_READY)
	BEGIN
		
		LEDG(2) <= S_GOT_ALL_MATRICES;
		LEDG(3) <= S_RESULTS_READY;
		
	END PROCESS;

	LEDG(1) <= '1';
	--SOME OF THEM ACTIVE HIGH RESET , OTHER ACTIVE LOW
	--MAIN_CONTROLLER,NUM CONV, DATA GENERATOR

	


	
	
end Logic ;	