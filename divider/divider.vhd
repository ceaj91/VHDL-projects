
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity divider is
generic(WIDTH:positive := 8);
Port (a_in:in std_logic_vector(WIDTH-1 downto 0);
      b_in:in std_logic_vector(WIDTH-1 downto 0);
      clk:in std_logic;
      start:in std_logic;
      reset:in std_logic;
      
      result:out std_logic_vector(WIDTH-1 downto 0);
      ostatak:out std_logic_vector(WIDTH-1 downto 0);
      ready:out std_logic);
end divider;

architecture Behavioral of divider is
type reg_state is (IDLE,B_greq_A, RES);
signal state_reg: reg_state := IDLE;
signal state_next: reg_state := IDLE;

signal op1_reg,op1_next:std_logic_vector(WIDTH-1 downto 0);
signal op2_reg,op2_next:std_logic_vector(WIDTH-1 downto 0);
signal q_reg,q_next: std_logic_vector(WIDTH-1 downto 0);
signal r_reg,r_next: std_logic_vector(WIDTH-1 downto 0);


begin
--sekvencijalni deo
process(clk, reset) is
begin
    if(reset = '1') then
        op1_reg<=(others => '0');
        op2_reg<=(others => '0');
        q_reg <= (others => '0');
        r_reg <= (others => '0');
        state_reg <= IDLE;
     elsif(rising_edge(clk)) then
        op1_reg <= op1_next;
        op2_reg <= op2_next;
        q_reg <= q_next;
        r_reg <= r_next;
        state_reg <= state_next;
      end if;   
end process;
--kombinacioni deo
process(state_reg,op1_reg,op2_reg,q_reg,r_reg,a_in,b_in,q_reg,start) is 
begin
    op1_next <= op1_reg;
    op2_next <= op2_reg;
    q_next <= q_reg;
    r_next <= r_reg;
    ready <= '0';
    case state_reg is 
        when IDLE=>
            ready <= '1';
            if(start ='1') then
                q_next <= (others => '0');
                r_next <= (others => '0');
                if(unsigned(a_in) > unsigned(b_in)) then
                    op1_next <= a_in;
                    op2_next <= b_in;
                    state_next <= RES;
                else
                    state_next <=B_greq_A;
                end if;
            else
                state_next <= IDLE;
            end if;
            
        when B_greq_A =>
            op1_next <= b_in;
            op2_next <= a_in;
            state_next <=RES;
        when RES =>
            if(unsigned(op1_reg) < unsigned(op2_reg)) then
                r_next <= op1_reg;
                state_next <= IDLE;
            else   
                state_next <= RES;
                op1_next <= std_logic_vector(unsigned(op1_reg)-unsigned(op2_reg));
                q_next <= std_logic_vector(unsigned(q_reg) + to_unsigned(1,WIDTH));
            end if;
     end case;
end process;

result <= q_reg;
ostatak <= r_reg;

end Behavioral;
