extends FriendlyWeapon

@export var rotateSpeed:float = 10
@export var radius:float = 0
var rotateAngle:float = 0
var rotateTimer:float = 0
var doneRotating: bool = false
var count:float = 0
var press
var enemies:Array = []
var enemySpeed

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
			fireRate = 1.0
			position.y += (reach/2 + 30)
			radius = -(position.distance_to(pos))
		"saw":
			reach = 140
			damage = 0.2
			fireRate = 0.1
			position.y += -(reach/2 + 20)
			rotateSpeed = -1
			sprite = $Sprite
		"repulsar":
			reach = 180
			damage = 8.0
			fireRate = 0.8
			#position.y += -(reach/2 + 10)
	

func _physics_process(delta: float) -> void:
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
			else:
				queue_free()
		"saw":
			count += delta
			press = Input.is_action_pressed("fire")
			if press and count >= fireRate:
				for enemy in enemies:
					if not is_instance_valid(enemy):
						enemies.erase(enemy)
						continue
					if enemy.name != "Body":
						enemy.take_damage(damage)
			sprite.rotate(rotateSpeed)
			if count > 1 and not press:
				sawblade_off.emit()
				queue_free()
		"repulsar":
			count += delta
			if count > .2:
				queue_free()
		

func _bullet_hit(target:Node2D):
	if is_instance_valid(target) and target is Enemy:
		enemies.append(target)
		enemySpeed = target.base_speed
		match wType:
			"saw":
				if target.base_speed > (target.base_speed * 7)/ 10:
					target.base_speed = (target.base_speed * 7)/ 10
			"repulsar":
				target.position.y -= 100

func _left(target:Node2D):
	if target.base_speed < enemySpeed:
		target.base_speed = enemySpeed
	enemies.erase(target)
