LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Counter IS 
	GENERIC (Ceil_value: INTEGER);
	PORT(
		Clk, Inc, Clr: IN STD_LOGIC;
		Z: 			OUT STD_LOGIC;
		Count: 	OUT INTEGER RANGE 0 TO Ceil_value
		);
END Counter;

ARCHITECTURE Counter_architecture OF Counter IS
	SIGNAL Temp_counter: INTEGER RANGE 0 TO Ceil_value;
	BEGIN 
		PROCESS	
			BEGIN 
			WAIT UNTIL (Clk'Event AND Clk = '1');
			IF Clr = '1' THEN
				Temp_counter <= 0;
				Z <= '0';
			ELSE 
				IF Inc = '1' THEN
				IF Temp_counter =  Ceil_value - 1 THEN
					Z <= '1';
				ELSE 
					Temp_counter <= Temp_counter + 1;
					Z <= '0';
				END IF;
				END IF;
			END IF;
		END PROCESS;
	Count <= Temp_counter;
END Counter_architecture;

