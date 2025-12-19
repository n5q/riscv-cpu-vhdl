------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : single_cycle_riscv.vhdl
-- Authors     : Antonio Alejandro Andara Lara
-- Date        : 23-Oct-2025
------------------------------------------------------------------------
-- Description  : Top-level RISC-V CPU combining single-cycle datapath and control logic.
--                Executes basic load, store, and arithmetic instructions.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY single_cycle_riscv IS
    PORT (
        clock    : IN  STD_LOGIC;
        out_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Structural OF single_cycle_riscv IS

    SIGNAL pc_sel      : STD_LOGIC;
    SIGNAL zero_flag   : STD_LOGIC := '0';
    SIGNAL data_write  : STD_LOGIC;
    SIGNAL reg_write   : STD_LOGIC;
    SIGNAL funct7      : STD_LOGIC;
    SIGNAL alu_sel     : STD_LOGIC;
    SIGNAL result_src  : STD_LOGIC;
    SIGNAL output_en   : STD_LOGIC;

    SIGNAL funct3      : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL imm_sel     : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL alu_ctrl    : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL opcode      : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    --------------------------------------------------------------------
    -- DATAPATH
    --------------------------------------------------------------------
    datapath : ENTITY work.lw_sw_datapath(structural)
        PORT MAP(
            clock       => clock,
            pc_sel      => pc_sel,
            mem_write   => data_write,
            reg_write   => reg_write,
            alu_sel     => alu_sel,
            result_src  => result_src,
            output_en   => output_en,
            imm_sel     => imm_sel,
            alu_ctrl    => alu_ctrl,
            opcode      => opcode,
            funct3      => funct3,
            funct7      => funct7,
            zero_flag   => zero_flag,
            out_data    => out_data
        );

    --------------------------------------------------------------------
    -- CONTROLLER
    --------------------------------------------------------------------
    control_unit : ENTITY work.controller(behavioral)
        PORT MAP(
            opcode     => opcode,
            funct3     => funct3,
            funct7     => funct7,
            zero_flag  => zero_flag,
            pc_sel     => pc_sel,
            alu_sel    => alu_sel,
            result_src => result_src,
            mem_write  => data_write,
            reg_write  => reg_write,
            output_en  => output_en,
            imm_sel    => imm_sel,
            alu_ctrl   => alu_ctrl
        );

END Structural;
