library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
--use UNISIM.VComponents.all;

entity ACL is
    Port ( 
        addr            :   in  STD_LOGIC_VECTOR(15 downto 0);
        RE              :   in  STD_LOGIC;
        WE              :   in  STD_LOGIC;
        ACL_MUX         :   out STD_LOGIC_VECTOR(4 downto 0);
        mem_en          :   out STD_LOGIC;
        cs_IO_SSEG      :   out STD_LOGIC;
        cs_IO_LED       :   out STD_LOGIC;
        cs_IO_PLED      :   out STD_LOGIC;
        rx_rd           :   out STD_LOGIC;
        tx_wr           :   out STD_LOGIC;
        pc_rx_rd        :   out STD_LOGIC;
        pc_tx_wr        :   out STD_LOGIC;
        spi_rd          : out std_logic       
    );
end ACL;

architecture Behavioral of ACL is
	-- I/O constants for addr from 0xFE00 to 0xFFFF:
    constant STDIN_S    : std_logic_vector(15 downto 0) := X"FE00";  -- Serial IN (terminal keyboard)
    constant STDIN_D    : std_logic_vector(15 downto 0) := X"FE02";
    constant STDOUT_S   : std_logic_vector(15 downto 0) := X"FE04";  -- Serial OUT (terminal  display)
    constant STDOUT_D   : std_logic_vector(15 downto 0) := X"FE06";
    constant IO_SW      : std_logic_vector(15 downto 0) := X"FE0A";  -- Switches
    constant IO_PSW     : std_logic_vector(15 downto 0) := X"FE0B";  -- Physical Switches	
	constant IO_BTN     : std_logic_vector(15 downto 0) := X"FE0e";  -- Buttons
 	constant IO_PBTN    : std_logic_vector(15 downto 0) := X"FE0F";  -- Physical Buttons	
	constant IO_SSEG    : std_logic_vector(15 downto 0) := X"FE12";  -- 7 segment
	constant IO_LED     : std_logic_vector(15 downto 0) := X"FE16";  -- Leds
	constant IO_PLED    : std_logic_vector(15 downto 0) := X"FE17";  -- Physical Leds
	
	-- Vores IO konstanter
	constant IO_UART_RX_S    : std_logic_vector(15 downto 0) := X"FE18";  -- UART IN status register
	constant IO_UART_RX_D    : std_logic_vector(15 downto 0) := X"FE19";  -- UART IN data register
    constant IO_UART_TX_S    : std_logic_vector(15 downto 0) := X"FE1A";  -- UART OUT status register
    constant IO_UART_TX_D    : std_logic_vector(15 downto 0) := X"FE1B";  -- UART OUT data register
    
    constant IO_SPI_RX_D    : std_logic_vector(15 downto 0) := X"FE1C";  -- SPI - Sende Register
    constant IO_SPI_TX_D    : std_logic_vector(15 downto 0) := X"FE1D";  -- SPI - Modtage Register.
        
    begin
    process ( addr, WE, RE )
    begin
        ACL_MUX     <= "00000";
        cs_IO_SSEG  <= '0';
        cs_IO_LED   <= '0';
        cs_IO_PLED  <= '0';
        
        mem_en      <= '0';

        -- Vores UART
        pc_rx_rd       <= '0';
        pc_tx_wr       <= '0';
        
        -- VIO UART
        rx_rd       <= '0';
        tx_wr       <= '0';
        
        -- Vores SPI
        spi_rd      <= '0';
        --Tilføj if statements der tjekker alle de mulige addresser!
        if( addr = STDIN_S ) then       -- STD IN Status
            ACL_MUX     <= "00001";
        elsif( addr = STDIN_D) then     -- STD IN Data
            if (RE = '1') then
                rx_rd       <= '1';
            end if;
            ACL_MUX     <= "00010";
        elsif( addr = STDOUT_S) then    -- STD OUT Status
            ACL_MUX     <= "00011";
        elsif( addr = STDOUT_D) then
            tx_wr <= '1';
            ACL_MUX     <= "00100";
        elsif( addr = IO_SW) then
            ACL_MUX     <= "00101";
        elsif (addr = IO_PSW) then
            ACL_MUX     <= "00110";
        elsif( addr = IO_BTN) then
            ACL_MUX     <= "00111";
        elsif( addr = IO_PBTN) then
            ACL_MUX     <= "01000";                   
        elsif( addr = IO_SSEG) then
            if( WE = '1') then
                cs_IO_SSEG <= '1';
            end if;
            ACL_MUX     <= "01001";    
        elsif( addr = IO_LED) then
            if( WE = '1') then
                cs_IO_LED <= '1';
            end if;
            ACL_MUX     <= "01010";
        elsif( addr = IO_PLED) then
            if( WE = '1') then
                cs_IO_PLED <= '1';
            end if;
            ACL_MUX     <= "01011";
        elsif(addr = IO_UART_RX_S) then
            ACL_MUX     <= "01100";
        elsif(addr = IO_UART_RX_D) then
             if (RE = '1') then
                pc_rx_rd <= '1';
             end if;
             ACL_MUX     <= "01101";
        elsif(addr = IO_UART_TX_S) then
            ACL_MUX     <= "01111";
        elsif(addr = IO_UART_TX_D) then
            pc_tx_wr <= '1';
        --    ACL_MUX     <= "01110"; -- Da vi ikke skal læse på det vi skriver
        elsif(addr = IO_SPI_RX_D) then
            if ( WE = '1') then
                spi_rd <= '1';
            end if;
            ACL_MUX     <= "10000";
        elsif(addr = IO_SPI_TX_D) then
                ACL_MUX     <= "10001";
        else
            mem_en <= '1';
            ACL_MUX     <= "00000";
        end if;
    end process;
end Behavioral;
