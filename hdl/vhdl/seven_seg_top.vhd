-------------------------------------------------------------------------------
-- Title      : 7-segment controller top level
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_top.vhd
-- Author     : onnihy@gmail.com
-- Company    : 
-- Created    : 2019-05-26
-- Last update: 2019-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Top level block for testing the 7-segement controller on fpga
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-05-26  1.0      onnex   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity seven_seg_top is

  generic (
    num_of_displays_g : positive              := 8;
    max_value_g       : integer range 0 to 15 := 9);

  port (
    clk        : in  std_logic;
    rst_n      : in  std_logic;
    values_out : out std_logic_vector(num_of_displays_g*7-1 downto 0)
    );

end entity seven_seg_top;


architecture structural of seven_seg_top is

  component seven_seg_input_gen is
    generic (
      max_value_g    : integer range 0 to 15;
      delay_cycles_g : integer);
    port (
      clk       : in  std_logic;
      rst_n     : in  std_logic;
      value_out : out std_logic_vector(4-1 downto 0));
  end component seven_seg_input_gen;

  component seven_seg_ctrl is
    generic (
      num_of_displays_g : positive);
    port (
      clk               : in  std_logic;
      rst_n             : in  std_logic;
      values_in         : in  std_logic_vector(num_of_displays_g*4-1 downto 0);
      display_active_in : in  std_logic_vector(num_of_displays_g-1 downto 0);
      values_out        : out std_logic_vector(num_of_displays_g*7-1 downto 0));
  end component seven_seg_ctrl;

  signal input_to_ctrl     : std_logic_vector(4-1 downto 0);
  signal input_to_ctrl_arr : std_logic_vector(num_of_displays_g*4-1 downto 0);

  signal values : std_logic_vector(num_of_displays_g*7-1 downto 0);

begin  -- architecture structural

  i_seven_seg_input_gen : seven_seg_input_gen
    generic map (
      max_value_g    => max_value_g,
      delay_cycles_g => 50_000_000)
    port map (
      clk       => clk,
      rst_n     => rst_n,
      value_out => input_to_ctrl
      );

  g_input_ctrl : for display in 0 to num_of_displays_g-1 generate
    input_to_ctrl_arr((display+1)*4-1 downto display*4)
      <= input_to_ctrl;
  end generate g_input_ctrl;

  i_seven_seg_ctrl : seven_seg_ctrl
    generic map (
      num_of_displays_g => num_of_displays_g)
    port map (
      clk               => clk,
      rst_n             => rst_n,
      values_in         => input_to_ctrl_arr,
      display_active_in => (others => '1'),
      values_out        => values
      );

  values_out <= values;

end architecture structural;
