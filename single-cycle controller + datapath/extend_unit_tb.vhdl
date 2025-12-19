LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY extend_unit_tb IS
END ENTITY;

ARCHITECTURE tb OF extend_unit_tb IS

    SIGNAL instr        : STD_LOGIC_VECTOR(31 DOWNTO 7) := (OTHERS => '0');
    SIGNAL imm_sel      : STD_LOGIC_VECTOR(2 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL imm_ext      : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL expect       : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    -- Convert std_logic_vector to hex string
    FUNCTION to_hex(slv : STD_LOGIC_VECTOR) RETURN STRING IS
        CONSTANT hex_chars  : STRING := "0123456789ABCDEF";
        VARIABLE result     : STRING(1 TO (slv'length + 3)/4);
        VARIABLE nibble     : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE i          : INTEGER := slv'length - 1;
        VARIABLE idx        : INTEGER := 1;
        VARIABLE value      : INTEGER;
    BEGIN
        WHILE i >= 0 LOOP
            nibble := (OTHERS => '0');
            FOR j IN 0 TO 3 LOOP
                IF (i - j) >= 0 THEN
                    nibble(3 - j) := slv(i - j);
                END IF;
            END LOOP;
            value       := to_integer(unsigned(nibble));
            result(idx) := hex_chars(value + 1);
            idx         := idx + 1;
            i           := i - 4;
        END LOOP;
        RETURN result;
    END FUNCTION;

    -- Test vector type
    TYPE test_vector IS RECORD
        name   : STRING(1 TO 6);
        ctrl   : STD_LOGIC_VECTOR(2 DOWNTO 0);
        instr  : STD_LOGIC_VECTOR(31 DOWNTO 7);
        expect : STD_LOGIC_VECTOR(31 DOWNTO 0);
    END RECORD;

    TYPE test_array IS ARRAY(NATURAL RANGE <>) OF test_vector;

    CONSTANT tests : test_array := (
        ("I-type", "010", "1010101010101111111111111", "11111111111111111111101010101010"),
        ("U-type", "011", "1001100110011001100111111", "10011001100110011001000000000000"),
        ("S-type", "100", "1111010000000000000011111", "11111111111111111111111101011111"),
        ("B-type", "101", "1111111000000000000011110", "11111111111111111111011111111110"),
        ("J-type", "110", "1011111111110110101010000", "11111111111101101010101111111110")
    );

    PROCEDURE run_test(
        CONSTANT t     : test_vector;
        SIGNAL imm_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL instr   : OUT STD_LOGIC_VECTOR(31 DOWNTO 7);
        SIGNAL expect  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL imm_ext : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    ) IS
    BEGIN
        imm_sel <= t.ctrl;
        instr   <= t.instr;
        WAIT FOR 1 ns;
        ASSERT imm_ext = t.expect
        REPORT t.name & " FAILED! Expected: " &
            to_hex(t.expect) & " Got: " & to_hex(imm_ext)
            SEVERITY error;
        REPORT t.name & " passed." SEVERITY note;
    END PROCEDURE;

BEGIN

    DUT : ENTITY work.extend
        PORT MAP(
            din  => instr,
            ctrl => imm_sel,
            dout => imm_ext
        );

    stimuli : PROCESS
    BEGIN
        FOR i IN tests'RANGE LOOP
            run_test(tests(i), imm_sel, instr, expect, imm_ext);
        END LOOP;

        REPORT "All tests completed." SEVERITY note;
        WAIT;
    END PROCESS;

END ARCHITECTURE;
