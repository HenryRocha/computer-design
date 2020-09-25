LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY etapaDeBusca IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 3;
        INCREMENTO : NATURAL := 1
    );
    PORT (
        -- Input ports
        clk      : IN std_logic;
        selMuxPC : IN std_logic;
        desvio   : IN std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);

        -- Output ports
        instrucao : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behaviour OF etapaDeBusca IS
    SIGNAL muxPCOut      : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL registerPCOut : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL somaPCOut     : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
BEGIN
    somaPC : ENTITY work.somaConstante
        GENERIC MAP(
            larguraDados => ADDR_WIDTH,
            constante    => INCREMENTO
        )
        PORT MAP(
            entrada => registerPCOut,
            saida   => somaPCOut
        );

    muxPC : ENTITY work.muxGenerico2x1
        GENERIC MAP(
            larguraDados => ADDR_WIDTH
        )
        PORT MAP(
            entradaA_MUX => desvio,
            entradaB_MUX => somaPCOut,
            seletor_MUX  => selMuxPC,
            saida_MUX    => muxPCOut
        );

    registerPC : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => ADDR_WIDTH
        )
        PORT MAP(
            DIN    => muxPCOut,
            DOUT   => registerPCOut,
            ENABLE => '1',
            CLK    => clk,
            RST    => '0'
        );

    ROM : ENTITY work.memoriaROM
        GENERIC MAP(
            dataWidth => DATA_WIDTH,
            addrWidth => ADDR_WIDTH
        )
        PORT MAP(
            Endereco => registerPCOut,
            Dado     => instrucao
        );
END ARCHITECTURE;