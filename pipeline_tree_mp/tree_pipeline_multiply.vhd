

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tree_pipeline_multiply is
generic(WIDTH:positive:=8);
Port(a_in: in std_logic_vector(WIDTH-1 downto 0);
     b_in: in std_logic_vector(WIDTH-1 downto 0);
     reset:in std_logic;
     clk:in std_logic;
     res_out:out std_logic_vector(2*WIDTH-1 downto 0));
end tree_pipeline_multiply;

architecture Behavioral of tree_pipeline_multiply is
--   stage    reg_in_stage
--type pipe_stage_1 is array(0 to 3) of std_logic_vector(2*WIDTH-1 downto 0); 
--type pipe_stage_2 is array(0 to 1) of std_logic_vector(2*WIDTH-1 downto 0); 
--signal stage1_reg, stage1_next:pipe_stage_1;
--signal stage2_reg,stage2_next:pipe_stage_2;
--signal stage3_reg_stage3_next:std_logic_vector(2*WIDTH-1 downto 0);

type pipe_mem is array (0 to 6) of std_logic_vector(2*WIDTH-1 downto 0);
type extended_bit is array(0 to WIDTH-1) of std_logic_vector(2*WIDTH-1 downto 0);
type temp_res is array (0 to WIDTH-1) of std_logic_vector(WIDTH-1 downto 0);

signal res_temp,b_extended:temp_res;
signal pipe_reg,pipe_next: pipe_mem;
signal BP: extended_bit;
begin

--seq
process(clk) is begin

    if(rising_edge(clk)) then
        if(reset='1') then
            for i in 0 to 6 loop
                pipe_reg(i)<=(others=>'0');
            end loop;
        else
            for i in 0 to 6 loop
                    pipe_reg(i)<=pipe_next(i);
            end loop;
            end if;
    end if;
end process;

comb: process(a_in,b_in,b_extended,BP,pipe_reg) is 
begin
--first stage
    for i in 0 to WIDTH-1 loop
        b_extended(i)<= (others=>b_in(i));
        res_temp(i) <=(b_extended(i) and a_in); 
        BP(i)<= std_logic_vector(to_unsigned(0,WIDTH)) &res_temp(i);
    end loop;
    pipe_next(0) <= std_logic_vector(unsigned(BP(0)) + unsigned(BP(1)));
    pipe_next(1) <= std_logic_vector(unsigned(BP(2)) + unsigned(BP(3)));
    pipe_next(2) <= std_logic_vector(unsigned(BP(4)) + unsigned(BP(5)));
    pipe_next(3) <= std_logic_vector(unsigned(BP(6)) + unsigned(BP(7)));
    pipe_next(4) <= std_logic_vector(unsigned(pipe_reg(0)) + unsigned(pipe_reg(1)));
    pipe_next(5) <= std_logic_vector(unsigned(pipe_reg(2)) + unsigned(pipe_reg(3)));
    pipe_next(6) <= std_logic_vector(unsigned(pipe_reg(4)) + unsigned(pipe_reg(5)));
end process;

res_out<=pipe_reg(6);

end Behavioral;
