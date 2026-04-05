extends Area2D
class_name Weapon1

@export var speed:float = -40
@export var damage:float = 5.0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	#translate(Vector2(position.x, speed))
	position.y += speed
	if position.y < -2000:
		queue_free()
