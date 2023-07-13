LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS   
	PORT
	(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	
--	sm_clk_en                 : out std_logic;
--	blink_signal              : out std_logic;
--	NSA_sim                   : out std_logic;
--	NSD_sim                   : out std_logic;
--	NSG_sim                   : out std_logic;
--	EWA_sim                   : out std_logic;
--	EWD_sim                   : out std_logic;
--	EWG_sim                   : out std_logic;

	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
   );
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

   component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

   component pb_inverters port (
			 rst_n            : in std_logic;
			 rst              : out std_logic;
			 pb_n_filtered    : in std_logic_vector(3 downto 0);
			 pb			  		: out std_logic_vector(3 downto 0)
  );
   end component;

	
	component synchronizer port(
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
   end component;
 
  component holding_register port (
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
  end component;

  component PB_filters port(
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	: out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	: out	std_logic_vector(3 downto 0)							 
  ); 
  end component;
  
  component state_machine port (
		
		clk_input, reset, sm_clken         : in std_logic;
		blink                              : in std_logic;
		NS_req, EW_req                     : in std_logic;
		NSA, NSG, NSD                      : out std_logic;
		EWA, EWG, EWD                      : out std_logic;
		NS_cross, Ew_cross                 : out std_logic;
		NS_clear, EW_clear                 : out std_logic;
		state_num                          : out std_logic_vector(3 downto 0)
	);
	
	end component;
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode						: boolean := FALSE; -- set to FALSE for LogicalStep board downloads
	                                                     -- set to TRUE for SIMULATIONS
	
	SIGNAL sm_clken, blink_sig			: std_logic; 
	
	SIGNAL pb, pb_n_filtered   		: std_logic_vector(3 downto 0); -- pb(3) is used as an active-high reset for all registers
	
	signal EW, NS                    : std_logic;
	
	signal synch_rst, rst, rst_n_filtered : std_logic;
	
	signal NS_sevenseg               : std_logic_vector(6 downto 0); -- 7 bit signal to concatenate NS
	signal EW_sevenseg               : std_logic_vector(6 downto 0); -- 7 bit signal to concatenate EW
	
	signal NSA, NSG, NSD             : std_logic;
	signal EWA, EWG, EWD             : std_logic;
	
	signal NS_cross                  : std_logic;
	signal EW_cross                  : std_logic;
	
	signal NS_clear                  : std_logic;
	signal EW_clear                  : std_logic;
	
	signal NS_req                    : std_logic;
	signal EW_req                    : std_logic;
	
	signal state_num                 : std_logic_vector(3 downto 0); -- 4 bit state number
	
--	signal NSA_sim, NSD_sim, NSG_sim, EWA_sim, EWD_sim, EWG_sim : std_logic;
--	
--	signal sm_clk_en : std_logic;
--	signal blink_signal : std_logic;
--		
	
BEGIN

----------------------------------------------------------------------------------------------------
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);
INST3: synchronizer     port map (clkin_50, synch_rst, pb(1), EW);
INST4: synchronizer     port map (clkin_50, synch_rst, pb(0), NS);
INST5: synchronizer     port map (clkin_50, synch_rst, rst, synch_rst);
INST6: holding_register port map (clkin_50, synch_rst, EW_clear, EW, EW_req);
INST7: holding_register port map (clkin_50, synch_rst, NS_clear, NS, NS_req);
INST8: PB_filters       port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST9: state_machine    port map (clkin_50, synch_rst, sm_clken, blink_sig, NS_req, EW_req, NSA, NSG, NSD, EWA, EWG, EWD, NS_cross, EW_cross, NS_clear, EW_clear, state_num);
INST10: segment7_mux    port map (clkin_50, NS_sevenseg, EW_sevenseg, seg7_data, seg7_char2, seg7_char1);




--leds(2) <= sm_clken;
--leds(0) <= blink_sig;
leds(0) <= NS_cross;
leds(2) <= EW_cross;

leds(3) <= EW_req;
leds(1) <= NS_req;

NS_sevenseg <= NSG&"00"&NSD&"00"&NSA;
EW_sevenseg <= EWG&"00"&EWD&"00"&EWA;

leds(7 downto 4) <= state_num;

--NSA_sim <= NSA;
--NSD_sim <= NSD;
--NSG_sim <= NSG;
--
--EWA_sim <= EWA;
--EWD_sim <= EWD;
--EWG_sim <= EWG;
--
--
--sm_clk_en <= sm_clken;
--blink_signal <= blink_sig;

END SimpleCircuit;