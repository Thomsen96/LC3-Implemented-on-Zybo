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
        tick_reset  : out std_logic;
        
        -- Til og fra ADC        
        cs          : out std_logic;
        MOSI        : out std_logic;
        MISO        : in  std_logic;
        spi_clk     : out std_logic;
        
        -- Til Data register
        data_out    : out std_logic_vector(15 downto 0)
--        data_en     : out std_logic
        
    );
end SPI;

architecture Behavioral of SPI is
	TYPE State_type IS (init, start, waiting, rising, falling);
    signal state : State_type;
    signal next_state : State_type;
    signal count_signal : std_logic;
    signal count_reset  : std_logic;
    signal count_max    : std_logic;
--    signal shift_en     : std_logic;
    signal shift_in     : std_logic_vector(16 downto 0);
    signal shift_out    : std_logic_vector(16 downto 0);
    signal shift_ctrl   : std_logic_vector(1 downto 0);
   -- signal data_in      : std_logic_vector(15 downto 0);
    --signal data_out_signal  : std_logic_vector(9 downto 0);
    
    signal clk_reg_en   : std_logic;
    
    
    Begin
--    spi_clk <= count_signal;

    Process(sys_reset, clk)     -- Register
    Begin
        if (sys_reset = '1') then                                       -- Reset signal
            state <= init;
        elsif( rising_edge(clk) ) then    -- Rise og fall clk
            state <= next_state;
        end if;		
    end process;
    
                                            --next state
    next_state_logic : process (rd, state, tick_fall, tick_rise, count_max)
    begin
        next_state <= state;
        case state is
            when init =>
                if (rd = '1') then
                    next_state <= start;		
                end if;
            When start =>
                next_state <= waiting;
            WHEN waiting =>                    
                if (tick_fall = '1') then
                    next_state <= falling;
                elsif (tick_rise = '1') then
                    next_state <= rising;    
                end if;
            WHEN falling =>
                if( count_max = '1') then
                    next_state <= init;
                else
                    next_state <= waiting;
                end if;
            When rising =>
                next_state <= waiting;
        end case;
    end process;
		
		                                                  --output logic.
    output_logic : process ( state )      
    begin
        cs              <= '0';
        status          <= '0';
        tick_reset      <= '0';
        count_reset     <= '0';
        count_signal    <= '0';
        shift_ctrl      <= "00";
        clk_reg_en      <= '1';
--      shift_en        <= '0';
        case state is
            when init =>
                status <= '1';
                tick_reset <= '1';
                count_reset <= '1';
                cs <= '1';
            When start =>
                shift_ctrl <= "11";         -- 
 --             shift_en <= '1';
            WHEN waiting =>
                clk_reg_en <= '0';            
            WHEN falling =>
                shift_ctrl <= "01";         -- Signal til at skrifte en gang til venstre.
            When rising =>
                count_signal <= '1';
        end case;	
    end process;
    
    clock_flop : entity work.d_ff
        port map(
            clk         => clk,
            reset       => sys_reset,
            en          => clk_reg_en,
            data_in     => count_signal,
            data_out    => spi_clk
        );
    
    shift_in <= "11" & SEL &  "00000000000" & miso;
    mosi    <= shift_out(16);
--    mosi    <= '1';
    data_out <= shift_out(15 downto 0);
    
    Shift_reg_u : entity work.shift_universal
        generic map (N => 17)
        port map(
            clk     => clk,
            reset   => sys_reset,
            ctrl    => shift_ctrl,
            d       => shift_in,
            q       => shift_out
        );
--    data_in <= "00000000000000" & SEL;
--    SPI_Data_Logic : entity work.univ_shift_reg
--        generic map( n => 17)
--        port map (
--            tick_rise => tick_rise,
--            tick_fall => tick_fall,
--            reset => sys_reset,
--            data_in => data_in,
--            data_out => data_out,
--            miso => miso,
--            mosi    => mosi,
--            rd => rd,
--            shift_en => shift_en
--        ); 
    
    counter : entity work.vores_counter
        generic map(
            N => 5,             -- Antal bits der skal bruges til at tælle til tallet.
            m => 18             -- Giver m-1 cycler
        )
        port map(
            count       => count_signal,
            reset       => count_reset,
            max_tick    => count_max,
            q           => open
        );     
end Behavioral;

