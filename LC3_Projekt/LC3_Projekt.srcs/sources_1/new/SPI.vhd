library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SPI is
    Port ( 
        tick_rise : in std_logic;
        tick_fall : in std_logic;
        SEL : in  STD_LOGIC_VECTOR (3 downto 0);
        rd : in  STD_LOGIC;
        SLAVE_SELECT : out  STD_LOGIC;
        MOSI : out  STD_LOGIC;
        MISO : in  STD_LOGIC;
        REG_DATA : out  STD_LOGIC;
        READY : out  STD_LOGIC;
        SAVE: out STD_LOGIC;
        reset: in STD_LOGIC
    );
end SPI;

architecture Behavioral of SPI is
	TYPE State_type IS (init, start, waiting, rising, falling);
    signal state : State_type;
    Begin
		Process(tick_rise, tick_fall, reset)
		Begin
            if (reset = '1') then
                REG_DATA <= '0';
                SAVE <= '0';
                MOSI <= '0';
                READY <= '1';
            elsif(rising_edge(tick_rise) or rising_edge(tick_fall)) then
                CASE state IS
                    When init =>
                        if (rd = '1') then
                            state <= start;		
                        end if;
                    When start =>
                        state <= waiting;
                        shift_en <= '1';
                        load <= '1';
                    WHEN waiting =>
                        if (tick_rise = '1') then
                            state <= rising;
                        elsif (tick_fall = '1') then
                            state <= falling;
                        endif
                    When rising =>
                        counter + 1;
                        tick_rise
                    WHEN falling =>
                        shift_en <= '1';
                        SLCK     <= clear;
                end case;
            else
                state <= Waiting;
                SLAVE_SELECT <= '0';
                READY <= '1';		
            end if;		

		end process;

end Behavioral;

