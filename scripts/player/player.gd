class_name Player
extends CharacterBody3D
## Jogador em primeira pessoa: andar, olhar com o mouse e agachar.
##
## API pública (para outras cenas e para o Codex):
## - sinal [signal stepped]: emitido a cada passo. Use para tocar som de passo.
## - sinal [signal crouch_changed]: emitido ao agachar ou levantar.
## - [member camera]: a câmera do jogador. Coisas que devem seguir o olhar
##   (lanterna, RayCast3D de interação) entram como filhas dela.
## - [member input_enabled]: desligue durante conversas e menus para travar o jogador.
## - [method is_crouching]: diz se o jogador está agachado.
##
## Teclas: WASD anda, mouse olha, Ctrl (segurar) agacha, Esc solta o mouse,
## clique na tela captura o mouse de novo.

## Emitido a cada passo dado.
signal stepped
## Emitido quando o jogador agacha (true) ou levanta (false).
signal crouch_changed(crouching: bool)

@export_group("Movimento")
## Velocidade andando, em metros por segundo. Devagar combina com terror.
@export var walk_speed: float = 2.2
## Velocidade agachado, em metros por segundo.
@export var crouch_speed: float = 1.1
## Quão rápido o jogador acelera e freia. Valores menores dão sensação de peso.
@export var acceleration: float = 8.0

@export_group("Câmera")
## Sensibilidade do mouse.
@export_range(0.01, 1.0) var mouse_sensitivity: float = 0.12
## Quanto o jogador pode olhar para cima e para baixo, em graus.
@export_range(30.0, 89.0) var max_look_angle: float = 85.0

@export_group("Agachar")
## Altura dos olhos em pé, em metros.
@export var stand_eye_height: float = 1.6
## Altura dos olhos agachado, em metros.
@export var crouch_eye_height: float = 0.95
## Velocidade da transição entre em pé e agachado.
@export var crouch_transition_speed: float = 6.0

@export_group("Passos")
## Distância entre um passo e outro, em metros. Maior = passos mais pesados.
@export var step_distance: float = 0.85
## Liga ou desliga o balanço da câmera ao andar.
@export var head_bob_enabled: bool = true
## Quanto a câmera desce a cada passo, em metros.
@export var head_bob_amount: float = 0.035

## Altura do corpo (cápsula de colisão) em pé e agachado.
const STAND_BODY_HEIGHT: float = 1.8
const CROUCH_BODY_HEIGHT: float = 1.1

## Quando falso, o jogador não anda nem olha (use em conversas e menus).
var input_enabled: bool = true:
	set(value):
		input_enabled = value
		if not input_enabled:
			velocity.x = 0.0
			velocity.z = 0.0

var _crouching: bool = false
var _eye_height: float = 1.6
var _step_progress: float = 0.0
var _steps_taken: int = 0
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var _collision: CollisionShape3D = $CollisionShape3D
@onready var _body_shape: CapsuleShape3D = $CollisionShape3D.shape
@onready var _ceiling_check: ShapeCast3D = $CeilingCheck


func _ready() -> void:
	_eye_height = stand_eye_height
	_set_body_height(STAND_BODY_HEIGHT)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return

	if event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return

	if not input_enabled or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		rotate_y(deg_to_rad(-motion.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-motion.relative.y * mouse_sensitivity))
		var limit: float = deg_to_rad(max_look_angle)
		head.rotation.x = clampf(head.rotation.x, -limit, limit)


func _physics_process(delta: float) -> void:
	_update_crouch(delta)

	if not is_on_floor():
		velocity.y -= _gravity * delta

	var input_dir := Vector2.ZERO
	if input_enabled:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	var speed: float = crouch_speed if _crouching else walk_speed
	var weight: float = minf(acceleration * delta, 1.0)
	velocity.x = lerpf(velocity.x, direction.x * speed, weight)
	velocity.z = lerpf(velocity.z, direction.z * speed, weight)

	move_and_slide()
	_update_steps_and_bob(delta)


## Retorna true se o jogador está agachado.
func is_crouching() -> bool:
	return _crouching


func _update_crouch(delta: float) -> void:
	var wants_crouch: bool = input_enabled and Input.is_action_pressed("crouch")
	# Só levanta se não houver teto em cima.
	var should_crouch: bool = wants_crouch or (_crouching and _ceiling_check.is_colliding())
	if should_crouch != _crouching:
		_crouching = should_crouch
		_set_body_height(CROUCH_BODY_HEIGHT if _crouching else STAND_BODY_HEIGHT)
		crouch_changed.emit(_crouching)

	var target_eye: float = crouch_eye_height if _crouching else stand_eye_height
	_eye_height = lerpf(_eye_height, target_eye, minf(crouch_transition_speed * delta, 1.0))


func _set_body_height(height: float) -> void:
	_body_shape.height = height
	_collision.position.y = height / 2.0
	# O detector de teto tem a largura do corpo: parte do topo do corpo agachado
	# e varre até a altura em pé, para não levantar com parte do corpo sob um obstáculo.
	var check_shape := _ceiling_check.shape as CylinderShape3D
	_ceiling_check.position.y = CROUCH_BODY_HEIGHT - check_shape.height / 2.0
	_ceiling_check.target_position = Vector3(0.0, STAND_BODY_HEIGHT - CROUCH_BODY_HEIGHT + 0.05, 0.0)


func _update_steps_and_bob(delta: float) -> void:
	var horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	var moving: bool = is_on_floor() and horizontal_speed > 0.3

	if moving:
		_step_progress += horizontal_speed * delta
		var steps_now: int = floori(_step_progress / step_distance)
		if steps_now > _steps_taken:
			_steps_taken = steps_now
			stepped.emit()
	else:
		# Volta suavemente para o fim do passo atual, sem contar um passo novo.
		var rest: float = ceilf(_step_progress / step_distance) * step_distance
		_step_progress = move_toward(_step_progress, rest, horizontal_speed * delta + 0.5 * delta)

	var bob: float = 0.0
	if head_bob_enabled:
		bob = absf(sin(_step_progress / step_distance * PI)) * head_bob_amount
	head.position.y = _eye_height - bob
