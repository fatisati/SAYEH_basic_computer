library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity alu is
	port (
		a, b: in std_logic_vector(15 downto 0);
		cin, zin: in std_logic;
		bout, iand, ior, inot, ishl, ishr, iadd, isub, 
		imult, icmp, idiv, isqr, irand, itcom, ixor, isin, icos, itan, icot : in std_logic;
		iout: out std_logic_vector(15 downto 0);
		cout, zout: out std_logic
		
	);
end entity alu;

architecture Behavioral of alu is

	component add16 
		PORT (  a, b : IN  std_logic_vector(15 DOWNTO 0);
            		cin  : IN  STD_LOGIC;
          	 	sum1 : OUT std_logic_vector(15 DOWNTO 0);
           	 	cout : OUT std_logic);
	end component;

	component sub
		
		port( 
		a, b: in  std_logic_vector(15 downto 0);
		cin: in std_logic;
                sub: out std_logic_vector(15 downto 0);
		borrowout: out std_logic
			);
	end component;
	
	signal icout, isubc, tmp: std_logic;
	signal sumout, subout, comp, anot: std_logic_vector(15 DOWNTO 0);
begin
	anot<= not(a);
	ad0: add16 port map(a, b, cin, sumout, icout);
	ad1: add16 port map(anot, "0000000000000001", '0', comp, tmp);
	sub0: sub port map(a, b, cin, subout, isubc);
	process (a, b, bout, iand, ior, inot, ishl, ishr, iadd, isub, 
		imult, icmp, idiv, isqr, irand, itcom, ixor, isin, icos, itan, icot) is
	begin
		if(bout='1') then
			iout<= b;

		elsif(iand = '1') then
			iout<= a and b;

		elsif(iadd='1') then 
			iout<=sumout; cout<=icout; zout<=zin;

		elsif(isub='1') then
			iout<=subout; cout<=isubc; zout<=zin;
			
		elsif(ior='1') then 
			iout<=a or b; cout<=cin; zout<=zin;
		
		elsif(inot='1') then 
			iout<=not(a); cout<=cin; zout<=zin;
			
		elsif(ishl='1') then 
			iout<=a(15 downto 1) & '0'; cout<=cin; zout<=zin;

		elsif(ishr='1') then 
			iout<='0' & a(15 downto 1); cout<=cin; zout<=zin;
			
		elsif(icmp='1') then 
		
			if(a = b) then
				zout<='1'; cout<='0';
			elsif(a < b) then
				cout<='1'; zout<='0';
			else
				cout<='0'; zout<='0';
			end if;

		elsif(ixor='1') then 
			iout<=a xor b; cout<=cin; zout<=zin;

		elsif(itcom='1') then 
			iout<=comp; cout<=cin; zout<=zin;
		
		else
			zout<=zin; cout<=cin;
		end if;
	end process;

end architecture Behavioral;