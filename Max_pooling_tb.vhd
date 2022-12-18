LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY max_pooling_tb IS
END max_pooling_tb;

ARCHITECTURE arc OF max_pooling_tb IS

CONSTANT CLK_TIME:		TIME := 20 ns;
CONSTANT ROW_IN:			integer := 32;
CONSTANT COL_IN:			integer := 32;
CONSTANT ROW_OUT:			integer := 16;
CONSTANT COL_OUT:			integer := 16;
CONSTANT ROW_STEP:		integer := 2;
CONSTANT COL_STEP:		integer := 2;

SIGNAL data_out_address:	integer RANGE 0 TO ROW_OUT * COL_OUT - 1;
SIGNAL data_in_address:		integer RANGE 0 TO ROW_IN * COL_IN - 1;
SIGNAL data_read_in, data_read_out, data_write_in, Data_write_out:	integer;
SIGNAL clk:	std_logic := '0';
SIGNAL start, reset, done: std_logic;

BEGIN 
	clk <= NOT clk AFTER CLK_TIME;
	U_Max_pooling : max_pooling
			GENERIC MAP(
				ROW_IN => ROW_IN,
				COL_IN => COL_IN,
				ROW_OUT => ROW_OUT,
				COL_OUT => COL_OUT,
				ROW_STEP => ROW_STEP,
				COL_STEP => COL_STEP
				)
			PORT MAP(
				clk => clk,
				start => start,
				reset => reset,
				done => done
				);
	testing: PROCESS
	BEGIN
		reset <= '1';
		WAIT FOR 100 ns;
		reset <= '0';
		start <= '1';
		WAIT;
	END PROCESS;

END arc;
