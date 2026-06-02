# Volei Campeonato — Scripts Roblox

No painel `Explorer`, abra `ServerScriptService`.

1. Crie uma pasta chamada `VoleiCampeonato` (opcional, apenas para organizar).
2. Crie quatro objetos do tipo `Script` e cole os arquivos abaixo em ordem:
   - `01_quadra`
   - `02_bola`
   - `03_partidas`
   - `04_campeonato`
3. Clique em `Jogar` para testar.

## Responsabilidades

| Script | O que faz |
|---|---|
| `01_quadra` | Quadra com linhas, rede em faixas, postes com topo, arquibancadas, placar 3D e postes de luz |
| `02_bola` | Bola com rastro visual, cooldown por jogador e física ajustada |
| `03_partidas` | HUD moderno por time com cores separadas, popup "+1 Ponto!" e indicador de time do jogador |
| `04_campeonato` | Troféu detalhado com pódio, haste, taça, alças e confetes ao finalizar |

## Melhorias em relação à versão original

### Gráficos
- Linhas de limite e ataque na quadra (brancas)
- Rede com múltiplas faixas alternadas preto/branco
- Postes com base e topo decorativo dourado
- Arquibancadas em 5 degraus com borda colorida por time
- Placares 3D em cada extremidade
- Postes de luz com lampada neon
- Troféu completo: pódio de 3 degraus, haste cilíndrica, taça com alças, estrela neon
- Confetes coloridos com `ParticleEmitter`

### Gameplay
- Cooldown de 0.6s por jogador (evita spam de rebatida)
- Rastro (`Trail`) luminoso na bola
- Impulso vertical adaptativo (levantamento vs ataque)
- HUD separado por time com contadores individuais e indicador de time do jogador
- Popup animado "+1 Time!" ao marcar ponto
- Após final de set, o saque começa no lado adversário (correto pelas regras)
