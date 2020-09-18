LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memoriaROM IS
    GENERIC (
        dataWidth : NATURAL := 8;
        addrWidth : NATURAL := 3
    );
    PORT (
        Endereco : IN std_logic_vector (addrWidth - 1 DOWNTO 0);
        Dado     : OUT std_logic_vector (dataWidth - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE assincrona OF memoriaROM IS
    TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF std_logic_vector(dataWidth - 1 DOWNTO 0);

    CONSTANT Jump      : std_logic_vector(3 DOWNTO 0) := "0000";
    CONSTANT Load      : std_logic_vector(3 DOWNTO 0) := "0001";
    CONSTANT Store     : std_logic_vector(3 DOWNTO 0) := "0010";
    CONSTANT AddAccMem : std_logic_vector(3 DOWNTO 0) := "0011";
    CONSTANT SubAccMem : std_logic_vector(3 DOWNTO 0) := "0100";

    FUNCTION initMemory
        RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
    BEGIN
        -- Inicializa os endereços:
        tmp(0) := Load & x"000";
        --        tmp(1) := x"42";
        --        tmp(2) := x"43";
        --        tmp(3) := x"44";
        --        tmp(4) := x"45";
        --        tmp(5) := x"46";
        --        tmp(6) := x"47";
        --        tmp(7) := x"55";
        RETURN tmp;
    END initMemory;

    SIGNAL memROM : blocoMemoria := initMemory;
BEGIN
    Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;