extends Enemy
class_name ShooterEnemy

# Enemy that shoots down projectiles

@export var shoot_rate: float = 1.5
@export var shoot_offset: Vector2 = Vector2(0, 20)
@export var projectile: Area2D


var shoot_timer: float = 0.0

func _ready() -> void:
	max_health = 25
	health = max_health
	enemy_score = 150
	base_speed = 25
	$EnemyProjectile.disable_mode = true
	super()

func move_enemy(_delta: float) -> void:
	velocity.y = base_speed

func _process(delta: float) -> void:
	time_alive += delta
	move_enemy(delta)
	move_and_slide()
	
	# Shooting logic
	shoot_timer += delta
	if shoot_timer >= shoot_rate:
		shoot_timer = 0.0
		shoot()

func shoot() -> void:
	if projectile == null:
		return
	
	var newProjectile = projectile.duplicate()
	newProjectile.position = global_position + shoot_offset
	newProjectile.disable_mode = false
	get_parent().add_child(newProjectile)
	
	# Play animation if it has AnimatedSprite2D
	if newProjectile.has_node("AnimatedSprite2D"):
		newProjectile.get_node("AnimatedSprite2D").play()
