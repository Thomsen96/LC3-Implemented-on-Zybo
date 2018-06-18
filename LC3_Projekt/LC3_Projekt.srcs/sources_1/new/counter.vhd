library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vores_counter is
   generic(
      N: integer;       -- antal bits der skal repræsentere det tal man skal tælle til.
      M: integer        -- Tal man tæller til
  );
   port(
      count     : in std_logic;
      reset     : in std_logic;
      max_tick: out std_logic;
      q: out std_logic_vector(N-1 downto 0)
   );
end vores_counter;

architecture arch of vores_counter is
   signal r_reg: unsigned(N-1 downto 0);
   signal r_next: unsigned(N-1 downto 0);
begin
-- register
   process(count ,reset)
   begin
      if (reset='1') then
         r_reg <= (others=>'0');
      elsif (count'event and count='1') then
         r_reg <= r_next;
      end if;
   end process;
   -- next-state logic
   r_next <= (others=>'0') when r_reg=(M-1) else
             r_reg + 1;
   -- output logic
   q <= std_logic_vector(r_reg);
   max_tick <= '1' when unsigned(r_reg)=(M-1) else '0';
end arch;