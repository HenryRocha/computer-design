## Criação dos OPCODES e quais pontos de controle eles devem abilitar.

| INST      | OPCODE | selMuxProxPC | selMuxULAImed | HabEscritaAcumulador | selOperacaoULA | habLeituraMEM | habEscritaMEM |
| --------- | ------ | ------------ | ------------- | -------------------- | -------------- | ------------- | ------------- |
| JUMP      | 0000   | 1            | 0             | 0                    | 000            | 0             | 0             |
| LOAD      | 0001   | 0            | 1             | 1                    | 011            | 1             | 0             |
| STORE     | 0010   | 0            | 0             | 0                    | 010            | 0             | 1             |
| ADDACCMEM | 0011   | 0            | 1             | 1                    | 000            | 1             | 0             |
| SUBACCMEM | 0100   | 0            | 1             | 1                    | 001            | 1             | 0             |
