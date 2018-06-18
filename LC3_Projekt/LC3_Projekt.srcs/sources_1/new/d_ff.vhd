
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_ff is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        en      : in STD_LOGIC;
        data_in : in STD_LOGIC;
        data_out : out STD_LOGIC);
end d_ff;

architecture Behavioral of d_ff is
begin
process (clk, reset)
    begin
        if (reset = '1') then
            data_out <= '0';
        elsif (clk'event and clk = '1' and en = '1') then
            data_out <= data_in;
        end if;
            
    end process;


end Behavioral;
