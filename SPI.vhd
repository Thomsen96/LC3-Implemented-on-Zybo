library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SPI is
    Port ( CLK_IN : in  STD_LOGIC;
           CLK_OUT : out  STD_LOGIC;
           SEL : in  STD_LOGIC_VECTOR (3 downto 0);
           RD : in  STD_LOGIC;
           SLAVE_SELECT : out  STD_LOGIC;
           MOSI : out  STD_LOGIC;
           MISO : in  STD_LOGIC;
           REG_SELECT : out  STD_LOGIC_VECTOR (2 downto 0);
           REG_DATA : out  STD_LOGIC;
           READY : out  STD_LOGIC;
			  SAVE: out STD_LOGIC
			  );
end SPI;

architecture Behavioral of SPI is
	TYPE State_type IS (Waiting, SiDi, D2, D1, D0, Sc0, Sc1, Sc2, Sc3, Sc4, Sc5, Sc6, Sc7, Sc8, Sc9, Dcare);
		SIGNAL state : State_type;
		
		Begin
		CLK_OUT 			<= CLK_IN;
		SLAVE_SELECT 	<= RD;
			Process(clk)
			Begin
				if(RD='1') then
					READY				<= '1';
					SLAVE_SELECT 	<= '1';
					if (rising_edge(clk)) then
						CASE start IS
							When Waiting =>
								state <= SiDi;
								SLAVE_SELECT <= '1';
								REG_SELECT <= SEL;
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
								Save <= '1';
								Data <= MISO;
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
							WHEN Sc9 =>
								state <= Dcare;	
							WHEN Sc9 =>
								state <= Dcare;
								SAVE  <= '0';
						end case;
					end if;		
				else
						state <= Waiting;
						SLAVE_SELECT <= '0';
						READY <= '1';		
				end if;

		end process;

end Behavioral;

