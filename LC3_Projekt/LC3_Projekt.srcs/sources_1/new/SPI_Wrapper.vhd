Library UNISIM;
use UNISIM.vcomponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SPI_Wrapper is
		port (
			ss_pin : out std_logic;
			mosi_pin : out std_logic;
			miso_pin : in std_logic;
			
			reset : in std_logic;
			rd :	in std_logic;
			Status : out std_logic_vector (15 downto 0) ;
			SEL : in std_logic_vector (3 downto 0);
			CLK : in std_logic;
			SPI_to_mux : out std_logic_vector (15 downto 0)
		);		
end SPI_Wrapper;

architecture behavioral of SPI_Wrapper is
			
			signal REG_DATA	: std_logic;
			signal SAVE			: std_logic;
			signal SPI_DATA : std_logic_vector (9 downto 0);
			signal SPI_OUT : std_logic_vector (9 downto 0);
			signal ready_signal : std_logic;

begin

Status  <= Ready_signal & "000000000000000"; 

		SPI : entity work.SPI
				port map (
					CLK		=> clk,
					SEL			=> SEL,
					SLAVE_SELECT	=> ss_pin,
					MOSI			=> mosi_pin,
					MISO			=> miso_pin,
					rd	      	=> rd, 
					REG_DATA		=> REG_DATA,
					SAVE			=> SAVE,
					reset			=> reset,
					READY			=> Ready_signal
				);
				
		SPI_Data_Logic : entity work.SPI_Data_Logic
				port map (
					DATA_IN		=> REG_DATA,
					CLK			=> CLK,
					DATA_OUT		=> SPI_DATA,
					reset 		=> reset
				);
				
			SPI_to_Mux  <= "000000" & SPI_out;
			
		SPI_Data_Register : entity work.SPI_Data_Register
				port map (
					clk			=> CLK,
					reset			=> reset,
					cs_en			=> SAVE,
					data_in 		=>	SPI_DATA,
					data_out		=> SPI_out
				);

end behavioral;

