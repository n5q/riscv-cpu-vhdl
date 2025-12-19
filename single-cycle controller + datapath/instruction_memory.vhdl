------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : instruction_memory.vhdl
-- Authors     : Antonio Alejandro Andara Lara
-- Date        : 23-Oct-2025
------------------------------------------------------------------------
-- Description  : 1 KB instruction memory (ROM) storing a simple RISC-V program.
--                Provides 32-bit instruction fetch based on byte address.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY instr_mem IS
    PORT (
        address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF instr_mem IS

    -- Byte-addressable ROM
    TYPE memory_data IS ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT ROM : memory_data := (
        -- Program (little-endian)
  -- 0x0044a303   lw x6, 4(x9)
        0 => x"03", 1 => x"A3", 2 => x"44", 3 => x"00",
        -- 0x0064aa23   sw x6, 20(x9)
        4 => x"23", 5 => x"AA", 6 => x"64", 7 => x"00",
        -- 0x00802103   lw x2, 8(x0)
        8 => x"03", 9 => x"21", 10 => x"80", 11 => x"00",
        -- 0x00802183   lw x3, 8(x0)
        12 => x"83", 13 => x"21", 14 => x"80", 15 => x"00",
        -- 0x00210433   add x8, x2, x2
        16 => x"33", 17 => x"04", 18 => x"21", 19 => x"00",
        -- 0x00310463   beq x2, x3, 8
        20 => x"63", 21 => x"04", 22 => x"31", 23 => x"00",
        OTHERS => (OTHERS => '0')
    );

    SIGNAL addr_int : INTEGER := 0;

BEGIN
    addr_int <= to_integer(unsigned(address(9 DOWNTO 0))); -- Address conversion fits 1 KB of ROM

    -- read 4 consecutive bytes form one 32-bit word
    data <= ROM(addr_int + 3) &
            ROM(addr_int + 2) &
            ROM(addr_int + 1) &
            ROM(addr_int);

END ARCHITECTURE rtl;
