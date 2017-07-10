--------------------------------------------------------------------------------
-- Author:        Parham Alvani (parham.alvani@gmail.com)
--
-- Create Date:   16-03-2017
-- Module Name:   memory.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
	generic (blocksize : integer := 1024);

	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : inout std_logic_vector (15 downto 0);
		memdataready : out std_logic);
end entity memory;

architecture behavioral of memory is
	type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);
begin
	process (clk, readmem)
		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then
			-- some initiation
			
			buffermem(0) := "0000101000000010"; --add wp
			buffermem(1) := "1111000000000000"; --mil r0<= 0
			buffermem(3) := "1111000100000000"; --mih r0
			buffermem(4) := "1111010000000001"; --mil r1<=1
			buffermem(5) := "1111010100000000"; --mih r1
			buffermem(6) := "1100000100101001"; --r0<=r0+r1 -lda: r2<-mem(r1)
			buffermem(7) := "0011010011100001"; --sta mem(r1) <- r0 -cmp r0 and r1
			buffermem(8) := "0000100000000010"; --pc<= pc+2 if z=1
			buffermem(10) := "1111101000000011"; --r2<=pc+3
			buffermem(11) := "1111101100000010"; --pc <= r2+2
			init := false;
		end if;

		

		if  clk'event and clk = '1' then
			ad := to_integer(unsigned(addressbus));

			if readmem = '1' then -- Readiing :)
				memdataready <= '0';
				if ad >= blocksize then
					databus <= (others => 'Z');
				else
					databus <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				memdataready <= '0';
				if ad < blocksize then
					buffermem(ad) := databus;
				end if;
			else
				databus <= (others => 'Z');

			end if;
			memdataready <= '1';
		end if;
	end process;
end architecture behavioral;
