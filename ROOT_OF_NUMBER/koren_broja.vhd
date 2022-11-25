

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity koren_broja is
generic(WIDTH:positive);
Port (x:in std_logic_vector(WIDTH-1 downto 0);
      clk:in std_logic;
      start: in std_logic;
      reset: in std_logic;
      r_out:out std_logic_vector(WIDTH-1 downto 0);
      ready: out std_logic);
end koren_broja;

architecture Behavioral of koren_broja is
type reg_state is (IDLE, ONE_CH, RES_CH, SHIFT);

signal op_reg,op_next: std_logic_vector(WIDTH-1 downto 0);
signal one_reg, one_next,one_reg_shl1: std_logic_vector(30 downto 0);
signal res_reg,res_next:std_logic_vector(WIDTH-1 downto 0);
signal state_reg: reg_state := IDLE;
signal state_next:reg_state := IDLE;
signal res_reg_plus_one_reg:std_logic_vector(30 downto 0);

begin

process(clk,reset) is
begin
if (reset = '1') then
    op_reg <= (others=>'0');
    one_reg <= (others=>'0');
    res_reg <= (others=>'0');
    state_reg <= IDLE;
elsif(rising_edge(clk)) then
    op_reg <= op_next;
    one_reg <= one_next;
    res_reg <= res_next;
    state_reg <= state_next;
end if;
end process;

process(state_reg,op_reg,one_reg,res_reg,start,x,one_next,res_reg_plus_one_reg,op_next) is 
begin
op_next <= op_reg;
one_next <= one_reg;
res_next <= res_reg;
ready <= '0';
case state_reg is
    when IDLE =>
        ready <= '1';
        if(start ='1') then
            op_next <= x;
            one_next <= '1' & std_logic_vector(to_unsigned(0,30));
            res_next <= (others => '0');
            if(unsigned(one_next) > unsigned(op_next)) then
                state_next <= ONE_CH;
            else
                state_next <= RES_CH;
            end if;
        else
            state_next <= IDLE;
            
        end if;
        
    when ONE_CH =>
        one_next <= "00"&one_reg(30 downto 2);    -- mozda dole nece prepoznati one_next ??
        if (unsigned(one_next) > unsigned(op_next)) then
            state_next <= ONE_CH;
        else
            state_next <= RES_CH;
        end if;
        
    when RES_CH =>
       if (not(unsigned(one_next) = to_unsigned(0,30))) then
            if(unsigned(op_reg) < unsigned(res_reg_plus_one_reg)) then
                 state_next <= SHIFT;
            else
                 op_next <= std_logic_vector(unsigned(op_reg) - unsigned(res_reg_plus_one_reg(WIDTH-1 downto 0)));
                 res_next <= std_logic_vector(unsigned(res_reg) + unsigned(one_reg_shl1(WIDTH-1 downto 0)));  
                 --res_next <= std_logic_vector(to_unsigned(5,WIDTH/2+2));
                 state_next <= SHIFT;
             end if;
       else
            state_next <= IDLE;
       end if;
    when SHIFT =>
        res_next <= '0' &res_reg(WIDTH-1 downto 1);
        one_next <= "00" & one_reg(30 downto 2);
        state_next <= RES_CH;
      
end case;
end process;

one_reg_shl1 <= one_reg(29 downto 0)&'0';
res_reg_plus_one_reg<=std_logic_vector(unsigned(res_reg)+unsigned(one_reg));
r_out <= res_reg;
end Behavioral;
