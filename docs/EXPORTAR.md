# Exportar para Windows

A predefinição **Windows Desktop** salva o jogo em `build/windows/projeto_terror.exe`, para Windows de 64 bits (Intel ou AMD).

## Preparar uma vez

1. Abra o `project.godot` no Godot 4.7, usando o renderizador Forward+ do projeto.
2. Abra **Editor > Gerenciar modelos de exportação** (em inglês: **Manage Export Templates**). Baixe e instale os modelos da mesma versão exata do editor.
3. No Explorador de Arquivos do Windows, abra a pasta do repositório. Crie a pasta `build` e, dentro dela, a pasta `windows`.
4. Confira se existe uma cena principal em **Projeto > Configurações do projeto > Aplicação > Executar > Cena principal** (**Application > Run > Main Scene**). O projeto inicial ainda não tem cenas jogáveis; quando elas existirem, selecione a cena de entrada combinada com o diretor. Sem ela, não é possível testar o jogo exportado. Esta tarefa não cria uma cena.

## Gerar o jogo

1. No Godot, clique em **Projeto > Exportar** (**Project > Export**).
2. Selecione **Windows Desktop** na lista à esquerda. A predefinição já vem no repositório; não é necessário adicionar outra.
3. Confira se não há mensagens de erro. Se faltarem modelos, instale-os pelo passo 2 de preparação; se faltar a cena principal, complete o passo 4.
4. Clique em **Exportar projeto** (**Export Project**), e não em **Exportar PCK/ZIP**.
5. Confirme o destino `build/windows/projeto_terror.exe`. Desmarque **Exportar com depuração** (**Export With Debug**) para gerar a versão de distribuição e clique em **Salvar**.
6. No Explorador de Arquivos, abra `build/windows/` e dê dois cliques em `projeto_terror.exe`. Confira se o jogo abre na cena principal. As teclas de jogo serão definidas nas tarefas de movimento e interface.

## Compartilhar e conferir

- Mantenha o `.exe`, o `.pck` e os demais arquivos gerados juntos. Para enviar o jogo, compacte a pasta `build/windows/` inteira; enviar apenas o `.exe` não basta.
- Teste também a cópia descompactada em outra pasta, abrindo o `.exe`.
- A pasta `build/` já é ignorada pelo Git. Não envie os arquivos gerados ao repositório.
- A exportação usa Forward+; o computador que executa o jogo precisa de suporte a Vulkan e drivers de vídeo compatíveis.
- Não há assinatura digital configurada. O Windows pode mostrar um aviso de aplicativo desconhecido.

Referência: [documentação oficial de exportação para Windows](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_windows.html).
