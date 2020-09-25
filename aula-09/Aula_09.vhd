LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Aula_09 IS
    GENERIC (
        DATA_WIDTH : NATURAL := 16;
        ADDR_WIDTH : NATURAL := 8;
        INCREMENTO : NATURAL := 1
    );
    PORT (
        -- Input ports
        clk : IN std_logic
    );
END ENTITY;

ARCHITECTURE behaviour OF Aula_09 IS
BEGIN
END ARCHITECTURE;