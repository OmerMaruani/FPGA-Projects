library ieee;
use ieee.std_logic_1164.all;

entity shift_register_tb is
end entity;


architecture behave of shift_register_tb is

	constant CLOCK_PERIOD	: time := 20 ns;
	constant NUM_OF_BITS	: integer := 17;
	
	component shift_register is
	generic (
		G_N_BITS	: integer := 8
	);
	port (
		CLK			: in    std_logic;
		RST			: in    std_logic;
		ENA			: in    std_logic;
		L_Rn		: in    std_logic;
		Q			: out   std_logic_vector(G_N_BITS-1 downto 0)
	);
	end component;

	signal clk_sig	: std_logic := '0';
	signal rst		: std_logic := '0';
	signal ena		: std_logic := '0';
	signal l_rn		: std_logic := '0';
	signal q_sig	: std_logic_vector(NUM_OF_BITS-1 downto 0);
	
	
begin
	
	
	dut: shift_register
	generic map (
		G_N_BITS	=> NUM_OF_BITS
	)
	port map (
		CLK			=> clk_sig,
		RST			=> rst,
		ENA			=> ena,
		L_Rn		=> l_rn,
		Q			=> q_sig
	);
	
	process
	begin
		ena <= '0';
		
		for i in 0 to 29 loop
			wait for 10 us;
			wait until rising_edge(clk_sig);
			ena <= '1';
			wait until rising_edge(clk_sig);
			ena <= '0';
		end loop;
		
		wait;
	end process;
		
	clk_sig <= not clk_sig after CLOCK_PERIOD/2;
	rst <= '0', '1' after 34 ns;
	
	l_rn <= '0', '1' after 150 us;

end architecture;