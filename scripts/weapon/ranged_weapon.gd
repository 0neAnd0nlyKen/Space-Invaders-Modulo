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

func setup(type:String, pos:Vector2):
	hitbox = $CollisionShape2D
	body_entered.connect(_bullet_hit)
	body_exited.connect(_left)
	position = pos
	wType = type
	match type:
		"rifle":
			speed = -40
			damage = 3.0
			fireRate = 0.2
		"sniper":
			speed = -100
			damage = 12.0
			fireRate = 1.0
		"shotgun":
			speed = -40
			damage = 2.0
			fireRate = 0.65
		"explosive":
			speed = -20
			damage = 0.0
			fireRate = 1.2
	

func _process(_delta: float) -> void:
	if not meleeWeapons.has(wType):
		position.y += speed
		if (is_instance_valid(objHit) and objHit is Enemy) or position.y < -1000:
			if wType == "explosive":
				var hit:FriendlyWeapon = explosion.instantiate()
				var par = get_parent()
				par.add_child(hit)
				hit.explode(position)
			queue_free()

func _bullet_hit(target:Node2D):
	if is_instance_valid(target) and target is Enemy:
		objHit = target

func _left(target:Node2D):
	pass
