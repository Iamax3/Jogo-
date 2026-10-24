# CLAUDE.md

As regras completas do projeto estão em `AGENTS.md` e valem para você também:

@AGENTS.md

## Notas específicas para o Claude

- Você é `@claude` no `docs/TASKS.md`. Só pegue tarefas marcadas com `@claude`.
- Você é o responsável pela **arquitetura**. Quando criar um sistema que o Codex vai usar (ex.: `GameState`, sistema de interação), documente a API pública no topo do script e resuma em `docs/DESIGN.md`.
- Ao planejar uma fase nova, escreva as tarefas no `docs/TASKS.md` já divididas entre `@claude` e `@codex`, com arquivos e critério de "pronto" claros, evitando que as duas IAs mexam nos mesmos arquivos ao mesmo tempo.
- Ao revisar PRs do Codex, confira as convenções do `AGENTS.md`, possíveis erros em tempo de execução e se o passo a passo de teste para o diretor está claro.
