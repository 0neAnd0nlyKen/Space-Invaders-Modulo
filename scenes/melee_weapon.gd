extends FriendlyWeapon

@export var rotateSpeed:float = 10
@export var radius:float = 0
var rotateAngle:float = 0
var rotateTimer:float = 0
var doneRotating: bool = false

func setup(type:String, pos:Vector2):
	hitbox = $CollisionShape2D
	body_entered.connect(_bullet_hit)
	position = pos
	origin = pos
	wType = type
	match type:
		"sword":
			range = 170
			damage = 13.0
			fireRate = 0.6
			position.y += (range/2 + 30)
			radius = -(position.distance_to(pos))
			#print_debug(PI*2)
		"saw":
			range = 40
			damage = 0.3
			fireRate = 0.05
		"repulsar":
			range = 80
			damage = 8.0
			fireRate = 1.0
	

func _process(delta: float) -> void:
	match wType:
		"sword":
			if rotateTimer > .35:
				doneRotating = true
			if not doneRotating:
				rotateTimer += delta
				rotateAngle += rotateSpeed * delta
				position = Vector2(
					cos(rotateAngle) * radius,
					sin(rotateAngle) * radius
				)
				rotation = (rotateAngle + 29.8)
				print_debug(rotateAngle)
			else:
				queue_free()
		

func _bullet_hit(target:Node2D):
	objHit = target
