extends Node3D

@onready var model: Node3D = $Model
@onready var cast_for_targets: ShapeCast3D = $CastForTargets
@onready var cast_for_punchables: ShapeCast3D = $CastForPunchables
@onready var hitbox: KaijuHitbox = $Area3D

var _rotation: float
var _punch_cooldown: float
var _player_aggro_cooldown: float
var _target: Node3D
var _health: float = 10.0
var _anger_treshold: float = 8.001
var _damaged_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.damaged.connect(damaged)

func _get_mecha() -> Node3D:
	for i in cast_for_targets.get_collision_count():
		var collision := cast_for_targets.get_collider(i)
		if collision is not MechaHitbox:
			continue
		return collision
	return null

func damaged(amount: float) -> void:
	_health -= amount
	var material: StandardMaterial3D = $Model/MeshInstance3D4.get_surface_override_material(0)
	if _damaged_tween:
		_damaged_tween.kill()
	_damaged_tween = create_tween()
	_damaged_tween.tween_property(material, "albedo_color", Color.ALICE_BLUE, 0.1)
	_damaged_tween.tween_property(material, "albedo_color", Color.RED, 0.1)
	if _anger_treshold > _health and _player_aggro_cooldown <= 0.0:
		_target = _get_mecha()
		_anger_treshold -= 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _health <= 0.0:
		model.rotation = Vector3(0, 0, PI / 2.0)
		return
	
	_player_aggro_cooldown -= delta
	
	for i in cast_for_punchables.get_collision_count():
		var collider := cast_for_punchables.get_collider(i)
		if collider is Damageable:
			if collider is MechaHitbox:
				if (collider as MechaHitbox).fallen_over: continue
				if _player_aggro_cooldown > 0.0: continue
			model.rotation = Vector3(0, 0, sin(Time.get_unix_time_from_system() * 10.0) * 0.3)
			if _punch_cooldown > 0.0:
				_punch_cooldown -= delta
				return
			var damageable := collider as Damageable
			damageable.damage(0.5)
			_punch_cooldown += 2.0
			if damageable is MechaHitbox and _target is MechaHitbox:
				_player_aggro_cooldown = 5.0
				_target = null
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
	global_position += move_vector * delta * 0.3 * (2.0 if _target is MechaHitbox else 1.0)
	
	rotation = Vector3(0.0, _rotation, 0.0)
	model.rotation = Vector3(0.0, sin(Time.get_unix_time_from_system() * 10.0) * 0.3, 0.0)
	#print(_target.get_parent_node_3d().name)
	#print(global_position.distance_to(_target.global_position))
	
	if _target is BuildingHitbox:
		var building := _target as BuildingHitbox
		if building.health <= 0.0: _target = null
