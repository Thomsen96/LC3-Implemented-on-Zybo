library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX is
    Port ( 
            -- Selctor og output
            MUX_in : in STD_LOGIC_VECTOR (4 downto 0);
            MUX_out : out STD_LOGIC_VECTOR (15 downto 0);
            -- Input til MUXen.
            MEM      : in STD_LOGIC_VECTOR (15 downto 0);
            STDIN_S    : in STD_LOGIC_VECTOR (15 downto 0);
            STDIN_D     : in STD_LOGIC_VECTOR (15 downto 0);
            STDOUT_S     : in STD_LOGIC_VECTOR (15 downto 0);
            IO_SW     : in STD_LOGIC_VECTOR (15 downto 0);
            IO_PSW    : in STD_LOGIC_VECTOR (15 downto 0);
            IO_BTN      : in STD_LOGIC_VECTOR (15 downto 0);
            IO_PBTN     : in STD_LOGIC_VECTOR (15 downto 0);
            IO_SSEG  : in STD_LOGIC_VECTOR (15 downto 0);
            IO_LED      : in STD_LOGIC_VECTOR (15 downto 0);
            IO_PLED     : in STD_LOGIC_VECTOR (15 downto 0);
            SPI_S   : in STD_LOGIC_VECTOR (15 downto 0);
            SPI_D  : in STD_LOGIC_VECTOR (15 downto 0);
            UART_RX_D  : in STD_LOGIC_VECTOR (15 downto 0);
            UART_RX_S    : in STD_LOGIC_VECTOR (15 downto 0);
            UART_TX_S : in STD_LOGIC_VECTOR (15 downto 0)

           );
           
end MUX;

architecture Behavioral of MUX is
begin
    with MUX_in select
        MUX_out <=  MEM      when "00000",
                    STDIN_S     when "00001",
                    STDIN_D     when "00010",
                    STDOUT_S     when "00011",
--                    STDOUT_D    when "00100",
                    IO_SW     when "00101",
                    IO_PSW    when "00110",
                    IO_BTN      when "00111",
                    IO_PBTN     when "01000",
                    IO_SSEG   when "01001",
                    IO_LED      when "01010",
                    IO_PLED     when "01011",
                    UART_RX_S  when "01100",
                    UART_RX_D  when "01101",
                    --UART_TX_D when  "01110",
                    UART_TX_S when  "01111",
                    SPI_S   when   "10000",
                    SPI_D  when   "10001",
                    
                    x"FFFF"  when others;
end Behavioral;
