library IEEE;
use IEEE.std_logic_1164.all;

entity Excess_3s_tb is
end entity Excess_3s_tb;

architecture test1 of Excess_3s_tb is
   
    signal BCD_test    : std_logic_vector(3 downto 0);
    signal Excess_test : std_logic_vector(3 downto 0);
    
    
    component Excess_3s
        port(
            BCD    : in  std_logic_vector(3 downto 0);
            Excess : out std_logic_vector(3 downto 0)
        );
    end component;
    
begin
    
    UUT: Excess_3s port map (
        BCD => BCD_test,
        Excess => Excess_test
    );
    
    -- Test process
    stimulus: process
    begin
        -- Test all valid BCD inputs (0-9)
        
       
        -- Test all valid BCD inputs (0-9)
        for i in 0 to 9 loop
            case i is
                when 0 => BCD_test <= "0000";
                when 1 => BCD_test <= "0001";
                when 2 => BCD_test <= "0010";
                when 3 => BCD_test <= "0011";
                when 4 => BCD_test <= "0100";
                when 5 => BCD_test <= "0101";
                when 6 => BCD_test <= "0110";
                when 7 => BCD_test <= "0111";
                when 8 => BCD_test <= "1000";
                when 9 => BCD_test <= "1001";
                when others => null;
            end case;
            
            wait for 10 ns; -- Wait for signal stabilization
            
            -- Verify results with assertions
            case i is
                when 0 => 
                    assert Excess_test = "0011"
                        report "Error: BCD=0000, Expected=0011" severity error;
                when 1 => 
                    assert Excess_test = "0100"
                        report "Error: BCD=0001, Expected=0100" severity error;
                when 2 => 
                    assert Excess_test = "0101"
                        report "Error: BCD=0010, Expected=0101" severity error;
                when 3 => 
                    assert Excess_test = "0110"
                        report "Error: BCD=0011, Expected=0110" severity error;
                when 4 => 
                    assert Excess_test = "0111"
                        report "Error: BCD=0100, Expected=0111" severity error;
                when 5 => 
                    assert Excess_test = "1000"
                        report "Error: BCD=0101, Expected=1000" severity error;
                when 6 => 
                    assert Excess_test = "1001"
                        report "Error: BCD=0110, Expected=1001" severity error;
                when 7 => 
                    assert Excess_test = "1010"
                        report "Error: BCD=0111, Expected=1010" severity error;
                when 8 => 
                    assert Excess_test = "1011"
                        report "Error: BCD=1000, Expected=1011" severity error;
                when 9 => 
                    assert Excess_test = "1100"
                        report "Error: BCD=1001, Expected=1100" severity error;
                when others => null;
            end case;
        end loop;
        
        -- Test invalid BCD inputs
        BCD_test <= "1010"; wait for 10 ns;
        assert Excess_test = "0000"
            report "Error: BCD=1010, Expected=0000" severity error;
               
        BCD_test <= "1011"; wait for 10 ns;
        assert Excess_test = "0000"
            report "Error: BCD=1011, Expected=0000" severity error;
               
        BCD_test <= "1111"; wait for 10 ns;
        assert Excess_test = "0000"
            report "Error: BCD=1111, Expected=0000" severity error;
        
        wait; -- End simulation
    end process stimulus;
    
end architecture test1;