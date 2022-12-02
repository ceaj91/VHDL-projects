----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2022 06:37:41 PM
-- Design Name: 
-- Module Name: mul_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul_tb is
--  Port ( );
end mul_tb;

architecture Behavioral of mul_tb is
  constant WIDTH:integer:=8;
  signal clk   : std_logic;
  signal reset : std_logic;
  signal a_i   : std_logic_vector(WIDTH-1 downto 0):=(others => '0');
  signal b_i   : std_logic_vector(WIDTH-1 downto 0):=(others => '0');
  signal res_o : std_logic_vector(2*WIDTH-1 downto 0);
begin
  add_and_shift_mul_1: entity work.tree_pipeline_multiply
    generic map (
      WIDTH => WIDTH)
    port map (
      clk   => clk,
      reset => reset,
      a_in   => a_i,
      b_in   => b_i,
      res_out => res_o);

  process
  begin
    --a_i <= x"4";
    --b_i <= x"4";
    reset <= '1';
    wait for 1000ns;
    reset <= '0';
    a_i <= std_logic_vector(to_unsigned(15, WIDTH));
    b_i <= std_logic_vector(to_unsigned(15, WIDTH));
    wait for 100ns;
    a_i <= std_logic_vector(to_unsigned(14, WIDTH));
    b_i <= std_logic_vector(to_unsigned(14, WIDTH));
    wait for 100ns;
    a_i <= std_logic_vector(to_unsigned(13, WIDTH));
    b_i <= std_logic_vector(to_unsigned(13, WIDTH));
    wait for 100ns;
    a_i <= std_logic_vector(to_unsigned(12, WIDTH));
    b_i <= std_logic_vector(to_unsigned(12, WIDTH));
    wait for 100ns;
    a_i <= std_logic_vector(to_unsigned(11, WIDTH));
    b_i <= std_logic_vector(to_unsigned(11, WIDTH));
    wait for 100ns;
    a_i <= std_logic_vector(to_unsigned(10, WIDTH));
    b_i <= std_logic_vector(to_unsigned(10, WIDTH));
    wait for 100ns;
    a_i <= std_logic_vector(to_unsigned(9, WIDTH));
    b_i <= std_logic_vector(to_unsigned(9, WIDTH));
    wait for 100ns;
    a_i <= std_logic_vector(to_unsigned(8, WIDTH));
    b_i <= std_logic_vector(to_unsigned(8, WIDTH));
    wait;
  end process;

    process
    begin
      clk <= '1', '0' after 50ns;
      wait for 100ns;
    end process;

end Behavioral;
