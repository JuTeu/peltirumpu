@abstract
class_name Interactable extends RigidBody3D

var should_lock_camera: bool

@abstract
func start_interaction() -> void

@abstract
func end_interaction() -> void

@abstract
func update(mouse_movement: Vector2, camera: Camera3D) -> void
