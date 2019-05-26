-------------------------------------------------------------------------------
-- Title      : 7-segment display controller testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_ctrl_tb.vhd
-- Author     : onnihy@gmail.com
-- Company    : 
-- Created    : 2019-05-23
-- Last update: 2019-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Testbench for generic 7-segment controller
--              - Gives same input parameters to a generic amount of
--              7-segment LUTs and checks that they match together.
--              - Doesn't check that output values match to correct
--              bit sequences
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-05-23  1.0      onnex   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_ctrl_tb is
end entity seven_seg_ctrl_tb;


architecture testbench of seven_seg_ctrl_tb is

  constant num_of_displays_c : positive              := 8;
  constant max_value_c       : integer range 0 to 15 := 9;

  constant clk_period_c : time := 20 ns;
  constant reset_down_c : time := 45 ns;

  type input_arr_t is array (0 to num_of_displays_c-1)
    of std_logic_vector(4-1 downto 0);
  type output_arr_t is array (0 to num_of_displays_c-1)
    of std_logic_vector(7-1 downto 0);

  signal input_arr  : input_arr_t;
  signal output_arr : output_arr_t;
  signal input      : std_logic_vector(num_of_displays_c*4-1 downto 0);
  signal output     : std_logic_vector(num_of_displays_c*7-1 downto 0);

  signal clk   : std_logic := '0';
  signal rst_n : std_logic := '0';

  signal active : std_logic_vector(num_of_displays_c-1 downto 0);

  signal number : std_logic_vector(4-1 downto 0);
--  signal number : unsigned(4-1 downto 0);

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
      values_in         : in  std_logic_vector(num_of_displays_c*4-1 downto 0);
      display_active_in : in  std_logic_vector(num_of_displays_c-1 downto 0);
      values_out        : out std_logic_vector(num_of_displays_c*7-1 downto 0));
  end component seven_seg_ctrl;

begin  -- architecture testbench

  clk   <= not(clk) after clk_period_c/2;
  rst_n <= '1'      after reset_down_c;

  active <= (others => '1'),
            (others => '0') after 4_500_000 ns,
            --"10101011" after 85 ns,
            (others => '1') after 5_500_000 ns;

  i_seven_seg_input_gen : seven_seg_input_gen
    generic map (
      max_value_g    => max_value_c,
      delay_cycles_g => 50_000)
    port map (
      clk       => clk,
      rst_n     => rst_n,
      value_out => number);

  input_arr_gen : process (number) is
  begin  -- process

    for display in 0 to num_of_displays_c-1 loop
      input_arr(display) <= number;
    end loop;

    assert unsigned(number) /= max_value_c
      report "Simulation ended"
      severity failure;


  end process input_arr_gen;  -- display

  -- flatten the input array
  genin : process (input_arr) is
  begin  -- process

    for in_display in 0 to num_of_displays_c-1 loop
      input((in_display+1)*4-1 downto in_display*4) <= input_arr(in_display);
    end loop;

  end process genin;


  seven_seg_ctrl_1 : seven_seg_ctrl
    generic map (
      num_of_displays_g => num_of_displays_c)
    port map (
      clk               => clk,
      rst_n             => rst_n,
      values_in         => input,
      display_active_in => active,
      values_out        => output
      );

  -- take outputs to an array
  genout : process (output) is
  begin  -- process

    for out_display in 0 to num_of_displays_c-1 loop
      output_arr(out_display)
        <= output((out_display+1)*7-1 downto out_display*7);
    end loop;
  end process genout;

  -- purpose: checks that all the LUTs give same output values
  -- (should be same because they use same inputs)
  -- type   : combinational
  -- inputs : output_arr
  -- outputs: 
  check_match : process (output_arr) is
  begin  -- process check_match

    if num_of_displays_c > 1 then

      for i in output_arr'low to output_arr'high-1 loop
        assert output_arr(i) = output_arr(i+1)
          report "outputs between LUTs don't match"
          severity error;
      end loop;  -- i


    end if;

  end process check_match;


end architecture testbench;
