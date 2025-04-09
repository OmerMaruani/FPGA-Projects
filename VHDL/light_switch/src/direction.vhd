library ieee;
use ieee.std_logic_1164.all;

entity direction is
generic(
	G_N_BITS		: integer := 4
);
port (
	RST    			: in 	std_logic;
	CLK     		: in 	std_logic;
	L_Rn    		: out    std_logic;
	Q    			: in 	std_logic_vector(G_N_BITS-1 downto 0)
);
end entity;

architecture behave of direction is
	
--	signal q_sig	: std_logic_vector(G_N_BITS-1 downto 0); 
	signal dir : std_logic :='1';
begin
   
	process(CLK, RST)
	begin
		if RST='0' then
			dir <= '1'; 
		elsif rising_edge(CLK) then
		
			if q(G_N_BITS-1) = '1' then	-- leftmost LED is ON
				if dir = '1' then
					dir <= '0';
				end if;
			elsif q(0) = '1' then 				-- rightmost LED is ON
				if dir = '0' then
					dir <= '1';
				end if;
			end if;

		end if;
	end process;
	
	L_Rn<=dir;
	
end architecture;
