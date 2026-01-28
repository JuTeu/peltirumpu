class_name Fuse extends Interactable

@export var fresh_mesh: Node3D
@export var fried_mesh: Node3D
@export var interactable := true
var _dragged := false
var _target_pos: Vector3
var _target_dis: float

func start_interaction() -> void:
	if not interactable: return
	_dragged = true

func end_interaction() -> void:
	_dragged = false
	_target_dis = 0.0
	_target_pos = Vector3.ZERO
	if not interactable: return

func update(mouse_movement: Vector2, camera: Camera3D) -> void:
	if not interactable: return
	if _target_dis == 0:
		_target_dis = camera.global_position.distance_to(global_position)
	_target_dis -= mouse_movement.y
	_target_dis = clampf(_target_dis, 0.2, 1.0)
	_target_dis = 1.0
	_target_pos = camera.to_global(Vector3.FORWARD * _target_dis)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if not _dragged: return
	if _target_pos == Vector3.ZERO: return
	
	var target_velocity: Vector3 = _target_pos - global_position
	target_velocity *= 5.0
	
	
	linear_velocity = linear_velocity.move_toward(target_velocity, state.step * 30.0)

func fry() -> void:
	freeze = false
	linear_velocity = to_global(Vector3.UP) * 2.0
	fresh_mesh.visible = false
	fried_mesh.visible = true
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	should_lock_camera = false
