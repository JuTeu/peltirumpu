class_name LightBulb extends OmniLight3D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var powered: bool:
	get:
		return _powered
	set(value):
		if value != _powered:
			_animation_player.play("power_on" if value else "power_off")
		_powered = value

var _powered := true
