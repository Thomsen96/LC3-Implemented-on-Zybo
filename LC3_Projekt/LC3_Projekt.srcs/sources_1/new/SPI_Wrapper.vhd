Library UNISIM;
use UNISIM.vcomponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SPI_Wrapper is
    generic ( 
        DVSR : integer := 1000;     -- baud rate divisor DVSR = 50M/( 16 * baud rate) 
        DVSR_BIT : integer:= 10    -- # bits of DVSR 
    ); 
    port (
        clk : in std_logic;
        spi_clk   : out std_logic;
        
        ss_pin : out std_logic;
        mosi_pin : out std_logic;
        miso_pin : in std_logic;
        
        reset : in std_logic;
        rd :	in std_logic;
        Status : out std_logic_vector (15 downto 0) ;
        SEL : in std_logic_vector (2 downto 0);
        SPI_to_mux : out std_logic_vector (15 downto 0)
    );		
end SPI_Wrapper;

architecture behavioral of SPI_Wrapper is
    TYPE State_type IS (wait1, falling, wait2, rising);
    signal tick_state : State_type;
    
    signal REG_DATA	: std_logic;
    signal SAVE			: std_logic;
    signal SPI_DATA : std_logic_vector (9 downto 0);
    signal SPI_OUT : std_logic_vector (9 downto 0);
    signal ready_signal : std_logic;
    signal tick :std_logic;
    signal spi_in_clk : std_logic;
    

begin
    -- Konstante forbindelser.
    Status  <= Ready_signal & "000000000000000"; 
    SPI_to_Mux  <= "000000" & SPI_out;
    
    SPI : entity work.SPI
        port map (
            tick_rise       => spi_in_clk,
            tick_fall       => spi_clk,
            SEL			    => SEL,
            SLAVE_SELECT    => ss_pin,
            MOSI			=> mosi_pin,
            MISO			=> miso_pin,
            rd	      	    => rd, 
            REG_DATA		=> REG_DATA,
            SAVE			=> SAVE,
            reset			=> reset,
            READY			=> Ready_signal
        );
    
    SPI_Data_Logic : entity work.SPI_Data_Logic
        port map (
            DATA_IN		=> REG_DATA,
            clk			=> clk,
            DATA_OUT		=> SPI_DATA,
            reset 		=> reset
        );
    
    SPI_to_Mux  <= "000000" & SPI_out;
    
    SPI_Data_Register : entity work.SPI_Data_Register
    port map (
    clk			=> clk,
    reset			=> reset,
    cs_en			=> SAVE,
    data_in 		=>	SPI_DATA,
    data_out		=> SPI_out
    );
    
    baud_gen_unit: entity work.mod_m_counter(arch) 
        generic map(
            M => DVSR, 
            N => DVSR_BIT)
        port map ( 
            clk      => clk,
            reset    => reset, 
            q        => open,
            max_tick => tick
        ); 
    process (tick, reset) 
    begin
        if (reset = '1') then
            tick_state <= wait1;
        elsif (rising_edge(tick)) then
            case tick_state IS
                when Wait1 =>
                    spi_clk <= '0';
                    spi_in_clk <= '0';
                    if (tick = '1') then 
                        tick_state <= falling;
                    end if;
                when falling =>
                    spi_clk <= '1';
                    tick_state <= wait2;
                when wait2 =>
                    spi_clk <= '0';
                    spi_in_clk <= '0';
                    if (tick = '1') then 
                        tick_state <= rising; 
                    end if;
                when rising =>
                    spi_in_clk <= '1';
                    tick_state <= wait1;
            end case;
        else
            tick_state <= wait1;
        end if;
                
            
        
    end process;
end behavioral;

if (reset = '1') then
					REG_DATA <= '0';
					SAVE <= '0';
					MOSI <= '0';
					READY <= '1';
				elsif(rising_edge(clk)) then
					if (RD='1') then
						CASE state IS
							When Waiting =>
								state <= SiDi;				-- Single eller Differential
								SLAVE_SELECT <= '1';
								READY <= '0';
							When SiDi =>
								state <= D2;
								MOSI	<= SEL(3);
							WHEN D2 =>
								state <= D1;
								MOSI	<= SEL(2);
							When D1 =>
								state <= D0;
								MOSI	<= SEL(1);
							WHEN D0 =>
								state <= Sc0;
								MOSI	<= SEL(0);
							WHEN Sc0 =>
								state <= Sc1;
								REG_Data <= MISO;
							WHEN Sc1 =>
								state <= Sc2;
							WHEN Sc2 =>
								state <= Sc3;
							WHEN Sc3 =>
								state <= Sc4;
							WHEN Sc4 =>
								state <= Sc5;
							WHEN Sc5 =>
								state <= Sc6;
							WHEN Sc6 =>
								state <= Sc7;
							WHEN Sc7 =>
								state <= Sc8;
							WHEN Sc8 =>
								state <= Sc9;	
								Save <= '1';
							WHEN Sc9 =>
								state <= HALT;
								SAVE  <= '0';
								Slave_select <= '0';
							WHEN HALT =>
								Ready <= '0';
						end case;
					else
						state <= Waiting;
						SLAVE_SELECT <= '0';
						READY <= '1';		
					end if;		
				end if;

		end process;