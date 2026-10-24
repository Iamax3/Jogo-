# Tarefas

Status possíveis: `pendente` · `em andamento` · `revisão` · `feito`

Regras: cada IA só pega tarefas com a sua marca. Antes de começar, mude o status para `em andamento`. Não edite arquivos listados numa tarefa `em andamento` de outra IA. Detalhes em `AGENTS.md`.

---

## Fase 0 — Preparação

### T-001 · Criar o repositório e a estrutura inicial
- **Dono:** @claude
- **Status:** feito
- **Arquivos:** estrutura de pastas, `project.godot`, `AGENTS.md`, `CLAUDE.md`, `docs/`
- **Pronto quando:** o projeto abre no Godot sem erros e as regras de trabalho estão escritas.

### T-002 · Preparar o computador do diretor
- **Dono:** @diretor
- **Status:** pendente
- **Pronto quando:** Godot 4.7 instalado, repositório clonado (GitHub Desktop serve) e o projeto abre no Godot.

### T-003 · Predefinição de exportação para Windows
- **Dono:** @codex
- **Status:** feito
- **Arquivos:** `export_presets.cfg`, `docs/EXPORTAR.md`
- **Pronto quando:** existe uma predefinição "Windows Desktop" que exporta para `build/windows/`, e `docs/EXPORTAR.md` explica em passos simples como o diretor gera o `.exe`.

---

## Fase 1 — Protótipo de movimento
**Meta:** andar por um quarto escuro com uma lanterna e examinar objetos.

### T-101 · Controle em primeira pessoa
- **Dono:** @claude
- **Status:** feito
- **Arquivos:** `scenes/player/player.tscn`, `scripts/player/player.gd`, `scenes/levels/player_sandbox.tscn` (área de teste provisória), seções `[input]` e `run/main_scene` do `project.godot`
- **Pronto quando:** cena `player.tscn` com andar (WASD), olhar (mouse), agachar (Ctrl), passos lentos e pesados combinando com terror. Velocidade e sensibilidade são `@export`. Ações de input criadas: `move_forward`, `move_back`, `move_left`, `move_right`, `crouch`, `interact` (E), `flashlight` (F).

### T-102 · Cena de teste com clima de terror
- **Dono:** @claude
- **Status:** revisão
- **Depende de:** T-101
- **Arquivos:** `scenes/levels/test_room.tscn`, `scripts/levels/`, `run/main_scene` do `project.godot`
- **Pronto quando:** um quarto fechado com móveis simples, iluminação baixa, neblina volumétrica e `WorldEnvironment` configurado. O jogador da T-101 começa dentro dele. O quarto vira a **cena principal** do projeto (no lugar de `player_sandbox.tscn`), para a exportação da T-003 gerar algo jogável.

### T-103 · Sistema de interação
- **Dono:** @codex
- **Status:** revisão
- **Depende de:** T-101 (usa a ação `interact`)
- **Arquivos:** `scenes/interactables/`, `scripts/interactables/`, `scenes/ui/interaction_prompt.tscn`, `scripts/ui/interaction_prompt.gd`
- **Pronto quando:** existe uma classe base `Interactable` (um `Area3D` ou `StaticBody3D` com `interact()` e um texto de dica). Ao mirar num objeto, aparece "E — Examinar" na tela; ao apertar E, o objeto reage. Inclui um exemplo: uma nota que mostra um texto na tela. A forma de detectar o objeto mirado (RayCast3D na câmera do jogador) deve ser documentada para o Claude integrar ao jogador.

### T-104 · Lanterna
- **Dono:** @codex
- **Status:** pendente
- **Depende de:** T-101
- **Arquivos:** `scenes/player/flashlight.tscn`, `scripts/player/flashlight.gd`
- **Pronto quando:** cena separada com `SpotLight3D` que liga e desliga com F, tem bateria que descarrega aos poucos e pisca quando está fraca. Duração da bateria e intensidade são `@export`. A cena é feita para ser colocada como filha da câmera do jogador, sem editar `player.tscn` (o Claude faz a integração).

---

## Fase 2 — Sistemas de história
**Meta:** uma conversa com escolha que muda algo no cenário.

Tarefas detalhadas serão escritas pelo @claude quando a Fase 1 terminar. Prévia:

- @claude — instalar o Dialogue Manager e criar o autoload `GameState` com flags de escolha
- @claude — sistema de save e de troca entre zonas de conversa e exploração
- @codex — interface de diálogo (caixa de texto, nome de quem fala, opções de resposta)
- @codex — menu principal, pausa e configurações

## Fases 3 a 5

Fatia vertical (capítulo 1 completo), conteúdo e finais, polimento e lançamento — ver `docs/DESIGN.md`.
