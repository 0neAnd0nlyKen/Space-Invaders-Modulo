extends CharacterBody2D
class_name Enemy

@onready var hitbox:Area2D = $Area2D
@export var speed:float = 30
var health:int = 15

func _ready() -> void:
	if hitbox == null:
		hitbox = $CollisionShape2D

func _process(_delta: float) -> void:
	velocity.y = 50
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Weapon1:
		health -= area.damage
		if health <= 0:
			queue_free()
		#print_debug("health is ", health)
	#print_debug(area.name)
