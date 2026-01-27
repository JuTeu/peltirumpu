class_name Cockpit extends Node3D

@onready var lever: Lever = $Lever
@onready var lever_2: Lever = $Lever2
@onready var interactable_button: InteractableButton = $InteractableButton

var _mecha: Mecha
var _right_thread: float
var _left_thread: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_mecha = Mecha.instance
	lever.value_changed.connect(_right_thread_lever)
	lever_2.value_changed.connect(_left_thread_lever)
	interactable_button.pressed.connect(_button_pressed)

func _process(delta: float) -> void:
	if not _mecha: return
	_mecha.left_track = _left_thread
	_mecha.right_track = _right_thread

func _button_pressed() -> void:
	_mecha.fire_laser()

func _right_thread_lever(value: float) -> void:
	if (absf(value) > 0.1):
		_right_thread = value
	else:
		_right_thread = 0.0

func _left_thread_lever(value: float) -> void:
	if (absf(value) > 0.1):
		_left_thread = value
	else:
		_left_thread = 0.0
