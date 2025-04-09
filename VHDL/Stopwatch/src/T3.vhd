library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity T3 is 
	port(CLK,EN,ID,IK,UD: IN std_logic;
		DIN : IN std_logic_vector( 7 downto 0);
		DOUT : OUT std_logic_vector(7 downto 0) )
;


end T3;


architecture be of T3 is



SIGNAL CNT : std_logic_vector(7 downto 0);
SIGNAL K : std_logic_vector(3 downto 0);

begin 


DOUT <= CNT WHEN EN = '1' ELSE  (others => 'Z');
	PROCESS(CLK,ID,IK)

	BEGIN

	IF ID = '1' THEN
		CNT <= DIN;

	ELSIF IK ='1' THEN
		K <= DIN(3 DOWNTO 0);

	ELSIF clk'event and clk = '1' AND EN = '1' THEN
		
		IF EN= '1' THEN

			IF UD = '1' THEN
				IF CNT <255 THEN
					CNT <= CNT+ K;
				ELSE
					CNT<= (OTHERS =>'0') ;

				END IF;


			ELSIF UD = '0' THEN

				IF CNT > 0 THEN
					CNT <= CNT-K;
				ELSE 
					CNT <= (OTHERS => '1');

				END IF;
			END IF;


		END IF;
	END IF;
	
	END PROCESS;

end be;