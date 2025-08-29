LIBRARY ieee;
USE ieee.std_logic_1164.ALL;      
USE ieee.numeric_std.ALL;          

ENTITY preamble_generator IS  
    PORT (
        clk       : IN  std_logic;  
        rst       : IN  std_logic;   
        start     : IN  std_logic;  
        data_out  : OUT std_logic    
    );
END preamble_generator;


ARCHITECTURE behavioral OF preamble_generator IS  
   
    TYPE state_type IS (IDLE, S0, S1, S2, S3, S4, S5, S6, S7);
    
   
    SIGNAL curr_state, next_state : state_type;
    
BEGIN
    
    comb_process: PROCESS(curr_state, start)  
    BEGIN
        
        next_state <= curr_state; 
        data_out <= '0';       
        
        CASE curr_state IS
            WHEN IDLE =>
                data_out <= '0';
                IF start = '1' THEN
                    next_state <= S0;
                ELSE
                    next_state <= IDLE;
                END IF;
                
            WHEN S0 =>
                data_out <= '1';      
                next_state <= S1;
                
            WHEN S1 =>
                data_out <= '0';     
                next_state <= S2;
                
            WHEN S2 =>
                data_out <= '1';    
                next_state <= S3;
                
            WHEN S3 =>
                data_out <= '0';      
                next_state <= S4;
                
            WHEN S4 =>
                data_out <= '1';    
                next_state <= S5;
                
            WHEN S5 =>
                data_out <= '0';     
                next_state <= S6;
                
            WHEN S6 =>
                data_out <= '1';    
                next_state <= S7;
                
            WHEN S7 =>
                data_out <= '0';      
                next_state <= IDLE; 
                
        END CASE;
    END PROCESS comb_process;

   
    reg_process: PROCESS(clk)  
    BEGIN
        IF rising_edge(clk) THEN     
            IF rst = '1' THEN       
                curr_state <= IDLE;  
            ELSE
                curr_state <= next_state;  
            END IF;
        END IF;
    END PROCESS reg_process;

END behavioral;