LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY datapath IS 
	GENERIC	(
		ROW_IN:		integer;
		COL_IN:		integer;
		ROW_OUT:	integer;
		COL_OUT:	integer;
		ROW_STEP:	integer;
		COL_STEP:	integer
		);

	PORT	(
		clk:	IN std_logic;
		r_clear, rs_clear, c_clear, cs_clear:	IN std_logic;
		r_increase, rs_increase, c_increase, cs_increase:	IN std_logic;
		r_z, rs_z, c_z, cs_z, greater_than:		OUT std_logic;
		data_in, data_out:	IN integer;
		data_in_address:		OUT integer RANGE 0 TO ROW_IN * COL_IN - 1;
		data_out_address:		OUT integer RANGE 0 TO ROW_OUT * COL_OUT - 1
		);
END datapath;

ARCHITECTURE datapath_architecture OF datapath IS
	
	SIGNAL count_r:		integer RANGE 0 TO ROW_OUT;
	SIGNAL count_rs:	integer RANGE 0 TO ROW_STEP;
	SIGNAL count_c:		integer RANGE 0 TO COL_OUT;
	SIGNAL count_cs:	integer RANGE 0 TO COL_STEP;
	
	BEGIN
	-- counter
	Cnt_r:	counter 
		GENERIC MAP(ceil_value => ROW_OUT)

		PORT MAP(
			clk		=> clk,
			inc		=> r_increase,
			clr		=> r_clear,
			z 		=> r_z,
			count	=> count_r
			);
	Cnt_rs:	counter
		GENERIC MAP(ceil_value => ROW_STEP)
		
		PORT MAP(
			clk		=> clk,
			inc		=> rs_increase,
			clr		=> rs_clear,
			z			=> rs_z,
			count => count_rs
			);
	Cnt_c:	counter
		GENERIC MAP (ceil_value => COL_OUT)

		PORT MAP(
			clk		=> clk,
			inc		=> c_increase,
			clr		=> c_clear,
			z			=> c_z,
			count	=> count_c
			);
	Cnt_cs:	counter
		GENERIC MAP (ceil_value => COL_STEP)
		
		PORT MAP (
			clk		=> clk,
			inc		=> cs_increase,
			clr		=> cs_clear,
			z			=> cs_z,
			count	=> count_cs
			);
	-- Address
	
	data_in_address	<= (count_r * ROW_STEP + count_rs) * ROW_IN + count_c * COL_STEP + count_cs;
	data_out_address	<= count_r * ROW_OUT + count_c;
	greater_than <= '1' WHEN data_in > data_out ELSE '0';
	
END datapath_architecture;

