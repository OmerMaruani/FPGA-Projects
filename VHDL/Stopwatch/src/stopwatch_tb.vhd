library ieee;
use ieee.std_logic_1164.all;

entity stopwatch_tb is
end entity;


architecture behave of stopwatch_tb is
		

	COMPONENT stopwatch
	
   	GENERIC( G_CLOKCS_PER_10ms : INTEGER := 2 );
	

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
	
	END COMPONENT;



signal S_CLK	 : std_logic := '0';
signal S_RSTn    :std_logic := '0';
signal S_SW_START_STOP	: std_logic := '0';
signal S_SW_CLEAR	: std_logic := '0';
signal S_SW_LAP	: std_logic := '0';
signal S_HUND_ONES_7SEG: std_logic_vector(6 downto 0):= (others=>'0') ;
signal S_HUND_TENS_7SEG: std_logic_vector(6 downto 0) := (others=>'0') ;
signal S_SEC_ONES_7SEG : std_logic_vector(6 downto 0) := (others=>'0') ;
signal S_SEC_TENS_7SEG : std_logic_vector(6 downto 0):= (others=>'0') ;

	

	
	
begin
	

DUT : stopwatch

   	GENERIC MAP( G_CLOKCS_PER_10ms => 5 )
	

   	port map(S_CLK,S_RSTn,S_SW_START_STOP,S_SW_CLEAR,
		S_SW_LAP,S_HUND_ONES_7SEG,S_HUND_TENS_7SEG,
		S_SEC_ONES_7SEG,S_SEC_TENS_7SEG);
		








	----CLOCK------

		PROCESS
		BEGIN
			
			for i in 0 to 3000 loop
				wait for 2 ns;
				s_clk <= not s_clk;
	
				wait for 2 ns;
				s_clk <= not s_clk;
				END LOOP;
				wait;
		END PROCESS;






---- Signal's Waves Creation ----





--S_RATE <= '1' after 200 ns ;
--S_RST<= '0' after 80 ns, '1' after 125 ns;




S_RSTn <= '1' after 10 ns, '0' after 2950 ns;
S_SW_START_STOP	<='1' after 100 ns, '0' after 104 ns, '1' after 1000 ns,'0' after 1004 ns;
S_SW_CLEAR  <='1' after 500 ns, '0' after 504 ns;
S_SW_LAP <='1' after 1600 ns , '0' after 1604 ns,
'1' after 1900 ns, '0' after 1904 ns;

end architecture;