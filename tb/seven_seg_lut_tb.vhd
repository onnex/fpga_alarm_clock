-------------------------------------------------------------------------------
-- Title      : 7-segment LUT testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_lut_tb.vhd
-- Author     : onnihy@gmail.com
-- Company    : 
-- Created    : 2019-05-22
-- Last update: 2019-05-25
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Verifies 7-segment LUT
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-05-22  1.0      onnex   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_lut_tb is
  generic (
    max_num_g : integer := 9
    );

end entity seven_seg_lut_tb;

architecture testbench of seven_seg_lut_tb is

  type seven_seg_arr is array (0 to 9) of std_logic_vector(8-1 downto 0);
  constant seven_seg_c : seven_seg_arr := (X"3F", X"06", X"5B", X"4F", X"66",
                                           X"6D", X"7D", X"07", X"7F", X"6F");

  signal number : unsigned(4-1 downto 0) := "0000";
  signal output : std_logic_vector(7-1 downto 0);

  component seven_seg_lut is
    port (
      data_in  : in  std_logic_vector(4-1 downto 0);
      data_out : out std_logic_vector(7-1 downto 0)
      );
  end component seven_seg_lut;

begin  -- architecture testbench

  i_seven_seg_lut : seven_seg_lut
    port map (
      data_in  => std_logic_vector(number),
      data_out => output
      );

-- purpose: loop through all numbers and check them
-- type   : combinational
-- inputs : 
-- outputs: number
  stimulus : process

  begin

    for i in 0 to max_num_g loop
      number <= to_unsigned(i, 4);

      wait for 10 ns;

      assert output = not(seven_seg_c(to_integer(number))(6 downto 0))
        report "output does not match 7-seg table value"
        severity error;

      assert number /= max_num_g report "Simulation succesful" severity failure;

    end loop;  -- i

    wait;

  end process stimulus;

end architecture testbench;
