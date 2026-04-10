extends Area2D
class_name FriendlyWeapon

@export var speed:float
@export var damage:float
@export var fireRate:float
@export var reach:float
var explosion: = preload("res://scenes/weapons/explosion.tscn")
var origin:Vector2
var wType:String
var hitbox:CollisionShape2D
var sprite:Sprite2D
var objHit:Node2D
var die:bool = false

const meleeWeapons:Array = ["sword", "saw", "repulsar"]

signal sawblade_off()

func setup(type:String, pos:Vector2):
	hitbox = $CollisionShape2D
	body_entered.connect(_bullet_hit)
	body_exited.connect(_left)
	area_entered.connect(_also_bullet_hit)
	origin = pos
	position = pos
	wType = type
	match type:
		"rifle":
			speed = -1600
			damage = 3.0 + SelectionInstructions.dmgMulti
			fireRate = 0.2 - SelectionInstructions.fireRateUp
		"sniper":
			speed = -2800
			damage = 12.0 + SelectionInstructions.dmgMulti
			fireRate = 1.0 - SelectionInstructions.fireRateUp
		"shotgun":
			speed = -1600
			damage = 1.8 + SelectionInstructions.dmgMulti
			fireRate = 0.75 - SelectionInstructions.fireRateUp
		"explosive":
			speed = -1000
			damage = 0.0
			fireRate = 1.2 - SelectionInstructions.fireRateUp
	

func _physics_process(delta: float) -> void:
	if not meleeWeapons.has(wType):
		if wType == "shotgun":
			position += Vector2(0, speed).rotated(rotation) * delta
		else:
			position.y += speed * delta
		#position.x = origin.x
		if (is_instance_valid(objHit) and objHit is Enemy) or position.y < -1000:
			if wType == "explosive":
				if SelectionInstructions.recast > 0:
					var a:int = 0
					while a < SelectionInstructions.recast:
						explota()
						a+=1
				else:
					explota()
				
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
		objHit = target.get_parent()

func _also_bullet_hit(target:Node2D):
	if is_instance_valid(target) and target.get_parent() is Enemy:
		body_entered.emit(target)

func _left(target:Node2D):
	pass
