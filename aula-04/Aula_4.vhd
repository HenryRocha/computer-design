LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Aula_4 IS
    GENERIC (
        dataWidth : NATURAL := 8;
        addrWidth : NATURAL := 8;
        -- Utilizar o que for maior entre: dataWidth e addrWidth e somar com a quantidade de sinais de controle:
        dataROMWidth : NATURAL := 8 + 7
    );
    PORT (
        -- Entradas (placa)
        CLOCK_50 : IN STD_LOGIC;
        SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);

        -- Saidas (placa)
        LEDR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY;
ARCHITECTURE RTL OF Aula_4 IS
    SIGNAL ULA_Acumulador, ULAentradaA, ULAentradaB, barramentoLeituraDados, barramentoEscritaDados : std_logic_vector(dataWidth - 1 DOWNTO 0);
    SIGNAL PC_ROM, Incr_MUX_ProxPC, Incr_PC, barramentoEnderecos : std_logic_vector (addrWidth - 1 DOWNTO 0);
    SIGNAL Instrucao : std_logic_vector(dataROMWidth - 1 DOWNTO 0);
    SIGNAL habilitaBlocos : std_logic_vector(3 DOWNTO 0);
    SIGNAL clk : std_logic;

    ALIAS enderecoRAM : std_logic_vector(addrWidth - 1 DOWNTO 0) IS Instrucao(addrWidth - 1 DOWNTO 0);
    ALIAS imediatoDado : std_logic_vector (dataWidth - 1 DOWNTO 0) IS Instrucao(dataWidth - 1 DOWNTO 0);
    ALIAS imediatoEndereco : std_logic_vector (addrWidth - 1 DOWNTO 0) IS Instrucao(addrWidth - 1 DOWNTO 0);

    ALIAS habLeituraBarramento : std_logic IS Instrucao(dataROMWidth - 1);
    ALIAS habEscritaBarramento : std_logic IS Instrucao(dataROMWidth - 2);
    ALIAS habAcumulador : std_logic IS Instrucao(dataROMWidth - 3);
    ALIAS sel_Imediato_RAM : std_logic IS Instrucao(dataROMWidth - 4);
    ALIAS operacaoULA : std_logic_vector IS Instrucao(dataROMWidth - 5 DOWNTO dataROMWidth - 6);
    ALIAS sel_MUX_Jump : std_logic IS Instrucao(dataROMWidth - 7);
BEGIN

    ULA : ENTITY work.ULA
        PORT MAP(
            entradaA => ULAentradaA,
            entradaB => ULAentradaB,
            saida => ULA_Acumulador,
            seletor => operacaoULA
        );

    RAM : ENTITY work.memoriaRAM
        PORT MAP(
            clk => clk,
            addr => barramentoEnderecos,
            we => habEscritaBarramento,
            re => habLeituraBarramento,
            habilita => habilitaBlocos(1),
            dado_in => barramentoEscritaDados,
            dado_out => barramentoLeituraDados
        );

    MUX_RAM_Imediato : ENTITY work.muxGenerico2x1
        PORT MAP(
            entradaA_MUX => barramentoLeituraDados,
            entradaB_MUX => imediatoDado,
            seletor_MUX => sel_Imediato_RAM,
            saida_MUX => ULAentradaA
        );

    MUX_proxPC : ENTITY work.muxGenerico2x1
        PORT MAP(
            entradaA_MUX => Incr_MUX_ProxPC,
            entradaB_MUX => imediatoEndereco,
            seletor_MUX => sel_MUX_Jump,
            saida_MUX => Incr_PC
        );

    incremento : ENTITY work.somaConstante
        PORT MAP(
            entrada => PC_ROM,
            saida => Incr_MUX_ProxPC
        );

    ROM : ENTITY work.memoriaROM
        GENERIC MAP(
            dataWidth => dataROMWidth
        )
        PORT MAP(
            Endereco => PC_ROM,
            Dado => Instrucao
        );

    PC : ENTITY work.registradorGenerico
        PORT MAP(
            CLK => clk,
            DIN => Incr_PC,
            DOUT => PC_ROM,
            ENABLE => '1',
            RST => '0'
        );

    Acumulador : ENTITY work.registradorGenerico
        PORT MAP(
            CLK => clk,
            DIN => ULA_Acumulador,
            DOUT => ULAentradaB,
            ENABLE => habAcumulador,
            RST => '0'
        );

    decodificador : ENTITY work.decodificador2x4
        PORT MAP(
            seletor => barramentoEnderecos(addrWidth - 1 DOWNTO addrWidth - 2),
            habilita => habilitaBlocos
        );

    saidaLEDs : ENTITY work.interfaceLEDs
        PORT MAP(
            clk => clk,
            entrada => barramentoEscritaDados(dataWidth - 1 DOWNTO 0),
            saida => LEDR(dataWidth - 1 DOWNTO 0),
            habilita => habilitaBlocos(3)
        );

    entradaChaves : ENTITY work.interfaceCHAVES
        PORT MAP(
            entrada => SW(dataWidth - 1 DOWNTO 0),
            saida => barramentoLeituraDados(dataWidth - 1 DOWNTO 0),
            habilita => habilitaBlocos(2)
        );

    barramentoEscritaDados <= ULAentradaB;
    barramentoEnderecos <= imediatoEndereco;
    clk <= CLOCK_50;
END ARCHITECTURE;