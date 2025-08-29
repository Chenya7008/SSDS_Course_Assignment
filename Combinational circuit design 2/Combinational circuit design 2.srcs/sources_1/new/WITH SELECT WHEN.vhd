library IEEE;
use IEEE.std_logic_1164.all;

entity btExcess_3s is

    port(
        BCD    : in  std_logic_vector(3 downto 0);
        Excess : out std_logic_vector(3 downto 0)
    );
end  btExcess_3s;

architecture behav of btExcess_3s is
begin
    
    with BCD select
        Excess <= "0011" when "0000",
                  "0100" when "0001",
                  "0101" when "0010",
                  "0110" when "0011",
                  "0111" when "0100",
                  "1000" when "0101",
                  "1001" when "0110",
                  "1010" when "0111",
                  "1011" when "1000",
                  "1100" when "1001",
                  "0000" when others; 
end  behav;