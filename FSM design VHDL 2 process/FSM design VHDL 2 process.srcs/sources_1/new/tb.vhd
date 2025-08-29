LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_simple_preamble IS
END tb_simple_preamble;

ARCHITECTURE simple_test OF tb_simple_preamble IS
    -- Component declaration
    COMPONENT preamble_generator
        PORT(
            clk      : IN  std_logic;
            rst      : IN  std_logic;
            start    : IN  std_logic;
            data_out : OUT std_logic
        );
    END COMPONENT;
    
    -- Signals
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal start    : std_logic := '0';
    signal data_out : std_logic;
    
    -- Clock period
    constant clk_period : time := 10 ns;
    signal test_complete : boolean := false;

BEGIN
    -- Instantiate UUT
    uut: preamble_generator 
        PORT MAP (
            clk      => clk,
            rst      => rst,
            start    => start,
            data_out => data_out
        );

    -- Clock generation
    clk_process: PROCESS
    BEGIN
        while not test_complete loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    END PROCESS;

    -- Simple stimulus
    stim_proc: PROCESS
    BEGIN		
        -- Initial reset
        rst <= '1';
        start <= '0';
        wait for clk_period * 2;
        
        rst <= '0';
        wait for clk_period * 2;
        
        -- Start preamble generation
        report "Starting preamble generation..." severity note;
        start <= '1';
        wait for clk_period;
        start <= '0';
        
        -- Wait for 8 clock cycles and observe
        for i in 0 to 7 loop
            wait for clk_period;
            report "Cycle " & integer'image(i) & ": data_out = " & std_logic'image(data_out) severity note;
        end loop;
        
        -- Wait a few more cycles
        wait for clk_period * 3;
        
        report "Test completed. Check console output and waveform." severity note;
        test_complete <= true;
        wait;
        
    END PROCESS;

END simple_test;