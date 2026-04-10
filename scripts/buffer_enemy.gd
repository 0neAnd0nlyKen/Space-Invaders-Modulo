extends Enemy
class_name BufferEnemy

@export var speed_multiplier: float = 1.5
@onready var movement_speed: float
@export var buff_aura: Sprite2D

func _ready() -> void:
	movement_speed = base_speed * speed_multiplier

func _on_buff_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.base_speed *= speed_multiplier
		# Add buff aura to the enemy
		if buff_aura:
			var aura_copy = buff_aura.duplicate()
			aura_copy.visible = true
			body.add_child(aura_copy)


func _on_buff_area_body_exited(body: Node2D) -> void:
	if body is Enemy:
		body.base_speed /= speed_multiplier
		# Remove buff aura from the enemy
		for child in body.get_children():
			if child is Sprite2D and child.name == buff_aura.name:
				child.queue_free()
