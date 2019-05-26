-------------------------------------------------------------------------------
-- Title      : 7-segment display input generator
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_input_gen.vhd
-- Author     : onnihy@gmail.com
-- Company    : 
-- Created    : 2019-05-26
-- Last update: 2019-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Generates input vaues for a 7-segment display in order to test
--              it on and FPGa board
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

entity seven_seg_input_gen is

  generic (
    max_value_g    : integer range 0 to 15 := 9;
    delay_cycles_g : integer               := 50_000_000);

  port (
    clk       : in  std_logic;
    rst_n     : in  std_logic;
    value_out : out std_logic_vector(4-1 downto 0)
    );

end entity seven_seg_input_gen;


architecture rtl of seven_seg_input_gen is

  signal clk_div_r : integer range 0 to delay_cycles_g;
  signal value     : unsigned(4-1 downto 0);

begin  -- architecture rtl

  -- purpose: Cycles through possible input numbers
  -- type   : sequential
  -- inputs : clk, rst_n
  -- outputs: value_out
  cycle_numbers : process (clk, rst_n) is
  begin  -- process cycle_numbers
    if rst_n = '0' then                 -- asynchronous reset (active low)
      value     <= (others => '0');
      clk_div_r <= 0;
    elsif clk'event and clk = '1' then  -- rising clock edge

      if clk_div_r /= delay_cycles_g then
        clk_div_r <= clk_div_r + 1;
      else
        clk_div_r <= 0;

        if value = max_value_g then
          value <= (others => '0');
        else
          value <= value + 1;
        end if;

      end if;

    end if;
  end process cycle_numbers;

  value_out <= std_logic_vector(value);

end architecture rtl;
