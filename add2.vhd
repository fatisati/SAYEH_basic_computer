LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY add2 IS
    PORT( a, b  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          cin   : IN  STD_LOGIC;
          ans   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          cout  : OUT STD_LOGIC
    );
END add2;

ARCHITECTURE STRUCTURE OF add2 IS

    COMPONENT add1
        PORT( a, b, cin  : IN  STD_LOGIC;
                sum, cout  : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL c1 : STD_LOGIC;

BEGIN

    b_adder0: add1 PORT MAP (a(0), b(0), cin, ans(0), c1);
    b_adder1: add1 PORT MAP (a(1), b(1), c1, ans(1), cout);

END STRUCTURE;
