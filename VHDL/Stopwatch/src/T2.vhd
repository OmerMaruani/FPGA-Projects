library ieee;
use ieee.std_logic_1164.all;


entity T2 is 
	port(A,B,CIN: IN std_logic;
		COUT,SUM : OUT std_logic);


end T2;


architecture be of T2 is

signal s1,s2,s3 : std_logic;


begin 

s1<= A AND B;
s2<= A AND CIN;
s3<= B AND CIN;

COUT <= s3 or s1 or s2;
SUM <= CIN XOR A XOR B;


end be;