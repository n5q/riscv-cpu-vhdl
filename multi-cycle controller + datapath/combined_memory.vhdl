
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY combined_mem IS
    PORT (
        clock      : IN STD_LOGIC;
        write_en   : IN STD_LOGIC;
        address    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF combined_mem IS

    -- Byte-addressable RAM
    TYPE memory_data IS ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL RAM : memory_data := (
        -- Program (little-endian)
        
        -- PART 2 TESTBENCH
--        -- 0x0044a303   lw x6, 4(x9)
--        0 => x"03", 1 => x"A3", 2 => x"44", 3 => x"00",
--        -- 0x0064aa23   sw x6, 20(x9)
--        4 => x"23", 5 => x"AA", 6 => x"64", 7 => x"00",
--        -- 0x00802103   lw x2, 8(x0)
--        8 => x"03", 9 => x"21", 10 => x"80", 11 => x"00",
--        -- 0x00802183   lw x3, 8(x0)
--        12 => x"83", 13 => x"21", 14 => x"80", 15 => x"00",
--        -- 0x00210433   add x8, x2, x2
--        16 => x"33", 17 => x"04", 18 => x"21", 19 => x"00",
--        -- 0x00310463   beq x2, x3, 8
--        20 => x"63", 21 => x"04", 22 => x"31", 23 => x"00",
--        -- 0x01008093   addi x1, x1, 16
--        24 => x"93", 25 => x"80", 26 => x"00", 27 => x"01",
--        -- 0x00220213   addi x4, x4, 2
--        28 => x"13", 29 => x"02", 30 => x"22", 31 => x"00",
--        -- 0x004092b3   sll x5, x1, x4
--        32 => x"B3", 33 => x"92", 34 => x"40", 35 => x"00",
--        -- 0x00500293   addi x5, x0, 5
--        36 => x"93", 37 => x"02", 38 => x"50", 39 => x"00",
--        -- 0x00528533   add x10, x5, x5
--        40 => x"33", 41 => x"85", 42 => x"52", 43 => x"00",
--        -- 0x005295b3   sll x11, x5, x5
--        44 => x"B3", 45 => x"95", 46 => x"52", 47 => x"00",
--        -- 0x00a2c463   blt x5, x10, 8
--        48 => x"63", 49 => x"C4", 50 => x"A2", 51 => x"00",
--        -- 0x00000013   addi x0, x0, 0
--        52 => x"13", 53 => x"00", 54 => x"00", 55 => x"00",
--        -- 0xfe528ce3   beq x5, x5, -8
--        56 => x"E3", 57 => x"8C", 58 => x"52", 59 => x"FE",
        
        
        
        -- 0x00500313   ADDI x6, x0, 5      # val 1
        0 => x"13", 1 => x"03", 2 => x"50", 3 => x"00",
        -- 0x00602023   SW   x6, 0(x0)      #
        4 => x"23", 5 => x"20", 6 => x"60", 7 => x"00",
        -- 0x00c00313   ADDI x6, x0, 12     # val 2
        8 => x"13", 9 => x"03", 10 => x"C0", 11 => x"00",
        -- 0x00602223   SW   x6, 4(x0)      #
        12 => x"23", 13 => x"22", 14 => x"60", 15 => x"00",
        -- 0x00300313   ADDI x6, x0, 3      # val 3
        16 => x"13", 17 => x"03", 18 => x"30", 19 => x"00",
        -- 0x00602423   SW   x6, 8(x0)      #
        20 => x"23", 21 => x"24", 22 => x"60", 23 => x"00",
        -- 0x03700313   ADDI x6, x0, 55     # val 4 (MAX)
        24 => x"13", 25 => x"03", 26 => x"70", 27 => x"03",
        -- 0x00602623   SW   x6, 12(x0)     #
        28 => x"23", 29 => x"26", 30 => x"60", 31 => x"00",
        -- 0x00800313   ADDI x6, x0, 8      # val 5
        32 => x"13", 33 => x"03", 34 => x"80", 35 => x"00",
        -- 0x00602823   SW   x6, 16(x0)     #
        36 => x"23", 37 => x"28", 38 => x"60", 39 => x"00",
        -- 0x00100313   ADDI x6, x0, 1      # val 6
        40 => x"13", 41 => x"03", 42 => x"10", 43 => x"00",
        -- 0x00602a23   SW   x6, 20(x0)     #
        44 => x"23", 45 => x"2A", 46 => x"60", 47 => x"00",
        -- 0x01400313   ADDI x6, x0, 20     # val 7
        48 => x"13", 49 => x"03", 50 => x"40", 51 => x"01",
        -- 0x00602c23   SW   x6, 24(x0)     #
        52 => x"23", 53 => x"2C", 54 => x"60", 55 => x"00",
        -- 0x00000313   ADDI x6, x0, 0      # val 8
        56 => x"13", 57 => x"03", 58 => x"00", 59 => x"00",
        -- 0x00602e23   SW   x6, 28(x0)     #
        60 => x"23", 61 => x"2E", 62 => x"60", 63 => x"00",
        -- 0x02a00313   ADDI x6, x0, 42     # val 9
        64 => x"13", 65 => x"03", 66 => x"A0", 67 => x"02",
        -- 0x02602023   SW   x6, 32(x0)     #
        68 => x"23", 69 => x"20", 70 => x"60", 71 => x"02",
        -- 0x00b00313   ADDI x6, x0, 11     # val 10
        72 => x"13", 73 => x"03", 74 => x"B0", 75 => x"00",
        -- 0x02602223   SW   x6, 36(x0)     #
        76 => x"23", 77 => x"22", 78 => x"60", 79 => x"02",
        -- 0x00000093   ADDI x1, x0, 0      # x1 = pointer
        80 => x"93", 81 => x"00", 82 => x"00", 83 => x"00",
        -- 0x00a00113   ADDI x2, x0, 10     # x2 = loop counter (10 items)
        84 => x"13", 85 => x"01", 86 => x"A0", 87 => x"00",
        -- 0x00000193   ADDI x3, x0, 0      # x3 = max value
        88 => x"93", 89 => x"01", 90 => x"00", 91 => x"00",
        -- 0x00010e63   BEQ  x2, x0, 28     # if x2==0, branch forward
        92 => x"63", 93 => x"0E", 94 => x"01", 95 => x"00",
        -- 0x0000b203   LD   x4, 0(x1)      # load mem[x1] into x4
        96 => x"03", 97 => x"B2", 98 => x"00", 99 => x"00",
        -- 0x00324463   BLT  x4, x3, 8      # If x4 < max (x3), dont update x3
        100 => x"63", 101 => x"44", 102 => x"32", 103 => x"00",
        -- 0x004001b3   ADD  x3, x0, x4     # max = value
        104 => x"B3", 105 => x"01", 106 => x"40", 107 => x"00",
        -- 0x00408093   ADDI x1, x1, 4      # point to next
        108 => x"93", 109 => x"80", 110 => x"40", 111 => x"00",
        -- 0xfff10113   ADDI x2, x2, -1     # counter--
        112 => x"13", 113 => x"01", 114 => x"F1", 115 => x"FF",
        -- 0xfe0004e3   BEQ  x0, x0, -24    # back 24
        116 => x"E3", 117 => x"04", 118 => x"00", 119 => x"FE",
        -- 0x7E7E7E7E   HALT
        120 => x"7E", 121 => x"7E", 122 => x"7E", 123 => x"7E",
        OTHERS => (OTHERS => '0')
    );

    SIGNAL addr_int : INTEGER := 0;

BEGIN
    addr_int <= to_integer(unsigned(address(9 DOWNTO 0))); -- Address conversion fits 1 KB

    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) AND write_en = '1' THEN
            RAM(addr_int)     <= write_data(7 DOWNTO 0);
            RAM(addr_int + 1) <= write_data(15 DOWNTO 8);
            RAM(addr_int + 2) <= write_data(23 DOWNTO 16);
            RAM(addr_int + 3) <= write_data(31 DOWNTO 24);
        END IF;
    END PROCESS;

    -- read 4 consecutive bytes form one 32-bit word
    data <= RAM(addr_int + 3) &
        RAM(addr_int + 2) &
        RAM(addr_int + 1) &
        RAM(addr_int);

END ARCHITECTURE rtl;
