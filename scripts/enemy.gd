extends CharacterBody2D
class_name Enemy

@export var hitbox: Area2D
@export var max_health: float = 15
@export var enemy_score: int = 100
@export var base_speed: float = 30
@export var animated_sprite: AnimatedSprite2D

var health: float
var time_alive: float = 0.0

signal enemy_defeated(score_value: float)
signal enemy_landed(enemy_health: float)


func _ready() -> void:
	health = max_health
	
	# Connect damage detection
	if hitbox and hitbox.area_entered.is_connected(_on_area_2d_area_entered) == false:
		hitbox.area_entered.connect(_on_area_2d_area_entered)
	animated_sprite.play()

func _process(delta: float) -> void:
	time_alive += delta
	move_enemy(delta)
	move_and_slide()

# Override this in subclasses for different movement patterns
func move_enemy(_delta: float) -> void:
	velocity.y = base_speed

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	enemy_defeated.emit(enemy_score)
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is FriendlyWeapon:
		print_debug(health, " area.dmg ", area.damage)
		take_damage(area.damage)
		print_debug("after", health, " area.dmg ", area.damage)


func enemy_lands() -> void:
	enemy_landed.emit(max_health)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is AnimatableBody2D:
		enemy_lands()
