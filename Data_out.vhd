LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY data_out IS 
	GENERIC	(
		ROW_SIZE:	integer;
		COL_SIZE:	integer
		);

	PORT	(
		clk:		IN std_logic;
		we_out:	IN std_logic;
		re_out:	IN std_logic;
		addr:		IN integer RANGE 0 TO COL_SIZE * ROW_SIZE - 1;
		d_in:		IN integer;
		d_out:	OUT integer
		);
END data_out;

ARCHITECTURE data_out_architecture OF data_out IS
	TYPE DATA_ARRAY IS ARRAY(0 TO COL_SIZE * ROW_SIZE - 1) OF integer;
	SIGNAL matrix_out : DATA_ARRAY := (OTHERS => 0);
	BEGIN
		PROCESS(clk)
		BEGIN
			IF (clk'Event AND clk = '1') THEN
				IF (we_out = '1') THEN 
					matrix_out(addr) <= d_in;
				ELSE 
					IF (re_out = '1') THEN
						d_out <= matrix_out(addr);
					END IF;
				END IF;
			END IF;
		END PROCESS;
END data_out_architecture;

