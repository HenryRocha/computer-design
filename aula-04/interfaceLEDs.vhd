LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY interfaceLEDs IS
    GENERIC (
        dataWidth : NATURAL := 8
    );
    PORT (
        entrada : IN std_logic_vector(dataWidth - 1 DOWNTO 0);
        habilita : IN std_logic;
        clk : IN std_logic;
        saida : OUT std_logic_vector(dataWidth - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF interfaceLEDs IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (habilita = '1') THEN
                saida <= entrada;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;