extends FriendlyWeapon
var delTime:float = 0.0

func explode(pos:Vector2):
	damage = 20.0
	position = pos

func _process(delta: float) -> void:
	delTime += delta
	if get_parent().name == "player" and delTime > 0.1:
		print_debug(get_parent())
		delTime = 0
		queue_free()
#func _bullet_hit(target:Node2D):
	#print_debug("explota!!")
