extends FriendlyWeapon

@export var rotateSpeed:float = 10
@export var radius:float = 0
var rotateAngle:float = 0
var rotateTimer:float = 0
var doneRotating: bool = false
var count:float = 0
var throwSpeed:float = 15
var press
var enemies:Array = []
var enemySpeed

func setup(type:String, pos:Vector2, cond:bool):
	hitbox = $CollisionShape2D
	body_entered.connect(_bullet_hit)
	body_exited.connect(_left)
	area_entered.connect(_also_bullet_hit)
	position = pos
	origin = pos
	wType = type
	theWorld = cond
	match type:
		"sword":
			reach = 170
			damage = 16.0 + SelectionInstructions.dmgMulti
			fireRate = 1.0 - SelectionInstructions.fireRateUp
			position.y += (reach/2 + 30)
			radius = -(position.distance_to(pos))
		"saw":
			reach = 140
			damage = 0.3 + (SelectionInstructions.dmgMulti * 0.5)
			fireRate = 0.04 - (SelectionInstructions.fireRateUp * 0.5)
			position.y += -(reach/2 + 20)
			rotateSpeed = -1
			sprite = $Sprite
		"repulsar":
			reach = 180
			damage = 10.0 + SelectionInstructions.dmgMulti
			fireRate = 0.8 - SelectionInstructions.fireRateUp
			#position.y += -(reach/2 + 10)
	

func _physics_process(delta: float) -> void:
	if theWorld:
		rotateSpeed = 0.1
		throwSpeed = -1
	else:
		rotateSpeed = 10
		throwSpeed = -1
	match wType:
		"sword":
			if not SelectionInstructions.throw:
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
			else:
				throwSword()
		"saw":
			count += delta
			if SelectionInstructions.throw:
				sawThrow()
			else:
				sawNormal()
		"repulsar":
			count += delta
			if count > .2:
				queue_free()

func throwSword():
	rotate(.3)
	position.y -= throwSpeed
	position.x = origin.x
	if position.y < -1000:
		queue_free()

func sawNormal():
	press = Input.is_action_pressed("fire")
	if press and count >= fireRate:
		for enemy in enemies:
			if not is_instance_valid(enemy):
				enemies.erase(enemy)
				#queue_free()
				continue
			enemy.take_damage(damage)
			print_debug(damage)
		count = 0
	sprite.rotate(rotateSpeed)
	if count > 1:
		sawblade_off.emit()
		queue_free()

func sawThrow():
	position.y -= throwSpeed
	position.x = origin.x
	if count >= fireRate:
		for enemy in enemies:
			if not is_instance_valid(enemy):
				enemies.erase(enemy)
				continue
			if enemy is not Player:
				enemy.take_damage(damage)
				count = 0
	sprite.rotate(rotateSpeed)
	if position.y < -1000:
		sawblade_off.emit()
		queue_free()

func _bullet_hit(target:Node2D):
	#trueTarget = target.get_parent()
	if is_instance_valid(target) and target.get_parent() is Enemy:
		trueTarget = target.get_parent()
		enemies.append(trueTarget)
		enemySpeed = trueTarget.base_speed
		match wType:
			"saw":
				if trueTarget.base_speed > (trueTarget.base_speed * 7)/ 10:
					trueTarget.base_speed = (trueTarget.base_speed * 7)/ 10
			"repulsar":
				trueTarget.position.y -= 100

func _also_bullet_hit(target:Node2D):
	if is_instance_valid(target) and target.get_parent() is Enemy:
		body_entered.emit(target)

func _left(target:Node2D):
	trueTarget = target.get_parent()
	if is_instance_valid(target) and trueTarget is Enemy:
		if trueTarget.base_speed < enemySpeed:
			trueTarget.base_speed = enemySpeed
	enemies.erase(trueTarget)

func _on_timeStop(state:bool):
	if state == true:
		theWorld = true
	else:
		theWorld = false
