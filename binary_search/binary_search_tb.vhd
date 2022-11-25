library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity binary_search_tb is
generic(DATA_WIDTH: positive := 8;
        ARRAY_SIZE:positive :=8;
        ADR_SIZE:positive:=3);
 --Port ( );
end binary_search_tb;

architecture Behavioral of binary_search_tb is
signal key_s, left_s,right_s, pos_s:std_logic_vector(7 downto 0);
signal start_s, clk_s, reset_s, ready_s,el_found_s:std_logic;
--MEMORY INETRFACE
signal mem_adr_s:std_logic_vector(ADR_SIZE-1 downto 0);
signal mem_data_s: std_logic_vector(7 downto 0); 
signal mem_wr_s : std_logic;

signal adr_s:std_logic_vector(ADR_SIZE-1 downto 0);
signal data_in_s: std_logic_vector(7 downto 0);
signal wr_s: std_logic;
type mem_type is array (0 to ARRAY_SIZE-1) of std_logic_vector(7 downto 0);

constant MEM_CONTET : mem_type := (std_logic_vector(to_unsigned(0,8)),
                                   std_logic_vector(to_unsigned(1,8)),
                                   std_logic_vector(to_unsigned(5,8)),
                                   std_logic_vector(to_unsigned(10,8)),
                                   std_logic_vector(to_unsigned(16,8)),
                                   std_logic_vector(to_unsigned(20,8)),
                                   std_logic_vector(to_unsigned(24,8)),
                                   std_logic_vector(to_unsigned(35,8)));

begin

clk_procs: process is
begin
    clk_s<='0','1' after 100ns;
    wait for 200ns;

end process;

stim_gen: process is
begin
    start_s <='0';
    reset_s <='1';
    wait for 500ns;
    reset_s <= '0';
    wait until falling_edge(clk_s);
    mem_wr_s <='1';
    for i in 0 to ARRAY_SIZE-1 loop
        mem_adr_s <=  std_logic_vector(to_unsigned(i,ADR_SIZE));
        mem_data_s <= MEM_CONTET(i); 
        wait until falling_edge(clk_s);
    end loop;
    mem_wr_s<='0';
    start_s <='1';
    key_s<= std_logic_vector(to_unsigned(0,DATA_WIDTH));
    left_s<= std_logic_vector(to_unsigned(0,DATA_WIDTH));
    right_s <= std_logic_vector(to_unsigned(ARRAY_SIZE-1,DATA_WIDTH));
    wait until falling_edge(clk_s);
    start_s <='0';
    wait until ready_s <= '1';
    wait;
end process;

mem: entity work.dp_memory(beh)
generic map(WIDTH => DATA_WIDTH,ADR_SIZE =>ADR_SIZE)
port map(clk =>clk_s,
        reset => reset_s,
        -- Port 1 interface
        p1_addr_i => mem_adr_s,
        p1_data_i => mem_data_s,
        p1_data_o => open,
        p1_wr_i => mem_wr_s,
        -- Port 2 interface
        p2_addr_i => adr_s,
        p2_data_i => (others=>'0'),
        p2_data_o => data_in_s,
        p2_wr_i => wr_s);

duv: entity work.binary_search
generic map(ADR_SIZE => ADR_SIZE,DATA_WIDTH=>DATA_WIDTH)
port map(key_in =>key_s,
        left_in =>left_s,
        right_in =>right_s,
        start =>start_s,
        clk =>clk_s,
        reset =>reset_s,
        ready =>ready_s,
        pos_out =>pos_s,
        el_found_out =>el_found_s,
        adr_out =>adr_s,
        mem_data =>data_in_s,
        rw_out=>wr_s);

end Behavioral;
