class_name Mecha extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $"../CanvasLayer/Label"
@onready var laser_collision: Area3D = $Laser/Area3D
@onready var forward_cast: ShapeCast3D = $ShapeCast3D
@onready var back_cast: ShapeCast3D = $ShapeCast3D2
@onready var hitbox: MechaHitbox = $Area3D

@export var move_speed := 10.0
@export var rotate_speed := 0.5

static var instance: Mecha

var right_track: float = 0.0
var left_track: float = 0.0
var _rotation: float = 0.0

func shoot() -> void:
	print("PUM!")
	var areas := laser_collision.get_overlapping_areas()
	for area in areas:
		if area is not Damageable:
			continue
		var damageable := area as Damageable
		damageable.damage(1.0)

func fire_laser() -> void:
	animation_player.play("shoot_laser")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self

func _get_inputs(delta: float) -> void:
	if (Input.is_action_pressed("ui_left")):
		right_track += delta
	if (Input.is_action_pressed("ui_right")):
		right_track -= delta
	
	if (Input.is_action_pressed("ui_up")):
		left_track += delta
	if (Input.is_action_pressed("ui_down")):
		left_track -= delta
		
	if (Input.is_action_just_pressed("ui_accept")):
		fire_laser()
	
	right_track = clampf(right_track, -1.0, 1.0)
	left_track = clampf(left_track, -1.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_get_inputs(delta)
	label.text = "left_track: %s\nright_track: %s" % [left_track, right_track]
	var speed := 0.0
	if (right_track > 0.0 && left_track > 0.0):
		speed = minf(right_track, left_track)
	elif (right_track < 0.0 && left_track < 0.0):
		speed = maxf(right_track, left_track)
	speed *= -move_speed
	
	if speed < 0.0 and forward_cast.is_colliding():
		speed = 0.0
	elif speed > 0.0 and back_cast.is_colliding():
		speed = 0.0
	
	_rotation += (right_track - left_track) * delta * rotate_speed
	
	var move_vector: Vector3 = Vector3.FORWARD * speed
	move_vector = move_vector.rotated(Vector3.UP, _rotation)
	
	position += move_vector * delta
	rotation = Vector3(0, _rotation, 0)
