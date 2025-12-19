------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : program_counter.vhdl
-- Authors     : Antonio Alejandro Andara Lara
-- Date        : 23-Oct-2025
------------------------------------------------------------------------
-- Description  : 32-bit program counter register. Updates PC on each rising clock edge.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY program_counter IS
    PORT (
        clock   : IN STD_LOGIC;
        pc_next : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pc_out      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF program_counter IS
    SIGNAL pc_reg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    pc_out <= pc_reg;

    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) THEN
            pc_reg <= pc_next;
        END IF;
    END PROCESS;

END behavioral;
