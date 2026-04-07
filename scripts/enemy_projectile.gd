extends Area2D
class_name EnemyProjectile

@export var damage: int = 5
@export var lifetime: float = 10.0
var velocity: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	position += velocity * delta
	time_alive += delta
	
	if time_alive >= lifetime:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	# Hit the player or player shield
	if area.is_in_group("player"):
		queue_free()