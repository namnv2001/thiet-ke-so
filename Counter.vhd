LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS 
	GENERIC (ceil_value: integer);
	PORT(
		clk, inc, clr: IN std_logic;
		z: 			OUT std_logic;
		count: 	OUT integer RANGE 0 TO ceil_value
		);
END counter;

ARCHITECTURE counter_architecture OF counter IS
	SIGNAL temp_counter: integer RANGE 0 TO ceil_value;
	BEGIN 
		PROCESS	
			BEGIN 
			WAIT UNTIL (clk'Event AND clk = '1');
			IF clr = '1' THEN
				temp_counter <= 0;
				z <= '0';
			ELSE 
				IF inc = '1' THEN
				IF temp_counter =  ceil_value - 1 THEN
					z <= '1';
				ELSE 
					temp_counter <= temp_counter + 1;
					z <= '0';
				END IF;
				END IF;
			END IF;
		END PROCESS;
	count <= temp_counter;
END counter_architecture;

