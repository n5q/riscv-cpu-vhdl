------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : single_cycle_controller.vhdl
-- Authors     : Antonio Alejandro Andara Lara
-- Date        : 23-Oct-2025
------------------------------------------------------------------------
-- Description  : Single-cycle control unit for a simple RISC-V processor.
--                Decodes opcode, funct3, and funct7 fields to generate
--                ALU, memory, and register control signals.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY controller IS
    PORT (
        opcode     : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        funct3     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        funct7     : IN STD_LOGIC;
        zero_flag  : IN STD_LOGIC;
        pc_sel     : OUT STD_LOGIC;
        alu_sel    : OUT STD_LOGIC;
        result_src : OUT STD_LOGIC;
        mem_write  : OUT STD_LOGIC;
        reg_write  : OUT STD_LOGIC;
        output_en  : OUT STD_LOGIC;
        imm_sel    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        alu_ctrl   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END controller;

ARCHITECTURE Behavioral OF controller IS
    SIGNAL controls      : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL branch_cond   : STD_LOGIC := '0';
    SIGNAL branch_enable : STD_LOGIC := '0';

    TYPE instruction IS (LW, SW, ADD, NOP, B);
    SIGNAL instr : instruction := NOP;
    SIGNAL aux   : STD_LOGIC_VECTOR(10 DOWNTO 0);

    -- Instruction opcodes
    CONSTANT OPCODE_LW  : STD_LOGIC_VECTOR(6 DOWNTO 0)  := "0000011";
    CONSTANT OPCODE_SW  : STD_LOGIC_VECTOR(6 DOWNTO 0)  := "0100011";
    CONSTANT OPCODE_ADD : STD_LOGIC_VECTOR(6 DOWNTO 0)  := "0110011";
    CONSTANT OPCODE_B   : STD_LOGIC_VECTOR(6 DOWNTO 0)  := "1100011";

    -- Control signals per instruction
    -- [9]   alu_sel
    -- [8]   result_src
    -- [7]   reg_write
    -- [6]   mem_write
    -- [5:3] imm_sel
    -- [2:0] alu_ctrl
    CONSTANT CTRL_LW  : STD_LOGIC_VECTOR(9 DOWNTO 0) := "1110010100";
    CONSTANT CTRL_SW  : STD_LOGIC_VECTOR(9 DOWNTO 0) := "1101011100";
    CONSTANT CTRL_ADD : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0010011100";
    CONSTANT CTRL_NOP : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000";

    -- Branch control word (example: B-type imm, SUB compare)
    -- *** adjust alu_ctrl bits [2:0] to match your ALU's SUB code ***
--    CONSTANT CTRL_B   : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0001010001";
    --  alu_sel=0, result_src=0, no reg/mem write, imm_sel="101", alu_ctrl="101"

    -- alu_sel=0, result_src=0, reg_write=0, mem_write=0, imm_sel="101", alu_ctrl="101"
    CONSTANT CTRL_B   : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000101101";

BEGIN

    aux <= funct7 & funct3 & opcode;

    decode : PROCESS (opcode, funct3, funct7, zero_flag)
    BEGIN
        -- defaults
        controls      <= CTRL_NOP;
        instr         <= NOP;
        branch_enable <= '0';
        branch_cond   <= '0';
        output_en     <= '1';   -- show ALU/mem result by default

        CASE opcode IS
            WHEN OPCODE_LW =>
                instr    <= LW;
                controls <= CTRL_LW;

            WHEN OPCODE_SW =>
                instr    <= SW;
                controls <= CTRL_SW;

            WHEN OPCODE_ADD =>
                IF funct3 = "000" AND funct7 = '0' THEN
                    instr    <= ADD;
                    controls <= CTRL_ADD;
                END IF;

            ----------------------------------------------------------------
            -- Branch Instructions
            ----------------------------------------------------------------
            WHEN OPCODE_B =>
                instr         <= B;
                controls      <= CTRL_B;   -- B-type immediate + compare op
                output_en     <= '1';
                branch_enable <= '1';

                CASE funct3 IS
                    WHEN "000" => -- BEQ
                        branch_cond <= '1';
                    WHEN "001" => -- BNE
                        branch_cond <= NOT zero_flag;
                    WHEN OTHERS =>
                        branch_cond <= '0';
                END CASE;

            WHEN OTHERS =>
                instr    <= NOP;
                controls <= CTRL_NOP;
        END CASE;
    END PROCESS;

    -- Controller output assignments
    alu_sel    <= controls(9);
    result_src <= controls(8);
    reg_write  <= controls(7);
    mem_write  <= controls(6);
    imm_sel    <= controls(5 DOWNTO 3);
    alu_ctrl   <= controls(2 DOWNTO 0);

    pc_sel     <= branch_enable AND branch_cond;

END Behavioral;
