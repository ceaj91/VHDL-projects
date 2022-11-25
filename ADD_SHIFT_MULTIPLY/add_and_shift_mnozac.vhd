



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity add_and_shift_mnozac is
generic(WIDTH:positive := 8);
Port (a_in : in std_logic_vector(WIDTH-1 downto 0);
      b_in : in std_logic_vector(WIDTH-1 downto 0);
      start: in std_logic;
      clk : in std_logic;
      reset: in std_logic;
      r_out: out std_logic_vector(2*WIDTH-1 downto 0);
      ready: out std_logic);
end add_and_shift_mnozac;

architecture Behavioral of add_and_shift_mnozac is

type reg_state is (IDLE, SHIFT, OP);

signal a_reg, a_next : std_logic_vector(WIDTH-1 downto 0);
signal b_reg, b_next : std_logic_vector(WIDTH-1 downto 0);
signal n_reg, n_next : std_logic_vector(WIDTH-1 downto 0);
signal p_reg, p_next : std_logic_vector(2*WIDTH-1 downto 0);
signal state_reg: reg_state := IDLE;
signal state_next: reg_state := IDLE;
signal is_n_next_0: std_logic;
begin

change_states:process(clk) 
begin
if (reset = '1') then
    a_reg <= (others =>'0');
    b_reg <= (others =>'0');
    n_reg <= (others =>'0');
    p_reg <= (others =>'0');
    state_reg <= IDLE;
elsif(rising_edge(clk)) then
    a_reg <= a_next;
    b_reg <= b_next;
    n_reg <= n_next;
    p_reg <= p_next;
    state_reg <= state_next;
end if;
end process;

combinational_cicuits: process(a_reg,b_reg,n_reg,p_reg,start,b_next,n_next,a_in,b_in, state_reg) 
begin 
--default values
a_next <= a_reg;
b_next <= b_reg;
n_next <= n_reg;
p_next <= p_reg;
ready <= '0';

case state_reg is
    when IDLE =>
        if(start = '1') then
            a_next <= a_in;
            b_next <= b_in;
            n_next <= std_logic_vector(to_unsigned(WIDTH,WIDTH));
            p_next <= std_logic_vector(to_unsigned(0,2*WIDTH));
            if(b_next(0) = '1') then
                state_next <= OP;
            else
                state_next <= SHIFT;
            end if;
        else
            ready <='1';
            state_next <= IDLE;
        end if;
    when SHIFT =>
        b_next <= '0'&b_reg(WIDTH-1 downto 1);
        a_next <= a_reg(WIDTH-2 downto 0)&'0';
        n_next <= std_logic_vector(unsigned(n_reg) - to_unsigned(1,WIDTH));
        if(n_next /= std_logic_vector(to_unsigned(0,WIDTH))) then
            if(b_next(0) = '1') then
                state_next <= OP;
            else
                state_next <= SHIFT;
            end if;
        else
            state_next <= IDLE;
        end if;            
    when OP => 
        p_next <= std_logic_vector(unsigned(p_reg) + unsigned(a_reg));
        state_next <=  SHIFT;
end case;
end process;

r_out <= p_reg;
end Behavioral;