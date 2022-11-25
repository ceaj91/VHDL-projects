
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_mnozac is
GENERIC(WIDTH:positive := 8);
end tb_mnozac;

architecture Behavioral of tb_mnozac is
signal a_s, b_s :std_logic_vector(WIDTH-1 downto 0);
signal start_s,clk_s,reset_s,ready_s:std_logic;
signal r_s:std_logic_vector(2*WIDTH-1 downto 0);
begin

duv: entity work.add_and_shift_mnozac
    generic map(WIDTH => WIDTH)
    port map(
            a_in => a_s,
            b_in  => b_s,
            start => start_s,
            clk => clk_s,
            reset=>reset_s,
            ready => ready_s,
            r_out => r_s);

clk_gen: process is
begin
    clk_s <= '0';
    wait for 100ns;
    clk_s <= '1';
    wait for 100ns;
end process;

signal_gen: process is
begin
a_s <= std_logic_vector(to_unsigned(30,WIDTH));
b_s <= std_logic_vector(to_unsigned(6,WIDTH));
start_s <= '0';
reset_s <='1';
wait for 300ns;
reset_s <='0';
wait for 700ns;
start_s<='1';
wait;
end process;


end Behavioral;
