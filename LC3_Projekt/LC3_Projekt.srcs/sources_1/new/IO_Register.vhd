library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity IO_Register is
    Port (  
            clk     : in STD_LOGIC;
            reset   : in STD_LOGIC;
            cs_en   : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR (15 downto 0);
            data_out : out STD_LOGIC_VECTOR (15 downto 0)
          );
end IO_Register;

architecture Behavioral of IO_Register is

begin
    --data_out <= x"FFAA";
    process ( clk, reset)
    begin
        if (reset = '1') then
            data_out <= x"0000";
        elsif( clk'event and clk = '1') then
            if ( cs_en = '1') then
                data_out <= data_in;
            end if;
        end if;
    end process;

end Behavioral;


