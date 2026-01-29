class_name StatusLight extends Node3D

@onready var _light_on: MeshInstance3D = $MeshInstance3D2
@onready var _light_off: MeshInstance3D = $MeshInstance3D3

var powered: bool:
	set(value):
		_light_off.visible = not value
		_light_on.visible = value
	get:
		return _light_on.visible
