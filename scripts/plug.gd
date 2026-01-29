class_name Plug extends Interactable

@onready var _plug_model: Node3D = $PlugModel
@onready var _line_model: MeshInstance3D = $LineModel
@onready var _socket_cast: ShapeCast3D = $ShapeCast3D
@onready var _collision_shape: CollisionShape3D = $CollisionShape3D

var has_power: bool:
	get:
		return _has_power
	set(value):
		_has_power = value
		if _plug_socket:
			_plug_socket.powered = value
var socket: PlugSocket:
	get:
		return _plug_socket
	set(value):
		if _plug_socket:
			_plug_socket.powered = false
			_plug_socket.has_plug = false
		_plug_socket = value
		if _plug_socket:
			_collision_shape.global_position = _plug_socket.global_position
			_plug_socket.powered = has_power
			_plug_socket.has_plug = true
var _plug_socket: PlugSocket
var _has_power := true
var _dragging := false
var _target_position: Vector3
var _rot_tween: Tween
var _flipped := false

func _ready() -> void:
	should_lock_camera = false
	if not _target_position:
		_target_position = global_position

func start_interaction() -> void:
	_dragging = true

func end_interaction() -> void:
	_dragging = false
	if not _plug_socket:
		_target_position = global_position
	else:
		_target_position = _plug_socket.global_position
	_collision_shape.global_position = _target_position

func _get_plug_position(camera: Node3D) -> Vector3:
	var point := global_position + Vector3.BACK * 0.07
	var plane_normal := to_global(Vector3.FORWARD) - global_position
	var ray_origin := camera.global_position
	var ray_dir := camera.to_global(Vector3.FORWARD) - ray_origin
	
	var denom := plane_normal.dot(ray_dir)
	if denom < 0.001: return Vector3.ZERO
	var distance := plane_normal.dot(point - ray_origin) / denom
	return ray_origin + ray_dir * distance

func update(mouse_movement: Vector2, camera: Camera3D) -> void:
	_target_position = _get_plug_position(camera)
	if _target_position.distance_squared_to(global_position) > 0.25:
		var dir := (_target_position - global_position).normalized()
		_target_position = global_position + dir * 0.5
	_socket_cast.global_position = _target_position
	if _socket_cast.is_colliding():
		var new_socket := _socket_cast.get_collider(0) as PlugSocket
		if not new_socket.has_plug:
			socket = new_socket
		elif new_socket != _plug_socket:
			socket = null
	else:
		socket = null
func flip(should_flip: bool, flip_to_up: bool = true) -> void:
	if _rot_tween: _rot_tween.kill()
	_rot_tween = create_tween()
	if should_flip:
		if flip_to_up:
			_rot_tween.tween_property(_plug_model, "rotation", Vector3(-PI + 0.01, 0.0, 0.0), 0.25)
		else:
			_rot_tween.tween_property(_plug_model, "rotation", Vector3(PI - 0.01, 0.0, 0.0), 0.25)
	else:
		_rot_tween.tween_property(_plug_model, "rotation", Vector3(0.0, 0.0, 0.0), 0.25)

func _process(delta: float) -> void:
	var target := _plug_socket.global_position if _plug_socket else _target_position
	_plug_model.global_position = _plug_model.global_position.move_toward(target, delta * 20.0 * _plug_model.global_position.distance_to(target))
	_line_model.global_position = global_position.lerp(_plug_model.global_position, 0.5)
	_line_model.rotation = Vector3(0.0, 0.0, Vector2(_plug_model.position.x, _plug_model.position.y).angle() + PI / 2.0)
	_line_model.scale = Vector3(0.02, _plug_model.position.distance_to(Vector3.ZERO) * 0.5, 0.02)
	if absf(_plug_model.global_position.y - global_position.y) < 0.1 and _flipped:
		flip(false)
		_flipped = false
	elif absf(_plug_model.global_position.y - global_position.y) > 0.1 and not _flipped:
		flip(true, _plug_model.global_position.y > global_position.y)
		_flipped = true
