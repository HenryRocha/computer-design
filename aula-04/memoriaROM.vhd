LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memoriaROM IS
    GENERIC (
        dataWidth : NATURAL := 8;
        addrWidth : NATURAL := 8;
        oPcode_Width : NATURAL := 7
    );
    PORT (
        Endereco : IN std_logic_vector (addrWidth - 1 DOWNTO 0);
        Dado : OUT std_logic_vector (dataWidth - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE assincrona OF memoriaROM IS

    -- Formato das instrucoes:
    --alias enderecoRAM: std_logic_vector(addrWidth-1 DOWNTO 0) is Instrucao(addrWidth-1 downto 0);
    --alias imediatoDado: std_logic_vector (dataWidth-1 DOWNTO 0) is Instrucao(dataWidth-1 downto 0);
    --alias imediatoEndereco: std_logic_vector (addrWidth-1 DOWNTO 0) is Instrucao(addrWidth-1 downto 0);
    --
    --alias habLeituraBarramento: std_logic is Instrucao(dataROMWidth-1);
    --alias habEscritaBarramento: std_logic is Instrucao(dataROMWidth-2);
    --alias habAcumulador: std_logic is Instrucao(dataROMWidth-3);
    --alias sel_Imediato_RAM: std_logic is Instrucao(dataROMWidth-4);
    --alias operacaoULA: std_logic is Instrucao(dataROMWidth-5);
    --alias sel_MUX_Jump: std_logic is Instrucao(dataROMWidth-6);

    --Bit Instrucao---->        14                   13               12              11          10,9           8         7~0
    --Instrução       |habLeituraBarramento|habEscritaBarramento|habAcumulador|sel_Imediato_RAM|operacaoULA|sel_MUX_Jump|Imediato| 
    --Soma RAM        |          1         |         0          |      1      |       0        |    00     |     0      |Endereco|
    --Soma Imediato   |          1         |         0          |      1      |       1        |    00     |     0      | Valor  |
    --Subtrai RAM     |          1         |         0          |      1      |       0        |    01     |     0      |Endereco|
    --Subtrai Imediato|          1         |         0          |      1      |       1        |    00     |     0      | Valor  |
    --LW              |          1         |         0          |      1      |       0        |    1X     |     0      |Endereco|
    --SW              |          0         |         1          |      0      |       X        |     X     |     0      |Endereco|
    --J               |          0         |         0          |      0      |       X        |     X     |     1      |Endereco|

    --Soma RAM:     1010000_EnderecoRAM
    --Subtrai RAM:  1010010_EnderecoRAM
    --Soma Imed:    1011000_Imediato
    --Subtrai Imed: 1011010_EnderecoRAM
    --LW:           1010100_EnderecoRAM
    --SW:           0100100_EnderecoRAM
    --Jump:         0000001_EnderecoROM
    SUBTYPE opCode_t IS std_logic_vector(oPcode_Width - 1 DOWNTO 0);
    CONSTANT SomaRAM : opCode_t := "1010000";
    CONSTANT SubtraiRAM : opCode_t := "1010010";
    CONSTANT SomaImed : opCode_t := "1011000";
    CONSTANT SubtraiImed : opCode_t := "1011010";
    CONSTANT LW : opCode_t := "1010100";
    CONSTANT SW : opCode_t := "0100100";
    CONSTANT Jump : opCode_t := "0000001";

    TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF std_logic_vector(dataWidth - 1 DOWNTO 0);

    FUNCTION initMemory
        RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
    BEGIN
        -- Inicializa os endereços:
        tmp(0) := LW & "10000100"; --Endereco 132 Le chave
        -- tmp(1) := SubtraiImed & "00000001";   -- Subtrai 1
        tmp(1) := SomaImed & "00000001";   -- Soma 1
        tmp(2) := SW & "01000000";  --Endereco 64  Salva RAM
        -- tmp(5) := SomaImed & "00000001";   -- Soma 1
        -- tmp(6) := SW & "01000001";  --Endereco 65
        tmp(3) := LW & "01000000";  --Endereco 64  Le RAM
        tmp(4) := SW & "11001000"; --Endereco 200 Escreve LEDs
        -- tmp(8) := LW & "01000001";  --Endereco 65  Le RAM
        -- tmp(9) := SW & "11000000";  --Endereco 192 Escreve LEDs
        tmp(5) := Jump & "00000000";
        RETURN tmp;
    END initMemory;

    SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
    Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;