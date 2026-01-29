extends Node3D

@onready var model: Node3D = $Model
@onready var cast_for_targets: ShapeCast3D = $CastForTargets
@onready var cast_for_punchables: ShapeCast3D = $CastForPunchables
@onready var hitbox: KaijuHitbox = $Area3D

var _rotation: float
var _punch_cooldown: float
var _target: Node3D
var _health: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.damaged.connect(damaged)

func damaged(amount: float) -> void:
	_health -= amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _health <= 0.0:
		model.rotation = Vector3(0, 0, PI / 2.0)
		return
	
	for i in cast_for_punchables.get_collision_count():
		var collider := cast_for_punchables.get_collider(i)
		if collider is Damageable:
			model.rotation = Vector3(0, 0, sin(Time.get_unix_time_from_system() * 10.0) * 0.3)
			if _punch_cooldown > 0.0:
				_punch_cooldown -= delta
				return
			var damageable := collider as Damageable
			damageable.damage(0.5)
			_punch_cooldown += 2.0
			return
	_punch_cooldown = 0.0
	
	if not _target:
		var candinates: Array[BuildingHitbox]
		for i in cast_for_targets.get_collision_count():
			var collision := cast_for_targets.get_collider(i)
			if collision is not BuildingHitbox:
				continue
			candinates.append(collision as BuildingHitbox)
		_target = candinates[randi_range(0, candinates.size() - 1)]
	if not _target: return
	var angle_to_target := Vector3.FORWARD.signed_angle_to(_target.global_position - global_position, Vector3.UP)
	
	_rotation = move_toward(_rotation, angle_to_target, delta)
	
	var move_vector: Vector3 = Vector3.FORWARD
	move_vector = move_vector.rotated(Vector3.UP, _rotation)
	global_position += move_vector * delta * 0.3
	
	rotation = Vector3(0.0, _rotation, 0.0)
	model.rotation = Vector3(0.0, sin(Time.get_unix_time_from_system() * 10.0) * 0.3, 0.0)
	#print(_target.get_parent_node_3d().name)
	#print(global_position.distance_to(_target.global_position))
	
	if _target is BuildingHitbox:
		var building := _target as BuildingHitbox
		if building.health <= 0.0: _target = null
