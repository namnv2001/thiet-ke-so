LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY Datapath IS 
	GENERIC	(
		ROW_IN:		INTEGER;
		COL_IN:		INTEGER;
		ROW_OUT:	INTEGER;
		COL_OUT:	INTEGER;
		ROW_STEP:	INTEGER;
		COL_STEP:	INTEGER
		);

	PORT	(
		Clk:	IN STD_LOGIC;
		R_clr, Rs_clr, C_clr, Cs_clr:	IN STD_LOGIC;
		R_inc, Rs_inc, C_inc, Cs_inc:	IN STD_LOGIC;
		R_z, Rs_z, C_z, Cs_z, Gt:			OUT STD_LOGIC;
		Data_in, Data_out:		IN INTEGER;
		Data_in_addr:					OUT INTEGER RANGE 0 TO ROW_IN * COL_IN - 1;
		Data_out_addr:				OUT INTEGER RANGE 0 TO ROW_OUT * COL_OUT - 1
		);
END Datapath;

ARCHITECTURE Datapath_architecture OF Datapath IS
	
	SIGNAL Count_r:		INTEGER RANGE 0 TO ROW_OUT;
	SIGNAL Count_rs:	INTEGER RANGE 0 TO ROW_STEP;
	SIGNAL Count_c:		INTEGER RANGE 0 TO COL_OUT;
	SIGNAL Count_cs:	INTEGER RANGE 0 TO COL_STEP;
	
	BEGIN
	-- Counter
	Cnt_r:	Counter 
		GENERIC MAP(Ceil_value => ROW_OUT)

		PORT MAP(
			Clk	=> Clk,
			Inc	=> R_inc,
			Clr	=> R_clr,
			Z 	=> R_z,
			Count	=> Count_r
			);
	Cnt_rs:	Counter
		GENERIC MAP(Ceil_value => ROW_STEP)
		
		PORT MAP(
			Clk	=> Clk,
			Inc	=> Rs_inc,
			Clr	=> Rs_clr,
			Z	=> Rs_z,
			Count 	=> Count_rs
			);
	Cnt_c:	Counter
		GENERIC MAP (Ceil_value => COL_OUT)

		PORT MAP(
			Clk	=> Clk,
			Inc	=> C_inc,
			Clr	=> C_clr,
			Z	=> C_z,
			Count	=> Count_c
			);
	Cnt_cs:	Counter
		GENERIC MAP (Ceil_value => COL_STEP)
		
		PORT MAP (
			Clk	=> Clk,
			Inc	=> Cs_inc,
			Clr	=> Cs_clr,
			Z	=> Cs_z,
			Count	=> Count_cs
			);
	-- Address
	
	Data_in_addr	<= (Count_r * ROW_STEP + Count_rs) * ROW_IN + Count_c * COL_STEP + Count_cs;
	Data_out_addr	<= Count_r * ROW_OUT + Count_c;
	Gt <= '1' WHEN Data_in > Data_out ELSE '0';
	
END Datapath_architecture;

