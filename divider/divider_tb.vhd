

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity divider_tb is
generic  (WIDTH:positive :=8 );
end divider_tb;

architecture Behavioral of divider_tb is

signal a_s,b_s,res_s,ostatak_s: std_logic_vector(WIDTH-1 downto 0);
signal clk_s,reset_s,ready_s,start_s:std_logic;


begin

duv:entity work.divider 
generic map(WIDTH => WIDTH)
port map(a_in=>a_s, b_in => b_s, clk=> clk_s, result=> res_s, reset => reset_s, start=>start_s, ready => ready_s,ostatak => ostatak_s);


clk_proc:process is 
begin 
    clk_s <= '0','1' after 100ns;
    wait for 200ns;
end process;

stim_gen: process is begin
a_s <= std_logic_vector(to_unsigned(48,WIDTH));
b_s <= std_logic_vector(to_unsigned(8,WIDTH));
reset_s<='1';
start_s <= '0';
wait for 50ns;
reset_s<='0';
wait for 50ns;
start_s<='1';
wait;


end process;

end Behavioral;
