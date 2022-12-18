LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY Max_pooling IS
	GENERIC(
		DATA_WIDTH:	INTEGER;
		ROW_IN:		INTEGER;
		COL_IN:		INTEGER;
		ROW_OUT:	INTEGER;
		COL_OUT:	INTEGER;
		ROW_STEP:	INTEGER;
		COL_STEP:	INTEGER
		);
	
	PORT	(
		Start, Clk, Reset:	IN STD_LOGIC;
		Done: OUT STD_LOGIC
		);

END Max_pooling;

ARCHITECTURE Max_pooling_architecture OF Max_pooling IS

	SIGNAL R_clr, Rs_clr, C_clr, Cs_clr:	STD_LOGIC;
	SIGNAL R_inc, Rs_inc, C_inc, Cs_inc:	STD_LOGIC;
	SIGNAL R_z, Rs_z, C_z, Cs_z, Gt:			STD_LOGIC;
	SIGNAL Re_in, Re_out, We_in, We_out:	STD_LOGIC;
	SIGNAL Data_in_addr:	INTEGER RANGE 0 TO ROW_IN * COL_IN - 1;
	SIGNAL Data_out_addr:	INTEGER RANGE 0 TO ROW_OUT * COL_OUT - 1;
	SIGNAL Data_write_in:	INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;
	SIGNAL Data_read_in, Data_read_out:		INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;

	BEGIN
		----- Memory -----
		U_Data_out : Data_out
			GENERIC MAP(
				DATA_WIDTH => DATA_WIDTH,
				ROW_SIZE => ROW_OUT,
				COL_SIZE => COL_OUT
				)
			PORT MAP(
				Clk => Clk,
				We_out => We_out,
				Re_out => Re_out,
				Addr => Data_out_addr,
				Din => Data_read_in,
				Dout => Data_read_out
				);	
		
		U_Data_in : Data_in
			GENERIC MAP(
				DATA_WIDTH => DATA_WIDTH,
				ROW_SIZE => ROW_IN,
				COL_SIZE => COL_IN
				)
			PORT MAP(
				Clk => Clk,
				We_in => We_in,
				Re_in => Re_in,
				Addr => Data_in_addr,
				Din => Data_write_in,
				Dout => Data_read_in
				);

		U_Controller : Controller
			GENERIC MAP(DATA_WIDTH => DATA_WIDTH)

			PORT MAP(
				Clk => Clk,
				Start => Start,
				Reset => Reset,

				R_clr => R_clr,
				Rs_clr => Rs_clr,
				C_clr => C_clr,
				Cs_clr => Cs_clr,

				R_inc => R_inc,
				Rs_inc => Rs_inc,
				C_inc => C_inc,
				Cs_inc => Cs_inc,

				R_z => R_z,
				Rs_z => Rs_z,
				C_z => C_z,
				Cs_z => Cs_z,
				Gt => Gt,

				Re_in => Re_in,
				Re_out => Re_out,
				We_in => We_in,
				We_out => We_out,
				
				
				Done => Done
				);

		U_Datapath : Datapath
			GENERIC MAP(
				DATA_WIDTH => DATA_WIDTH,
				ROW_IN => ROW_IN,
				COL_IN => COL_IN,
				ROW_OUT => ROW_OUT,
				COL_OUT => COL_OUT,
				ROW_STEP => ROW_STEP,
				COL_STEP => COL_STEP
				)
			PORT MAP(
				Clk => Clk,

				R_clr => R_clr,
				Rs_clr => Rs_clr,
				C_clr => C_clr,
				Cs_clr => Cs_clr,

				R_inc => R_inc,
				Rs_inc => Rs_inc,
				C_inc => C_inc,
				Cs_inc => Cs_inc,

				Data_in => Data_read_in,
				Data_out => Data_read_out,

				R_z => R_z,
				Rs_z => Rs_z,
				C_z => C_z,
				Cs_z => Cs_z,
				Gt => Gt,
				Data_in_addr => Data_in_addr,
				Data_out_addr => Data_out_addr
				);

END Max_pooling_architecture;

