LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY STRUCTURALLY IS  
    PORT (
        CLK, RST : IN std_logic;  
        Go : IN std_logic;        
        dataIN : IN std_logic_vector(15 downto 0);  
        finish : OUT std_logic;
        mem_address : OUT std_logic_vector(9 downto 0);
        Average : OUT std_logic_vector(15 downto 0)
    );
END STRUCTURALLY;

ARCHITECTURE structural OF STRUCTURALLY IS  
   
    COMPONENT DATAPATH
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
    END COMPONENT;
    
    COMPONENT Controller
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
    END COMPONENT;
    
   
    SIGNAL sumSEL_1 : std_logic;
    SIGNAL addSEL_1 : std_logic;
    SIGNAL AvgSEL_1 : std_logic;
    SIGNAL addEQ_1 : std_logic;
    SIGNAL ldAvg_1 : std_logic;
    SIGNAL ldsum_1 : std_logic;
    
BEGIN
 
    DP: DATAPATH PORT MAP (
        RST,        
        CLK,       
        sumSEL_1,
        addSEL_1,
        AvgSEL_1,
        addEQ_1,
        dataIN,
        mem_address,
        Average,
        ldAvg_1,
        ldsum_1
    );
    
    CU: Controller PORT MAP (
        RST,       
        CLK,       
        Go,
        addEQ_1,
        sumSEL_1,
        addSEL_1,
        AvgSEL_1,
        finish,
        ldAvg_1,
        ldsum_1
    );
    
END structural;