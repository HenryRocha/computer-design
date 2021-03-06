LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY interfaceCHAVES IS
    GENERIC (
        dataWidth : NATURAL := 8
    );
    PORT (
        entrada : IN std_logic_vector(dataWidth - 1 DOWNTO 0);
        habilita : IN std_logic;
        saida : OUT std_logic_vector(dataWidth - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF interfaceCHAVES IS
BEGIN
    saida <= entrada WHEN habilita = '1' ELSE
        (OTHERS => 'Z');
END ARCHITECTURE;