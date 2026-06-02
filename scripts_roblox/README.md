# Scripts separados para Roblox Studio

No painel `Explorer`, abra `ServerScriptService`.

1. Remova ou desative o script antigo que continha tudo junto.
2. Crie quatro objetos do tipo `Script`.
3. Renomeie e cole o conteudo dos arquivos correspondentes:
   - `01_mapa`
   - `02_cristais`
   - `03_zumbis`
   - `04_fases`
4. Clique em `Jogar` para testar.

## Responsabilidades

- `01_mapa.server.lua`: cria o chao, as arvores, a escada, a plataforma e o portao.
- `02_cristais.server.lua`: cria e remove os cristais coletados.
- `03_zumbis.server.lua`: cria os zumbis e faz com que persigam jogadores proximos.
- `04_fases.server.lua`: mostra o contador, abre o portao e inicia a segunda noite.
