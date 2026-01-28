class_name FuseBox extends Node3D

var good_fuses: int = 3
@export var right_fuse: Fuse
@export var middle_fuse: Fuse
@export var left_fuse: Fuse

@onready var area_3d_middle_fuse: Area3D = $Area3DMiddleFuse
@onready var area_3d_left_fuse: Area3D = $Area3DLeftFuse
@onready var area_3d_right_fuse: Area3D = $Area3DRightFuse

@onready var right_fuse_pos := right_fuse.position
@onready var middle_fuse_pos := middle_fuse.position
@onready var left_fuse_pos := left_fuse.position

@onready var right_fuse_rot := right_fuse.rotation
@onready var middle_fuse_rot := middle_fuse.rotation
@onready var left_fuse_rot := left_fuse.rotation


func fry() -> void:
	good_fuses -= 1
	var random := randi_range(0, 2)
	if not right_fuse and random == 0: random = 1
	if not middle_fuse and random == 1: random = 2
	if not left_fuse and random == 2: random = 0
	
	if not right_fuse and random == 0:
		good_fuses += 1
		return 
	
	match random:
		0:
			right_fuse.fry()
			right_fuse = null
		1:
			middle_fuse.fry()
			middle_fuse = null
		2:
			left_fuse.fry()
			left_fuse = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d_left_fuse.body_entered.connect(left_area_entered)
	area_3d_right_fuse.body_entered.connect(right_area_entered)
	area_3d_middle_fuse.body_entered.connect(middle_area_entered)

func left_area_entered(body: Node3D) -> void:
	var fuse := body as Fuse
	if left_fuse: return
	fuse.interactable = false
	fuse.freeze = true
	left_fuse = fuse
	fuse.position = left_fuse_pos
	fuse.rotation = left_fuse_rot
	good_fuses += 1

func middle_area_entered(body: Node3D) -> void:
	var fuse := body as Fuse
	if middle_fuse: return
	fuse.interactable = false
	fuse.freeze = true
	middle_fuse = fuse
	fuse.position = middle_fuse_pos
	fuse.rotation = middle_fuse_rot
	good_fuses += 1

func right_area_entered(body: Node3D) -> void:
	var fuse := body as Fuse
	if right_fuse: return
	fuse.interactable = false
	fuse.freeze = true
	right_fuse = fuse
	fuse.position = right_fuse_pos
	fuse.rotation = right_fuse_rot
	good_fuses += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
