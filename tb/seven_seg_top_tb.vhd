-------------------------------------------------------------------------------
-- Title      : 7-segment top testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_top_tb.vhd
-- Author     : onnihy@gmail.com
-- Company    : 
-- Created    : 2019-05-26
-- Last update: 2019-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Testbench that generates clk and reset for 7-seg top level
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-05-26  1.0      onnex   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity seven_seg_top_tb is

end entity seven_seg_top_tb;


architecture testbench of seven_seg_top_tb is


  constant num_of_displays_c : positive              := 8;
  constant max_value_c       : integer range 0 to 15 := 9;


  type output_arr_t is array (0 to num_of_displays_c-1)
    of std_logic_vector(7-1 downto 0);

  signal clk        : std_logic := '0';
  signal rst_n      : std_logic := '0';
  signal output     : std_logic_vector(num_of_displays_c*7-1 downto 0);
  signal output_arr : output_arr_t;

  component seven_seg_top is
    generic (
      num_of_displays_g : positive;
      max_value_g       : integer range 0 to 15);
    port (
      clk        : in  std_logic;
      rst_n      : in  std_logic;
      values_out : out std_logic_vector(num_of_displays_g*7-1 downto 0)
      );
  end component seven_seg_top;

begin  -- architecture testbench

  clk   <= not(clk) after 10 ns;
  rst_n <= '1'      after 45 ns;

  i_seven_seg_top : seven_seg_top
    generic map (
      num_of_displays_g => num_of_displays_c,
      max_value_g       => max_value_c)
    port map (
      clk        => clk,
      rst_n      => rst_n,
      values_out => output
      );

  gen_arr : for display in 0 to num_of_displays_c-1 generate
    output_arr(display) <= output((display+1)*7-1 downto display*7);
  end generate gen_arr;

end architecture testbench;
