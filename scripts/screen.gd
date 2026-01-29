class_name Screen extends MeshInstance3D

var powered: bool:
	get:
		return _powered
	set(value):
		_powered = value
		if value:
			_material.albedo_color = Color.WHITE
		else:
			_material.albedo_color = Color.BLACK
var _powered := true
@onready var _kaiju_sub_viewport: SubViewport = $"../../KaijuSubViewport"
@onready var _material: StandardMaterial3D = get_surface_override_material(0)
var _timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_material.albedo_texture = _kaiju_sub_viewport.get_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer += delta
	if _timer > 0.1:
		_timer = 0.0
		_kaiju_sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
