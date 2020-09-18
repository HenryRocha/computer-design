LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Unidade_Controle IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 8
    );
    PORT (
        -- Input ports
        clk    : IN std_logic;
        opCode : IN std_logic_vector(3 DOWNTO 0);
        -- Output ports
        palavraControle : OUT std_logic_vector(7 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_name OF Unidade_Controle IS
    ALIAS selMuxProxPC         : std_logic IS palavraControle(7);
    ALIAS selMuxULAImed        : std_logic IS palavraControle(6);
    ALIAS HabEscritaAcumulador : std_logic IS palavraControle(5);
    ALIAS selOperacaoULA       : std_logic_vector(2 DOWNTO 0) IS palavraControle(4 DOWNTO 2);
    ALIAS habLeituraMEM        : std_logic IS palavraControle(1);
    ALIAS habEscritaMEM        : std_logic IS palavraControle(0);

    SIGNAL instrucao         : std_logic_vector(4 DOWNTO 0);
    CONSTANT opCodeJump      : std_logic_vector(3 DOWNTO 0) := "0000";
    CONSTANT opCodeLoad      : std_logic_vector(3 DOWNTO 0) := "0001";
    CONSTANT opCodeStore     : std_logic_vector(3 DOWNTO 0) := "0010";
    CONSTANT opCodeAddAccMem : std_logic_vector(3 DOWNTO 0) := "0011";
    CONSTANT opCodeSubAccMem : std_logic_vector(3 DOWNTO 0) := "0100";

    ALIAS jump      : std_logic IS instrucao(0);
    ALIAS load      : std_logic IS instrucao(1);
    ALIAS store     : std_logic IS instrucao(2);
    ALIAS addAccMem : std_logic IS instrucao(3);
    ALIAS subAccMem : std_logic IS instrucao(4);
BEGIN
    -- 0000 - 00 JUMP:            10000000
    -- 0001 - 01 LOAD:            01101110
    -- 0010 - 02 STORE:           01001001
    -- 0011 - 03 ADD ACC MEM:     01000010
    -- 0100 - 04 SUB ACC MEM:     01000110
    -- 0000 - 00 ADD ACC IMED:    N/A
    -- 0000 - 00 SUB ACC IMED:    N/A
    -- 0000 - 00 DESVIA:          N/A

    -- <optional_label>: with <expression> select
    -- <target> <= <value> when <choices>,
    -- 			<value> when <choices>,
    -- 			<value> when <choices>,
    -- 			...
    -- 			<value> when others;

    WITH opCode SELECT
        instrucao <= "00001" WHEN opCodeJump,
        "00010" WHEN opCodeLoad,
        "00100" WHEN opCodeStore,
        "01000" WHEN opCodeAddAccMem,
        "10000" WHEN opCodeSubAccMem,
        "00000" WHEN OTHERS;

    selMuxProxPC <= jump;

    selMuxULAImed <= store;

    HabEscritaAcumulador <= load;

    WITH opCode SELECT
        selOperacaoULA <= "000" WHEN opCodeJump,
        "000" WHEN opCodeAddAccMem,
        "011" WHEN opCodeLoad,
        "010" WHEN opCodeStore,
        "001" WHEN opCodeSubAccMem,
        "000" WHEN OTHERS;

    habLeituraMEM <= load OR addAccMem OR subAccMem;

    habEscritaMEM <= store;
END ARCHITECTURE;