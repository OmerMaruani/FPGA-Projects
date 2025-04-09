library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
-- Entity declaration




entity counter_tb is 
end entity ;



-- Dataflow Modelling Style
-- Architecture definition

architecture test of counter_tb is


	COMPONENT counter


	 GENERIC( G_RESET_ACTIVE_VALUE: std_logic :='0' );

  	 port(
		CLK : in std_logic;
		RST : in std_logic;
		CLEAR : in std_logic;
		ENA: in std_logic;
		OEn : in std_logic;
		HUND_ONES :out std_logic_vector(3 downto 0);
		HUND_TENS :out  std_logic_vector(3 downto 0);
		SEC_ONES :out  std_logic_vector(3 downto 0);
		SEC_TENS :out  std_logic_vector(3 downto 0) );
	
         


	END COMPONENT;


	--singal is nesecesry--
SIGNAL S_CLK :std_logic := '0'; 

SIGNAL S_RST  : std_logic := '1';
SIGNAL S_CLEAR :std_logic := '0';

SIGNAL S_ENA :std_logic := '1';

SIGNAL S_OEn :std_logic := '0';



SIGNAL S_HUND_ONES : std_logic_vector(3 downto 0) := (others =>'0') ;
SIGNAL S_HUND_TENS : std_logic_vector(3 downto 0) := (others =>'0') ;
SIGNAL S_SEC_ONES : std_logic_vector(3 downto 0) := (others =>'0') ;
SIGNAL S_SEC_TENS : std_logic_vector(3 downto 0) := (others =>'0') ;
	

	


begin
----- dut instantiation -----

DUT : counter
	GENERIC MAP(	G_RESET_ACTIVE_VALUE => '0' )

	--PORT  MAP(S_RATE,S_CLK,S_RESET,S_PULSE);
	PORT MAP(S_CLK,S_RST,S_CLEAR,S_ENA,S_OEn,
		S_HUND_ONES,S_HUND_TENS,S_SEC_ONES,S_SEC_TENS);





----CLOCK------

		PROCESS
		BEGIN
			
			for i in 0 to 1500*10 loop
				wait for 0.5 ns;
				s_clk <= not s_clk;
	
				wait for 0.5 ns;
				s_clk <= not s_clk;
				END LOOP;
				wait;
		END PROCESS;






---- Signal's Waves Creation ----




S_CLEAR <= '0' after 5 ns , '1' after 30 ns , '0' after 100 ns;
S_RST <= '1' after 10 ns;
--S_CLEAR <= '1' after 150 ns, '0' after 160 ns;
--S_RST<= '0' after 150 ns, '1' after 220 ns;
S_ENA<= '0' after 500 ns, '1' after 1000 ns;

S_OEn <= '1' after 1200 ns, '0' after 1700 ns;

end test;	