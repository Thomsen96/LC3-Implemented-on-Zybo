Library UNISIM;
use UNISIM.vcomponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity slow_clk is
    generic ( 
    DVSR : integer := 1000;     -- baud rate divisor DVSR = 50M/( 16 * baud rate) 
    DVSR_BIT : integer:= 10    -- # bits of DVSR 
    ); 
    Port (  
            clk         : in std_logic;
            reset       : in std_logic;
            tick_fall   : out std_logic;
            tick_rise   : out std_logic
          );
end slow_clk;

architecture Behavioral of slow_clk is
    TYPE State_type IS (wait1, falling, wait2, rising);
    signal tick_state       : State_type;
    signal tick_signal      : std_logic;


begin
    baud_gen_unit: entity work.vores_mod_m_counter(arch) 
        generic map(
            M => DVSR, 
            N => DVSR_BIT)
        port map ( 
            clk      => clk,
            reset    => reset, 
            q        => open,
            max_tick => tick_signal
        ); 
    -- Slow clock(ticks)
    process (tick_signal, reset) 
    begin
        if (reset = '1') then
            tick_state <= wait1;
        elsif (rising_edge(tick_signal)) then
            case tick_state IS
                when Wait1 =>
                    tick_rise <= '0';
                    tick_fall <= '0';
                    if (tick_signal = '1') then 
                        tick_state <= falling;
                    end if;
                when falling =>
                    tick_fall <= '1';
                    tick_state <= wait2;
                when wait2 =>
                    tick_rise <= '0';
                    tick_fall <= '0';
                    if (tick_signal = '1') then 
                        tick_state <= rising; 
                    end if;
                when rising =>
                    tick_rise <= '1';
                    tick_state <= wait1;
            end case;
        end if;
    end process;    
end Behavioral;


