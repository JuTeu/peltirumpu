class_name PlugSocket extends Area3D

var has_plug: bool
var _powered := false
var powered: bool:
	get:
		return _powered
	set(value):
		_powered = value
		powered_state_changed.emit(value)

signal powered_state_changed(value: bool)
