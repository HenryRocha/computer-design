LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ULAsoma IS
    GENERIC (
        larguraDados : NATURAL := 8
    );
    PORT (
        entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
        operacao : IN STD_LOGIC;
        saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF ULAsoma IS
    SIGNAL soma, subtracao : STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
BEGIN
    soma <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
    subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
    saida <= soma WHEN (operacao = '1') ELSE
        subtracao;
END ARCHITECTURE;