class_name InteractionPrompt
extends CanvasLayer
## Dica de interação e painel de leitura controlado por teclado.

signal reading_closed

@onready var _hint: Label = $Hint
@onready var _panel: PanelContainer = $ReadingPanel
@onready var _text: RichTextLabel = $ReadingPanel/Margin/Content/Text


func set_hint(text: String) -> void:
	_hint.text = text
	_hint.visible = not text.is_empty() and not _panel.visible


func show_reading(text: String) -> void:
	_text.text = text
	_text.scroll_to_line(0)
	_panel.show()
	_hint.hide()


func _input(event: InputEvent) -> void:
	if not _panel.visible:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if not event.is_echo():
			_panel.hide()
			reading_closed.emit()
