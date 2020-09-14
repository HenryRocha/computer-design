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
    CONSTANT constSeven : std_logic_vector := "0111";
    SIGNAL somador2xOut, somador2yOut, somador3yOut, subtrator2x3xOut, somadorConstOut : std_logic_vector(3 DOWNTO 0);
    ALIAS y : std_logic_vector IS SW(3 DOWNTO 0);
    ALIAS x : std_logic_vector IS SW(9 DOWNTO 6);
BEGIN
    somador2x : ENTITY work.somadorGenerico PORT MAP(
        entradaA => x,
        entradaB => x,
        saida => somador2xOut
        );

    somador2y : ENTITY work.somadorGenerico PORT MAP(
        entradaA => y,
        entradaB => y,
        saida => somador2yOut
        );

    somador3y : ENTITY work.somadorGenerico PORT MAP(
        entradaA => somador2yOut,
        entradaB => y,
        saida => somador3yOut
        );

    subtrator2x3x : ENTITY work.subtratorGenerico PORT MAP(
        entradaA => somador2xOut,
        entradaB => somador3yOut,
        saida => subtrator2x3xOut
        );

    somadorConst : ENTITY work.somadorGenerico PORT MAP(
        entradaA => subtrator2x3xOut,
        entradaB => constSeven,
        saida => LEDR(3 DOWNTO 0)
        );
END ARCHITECTURE;