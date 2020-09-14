LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY main IS
    PORT (
        CLOCK_50 : IN std_logic;
        FPGA_RESET_N : IN std_logic;
        KEY : IN std_logic_vector(3 DOWNTO 0);
        SW : IN std_logic_vector(9 DOWNTO 0);
        LEDR : OUT std_logic_vector(9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behaviour OF main IS
    ALIAS resetA : std_logic IS KEY(1);
    ALIAS enableA : std_logic IS KEY(3);
    ALIAS resetB : std_logic IS KEY(0);
    ALIAS enableB : std_logic IS KEY(2);

    ALIAS seletorMux : std_logic IS SW(8);
    ALIAS seletorOp : std_logic IS SW(9);

    ALIAS indicadorULA : std_logic_vector IS LEDR(7 DOWNTO 0);
    ALIAS indicadorMux : std_logic IS LEDR(8);
    ALIAS indicadorOp : std_logic IS LEDR(9);

    ALIAS entradaSW : std_logic_vector IS SW(7 DOWNTO 0);

    SIGNAL detectorCLK, detectorRSTA, detectorRSTB : std_logic;
    SIGNAL out_ULA, out_MUX, out_REGA, out_REGB : std_logic_vector(7 DOWNTO 0);
BEGIN
    detectorRSTA_c : ENTITY work.edgeDetector(bordaDescida) PORT MAP (
        clk => CLOCK_50,
        entrada => NOT resetA,
        saida => detectorRSTA
        );

    detectorRSTB_c : ENTITY work.edgeDetector(bordaDescida) PORT MAP (
        clk => CLOCK_50,
        entrada => NOT resetB,
        saida => detectorRSTB
        );

    detectorCLK_c : ENTITY work.edgeDetector(bordaDescida) PORT MAP (
        clk => CLOCK_50,
        entrada => NOT FPGA_RESET_N,
        saida => detectorCLK
        );

    muxIn_A : ENTITY work.muxGenerico2x1 PORT MAP (
        entradaA_MUX => entradaSW,
        entradaB_MUX => out_ULA,
        seletor_MUX => seletorMux,
        saida_MUX => out_MUX
        );

    regA : ENTITY work.registradorGenerico PORT MAP(
        DIN => out_MUX,
        CLK => detectorCLK,
        RST => detectorRSTA,
        ENABLE => NOT enableA,
        DOUT => out_REGA
        );

    regB : ENTITY work.registradorGenerico PORT MAP(
        DIN => entradaSW,
        CLK => detectorCLK,
        RST => detectorRSTB,
        ENABLE => NOT enableB,
        DOUT => out_REGB
        );

    ULA : ENTITY work.ULAsoma PORT MAP(
        entradaA => out_REGA,
        entradaB => out_REGB,
        operacao => seletorOp,
        saida => out_ULA
        );

    indicadorMux <= seletorMux;
    indicadorOp <= seletorOp;
    indicadorULA <= out_ULA;
END ARCHITECTURE;