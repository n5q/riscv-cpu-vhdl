------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : extend.vhdl
-- Authors     : Omar Mahmoud, Nasif Qadri
-- Date        : 13-Nov-2025
------------------------------------------------------------------------
-- Description : Bit extender
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY extend IS
  PORT (
    din  : IN  STD_LOGIC_VECTOR(24 DOWNTO 0);  -- usually instr(31 downto 7)
    ctrl : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
    dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END extend;

ARCHITECTURE Behavioral OF extend IS
  CONSTANT I_TYPE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
  CONSTANT U_TYPE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
  CONSTANT S_TYPE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
  CONSTANT B_TYPE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
  CONSTANT J_TYPE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "110";
BEGIN
  PROCESS(din, ctrl) IS
  BEGIN
    CASE ctrl IS
      WHEN I_TYPE =>
        dout <= (31 DOWNTO 12 => din(24))
                & din(24 DOWNTO 13);

      WHEN U_TYPE =>
        dout <= din(24 DOWNTO 5)
                & (11 DOWNTO 0 => '0');

      WHEN S_TYPE =>
        dout <= (31 DOWNTO 12 => din(24))
                & din(24 DOWNTO 18)
                & din(4 DOWNTO 0);

      WHEN B_TYPE =>
        dout <= (31 DOWNTO 13 => din(24))
                & din(24)
                & din(0)
                & din(23 DOWNTO 18)
                & din(4 DOWNTO 1)
                & '0';

      WHEN J_TYPE =>
        dout <= (31 DOWNTO 21 => din(24))
                & din(24)
                & din(12 DOWNTO 5)
                & din(13)
                & din(23 DOWNTO 14)
                & '0';

      WHEN OTHERS =>
        dout <= (31 DOWNTO 0 => '0');
    END CASE;
  END PROCESS;
END Behavioral;
