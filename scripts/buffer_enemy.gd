extends Enemy
class_name BufferEnemy

@export var speed_multiplier: float = 1.3
@onready var movement_speed: float

func _ready() -> void:
	movement_speed = base_speed * speed_multiplier

func _on_buff_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.base_speed *= speed_multiplier
		body.buff_aura.visible = true


func _on_buff_area_body_exited(body: Node2D) -> void:
	if body is Enemy:
		body.base_speed /= speed_multiplier
		# Remove buff aura from the enemy
		body.buff_aura.visible = false
		#for child in body.get_children():
			#if child is Sprite2D and child.name == buff_aura.name:
				#child.queue_free()
