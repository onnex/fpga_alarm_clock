-------------------------------------------------------------------------------
-- Title      : 7-segment display LUT
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_lut.vhd
-- Author     : onnihy@gmail.com
-- Company    : 
-- Created    : 2019-05-22
-- Last update: 2019-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Returns data input value in 7-segment format for one display
--              Works with numbers 0-9
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

entity seven_seg_lut is

  port (
    data_in  : in  std_logic_vector(4-1 downto 0);
    data_out : out std_logic_vector(7-1 downto 0)
    );

end entity seven_seg_lut;


architecture rtl of seven_seg_lut is

  signal value : unsigned(4-1 downto 0);

begin  -- architecture rtl

  value <= unsigned(data_in);

  data_out <=
    B"100_0000" when value = 0 else
    B"111_1001" when value = 1 else
    B"010_0100" when value = 2 else
    B"011_0000" when value = 3 else
    B"001_1001" when value = 4 else
    B"001_0010" when value = 5 else
    B"000_0010" when value = 6 else
    B"111_1000" when value = 7 else
    B"000_0000" when value = 8 else
    B"001_0000" when value = 9 else
    B"111_1111";

  assert value >= 0 and value < 10
    report "value " & integer'image(to_integer(value)) & " is out of range 0 to 9"
    severity note;

end architecture rtl;
