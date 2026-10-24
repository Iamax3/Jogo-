# Design do jogo (resumo)

> Documento completo, mantido pelo diretor: https://claude.ai/artifact/SfUQJj2z8V88An1TeuRWkX
> Este arquivo é o resumo que as IAs consultam. Se houver conflito, vale o documento completo e a palavra do diretor.

## Conceito

Jogo curto de terror psicológico e sobrenatural, em primeira pessoa. A história avança mais por conversas e escolhas do que por ação. O jogador alterna entre **zonas de conversa** e **cenários de exploração**, e suas decisões mudam o rumo e o final.

## Pilares

1. **Escolhas que pesam** — decisões importantes mudam o que acontece depois, e o jogo lembra delas.
2. **Medo que cresce aos poucos** — clima, detalhes errados e o que não se vê; nada de sustos baratos.
3. **Pequeno e bem acabado** — 3 a 4 cenários caprichados, 1 a 2 horas de jogo.

## Inspirações

- Doki Doki Literature Club — começa inocente e se distorce; o jogo parece "saber" das escolhas.
- P.T. e Visage — exploração em primeira pessoa, ambientes que mudam quando você não olha.
- Buckshot Roulette — terror pequeno em Godot com muita atmosfera.

## Estrutura

- **3 capítulos.** Cada um alterna: zona de conversa → zona de exploração.
- **Zona de conversa:** câmera parada ou quase parada, personagens falando, opções de resposta.
- **Zona de exploração:** primeira pessoa, examinar objetos, achar pistas, puzzles simples.
- **Escolhas** gravam flags no `GameState`. Flags mudam falas futuras, objetos nos cenários e o comportamento dos fantasmas.
- Um contador escondido (sanidade ou desconfiança) pode alterar o clima: luzes piscando, sons estranhos.
- **3 finais:** bom, ruim e um secreto. O jogo pode reagir a ter sido jogado antes.

## Visual e som

- Realista estilizado: pouca luz, neblina, granulado, vinheta, leve distorção.
- Assets gratuitos (Poly Haven, Kenney, Quaternius) — registrar em `assets/CREDITS.md`.
- Som é metade do medo: ambiente constante, rangidos, silêncios.

## História

Ainda em definição pelo diretor. Perguntas em aberto:

- Onde se passa? Quem é o protagonista e por que está ali?
- Quem são os personagens das conversas? Algum é o fantasma?
- Haverá quebra da quarta parede estilo Doki Doki?

**Não invente história, personagens ou falas definitivas.** Use textos provisórios marcados com `[PROVISÓRIO]`.

## Tabela de flags

| Flag | Capítulo | Significado |
| --- | --- | --- |
| _(nenhuma ainda)_ | | |
