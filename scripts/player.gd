class_name Player extends Node3D

@onready var ray_cast: RayCast3D = $Camera3D/RayCast3D
@onready var camera: Camera3D = $Camera3D
var rot_x := 0.0
var rot_y := 0.0
var camera_locked := false
var mouse_movement: Vector2
var interactable: Interactable
var mouse_just_pressed: bool
var mouse_just_released: bool

func _ready() -> void:
	pass
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func start_interact() -> void:
	var new_interactable := ray_cast.get_collider() as Interactable
	if (not new_interactable): return
	new_interactable.start_interaction()
	if new_interactable.should_lock_camera:
		camera_locked = true
	interactable = new_interactable

func end_interact() -> void:
	interactable.end_interaction()
	camera_locked = false
	interactable = null

func _process(delta: float) -> void:
	camera.rotation = Vector3(-rot_y, -rot_x, 0.0)
	if (mouse_just_pressed):
		start_interact()
	if (mouse_just_released and interactable):
		end_interact()
	if (interactable):
		interactable.update(mouse_movement, camera)
	
	mouse_just_pressed = false
	mouse_just_released = false
	mouse_movement = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_event := event as InputEventMouseMotion
		mouse_movement = mouse_event.screen_relative
		if not camera_locked:
			rot_x += mouse_event.screen_relative.x * 0.004
			rot_y += mouse_event.screen_relative.y * 0.004
			rot_y = clampf(rot_y, -1.5, 1.5)
	
	if event is InputEventKey:
		if (event as InputEventKey).keycode == Key.KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			return
		var mouse_button := event as InputEventMouseButton
		if mouse_button.button_index != MouseButton.MOUSE_BUTTON_LEFT:
			return
		if mouse_button.pressed:
			mouse_just_pressed = true
		else:
			mouse_just_released = true
		#if not mouse_pressed and mouse_button.pressed:
		#	mouse_just_pressed = true
