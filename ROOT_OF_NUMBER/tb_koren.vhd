

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_koren is
generic(WIDTH:positive:=8);
end tb_koren;

architecture Behavioral of tb_koren is

signal x_s: std_logic_vector(WIDTH-1 downto 0);
signal clk_s, start_s,reset_s, ready_s: std_logic;
signal r_s : std_logic_vector (WIDTH-1 downto 0);

begin

duv:entity work.koren_broja
generic map(WIDTH => WIDTH)
port map (x =>x_s,
          clk=>clk_s,
          start=>start_s,
          reset=>reset_s,
          r_out=>r_s,
            ready=>ready_s);
            
clk_p:process is
begin
clk_s <= '0', '1' after 100ns;
wait for 200ns;
end process;

stim_gen:process is
begin
x_s<= std_logic_vector(to_unsigned(169,WIDTH));
start_s <= '0';
reset_s <='1';
wait for 500ns;
reset_s <='0';
wait for 900ns;
start_s <= '1';
wait for 9700ns;
start_s <= '0';
wait;
end process;


end Behavioral;
