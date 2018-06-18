Library UNISIM;
use UNISIM.vcomponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SPI_Wrapper is
    port (
        -- Til of fra LC3
        clk         : in std_logic;
        sys_reset   : in std_logic;
        rd          : in std_logic;
        SEL         : in std_logic_vector (2 downto 0);
        Status      : out std_logic_vector (15 downto 0);
        SPI_to_mux  : out std_logic_vector (15 downto 0);
        
        -- Til og fra SPI enheder
        spi_clk     : out std_logic;        -- clk
        ss_pin      : out std_logic;        -- cs
        mosi_pin    : out std_logic;        -- Master out
        miso_pin    : in std_logic          -- Master in
    );		
end SPI_Wrapper;

architecture behavioral of SPI_Wrapper is

    -- singlaer til klokken
    signal tick_rise    : std_logic;
    signal tick_fall    : std_logic;
    -- signaler fra SPI til data register
    --signal data_reg	    : std_logic_vector (9 downto 0);
    --signal data_en		: std_logic;
    
    -- Signaler fra data reg til LC3.
    signal data_mux      : std_logic_vector (9 downto 0);
    signal status_signal : std_logic;
    
    

begin
   -- spi_clk <= tick_fall;   -- Klokken der går til ADC.
    -- Konstante forbindelser.
    Status  <= status_signal & "000000000000000"; 
    SPI_to_Mux  <= "000000" & data_mux;
    

    slow_clk : entity work.slow_clk
        port map (
            clk         => clk,
            reset       => sys_reset,
            tick_fall   => tick_fall,
            tick_rise   => tick_rise
        );
    
    
    SPI : entity work.SPI
        port map (
            clk         => clk,
            sys_reset   => sys_reset,
            rd          => rd,
            SEL         => SEL,
            status      => status_signal,
            
            -- Fra Slow clk
            tick_fall   => tick_fall,
            tick_rise   => tick_rise,
            -- Til og fra ADC     
            spi_clk     => spi_clk,   
            cs          => ss_pin,
            MOSI        => mosi_pin,
            MISO        => miso_pin,
            
            -- Til Data register
            data_out        => data_mux
            --data_en     => data_en
        );
           
--    SPI_Data_Register : entity work.SPI_Data_Register
--        port map (
--            clk			=> clk,
--            sys_reset	=> sys_reset,
--            data_en		=> data_en,
--            data_in 	=> data_reg,
--            data_out	=> data_mux
    
--    SPI_Data_Logic : entity work.SPI_Data_Logic
--        port map (
--            DATA_IN		=> REG_DATA,
--            clk			=> clk,
--            DATA_OUT	=> SPI_DATA,
--            reset 		=> sys_reset
--        );    
        

end behavioral;