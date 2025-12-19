------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : data_memory.vhdl
-- Authors     : Antonio Alejandro Andara Lara
-- Date        : 23-Oct-2025
------------------------------------------------------------------------
-- Description  : 1 KB data memory with 32-bit read/write interface.
--                Supports synchronous writes and asynchronous reads.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY data_mem IS
    PORT (
        address    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_en   : IN STD_LOGIC;
        clock      : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF data_mem IS

    TYPE memory_data IS ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RAM : memory_data := (
        4 => x"DEADBEEF",
        8 => x"CAFEBABE",
        OTHERS => (OTHERS => '0')
    );

BEGIN

    PROCESS (clock) IS
    BEGIN
        IF rising_edge(clock) AND write_en = '1' THEN
            RAM(to_integer(unsigned(address))) <= write_data;
        END IF;
    END PROCESS;

    data <= RAM(to_integer(unsigned(address)));

END behavioral;

ARCHITECTURE rtl OF data_mem IS

    TYPE memory_data IS ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL RAM : memory_data := (
        -- Test values (little-endian)
        -- Address 4: 0x66BEDEAD
        4 => x"AD", 5 => x"DE", 6 => x"BE", 7 => x"66",
        -- Address 8: 0x88888888
        8 => x"88", 9 => x"88", 10 => x"88", 11 => x"88",
        -- Address 12: 0x12DABEEF
        12 => x"EF", 13 => x"BE", 14 => x"DA", 15 => x"12",
        OTHERS => (OTHERS => '0')
    );

    SIGNAL addr_int : INTEGER := 0;

BEGIN

    -- Convert 32-bit address to integer
    addr_int <= to_integer(unsigned(address(9 DOWNTO 0))); -- 1 KB = 10-bit addressing

    -- Synchronous write
    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) THEN
            -- Implement byte-wise write operation
            RAM(addr_int + 3) <= write_data(31 downto 24);
            RAM(addr_int + 2) <= write_data(23 downto 16);
            RAM(addr_int + 1) <= write_data(15 downto 8);
            RAM(addr_int)     <= write_data(7 downto 0);
        END IF;
    END PROCESS;

    -- Combinational read
    -- Reconstruct 32-bit word from four bytes in little-endian order
    data <= RAM(addr_int + 3) & RAM(addr_int + 2) & RAM(addr_int + 1) & RAM(addr_int);

END ARCHITECTURE rtl;
