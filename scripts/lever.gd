class_name Lever extends Interactable

@onready var _shaft: Node3D = $Shaft
var _value: float = 0.0
signal value_changed(value: float)

func _ready() -> void:
	should_lock_camera = true

func start_interaction() -> void:
	pass

func end_interaction() -> void:
	pass

func update(mouse_movement: Vector2, camera: Camera3D) -> void:
	_value -= mouse_movement.y * 0.005
	_value = clampf(_value, -1.0, 1.0)
	_shaft.rotation = Vector3(0.0, 0.0, _value)
	value_changed.emit(_value)# * _value * (-1.0 if _value < 0.0 else 1.0))
