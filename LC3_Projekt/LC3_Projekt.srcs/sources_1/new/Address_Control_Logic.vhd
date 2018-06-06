----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.06.2018 12:08:45
-- Design Name: 
-- Module Name: Address_Control_Logic - Behavioral
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

entity ACL is
    Port ( 
        addr    :   in  STD_LOGIC_VECTOR (15 downto 0);
        RE      :   in  STD_LOGIC;
        WE      :   in  STD_LOGIC;
        mem_we  :   out STD_LOGIC;
        ACL_TO_MUX  :   out STD_LOGIC_VECTOR(4 downto 0);
        test        :   out STD_LOGIC
    );
end ACL;

architecture Behavioral of ACL is
begin
    process ( addr )
    begin
        cs_sw = '0';
        if( addr = IO_SW) then
            cs_sw = '1';
        end if;
        if(RE = '1') then 
                
        end if;
        mem_en <= '0';
        test <= '0';
        ACL_TO_MUX <= "00101";
        --if (  addr = x"0001") then
            
        --end if;
    end process;
end Behavioral;
