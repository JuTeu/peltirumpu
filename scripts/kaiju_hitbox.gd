class_name KaijuHitbox extends Damageable

signal damaged(amount: float)

func damage(amount: float) -> void:
	damaged.emit(amount)
