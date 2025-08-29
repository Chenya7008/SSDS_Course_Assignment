LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Controller IS
    PORT (
        rst : IN std_logic;
        clk : IN std_logic;
        Go : IN std_logic;
        addEQ : IN std_logic;
        sumSEL : OUT std_logic;
        addSEL : OUT std_logic;
        AvgSEL : OUT std_logic;
        Finish : OUT std_logic;
        ldAvg, ldsum : OUT std_logic
    );
END Controller;

ARCHITECTURE behav OF Controller IS
    TYPE statetype IS (IDLE, S0, DONE);
    SIGNAL state, next_state : statetype;
BEGIN
    -- State register process
    Reg: PROCESS(clk)
    BEGIN
        IF(rising_edge(clk)) THEN
            IF(rst = '1') THEN
                state <= IDLE;
            ELSE
                state <= next_state;
            END IF;
        END IF;
    END PROCESS Reg;
    

    comb: PROCESS(state, Go, addEQ)
    BEGIN
      
        sumSEL <= '0';
        addSEL <= '0'; 
        AvgSEL <= '0';
        Finish <= '0';
        ldAvg <= '0';
        ldsum <= '0';   
        next_state <= state;
        
        CASE state IS
            WHEN IDLE =>
                IF(Go = '1') THEN
                    next_state <= S0;
                ELSE
                    next_state <= IDLE;
                END IF;
                
            WHEN S0 =>
                addSEL <= '1';   
                sumSEL <= '1';   
                ldAvg <= '0';
                ldsum <= '1';
                IF(addEQ = '1') THEN
                    next_state <= DONE;
                ELSE
                    next_state <= S0;
                END IF;
                
            WHEN DONE =>
                ldsum <= '0';
                ldAvg <= '1';
                AvgSEL <= '1';  
                Finish <= '1';   
                next_state <= DONE;  
                
        END CASE;
    END PROCESS comb;
    
END behav;