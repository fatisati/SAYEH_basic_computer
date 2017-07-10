library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
ENTITY address_logic IS
	    PORT (
		PCside, Rside : IN std_logic_vector (15 DOWNTO 0);
		Iside : IN std_logic_vector (7 DOWNTO 0);
		ALout : OUT std_logic_vector (15 DOWNTO 0);
		ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : IN std_logic
	    );
	END address_logic;

	ARCHITECTURE dataflow of address_logic IS
	  
	BEGIN
	    PROCESS (ResetPC, PCplus1, Rplus0, Rside, PCplusI, RplusI)
	    BEGIN
		
		    if(ResetPC = '1') then 
				ALout <= (OTHERS => '0');
			
			elsif(PCplus1 = '1') then
				ALout <= PCside + '1';
				
			elsif(Rplus0 = '1') then
				ALout <= Rside;

			elsif(PCplusI ='1') then
				ALout <= PCside + Iside;

			elsif(RplusI='1') then
				ALout <= Rside + Iside;
			end if;
		
	    END PROCESS;
END dataflow;