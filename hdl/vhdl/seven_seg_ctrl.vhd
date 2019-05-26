-------------------------------------------------------------------------------
-- Title      : 7-segment display controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_ctrl.vhd
-- Author     : onnihy@gmail.com
-- Company    : 
-- Created    : 2019-05-23
-- Last update: 2019-05-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Controller for generic amount of 7-segment displays
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-05-23  1.0      onnex   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_ctrl is

  generic (
    num_of_displays_g : positive := 8
    );

  port (
    clk               : in  std_logic;
    rst_n             : in  std_logic;
    values_in         : in  std_logic_vector(num_of_displays_g*4-1 downto 0);
    display_active_in : in  std_logic_vector(num_of_displays_g-1 downto 0);
    values_out        : out std_logic_vector(num_of_displays_g*7-1 downto 0)
    );

end entity seven_seg_ctrl;


architecture structural of seven_seg_ctrl is

  type input_arr_t is array (0 to num_of_displays_g-1)
    of std_logic_vector(4-1 downto 0);
  type output_arr_t is array (0 to num_of_displays_g-1)
    of std_logic_vector(7-1 downto 0);

  signal input_arr  : input_arr_t;
  signal output_arr : output_arr_t;

  component seven_seg_lut is
    port (
      data_in  : in  std_logic_vector(3 downto 0);
      data_out : out std_logic_vector(6 downto 0)
      );
  end component seven_seg_lut;

begin  -- architecture structural

  -- take inputs to an array
  gen_in : process (values_in) is
  begin  -- process

    for in_display in 0 to num_of_displays_g-1 loop
      input_arr(in_display)
        <= values_in((in_display+1)*4-1 downto in_display*4);
    end loop;

  end process gen_in;

  -- generate lookup tables
  gen_luts : for display in 0 to num_of_displays_g-1 generate

    i_seven_seg_lut : seven_seg_lut
      port map (
        data_in  => input_arr(display),
        data_out => output_arr(display)
        );

  end generate gen_luts;

-- purpose: Makes output of the entity registered
-- type   : sequential
-- inputs : clk, rst_n, output_arr
-- outputs: values_out
  output : process (clk, rst_n) is

    variable out_vec_v : std_logic_vector(output_arr(output_arr'low)'range);

  begin  -- process output

    if rst_n = '0' then                 -- asynchronous reset (active low)
      values_out <= (others => '1');
      out_vec_v  := (others => '1');

    elsif clk'event and clk = '1' then  -- rising clock edge

      for out_display in 0 to num_of_displays_g-1 loop

        if display_active_in(out_display) = '1' then
          out_vec_v := output_arr(out_display);
        else
          out_vec_v := (others => '1');
        end if;

        values_out((out_display+1)*7-1 downto out_display*7) <= out_vec_v;

      end loop;  -- out_display

    end if;

  end process output;


end architecture structural;
