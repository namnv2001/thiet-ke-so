
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Controller IS
	GENERIC(
		DATA_WIDTH:	INTEGER
		);

	PORT	(
		Start:	IN STD_LOGIC;
		Clk:		IN STD_LOGIC;
		Reset:	IN STD_LOGIC;
		R_z, Rs_z, C_z, Cs_z, Gt:			IN STD_LOGIC;
		R_clr, Rs_Clr, C_clr, Cs_clr:	OUT STD_LOGIC;
		R_inc, Rs_inc, C_inc, Cs_inc:	OUT STD_LOGIC;
		Re_in, Re_out, We_in, We_out:	OUT STD_LOGIC;
		Done:		OUT STD_LOGIC
		);
END Controller;

ARCHITECTURE Controller_architecture OF Controller IS

	TYPE STATE_TYPE IS (
		RESET_S, START_S, CLEAR_R, COMP_R, 
		CLEAR_RS, COMP_RS, CLEAR_C, COMP_C, 
		CLEAR_CS, COMP_CS, READ_IO, COMP_IO, 
		WRITE_IO, COUNT_CS, COUNT_C, COUNT_RS, 
		COUNT_R, DONE_S, END_S
		);
	
	SIGNAL Current_state: STATE_TYPE;
	BEGIN 
		PROCESS(Clk, Current_state, Reset)
		BEGIN
			IF Reset = '1' THEN
				Current_state <= RESET_S;
			ELSIF Clk'Event AND Clk = '1' THEN
				CASE Current_state IS
					WHEN RESET_S => 
						Current_state <= START_S;

					WHEN START_S => 
						IF Start = '1' THEN Current_state <= CLEAR_R;
						END IF;

					WHEN CLEAR_R => 
						Current_state <= COMP_R;

					WHEN COMP_R => 
						IF R_z = '0' THEN Current_state <= CLEAR_RS;
						ELSE Current_state <= DONE_S;
						END IF;

					WHEN CLEAR_RS => 
						Current_state <= COMP_RS;

					WHEN COMP_RS => 
						IF Rs_z = '0' THEN Current_state <= CLEAR_C;
						ELSE Current_state <= COUNT_R;
						END IF;

					WHEN CLEAR_C => 
						Current_state <= COMP_C;

					WHEN COMP_C =>
						IF C_z = '0' THEN Current_state <= CLEAR_CS;
						ELSE Current_state <= COUNT_RS;
						END IF;

					WHEN CLEAR_CS => 
						Current_state <= COMP_CS;

					WHEN COMP_CS => 
						IF Cs_z = '0' THEN Current_state <= READ_IO;
						ELSE Current_state <= COUNT_C;
						END IF;

					WHEN READ_IO => 
						Current_state <= COMP_IO;

					WHEN COMP_IO =>
						IF Gt = '1' THEN Current_state <= WRITE_IO;
						ELSE Current_state <= COUNT_CS;
						END IF;
					
					WHEN WRITE_IO =>
						Current_state <= COUNT_CS;

					WHEN COUNT_CS => 
						Current_state <= COMP_CS;

					WHEN COUNT_C => 
						Current_state <= COMP_C;

					WHEN COUNT_Rs => 
						Current_state <= COMP_RS;

					WHEN COUNT_R => 
						Current_state <= COMP_R;
						
					WHEN DONE_S =>
						Current_state <= END_S;

					WHEN END_S =>
						IF Start = '0' THEN Current_state <= RESET_S;
						END IF;
				END CASE;
			END IF;
		END PROCESS;

	-- Increase Count
	WITH Current_state SELECT R_inc <= '1' WHEN COUNT_R, '0' WHEN OTHERS;
	WITH Current_state SELECT Rs_inc <= '1' WHEN COUNT_RS, '0' WHEN OTHERS;
	WITH Current_state SELECT C_inc <= '1' WHEN COUNT_C, '0' WHEN OTHERS;
	WITH Current_state SELECT Cs_inc <= '1' WHEN COUNT_CS, '0' WHEN OTHERS;

	-- Clear Count
	WITH Current_state SELECT R_clr <= '1' WHEN CLEAR_R | RESET_S, '0' WHEN OTHERS;
	WITH Current_state SELECT Rs_clr <= '1' WHEN CLEAR_RS | RESET_S, '0' WHEN OTHERS;
	WITH Current_state SELECT C_clr <= '1' WHEN CLEAR_C | RESET_S, '0' WHEN OTHERS;
	WITH Current_state SELECT Cs_clr <= '1' WHEN CLEAR_CS | RESET_S, '0' WHEN OTHERS;
	
	-- Read Memory 
	WITH Current_state SELECT Re_in <= '1' WHEN READ_IO | WRITE_IO, '0' WHEN OTHERS;
	WITH Current_state SELECT Re_out <= '1' WHEN READ_IO, '0' WHEN OTHERS;
	WITH Current_state SELECT We_out <= '1' WHEN WRITE_IO, '0' WHEN OTHERS;

	-- Done
	Done <= '1' WHEN (Current_state = DONE_S) ELSE '0';
END Controller_architecture;
