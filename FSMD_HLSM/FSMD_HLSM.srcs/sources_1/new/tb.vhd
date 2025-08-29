LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RAM_ACCESS_TB IS
END RAM_ACCESS_TB;

ARCHITECTURE Behavioral OF RAM_ACCESS_TB IS
    -- Component declaration for unit under test
    COMPONENT RAM_ACCESS
        PORT (
            clk : IN std_logic;
            rst : IN std_logic;
            Go : IN std_logic;
            Finish : OUT std_logic;
            Average : OUT std_logic_vector(15 downto 0);
            mem_address : OUT std_logic_vector(9 downto 0);
            dataIN : IN std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
    -- Test signals
    SIGNAL clk_tb : std_logic := '0';
    SIGNAL rst_tb : std_logic := '1';
    SIGNAL Go_tb : std_logic := '0';
    SIGNAL Finish_tb : std_logic;
    SIGNAL Average_tb : std_logic_vector(15 downto 0);
    SIGNAL mem_address_tb : std_logic_vector(9 downto 0);
    SIGNAL dataIN_tb : std_logic_vector(15 downto 0);
    
    -- Clock period
    CONSTANT clk_period : time := 20 ns;
    
BEGIN
    -- Unit under test instantiation
    UUT: RAM_ACCESS 
        PORT MAP (
            clk => clk_tb,
            rst => rst_tb,
            Go => Go_tb,
            Finish => Finish_tb,
            Average => Average_tb,
            mem_address => mem_address_tb,
            dataIN => dataIN_tb
        );
    
    -- Clock generation
    clk_process: PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR clk_period/2;
        clk_tb <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;
    
    -- Simple RAM simulation - directly based on address
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
        
        -- Selective debug output (only key addresses)
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
        REPORT "=== Starting RAM average calculation test ===";
        REPORT "Test pattern: addresses 0-511 = 100, addresses 512-1023 = 200";
        REPORT "Expected average = (512*100 + 512*200)/1024 = 150";
        
        Go_tb <= '1';
        WAIT FOR clk_period;
        Go_tb <= '0';
        
        -- Wait for completion with sufficient time
        -- 1024 cycles + overhead = ~21-22us
        WAIT UNTIL Finish_tb = '1' FOR 25 us;
        
        IF Finish_tb = '1' THEN
            REPORT "=== Test completed successfully! ===";
            REPORT "Calculated average: " & integer'image(to_integer(unsigned(Average_tb)));
            REPORT "Expected average: 150";
            
            -- Verify result
            IF to_integer(unsigned(Average_tb)) = 150 THEN
                REPORT "*** TEST PASSED! ***" SEVERITY NOTE;
            ELSIF to_integer(unsigned(Average_tb)) >= 140 AND to_integer(unsigned(Average_tb)) <= 160 THEN
                REPORT "*** TEST PASSED (within tolerance)! Got " & 
                       integer'image(to_integer(unsigned(Average_tb))) & " ***" SEVERITY NOTE;
            ELSE
                REPORT "*** TEST FAILED! Expected ~150, got " & 
                       integer'image(to_integer(unsigned(Average_tb))) & " ***" SEVERITY ERROR;
            END IF;
        ELSE
            REPORT "*** TEST TIMEOUT! Finish signal never asserted ***" SEVERITY ERROR;
            REPORT "Check if HLSM is stuck in a state or if timing is too long";
        END IF;
        
        WAIT FOR 1 us;
        REPORT "=== Test finished ===";
        WAIT;
    END PROCESS;
    
END Behavioral;