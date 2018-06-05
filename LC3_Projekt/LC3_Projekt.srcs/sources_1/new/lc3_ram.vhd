----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.06.2018 13:13:03
-- Design Name: 
-- Module Name: lc3_ram - structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
--use UNISIM.VComponents.all;

entity one_port_ram_sync is
    generic(
        ADDR_WIDTH: integer:=16;
        DATA_WIDTH: integer:=14
        );

    Port (
        clk: in std_logic;
        we: in std_logic;
        addr: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        din: in std_logic_vector(DATA_WIDTH - 1 downto 0);
        dout: in std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end one_port_ram_sync;

architecture beh_arch of one_port_ram_sync is
    type ram_type is array (2**ADDR_WIDTH - 1 downto 0)
        of std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal ram : ram_type;
    signal addr_reg : std_logic_vector ( ADDR_WIDTH - 1 downto 0);   

begin
    process ( clk )
    begin
        if ( clk'event and clk = '1') then
            if (we = '1') then
                ram(to_integer(unsigned(addr))) <= din;
            end if;
        addr_reg <= addr;
        end if;
    end process;
    dout <= ram(to_integer(unsigned(addr_reg)));

end beh_arch;
