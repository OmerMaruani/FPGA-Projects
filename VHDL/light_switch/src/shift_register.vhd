library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
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
end entity;

architecture behave of shift_register is

	constant INIT_VAL	: std_logic_vector(G_N_BITS-1 downto 0) := (0=>'1', others=>'0');

	signal shift_reg	: std_logic_vector(G_N_BITS-1 downto 0);

begin

	process(CLK, RST)
	begin
		if RST = '0' then
			shift_reg <= INIT_VAL;
		elsif rising_edge(CLK) then
			if ENA = '1' then
				if L_Rn = '1' then
					shift_reg(G_N_BITS-1 downto 1) <= shift_reg(G_N_BITS-2 downto 0);
					shift_reg(0) <= shift_reg(G_N_BITS-1);
				else
					shift_reg(G_N_BITS-2 downto 0) <= shift_reg(G_N_BITS-1 downto 1);
					shift_reg(G_N_BITS-1) <= shift_reg(0);
				end if;
			
			end if;
		
		end if;
	end process;
	
	Q <= shift_reg;

end architecture;