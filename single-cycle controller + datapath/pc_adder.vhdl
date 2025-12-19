------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : pc_adder.vhdl
-- Authors     : Antonio Alejandro Andara Lara
-- Date        : 23-Oct-2025
------------------------------------------------------------------------
-- Description  : Adds a configurable value to the program counter (default 4).
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pc_adder IS
    GENERIC (
        INCREMENT : unsigned(31 DOWNTO 0) := to_unsigned(4, 32)
    );
    PORT (
        pc_current : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pc_next    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF pc_adder IS
BEGIN
    u_pc_adder : ENTITY WORK.adder_32(Behavioral)
        PORT MAP(
            op_a => pc_current,
            op_b => STD_LOGIC_VECTOR(INCREMENT),
            sum  => pc_next
        );
END structural;
