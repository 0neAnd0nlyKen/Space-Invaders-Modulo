extends Area2D
class_name FriendlyWeapon

@export var gunType:int
@export var speed:float
@export var damage:float
@export var fireRate:float
var objHit:Node2D

func _ready() -> void:
	body_entered.connect(_bullet_hit)

func _process(_delta: float) -> void:
	match gunType:
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
	
	position.y += speed
	if (is_instance_valid(objHit) and objHit is Enemy) or position.y < -2000:
		queue_free()

func _bullet_hit(target:Node2D):
	objHit = target
