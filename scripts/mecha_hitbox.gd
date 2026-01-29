class_name MechaHitbox extends Damageable

signal damaged(amount: float)

var fallen_over := false

func damage(amount: float) -> void:
	#fallen_over = true
	damaged.emit(amount)
