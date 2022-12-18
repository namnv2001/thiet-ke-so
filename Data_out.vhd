LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Data_out IS 
	GENERIC	(
		ROW_SIZE:	INTEGER;
		COL_SIZE:	INTEGER
		);

	PORT	(
		Clk:		IN STD_LOGIC;
		We_out:	IN STD_LOGIC;
		Re_out:	IN STD_LOGIC;
		Addr:		IN INTEGER RANGE 0 TO COL_SIZE * ROW_SIZE - 1;
		Din:		IN INTEGER;
		Dout:		OUT INTEGER
		);
END Data_out;

ARCHITECTURE Data_out_architecture OF Data_out IS
	TYPE DATA_ARRAY IS ARRAY(0 TO COL_SIZE * ROW_SIZE - 1) OF INTEGER;	--Memory Type
	SIGNAL Matrix_out : DATA_ARRAY := (OTHERS => 0);
	BEGIN
		PROCESS(Clk)
		BEGIN
			IF (Clk'Event AND Clk = '1') THEN
				IF (We_out = '1') THEN 
					Matrix_out(Addr) <= Din;
				ELSE 
					IF (Re_out = '1') THEN
						Dout <= Matrix_out(Addr);
					END IF;
				END IF;
			END IF;
		END PROCESS;
END Data_out_architecture;

