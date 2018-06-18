-- Listing 4.8
library ieee;
use ieee.std_logic_1164.all;
entity univ_shift_reg is
   generic(N: integer);
   port(
      tick_rise : in std_logic;
      tick_fall : in std_logic; 
      reset : in std_logic;
      data_in : in std_logic_vector(N-1 downto 0);
      data_out : out std_logic_vector(9 downto 0);
      miso : in std_logic;
      mosi : out std_logic;
      rd : in std_logic;
      shift_en: in std_logic
   );
end univ_shift_reg;

architecture arch of univ_shift_reg is
   signal r_reg: std_logic_vector(N-1 downto 0);
   signal r_next: std_logic_vector(N-1 downto 0);
begin
   -- register
   process(tick_rise, tick_fall, reset)
   begin
  --       r_reg <= (others=>'0');
      if (reset='1') then
         r_reg <= (others=>'0');
      elsif (tick_fall = '1') then
         r_reg(n-1 downto 1) <= r_next(n-1 downto 1);
         r_reg(0) <= r_reg(0);
      elsif (tick_rise = '1') then
         r_reg(0) <= r_next(0);  
         r_reg(n-1 downto 1) <= r_reg(n-1 downto 1);
      end if;
   end process;
   
   -- next-state logic
   process (shift_en, rd, miso, r_reg, data_in)
   begin
        --r_next(n-1 downto 1) <= r_reg(n-1 downto 1);
        --r_next(0) <= r_reg(0);
        if (shift_en = '1') then
            r_next(n-1 downto 1) <= r_reg(N-2 downto 0); 
            r_next(0)<= miso;
        elsif (rd = '1') then
            r_next(n-1 downto 1) <= data_in(n-1 downto 1);
            r_next(0) <= data_in(0);
        end if;
    end process;
   -- output
   data_out <= r_reg(9 downto 0);
   mosi <= r_reg(16);
end arch;