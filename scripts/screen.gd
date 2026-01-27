extends MeshInstance3D

@onready var kaiju_sub_viewport: SubViewport = $"../../KaijuSubViewport"
@onready var material: StandardMaterial3D = get_surface_override_material(0)
var _timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.albedo_texture = kaiju_sub_viewport.get_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer += delta
	if _timer > 0.1:
		_timer = 0.0
		kaiju_sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
