LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY STRUCTURALLY_TB IS
END STRUCTURALLY_TB;

ARCHITECTURE Behavioral OF STRUCTURALLY_TB IS
    -- Component declaration for unit under test
    COMPONENT STRUCTURALLY
        PORT (
            CLK, RST : IN std_logic;
            Go : IN std_logic;
            dataIN : IN std_logic_vector(15 downto 0);
            finish : OUT std_logic;
            mem_address : OUT std_logic_vector(9 downto 0);
            Average : OUT std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
    -- Test signals
    SIGNAL clk_tb : std_logic := '0';
    SIGNAL rst_tb : std_logic := '1';
    SIGNAL Go_tb : std_logic := '0';
    SIGNAL finish_tb : std_logic;
    SIGNAL Average_tb : std_logic_vector(15 downto 0);
    SIGNAL mem_address_tb : std_logic_vector(9 downto 0);
    SIGNAL dataIN_tb : std_logic_vector(15 downto 0);
    
    -- Clock period
    CONSTANT clk_period : time := 20 ns;
    
BEGIN
    -- Unit under test instantiation
    UUT: STRUCTURALLY 
        PORT MAP (
            CLK => clk_tb,
            RST => rst_tb,
            Go => Go_tb,
            dataIN => dataIN_tb,
            finish => finish_tb,
            mem_address => mem_address_tb,
            Average => Average_tb
        );
    
    -- Clock generation
    clk_process: PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR clk_period/2;
        clk_tb <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;
    
    -- Simple RAM simulation
    ram_read: PROCESS(mem_address_tb)
        VARIABLE addr_val : integer;
    BEGIN
        addr_val := to_integer(unsigned(mem_address_tb));
        
        -- Simple test pattern: first 512 = 100, last 512 = 200
        IF addr_val < 512 THEN
            dataIN_tb <= std_logic_vector(to_unsigned(100, 16));  -- 0x0064
        ELSE
            dataIN_tb <= std_logic_vector(to_unsigned(200, 16));  -- 0x00C8
        END IF;
        
        -- Debug output for key addresses
        IF addr_val = 0 OR addr_val = 1 OR addr_val = 511 OR 
           addr_val = 512 OR addr_val = 513 OR addr_val = 1023 THEN
            REPORT "Address: " & integer'image(addr_val) & 
                   " DataIN: " & integer'image(to_integer(unsigned(dataIN_tb)));
        END IF;
    END PROCESS;
    
    -- Test stimulus
    stimulus: PROCESS
    BEGIN
        -- Initial state
        rst_tb <= '1';
        Go_tb <= '0';
        WAIT FOR 100 ns;
        
        -- Release reset
        rst_tb <= '0';
        WAIT FOR 50 ns;
        
        -- Start test
        REPORT "=== Starting FSM-D RAM average calculation test ===";
        REPORT "Test pattern: addresses 0-511 = 100, addresses 512-1023 = 200";
        REPORT "Expected average = (512*100 + 512*200)/1024 = 150";
        
        Go_tb <= '1';
        WAIT FOR clk_period;
        Go_tb <= '0';
        
        -- Wait for completion with sufficient time
        WAIT UNTIL finish_tb = '1' FOR 25 us;
        
        IF finish_tb = '1' THEN
            REPORT "=== Test completed successfully! ===";
            REPORT "Calculated average: " & integer'image(to_integer(unsigned(Average_tb)));
            REPORT "Expected average: 150";
            
            -- Verify result
            IF to_integer(unsigned(Average_tb)) = 150 THEN
                REPORT "*** FSM-D TEST PASSED! ***" SEVERITY NOTE;
            ELSIF to_integer(unsigned(Average_tb)) >= 140 AND to_integer(unsigned(Average_tb)) <= 160 THEN
                REPORT "*** FSM-D TEST PASSED (within tolerance)! Got " & 
                       integer'image(to_integer(unsigned(Average_tb))) & " ***" SEVERITY NOTE;
            ELSE
                REPORT "*** FSM-D TEST FAILED! Expected ~150, got " & 
                       integer'image(to_integer(unsigned(Average_tb))) & " ***" SEVERITY ERROR;
            END IF;
        ELSE
            REPORT "*** FSM-D TEST TIMEOUT! Finish signal never asserted ***" SEVERITY ERROR;
            REPORT "Check if FSM-D is stuck in a state or if timing is too long";
        END IF;
        
        WAIT FOR 1 us;
        REPORT "=== FSM-D Test finished ===";
        WAIT;
    END PROCESS;
    
END Behavioral;