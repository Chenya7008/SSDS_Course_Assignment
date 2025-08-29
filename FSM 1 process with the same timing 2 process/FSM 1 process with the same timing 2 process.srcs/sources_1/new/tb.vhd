

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_minimal_preamble IS
END tb_minimal_preamble;

ARCHITECTURE minimal_test OF tb_minimal_preamble IS
    -- Component declaration
    COMPONENT preamble
        PORT(
            clk      : IN  std_logic;
            rst      : IN  std_logic;
            start    : IN  std_logic;
            data_out : OUT std_logic
        );
    END COMPONENT;
    
    -- Test signals
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal start    : std_logic := '0';
    signal data_out : std_logic;
    
    -- Clock period
    constant clk_period : time := 10 ns;
    signal test_done : boolean := false;

BEGIN
    -- Instantiate FSM
    uut: preamble 
        PORT MAP (
            clk      => clk,
            rst      => rst,
            start    => start,
            data_out => data_out
        );

    -- Clock generation
    clk_process: PROCESS
    BEGIN
        while not test_done loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    END PROCESS;

    -- Minimal test stimulus 
    test_process: PROCESS
    BEGIN		
        report "=== Minimal Preamble Test Started ===" severity note;
        
      
        rst <= '1';
        wait for clk_period * 2;
        rst <= '0';
        wait for clk_period;
        
        
        report "Starting single preamble generation..." severity note;
        start <= '1';
        wait for clk_period;
        start <= '0';
        
       
        report "Expected pattern: 10101010" severity note;
        for i in 0 to 7 loop
            wait for clk_period;
            report "Bit " & integer'image(i) & ": " & std_logic'image(data_out) severity note;
        end loop;
        
        
        wait for clk_period * 2;
        
        report "=== Single Test Completed ===" severity note;
        report "Check waveform for correct '10101010' pattern" severity note;
        
        test_done <= true;
        wait;
        
    END PROCESS;

END minimal_test;