library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Excess_3s is
    port(
        BCD    : in  std_logic_vector(3 downto 0);
        Excess : out std_logic_vector(3 downto 0)
    );
end  Excess_3s;

architecture behave of Excess_3s is
begin
    
    Excess <= "0011" when BCD = "0000" else
              "0100" when BCD = "0001" else
              "0101" when BCD = "0010" else
              "0110" when BCD = "0011" else
              "0111" when BCD = "0100" else
              "1000" when BCD = "0101" else
              "1001" when BCD = "0110" else
              "1010" when BCD = "0111" else
              "1011" when BCD = "1000" else
              "1100" when BCD = "1001" else
              "0000"; -- default for invalid BCD
end behave;
