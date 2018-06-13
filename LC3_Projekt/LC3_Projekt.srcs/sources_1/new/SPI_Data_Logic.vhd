
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SPI_Data_Logic is
	Port (	DATA_IN   : in  STD_LOGIC;
				reset : in STD_LOGIC;
				CLK : in  STD_LOGIC;
				DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));

end SPI_Data_Logic;

architecture Behavioral of SPI_Data_Logic is
   signal shift_reg : STD_LOGIC_VECTOR(9 downto 0);
begin    
    --shift register

	 DATA_OUT <= shift_reg;

    process (CLK, reset)
    begin
			if (reset = '1') then
				shift_reg <= "0000000000";
			
			elsif (rising_edge(CLK)) then
            shift_reg(9 downto 1) <= shift_reg(8 downto 0);
            shift_reg(0) <= DATA_IN;
			end if;
    end process;
    
	 

end Behavioral;

