class_name GeneratorPlug extends Node3D

@onready var _offline: Label3D = $Offline
@onready var _ok: Label3D = $OK
@onready var plug: Plug = $Plug

var has_power: bool:
	get:
		return _powered
	set(value):
		_powered = value
		_ok.visible = value
		_offline.visible = not value
		plug.has_power = value

var _powered := true
