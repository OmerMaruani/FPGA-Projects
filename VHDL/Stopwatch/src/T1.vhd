library ieee;
use ieee.std_logic_1164.all;


entity T1 is 
	port(A,B,C,EN: IN std_logic;
		Y : OUT std_logic);


end T1;


architecture be of T1 is

signal s1,s2 : std_logic;


begin 

s1<= A OR B;
s2<= NOT B AND C;
Y<= s1 OR s2 WHEN EN= '1' ELSE 'Z';

end be;