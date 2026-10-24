# Interação — T-103

## Testar sem alterar o jogador

Abra `scenes/interactables/interaction_demo.tscn` e aperte **F6** (executar a cena atual). Uma nota provisória fica flutuando à frente do jogador, na altura dos olhos, para facilitar o teste.

1. Mire no centro da nota: aparece **E — Examinar**.
2. Aperte **E**: o texto abre e o jogador para de andar e olhar.
3. Aperte **E** novamente ou **Esc**: o painel fecha e o controle volta. Segurar E não deve abrir e fechar repetidamente.
4. Olhe para o chão ou afaste-se mais de 2,5 metros: a dica desaparece e E não abre nada.
5. Fora da leitura, **Esc** solta o mouse e esconde a dica; clique na janela para capturar de novo.

## Integrar ao cenário (Claude)

- Instancie `scenes/interactables/interaction_ray.tscn` como filha direta de `Player/Head/Camera3D`, sem deslocamento ou rotação local. A cena já contém a interface; não adicione outra cópia de `interaction_prompt.tscn`.
- O nó raiz é um `RayCast3D` apontado para o eixo local **-Z** da câmera. `interaction_distance` ajusta o alcance no Inspetor (padrão: 2,5 metros).
- O script encontra o ancestral `Player`, exclui seu corpo das colisões do raio e respeita `Player.input_enabled` e o mouse capturado. Cada acionamento de E atualiza o raio antes de escolher o alvo.
- O raio considera o **primeiro corpo atingido**, sem atravessar paredes. Objetos e obstáculos devem estar em camadas incluídas na máscara do raio (padrão: camada 1). `Area3D` não participa desta implementação.
- Instancie `note.tscn` no cenário e ajuste `examination_text` e `interaction_hint` no Inspetor. O painel não interpreta BBCode; o texto é literal. Textos longos podem ser rolados com a roda do mouse.
- Na leitura, o componente guarda `input_enabled`, desativa o controle e restaura o valor ao fechar ou remover o componente. E e Esc são consumidos pela interface para não reabrir a nota nem soltar o mouse no mesmo evento.
- O sistema não altera a cena principal nem os arquivos `player.tscn` e `player.gd`. A demonstração instancia o jogador existente e acrescenta o componente somente naquela cena.

## Criar outros objetos

Use um `StaticBody3D` com um script que estenda `Interactable` (`scripts/interactables/interactable.gd`), uma forma de colisão e um visual. Mantenha o script no caminho espelhado da cena.

- `interaction_hint`: texto depois de **E —**.
- `interaction_enabled`: permite desativar a interação mantendo a colisão.
- `interact() -> void`: reação do objeto. A implementação base emite o sinal `interacted`; conecte esse sinal ou sobrescreva o método, chamando `super.interact()` quando quiser preservar o aviso.
- `examination_text`: abre a leitura depois da reação; deixe vazio para objetos que apenas reagem, como uma porta. A nota de exemplo usa texto marcado como **[PROVISÓRIO]**, sem criar história ou flags.

Não use o bloqueio de leitura simultaneamente com outro menu que também controle `input_enabled`; a coordenação dos menus fica para o sistema de interface. Há uma interface por jogador, pensada para o jogo de um jogador deste projeto.
