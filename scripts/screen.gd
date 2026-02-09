class_name Screen extends MeshInstance3D

var powered: bool:
	get:
		return _powered
	set(value):
		_powered = value
		if _tween:
			_tween.kill()
		_tween = create_tween()
		if value:
			_tween.tween_method(_change_screen_status_progress, _material.get_shader_parameter("progress"), 0.0, 1.0)
			#_material.albedo_color = Color.WHITE
		else:
			#_material.albedo_color = Color.BLACK
			_tween.tween_method(_change_screen_status_progress, _material.get_shader_parameter("progress"), 1.0, 1.0)
var _powered := true
var _tween: Tween
@onready var _kaiju_sub_viewport: SubViewport = $"../../KaijuSubViewport"
@onready var _material: ShaderMaterial = get_surface_override_material(0)
var _timer := 0.0

func _change_screen_status_progress(progress: float) -> void:
	_material.set_shader_parameter("progress", progress)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_material.set_shader_parameter("tex", _kaiju_sub_viewport.get_texture())
	#_material.albedo_texture = _kaiju_sub_viewport.get_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer += delta
	if _timer > 0.1:
		_timer = 0.0
		_kaiju_sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
