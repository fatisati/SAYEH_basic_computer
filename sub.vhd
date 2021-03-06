LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sub is
        port( 
		a, b: in  std_logic_vector(15 downto 0);
		cin: in std_logic;
                sub: out std_logic_vector(15 downto 0);
		borrowout: out std_logic
			);
end sub;

architecture BHV of sub is

	component add16
		PORT (  a, b : IN  std_logic_vector(15 DOWNTO 0);
            cin  : IN  STD_LOGIC;
            sum1 : OUT std_logic_vector(15 DOWNTO 0);
            cout : OUT std_logic);
	end component;
	
	signal c0, c1: std_logic;
	signal ib: std_logic_vector(15 downto 0);
	signal ic: std_logic_vector(15 downto 0):= "0000000000000000";
	signal sum0, sum1: std_logic_vector(15 downto 0);
begin

	ib <= not(b); ic(0)<= not(cin);
	s0: add16 port map(a, ib, '1', sum0, c0);
	s1: add16 port map(sum0, ic, '1', sum1, c1);
	
	borrowout<= c0 xor c1;
	sub<= sum1;
end BHV;
