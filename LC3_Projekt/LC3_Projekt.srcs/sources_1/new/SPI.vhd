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
	TYPE State_type IS (init, start, wait1, rising, falling);
    signal state : State_type;
    Begin
		Process(tick_rise, tick_fall, reset)
		Begin
			if (reset = '1') then
				REG_DATA <= '0';
                SAVE <= '0';
                MOSI <= '0';
                READY <= '1';
            elsif(rising_edge(tick_rise, tick_fall)) then
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

end Behavioral;

