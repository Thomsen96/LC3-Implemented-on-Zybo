-- This is the component that you'll need to fill in in order to create the LC3 computer.
-- It is FPGA independent. It can be used without any changes between the Zybo and the 
-- Nexys3 boards.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lc3_computer is
   port (
		--System clock
      clk              : in  std_logic; 

      --Virtual I/O
        led              : out std_logic_vector(7 downto 0);
        btn              : in  std_logic_vector(4 downto 0);
        sw               : in  std_logic_vector(7 downto 0);
        hex              : out std_logic_vector(15 downto 0); --16 bit hexadecimal value (shown on 7-seg sisplay)

		--Physical I/0 (IO on the Zybo FPGA)
		pbtn				  : in  std_logic_vector(3 downto 0);
		psw				  : in  std_logic_vector(3 downto 0);
		pled				  : out  std_logic_vector(2 downto 0);

		--VIO serial
		rx_data          : in  std_logic_vector(7 downto 0);
        rx_rd            : out std_logic;
        rx_empty         : in  std_logic;
        tx_data          : out std_logic_vector(7 downto 0);
        tx_wr            : out std_logic;
        tx_full          : in  std_logic;
        
		--UART serial
        pc_rx_data          : in  std_logic_vector(7 downto 0);
        pc_rx_rd            : out std_logic;
        pc_rx_empty         : in  std_logic;
        pc_tx_data          : out std_logic_vector(7 downto 0);
        pc_tx_wr            : out std_logic;
        pc_tx_full          : in  std_logic;		
		
		
		sink             : out std_logic;

    --Debug
      address_dbg      : out std_logic_vector(15 downto 0);
      data_dbg         : out std_logic_vector(15 downto 0);
      RE_dbg           : out std_logic;
      WE_dbg           : out std_logic;
		
		--LC3 CPU inputs
      cpu_clk_enable   : in  std_logic;
      sys_reset        : in  std_logic;
      sys_program      : in  std_logic;
      
      -- SPI signaler
      spi_rd  : out  std_logic;
      spi_s   : in  std_logic_vector(15 downto 0);
      spi_d   : in  std_logic_vector(15 downto 0);
      data_to_spi : out std_logic_vector(2 downto 0)

   );
end lc3_computer;

architecture Behavioral of lc3_computer is
   ---<<<<<<<<<<<<<<>>>>>>>>>>>>>>>---
   ---<<<<< Pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<>>>>>>>>>>>>>>>---

	--Making	sure	that	our	output	signals	are	not	merged/removed	during	
	-- synthesis. We	achieve	this	by	setting	the keep	attribute for	all	our	outputs
	-- It's good to uncomment the following attributs if you get some errors with multiple 
	-- drivers for a signal.
--	attribute	keep:string;
--	attribute	keep	of	led			: signal	is	"true";
--	attribute	keep	of	pled			: signal	is	"true";
--	attribute	keep	of	hex			: signal	is	"true";
--	attribute	keep	of	rx_rd			: signal	is	"true";
--	attribute	keep	of	tx_data		: signal	is	"true";
--	attribute	keep	of	tx_wr			: signal	is	"true";
--	attribute	keep	of	address_dbg	: signal	is	"true";
--	attribute	keep	of	data_dbg		: signal	is	"true";
--	attribute	keep	of	RE_dbg		: signal	is	"true";
--	attribute	keep	of	WE_dbg		: signal	is	"true";
--	attribute	keep	of	sink			: signal	is	"true";


   --Creating user friently names for the buttons
    alias btn_u : std_logic is btn(0); --Button UP
    alias btn_l : std_logic is btn(1); --Button LEFT
    alias btn_d : std_logic is btn(2); --Button DOWN
    alias btn_r : std_logic is btn(3); --Button RIGHT
    alias btn_s : std_logic is btn(4); --Button SELECT (center button)
    alias btn_c : std_logic is btn(4); --Button CENTER
   
    signal sink_sw : std_logic;
    signal sink_psw : std_logic;
    signal sink_btn : std_logic;
    signal sink_pbtn : std_logic;
    signal sink_uart : std_logic;
   
	-- Memory interface signals
	signal address: std_logic_vector(15 downto 0);
	signal data, data_in, data_out: std_logic_vector(15 downto 0); -- data inputs
	signal RE, WE:  std_logic;


