library ieee;
use ieee.std_logic_1164.all;

entity light_organ_tb is
end entity;


architecture behave of light_organ_tb is

	constant num_leds : INTEGER := 7;
	constant size : INTEGER := 7;		

	COMPONENT light_organ

   	GENERIC( G_NUM_OF_LEDS : INTEGER := 8 ;
		G_CLOCKS_PER_PULSE : INTEGER := 4 );
	

   	port(
		CLK : in std_logic;
		RST : in std_logic;
		RATE : in std_logic; -- 0 LEDs shift every 0.5, 1 shift every 0.25
		LEDs : out std_logic_vector(G_NUM_OF_LEDS -1 downto 0)
	);
	
	END COMPONENT;



signal S_CLK	 : std_logic := '0';
signal S_RST	: std_logic := '0';
signal S_RATE	: std_logic := '0';
signal S_LEDS	: std_logic_vector(num_leds  -1 downto 0) :=  (0=>'1', others=>'0'); 
	

	
	
begin
	

DUT : light_organ
	GENERIC MAP(G_NUM_OF_LEDS =>num_leds ,
			G_CLOCKS_PER_PULSE => 4)


	--GENERIC MAP(	G_NUM_OF_LEDS => 8 ,
	--		G_CLOCKS_PER_PULSE => 4 );

	--PORT MAP(S_CLK,S_RST,S_RATE,S_LEDS);

	PORT MAP(CLK=> S_CLK,
		RST => S_RST,
		RATE=>S_RATE,
		LEDS=> S_LEDS
);



----CLOCK------

		PROCESS
		BEGIN
			
			for i in 0 to 150 loop
				wait for 3 ns;
				s_clk <= not s_clk;
	
				wait for 3 ns;
				s_clk <= not s_clk;
				END LOOP;
				wait;
		END PROCESS;






---- Signal's Waves Creation ----





S_RATE <= '1' after 200 ns ;
S_RST<= '0' after 80 ns, '1' after 125 ns;



end architecture;