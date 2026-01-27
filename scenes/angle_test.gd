extends MeshInstance3D

@onready var targ: MeshInstance3D = $"../MeshInstance3D2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var angle := Vector3.FORWARD.signed_angle_to(targ.global_position - global_position, Vector3.UP)
	rotation = Vector3(0.0, angle, 0.0)
