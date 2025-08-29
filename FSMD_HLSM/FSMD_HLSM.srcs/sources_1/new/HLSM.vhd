
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY RAM_ACCESS IS
    PORT (
        clk : IN std_logic;
        rst : IN std_logic;
        Go : IN std_logic;
        Finish : OUT std_logic;
        Average : OUT std_logic_vector(15 downto 0);
        mem_address : OUT std_logic_vector(9 downto 0);
        dataIN : IN std_logic_vector(15 downto 0)
    );
END RAM_ACCESS;


ARCHITECTURE HLSM OF RAM_ACCESS IS
   
    TYPE state_type IS (IDLE, S0, DONE);
    

    SIGNAL state, next_state : state_type;
    SIGNAL sum, next_sum : unsigned(25 downto 0);
    SIGNAL tempAvg, next_tempAvg : unsigned(15 downto 0);
    SIGNAL finishSig : std_logic;
    SIGNAL tempaddress,next_tempaddress : unsigned(9 downto 0);
BEGIN
    -- Register process
    Reg: PROCESS(clk)
    BEGIN
        IF(rising_edge(clk)) THEN
            IF(rst = '1') THEN
                state <= IDLE;
                sum <= (others => '0');
                tempAvg <= (others => '0');
                tempaddress  <= (others => '0');
            ELSE
                state <= next_state;
                sum <= next_sum;
                tempAvg <= next_tempAvg;
                tempaddress <= next_tempaddress;
            END IF;
        END IF;
    END PROCESS Reg;

    -- Combinational logic process
    Comb: PROCESS(state, Go, sum, tempAvg, dataIN,tempaddress)
       
        --VARIABLE tempaddress : unsigned(9 downto 0);
    BEGIN
        -- Default values
        next_sum <= sum;
        next_tempAvg <= tempAvg;
        next_state <= state;
        next_tempaddress <=tempaddress;

        CASE state IS
            WHEN IDLE =>
                finishSig <= '0';
                IF(Go = '1') THEN
                    next_sum <= (others => '0');
                    next_state <= S0;
                ELSE
                    next_state <= IDLE;
                END IF;
                
            WHEN S0 =>
                next_tempaddress <= tempaddress + 1;
                mem_address <= std_logic_vector(tempaddress);
                next_sum <= sum + unsigned(dataIN);
                --tempaddress := tempaddress + 1;
                
                IF(tempaddress = 1023) THEN
                    next_state <= DONE;
                ELSE  
                    next_state <= S0;
                END IF;
                
            WHEN DONE =>
                --next_tempAvg <= sum / 1024;
                next_tempAvg <= sum(25 downto 10); 
                finishSig <= '1';
                
        END CASE;
    END PROCESS Comb;
    
    Finish <= finishSig;
    Average <= std_logic_vector(tempAvg) WHEN finishSig = '1' ELSE (others => '0');
    
END HLSM;