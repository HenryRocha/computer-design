LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY main IS
    PORT (
        CLOCK_50 : IN std_logic;
        SW : IN std_logic_vector(9 DOWNTO 0);
        LEDR : OUT std_logic_vector(9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behaviour OF main IS
BEGIN
    LEDR(9 DOWNTO 0) <= SW(9 DOWNTO 0);
END ARCHITECTURE;