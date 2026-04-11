extends Area2D
class_name FriendlyWeapon

@export var speed:float
@export var damage:float
@export var fireRate:float
@export var reach:float
var explosion: = preload("res://scenes/weapons/explosion.tscn")
var origin:Vector2
var wType:String
var oriSpeed:float
var hitbox:CollisionShape2D
var sprite:Sprite2D
var objHit:Node2D
var trueTarget:Node2D
var die:bool = false
var theWorld:bool

const meleeWeapons:Array = ["sword", "saw", "repulsar"]

signal sawblade_off()

func setup(type:String, pos:Vector2, cond:bool):
	hitbox = $CollisionShape2D
	body_entered.connect(_bullet_hit)
	body_exited.connect(_left)
	area_entered.connect(_also_bullet_hit)
	origin = pos
	position = pos
	wType = type
	theWorld = cond
	match type:
		"rifle":
			speed = -1600
			damage = 3.5 + SelectionInstructions.dmgMulti
			fireRate = 0.2 - SelectionInstructions.fireRateUp
		"sniper":
			speed = -2800
			damage = 18.0 + SelectionInstructions.dmgMulti
			fireRate = 1.0 - SelectionInstructions.fireRateUp
		"shotgun":
			speed = -1600
			damage = 2.8 + SelectionInstructions.dmgMulti
			fireRate = 0.75 - SelectionInstructions.fireRateUp
		"explosive":
			speed = -1000
			damage = 0.0
			fireRate = 1.2 - SelectionInstructions.fireRateUp
	oriSpeed = speed

func _physics_process(delta: float) -> void:
	if not meleeWeapons.has(wType):
		if theWorld == true:
			speed = -10
		else:
			speed = oriSpeed
		if wType == "shotgun":
			position += Vector2(0, speed).rotated(rotation) * delta
		else:
			position.y += speed * delta
		
		#position.x = origin.x
		
		if position.y < -1000:
			queue_free()

func explota():
	var hit:FriendlyWeapon = explosion.instantiate()
	var par = get_parent()
	par.add_child(hit)
	hit.explode(position, SelectionInstructions.dmgMulti)

func _bullet_hit(target:Node2D):
	#print_debug("hit")
	if is_instance_valid(target) and target.get_parent() is Enemy:
		#print_debug("body")
		objHit = target
		trueTarget = target.get_parent()
		if wType == "explosive" and target.name != "EnemyProjectile":
			if SelectionInstructions.recast > 0:
				var a:int = 0
				while a < SelectionInstructions.recast:
					explota()
					a+=1
			else:
				explota()
		if target.name != "ShieldNode" and target.name != "EnemyProjectile" and target.name != "BuffArea":
			queue_free()

func _also_bullet_hit(target:Node2D):
	if is_instance_valid(target) and target.get_parent() is Enemy:
		body_entered.emit(target)

func _left(target:Node2D):
	pass

func _on_timeStop(state:bool):
	if state == true:
		theWorld = true
	else:
		theWorld = false
