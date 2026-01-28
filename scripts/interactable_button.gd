class_name InteractableButton extends Interactable

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

signal pressed()

func _ready() -> void:
	should_lock_camera = false

func start_interaction() -> void:
	_animation_player.play("RESET")
	_animation_player.play("pressed")
	pressed.emit()

func end_interaction() -> void:
	pass

func update(mouse_movement: Vector2, camera: Camera3D) -> void:
	pass
