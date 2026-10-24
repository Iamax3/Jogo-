# Projeto Terror

Jogo de terror psicológico em primeira pessoa, focado em escolhas e conversas, feito em Godot 4.
Nome provisório.

## Como abrir o projeto

1. Instale o [Godot 4.7](https://godotengine.org/download) (versão padrão, não a .NET).
2. Baixe este repositório (pelo [GitHub Desktop](https://desktop.github.com/) é o mais fácil).
3. Abra o Godot, clique em **Importar**, escolha o arquivo `project.godot` desta pasta.

## Como o projeto é feito

Este jogo é desenvolvido por um diretor humano com duas IAs, **Claude** e **Codex**, que trabalham no mesmo repositório:

- `docs/DESIGN.md` — o que é o jogo.
- `docs/TASKS.md` — lista de tarefas, cada uma com dono (`@claude`, `@codex` ou `@diretor`).
- `AGENTS.md` — regras de trabalho para as IAs (o `CLAUDE.md` aponta para ele).

Cada tarefa vira um pull request, que a outra IA revisa e o diretor testa no Godot antes de aprovar.
