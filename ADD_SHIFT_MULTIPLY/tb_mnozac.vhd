
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_mnozac is
GENERIC(WIDTH:positive := 8);
end tb_mnozac;

architecture Behavioral of tb_mnozac is
signal a_s, b_s :std_logic_vector(WIDTH-1 downto 0);
signal clk_s,reset_s,ready_s:std_logic;
signal r_s:std_logic_vector(2*WIDTH-1 downto 0);
begin

duv: entity work.pipeline
    generic map(WIDTH => WIDTH)
    port map(
            a_in => a_s,
            b_in  => b_s,
            clk => clk_s,
            reset=>reset_s,
            r_out => r_s);
  process
  begin
    --a_i <= x"4";
    --b_i <= x"4";
    reset_s <= '1';
    wait for 1000ns;
    reset_s <= '0';
    a_s <= std_logic_vector(to_unsigned(15, WIDTH));
    b_s <= std_logic_vector(to_unsigned(15, WIDTH));
    wait for 100ns;
    a_s <= std_logic_vector(to_unsigned(14, WIDTH));
    b_s <= std_logic_vector(to_unsigned(14, WIDTH));
    wait for 100ns;
    a_s <= std_logic_vector(to_unsigned(13, WIDTH));
    b_s <= std_logic_vector(to_unsigned(13, WIDTH));
    wait for 100ns;
    a_s <= std_logic_vector(to_unsigned(12, WIDTH));
    b_s <= std_logic_vector(to_unsigned(12, WIDTH));
    wait for 100ns;
    a_s <= std_logic_vector(to_unsigned(11, WIDTH));
    b_s <= std_logic_vector(to_unsigned(11, WIDTH));
    wait for 100ns;
    a_s <= std_logic_vector(to_unsigned(10, WIDTH));
    b_s <= std_logic_vector(to_unsigned(10, WIDTH));
    wait for 100ns;
    a_s <= std_logic_vector(to_unsigned(9, WIDTH));
    b_s <= std_logic_vector(to_unsigned(9, WIDTH));
    wait for 100ns;
    a_s <= std_logic_vector(to_unsigned(8, WIDTH));
    b_s <= std_logic_vector(to_unsigned(8, WIDTH));
    wait;
  end process;

    process
    begin
      clk_s <= '1', '0' after 50ns;
      wait for 100ns;
    end process;


end Behavioral;