--	-- I/O constants for addr from 0xFE00 to 0xFFFF:
--    constant STDIN_S    : std_logic_vector(15 downto 0) := X"FE00";  -- Serial IN (terminal keyboard)
--    constant STDIN_D    : std_logic_vector(15 downto 0) := X"FE02";
--    constant STDOUT_S   : std_logic_vector(15 downto 0) := X"FE04";  -- Serial OUT (terminal  display)
--    constant STDOUT_D   : std_logic_vector(15 downto 0) := X"FE06";
--    constant IO_SW      : std_logic_vector(15 downto 0) := X"FE0A";  -- Switches
--    constant IO_PSW     : std_logic_vector(15 downto 0) := X"FE0B";  -- Physical Switches	
--	  constant IO_BTN     : std_logic_vector(15 downto 0) := X"FE0e";  -- Buttons
-- 	  constant IO_PBTN    : std_logic_vector(15 downto 0) := X"FE0F";  -- Physical Buttons	
--	  constant IO_SSEG    : std_logic_vector(15 downto 0) := X"FE12";  -- 7 segment
--	  constant IO_LED     : std_logic_vector(15 downto 0) := X"FE16";  -- Leds
--	  constant IO_PLED    : std_logic_vector(15 downto 0) := X"FE17";  -- Physical Leds
   
	---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
   ---<<<<< End of pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---

    --<<< Vores kode inds�ttes her!>>>--
        signal MEM_MUX                :  std_logic_vector(15 downto 0);
        signal ACL_MUX                :  std_logic_vector(4 downto 0);
        signal mem_en                 :   std_logic;
        signal Zsw                     :  std_logic_vector(15 downto 0);
        signal Zpsw                     :  std_logic_vector(15 downto 0);
        signal Zbtn                     :  std_logic_vector(15 downto 0);
        signal Zpbtn                     :  std_logic_vector(15 downto 0);
        signal E_KBSR                   : std_logic_vector(15 downto 0); 
      
        
        
        signal STDIN_S_SIGNAL         : std_logic_vector(15 downto 0);   
        signal STDIN_D_SIGNAL          : std_logic_vector(15 downto 0);
       -- signal STDOUT_S_SIGNAL         : std_logic_vector(15 downto 0);  -- Serial OUT (terminal  display)
        signal STDOUT_D_SIGNAL  : std_logic_vector(15 downto 0);
        signal IO_SSEG_SIGNAL   : std_logic_vector(15 downto 0);  -- 7 segment
        signal IO_LED_SIGNAL    : std_logic_vector(15 downto 0);  -- Leds
        signal IO_PLED_SIGNAL   : std_logic_vector(15 downto 0);  -- Physical Leds

        signal cs_STDIN_S    : std_logic;  -- Serial IN (terminal keyboard)
        signal cs_STDIN_D    : std_logic;
        signal cs_STDOUT_S   : std_logic;  -- Serial OUT (terminal  display)
        signal cs_STDOUT_D   : std_logic;
        signal cs_IO_SSEG    : std_logic;  -- 7 segment
        signal cs_IO_LED     : std_logic;  -- Leds
        signal cs_IO_PLED    : std_logic;  -- Physical Leds
        
        -- Signaler til VIO UART
        signal KBSR         : std_logic;
        signal KBDR         : std_logic_vector(15 downto 0);
        signal DSR         : std_logic_vector(15 downto 0);

        signal PC_RX_SR         : std_logic_vector(15 downto 0);
        signal PC_RX_DR         : std_logic_vector(15 downto 0);
--        signal PC_RX_RD         : std_logic;
        
        signal PC_TX_SR         : std_logic_vector(15 downto 0);
        --signal PC_TX_DR         : std_logic_vector(15 downto 0);
--        signal PC_TX_WR         : std_logic;
        
--        signal PC_tx_full       : std_logic;
--        signal PC_rx_empty      : std_logic;
    
        
        
--            attribute	keep	of	STDIN_D_SIGNAL			: signal	is	"true";
	
