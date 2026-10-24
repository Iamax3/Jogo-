# AGENTS.md — Regras do projeto

Este arquivo vale para **todas as IAs** que trabalham neste repositório (Codex lê este arquivo; Claude lê através do `CLAUDE.md`). Leia inteiro antes de começar qualquer tarefa.

## Sobre o jogo

Jogo curto de **terror psicológico e sobrenatural**, em **primeira pessoa**, feito em **Godot 4**. A história avança por **conversas e escolhas** (inspiração: Doki Doki Literature Club), alternando com **cenários 3D de exploração** com puzzles simples. As escolhas mudam falas, cenários e decidem entre 3 finais.

- Escopo: 3 capítulos, 3 a 4 cenários, 2 a 4 personagens, 1 a 2 horas de jogo.
- Visual: realista estilizado — pouca luz, neblina, granulado, vinheta.
- Plataforma: PC (Windows primeiro).
- Detalhes completos: [`docs/DESIGN.md`](docs/DESIGN.md).

## Quem trabalha aqui

| Quem | Papel |
| --- | --- |
| **Diretor (humano)** | Decide história e clima, testa no Godot, aprova ou recusa pull requests. Não programa — explique as coisas em linguagem simples. |
| **Claude** (`@claude`) | Arquitetura, sistemas principais (jogador, escolhas, diálogos, save, troca de zonas), montagem de cenários, roteiro junto com o diretor, revisão do código do Codex. |
| **Codex** (`@codex`) | Tarefas bem delimitadas: interface e menus, interações com objetos, puzzles, efeitos visuais e sonoros, testes, bugs, revisão do código do Claude. |

As duas IAs **não conversam diretamente**. Toda comunicação acontece por arquivos e pull requests neste repositório.

## Fluxo de trabalho

1. **Só pegue tarefas com a sua marca** em [`docs/TASKS.md`](docs/TASKS.md) (`@claude` ou `@codex`) e com status `pendente`.
2. Ao começar, mude o status para `em andamento` e confira a lista de **Arquivos** da tarefa.
3. **Nunca edite arquivos que estão listados numa tarefa `em andamento` da outra IA.** Se precisar mexer neles, pare e escreva isso no pull request.
4. Crie um branch: `claude/T-000-nome-curto` ou `codex/T-000-nome-curto`.
5. **Uma tarefa por pull request.** Mantenha o PR pequeno.
6. Na descrição do PR, escreva em português simples:
   - o que foi feito;
   - como o diretor testa (passo a passo no Godot: qual cena abrir, quais teclas apertar);
   - o que ficou de fora ou pode dar problema.
7. Ao terminar, mude o status para `revisão`. Depois que o diretor aprovar e o PR entrar no `main`, o status vira `feito`.
8. Revise os PRs da outra IA quando o diretor pedir: aponte bugs, quebra de convenções e riscos. Seja específico.

Se uma tarefa estiver ambígua, **não invente**: faça a parte clara e liste as dúvidas no PR.

## Tecnologia

- **Godot 4.7** (estável), renderizador **Forward+**.
- **GDScript** com tipagem estática.
- **Diálogos:** plugin [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager), instalado em `addons/dialogue_manager/` (entra na Fase 2). Arquivos de diálogo ficam em `dialogue/*.dialogue`.
- Não adicione outros plugins ou dependências sem uma tarefa pedindo isso.

## Estrutura de pastas

```
addons/            plugins do Godot (não edite código de terceiros)
autoload/          scripts globais (singletons), ex.: game_state.gd
assets/
  models/          modelos 3D (.glb preferido)
  textures/        texturas
  materials/       materiais (.tres)
  fonts/           fontes
  audio/music      trilha
  audio/sfx        efeitos
  audio/ambience   sons de ambiente
  CREDITS.md       origem e licença de TODO asset de terceiros
dialogue/          arquivos .dialogue (roteiro)
scenes/
  player/          jogador
  levels/          cenários de exploração
  dialogue_zones/  zonas de conversa
  interactables/   objetos interativos (portas, notas, chaves)
  ui/              menus e interface
scripts/           espelha scenes/: scenes/player/player.tscn usa scripts/player/player.gd
tests/             testes automatizados
docs/              DESIGN.md, TASKS.md
```

## Convenções de código

- **Código em inglês** (nomes de arquivos, variáveis, funções, nós). **Comentários, textos de PR e documentação em português.** Texto que aparece para o jogador: português.
- Arquivos e pastas em `snake_case` (`flashlight.gd`, `main_menu.tscn`). `class_name` e nomes de nós em `PascalCase`.
- Indentação com **tabs** (padrão do Godot).
- Tipagem estática sempre: `var speed: float = 4.0`, `func open() -> void:`.
- Valores que o diretor pode querer ajustar viram `@export` com comentário `##` explicando em português.
- Sinais no passado: `door_opened`, `choice_made`.
- Um script por cena, ligado ao nó raiz, salvo no caminho espelhado em `scripts/`.
- Prefira composição (cenas pequenas reutilizáveis) a scripts gigantes.

## Escolhas e estado do jogo

- Todo estado de história fica no autoload `GameState` (`autoload/game_state.gd`).
- Escolhas são **flags** com nome em `snake_case` e prefixo do capítulo: `ch1_trusted_ana`, `ch2_opened_basement`.
- Toda flag nova deve ser registrada na tabela de flags em `docs/DESIGN.md`.

## Arquivos do Godot

- **Nunca** versione a pasta `.godot/` (já está no `.gitignore`).
- Arquivos `.import` **devem** ser versionados.
- Ao editar `.tscn`/`.tres` à mão, preserve os `uid` existentes e não reordene recursos sem necessidade.
- Não altere configurações do `project.godot` que não tenham relação com a sua tarefa.

## Validação

- Se o Godot estiver disponível no ambiente, rode `godot --headless --path . --quit` e garanta que não há erros de script.
- Se não estiver, escreva no PR: "não testei no Godot", para o diretor testar com atenção.

## Assets

- Use apenas assets com licença livre (CC0 de preferência: Poly Haven, Kenney, Quaternius, Freesound CC0).
- Registre cada asset em `assets/CREDITS.md`: nome, autor, link, licença.

## Proibido

- Apagar ou reescrever trabalho da outra IA sem uma tarefa pedindo.
- Fazer commit direto no `main`.
- Mudar a história, os nomes dos personagens ou as escolhas sem aprovação do diretor.
