library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity datapath is
	port (
		clk, controller_rst, memdataready: in std_logic;
		databus: inout std_logic_vector(15 downto 0);
		addressbus: out std_logic_vector (15 downto 0);
		instruction0: out std_logic_vector (7 downto 0);
		readmem, writemem, readio, writeio: out std_logic
	);
end datapath;

architecture rtl of datapath is

	component address_logic
		PORT (
		PCside, Rside : IN std_logic_vector (15 DOWNTO 0);
		Iside : IN std_logic_vector (7 DOWNTO 0);
		ALout : OUT std_logic_vector (15 DOWNTO 0);
		ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : IN std_logic
	    	);
	end component;

	component pc
		port (
		PCin: in std_logic_vector(15 downto 0);
		clk, en: in std_logic;
		PCout: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component IR
		port (
		IRin: in std_logic_vector(15 downto 0);
		IRload, clk: in std_logic;
		IRout: out std_logic_vector(15 downto 0)
		);
	end component;

	component controller
		port (
		irin: in std_logic_vector(15 downto 0);
		clk, rst, memdataready, c, z: in std_logic;
		IRload, readMem, writemem, rstpc, pcplusI, pcplus1, rplusI, rplus0, pcen: out std_logic;
		rdonrside, rsonaddressbus, rfonopndbus, aluondatabus, irlonopndbus, dataonaddressbus: out std_logic; --on bus signals
		rflwrite, rfhwrite: out std_logic; --register bus
		bout, iand, ior, inot, ishl, ishr, iadd, isub, 
		 imult, icmp, idiv, isqr, irand, itcom, ixor, isin, icos, itan, icot: out std_logic; --alu
		cset, creset, zset, zreset, srload: out std_logic;
		wpadd, wpreset: out std_logic; --wp
		cinstruction: out std_logic_vector(7 downto 0) -- controller instruction
		);
	end component;

	component registerfile
		port (
		clk, rflwrite, rfhwrite: in std_logic; --register file low/high write
		databus: in std_logic_vector(15 downto 0);
		wp: in std_logic_vector(5 downto 0);
		irs, ird: in std_logic_vector(1 downto 0); --input
		rs, rd: out std_logic_vector(15 downto 0)
		);
	end component;

	component wp
		port (
		clk, wpadd, wpreset: in std_logic;
		irin: in std_logic_vector(5 downto 0);
		wpout: out std_logic_vector(5 downto 0)
		);
	end component;
	
	component alu
		port (
		a, b: in std_logic_vector(15 downto 0);
		cin, zin: in std_logic;
		bout, iand, ior, inot, ishl, ishr, iadd, isub, 
		imult, icmp, idiv, isqr, irand, itcom, ixor, isin, icos, itan, icot : in std_logic;
		iout: out std_logic_vector(15 downto 0);
		cout, zout: out std_logic
		
		);
	end component;

	component flags

		port (
		clk,cin, zin,
		 cset, creset, zset, zreset, srload: in std_logic;
		 cout, zout: out std_logic
		
		);
	end component;
	
	--signal memdataready: std_logic;
	signal pcside, rside: std_logic_vector(15 downto 0);
	signal instruction: std_logic_vector(7 downto 0);
	signal iside: std_logic_vector(7 downto 0);
	signal IRload, rstpc, pcplusI, pcplus1, rplusI, rplus0, pcen: std_logic;
	signal iaddressbus: std_logic_vector(15 downto 0);

	signal rdonrside, rsonaddressbus, rfonopndbus, aluondatabus, irlonopndbus, dataonaddressbus: std_logic; --on bus signals
	signal	rflwrite, rfhwrite: std_logic; --register bus
	signal	bout, iand, ior, inot, ishl, ishr, iadd, isub, 
		 imult, icmp, idiv, isqr, irand, itcom, ixor, isin, icos, itan, icot: std_logic;--alu
	
	signal c, z: std_logic;
	--signal databus: std_logic_vector(15 downto 0);
	signal rs, rd: std_logic_vector(15 downto 0);
	signal wpout: std_logic_vector(5 downto 0);
	signal wpadd, wpreset : std_logic;
	
	signal a, b: std_logic_vector(15 downto 0);
	signal aluout: std_logic_vector(15 downto 0);
	signal irout: std_logic_vector(15 downto 0);

	signal cin, zin,
		 cset, creset, zset, zreset, srload,
		 cout, zout: std_logic;
	
begin
	--mem: memory port map(clk, readmem, writemem, addressbus, databus, memdataready);
	addressl: address_logic port map(pcside, rside, irout(7 downto 0), iaddressbus, rstpc, pcplusI, pcplus1, rplusI, rplus0);
	pc0: pc port map(iaddressbus, clk, pcen, pcside);
	ir0: IR port map(databus, IRload, clk, irout);
	
	cont: controller port map(irout,
		clk, controller_rst, memdataready,cout, zout,
		IRload, readMem, writemem, rstpc, pcplusI, pcplus1, rplusI, rplus0, pcen,
		rdonrside, rsonaddressbus, rfonopndbus, aluondatabus, irlonopndbus, dataonaddressbus, 
		rflwrite, rfhwrite,
		bout, iand, ior, inot, ishl, ishr, iadd, isub, 
		 imult, icmp, idiv, isqr, irand, itcom, ixor, isin, icos, itan, icot,
		cset, creset, zset, zreset, srload,
		wpadd, wpreset,
		instruction);
	
	reg0: registerfile port map(clk, rflwrite, rfhwrite, databus, wpout, instruction(1 downto 0), instruction(3 downto 2), rs, rd); --wp
	wp0: wp port map(clk, wpadd, wpreset, irout(5 downto 0), wpout);
	alu0: alu port map(rd, b, cout, zout, bout, iand, ior, inot, ishl, ishr, iadd, isub, 
		 imult, icmp, idiv, isqr, irand, itcom, ixor, isin, icos, itan, icot, aluout, cin, zin);

	fl0: flags port map(clk,cin, zin,
		 cset, creset, zset, zreset, srload, cout, zout);
	
	addressbus<=iaddressbus;
	instruction0<= instruction;
	
	process(rdonrside, rsonaddressbus, aluondatabus, rfonopndbus, irlonopndbus, dataonaddressbus)
	begin
	
		if(rdonrside = '1') then
			rside <= rd;
		
		elsif(rsonaddressbus ='1') then
			rside <= rs;
		else
			rside <= (others => 'Z');
		end if;
		
		if(aluondatabus = '1') then
			databus <= aluout;
		elsif(dataonaddressbus ='1') then
			databus<= iaddressbus;
		else
			databus <= (others => 'Z');
		end if;
		
		if(rfonopndbus = '1') then
			b<= rs;
		elsif(irlonopndbus = '1') then
			b <= "00000000" & irout(7 downto 0);
		else
			b<= (others => 'Z');
		end if;
		
		
	end process;
 
end rtl;