begin
  ---<<<<<<<<<<<<<<>>>>>>>>>>>>>>>---
   ---<<<<< Pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<>>>>>>>>>>>>>>>--- 
   
  -- udefineret signal vores:
    --STDIN_S_SIGNAL <= x"FFFF";
    --STDIN_D_SIGNAL <= x"FFFF";
    --STDOUT_S_SIGNAL <= x"FFFF";
    --STDOUT_D_SIGNAL <= x"FFFF";
    --IO_SSEG_SIGNAL <= x"FFFF";
    --IO_PLED_SIGNAL <= x"FFFF";
   
   --In order to avoid warnings or errors all outputs should be assigned a value. 
   --The VHDL lines below assign a value to each otput signal. An otput signal can have
   --only one driver, so each otput signal that you plan to use in your own VHDL code
   --should be commented out in the lines below 

   
   --Virtual Leds on Zybo VIO (active high)
--   --led(0) <= '0';
--   --led(1) <= '0';
--   led(2) <= '0'; 
--   led(3) <= '0'; 
--   led(4) <= '0'; 
--   led(5) <= '0'; 
--   led(6) <= '0'; 
--   led(7) <= '0'; 
    led <= IO_LED_SIGNAL(7 downto 0);

   --Physical leds on the Zybo board (active high)
--   pled(0) <= '0';
--   pled(1) <= '0';
--   pled(2) <= '0';
    pled <= IO_PLED_SIGNAL(2 downto 0);

   --Virtual hexadecimal display on Zybo VIO
--   hex <= X"1234"; 
    hex <= IO_SSEG_SIGNAL;
    --hex <= "000" & test_signal2 & "000" & test_signal & KBDR(7 downto 0) ;
   -- Denn linje tester de fysiske switches og knapper samt VIO switches.
   -- hex <= psw(3 downto 0) & pbtn(3 downto 0) & IO_SSEG_SIGNAL(7 downto 0);
   
	--Virtual I/O UART
	--KBSR <= not(rx_empty);
	KBDR <= x"00" & rx_data;
	--tx_wr <= STDOUT_S_SIGNAL(15);
	--tx_data <=  w_data(7 downto 0);
	--rx_rd <= '0';
	--tx_wr <= '0';
	--tx_data <= X"00";
	-- rx_rd <= test_signal;
	-- tx_wr <= test_signal2;
	 
	 
	--Input data for the LC3 CPU
	--data_in <= X"0000";

   --All the input signals comming to the FPGA should be used at least once otherwise we get 
   --synthesis warnings. The following lines of VHDL code are meant to remove those warnings. 
   --Sink is just an output signal that that has the only purpose to allow all the inputs to 
   --be used at least once, by orring them and assigning the resulting the value to sink.
   --You are not suppoosed to modify the following lines of VHDL code, where inputs are orred and
   --assigned to the sink. 
   sink_psw <= psw(0) or psw(1) or psw(2) or psw(3);
   sink_pbtn <= pbtn(0) or pbtn(1) or pbtn(2) or pbtn(3);
   sink_sw <= sw(0) or sw(1) or sw(2) or sw(3) or sw(4) or sw(5) or sw(6) or sw(7); 
   sink_btn <= btn(0) or btn(1) or btn(2) or btn(3) or btn(4);
   sink_uart <= rx_data(0) or rx_data(1) or rx_data(2) or rx_data(3) or rx_data(4) or 
					 rx_data(5) or rx_data(6) or rx_data(7)or rx_empty or tx_full; 
   sink <= sink_sw or sink_psw or sink_btn or sink_pbtn or sink_uart;

   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
   ---<<<<< End of pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
	
	--You'll have to decide which type of data bus you need to use for the
	--  LC3 processor. Here are the options:
	-- 1. Bidirectional data bus (to which you write using tristates).
	-- 2. Two unidirctional busses data_in and data_out where you use
	--    multiplexors to dicide where the data for data_in is comming for.
	--The VHDL code that instantiate either one of these options for the LC3
	--  processor are provided below. Just uncomment the one you prefer
	
	-- <<< LC3 CPU using multiplexers for the data bus>>>	
	lc3_m: entity work.lc3_wrapper_multiplexers
	port map (
		 clk        => clk,
		 clk_enable => cpu_clk_enable,
		 reset      => sys_reset,
		 program    => sys_program,
		 addr       => address,
		 data_in    => data_in,
		 data_out   => data_out,
		 WE         => WE,
		 RE         => RE 
		 );
   data_dbg <= data_in when RE='1' else data_out;

	
	--Information that is sent to the debugging module
   address_dbg <= address;
   RE_dbg <= RE;
   WE_dbg <= WE;
   
	-------------------------------------------------------------------------------
	-- <<< Write your VHDL code starting from here >>>
	-------------------------------------------------------------------------------
