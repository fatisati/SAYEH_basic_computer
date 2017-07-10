library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pc is
	port (
		PCin: in std_logic_vector(15 downto 0);
		clk, en: in std_logic;
		PCout: out std_logic_vector(15 downto 0)
	);
end pc;

architecture rtl of pc is
begin
	process(clk)
	begin
		if (clk'event and clk = '0') and en='1' then
			PCout <= PCin;
		end if;
	end process;
 
end rtl;
