library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity binary_search is
Generic(ADR_SIZE:positive :=3;
        DATA_WIDTH: positive := 8);
Port ( 
    key_in:in std_logic_vector(DATA_WIDTH-1 downto 0);
    left_in:in std_logic_vector(DATA_WIDTH-1 downto 0);
    right_in:in std_logic_vector(DATA_WIDTH-1 downto 0);
    start:in std_logic;
    clk: in std_logic;
    reset:in std_logic;

    ready:out std_logic;
    pos_out: out std_logic_vector(DATA_WIDTH-1 downto 0);
    el_found_out:out std_logic;
    
    --mem interfejs
    adr_out:out std_logic_vector(ADR_SIZE-1 downto 0);
    mem_data:in std_logic_vector(DATA_WIDTH-1 downto 0);
    rw_out:out std_logic);
end binary_search;

architecture Behavioral of binary_search is

type reg_state is (IDLE,INIT,CALC);

signal state_reg, state_next: reg_state := IDLE;
signal  left_reg,right_reg, midle_reg, left_next,right_next, midle_next,key_reg,key_next: std_logic_vector(DATA_WIDTH-1 downto 0);
signal midle_temp: std_logic_vector(DATA_WIDTH-1 downto 0);


begin

--seq part of circuit
process(clk) is 
begin
if (reset ='1') then
    left_reg <= (others =>'0');
    right_reg <= (others =>'0');
    midle_reg <=(others =>'0');
    key_reg <= (others =>'0');
    state_reg <= IDLE;
elsif (rising_edge(clk)) then
        left_reg <= left_next;
        right_reg <= right_next;
        midle_reg <= midle_next;
        key_reg <= key_next;
        state_reg <= state_next;
 end if;
end process;


process(state_reg,start,mem_data,midle_next,midle_temp,left_in,right_in, key_in,key_reg,left_reg,right_reg, midle_reg,key_reg) is
begin
left_next <= left_reg ;
right_next <= right_reg;
midle_next <= midle_reg;
key_next <= key_reg;
ready <= '0';
el_found_out <= '0'; 
rw_out <= '0';
adr_out <= (others =>'0');

case state_reg is

    when IDLE => 
        ready<='1';
        if(start ='1') then
            left_next <= left_in;
            right_next <= right_in;
            key_next <= key_in;
            state_next <= INIT;
        else
            state_next <= IDLE;
        end if;
    when INIT =>
        if(unsigned(left_reg) <= unsigned(right_reg)) then
            midle_temp <= std_logic_vector(unsigned(left_reg)+unsigned(right_reg));
            midle_next <= '0'&midle_temp(DATA_WIDTH-1 downto 1);
            adr_out <= midle_next(ADR_SIZE-1 downto 0);
            state_next <= CALC;
        else 
            state_next <= INIT;
        end if;
    when CALC =>
        if (unsigned(mem_data) = unsigned(key_reg)) then
            el_found_out <='1';
            state_next <= IDLE;
        else
            state_next <= INIT;
            if(unsigned(mem_data) > unsigned(key_reg)) then
                right_next <= std_logic_vector(unsigned(midle_reg)-TO_UNSIGNED(1,DATA_WIDTH));
            else
                left_next <= std_logic_vector(unsigned(midle_reg)+TO_UNSIGNED(1,DATA_WIDTH));
            end if;
        end if;
end case;
end process;

pos_out <= midle_reg;

end Behavioral;
