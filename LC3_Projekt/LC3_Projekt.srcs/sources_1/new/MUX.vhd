----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.06.2018 12:33:24
-- Design Name: 
-- Module Name: MUX - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX is
    Port ( 
            -- Selctor og output
           MUX_in : in STD_LOGIC_VECTOR (4 downto 0);
           MUX_out : out STD_LOGIC_VECTOR (15 downto 0);
           -- Input til MUXen.
           ram      : in STD_LOGIC_VECTOR (15 downto 0);
           SiSR     : in STD_LOGIC_VECTOR (15 downto 0);
           SiDR     : in STD_LOGIC_VECTOR (15 downto 0);
           SoSR     : in STD_LOGIC_VECTOR (15 downto 0);
           SoDR     : in STD_LOGIC_VECTOR (15 downto 0);
           SwDR     : in STD_LOGIC_VECTOR (15 downto 0);
           PSwDR    : in STD_LOGIC_VECTOR (15 downto 0);
           BDR      : in STD_LOGIC_VECTOR (15 downto 0);
           PBDR     : in STD_LOGIC_VECTOR (15 downto 0);
           segDDR  : in STD_LOGIC_VECTOR (15 downto 0);
           LDR      : in STD_LOGIC_VECTOR (15 downto 0);
           PLDR     : in STD_LOGIC_VECTOR (15 downto 0);
           SPI_in   : in STD_LOGIC_VECTOR (15 downto 0);
           SPI_out  : in STD_LOGIC_VECTOR (15 downto 0);
           UART_in  : in STD_LOGIC_VECTOR (15 downto 0);
           UART_out : in STD_LOGIC_VECTOR (15 downto 0)
           );
           
end MUX;

architecture Behavioral of MUX is
begin
    with MUX_in select
        MUX_out <=  ram      when "00000",
                    SiSR     when "00001",
                    SiDR     when "00010",
                    SoSR     when "00011",
                    SoDR     when "00100",
                    SwDR     when "00101",
                    PSwDR    when "00110",
                    BDR      when "00111",
                    PBDR     when "01000",
                    segDDR   when "01001",
                    LDR      when "01010",
                    PLDR     when "01011",
                    SPI_in   when "01100",
                    SPI_out  when "01101",
                    UART_in  when "01110",
                    UART_out when "01111",
                    x"FFFF"  when others;
                    --"0000000000000000"  when others;

end Behavioral;
