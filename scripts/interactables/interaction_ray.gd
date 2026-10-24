extends RayCast3D
## Instancie esta cena como filha da câmera do Player.

## Alcance máximo de interação, em metros.
@export_range(0.2, 5.0, 0.1) var interaction_distance: float = 2.5

var _player: Player
var _target: Interactable
var _previous_input_enabled: bool = true
var _reading: bool = false

@onready var _prompt: InteractionPrompt = $InteractionPrompt


func _ready() -> void:
	var ancestor: Node = get_parent()
	while ancestor != null and not ancestor is Player:
		ancestor = ancestor.get_parent()
	_player = ancestor as Player
	if _player == null:
		push_error("InteractionRay precisa ser filha da câmera de um Player.")
		set_physics_process(false)
		set_process_unhandled_input(false)
		return
	add_exception(_player)
	_prompt.reading_closed.connect(_on_reading_closed)


func _physics_process(_delta: float) -> void:
	_refresh_target()


func _refresh_target() -> void:
	_target = null
	_prompt.set_hint("")
	if _reading or not _player.input_enabled or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	target_position = Vector3(0.0, 0.0, -interaction_distance)
	force_raycast_update()
	if not is_colliding():
		return
	# O primeiro corpo bloqueia o raio, mesmo quando não é interativo (paredes).
	var candidate: Interactable = get_collider() as Interactable
	if is_instance_valid(candidate) and candidate.interaction_enabled:
		_target = candidate
		_prompt.set_hint("E — " + candidate.interaction_hint)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact") or event.is_echo():
		return
	_refresh_target()
	if not is_instance_valid(_target):
		return
	var selected: Interactable = _target
	selected.interact()
	get_viewport().set_input_as_handled()
	# Uma reação pode remover o objeto; não o acesse depois disso.
	if not is_instance_valid(selected) or selected.is_queued_for_deletion():
		return
	if not selected.examination_text.is_empty():
		_previous_input_enabled = _player.input_enabled
		_reading = true
		_player.input_enabled = false
		_prompt.show_reading(selected.examination_text)
		_target = null


func _on_reading_closed() -> void:
	if _reading and is_instance_valid(_player):
		_player.input_enabled = _previous_input_enabled
	_reading = false


func _exit_tree() -> void:
	_on_reading_closed()
