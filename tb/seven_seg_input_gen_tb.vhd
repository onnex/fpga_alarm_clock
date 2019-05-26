-------------------------------------------------------------------------------
-- Title      : 7-segment input generator testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_input_gen_tb.vhd
-- Author     : onnihy@gmail.com
-- Company    : 
-- Created    : 2019-05-26
-- Last update: 2019-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Creates clock and reset and checks the output of input generator
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-05-26  1.0      onnex   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity seven_seg_input_gen_tb is

end entity seven_seg_input_gen_tb;


architecture testbench of seven_seg_input_gen_tb is

  constant clk_period_c : time := 20 ns;
  constant reset_down_c : time := 45 ns;

  constant max_value_c : integer range 0 to 15 := 9;
  constant delay_c     : integer               := 50_000;

  signal clk   : std_logic := '0';
  signal rst_n : std_logic := '0';

  signal output : std_logic_vector(4-1 downto 0);

  component seven_seg_input_gen is
    generic (
      max_value_g    : integer range 0 to 15;
      delay_cycles_g : integer);
    port (
      clk       : in  std_logic;
      rst_n     : in  std_logic;
      value_out : out std_logic_vector(4-1 downto 0));
  end component seven_seg_input_gen;

begin  -- architecture testbench

  clk   <= not(clk) after clk_period_c/2;
  rst_n <= '1'      after reset_down_c;

  i_seven_seg_input_gen : seven_seg_input_gen
    generic map (
      max_value_g    => max_value_c,
      delay_cycles_g => delay_c)
    port map (
      clk       => clk,
      rst_n     => rst_n,
      value_out => output
      );


  assert (unsigned(output) <= max_value_c)
    report "output value too big"
    severity error;

  assert unsigned(output) /= max_value_c
    report "Simulation ended"
    severity failure;

end architecture testbench;
