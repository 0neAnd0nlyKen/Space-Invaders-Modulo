extends CharacterBody2D
class_name Enemy

@export var hitbox:Area2D
@export var speed:float = 30
var health:int = 15

@export var enemy_score: int = 100  # Each enemy can have different score values

signal enemy_defeated(score_value: int)

func die():
	# When enemy dies (collision, health reaches 0, etc.)
	enemy_defeated.emit(enemy_score)
	queue_free()  # Remove the enemy from the scene

func _ready() -> void:
	if hitbox == null:
		hitbox = $CollisionShape2D

func _process(_delta: float) -> void:
	velocity.y = 50
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is FriendlyWeapon:
		health -= area.damage
		if health <= 0:
			die()
		#print_debug("health is ", health)
	#print_debug(area.name)
