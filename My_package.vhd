LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE MY_PACKAGE IS

COMPONENT counter IS
	GENERIC	(ceil_value: integer);

	PORT	(
		clk, inc, clr:	IN std_logic;
		z:			OUT std_logic;
		count:	OUT integer RANGE 0 TO ceil_value
		);
END COMPONENT;

COMPONENT data_out IS
	GENERIC (
		ROW_SIZE:		integer;
		COL_SIZE:		integer
		);
	
	PORT	(
		clk:		IN std_logic;
		we_out:	IN std_logic;
		re_out:	IN std_logic;
		addr:		IN integer RANGE 0 TO ROW_SIZE * COL_SIZE - 1;
		d_in:		IN integer;
		d_out:	OUT integer
		);		
END COMPONENT;

COMPONENT data_in IS
	GENERIC (
		ROW_SIZE:		integer;
		COL_SIZE:		integer
		);
	
	PORT	(
		clk:		IN std_logic;
		we_in:	IN std_logic;
		re_in:	IN std_logic;
		addr:		IN integer RANGE 0 TO ROW_SIZE * COL_SIZE - 1;
		d_in:		IN integer;
		d_out:	OUT integer
		);		
END COMPONENT;

COMPONENT controller IS

	PORT	(
		start:	IN std_logic;
		clk:		IN std_logic;
		reset:	IN std_logic;
		r_z, rs_z, c_z, cs_z, greater_than:	IN std_logic;
		r_clear, rs_clear, c_clear, cs_clear:	OUT std_logic;
		r_increase, rs_increase, c_increase, cs_increase:	OUT std_logic;
		re_in, re_out, we_in, we_out:	OUT std_logic;
		done:		OUT std_logic
		);
END COMPONENT;

COMPONENT datapath IS
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
		data_in, data_out:	IN integer;
		r_z, rs_z, c_z, cs_z, greater_than:		OUT std_logic;
		data_in_address:		OUT integer RANGE 0 TO ROW_IN * COL_IN - 1;
		data_out_address:	OUT integer RANGE 0 TO ROW_OUT * COL_OUT - 1
		);
END COMPONENT;

COMPONENT max_pooling IS
	GENERIC	(
		ROW_IN:		integer;
		COL_IN:		integer;
		ROW_OUT:	integer;
		COL_OUT:	integer;
		ROW_STEP:	integer;
		COL_STEP:	integer
		);
		
	PORT	(
		clk:		IN std_logic;
		start:	IN std_logic;
		reset:	IN std_logic;		
		done:		OUT std_logic
		);	
END COMPONENT;	

END PACKAGE MY_PACKAGE;

