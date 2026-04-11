extends CharacterBody2D
class_name Enemy
@onready var hit_sound = $HitSound

@export var hitbox: Area2D
@export var max_health: float = 15
@export var enemy_score: int = 100
@export var base_speed: float = 30
@export var animated_sprite: AnimatedSprite2D
@export var buff_aura: Sprite2D

var health: float
var time_alive: float = 0.0

var hit_sfx = preload("res://assets/sound/hitHurt.wav")
var death_sfx = preload("res://assets/sound/explosion.wav")

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
	
	if hit_sound: #Memanggil sound
		hit_sound.stream = hit_sfx
		hit_sound.pitch_scale = randf_range(0.9, 1.1) # biar variatif
		hit_sound.play()
		
	if health <= 0:
		die()

func die() -> void:
	if hit_sound:
		hit_sound.stream = death_sfx
		hit_sound.play()
		#await hit_sound.finished
		
	enemy_defeated.emit(enemy_score)
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is FriendlyWeapon:
		# print_debug(health, " area.dmg ", area.damage)
		take_damage(area.damage)
		# print_debug("after", health, " area.dmg ", area.damage)


func enemy_lands() -> void:
	enemy_landed.emit(max_health)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is AnimatableBody2D:
		enemy_lands()
