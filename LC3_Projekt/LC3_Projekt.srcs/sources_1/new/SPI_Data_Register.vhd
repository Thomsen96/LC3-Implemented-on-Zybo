library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_Data_Register is
	Port (  
            clk     : in STD_LOGIC;
            sys_reset   : in STD_LOGIC;
            data_en   : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR (9 downto 0);
            data_out : out STD_LOGIC_VECTOR (9 downto 0)
          );
end SPI_Data_Register;

architecture Behavioral of SPI_Data_Register is
	
begin
    process ( clk, sys_reset)
    begin
        if (sys_reset = '1') then
            data_out <= "0000000000";
        elsif( clk'event and clk = '1') then
            if ( data_en = '1') then
                data_out <= data_in;
            end if;
        end if;
    end process;
end Behavioral;

