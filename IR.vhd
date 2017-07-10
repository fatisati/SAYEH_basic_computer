library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IR is
	port (
		IRin: in std_logic_vector(15 downto 0);
		IRload, clk: in std_logic;
		IRout: out std_logic_vector(15 downto 0)
	);
end IR;

architecture bhv of IR is
begin
	process(clk)
	begin
		if (clk'event and clk = '0') then
			if(IRload = '1') then
				IRout<= IRin;
			end if;
		end if;
	end process;
 
end bhv;
