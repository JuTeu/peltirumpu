class_name DrawerBox extends Interactable

func _ready() -> void:
	should_lock_camera = true
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true

func start_interaction() -> void:
	pass
	#linear_velocity = Vector3.FORWARD * 1.0

func end_interaction() -> void:
	pass
	#slinear_velocity = Vector3.BACK * 1.0

func update(mouse_movement: Vector2, camera: Camera3D) -> void:
	if mouse_movement.y > 0.0 and position.z < -0.3: return
	if mouse_movement.y < 0.0 and position.z > -0.2: return
	linear_velocity += Vector3.FORWARD * clampf(mouse_movement.y, -90.0, 90.0) * 0.01
	linear_velocity.z = clampf(linear_velocity.z, -6.0, 6.0)
