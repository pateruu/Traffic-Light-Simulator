library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic;


BEGIN

hold: PROCESS (clk)  -- this process updates with a clock

BEGIN

	IF (rising_edge(clk)) THEN
			
			IF (reset = '1') THEN
				
				sreg <= '0';
				dout <= '0';
			
			ELSIF (reset = '0') THEN
				
				sreg <= NOT(reset OR register_clr) AND (sreg OR din);

				END IF;
	
	END IF;
					dout <= sreg;

	
END process;


end;