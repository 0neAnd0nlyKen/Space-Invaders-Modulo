extends Area2D
class_name FriendlyWeapon

@export var speed:float
@export var damage:float
@export var fireRate:float
var objHit:Node2D

func setup(type:String, pos:Vector2):
	body_entered.connect(_bullet_hit)
	position = pos
	match type:
		0:
			speed = -40
			damage = 3.0
			fireRate = 0.2
		1:
			speed = -100
			damage = 12.0
			fireRate = 1.0
		2:
			speed = -40
			damage = 2.0
			fireRate = 0.65

func _process(_delta: float) -> void:
	
	position.y += speed
	if (is_instance_valid(objHit) and objHit is Enemy) or position.y < -2000:
		queue_free()

func _bullet_hit(target:Node2D):
	objHit = target
