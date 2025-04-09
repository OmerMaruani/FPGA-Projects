library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration




entity light_organ is


   	GENERIC( G_NUM_OF_LEDS : INTEGER := 8 ;
		G_CLOCKS_PER_PULSE : INTEGER := 50e6 );
	

   	port(
		CLK : in std_logic;
		RST : in std_logic;
		RATE : in std_logic; -- 0 LEDs shift every 0.5, 1 shift every 0.25
		LEDs : out std_logic_vector(G_NUM_OF_LEDS-1 downto 0)
	);
	
         
end light_organ;

-- Dataflow Modelling Style
-- Architecture definition

ARCHITECTURE struct OF light_organ IS


	COMPONENT pulse_generator

		
  	 GENERIC( G_CLOCKS_PER_PULSE : INTEGER := 4);
  	 PORT (
		CLK : in std_logic;
		RESET : in std_logic;
		RATE : in std_logic;
		PULSE : out std_logic );
	END COMPONENT;





	COMPONENT direction

	GENERIC(G_N_BITS		: integer := 4);
	PORT (
		RST : in std_logic;
		CLK : in std_logic;
		L_Rn: out std_logic;
		Q   : in std_logic_vector(G_N_BITS-1 downto 0)
);

	END COMPONENT;



	COMPONENT shift_register

		
  	GENERIC(G_N_BITS: integer := 8);
	PORT(
		CLK: in  std_logic;
		RST: in  std_logic;
		ENA: in  std_logic;
		L_Rn:in  std_logic;
		Q: out   std_logic_vector(G_N_BITS-1 downto 0));

	END COMPONENT;



SIGNAL S_dir : std_logic:= '0' ;
SIGNAL S_pulse : std_logic:= '0' ;
SIGNAL S_Q : std_logic_vector(G_NUM_OF_LEDS-1 downto 0):=  (0=>'1', others=>'0');





BEGIN



U1: pulse_generator
	GENERIC MAP ( G_CLOCKS_PER_PULSE=> G_CLOCKS_PER_PULSE)
	PORT MAP( CLK => CLK,
		  RESET => RST,
		  RATE => RATE,
		  PULSE =>  S_PULSE) ; -- check this one -----

U2 : direction
	GENERIC MAP(G_N_BITS => G_NUM_OF_LEDS)
	PORT MAP(
		RST => RST,
		CLK => CLK,
		L_Rn => S_DIR, --out--
	
		Q => S_Q ) ;  -- in--
U3: shift_register

	GENERIC MAP(G_N_BITS => G_NUM_OF_LEDS)
	PORT MAP(
		CLK => CLK,
		RST => RST,
		ENA => S_PULSE,
		L_Rn=> S_DIR,
		Q => S_Q ) ;


	LEDs <= S_Q;


	
	
END struct ;	