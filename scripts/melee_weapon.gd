extends FriendlyWeapon

@export var rotateSpeed:float = 10
@export var radius:float = 0
var rotateAngle:float = 0
var rotateTimer:float = 0
var doneRotating: bool = false
var count:float = 0
var press

func setup(type:String, pos:Vector2):
	hitbox = $CollisionShape2D
	body_entered.connect(_bullet_hit)
	position = pos
	origin = pos
	wType = type
	match type:
		"sword":
			reach = 170
			damage = 13.0
			fireRate = 0.6
			position.y += (reach/2 + 30)
			radius = -(position.distance_to(pos))
		"saw":
			reach = 140
			damage = 0.3
			fireRate = 0.05
			position.y += -(reach/2 + 10)
			rotateSpeed = -1
		"repulsar":
			reach = 80
			damage = 8.0
			fireRate = 1.0
	

func _physics_process(delta: float) -> void:
	#print_debug(wType)
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
		"saw":
			count += delta
			press = Input.is_action_pressed("fire")
			if press and count >= fireRate:
				DealDamage()
			else:
				damage = 0
			rotate(rotateSpeed)
			if count > 5:
				queue_free()
		

func _bullet_hit(target:Node2D):
	objHit = target

func DealDamage():
	count = 0
	damage = 0.3
