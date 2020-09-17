LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decodificador2x4 IS
    PORT (
        seletor : IN std_logic_vector(1 DOWNTO 0);
        habilita : OUT std_logic_vector(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF decodificador2x4 IS
BEGIN
    WITH seletor SELECT
        habilita <= "0001" WHEN "00",
        "0010" WHEN "01",
        "0100" WHEN "10",
        "1000" WHEN "11",
        "0000" WHEN OTHERS;
END ARCHITECTURE;