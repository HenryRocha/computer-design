LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY decodificador2x4 IS
    PORT (
        seletor : IN std_logic_vector(7 DOWNTO 0);
        habilita : OUT std_logic_vector(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF decodificador2x4 IS
    SIGNAL numSeletor : unsigned(8 DOWNTO 0);
BEGIN
    numSeletor(7 DOWNTO 0) <= unsigned(seletor);
    habilita(0) <= '1' WHEN numSeletor = 0 ELSE
    '0';
    habilita(1) <= '1' WHEN numSeletor >= 64 AND numSeletor <= 127 ELSE
    '0';
    habilita(2) <= '1' WHEN numSeletor = 132 ELSE
    '0';
    habilita(3) <= '1' WHEN numSeletor = 200 ELSE
    '0';
END ARCHITECTURE;