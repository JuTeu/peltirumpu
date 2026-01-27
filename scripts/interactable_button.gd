class_name InteractableButton extends Interactable

signal pressed()

func _ready() -> void:
	should_lock_camera = false

func start_interaction() -> void:
	pressed.emit()

func end_interaction() -> void:
	pass

func update(mouse_movement: Vector2, camera: Camera3D) -> void:
	pass
