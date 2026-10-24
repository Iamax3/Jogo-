class_name Flashlight
extends SpotLight3D
## Instancie flashlight.tscn como filha de Player/Head/Camera3D.
## A luz aponta para -Z, acompanhando a câmera sem alterar o jogador.
## A bateria só gasta enquanto ligada, inclusive durante leituras.
## Não há recarga nesta tarefa; reiniciar a cena repõe a bateria.

signal toggled(is_on: bool)
signal battery_depleted

## Duração total da bateria ligada, em segundos.
@export_range(1.0, 3600.0, 1.0) var battery_duration: float = 180.0
## Intensidade da luz quando não está piscando.
@export_range(0.0, 16.0, 0.1) var intensity: float = 3.0
## Começa ligada quando a cena entra no jogo.
@export var starts_on: bool = true
## Fração da bateria abaixo da qual a luz começa a piscar (0,2 = 20%).
@export_range(0.01, 1.0, 0.01) var low_battery_threshold: float = 0.2
## Intervalo entre as piscadas, em segundos.
@export_range(0.1, 2.0, 0.05) var flicker_interval: float = 0.6
## Fração de cada intervalo durante a qual a luz fica apagada.
@export_range(0.05, 0.8, 0.05) var flicker_dark_fraction: float = 0.15

var _remaining_seconds: float = 0.0
var _capacity_seconds: float = 0.0
var _switched_on: bool = false
var _flicker_elapsed: float = 0.0
var _player: Player


func _ready() -> void:
	var ancestor: Node = get_parent()
	while ancestor != null and not ancestor is Player:
		ancestor = ancestor.get_parent()
	_player = ancestor as Player
	_capacity_seconds = maxf(battery_duration, 0.0)
	_remaining_seconds = _capacity_seconds
	set_enabled(starts_on)
	_apply_light()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("flashlight") or event.is_echo():
		return
	if is_instance_valid(_player):
		if not _player.input_enabled or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			return
	set_enabled(not _switched_on)
	get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if not _switched_on:
		return
	_remaining_seconds = maxf(_remaining_seconds - delta, 0.0)
	if _remaining_seconds <= 0.0:
		set_enabled(false)
		battery_depleted.emit()
		return
	if get_battery_ratio() <= low_battery_threshold:
		_flicker_elapsed += delta
	else:
		_flicker_elapsed = 0.0
	_apply_light()


## Liga ou desliga sem permitir acender com a bateria vazia.
func set_enabled(enabled: bool) -> void:
	var next_state: bool = enabled and _remaining_seconds > 0.0
	if next_state != _switched_on:
		_switched_on = next_state
		_flicker_elapsed = 0.0
		_apply_light()
		toggled.emit(_switched_on)


func is_enabled() -> bool:
	return _switched_on


## Carga restante entre zero e um, para uma futura interface de bateria.
func get_battery_ratio() -> float:
	if _capacity_seconds <= 0.0:
		return 0.0
	return clampf(_remaining_seconds / _capacity_seconds, 0.0, 1.0)


func _apply_light() -> void:
	visible = _switched_on
	var flicker_multiplier: float = 1.0
	if _switched_on and get_battery_ratio() <= low_battery_threshold:
		var interval: float = maxf(flicker_interval, 0.1)
		var phase: float = fmod(_flicker_elapsed, interval) / interval
		if phase >= 1.0 - clampf(flicker_dark_fraction, 0.0, 0.8):
			flicker_multiplier = 0.0
	light_energy = maxf(intensity, 0.0) * flicker_multiplier
