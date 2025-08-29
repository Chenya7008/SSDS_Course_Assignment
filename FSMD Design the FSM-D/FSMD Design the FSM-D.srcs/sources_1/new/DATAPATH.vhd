LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DATAPATH IS
    PORT (
        rst : IN std_logic;
        clk : IN std_logic;
        sumSEL : IN std_logic;
        addSEL : IN std_logic;
        AvgSEL : IN std_logic;
        addEQ : OUT std_logic;
        dataIN : IN std_logic_vector(15 downto 0);
        mem_address : OUT std_logic_vector(9 downto 0);
        Average : OUT std_logic_vector(15 downto 0);
        ldAvg, ldsum : IN std_logic
    );
END DATAPATH;

ARCHITECTURE behav OF DATAPATH IS
    SIGNAL sum, next_sum : unsigned(25 downto 0);
    SIGNAL tempAvg, next_tempAvg : unsigned(15 downto 0);
    SIGNAL tempaddress : unsigned(9 downto 0);  -- changed to SIGNAL
BEGIN
    -- Register Process
    Reg: PROCESS(clk)
    BEGIN
        IF(rising_edge(clk)) THEN
            IF(rst = '1') THEN
                sum <= (others => '0');
                tempAvg <= (others => '0');
                tempaddress <= (others => '0');  
            ELSE
                -- Sum register with load control
                IF(ldsum = '1') THEN
                    sum <= next_sum;
                END IF;
                
                -- Average register with load control  
                IF(ldAvg = '1') THEN
                    tempAvg <= next_tempAvg;
                END IF;
                
                -- Address increment control
                IF(addSEL = '1') THEN
                    tempaddress <= tempaddress + 1;  
                END IF;
            END IF;
        END IF;
    END PROCESS Reg;
    

    comb: PROCESS(sumSEL, AvgSEL, dataIN, sum, tempAvg, tempaddress)
    BEGIN
        
        next_sum <= sum;
        next_tempAvg <= tempAvg;
        
        -- Sum control
        CASE sumSEL IS
            WHEN '0' =>
                next_sum <= sum;  -- Hold
            WHEN '1' =>
                next_sum <= sum + unsigned(dataIN); 
            WHEN OTHERS =>
                next_sum <= sum;
        END CASE;
        
        -- Average control
        CASE AvgSEL IS
            WHEN '0' =>
                next_tempAvg <= tempAvg;  -- Hold
            WHEN '1' =>
                next_tempAvg <= sum(25 downto 10);  
            WHEN OTHERS =>
                next_tempAvg <= tempAvg;
        END CASE;
        
        -- Address output 
        IF(addSEL = '1') THEN
            mem_address <= std_logic_vector(tempaddress);
        ELSE
            mem_address <= (others => '0');
        END IF;
        
      
        IF(tempaddress = 1023) THEN
            addEQ <= '1';
        ELSE
            addEQ <= '0'; 
        END IF;
        
    END PROCESS comb;
    
    -- Output assignments
    Average <= std_logic_vector(tempAvg);
    
END behav;