LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY Max_pooling_tb IS
END Max_pooling_tb;

ARCHITECTURE arc OF Max_pooling_tb IS

CONSTANT CLK_TIME:		TIME := 20 ns;
CONSTANT ROW_IN:			INTEGER := 32;
CONSTANT COL_IN:			INTEGER := 32;
CONSTANT ROW_OUT:			INTEGER := 8;
CONSTANT COL_OUT:			INTEGER := 8;
CONSTANT ROW_STEP:		INTEGER := 2;
CONSTANT COL_STEP:		INTEGER := 2;

SIGNAL Data_out_addr:	INTEGER RANGE 0 TO ROW_OUT * COL_OUT - 1;
SIGNAL Data_in_addr:	INTEGER RANGE 0 TO ROW_IN * COL_IN - 1;
SIGNAL Data_read_in, Data_read_out, Data_write_in, Data_write_out:	INTEGER;
SIGNAL Clk:		STD_LOGIC := '0';
SIGNAL Start, Reset, Done: STD_LOGIC;

BEGIN 
	Clk <= NOT Clk AFTER CLK_TIME;
	U_Max_pooling : Max_pooling
			GENERIC MAP(
				ROW_IN => ROW_IN,
				COL_IN => COL_IN,
				ROW_OUT => ROW_OUT,
				COL_OUT => COL_OUT,
				ROW_STEP => ROW_STEP,
				COL_STEP => COL_STEP
				)
			PORT MAP(
				Clk => Clk,
				Start => Start,
				Reset => Reset,
				Done => Done
				);
	TESTING: PROCESS
	BEGIN
		Reset <= '1';
		WAIT FOR 100 ns;
		Reset <= '0';
		Start <= '1';
		WAIT;
	END PROCESS;

END arc;
