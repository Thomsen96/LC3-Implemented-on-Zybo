
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SPI_Data_Logic is
    Port (	
        miso    : in  std_logic;
        mosi    : out std_logic;
        reset   : in std_logic;
        tick_rise : in  std_logic;
        tick_fall : in  std_logic;
        
        rd  : in std_logic;
        sel : in std_logic_vector (2 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));

end SPI_Data_Logic;

architecture Behavioral of SPI_Data_Logic is
    signal shift_reg : STD_LOGIC_VECTOR(16 downto 0);
    signal komando   :  STD_LOGIC_VECTOR(16 downto 0);
begin    
    --shift register
    komando <= "11" & sel & "000000000000";
    DATA_OUT <= shift_reg(9 downto 0);
    mosi <= shift_reg(16);
    
    
    process (tick_fall, tick_rise, reset, rd)
    begin
        if (reset = '1') then
            shift_reg <= "11000000000000000";
        elsif ( rd = '1') then
            shift_reg <= komando;
        elsif (tick_fall = '1') then
            shift_reg(16 downto 1) <= shift_reg(15 downto 0);
        elsif (tick_rise = '1') then
            shift_reg(0) <= miso;
        end if;
    end process;

	 

end Behavioral;

