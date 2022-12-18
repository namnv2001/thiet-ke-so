
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY controller IS
	PORT	(
		start:	IN std_logic;
		clk:		IN std_logic;
		reset:	IN std_logic;
		r_z, rs_z, c_z, cs_z, greater_than:		IN std_logic;
		r_clear, rs_clear, c_clear, cs_clear:	OUT std_logic;
		r_increase, rs_increase, c_increase, cs_increase:	OUT std_logic;
		re_in, re_out, we_in, we_out:	OUT std_logic;
		done:		OUT std_logic
		);
END controller;

ARCHITECTURE controller_architecture OF controller IS

	TYPE STATE_TYPE IS (
		RESET_S, START_S, CLEAR_R, COMP_R, 
		CLEAR_RS, COMP_RS, CLEAR_C, COMP_C, 
		CLEAR_CS, COMP_CS, READ_IO, COMP_IO, 
		WRITE_IO, COUNT_CS, COUNT_C, COUNT_RS, 
		COUNT_R, DONE_S, END_S
		);
	
	SIGNAL state: STATE_TYPE;
	BEGIN 
		PROCESS(clk, state, reset)
		BEGIN
			IF reset = '1' THEN
				state <= RESET_S;
			ELSIF clk'Event AND clk = '1' THEN
				CASE state IS
					WHEN RESET_S => 
						state <= START_S;

					WHEN START_S => 
						IF start = '1' THEN state <= CLEAR_R;
						END IF;

					WHEN CLEAR_R => 
						state <= COMP_R;

					WHEN COMP_R => 
						IF r_z = '0' THEN state <= CLEAR_RS;
						ELSE state <= DONE_S;
						END IF;

					WHEN CLEAR_RS => 
						state <= COMP_RS;

					WHEN COMP_RS => 
						IF rs_z = '0' THEN state <= CLEAR_C;
						ELSE state <= COUNT_R;
						END IF;

					WHEN CLEAR_C => 
						state <= COMP_C;

					WHEN COMP_C =>
						IF c_z = '0' THEN state <= CLEAR_CS;
						ELSE state <= COUNT_RS;
						END IF;

					WHEN CLEAR_CS => 
						state <= COMP_CS;

					WHEN COMP_CS => 
						IF cs_z = '0' THEN state <= READ_IO;
						ELSE state <= COUNT_C;
						END IF;

					WHEN READ_IO => 
						state <= COMP_IO;

					WHEN COMP_IO =>
						IF greater_than = '1' THEN state <= WRITE_IO;
						ELSE state <= COUNT_CS;
						END IF;
					
					WHEN WRITE_IO =>
						state <= COUNT_CS;

					WHEN COUNT_CS => 
						state <= COMP_CS;

					WHEN COUNT_C => 
						state <= COMP_C;

					WHEN COUNT_Rs => 
						state <= COMP_RS;

					WHEN COUNT_R => 
						state <= COMP_R;
						
					WHEN DONE_S =>
						state <= END_S;

					WHEN END_S =>
						IF start = '0' THEN state <= RESET_S;
						END IF;
				END CASE;
			END IF;
		END PROCESS;

	-- Increase count
	WITH state SELECT r_increase <= '1' WHEN COUNT_R, '0' WHEN OTHERS;
	WITH state SELECT rs_increase <= '1' WHEN COUNT_RS, '0' WHEN OTHERS;
	WITH state SELECT c_increase <= '1' WHEN COUNT_C, '0' WHEN OTHERS;
	WITH state SELECT cs_increase <= '1' WHEN COUNT_CS, '0' WHEN OTHERS;

	-- Clear count
	WITH state SELECT r_clear <= '1' WHEN CLEAR_R | RESET_S, '0' WHEN OTHERS;
	WITH state SELECT rs_clear <= '1' WHEN CLEAR_RS | RESET_S, '0' WHEN OTHERS;
	WITH state SELECT c_clear <= '1' WHEN CLEAR_C | RESET_S, '0' WHEN OTHERS;
	WITH state SELECT cs_clear <= '1' WHEN CLEAR_CS | RESET_S, '0' WHEN OTHERS;
	
	-- Read Memory 
	WITH state SELECT re_in <= '1' WHEN READ_IO | WRITE_IO, '0' WHEN OTHERS;
	WITH state SELECT re_out <= '1' WHEN READ_IO, '0' WHEN OTHERS;
	WITH state SELECT we_out <= '1' WHEN WRITE_IO, '0' WHEN OTHERS;

	-- done
	done <= '1' WHEN (state = DONE_S) ELSE '0';
END controller_architecture;
