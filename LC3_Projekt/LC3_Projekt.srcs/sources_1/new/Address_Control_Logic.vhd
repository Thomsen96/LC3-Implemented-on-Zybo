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
        mem_en  :   out STD_LOGIC;
        ACL_TO_MUX  :   out STD_LOGIC_VECTOR(4 downto 0);
        test        :   out STD_LOGIC;
        cs_sw       :   out  STD_LOGIC;
        cs_SiSR     :   out STD_LOGIC;
        cs_SoSR     :   out STD_LOGIC;
        cs_SoDR     :   out STD_LOGIC;
        cs_segDDR   :   out STD_LOGIC;
        cs_LDR      :   out STD_LOGIC;
        cs_PLED     :   out STD_LOGIC;
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
    process ( addr )
    begin
        cs_sw = '0';
        cs_SiSR = '0';
        cs_SoSR = '0';
        cs_SoDR = '0';
        cs_segDDR = '0';
        cs_LDR  = '0';
        cs_PLED = '0';
        -- TILF�J UART og SPI!! SENERE!!
        
        --Tilf�j if statements der tjekker alle de mulige addresser!
        if( addr = IO_SW) then
            cs_sw = '1';
        end if;
        --- Sp�rgsm�l: Skal resten af addresse spacet
        -- Tilf�j s� n�r man vil access ram skal mem_en s�ttes til 1 lige meget om RE eller We er 1
        -- Hvis Addressen er mellem x0000 og xDFFF skal der kigges i memory, s� dette skal v�re det f�rste if statement
        -- Hvor mem_en s�ttes til 1. I alle andre tilf�lde skal mem_en s�ttes til 0, da der skal tilg�s et I/O register.
        if(RE = '1' ) then 
                mem_en <= '1';
        end if;
        mem_en <= '0';
        test <= '0';
        ACL_TO_MUX <= "00101";
        --if (  addr = x"0001") then
            
        --end if;
    end process;
end Behavioral;
