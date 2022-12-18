LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY max_pooling IS
	GENERIC(
		ROW_IN:		integer;
		COL_IN:		integer;
		ROW_OUT:	integer;
		COL_OUT:	integer;
		ROW_STEP:	integer;
		COL_STEP:	integer
		);
	
	PORT	(
		start, clk, reset:	IN std_logic;
		done: OUT std_logic
		);

END max_pooling;

ARCHITECTURE max_pooling_architecture OF max_pooling IS

	SIGNAL r_clear, rs_clear, c_clear, cs_clear:	std_logic;
	SIGNAL r_increase, rs_increase, c_increase, cs_increase:	std_logic;
	SIGNAL r_z, rs_z, c_z, cs_z, greater_than:			std_logic;
	SIGNAL re_in, re_out, we_in, we_out:	std_logic;
	SIGNAL data_in_address:	integer RANGE 0 TO ROW_IN * COL_IN - 1;
	SIGNAL data_out_address:	integer RANGE 0 TO ROW_OUT * COL_OUT - 1;
	SIGNAL data_write_in:	integer;
	SIGNAL data_read_in, data_read_out:	integer;

	BEGIN
		----- Memory -----
		U_Data_out : data_out
			GENERIC MAP(
				ROW_SIZE => ROW_OUT,
				COL_SIZE => COL_OUT
				)
			PORT MAP(
				clk => clk,
				we_out => we_out,
				re_out => re_out,
				addr => data_out_address,
				d_in => data_read_in,
				d_out => data_read_out
				);	
		
		U_Data_in : data_in
			GENERIC MAP(
				ROW_SIZE => ROW_IN,
				COL_SIZE => COL_IN
				)
			PORT MAP(
				clk => clk,
				we_in => we_in,
				re_in => re_in,
				addr => data_in_address,
				d_in => data_write_in,
				d_out => data_read_in
				);

		U_Controller : controller
			PORT MAP(
				clk => clk,
				start => start,
				reset => reset,

				r_clear => r_clear,
				rs_clear => rs_clear,
				c_clear => c_clear,
				cs_clear => cs_clear,

				r_increase => r_increase,
				rs_increase => rs_increase,
				c_increase => c_increase,
				cs_increase => cs_increase,

				r_z => r_z,
				rs_z => rs_z,
				c_z => c_z,
				cs_z => cs_z,
				greater_than => greater_than,

				re_in => re_in,
				re_out => re_out,
				we_in => we_in,
				we_out => we_out,
				
				done => done
				);

		U_Datapath : datapath
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

				r_clear => r_clear,
				rs_clear => rs_clear,
				c_clear => c_clear,
				cs_clear => cs_clear,

				r_increase => r_increase,
				rs_increase => rs_increase,
				c_increase => c_increase,
				cs_increase => cs_increase,

				data_in => data_read_in,
				data_out => data_read_out,

				r_z => r_z,
				rs_z => rs_z,
				c_z => c_z,
				cs_z => cs_z,
				greater_than => greater_than,
				data_in_address => data_in_address,
				data_out_address => data_out_address
				);

END max_pooling_architecture;

