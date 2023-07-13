library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity State_Machine is port (
		
		clk_input, reset, sm_clken         : in std_logic;
		blink                              : in std_logic;
		NS_req, EW_req                     : in std_logic;
		NSA, NSG, NSD                      : out std_logic;
		EWA, EWG, EWD                      : out std_logic;
		NS_cross, Ew_cross                 : out std_logic;
		NS_clear, EW_clear                 : out std_logic;
		state_num                          : out std_logic_vector(3 downto 0)
	);
end entity;

Architecture sm of state_machine is

TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);

signal current_state, next_state : STATE_NAMES;

BEGIN

Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input) AND (sm_clken = '1')) THEN
		IF (reset = '1') THEN
			current_state <= S0;
		ELSIF (reset = '0') THEN
			current_state <= next_State;
			END IF;
	END IF;
END PROCESS;	


Transition_Section: PROCESS (EW_req, NS_req, current_state) 

BEGIN
  CASE current_state IS
        WHEN S0 =>		
				IF ((EW_req = '1') AND (NS_req = '0')) THEN
					next_state <= S6;
				ELSE 	
					next_state <= S1;
				end if;
				
         WHEN S1 =>		
				IF ((EW_req = '1') AND (NS_req = '0')) THEN
					next_state <= S6;
				ELSE 	
					next_state <= S2;
				end if;
				
         WHEN S2 =>		
				
				next_state <= S3;
				
         WHEN S3 =>		

				next_state <= S4;

         WHEN S4 =>		
				
				next_state <= S5;

         WHEN S5 =>		
				
				next_state <= S6;
				
         WHEN S6 =>		

				next_state <= S7;
				
         WHEN S7 =>		
				
				next_state <= S8;
			
			WHEN S8 => 
				IF ((EW_req = '0') AND (NS_req = '1')) THEN
					next_state <= S14;
				ELSE 	
					next_state <= S9;
				end if;
				
			
			WHEN S9 => 
				IF ((EW_req = '0') AND (NS_req = '1')) THEN
					next_state <= S14;
				ELSE 	
					next_state <= S10;
				end if;
			
			WHEN S10 => 
				
				next_state <= S11;
				
			WHEN S11 =>
					
				next_state <= S12;
			
			WHEN S12 =>
					
				next_state <= S13;
			
			WHEN S13 =>
					
				next_state <= S14;
			
			WHEN S14 =>
					
				next_state <= S15;
				
			WHEN OTHERS =>
            next_state <= S0;
	  END CASE;
 END PROCESS;
 
 Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
	  
         WHEN S0 =>		
			
			--NS is flashing green
			
			NSA <= '0';
			NSG <= '0';
			NSD <= blink;
			
			--EW is red
			
			EWA <= '1';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "0000";
			
         WHEN S1 =>		
			
			--NS is flashing green
			
			NSA <= '0';
			NSG <= '0';
			NSD <= blink;
			
			--EW is red
			
			EWA <= '1';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "0001";
			
         WHEN S2 =>		
			
			--NS is green,  NS crossing is on
			
			NSA <= '0';
			NSG <= '0';
			NSD <= '1';
			
			--EW is red
			
			EWA <= '1';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '1';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "0010";
			
         WHEN S3 =>		
			
			--NS is green
			
			NSA <= '0';
			NSG <= '0';
			NSD <= '1';
			
			--EW is red
			
			EWA <= '1';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '1';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			state_num <= "0011";
			
         WHEN S4 =>		
			
			--NS is green
			
			NSA <= '0';
			NSG <= '0';
			NSD <= '1';
			
			--EW is red
			
			EWA <= '1';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '1';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "0100";

         WHEN S5 =>		
		
			--NS is green
				
			NSA <= '0';
			NSG <= '0';
			NSD <= '1';
				
			--EW is red
			
			EWA <= '1';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '1';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "0101";

				
         WHEN S6 =>		
			
			--NS is amber
			
			NSA <= '0';
			NSG <= '1';
			NSD <= '0';
			
			--EW is red
			
			EWA <= '1';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '1';
			EW_clear <= '0';
			
			state_num <= "0110";
				
         WHEN S7 =>		
			
			--NS is amber
			
			NSA <= '0';
			NSG <= '1';
			NSD <= '0';
			
			--EW is red
			
			EWA <= '1';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "0111";
		
         WHEN S8 =>
			
			--NS is red
			
			NSA <= '1';
			NSG <= '0';
			NSD <= '0';
			
			--EW is flashing green
			
			EWA <= '0';
			EWG <= '0';
			EWD <= blink;
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "1000";
			
			WHEN S9 =>
			
			--NS is red
			
			NSA <= '1';
			NSG <= '0';
			NSD <= '0';
			
			--EW is flashing green
			
			EWA <= '0';
			EWG <= '0';
			EWD <= blink;
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "1001";
			
			WHEN S10 =>
			
			--NS is red
			
			NSA <= '1';
			NSG <= '0';
			NSD <= '0';
			
			--EW is green
			
			EWA <= '0';
			EWG <= '0';
			EWD <= '1';
			
			NS_cross <= '0';
			EW_cross <= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "1010";
			
			WHEN S11 =>
			
			--NS is red
			
			NSA <= '1';
			NSG <= '0';
			NSD <= '0';
			
			--EW is green
			
			EWA <= '0';
			EWG <= '0';
			EWD <= '1';
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "1011";
			
			WHEN S12 =>
			
			--NS is red
			
			NSA <= '1';
			NSG <= '0';
			NSD <= '0';
			
			--EW is green
			
			EWA <= '0';
			EWG <= '0';
			EWD <= '1';
			
			NS_cross <= '0';
			EW_cross <= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "1100";
			
			WHEN S13 =>
			
			--NS is red
			
			NSA <= '1';
			NSG <= '0';
			NSD <= '0';
			
			--EW is green
			
			EWA <= '0';
			EWG <= '0';
			EWD <= '1';
			
			NS_cross <= '0';
			EW_cross <= '1';
			NS_clear <= '0';
			EW_clear <= '0';
			
			
			state_num <= "1101";
			
			WHEN S14 =>
			
			--NS is red
			
			NSA <= '1';
			NSG <= '0';
			NSD <= '0';
			
			--EW is amber
			
			EWA <= '0';
			EWG <= '1';
			EWD <= '0';
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '1';
			
			
			state_num <= "1110";
			
			WHEN S15 =>
			
			--NS is red
			
			NSA <= '1';
			NSG <= '0';
			NSD <= '0';
			
			--EW is amber
			
			EWA <= '0';
			EWG <= '1';
			EWD <= '0';
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '1';
			
			state_num <= "1111";
			
			WHEN others => 
				
			NSA <= '0';
			NSG <= '0';
			NSD <= '0';
			
			EWA <= '0';
			EWG <= '0';
			EWD <= '0';
			
			NS_cross <= '0';
			EW_cross <= '0';
			NS_clear <= '0';
			EW_clear <= '0';
			
			state_num <= "0000";
	  END CASE;
 END PROCESS;
 
 END Architecture sm;