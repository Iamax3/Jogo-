class_name Interactable
extends StaticBody3D
## Base para objetos examináveis. Sobrescreva interact() para outras reações.

signal interacted

## Dica mostrada depois da tecla de interação.
@export var interaction_hint: String = "Examinar"
## Texto da leitura. Vazio permite reações sem abrir o painel.
@export_multiline var examination_text: String = ""
## Permite desativar o objeto sem remover sua colisão.
@export var interaction_enabled: bool = true


func interact() -> void:
	if interaction_enabled:
		interacted.emit()
