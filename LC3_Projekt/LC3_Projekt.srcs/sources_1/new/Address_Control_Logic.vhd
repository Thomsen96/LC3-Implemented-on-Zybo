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
--        cs_STDIN_S      :   out STD_LOGIC;
--        cs_STDIN_D      :   out STD_LOGIC;
--        cs_STDOUT_S     :   out STD_LOGIC;
--        cs_STDOUT_D     :   out STD_LOGIC;
        cs_IO_SSEG      :   out STD_LOGIC;
        cs_IO_LED       :   out STD_LOGIC;
        cs_IO_PLED      :   out STD_LOGIC;
        rx_rd           :   out STD_LOGIC;
        tx_wr           :   out STD_LOGIC
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

    begin
    process ( addr, WE, RE )
    begin
--        cs_STDIN_S  <= '0';
--        cs_STDIN_D  <= '0';
--        cs_STDOUT_S <= '0';
--        cs_STDOUT_D <= '0';
        cs_IO_SSEG  <= '0';
        cs_IO_LED   <= '0';
        cs_IO_PLED  <= '0';
        
        mem_en      <= '0';
        -- TILFØJ UART og SPI!! SENERE!!
        -- UART
        rx_rd       <= '0';
        tx_wr       <= '0';
        
        --Tilføj if statements der tjekker alle de mulige addresser!
        if( addr = STDIN_S ) then       -- STD IN Status
            if( WE = '1') then
--                cs_STDIN_S  <= '1';
            end if;
            ACL_MUX     <= "00001";
            
        elsif( addr = STDIN_D) then     -- STD IN Data
            if (RE = '1') then
                rx_rd       <= '1';
            end if;
            ACL_MUX     <= "00010";
            
        elsif( addr = STDOUT_S) then    -- STD OUT Status
            if( WE = '1') then
--                cs_STDOUT_S <= '1';
            end if;
            ACL_MUX     <= "00011";
        elsif( addr = STDOUT_D) then
--            if( WE = '1') then
--                cs_STDOUT_D <= '1';
                  tx_wr <= '1';
--            end if;
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
        -- MANGLER FOR SPI og UART, både ind og ud.
        else
            mem_en <= '1';
            ACL_MUX     <= "00000";
        end if;
        --- Spørgsmål: Skal resten af addresse spacet
        -- Tilføj så når man vil access ram skal mem_en sættes til 1 lige meget om RE eller We er 1
        -- Hvis Addressen er mellem x0000 og xDFFF skal der kigges i memory, så dette skal være det første if statement
        -- Hvor mem_en sættes til 1. I alle andre tilfælde skal mem_en sættes til 0, da der skal tilgås et I/O register.
--        if(RE = '1' ) then 
--                mem_en <= '1';
--        end if;
--        mem_en <= '0';
--        ACL_MUX<= "00101";
--        --if (  addr = x"0001") then
            
--        --end if;
    end process;
end Behavioral;
