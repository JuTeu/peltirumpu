class_name BuildingHitbox extends Damageable
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var health := 2.0

func damage(amount: float) -> void:
	#if health <= 0.0: return
	health -= amount
	if health <= 0.0:
		animation_player.play("get_destroyed")