lc3_ram: entity work.xilinx_one_port_ram_sync
        port map (
             clk        => clk,
             addr       => address,
             din        => data_out,
             dout       => MEM_MUX,
             we         => WE,
             re         => RE,
             mem_en     => mem_en
         );

    Zsw     <= x"00" & sw;          -- Zero extender sw.
    Zpsw    <= x"000" & psw;
    Zbtn    <= "00000000000" & btn;
    Zpbtn   <= x"000" & pbtn;
    E_KBSR  <= not(rx_empty) & "000000000000000";
    DSR     <= not(tx_full) & "000000000000000";
    tx_data <= data_out(7 downto 0);
    
    -- UART
    PC_RX_DR <= x"00" & pc_rx_data;
    PC_RX_SR <= not(pc_rx_empty) & "000000000000000";
    PC_TX_SR <= not(pc_tx_full) &  "000000000000000";
    pc_tx_data <= data_out(7 downto 0);
    
    -- SPI
    data_to_spi <= data_out(2 downto 0);
    
MemMUX: entity work.MUX
    port map (
               MUX_in   =>  ACL_MUX, -- Select signalet 5-bit
               MUX_out  =>  data_in, -- Output signalet 16-bit
               -- Input til MUXen.
               MEM      =>  MEM_MUX,
               STDIN_S  =>  E_KBSR,
               STDIN_D  =>  KBDR,
               STDOUT_S =>  DSR,
--               STDOUT_D =>  w_data,       
               IO_SW    =>  Zsw,
               IO_PSW   =>  Zpsw,
               IO_BTN   =>  Zbtn,
               IO_PBTN  =>  Zpbtn,
               IO_SSEG  =>  IO_SSEG_SIGNAL,
               IO_LED   =>  IO_LED_SIGNAL,
               IO_PLED  =>  IO_PLED_SIGNAL,
               SPI_S   =>  spi_s,
               SPI_D  =>  spi_d,
               UART_RX_D  =>  PC_RX_DR,
               UART_RX_S  =>  PC_RX_SR,
               UART_TX_S =>  PC_TX_SR
               
               );

    Address_Control_Logic: entity work.ACL
        port map (
              addr          => address,
              RE            => RE,
              WE            => WE,
              mem_en        => mem_en,
              ACL_MUX       => ACL_MUX,
              cs_IO_SSEG    => cs_IO_SSEG,
              cs_IO_LED     => cs_IO_LED,
              cs_IO_PLED    => cs_IO_PLED,
              rx_rd         => rx_rd,
              tx_wr         =>  tx_wr,
              pc_rx_rd      => pc_rx_rd,
              pc_tx_wr      =>  pc_tx_wr,
              spi_rd        => spi_rd            
        );
    
    
    -- LED REGISTER:
    IO_LED_Register : entity work.IO_Register
        port map (
            clk     => clk,
            reset   => sys_reset,
            cs_en   => cs_IO_LED,
            data_in => data_out,
            data_out=> IO_LED_SIGNAL
        );
    -- PLED REGISTER:
    IO_PLED_Register : entity work.IO_Register
        port map (
            clk     => clk,
            reset   => sys_reset,
            cs_en   => cs_IO_PLED,
            data_in => data_out,
            data_out=> IO_PLED_SIGNAL
        );
    -- SSEG REGISTER:
    IO_SSEG_Register : entity work.IO_Register
            port map (
                clk     => clk,
                reset   => sys_reset,
                cs_en   => cs_IO_SSEG,
                data_in => data_out,
                data_out=> IO_SSEG_SIGNAL
            );


end Behavioral;