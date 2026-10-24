class_name InteractionPrompt
extends CanvasLayer
## Dica de interação, mira no centro da tela e painel de leitura controlado por teclado.

signal reading_closed

## Cor da mira quando não há nada interativo à frente.
@export var crosshair_idle_color: Color = Color(1, 1, 1, 0.35)
## Cor da mira quando o jogador olha para algo interativo.
@export var crosshair_active_color: Color = Color(1, 0.6, 0.2, 1)

@onready var _crosshair: ColorRect = $Crosshair
@onready var _hint: Label = $Hint
@onready var _panel: PanelContainer = $ReadingPanel
@onready var _text: RichTextLabel = $ReadingPanel/Margin/Content/Text


func set_hint(text: String) -> void:
	_hint.text = text
	_hint.visible = not text.is_empty() and not _panel.visible
	var active: bool = not text.is_empty()
	_crosshair.color = crosshair_active_color if active else crosshair_idle_color
	# A mira cresce um pouco ao mirar em algo interativo, para ficar fácil de notar.
	var half: float = 5.0 if active else 3.0
	_crosshair.offset_left = -half
	_crosshair.offset_top = -half
	_crosshair.offset_right = half
	_crosshair.offset_bottom = half
	_crosshair.visible = not _panel.visible


func show_reading(text: String) -> void:
	_text.text = text
	_text.scroll_to_line(0)
	_panel.show()
	_hint.hide()
	_crosshair.hide()


func _input(event: InputEvent) -> void:
	if not _panel.visible:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if not event.is_echo():
			_panel.hide()
			reading_closed.emit()
