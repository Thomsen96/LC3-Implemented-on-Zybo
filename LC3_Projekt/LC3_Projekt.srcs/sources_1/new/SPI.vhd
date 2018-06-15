library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SPI is
    Port ( 
        -- Til og fra LC3
        clk         : in std_logic;
        sys_reset   : in std_logic;
        rd          : in std_logic;
        SEL         : in std_logic_vector(2 downto 0);
        status      : out std_logic;
        
        -- Fra Slow clk
        tick_fall   : in std_logic;
        tick_rise   : in std_logic;
        
        -- Til og fra ADC        
        cs          : out std_logic;
        MOSI        : out std_logic;
        MISO        : in  std_logic;
        spi_clk     : out std_logic;
        
        -- Til Data register
        data_out    : out std_logic_vector(9 downto 0);
        data_en     : out std_logic
        
    );
end SPI;

architecture Behavioral of SPI is
	TYPE State_type IS (init, start, waiting, rising, falling);
    signal state : State_type;
    signal count_signal : std_logic;
    signal count_reset  : std_logic;
    signal count_max    : std_logic;
--    signal shift_en     : std_logic;
    Begin
    spi_clk <= count_signal;
		Process(tick_rise, tick_fall, sys_reset, clk)
		Begin
            if (sys_reset = '1') then                                       -- Reset signal
                --data_out <= "0000000000";
                data_en <= '0';
                --MOSI <= '0';
                status <= '1';
                state <= init;
                
            elsif( rising_edge(clk) ) then    -- Rise og fall clk
                case state is
                    when init =>
                        count_reset <= '1';
                        status <= '1';
                        cs <= '1';
                        data_en <= '0';
--                        shift_en <= '0';
                        if (rd = '1') then
                            state <= start;		
                        end if;
                    When start =>
                        count_reset <= '0';
                        cs <= '0';
                        status <= '0';
--                        shift_en <= '1';
                        state <= waiting;
                    WHEN waiting =>                     -- Vi kommer til først at gå til falling.
                        --count_signal <= '0';
                        if (tick_fall = '1') then
                            state <= falling;
                        elsif (tick_rise = '1') then
                            state <= rising;    
                        end if;
                    WHEN falling =>
                        count_signal <= '0';
                        if( count_max = '1') then
                            state <= init;
                            data_en <= '1';
                        else
--                            shift_en <= '1';
                            state <= waiting;
                        end if;
                    When rising =>
                        count_signal <= '1';
                        --count_signal <= '1';
                        state <= waiting;
                end case;
            end if;		

		end process;

    SPI_Data_Logic : entity work.SPI_Data_Logic
        port map (
            tick_rise	=> tick_rise,
            tick_fall	=> tick_fall,
            miso        => MISO,
            mosi        => MOSI,
            rd          => rd,
            sel         => SEL,
            DATA_OUT	=> data_out,
            reset 		=> sys_reset
        ); 
    
    counter : entity work.vores_counter
        generic map(
            N => 5,
            m => 17
            )
        port map(
            count       => count_signal,
            reset       => count_reset,
            max_tick    => count_max,
            q           => open
        );     
end Behavioral;

