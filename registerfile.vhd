library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerfile is
	port (
		clk, rflwrite, rfhwrite: in std_logic; --register file low/high write
		databus: in std_logic_vector(15 downto 0);
		wp: in std_logic_vector(5 downto 0);
		irs, ird: in std_logic_vector(1 downto 0); --input
		rs, rd: out std_logic_vector(15 downto 0)
		
	);
end registerfile;

architecture rtl of registerfile is

	component add16
		PORT (  a, b : IN  std_logic_vector(15 DOWNTO 0);
            cin  : IN  STD_LOGIC;
            sum1 : OUT std_logic_vector(15 DOWNTO 0);
            cout : OUT std_logic);
	end component;
	signal iwp, iirs, iird: std_logic_vector(15 downto 0);
	signal sum0, sum1: std_logic_vector(15 downto 0);
	signal c0, c1: std_logic;

type reg is array(0 to 63) of std_logic_vector(15 downto 0);
signal registers : reg;
begin	
	iwp<= "0000000000" & wp;
	iirs<= "00000000000000" & irs;
	iird<= "00000000000000" & ird;
	add0: add16 port map(iwp , iirs, '0', sum0, c0); --rs address
	add1: add16 port map(iwp , iird, '0', sum1, c1); --rd address

	rs<= registers(to_integer(unsigned(sum0)));
	rd<= registers(to_integer(unsigned(sum1)));
	
	
	process(clk)
	begin
		if (clk = '1') then
			
			if(rflwrite = '1') then
				registers(to_integer(unsigned(sum1)))(7 downto 0) <= databus(7 downto 0);
			end if;
			

			if(rfhwrite = '1') then
				registers(to_integer(unsigned(sum1)))(15 downto 8) <= databus(15 downto 8);
			end if;
		end if;
		
	end process;
 
end rtl;